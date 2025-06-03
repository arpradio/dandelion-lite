#!/bin/bash

echo "$(date +%F_%H:%M:%S) Running Dandelion Lite Initialization Job..."

# Setting CRON_DO_NOT_INITIALIZE to true on .env will disable this automatic initialization job
[[ "${CRON_DO_NOT_INITIALIZE}" == "true" ]] && echo "CRON_DO_NOT_INITIALIZE is true, aborting..." && exit 0
# [[ -z ${POSTGRES_DB} ]] && echo "POSTGRES_DB variable is not set, aborting..." && exit 1
# [[ -z ${POSTGRES_HOST} ]] && echo "POSTGRES_HOST variable is not set, aborting..." && exit 1

DB_NAME=${POSTGRES_DB}

# List of expected schemas
REQUIRED_SCHEMAS="${CRON_REQUIRED_SCHEMAS:-"${KOIOS_ARTIFACTS_SCHEMA},${DANDELION_POSTGREST_SCHEMA}"}"
SCHEMA_LIST=(${REQUIRED_SCHEMAS//,/ })

missing_schemas=()

for schema in "${SCHEMA_LIST[@]}"; do
  exists=$(psql "${DB_NAME}" -h "${POSTGRES_HOST}" -Atq -c "SELECT 1 FROM pg_namespace WHERE nspname = '${schema}' LIMIT 1;")
  if [[ -z "$exists" ]]; then
    missing_schemas+=("$schema")
  fi
done

if [[ ${#missing_schemas[@]} -eq 0 ]]; then
  echo "✅ All required schemas exist: '${REQUIRED_SCHEMAS}'. No need to run Initialize Postgres"
else
  echo "❌ Missing schemas: '${missing_schemas[*]}'. Let's run Initialize Postgres"
  cd /
  ./scripts/lib/install_postgres.sh
fi

echo "Job done!"



