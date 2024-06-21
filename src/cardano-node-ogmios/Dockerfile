ARG CARDANO_NODE_OGMIOS_IMAGE
FROM ${CARDANO_NODE_OGMIOS_IMAGE}

ADD jq /bin/
ADD healthcheck.sh /healthcheck.sh
RUN chmod +x /healthcheck.sh
