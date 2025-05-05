#!/usr/bin/env bash
set -uo pipefail
source "../../.env"

RUN_MODE="${1:-run}"

COOLDOWN_SECS=1
DEFAULT_GET_HEADERS="-H accept:application/json"
DEFAULT_POST_HEADERS="-H accept:application/json -H 'content-type: application/json'"

TESTING_KOIOS_URL="https://127.0.0.1:${HAPROXY_PORT}/koios/"
RECEIVED_DIR="./results/${NETWORK}/received/"
EXPECTED_DIR="./results/${NETWORK}/expected/"
REPORT_DIR="./results/${NETWORK}/"

source "./${NETWORK}.sh" # OFFICIAL_KOIOS_URL, TEST_CASES and default headers overrides defined here

# Utility: Read content of a file if it exists
loadFile() {
  local filePath="$1"
  if [[ -f "$filePath" ]]; then
    cat "$filePath"
  else
    echo ""
  fi
}

# Utility: Write content to a file
saveFile() {
  local filePath="$1"
  local content="$2"
  echo "$content" > "$filePath"
}

# Run or show command based on template
run_test() {
  local do_run="$1"
  local tmpl="$2"
  local api_url="$3"

  local cmd="${tmpl//%%API_URL%%/$api_url}"
  cmd="${cmd//%%DEFAULT_GET_HEADERS%%/$DEFAULT_GET_HEADERS}"
  cmd="${cmd//%%DEFAULT_POST_HEADERS%%/$DEFAULT_POST_HEADERS}"

  if [[ "$do_run" == "showCmd" ]]; then
    echo "$cmd"
  else
    eval "$cmd"
  fi
}

trim() {
  local var="$*"
  # Remove leading and trailing whitespace using parameter expansion
  var="${var#"${var%%[![:space:]]*}"}"
  var="${var%"${var##*[![:space:]]}"}"
  echo -n "$var"
}

try_jq() {
  local input="$1"
  echo "$input" | jq -S . 2>/dev/null || echo "$input"
}

# Main test loop
run_tests() {
  local idx=0
  local failures=0
  local successes=0

  mkdir -p "$RECEIVED_DIR"
  mkdir -p "$EXPECTED_DIR"

  for entry in "${TEST_CASES[@]}"; do
    ((idx++))
    IFS='|' read -r name tmpl <<<"$entry"
    IFS='|' read -r raw_name raw_tmpl <<<"$entry"

    name=$(trim "$raw_name")
    tmpl=$(trim "$raw_tmpl")
    
    extension='json'
    
    echo -e "\n=== Test #$idx: $name ==="
    if [[ "$RUN_MODE" == "run" ]]; then
      echo "CMD for Received: $(run_test showCmd "$tmpl" "$TESTING_KOIOS_URL")"
      echo "CMD for Expected: $(run_test showCmd "$tmpl" "$OFFICIAL_KOIOS_URL")"
    fi


    local received_file="${RECEIVED_DIR}${name}.${extension}"
    local expected_file="${EXPECTED_DIR}${name}.${extension}"

    local _received _expected
    _received=$(loadFile "$received_file")
    _expected=$(loadFile "$expected_file")

    if [[ -n "$_received" && -n "$_expected" ]] && diff <(echo "$_received") <(echo "$_expected") >/dev/null; then
      echo "✅ PASSED (cache)"
      ((successes++))
      continue
    fi

    if [[ "$RUN_MODE" == "report" ]]; then
      echo "❌ FAILED (cache)"
      ((failures++)) 
      continue
    fi

    # local received
    # received=$(run_test run "$tmpl" "$TESTING_KOIOS_URL" | jq -S .)
    # saveFile "$received_file" "$received"
    received_raw=$(run_test run "$tmpl" "$TESTING_KOIOS_URL")
    received=$(try_jq "$received_raw")
    saveFile "$RECEIVED_DIR$name.$extension" "$received"

    sleep "$COOLDOWN_SECS"

    # local expected
    # expected=$(run_test run "$tmpl" "$OFFICIAL_KOIOS_URL" | jq -S .)
    # saveFile "$expected_file" "$expected"

    expected_raw=$(run_test run "$tmpl" "$OFFICIAL_KOIOS_URL")
    expected=$(try_jq "$expected_raw")
    saveFile "$EXPECTED_DIR$name.$extension" "$expected"

    if [[ -n "$expected" ]] && diff <(echo "$received") <(echo "$expected") >/dev/null; then
      echo "✅ PASSED"
      ((successes++))
    else
      echo "❌ FAILED: $name"
      echo "--- RECEIVED ---"
      echo "$received"
      echo
      echo "--- EXPECTED ---"
      echo "$expected"
      ((failures++))
    fi

    sleep "$COOLDOWN_SECS"
  done

  local total=$((successes + failures))

  echo -e "\n=== Summary ==="
  echo -e "Ran $total test(s) on $NETWORK network"
  if [[ $failures -eq 0 ]]; then
    echo "✅ All $successes/$total test(s) passed 🎉"
  else
    echo "❌ $failures/$total test(s) failed"
  fi
  echo -e "\nAll done."
}

if [[ "$RUN_MODE" == "report" ]]; then
  run_tests | tee "${REPORT_DIR}report.txt"
else 
  run_tests
fi