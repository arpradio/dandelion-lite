# TODO:

Separate all Dandelion-Postgrest functions and views into an isolated postgres schema name, same design used on other services.

Right now these files are being applied into default schema, generally named `public`. These files should be applied under a different schema.

Use placeholders for schema name and run replacements from `scripts/lib/install_postgres.sh`

Also, make proper changes to Haproxy to inject this schema name in re-written headers 

