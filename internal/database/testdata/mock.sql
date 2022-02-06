-- Schema versioning table for testing the database.Import function

CREATE TABLE mock (
    `id` INTEGER PRIMARY KEY AUTOINCREMENT,
    `name` VARCHAR(10) NOT NULL DEFAULT "",
    `value` VARCHAR(10),
    `config` TEXT NOT NULL DEFAULT "{}"
);

INSERT INTO mock (name, config)
    VALUES ('test', '{"something":"else"}');

INSERT INTO mock (name, config)
    VALUES ('outdated', '{"value":"moved","name":"updated","something":"else"}');
