INSERT INTO `character` (id, user_id, name, level, config, result)
    VALUES (10, 1, "Admin Test Character", 1, "{}", "{}");
INSERT INTO `character` (id, user_id, name, level, config, result)
    VALUES (20, 2, "Testy McTestFace", 1, "{}", "{}");

INSERT INTO `party` (id, name, user_id, config)
    VALUES (100, "Test Dummies", 1, "{}");

INSERT INTO `party_characters` (party_id, character_id)
    VALUES (100, 10);
INSERT INTO `party_characters` (party_id, character_id)
    VALUES (100, 20);
