# TODO:

Create based on sql migration files from latest cardano-graphql.

Here is an outdated example made for cardano-sql: 
- reset `scripts/sql/rpc/40_cardano-sql/misc/30_cardano_graphql_down_[SKIP].sql` (DON'T USE IF YOU ARE USING cardano-graphql)
- apply `scripts/sql/rpc/40_cardano-sql/30_cardano_graphql_[SKIP].sql`

Why? because Dandelion-PostGREST is affected by those sql scripts thanks to be using cardano-graphql. 

- If you are using cardano-graphql you don't need to apply those files. 
- If you don't use cardano-graphql and you want to replicate Dandelion PostGREST API, you need to apply those files.