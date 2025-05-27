
-- DROP EXTENSION IF EXISTS pg_cardano;

CREATE EXTENSION IF NOT EXISTS pg_cardano;

ALTER EXTENSION pg_cardano UPDATE;

-- -- 1) Make sure the schema exists
-- DROP SCHEMA IF EXISTS cardano CASCADE;
-- CREATE SCHEMA IF NOT EXISTS cardano;

-- -- 2) Install pg_cardano into that schema (if not already)
-- CREATE EXTENSION IF NOT EXISTS pg_cardano
--   WITH SCHEMA cardano;

-- -- -- 3) If it _was_ already installed, ensure it lives in the right schema:
-- -- ALTER EXTENSION pg_cardano
-- --   SET SCHEMA cardano;

-- -- 4) Finally, bump it to the latest version
-- ALTER EXTENSION pg_cardano UPDATE;




-- -- 1) Ensure the schema exists (this is always safe)
-- CREATE SCHEMA IF NOT EXISTS cardano;

-- -- 2) PL/pgSQL block to create/update/move the extension as needed
-- DO $$
-- BEGIN
--   -- If the extension isn't installed at all, install it into our schema:
--   IF NOT EXISTS (
--     SELECT 1 FROM pg_extension WHERE extname = 'pg_cardano'
--   ) THEN
--     CREATE EXTENSION pg_cardano WITH SCHEMA cardano;
--     RAISE NOTICE 'pg_cardano extension installed in schema cardano';
  
--   ELSE
--     -- It exists, but maybe in the wrong schema; get its current schema:
--     PERFORM 1
--       FROM pg_extension e
--       JOIN pg_namespace n ON n.oid = e.extnamespace
--      WHERE e.extname = 'pg_cardano'
--        AND n.nspname = 'cardano';

--     -- If that PERFORM found nothing, the extension lives elsewhere:
--     IF NOT FOUND THEN
--       ALTER EXTENSION pg_cardano SET SCHEMA cardano;
--       RAISE NOTICE 'pg_cardano extension moved into schema cardano';
--     END IF;

--     -- Finally, update it to the latest control file version (if needed)
--     ALTER EXTENSION pg_cardano UPDATE;
--     RAISE NOTICE 'pg_cardano extension updated';
--   END IF;
-- END
-- $$ LANGUAGE plpgsql;