-- Add result column to character table

ALTER TABLE `character`
    ADD COLUMN `result` TEXT AFTER `config`;
