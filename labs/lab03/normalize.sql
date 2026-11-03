-- Реализация нормализации, описанной в отчёте лабораторной 3.
-- Выполняется после лабораторной 1, внутри транзакции run.sql.

DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Work_Log wl
        LEFT JOIN Damage d ON d.id = wl.id_damage
        WHERE wl.id_exhibit IS DISTINCT FROM d.id_exhibit
    ) THEN
        RAISE EXCEPTION 'Ссылки на экспонат в Work_Log и Damage не согласованы';
    END IF;
END;
$$;

ALTER TABLE Work_Log DROP COLUMN id_exhibit;

-- В отчёте badge_num заявлен кандидатным ключом смотрителя.
ALTER TABLE Watchmen ALTER COLUMN badge_num SET NOT NULL;
ALTER TABLE Watchmen
    ADD CONSTRAINT watchmen_badge_num_unique UNIQUE (badge_num);
