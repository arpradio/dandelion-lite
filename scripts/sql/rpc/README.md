# Postgres SQL customizations

## What's this?

A system that allows you to shape and add extra functionality to the bare-bone database populated by `cardano-db-sync`

The sql files in this directory are processed and applied to PostgresDB **recursively and in order**. 

This is done by `scripts/lib/install_postgres.sh`, which can be executed manually from `scripts/koios-lite.sh` on `Setup->Initialize Postgres` or from cron automatically. In both ways the script will be executed inside `postgress` container (PostgresDB service)

Running the `install_postgres.sh` script outside `postgress` container won't work. This is why to allow these replacements to take place, you must pass the target env-vars to the `postgress` environment variables in `docker-compose.yml`.

## Rules

File paths containing
- `[SKIP]` : are blacklisted, skipped from the workflow
- `_koios-lite`      : gets applied with these `placeholder:env-var` replacements
    - `{{SCHEMA}}:$KOIOS_LITE_SCHEMA`
- `_koios-artifacts` : gets applied with these `placeholder:env-var` replacements
    - `grest/$KOIOS_ARTIFACTS_SCHEMA`
    - `GREST/$KOIOS_ARTIFACTS_SCHEMA`
- `_dandelion-postgrest` : gets applied with these `placeholder:env-var` replacements
    `{{DANDELION_POSTGREST_SCHEMA}}:$DANDELION_POSTGREST_SCHEMA`

File names starting with numbered prefixes are for prioritizing the execution of some files before others as some of the files are required by others for a smooth setup without errors.

This extensible variable system allows you to easily update these external projects to their latest versions with minimal-to-none modifications, for easy "copy-paste" updates (test your updates!).

## Notes

Is adviced to test this always from zero: by restoring/droping `PostgresDb` database, starting containers again and run `Setup -> Initialize Postgres` on `koios-lite.sh` and fix errors based on the shown logs. 

Creating indexes by these sql files will take a while specially on an already indexed Cardano Mainnet database, this is normal. You can increase resources allocated for these tasks to speedup the process on `postgress` service, in `docker-compose.yaml` file, like `postgres -c maintenance_work_mem=1024MB  -c  max_parallel_maintenance_workers=4`

### Koios Artifacts

Update procedure for `scripts/sql/rpc/20_koios-artifacts`:
- Download and extract latest release from [koios artifacts](https://github.com/cardano-community/koios-artifacts/tags)
- copy `koios-artifacts-<VERSION>/files/grest/rpc` as `scripts/sql/rpc/20_koios-artifacts`
- This sub directory needs some file prioritization in order to work properly. Rename these directories and files this way: 
    - `/db-scripts` as  `/000_db-scripts`
    - `/db-scripts/reset_grest.sql` as `/000_db-scripts/01_reset_grest.sql`
    - `/account/account_info.sql` as `/account/01_account_info.sql`
    - `/pool/pool_delegators.sql` as `/pool/01_pool_delegators.sql`
- coment everything on `/000_db-scripts/01_reset_grest.sql` and only leave these uncomented:
    `DROP SCHEMA IF EXISTS grest CASCADE;` (commented lines are called on `basics.sql`)
- check for unexpected changes that require further actions.
