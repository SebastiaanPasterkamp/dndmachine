-- Rename item table to equipment

ALTER TABLE `item`
    RENAME TO `equipment`;

-- Greatclub
UPDATE `equipment`
    SET `config` = '{"weight": {"lb": 10.0}, "damage": {"dice_count": 1, "type": "bludgeoning", "dice_size": 8}, "cost": {"sp": 2}, "property": ["two-handed"], "versatile": {"dice_count": 1, "type": "bludgeoning", "dice_size": 10}}'
    WHERE id = 2;

-- Unarmed Strike
UPDATE `equipment`
    SET `config` = '{"damage": {"bonus": 1,"type": "bludgeoning"}}'
    WHERE id = 11;

-- Greatsword
UPDATE `equipment`
    SET `config` = '{"property": ["heavy", "two-handed"], "cost": {"gp": 50}, "damage": {"dice_count": 2, "type": "slashing", "dice_size": 6}, "weight": {"lb": 6.0}}'
    WHERE id = 28;

-- Blowgun
UPDATE `equipment`
    SET `config` = '{"property": ["ammunition", "loading"], "range": {"max": 100, "min": 25}, "cost": {"gp": 10}, "damage": {"value": "1", "type": "piercing"}, "weight": {"lb": 1.0}}'
    WHERE id = 34;

-- Net
UPDATE `equipment`
    SET `config` = '{"description": "A Large or smaller creature hit by a net is restrained until it is freed. A net has no effect on creatures that are formless, or creatures that are Huge or larger. A creature can use its action to make a DC `10` **Strength** check, freeing itself or another creature within its reach on a success. Dealing `5` slashing damage to the net (AC `10`) also frees the creature without harming it, ending the effect and destroying the net.\n\nWhen you use an action, bonus action, or reaction to attack with a net, you can make only one attack regardless of the number of attacks you can normally make.", "weight": {"lb": 2.0}, "range": {"max": 15, "min": 5}, "cost": {"gp": 1}, "property": ["thrown", "special"]}'
    WHERE id = 38;

-- Padded Armor
UPDATE `equipment`
    SET `config` = '{"weight": {"lb": 8.0}, "cost": {"gp": 5}, "armor": {"formula": "11 + statistics.modifiers.dexterity"}}'
    WHERE id = 39;

-- Leather Armor
UPDATE `equipment`
    SET `config` = '{"armor": {"formula": "11 + statistics.modifiers.dexterity"}, "cost": {"gp": 10}, "weight": {"lb": 10.0}}'
    WHERE id = 40;

-- Studded Leather
UPDATE `equipment`
    SET `config` = '{"armor": {"formula": "12 + statistics.modifiers.dexterity"}, "cost": {"gp": 45}, "weight": {"lb": 13.0}}'
    WHERE id = 41;

-- Hide Armor
UPDATE `equipment`
    SET `config` = '{"armor": {"formula": "12 + min(2, statistics.modifiers.dexterity)"}, "cost": {"gp": 10}, "weight": {"lb": 12.0}}'
    WHERE id = 42;

-- Chain Shirt
UPDATE `equipment`
    SET `config` = '{"armor": {"formula": "13 + min(2, statistics.modifiers.dexterity)"}, "cost": {"gp": 50}, "weight": {"lb": 20.0}}'
    WHERE id = 43;

-- Scale Mail
UPDATE `equipment`
    SET `config` = '{"armor": {"formula": "14 + min(2, statistics.modifiers.dexterity)", "disadvantage": true}, "cost": {"gp": 50}, "weight": {"lb": 45.0}}'
    WHERE id = 44;

-- Breastplate
UPDATE `equipment`
    SET `config` = '{"armor": {"formula": "14 + min(2, statistics.modifiers.dexterity)"}, "cost": {"gp": 400}, "weight": {"lb": 20.0}}'
    WHERE id = 45;

-- Half Plate
UPDATE `equipment`
    SET `config` = '{"armor": {"formula": "15 + min(2, statistics.modifiers.dexterity)", "disadvantage": true}, "cost": {"gp": 750}, "weight": {"lb": 40.0}}'
    WHERE id = 46;

-- Ring Mail
UPDATE `equipment`
    SET `config` = '{"cost": {"gp": 30}, "armor": {"value": 14, "disadvantage": true}, "weight": {"lb": 40.0}}'
    WHERE id = 47;

-- Chain Mail
UPDATE `equipment`
    SET `config` = '{"cost": {"gp": 75}, "requirements": {"strength": 13}, "armor": {"value": 16, "disadvantage": true}, "weight": {"lb": 55.0}}'
    WHERE id = 48;

-- Splint
UPDATE `equipment`
    SET `config` = '{"cost": {"gp": 200}, "requirements": {"strength": 15}, "armor": {"value": 17, "disadvantage": true}, "weight": {"lb": 60.0}}'
    WHERE id = 49;

-- Plate
UPDATE `equipment`
    SET `config` = '{"cost": {"gp": 1500}, "requirements": {"strength": 15}, "armor": {"value": 18, "disadvantage": true}, "weight": {"lb": 65.0}}'
    WHERE id = 50;

-- Shield
UPDATE `equipment`
    SET `config` = '{"armor": {"bonus": 2}, "cost": {"gp": 10}, "weight": {"lb": 6.0}}'
    WHERE id = 51;
