#!/usr/bin/env bash
set -uo pipefail
source "../../.env"

OFFICIAL_KOIOS_URL="https://preprod.koios.rest/"
TESTING_KOIOS_URL="https://127.0.0.1:${HAPROXY_PORT}/koios/"
COOLDOWN_SECS=5
DEFAULT_HEADERS="-H accept:application/json"

TEST_CASES=(
  "curl -skX GET %%API_URL%%api/v1/tip %%DEFAULT_HEADERS%%"
  # "curl -skX GET %%API_URL%%api/v1/genesis %%DEFAULT_HEADERS%%"
  # "curl -skX GET %%API_URL%%api/v1/totals?_epoch_no=166 %%DEFAULT_HEADERS%%"
  "curl -skX POST %%API_URL%%api/v1/address_info %%DEFAULT_HEADERS%% -H content-type:application/json -d '{\"_addresses\":[\"addr_test1vzpwq95z3xyum8vqndgdd9mdnmafh3djcxnc6jemlgdmswcve6tkw\",\"addr_test1vpfwv0ezc5g8a4mkku8hhy3y3vp92t7s3ul8g778g5yegsgalc6gc\"]}'"
)

run_test() {
  local do_run="$1"
  local tmpl="$2"
  local api_url="$3"

  local cmd="${tmpl//%%API_URL%%/$api_url}"
  cmd="${cmd//%%DEFAULT_HEADERS%%/$DEFAULT_HEADERS}"

  if [[ "$do_run" == "showCmd" ]]; then
    echo "$cmd"
  else
    eval "$cmd"
  fi
}

run_tests() {
  local idx=0
  local failures=0

  for tmpl in "${TEST_CASES[@]}"; do
    ((idx++))
    echo -e "\n=== Test #$idx ==="
    echo "CMD for Received: $(run_test showCmd "$tmpl" "$TESTING_KOIOS_URL")"
    echo "CMD for Expected: $(run_test showCmd "$tmpl" "$OFFICIAL_KOIOS_URL")"

    local received
    received=$(run_test run "$tmpl" "$TESTING_KOIOS_URL" | jq -S .)
    sleep "$COOLDOWN_SECS"
    local expected
    expected=$(run_test run "$tmpl" "$OFFICIAL_KOIOS_URL" | jq -S .)

    if diff <(echo "$received") <(echo "$expected") >/dev/null; then
      echo "✅ PASSED"
    else
      echo "❌ FAILED"
      echo "--- RECEIVED ---"
      echo "$received"
      echo
      echo "--- EXPECTED ---"
      echo "$expected"
      ((failures++))
    fi

    sleep "$COOLDOWN_SECS"
  done

  echo -e "\n=== Summary ==="
  if [[ $failures -eq 0 ]]; then
    echo "All tests passed 🎉"
  else
    echo "$failures test(s) failed ❌"    
  fi
  echo -e "\nAll done."

}

run_tests
