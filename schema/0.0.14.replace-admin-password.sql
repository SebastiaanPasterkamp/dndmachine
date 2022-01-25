-- Replace admin password with bcrypt version

UPDATE `user`
    SET `password` = '$2a$10$VlwKF7DGlIVbHANYtr.I9uUj8RY8OA2oCimhA/GUWJpdnY7h7WGcy'
    WHERE `id` = 1;
