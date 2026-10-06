"""
Run DQX checks defined in .yml files on OMOP tables 
"""

# Load libraries
from pyspark.sql import SparkSession
import yaml
import argparse
import logging
import sys
import databricks.labs.dqx.engine
from databricks.labs.dqx.engine import DQEngine
from databricks.labs.dqx.metrics_observer import DQMetricsObserver
from databricks.sdk import WorkspaceClient
from datetime import datetime
from pyspark.sql.types import StructType, StructField, StringType, IntegerType, TimestampType
from pyspark.sql import functions as F


def parse_args():
    """
    # Process the passed arguments

    Parameters
    ----------
    none

    Returns
    -------
    args: argparse.Namespace
        Parsed arguments
    """

    # Define the parser
    parser = argparse.ArgumentParser()

    # Add the arguments
    parser.add_argument("--omop_catalog")
    parser.add_argument("--omop_schema")
    parser.add_argument("--omop_monitoring_schema")
    parser.add_argument("--path")

    # Parse the aguments
    args = parser.parse_args()

    # Return the parsed arguments
    return args


def read_checks(bundle_path: StringType
                , tables_to_check_path: StringType):
    """
    # Read in the yaml file defining the tables to check at the location of the corresponding checks yamls files

    Parameters
    ----------
    bundle_path : StringType
        File path to the bundle where all the check yaml files are saved.
    tables_to_check_path : StringType
        File path within bundle_path to the yaml file defining the tables and files path with checks.

    Returns
    -------
    all_tables_dict: Dictonary
        Dictionary of the name of the table to check and the path to the file where the checks are defined
    """

    # Load the yaml file defining all the required checks for this table
    try:
        # Use a context manager ('with' statement) to ensure the file is closed automatically
        with open(bundle_path + tables_to_check_path, 'r') as file:
            # Load the YAML content safely into a Python dictionary
            all_tables_dict = yaml.safe_load(file)
    # Terminiate if an expection is encountered
    except FileNotFoundError:
        logging.warning(f"Error: The YAML file defining all tables to be checked {bundle_path + tables_to_check_path} was not found.")
        sys.exit(1)
    except yaml.YAMLError as e:
        logging.warning(f"Error parsing YAML file defining all tables to be checked {bundle_path + tables_to_check_path}: {e}")
        sys.exit(1)

    return(all_tables_dict)


def run_dqx_checks(omop_catalog: StringType
                   , omop_schema: StringType
                   , omop_monitoring_schema: StringType
                   , tables_to_check: dict
                   , bundle_path: StringType):
    """
    Implement data validation checks on OMOP tables using DQX, and save quarantined records and metrics summary

    Parameters
    ----------
    omop_catalog : StringType
        OMOP catalog in Databricks
    omop_schema : StringType
        OMOP schema in Databricks where the tables to check are found
    omop_monitoring_schema : StringType
        OMOP monitoring schema in Databricks where the monitoring tables are updated
    tables_to_check : dict
        Dictionary listing all tables (within {omop_catalog}.{omop_schema}) to run checks 
        on and the corresponding YML file, located within {path} where the checks for that 
        table are defined.
    bundle_path : StringType
        File path to the bundle where all the check yaml files are saved.

    Returns
    -------
    None
    """

    #####################
    # Set up the DQX session

    observer = DQMetricsObserver(name="dq_metrics")
    ws = WorkspaceClient()  # auto-authenticated inside Databricks
    dq_engine = DQEngine(ws, observer=observer)

    #####################
    # For each table, load the checks and table, implement the checks, and save quarantined records and metrics summary
    for table, file_path in tables_to_check.items():

        # Load the yaml file defining all the required checks for this table
        try:
            # Use a context manager ('with' statement) to ensure the file is closed automatically
            with open(bundle_path + file_path, 'r') as file:
                # Load the YAML content safely into a Python dictionary
                checks = yaml.safe_load(file)
        except FileNotFoundError:
            logging.warning(f"Error: The file {bundle_path + file_path} was not found.")
            continue   # skip the rest of this iteration
        except yaml.YAMLError as e:
            logging.warning(f"Error parsing YAML file {bundle_path + file_path}: {e}")
            continue   # skip the rest of this iteration

        # Load the OMOP table
        df = spark.read.table(f"{omop_catalog}.{omop_schema}.{table}")

        # Apply checks
        valid_records, invalid_records, observation = dq_engine.apply_checks_by_metadata_and_split(df, checks)

        # Add column to invalid_records dataframe for current time
        invalid_records_save = invalid_records.withColumn("dqx_run_timestamp",F.lit(datetime.now()))

        # Save the invalid records to a table, adding to the table so all quarantined records over time are saved for further investigation
        invalid_records_save.write.insertInto(f"{omop_catalog}.{omop_monitoring_schema}.{table}_quarantine", overwrite=False)
        
        # Save the summary metrics to the dqx_metrics table, adding a row for the metrics for this table
        metrics = observation.get
        monitoring_data = [(omop_catalog
                            , omop_schema
                            , table
                            , datetime.now()
                            , metrics['input_row_count']
                            , metrics['error_row_count']
                            , metrics['warning_row_count']
                            , metrics['valid_row_count']
                        )]
        monitoring_schema = StructType([
            StructField("catalog", StringType(), False),
            StructField("schema", StringType(), False),
            StructField("table", StringType(), False),
            StructField("monitoring_timestamp", TimestampType(), False),
            StructField("input_row_count", IntegerType(), False),
            StructField("error_row_count", IntegerType(), False),
            StructField("warning_row_count", IntegerType(), False),
            StructField("valid_row_count", IntegerType(), False)
            ])
        monitoring_df = spark.createDataFrame(monitoring_data, schema=monitoring_schema)
        monitoring_df.write.insertInto(f"{omop_catalog}.{omop_monitoring_schema}.dqx_metrics", overwrite=False)


def main():
    """
    # Argument and file parsing and DQX checks

    Parameters
    ----------
    none

    Returns
    -------
    none

    """

    # Parse the arguments
    parsed_args = parse_args()

    # Get the dictionary for table and relevant .yml file path to run checks on
    all_tables_to_check = read_checks(bundle_path = parsed_args.path
                                    , tables_to_check_path = '/monitoring/omop_dqx_monitoring_tables.yml')

    # Run the checks
    run_dqx_checks(omop_catalog = parsed_args.omop_catalog
                    , omop_schema = parsed_args.omop_schema
                    , omop_monitoring_schema = parsed_args.omop_monitoring_schema
                    , tables_to_check = all_tables_to_check
                    , bundle_path = parsed_args.path)


# Run argument and file parsing and DQX checks when the file is executed directly, but not when it is imported
if __name__ == "__main__":
    main()