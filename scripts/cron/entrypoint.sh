#!/bin/sh

# Load the specific crontab file
crontab /etc/cron.d/koios-lite/init_koios_lite_cron
crontab /etc/cron.d/koios-artifacts/init_koios_artifacts_cron
crontab /etc/cron.d/dbless-cardano-token-registry/init_dbless_cardano_token_registry_cron

# Start the cron daemon
exec crond -f -d 8
