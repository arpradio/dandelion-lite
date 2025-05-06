#!/bin/bash
DB_NAME=${POSTGRES_DB}

GENESIS_JSON="/config/cardano-node/shelley-genesis.json"
ALONZO_GENESIS_JSON="/config/cardano-node/alonzo-genesis.json"

# Based on https://github.com/cardano-community/guild-operators/blob/cd3657debc0b91f5fa6c679f78c6cb19de334616/scripts/grest-helper-scripts/setup-grest.sh#L264
# Description : Populate genesis table with given values.
insert_genesis_table_data() {
  local alonzo_genesis=$1
  shift
  local shelley_genesis=("$@")

  psql ${DB_NAME} -h ${POSTGRES_HOST} -c "INSERT INTO ${KOIOS_ARTIFACTS_SCHEMA}.genesis VALUES (
    '${shelley_genesis[4]}', '${shelley_genesis[2]}', '${shelley_genesis[0]}',
    '${shelley_genesis[1]}', '${shelley_genesis[3]}', '${shelley_genesis[5]}',
    '${shelley_genesis[6]}', '${shelley_genesis[7]}', '${shelley_genesis[8]}',
    '${shelley_genesis[9]}', '${shelley_genesis[10]}', '${alonzo_genesis}'
  );" > /dev/null
}

# Description : Read genesis values from node config files and populate grest.genesis table.
#             : Note: Given the Plutus schema is far from finalized, we expect changes as SC layer matures and PAB gets into real networks.
#             :       For now, a compressed jq will be inserted as a shell escaped json data blob.
populate_genesis_table() {
  read -ra SHGENESIS <<<$(jq -r '[
    .activeSlotsCoeff,
    .updateQuorum,
    .networkId,
    .maxLovelaceSupply,
    .networkMagic,
    .epochLength,
    .systemStart,
    .slotsPerKESPeriod,
    .slotLength,
    .maxKESEvolutions,
    .securityParam
    ] | @tsv' <"${GENESIS_JSON}")
  ALGENESIS="$(jq -c . <"${ALONZO_GENESIS_JSON}")"

  insert_genesis_table_data "${ALGENESIS}" "${SHGENESIS[@]}"
}


echo "$(date +%F_%H:%M:%S) Running Koios Initialization Job..."

if [[ "$(psql ${DB_NAME} -h ${POSTGRES_HOST} -Atq  -c "SELECT COUNT(*) FROM ${KOIOS_ARTIFACTS_SCHEMA}.genesis;")" -eq 0 ]]; then
  echo "Table '${KOIOS_ARTIFACTS_SCHEMA}.genesis' is empty, inserting genesis data..."
  populate_genesis_table
else
  echo "Table '${KOIOS_ARTIFACTS_SCHEMA}.genesis' already has data. Skipping insert."
fi


echo "Job done!"























echo "$(date +%F_%H:%M:%S) Job done!"
