CREATE OR REPLACE FUNCTION get_pools_dbsync_hash_id(_pool_bech32_ids text[] DEFAULT null) RETURNS TABLE (pool_dbsync_hash_id bigint, pool_bech32_id character varying, vrf_key_hash character varying) AS $$
select distinct pool_hash.id, pool_hash.view, encode(pool_update.vrf_key_hash, 'hex') from pool_update 
                inner join pool_hash on pool_update.hash_id = pool_hash.id
                where pool_update.registered_tx_id in (select max(pool_update.registered_tx_id) from pool_update group by hash_id)
                and not exists
                ( select * from pool_retire where pool_retire.hash_id = pool_update.hash_id
                and pool_retire.retiring_epoch <= (select max (epoch_no) from block)
                ) 
                AND CASE
                WHEN _pool_bech32_ids IS NULL THEN true
                WHEN _pool_bech32_ids IS NOT NULL THEN pool_hash.view = ANY(SELECT UNNEST(_pool_bech32_ids))
                END;
$$ LANGUAGE SQL IMMUTABLE;