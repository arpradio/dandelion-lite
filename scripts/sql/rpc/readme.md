# Postgres SQL customizations

## What's this?

A system that allows you to shape and add extra functionality to the bare-bone database populated by `cardano-db-sync`

The sql files in this directory are processed and applied to PostgresDB **recursively and in order**. 

This is done by `scripts/lib/install_postgres.sh`, which can be executed manually from `scripts/koios-lite.sh` on `Setup->Initialize Postgres` or from cron automatically.

## Rules

File paths containing
- `[SKIP]` : are blacklisted, skipped from the workflow
- `_koios_lite`      : gets applied with these `placeholder:env-var` replacements
    - `{{SCHEMA}}:$KOIOS_LITE_SCHEMA`
- `_koios_artifacts` : gets applied with these `placeholder:env-var` replacements
    - `grest/$KOIOS_ARTIFACTS_SCHEMA`
    - `GREST/$KOIOS_ARTIFACTS_SCHEMA`

File names starting with numbered prefixes are for prioritizing the execution of some files before others as some of the files are required by others for a smooth setup without errors.

This extensible variable system allows you to easily update these external projects to their latest versions with minimal-to-none modifications, for easy copy-paste updates.

## Notes

### Koios Artifacts

This sub directory needs some file prioritization in order to work properly. Rename these files this way: 

- `/000_db-scripts`
- `/account/01_account_info.sql`
- `/pool/01_pool_delegators.sql`