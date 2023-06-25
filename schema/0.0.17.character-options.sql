-- Create and populate character options table

DROP TABLE IF EXISTS `character_option`;
CREATE TABLE `character_option` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `uuid` VARCHAR(32) NOT NULL,
  `type` VARCHAR(32) NOT NULL,
  `name` TEXT NOT NULL,
  `config` TEXT
);

INSERT INTO `character_option` (id, uuid, type, name, config)
    VALUES (1, 'c4826704-86dc-4daf-985b-d4514ece5bc5', 'character-description', 'Character Description', '{}');
