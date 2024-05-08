DROP FUNCTION IF EXISTS {{DANDELION_POSTGREST_SCHEMA}}.get_tx_history_for_addresses ;
CREATE OR REPLACE FUNCTION {{DANDELION_POSTGREST_SCHEMA}}.get_tx_history_for_addresses(data json) RETURNS TABLE (tx_hash text, block word31type, tx_timestamp timestamp) AS $$
DECLARE
    addresses text[];
BEGIN
    addresses := (SELECT array_agg(replace(rec::text, '"', ''))
                FROM json_array_elements(data->'addresses') rec);
    RETURN QUERY (SELECT trim(txs.hash, '\\\\x') , txs.block_no, txs.time from (
    SELECT
        tx.id, tx.hash::text, block.block_no, block.hash::text as blockHash, block.time, tx.block_index
        FROM block
        INNER JOIN tx ON block.id = tx.block_id
        INNER JOIN tx_out ON tx.id = tx_out.tx_id
        WHERE tx_out.address = ANY(addresses)
    UNION
        SELECT DISTINCT
        tx.id, tx.hash::text, block.block_no, block.hash::text as blockHash, block.time, tx.block_index
        FROM block
        INNER JOIN tx ON block.id = tx.block_id
        INNER JOIN tx_in ON tx.id = tx_in.tx_in_id
        INNER JOIN tx_out ON (tx_in.tx_out_id = tx_out.tx_id) AND (tx_in.tx_out_index = tx_out.index)
        WHERE tx_out.address = ANY(addresses)
        ORDER BY time DESC
    ) AS txs);
END; $$ LANGUAGE PLPGSQL IMMUTABLE;

