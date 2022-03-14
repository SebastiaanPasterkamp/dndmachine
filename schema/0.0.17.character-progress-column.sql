-- Add progress column to character table

ALTER TABLE `character`
    ADD COLUMN `progress` TEXT BEFORE `config`;
