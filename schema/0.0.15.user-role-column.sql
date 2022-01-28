-- Add role column to user table

ALTER TABLE `user`
    ADD COLUMN `role` TEXT AFTER `password`;
