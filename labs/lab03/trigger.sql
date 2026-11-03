-- Триггер и функция из PDF-отчёта.
DROP TRIGGER IF EXISTS trg_after_repair ON Work_Log;
DROP FUNCTION IF EXISTS update_museum_stats();
DROP MATERIALIZED VIEW IF EXISTS mv_master_repairs;

CREATE MATERIALIZED VIEW mv_master_repairs AS
SELECT m.full_name AS master_name, COUNT(wl.id) AS repair_count
FROM Masters m
LEFT JOIN Work_Log wl ON m.id = wl.id_master
GROUP BY m.full_name
WITH DATA;

CREATE OR REPLACE FUNCTION update_museum_stats()
RETURNS TRIGGER AS $$
BEGIN
    REFRESH MATERIALIZED VIEW mv_master_repairs;
    RAISE NOTICE 'Статистика мастеров в музее обновлена!';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trg_after_repair
AFTER INSERT ON Work_Log
FOR EACH ROW

EXECUTE FUNCTION update_museum_stats();
