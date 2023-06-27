-- Create and populate character options table

DROP TABLE IF EXISTS `character_option`;
CREATE TABLE `character_option` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `uuid` VARCHAR(32) NOT NULL,
  `type` VARCHAR(32) NOT NULL,
  `name` TEXT NOT NULL,
  `config` TEXT
);

INSERT INTO `character_option` (id, uuid, type, name, config) VALUES
  (1, 'c4826704-86dc-4daf-985b-d4514ece5bc5', 'description', 'Character Description', '{}'),
  (2, '867fde51-ed0d-4ec6-bed4-a6e561f08ff4', 'tab', 'Class', '{"type":"class"}'),
  (3, '6a09ab55-21bc-4b87-82a3-e35110c1c3ae', 'class', 'Cleric', '{"id":"cleric","Name":"Cleric"}'),
  (4, 'b9147d0b-8aea-42eb-8e10-665257bb19f8', 'class', 'Fighter', '{"id":"fighter","Name":"Fighter"}');
