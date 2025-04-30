#!/usr/bin/env bash

set -uo pipefail
source "../../.env"

OFFICIAL_KOIOS_URL="https://preprod.koios.rest/"
TESTING_KOIOS_URL="https://127.0.0.1:${HAPROXY_PORT}/koios/"
COOLDOWN_SECS=5

# Default headers (space-separated)
# Example:
#DEFAULT_HEADERS=("accept: application/json" "encoding: utf8")
# Default headers if none supplied:
DEFAULT_HEADERS=("Accept: application/json")

# Populate TEST_CASES with METHOD|ENDPOINT|QUERY|HEADERS|BODY
TEST_CASES=(
  ## Network Test Cases
  "GET|api/v1/tip||Accept: application/json|"
  "GET|api/v1/genesis||Accept: application/json|"
  "GET|api/v1/totals|_epoch_no=166|Accept: application/json|"

  ## Epoch-Related Test Cases
  "GET|api/v1/epoch_info|_epoch_no=166|Accept: application/json|"
  "GET|api/v1/epoch_params|_epoch_no=166|Accept: application/json|"

  ## Block-Related Test Cases
  "GET|api/v1/blocks|_limit=10|Accept: application/json|"
  "POST|api/v1/block_info|||{\"_block_hashes\":[\"block_hash1\"]}"
  "GET|api/v1/block_txs|_block_hash=block_hash1|Accept: application/json|"

  ## Transaction-Related Test Cases
  "POST|api/v1/tx_info|||{\"_tx_hashes\":[\"8ae88d7ee59eda5a7a95dd66e9cf123a89758f2ec31e73a5c65b4d9cf312f71c\"]}"
  "POST|api/v1/tx_utxos|||{\"_tx_hashes\":[\"8ae88d7ee59eda5a7a95dd66e9cf123a89758f2ec31e73a5c65b4d9cf312f71c\"]}"
  "POST|api/v1/tx_metadata|||{\"_tx_hashes\":[\"8ae88d7ee59eda5a7a95dd66e9cf123a89758f2ec31e73a5c65b4d9cf312f71c\"]}"
  "GET|api/v1/tx_metalabels|||"
  "POST|api/v1/submittx|||{\"_signed_tx\":\"signed_tx_data\"}"
  "POST|api/v1/tx_status|||{\"_tx_hashes\":[\"8ae88d7ee59eda5a7a95dd66e9cf123a89758f2ec31e73a5c65b4d9cf312f71c\"]}"

  ## Address-Related Test Cases
  "POST|api/v1/address_info|||{\"_addresses\":[\"addr_test1vzpwq95z3xyum8vqndgdd9mdnmafh3djcxnc6jemlgdmswcve6tkw\",\"addr_test1vpfwv0ezc5g8a4mkku8hhy3y3vp92t7s3ul8g778g5yegsgalc6gc\"]}"
  "GET|api/v1/address_txs|_address=addr_test1vzpwq95z3xyum8vqndgdd9mdnmafh3djcxnc6jemlgdmswcve6tkw|Accept: application/json|"
  "GET|api/v1/address_assets|_address=addr_test1vzpwq95z3xyum8vqndgdd9mdnmafh3djcxnc6jemlgdmswcve6tkw|Accept: application/json|"
  "GET|api/v1/credential_txs|_payment_credential=cred1|Accept: application/json|"

  ## Stake Account-Related Test Cases
  "GET|api/v1/account_list|||"
  "POST|api/v1/account_info|||{\"_stake_addresses\":[\"stake_test1uzpwq95z3xyum8vqndgdd9mdnmafh3djcxnc6jemlgdmswcve6tkw\"]}"
  "POST|api/v1/account_rewards|||{\"_stake_addresses\":[\"stake_test1uzpwq95z3xyum8vqndgdd9mdnmafh3djcxnc6jemlgdmswcve6tkw\"]}"
  "POST|api/v1/account_updates|||{\"_stake_addresses\":[\"stake_test1uzpwq95z3xyum8vqndgdd9mdnmafh3djcxnc6jemlgdmswcve6tkw\"]}"
  "POST|api/v1/account_addresses|||{\"_stake_addresses\":[\"stake_test1uzpwq95z3xyum8vqndgdd9mdnmafh3djcxnc6jemlgdmswcve6tkw\"]}"
  "POST|api/v1/account_assets|||{\"_stake_addresses\":[\"stake_test1uzpwq95z3xyum8vqndgdd9mdnmafh3djcxnc6jemlgdmswcve6tkw\"]}"
  "POST|api/v1/account_history|||{\"_stake_addresses\":[\"stake_test1uzpwq95z3xyum8vqndgdd9mdnmafh3djcxnc6jemlgdmswcve6tkw\"]}"

  ## Asset-Related Test Cases
  "GET|api/v1/asset_list|||"
  "GET|api/v1/asset_address_list|_asset_policy=policy_id|Accept: application/json|"
  "GET|api/v1/asset_info|_asset_policy=policy_id&_asset_name=asset_name|Accept: application/json|"
  "GET|api/v1/asset_summary|_asset_policy=policy_id&_asset_name=asset_name|Accept: application/json|"
  "GET|api/v1/asset_txs|_asset_policy=policy_id&_asset_name=asset_name|Accept: application/json|"

  ## Pool-Related Test Cases
  "GET|api/v1/pool_list|||"
  "POST|api/v1/pool_info|||{\"_pool_bech32_ids\":[\"pool1jdhjfcu34lq88rypdtslzwyf27uh0h3apcr9mjd68zhc69r29fy\"]}"
  "GET|api/v1/pool_delegators|_pool_bech32=pool1jdhjfcu34lq88rypdtslzwyf27uh0h3apcr9mjd68zhc69r29fy|Accept: application/json|"
  "GET|api/v1/pool_blocks|_pool_bech32=pool1jdhjfcu34lq88rypdtslzwyf27uh0h3apcr9mjd68zhc69r29fy|Accept: application/json|"
  "GET|api/v1/pool_updates|_pool_bech32=pool1jdhjfcu34lq88rypdtslzwyf27uh0h3apcr9mjd68zhc69r29fy|Accept: application/json|"
  "GET|api/v1/pool_relays|||"
  "GET|api/v1/pool_metadata|_pool_bech32=pool1jdhjfcu34lq88rypdtslzwyf27uh0h3apcr9mjd68zhc69r29fy|Accept: application/json|"

  ## Script-Related Test Cases
  "GET|api/v1/script_list|||"
  "GET|api/v1/script_redeemers|_script_hash=script_hash|Accept: application/json|"
)


# Function to build curl -H arguments from header strings
build_headers() {
  local header_array=()
  for h in "$@"; do
    header_array+=(-H "$h")
  done
  echo "${header_array[@]}"
}

# Function to fetch data from an endpoint, with optional body
fetch_data() {
  local method="$1"
  local base_url="$2"
  local path="$3"
  local query="$4"
  local body="$5"
  shift 5
  local headers=("$@")

  local url="${base_url}${path}"
  if [[ -n "$query" ]]; then
    url="${url}?${query}"
  fi

  # Build the curl command
  local args=(-skX "${method}" "$url")
  # Add headers
  args+=("${headers[@]}")

  # Add body if provided
  if [[ -n "$body" ]]; then
    args+=(-H "Content-Type: application/json")
    args+=(-d "${body}")
  fi

  curl "${args[@]}"
}

# Run test cases
run_tests() {
  local failures=0

  for case in "${TEST_CASES[@]}"; do
    # Unpack all five fields
    IFS='|' read -r method endpoint query raw_headers body <<< "$case"
    echo -e "\n=== Testing ${endpoint}${query:+?}${query} ==="

    # Determine headers: use custom if set, otherwise default
    IFS=' ' read -r -a HEADERS <<< "${raw_headers:-}"
    if [[ ${#HEADERS[@]} -eq 0 ]]; then
      HEADERS=("${DEFAULT_HEADERS[@]}")
    fi

    # Build curl-ready header args
    read -r -a HEADER_ARGS <<< "$(build_headers "${HEADERS[@]}")"

    # Make requests (pass body as the 5th positional argument)
    RECEIVED=$(fetch_data \
      "$method" \
      "$TESTING_KOIOS_URL" \
      "$endpoint" \
      "$query" \
      "$body" \
      "${HEADER_ARGS[@]}" \
    | jq -S .)

    EXPECTED=$(fetch_data \
      "$method" \
      "$OFFICIAL_KOIOS_URL" \
      "$endpoint" \
      "$query" \
      "$body" \
      "${HEADER_ARGS[@]}" \
    | jq -S .)

    # Compare
    if diff <(echo "$RECEIVED") <(echo "$EXPECTED") > /dev/null; then
      echo "✅ PASSED"
    else
      echo "❌ FAILED: Difference detected"
      echo "--- RECEIVED ---"
      echo "$RECEIVED"
      echo
      echo "--- EXPECTED ---"
      echo "$EXPECTED"
      echo
      ((failures++))
    fi

    # Pause to avoid rate limits
    sleep "${COOLDOWN_SECS:-1}"
  done

  echo -e "\n=== Summary ==="
  if [[ $failures -eq 0 ]]; then
    echo "All tests passed 🎉"
  else
    echo "$failures test(s) failed ❌"
    exit 1
  fi
}


run_tests
