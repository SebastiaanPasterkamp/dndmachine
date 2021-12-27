-- Second schema file

ALTER TABLE `user`
    ADD COLUMN `google_id` TEXT AFTER `email`;
