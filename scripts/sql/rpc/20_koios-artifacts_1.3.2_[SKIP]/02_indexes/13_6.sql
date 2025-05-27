CREATE INDEX IF NOT EXISTS idx_address_address ON address USING hash (address);
CREATE INDEX IF NOT EXISTS idx_tx_out_stake_address_id ON tx_out (stake_address_id);
CREATE INDEX IF NOT EXISTS idx_tx_out_address_id ON tx_out (address_id);
CREATE INDEX IF NOT EXISTS idx_address_stake_address_id ON address (stake_address_id);
CREATE INDEX IF NOT EXISTS idx_voting_procedure_tx_id ON voting_procedure (tx_id DESC);
CREATE INDEX IF NOT EXISTS idx_voting_procedure_voting_anchor_id ON voting_procedure (voting_anchor_id);


-- /scripts/sql/rpc/20_koios-artifacts_1.3.2/z_02_indexes/13_6.sql: ERROR:  relation "address" does not exist
-- NOTICE:  relation "idx_tx_out_stake_address_id" already exists, skipping
-- ERROR:  column "address_id" does not exist
-- ERROR:  relation "address" does not exist
-- NOTICE:  relation "idx_voting_procedure_tx_id" already exists, skipping
-- NOTICE:  relation "idx_voting_procedure_voting_anchor_id" already exists, skipping
