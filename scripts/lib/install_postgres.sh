#!/bin/bash

# Set the working directory to the directory containing the rpc folder
cd /scripts/sql/rpc

# Files to log successful and unsuccessful executions
OK_FILE="Ok.txt"
NOT_OK_FILE="NotOk.txt"
SKIPPED_FILE="Skipped.txt"

# Empty the log files if they already exist
> "$OK_FILE"
> "$NOT_OK_FILE"

# Loop through all .sql files in the rpc folder and its subfolders
find /scripts/sql/rpc -name '*.sql' | sort | while read -r sql_file; do
  
  # Skip sql files that contain on their path the substring "[SKIP]"
  if [[ $sql_file == *"[SKIP]"* ]]; then
    echo "Skipped: '$sql_file'"
    echo "$sql_file" >> "$SKIPPED_FILE"
    continue
  fi  

  echo "Processing '$sql_file'..."

  # Create a temporary SQL file
  TEMP_SQL_FILE="temp_$(basename "$sql_file")"
  
  # Create a temporal copy of source file
  cp "$sql_file" "$TEMP_SQL_FILE"
  


  # Variable placeholders for Koios
  if [[ $sql_file == *"_koios-artifacts"* ]]; then    
    # Replace the placeholder with the actual schema name
    sed -i.bak1 "s/grest/$KOIOS_ARTIFACTS_SCHEMA/g" "$TEMP_SQL_FILE"
    sed -i.bak1 "s/GREST/$KOIOS_ARTIFACTS_SCHEMA/g" "$TEMP_SQL_FILE"
    echo "  'koios-artifacts' variables applied"
  fi  
  # Variable placeholders for Koios Lite
  if [[ $sql_file == *"_koios-lite"* ]]; then    
    # Replace the placeholder with the actual schema name
    sed -i.bak2 "s/{{SCHEMA}}/$KOIOS_LITE_SCHEMA/g" "$TEMP_SQL_FILE"   
    echo "  'koios-lite' variables applied"
  fi   
  # Variable placeholders for Dandelion Postgrest
  if [[ $sql_file == *"_dandelion-postgrest"* ]]; then    
    # Replace the placeholder with the actual schema name
    sed -i.bak3 "s/{{DANDELION_POSTGREST_SCHEMA}}/$DANDELION_POSTGREST_SCHEMA/g" "$TEMP_SQL_FILE"   
    echo "  'koios-lite' variables applied"
  fi     


  # Execute the SQL file and capture the output
  SQL_OUTPUT=$(psql -qt -d "${POSTGRES_DB}" -U "${POSTGRES_USER}" --host="${POSTGRES_HOST}" < "$TEMP_SQL_FILE" 2>&1)

  # Check for "ERROR:" in the SQL output
  if echo "$SQL_OUTPUT" | grep -q "ERROR:"; then
    # If error is found, append the file name to NotOk.txt
    echo "$sql_file: ${SQL_OUTPUT}" >> "$NOT_OK_FILE"
  else
    # If no error, append the file name to Ok.txt
    echo "$sql_file" >> "$OK_FILE"
  fi

  # Remove the temporary file
  #echo "$TEMP_SQL_FILE"
  rm "$TEMP_SQL_FILE"
  rm -f *.bak1
  rm -f *.bak2
  rm -f *.bak3
done

psql -qt -d "${POSTGRES_DB}" -U "${POSTGRES_USER}" --host="${POSTGRES_HOST}" -c "NOTIFY pgrst, 'reload schema'" >/dev/null

# echo "Execution complete. Check $OK_FILE and $NOT_OK_FILE for results."
echo -e "SQL scripts have finished processing, following scripts were executed successfully:\n"
cat /scripts/sql/rpc/Ok.txt
echo -e "\n\nThe following errors were encountered during processing:\n"
cat /scripts/sql/rpc/NotOk.txt
