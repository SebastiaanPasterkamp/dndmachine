-- Create and populate player character options table; (sub)race, (sub)class, background

DROP TABLE IF EXISTS `race`;
CREATE TABLE `race` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `sub` INTEGER,
  `name` TEXT NOT NULL,
  `config` TEXT,
  `phases` TEXT,
  FOREIGN KEY(`sub`) REFERENCES `race`(`id`)
);

DROP TABLE IF EXISTS `class`;
CREATE TABLE `class` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `sub` INTEGER,
  `name` TEXT NOT NULL,
  `config` TEXT,
  `phases` TEXT,
  FOREIGN KEY(`sub`) REFERENCES `class`(`uuid`)
);

DROP TABLE IF EXISTS `background`;
CREATE TABLE `background` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `sub` INTEGER,
  `type` VARCHAR(16) NOT NULL,
  `name` TEXT NOT NULL,
  `config` TEXT,
  `phases` TEXT,
  FOREIGN KEY(`sub`) REFERENCES `class`(`uuid`)
);

DROP TABLE IF EXISTS `characteristic_option`;
CREATE TABLE `characteristic_option` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `uuid` VARCHAR(32) NOT NULL,
  `name` TEXT NOT NULL,
  `type` VARCHAR(20) NOT NULL,
  `config` TEXT
);
