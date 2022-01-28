-- Add Google ID to user table

ALTER TABLE `user`
    ADD COLUMN `google_id` TEXT AFTER `email`;

CREATE UNIQUE INDEX
    `google_user` on `user` (`google_id`);
