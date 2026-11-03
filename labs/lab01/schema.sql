-- Схема из отчёта. Запускать в пустой учебной базе.
CREATE TABLE Halls (
    id SERIAL PRIMARY KEY,
    number INT,
    name TEXT
);
CREATE TABLE Types (
    id SERIAL PRIMARY KEY,
    name TEXT
);
CREATE TABLE Watchmen (
    id SERIAL PRIMARY KEY,
    full_name TEXT NOT NULL,
    badge_num INT,
    phone TEXT,
    start_work DATE NOT NULL,
    finish_work DATE
);
CREATE TABLE Masters (
    id SERIAL PRIMARY KEY,
    full_name TEXT NOT NULL,
    specialty TEXT,
    start_work DATE NOT NULL,
    finish_work DATE
);
CREATE TABLE Exhibits (
    id SERIAL PRIMARY KEY,
    id_type INTEGER REFERENCES Types(id),
    name TEXT,
    find_year INTEGER
);
CREATE TABLE Exhibits_in_Halls (
    id SERIAL PRIMARY KEY,
    id_exhibit INTEGER REFERENCES Exhibits(id) ON DELETE CASCADE,
    id_hall INTEGER REFERENCES Halls(id) ON DELETE CASCADE,
    date_arrival DATE,
    date_departure DATE
);
CREATE TABLE Damage (
    id SERIAL PRIMARY KEY,
    id_exhibit INTEGER REFERENCES Exhibits(id) ON DELETE CASCADE,
    info TEXT,
    level INTEGER,
    date_start DATE,
    date_end DATE
);
CREATE TABLE work_shifts (
    id SERIAL PRIMARY KEY,
    id_watchman INTEGER REFERENCES Watchmen(id) ON DELETE CASCADE,
    id_hall INTEGER REFERENCES Halls(id) ON DELETE CASCADE,
    start_time TIMESTAMP,
    end_time TIMESTAMP
);
CREATE TABLE Work_Log (
    id SERIAL PRIMARY KEY,
    id_master INTEGER REFERENCES Masters(id),
    id_exhibit INTEGER REFERENCES Exhibits(id),
    id_damage INTEGER REFERENCES Damage(id),
    work_date DATE,
    result TEXT
);
