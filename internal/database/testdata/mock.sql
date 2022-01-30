-- Schema versioning table for testing the database.Import function

CREATE TABLE mock (
    `id` INTEGER PRIMARY KEY AUTOINCREMENT,
    `name` VARCHAR(10) NOT NULL DEFAULT "",
    `config` TEXT NOT NULL DEFAULT "{}"
);

INSERT INTO mock (name, config)
    VALUES ('test', '{"something":"else"}');
