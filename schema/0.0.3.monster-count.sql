-- Create and populate 'item' table

ALTER TABLE `encounter_monsters`
    ADD COLUMN `count` INTEGER DEFAULT 1;
