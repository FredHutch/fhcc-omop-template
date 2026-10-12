# Map from the source-to-concept format Usagi exports into the concept and concept 
# relationship format needed for how we are implementing OMOP CDM v5.4

import pandas as pd
import csv
import here
from pathlib import Path

def append_custom_concepts(source_to_concept_file,
                           concept_file,
                           concept_relationship_file,
                           domain_id,
                           concept_class_id):
    """
    Append new custom concepts and the standard concepts they map to onto the concept and concept_relationship files
    
    source_to_concept_file: Path to file that maps source concepts to standard concepts, exported from Usagi
    concept_file: Path to file with custom concepts
    concept_relationship_file: Path to file with custom concept relationships
    domain_id: Domain for the concepts, based on OMOP CDM domain table
    concept_class_id: Domain for the concepts, based on OMOP CDM concept_class table
    """

    # read source to concept data exported from Usagi
    source_to_concept_data = pd.read_csv(source_to_concept_file,
                                         na_values = 'NaN')
                                         
    # Read in existing custom concept data to be able to determine concept_id to start from                                     
    current_concept_data = pd.read_csv(concept_file)
    
    # Add concept_id to be used in OMOP CDM
    start_concept_id = int(max(current_concept_data['concept_id']))+1
    source_to_concept_data['new_concept_id'] = range(start_concept_id, start_concept_id+len(source_to_concept_data), 1)
    
    # Create concept dataframe
    concept_data = pd.DataFrame({'concept_id': source_to_concept_data['new_concept_id'],
                                 'concept_name':source_to_concept_data['source_code_description'],
                                 'domain_id': domain_id,
                                 'vocabulary_id': source_to_concept_data['source_vocabulary_id'],
                                 'concept_class_id': concept_class_id,
                                 'standard_concept': None,
                                 'concept_code': source_to_concept_data['source_code'],
                                 'valid_start_date': 19700101,
                                 'valid_end_date': 20991231,
                                 'invalid_reason': source_to_concept_data['invalid_reason']
                                 })
    
    # create concept_relationship databframe based on matches between custom and standard concepts
    concept_relationship_data = pd.DataFrame()
    for index, row in source_to_concept_data.iterrows():
      if row['target_concept_id'] != 0:
        rows_add = pd.DataFrame({'concept_id_1': [row['new_concept_id'], row['target_concept_id']],
                                   'concept_id_2':	[row['target_concept_id'], row['new_concept_id']],
                                   'relationship_id':	['Maps to', 'Mapped from'],
                                   'valid_start_date': 19700101,
                                   'valid_end_date': 20991231,
                                   'invalid_reason': row['invalid_reason']
        })
        concept_relationship_data = pd.concat([concept_relationship_data, rows_add], ignore_index=True)
    
    # add new line indicator so the data written starts on a new line                         
    with open(concept_file, 'a') as f:
        f.write('\n') 
    with open(concept_relationship_file, 'a') as f:
        f.write('\n') 
    
    # Append the concept data
    concept_data.to_csv(concept_file, mode='a', header=False, index=False)
    
    # Append the concept relationship data
    concept_relationship_data.to_csv(concept_relationship_file, mode='a', header=False, index=False)
    

# Get the path to the repo where the custom vocabury files are saved
repo_path = here.get_calling_script_file_path()
    

# Run for race data    
append_custom_concepts(source_to_concept_file = repo_path + '/vocabulary/source_to_concept/usagi_epic_race_codes_source_to_concept.csv',
                       concept_file = repo_path + '/vocabulary/custom/concept.csv',
                       concept_relationship_file = repo_path + '/vocabulary/custom/concept_relationship.csv',
                       domain_id = 'Race',
                       concept_class_id = 'Race'
                       )
# Run for ethnicity data    
append_custom_concepts(source_to_concept_file = repo_path + '/vocabulary/source_to_concept/usagi_epic_ethnicity_codes_source_to_concept.csv',
                       concept_file = repo_path + '/vocabulary/custom/concept.csv',
                       concept_relationship_file = repo_path + '/vocabulary/custom/concept_relationship.csv',
                       domain_id = 'Ethnicity',
                       concept_class_id = 'Ethnicity'
                       )
# Run for country data
append_custom_concepts(source_to_concept_file = repo_path + '/vocabulary/source_to_concept/usagi_epic_country_codes_source_to_concept.csv',
                       concept_file = repo_path + '/vocabulary/custom/concept.csv',
                       concept_relationship_file = repo_path + '/vocabulary/custom/concept_relationship.csv',
                       domain_id = 'Geography',
                       concept_class_id = 'Geography'
                       )

# Run for discharged_to data
append_custom_concepts(source_to_concept_file = repo_path + '/vocabulary/source_to_concept/usagi_epic_discharged_to_source_to_concept.csv',
                       concept_file = repo_path + '/vocabulary/custom/concept.csv',
                       concept_relationship_file = repo_path + '/vocabulary/custom/concept_relationship.csv',
                       domain_id = 'Visit',
                       concept_class_id = 'Visit'
                       )

# Run for admin_route data
append_custom_concepts(source_to_concept_file = repo_path + '/vocabulary/source_to_concept/usagi_epic_admin_route_codes_source_to_concept.csv',
                       concept_file = repo_path + '/vocabulary/custom/concept.csv',
                       concept_relationship_file = repo_path + '/vocabulary/custom/concept_relationship.csv',
                       domain_id = 'Route',
                       concept_class_id = 'Route'
                       )

# Run for reference units data
append_custom_concepts(source_to_concept_file = repo_path + '/vocabulary/source_to_concept/usagi_epic_reference_units_source_to_concept.csv',
                       concept_file = repo_path + '/vocabulary/custom/concept.csv',
                       concept_relationship_file = repo_path + '/vocabulary/custom/concept_relationship.csv',
                       domain_id = 'Unit',
                       concept_class_id = 'Unit'
                       )

# Run for place of service
append_custom_concepts(source_to_concept_file = repo_path + '/vocabulary/source_to_concept/usagi_epic_place_of_service_source_to_concept.csv',
                       concept_file = repo_path + '/vocabulary/custom/concept.csv',
                       concept_relationship_file = repo_path + '/vocabulary/custom/concept_relationship.csv',
                       domain_id = 'Visit',
                       concept_class_id = 'Visit'
                       )

# Run for gender, mapping all sex_c values
append_custom_concepts(source_to_concept_file = repo_path + '/vocabulary/source_to_concept/usagi_epic_sex_c_codes_source_to_concept.csv',
                       concept_file = repo_path + '/vocabulary/custom/concept.csv',
                       concept_relationship_file = repo_path + '/vocabulary/custom/concept_relationship.csv',
                       domain_id = 'Gender',
                       concept_class_id = 'zc_sex'
                       )

# prov_type
append_custom_concepts(source_to_concept_file = repo_path + '/vocabulary/source_to_concept/usagi_epic_prov_type_source_to_concept.csv',
                       concept_file = repo_path + '/vocabulary/custom/concept.csv',
                       concept_relationship_file = repo_path + '/vocabulary/custom/concept_relationship.csv',
                       domain_id = 'Provider',
                       concept_class_id = 'Provider'
                       )

# Run for note type: ip_note_type_c 
append_custom_concepts(source_to_concept_file = repo_path + '/vocabulary/source_to_concept/usagi_epic_ip_note_type_c_source_to_concept.csv',
                       concept_file = repo_path + '/vocabulary/custom/concept.csv',
                       concept_relationship_file = repo_path + '/vocabulary/custom/concept_relationship.csv',
                       domain_id = 'Meas Value',
                       concept_class_id = 'zc_note_type_ip'
                       )

# Run for note type: note_type_c 
append_custom_concepts(source_to_concept_file = repo_path + '/vocabulary/source_to_concept/usagi_epic_note_type_c_source_to_concept.csv',
                       concept_file = repo_path + '/vocabulary/custom/concept.csv',
                       concept_relationship_file = repo_path + '/vocabulary/custom/concept_relationship.csv',
                       domain_id = 'Meas Value',
                       concept_class_id = 'zc_note_type'
                       )

# Run for note type: note_type_noadd_c 
append_custom_concepts(source_to_concept_file = repo_path + '/vocabulary/source_to_concept/usagi_epic_note_type_noadd_c_source_to_concept.csv',
                       concept_file = repo_path + '/vocabulary/custom/concept.csv',
                       concept_relationship_file = repo_path + '/vocabulary/custom/concept_relationship.csv',
                       domain_id = 'Meas Value',
                       concept_class_id = 'zc_note_type'
                       ) 
