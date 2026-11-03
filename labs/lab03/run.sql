\set ON_ERROR_STOP on

BEGIN;
\ir normalize.sql
\ir trigger.sql
COMMIT;
