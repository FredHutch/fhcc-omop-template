"""
Copy CSVs saved in bundle files with custom defined OMOP vocabuary to Unity Catalog tables
"""

# Load libraries
import os
from pyspark.sql import SparkSession
import argparse
import pandas as pd
import sys
import pyarrow as pa

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
    parser.add_argument("--omop_vocab_schema")
    parser.add_argument("--omop_schema")
    parser.add_argument("--omop_intermediate_schema")
    parser.add_argument("--path")

    # Parse the aguments
    args = parser.parse_args()

    # Return the parsed arguments
    return args

def csv_to_table(csv_path, catalog, schema, schema_reference, table, table_reference, spark_session):
    """
    # Load data from the provided filed path into the table at the specified Unity Catalog path

    Parameters
    ----------
    csv_path: path where the CSV file is saved
    catalog: catalog for table to update
    schema: schema for table to update
    schema_reference: schema where the main OMOP tables are saved to use for the table schema reference
    table: name of table to update
    table_reference: name of table to use for the table schema reference

    Returns
    -------
    args: argparse.Namespace
        Parsed arguments
    """

    # Define target Delta Table details in Unity Catalog
    target_table = f"{catalog}.{schema}.{table}"

    # Read the CSV file using pandas since on serverless/shared compute, Spark's file reader enforces 
    # Unity Catalog access control and requires the SELECT on ANY FILE privilege to read arbitrary file paths
    try:
        raw_table = pd.read_csv(csv_path
                            # Read in dates as string for better conversion later
                            , dtype={"valid_start_date": "str"
                                     , "valid_end_date": "str"}
                            # , parse_dates=["valid_start_date", "valid_end_date"]
                            # , date_format="%Y%m%d"
                         ).reset_index(drop=True).copy()
    # Terminiate if an expection is encountered
    except (pd.errors.ParserError, pd.errors.EmptyDataError, FileNotFoundError, UnicodeDecodeError) as e:
        print(f"Error loading CSV for table {target_table} at {csv_path}. Error: {e}")
        sys.exit(1)

    # Convert vocabulary date columns from string (YYYYMMDD) to datetime.date for schema compatibility
    for col in ["valid_start_date", "valid_end_date"]:
        if col in raw_table.columns:
            raw_table[col] = pd.to_datetime(raw_table[col], format="%Y%m%d", errors="coerce").dt.date

    # Convert visit mapping date columns from string (MM/DD/YY) to datetime.date for schema compatibility
    for col in ["effective_start_date", "effective_end_date", "last_reviewed_date"]:
        if col in raw_table.columns:
            raw_table[col] = pd.to_datetime(raw_table[col], format="%m/%d/%y", errors="coerce").dt.date

    # Force single-chunk arrays explicitly.
    # Without this there were errors with the arrow-mediated type coercion to utilizing the 
    # defined schema since there was a ChunkedArray where a flat Array was expected.
    arrow_table = pa.Table.from_pandas(raw_table, preserve_index=False)
    arrow_table = arrow_table.combine_chunks()

    # Get the schema to utilize
    existing_schema = spark_session.table(f"{catalog}.{schema_reference}.{table_reference}").schema

    # Save the data into a PySpark DataFrame
    df = spark_session.createDataFrame(arrow_table, schema = existing_schema)

    # Write to Delta Table, either overwriting or creating table if it doesn't exist
    df.write.format("delta").mode("overwrite").option(
        "overwriteSchema", "true"
    ).saveAsTable(target_table)

    print(f"Successfully loaded {csv_path} into {target_table}.")

def main():
    """
    # Parse arugments, start spark session, get path for CSVs, and load CSVs into tables

    Parameters
    ----------
    none

    Returns
    -------
    none

    """

    # Parse the arguments
    parsed_args = parse_args()

    # Start Spark session
    spark = SparkSession.builder.getOrCreate()

    # Get the relative path to the CSV deployed in the Workspace file system
    current_dir = os.path.dirname(parsed_args.path)
    
    for table in ["concept", "concept_relationship", "vocabulary", "concept_class"]:
        csv_to_table(
            csv_path = current_dir + "/files/vocabulary/custom/" + table + ".csv",
            catalog = parsed_args.omop_catalog,
            schema = parsed_args.omop_vocab_schema,
            schema_reference = parsed_args.omop_schema,
            table = 'custom_' + table,
            table_reference = table,
            spark_session = spark
        )

    for table in ["department_groups", "visit_mapping_rules"]:
        csv_to_table(
            csv_path = current_dir + "/files/vocabulary/visit_mapping_rules/" + table + ".csv",
            catalog = parsed_args.omop_catalog,
            schema = parsed_args.omop_intermediate_schema,
            schema_reference = parsed_args.omop_intermediate_schema,
            table = table,
            table_reference = table,
            spark_session = spark
        )

# Run main function
if __name__ == "__main__":
    main()
