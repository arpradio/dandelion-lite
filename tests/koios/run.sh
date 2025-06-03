
source "../../.env"

./tests.sh run 2>&1 | tee "${NETWORK}.report"