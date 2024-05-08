DROP FUNCTION IF EXISTS {{DANDELION_POSTGREST_SCHEMA}}.get_metadata ;
CREATE FUNCTION {{DANDELION_POSTGREST_SCHEMA}}.get_metadata(metadatum word64type default 0, epochs int[] default null) RETURNS TABLE (epoch word31type, data jsonb) AS $$
BEGIN
    IF epochs IS NOT NULL THEN
    RETURN QUERY (select block.epoch_no, json as epoch from tx_metadata
                    inner join tx on tx_metadata.tx_id = tx.id
                    inner join block on tx.block_id = block.id
                    where key = metadatum and epoch_no = ANY(epochs)
                    order by epoch_no);
    ELSE
    RETURN QUERY (select block.epoch_no, json as epoch from tx_metadata
                    inner join tx on tx_metadata.tx_id = tx.id
                    inner join block on tx.block_id = block.id
                    where key = metadatum
                    order by epoch_no);
    END IF;
END; $$ LANGUAGE PLPGSQL IMMUTABLE;
