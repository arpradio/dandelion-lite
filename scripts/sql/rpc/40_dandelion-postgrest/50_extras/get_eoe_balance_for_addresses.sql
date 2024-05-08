CREATE OR REPLACE FUNCTION {{DANDELION_POSTGREST_SCHEMA}}.get_eoe_balance_for_addresses(data json) RETURNS TABLE (balance numeric, address character varying) AS $$
DECLARE
    addresses text[];
    epoch int;
BEGIN
    addresses := (SELECT array_agg(replace(rec::text, '"', ''))
                FROM json_array_elements(data->'addresses') rec);
    SELECT json_extract_path_text(data, 'epoch') INTO epoch AS tmp;
    RETURN QUERY (SELECT SUM(utxo_view.value), utxo_view.address FROM utxo_view
    INNER JOIN tx ON tx.id = utxo_view.tx_id
    INNER JOIN block ON block.id = tx.block_id
    WHERE utxo_view.address = ANY(addresses)
    AND block.slot_no <= (select get_last_slot_for_epoch(epoch))
    GROUP BY utxo_view.address);
END; $$ LANGUAGE PLPGSQL IMMUTABLE;
