
source "../../.env"

./tests.sh run ${NETWORK} 'https://127.0.0.1:${HAPROXY_PORT}/blockfrost/api/v0' 2>&1 | tee "${NETWORK}.report"