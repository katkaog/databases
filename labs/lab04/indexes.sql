-- Кандидаты на B-tree-индексы по условиям задания.
-- Это отдельный сценарий: сначала проверьте существующие индексы через pg_indexes.
-- IF NOT EXISTS проверяет имя, а не наличие эквивалентного индекса.

-- Фильтрация первого запроса и соединение с ведомостями.
CREATE INDEX IF NOT EXISTS lab04_people_name_idx
    ON "Н_ЛЮДИ" USING btree ("ИМЯ");

CREATE INDEX IF NOT EXISTS lab04_statements_person_idx
    ON "Н_ВЕДОМОСТИ" USING btree ("ЧЛВК_ИД");

-- Фильтрация и соединение второго запроса.
CREATE INDEX IF NOT EXISTS lab04_people_patronymic_idx
    ON "Н_ЛЮДИ" USING btree ("ОТЧЕСТВО");

CREATE INDEX IF NOT EXISTS lab04_training_record_book_idx
    ON "Н_ОБУЧЕНИЯ" USING btree ("НЗК");

CREATE INDEX IF NOT EXISTS lab04_training_person_idx
    ON "Н_ОБУЧЕНИЯ" USING btree ("ЧЛВК_ИД");

-- Индексы по ИД могут уже существовать как индексы первичных ключей.
-- В исходном плане запроса 2 уже используется УЧЕН_ОБУЧ_FK_I
-- по Н_УЧЕНИКИ.ЧЛВК_ИД, поэтому он здесь повторно не создаётся.
