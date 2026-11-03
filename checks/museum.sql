-- Выполнять после setup.sql и labs/lab03/run.sql.
-- Вставка для проверки триггера будет отменена в конце транзакции.
\set ON_ERROR_STOP on

BEGIN;

DO $$
DECLARE
    chosen_master integer;
    chosen_damage integer;
    chosen_name text;
    before_count bigint;
    after_count bigint;
BEGIN
    IF EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = current_schema()
          AND table_name = 'work_log'
          AND column_name = 'id_exhibit'
    ) THEN
        RAISE EXCEPTION 'Избыточный столбец Work_Log.id_exhibit не удалён';
    END IF;

    IF (SELECT COALESCE(SUM(repair_count), 0) FROM mv_master_repairs)
       <> (SELECT COUNT(*) FROM Work_Log) THEN
        RAISE EXCEPTION 'Статистика не соответствует журналу ремонтов';
    END IF;

    SELECT id, full_name INTO chosen_master, chosen_name
    FROM Masters ORDER BY id LIMIT 1;
    SELECT id INTO chosen_damage FROM Damage ORDER BY id LIMIT 1;

    IF chosen_master IS NULL OR chosen_damage IS NULL THEN
        RAISE EXCEPTION 'Для проверки нужны тестовые данные лабораторной 1';
    END IF;

    SELECT repair_count INTO before_count
    FROM mv_master_repairs WHERE master_name = chosen_name;

    INSERT INTO Work_Log (id_master, id_damage, work_date, result)
    VALUES (chosen_master, chosen_damage, CURRENT_DATE, 'Проверка обновления статистики');

    SELECT repair_count INTO after_count
    FROM mv_master_repairs WHERE master_name = chosen_name;

    IF after_count IS DISTINCT FROM before_count + 1 THEN
        RAISE EXCEPTION 'Триггер не обновил статистику после вставки ремонта';
    END IF;

    RAISE NOTICE 'Проверки нормализации и триггера пройдены';
END;
$$;

ROLLBACK;
