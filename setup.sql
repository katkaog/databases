\set ON_ERROR_STOP on

BEGIN;
\ir labs/lab01/schema.sql
\ir labs/lab01/seed.sql
COMMIT;
