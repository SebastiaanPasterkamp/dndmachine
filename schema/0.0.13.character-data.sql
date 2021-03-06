-- Create and populate player data tables; (sub)race, (sub)class, background

DROP TABLE IF EXISTS `race`;
CREATE TABLE `race` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `name` TEXT NOT NULL,
  `config` TEXT
);

DROP TABLE IF EXISTS `subrace`;
CREATE TABLE `subrace` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `name` TEXT NOT NULL,
  `race_id` INTEGER NOT NULL,
  `config` TEXT,
  FOREIGN KEY(`race_id`) REFERENCES `race`(`id`)
);

DROP TABLE IF EXISTS `class`;
CREATE TABLE `class` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `name` TEXT NOT NULL,
  `config` TEXT
);

DROP TABLE IF EXISTS `subclass`;
CREATE TABLE `subclass` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `name` TEXT NOT NULL,
  `class_id` INTEGER NOT NULL,
  `config` TEXT,
  FOREIGN KEY(`class_id`) REFERENCES `class`(`id`)
);

DROP TABLE IF EXISTS `background`;
CREATE TABLE `background` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `name` TEXT NOT NULL,
  `config` TEXT
);

DROP TABLE IF EXISTS `options`;
CREATE TABLE `options` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `name` TEXT NOT NULL,
  `config` TEXT
);

INSERT INTO `race` (id, name, config)
    VALUES (1, 'Dwarf', '{
    "conditions": [
        {
            "path": "character.level",
            "type": "lte",
            "value": 1
        }
    ],
    "config": [
        {
            "config": [
                {
                    "given": [
                        2
                    ],
                    "hidden": true,
                    "multiple": true,
                    "path": "statistics.bonus.constitution",
                    "type": "list",
                    "uuid": "c7989c39-b7b5-41d4-aad6-400484afc8fb"
                }
            ],
            "description": "Your **Constitution** score increases by 2.",
            "name": "Ability Score Increase",
            "type": "config",
            "uuid": "ac1edc9b-a9eb-4431-8b52-6fbab220d48a"
        },
        {
            "config": [
                {
                    "hidden": true,
                    "path": "size",
                    "type": "value",
                    "uuid": "64242cd6-b761-42f2-88eb-bcc4b994b790",
                    "value": "medium"
                }
            ],
            "description": "Dwarves stand between 4 and 5 feet tall and average about 150 pounds. Your size is **Medium**.",
            "name": "Size",
            "type": "config",
            "uuid": "05d5e537-8ecd-44ad-b066-ccb35bbb2055"
        },
        {
            "config": [
                {
                    "hidden": true,
                    "path": "speed",
                    "type": "value",
                    "uuid": "02c50a57-a363-477a-9951-65c194b01321",
                    "value": 25
                }
            ],
            "description": "Your base walking *speed* is **25 feet**.",
            "name": "Speed",
            "type": "config",
            "uuid": "54734758-1295-41d8-bca2-5e32a098b408"
        },
        {
            "path": "info.Speed",
            "type": "value",
            "uuid": "820502f0-698a-433a-9a98-b7e62a4dcd62",
            "value": "Your *speed* is not reduced by wearing **heavy armor**."
        },
        {
            "name": "Darkvision",
            "path": "info.Darkvision",
            "type": "value",
            "uuid": "4ad9e96d-8240-43d8-bbbf-18be95e2d69b",
            "value": "Accustomed to life underground, you have\nsuperior vision in dark and dim conditions. You can see\nin dim light within 60 feet of you as if it were bright light,\nand in darkness as if it were dim light. You can\u2019t discern\ncolor in darkness, only shades of gray."
        },
        {
            "name": "Dwarven Resilience",
            "path": "info.Dwarven Resilience",
            "type": "value",
            "uuid": "896f5ee6-c76c-4cfb-b1d9-85eaf2787222",
            "value": "You have advantage on saving\nthrows against poison, and you have resistance against\npoison damage (explained in chapter 9)."
        },
        {
            "description": "You have proficiency with\nthe battleaxe, handaxe, light hammer, and warhammer.",
            "given": [
                {
                    "id": 16,
                    "name": "Battleaxe",
                    "type": "martial melee"
                },
                {
                    "id": 4,
                    "name": "Handaxe",
                    "type": "simple melee"
                },
                {
                    "id": 6,
                    "name": "Light Hammer",
                    "type": "simple melee"
                },
                {
                    "id": 32,
                    "name": "Warhammer",
                    "type": "martial melee"
                }
            ],
            "list": [],
            "name": "Dwarven Combat Training",
            "path": "proficiencies.weapons",
            "type": "objectlist",
            "uuid": "2e8b2e97-6e59-416f-9dff-db9fb12e0b17"
        },
        {
            "add": 1,
            "description": "You gain proficiency with the artisan\u2019s tools of your choice: smith\u2019s tools, brewer\u2019s supplies,\nor mason\u2019s tools.",
            "filter": [
                {
                    "field": "id",
                    "options": [
                        68,
                        56,
                        65
                    ],
                    "type": "attribute"
                }
            ],
            "list": [
                "gear"
            ],
            "name": "Tool Proficiency",
            "path": "proficiencies.tools",
            "type": "objectlist",
            "uuid": "fee2ccfb-7bd7-4b0e-9486-5aad04932c59"
        },
        {
            "name": "Stonecunning",
            "path": "info.Stonecunning",
            "type": "value",
            "uuid": "0a6c9349-4c6e-46ab-85b7-5be7e3ae3ce3",
            "value": "Whenever you make an *Intelligence\n(History)* check related to the origin of stonework, you are\nconsidered proficient in the *History* skill and add double\nyour proficiency bonus to the check, instead of your normal proficiency bonus."
        },
        {
            "description": "You can speak, read, and write *Common*\nand *Dwarvish*. Dwarvish is full of hard consonants and\nguttural sounds, and those characteristics spill over into\nwhatever other language a dwarf might speak.",
            "given": [
                {
                    "id": "common",
                    "name": "Common",
                    "type": "languages"
                },
                {
                    "id": "dwarvish",
                    "name": "Dwarvish",
                    "type": "languages"
                }
            ],
            "list": [],
            "name": "Languages",
            "path": "proficiencies.languages",
            "type": "objectlist",
            "uuid": "5d362fe7-51ad-4da2-a0e5-84ced7edc2eb"
        },
        {
            "description": "Two main subraces of dwarves populate the majority of\nworlds of D&D: hill dwarves and mountain dwarves.\nChoose one of the following subraces.",
            "name": "Subrace",
            "subtype": true,
            "type": "choice",
            "uuid": "d27c5535-d67f-4254-90e2-2d9368dc01d6"
        }
    ],
    "description": "Kingdoms rich in ancient grandeur, halls carved into the\nroots of mountains, the echoing of picks and hammers\nin deep mines and blazing forges, a commitment to clan\nand tradition, and a burning hatred of goblins and orcs\u2014\nthese common threads unite all dwarves.\n\n## Short and Stout\n\nBold and hardy, dwarves are known as skilled warriors,\nminers, and workers of stone and metal. Though they\nstand well under 5 feet tall, dwarves are so broad and\ncompact that they can weigh as much as a human standing\nnearly two feet taller. Their courage and endurance are\nalso easily a match for any of the larger folk.\nDwarven skin ranges from deep brown to a paler\nhue tinged with red, but the most common shades are\nlight brown or deep tan, like certain tones of earth.\nTheir hair, worn long but in simple styles, is usually\nblack, gray, or brown, though paler dwarves often have\nred hair. Male dwarves value their beards highly and\ngroom them carefully.",
    "phases": [
        {
            "conditions": [
                {
                    "path": "sub.dwarf.level",
                    "type": "eq",
                    "value": 1
                }
            ],
            "config": [],
            "name": "Dwarf 2",
            "type": "config",
            "uuid": "7e9ddd6e-548d-4160-a0ba-a2dfc1b3b759"
        },
        {
            "conditions": [
                {
                    "path": "sub.dwarf.level",
                    "type": "eq",
                    "value": 2
                }
            ],
            "config": [],
            "name": "Dwarf 3",
            "type": "config",
            "uuid": "fc2fb456-73fb-434a-badf-b54fc20a4b3c"
        },
        {
            "conditions": [
                {
                    "path": "sub.dwarf.level",
                    "type": "eq",
                    "value": 3
                }
            ],
            "config": [],
            "name": "Dwarf 4",
            "type": "config",
            "uuid": "dae474ef-b951-4422-8f19-a0f5185ae324"
        },
        {
            "conditions": [
                {
                    "path": "sub.dwarf.level",
                    "type": "eq",
                    "value": 4
                }
            ],
            "config": [],
            "name": "Dwarf 5",
            "type": "config",
            "uuid": "aa92e1c2-1531-4019-894b-9ede4ea1c8ac"
        },
        {
            "conditions": [
                {
                    "path": "sub.dwarf.level",
                    "type": "eq",
                    "value": 5
                }
            ],
            "config": [],
            "name": "Dwarf 6",
            "type": "config",
            "uuid": "c18f4a7c-5320-45e8-8007-7a44b8b5b9b7"
        },
        {
            "conditions": [
                {
                    "path": "sub.dwarf.level",
                    "type": "eq",
                    "value": 6
                }
            ],
            "config": [],
            "name": "Dwarf 7",
            "type": "config",
            "uuid": "cd29738f-45f2-4804-be91-8e7eb853114f"
        },
        {
            "conditions": [
                {
                    "path": "sub.dwarf.level",
                    "type": "eq",
                    "value": 7
                }
            ],
            "config": [],
            "name": "Dwarf 8",
            "type": "config",
            "uuid": "2995a57e-fe85-441b-8151-db726bdb7f05"
        },
        {
            "conditions": [
                {
                    "path": "sub.dwarf.level",
                    "type": "eq",
                    "value": 8
                }
            ],
            "config": [],
            "name": "Dwarf 9",
            "type": "config",
            "uuid": "e25e77dc-7ed9-4c9f-a6ba-ef7286d8a909"
        },
        {
            "conditions": [
                {
                    "path": "sub.dwarf.level",
                    "type": "eq",
                    "value": 9
                }
            ],
            "config": [],
            "name": "Dwarf 10",
            "type": "config",
            "uuid": "468c1590-7883-432b-aabc-d79c016e91b9"
        },
        {
            "conditions": [
                {
                    "path": "sub.dwarf.level",
                    "type": "eq",
                    "value": 10
                }
            ],
            "config": [],
            "name": "Dwarf 11",
            "type": "config",
            "uuid": "bcd8365a-48a1-4c29-901b-da7892e1bde8"
        },
        {
            "conditions": [
                {
                    "path": "sub.dwarf.level",
                    "type": "eq",
                    "value": 11
                }
            ],
            "config": [],
            "name": "Dwarf 12",
            "type": "config",
            "uuid": "192caa40-bb4b-4934-ba0e-84b36c68b4bb"
        },
        {
            "conditions": [
                {
                    "path": "sub.dwarf.level",
                    "type": "eq",
                    "value": 12
                }
            ],
            "config": [],
            "name": "Dwarf 13",
            "type": "config",
            "uuid": "842e7d52-b8ad-488a-aead-8a367d3b9f0f"
        },
        {
            "conditions": [
                {
                    "path": "sub.dwarf.level",
                    "type": "eq",
                    "value": 13
                }
            ],
            "config": [],
            "name": "Dwarf 14",
            "type": "config",
            "uuid": "f9325dd7-4eb6-49d9-a26c-ba03843aa757"
        },
        {
            "conditions": [
                {
                    "path": "sub.dwarf.level",
                    "type": "eq",
                    "value": 14
                }
            ],
            "config": [],
            "name": "Dwarf 15",
            "type": "config",
            "uuid": "a7baeafb-6b58-41f7-9799-fd22e8fa5663"
        },
        {
            "conditions": [
                {
                    "path": "sub.dwarf.level",
                    "type": "eq",
                    "value": 15
                }
            ],
            "config": [],
            "name": "Dwarf 16",
            "type": "config",
            "uuid": "eea35687-3f02-4afe-8d19-88af0297f6cc"
        },
        {
            "conditions": [
                {
                    "path": "sub.dwarf.level",
                    "type": "eq",
                    "value": 16
                }
            ],
            "config": [],
            "name": "Dwarf 17",
            "type": "config",
            "uuid": "5c10ce48-05e1-4314-84df-409206e71945"
        },
        {
            "conditions": [
                {
                    "path": "sub.dwarf.level",
                    "type": "eq",
                    "value": 17
                }
            ],
            "config": [],
            "name": "Dwarf 18",
            "type": "config",
            "uuid": "c35aeaf0-d82c-4c69-a743-65e3a3b4ada2"
        },
        {
            "conditions": [
                {
                    "path": "sub.dwarf.level",
                    "type": "eq",
                    "value": 18
                }
            ],
            "config": [],
            "name": "Dwarf 19",
            "type": "config",
            "uuid": "332e3927-60a2-45b4-8304-9938d69305b0"
        },
        {
            "conditions": [
                {
                    "path": "sub.dwarf.level",
                    "type": "eq",
                    "value": 19
                }
            ],
            "config": [],
            "name": "Dwarf 20",
            "type": "config",
            "uuid": "94ac268a-cd02-4217-92e3-eb1ab1fda640"
        }
    ],
    "type": "config",
    "uuid": "50dcaaf6-288b-434c-a367-be5106df317d"
}');
INSERT INTO `race` (id, name, config)
    VALUES (2, 'Elf', '{
    "conditions": [
        {
            "path": "character.level",
            "type": "lte",
            "value": 1
        }
    ],
    "config": [
        {
            "config": [
                {
                    "given": [
                        2
                    ],
                    "hidden": true,
                    "multiple": true,
                    "path": "statistics.bonus.dexterity",
                    "type": "list",
                    "uuid": "cde69de2-61bc-4c85-bd49-5e00bf6b243b"
                }
            ],
            "description": "Your **Dexterity** score increases by 2.",
            "name": "Ability Score Increase",
            "type": "config",
            "uuid": "7e4e2bdd-bc84-464c-ac9b-4e2d57ba32b0"
        },
        {
            "config": [
                {
                    "hidden": true,
                    "path": "size",
                    "type": "value",
                    "uuid": "2a75a7dc-46bb-4688-b0ce-56098326b95c",
                    "value": "medium"
                }
            ],
            "description": " Elves range from under 5 to over 6 feet tall and\nhave slender builds. Your size is **Medium**.",
            "name": "Size",
            "type": "config",
            "uuid": "d59ce4c9-8609-40af-91de-98342ab43922"
        },
        {
            "config": [
                {
                    "hidden": true,
                    "path": "speed",
                    "type": "value",
                    "uuid": "5ec1e55c-dbfe-4165-8ebb-cc24e8473fd7",
                    "value": 30
                }
            ],
            "description": " Your base walking speed is **30 feet**.",
            "name": "Speed",
            "type": "config",
            "uuid": "b1ae897e-7490-4bec-afde-c4be60a96778"
        },
        {
            "name": "Darkvision",
            "path": "info.Darkvision",
            "type": "value",
            "uuid": "339f5b06-2680-4329-a26b-aa3ced3472ae",
            "value": "Accustomed to twilit forests and the night\nsky, you have superior vision in dark and dim conditions.\nYou can see in dim light within 60 feet of you as if it were\nbright light, and in darkness as if it were dim light. You\ncan\u2019t discern color in darkness, only shades of gray."
        },
        {
            "description": "You have proficiency in the Perception skill.",
            "given": [
                {
                    "id": "perception",
                    "name": "Perception",
                    "type": "skills"
                }
            ],
            "list": [],
            "name": "Keen Senses",
            "path": "proficiencies.skills",
            "type": "objectlist",
            "uuid": "4b90bedb-a6fe-4fe1-aed0-9317d6078cc6"
        },
        {
            "name": "Fey Ancestry",
            "path": "info.Fey Ancestry",
            "type": "value",
            "uuid": "31e76eb7-797c-40ec-a8d9-c02a7269b15f",
            "value": "You have **advantage** on *saving throws*\nagainst being **charmed**, and magic can\u2019t put you to **sleep**."
        },
        {
            "name": "Trance",
            "path": "info.Trance",
            "type": "value",
            "uuid": "706111a0-2d31-4c44-a9a4-8d456fdee769",
            "value": "Elves don\u2019t need to sleep. Instead, they meditate deeply, remaining semiconscious, for 4 hours a day.\n(The Common word for such meditation is \u201ctrance.\u201d)\nWhile meditating, you can dream after a fashion; such\ndreams are actually mental exercises that have become\nreflexive through years of practice. After resting in this\nway, you gain the same benefit that a human does from 8\nhours of sleep"
        },
        {
            "description": "You can speak, read, and write Common\nand Elvish. Elvish is fluid, with subtle intonations and\nintricate grammar. Elven literature is rich and varied, and\ntheir songs and poems are famous among other races.\nMany bards learn their language so they can add Elvish\nballads to their repertoires.",
            "given": [
                {
                    "id": "common",
                    "name": "Common",
                    "type": "languages"
                },
                {
                    "id": "elvish",
                    "name": "Elvish",
                    "type": "languages"
                }
            ],
            "list": [],
            "name": "Languages",
            "path": "proficiencies.languages",
            "type": "objectlist",
            "uuid": "1129e749-7528-4ab4-9f69-b1d9419a508f"
        },
        {
            "description": "Ancient divides among the elven people resulted in three main subraces: high elves, wood elves,\nand dark elves, who are commonly called drow. This\ndocument presents two of these subraces to choose\nfrom. In some worlds, these subraces are divided still\nfurther (such as the sun elves and moon elves of the\nForgotten Realms), so if you wish, you can choose a narrower subrace.",
            "name": "Subrace",
            "subtype": true,
            "type": "choice",
            "uuid": "ac2b22db-9f5f-4b8a-9312-eb5df4db151f"
        }
    ],
    "description": "Elves are a magical people of otherworldly grace, living\nin the world but not entirely part of it. They live in places\nof ethereal beauty, in the midst of ancient forests or in\nsilvery spires glittering with faerie light, where soft music\ndrifts through the air and gentle fragrances waft on the\nbreeze. Elves love nature and magic, art and artistry, music and poetry, and the good things of the world.\n\n## Slender and Graceful\n\nWith their unearthly grace and fine features, elves appear\nhauntingly beautiful to humans and members of many\nother races. They are slightly shorter than humans on\naverage, ranging from well under 5 feet tall to just over\n6 feet. They are more slender than humans, weighing\nonly 100 to 145 pounds. Males and females are about\nthe same height, and males are only marginally heavier\nthan females.\n\nElves\u2019 coloration encompasses the normal human\nrange and also includes skin in shades of copper, bronze,\nand almost bluish-white, hair of green or blue, and eyes\nlike pools of liquid gold or silver. Elves have no facial and\nlittle body hair. They favor elegant clothing in bright colors, and they enjoy simple yet lovely jewelry.\n\n## A Timeless Perspective\n\nElves can live well over 700 years, giving them a broad\nperspective on events that might trouble the shorter-lived\nraces more deeply. They are more often amused than\nexcited, and more likely to be curious than greedy. They\ntend to remain aloof and unfazed by petty happenstance.\nWhen pursuing a goal, however, whether adventuring\non a mission or learning a new skill or art, elves can be\nfocused and relentless. They are slow to make friends\nand enemies, and even slower to forget them. They reply\nto petty insults with disdain and to serious insults with\nvengeance.\n\nLike the branches of a young tree, elves are flexible\nin the face of danger. They trust in diplomacy and compromise to resolve differences before they escalate to\nviolence. They have been known to retreat from intrusions into their woodland homes, confident that they can\nsimply wait the invaders out. But when the need arises,\nelves reveal a stern martial side, demonstrating skill with\nsword, bow, and strategy.\n\n## Hidden Woodland Realms\n\nMost elves dwell in small forest villages hidden among\nthe trees. Elves hunt game, gather food, and grow vegetables, and their skill and magic allow them to support\nthemselves without the need for clearing and plowing\nland. They are talented artisans, crafting finely worked\nclothes and art objects. Their contact with outsiders is\nusually limited, though a few elves make a good living by\ntrading crafted items for metals (which they have no interest in mining).\n\nElves encountered outside their own lands are commonly traveling minstrels, artists, or sages. Human\nnobles compete for the services of elf instructors to teach\nswordplay or magic to their children.\n\n## Exploration and Adventure\n\nElves take up adventuring out of wanderlust. Since they\nare so long-lived, they can enjoy centuries of exploration\nand discovery. They dislike the pace of human society,\nwhich is regimented from day to day but constantly\nchanging over decades, so they find careers that let them\ntravel freely and set their own pace. Elves also enjoy\nexercising their martial prowess or gaining greater magical power, and adventuring allows them to do so. Some\nmight join with rebels fighting against oppression, and\nothers might become champions of moral causes.",
    "phases": [
        {
            "conditions": [
                {
                    "path": "sub.elf.level",
                    "type": "eq",
                    "value": 1
                }
            ],
            "config": [],
            "name": "Elf 2",
            "type": "config",
            "uuid": "7b0183f9-74b4-469d-b42d-7ca7a90838b9"
        },
        {
            "conditions": [
                {
                    "path": "sub.elf.level",
                    "type": "eq",
                    "value": 2
                }
            ],
            "config": [],
            "name": "Elf 3",
            "type": "config",
            "uuid": "ca00f2bc-f0b0-4208-9c65-06cb16bb9c83"
        },
        {
            "conditions": [
                {
                    "path": "sub.elf.level",
                    "type": "eq",
                    "value": 3
                }
            ],
            "config": [],
            "name": "Elf 4",
            "type": "config",
            "uuid": "691fccfe-9870-478b-aa44-595a0f58fffb"
        },
        {
            "conditions": [
                {
                    "path": "sub.elf.level",
                    "type": "eq",
                    "value": 4
                }
            ],
            "config": [],
            "name": "Elf 5",
            "type": "config",
            "uuid": "d451415c-1827-477d-aa27-79d5e4ca16cd"
        },
        {
            "conditions": [
                {
                    "path": "sub.elf.level",
                    "type": "eq",
                    "value": 5
                }
            ],
            "config": [],
            "name": "Elf 6",
            "type": "config",
            "uuid": "21f82570-2529-45c5-bfc8-a5eef7b2e6a6"
        },
        {
            "conditions": [
                {
                    "path": "sub.elf.level",
                    "type": "eq",
                    "value": 6
                }
            ],
            "config": [],
            "name": "Elf 7",
            "type": "config",
            "uuid": "cf7b6381-e4a9-441a-aec0-61ef1e5bf893"
        },
        {
            "conditions": [
                {
                    "path": "sub.elf.level",
                    "type": "eq",
                    "value": 7
                }
            ],
            "config": [],
            "name": "Elf 8",
            "type": "config",
            "uuid": "8ad52444-f80c-4c34-a412-d225f34f07a6"
        },
        {
            "conditions": [
                {
                    "path": "sub.elf.level",
                    "type": "eq",
                    "value": 8
                }
            ],
            "config": [],
            "name": "Elf 9",
            "type": "config",
            "uuid": "4e3f6297-69fd-4d28-aab9-67e5f64d1ce7"
        },
        {
            "conditions": [
                {
                    "path": "sub.elf.level",
                    "type": "eq",
                    "value": 9
                }
            ],
            "config": [],
            "name": "Elf 10",
            "type": "config",
            "uuid": "38b03534-9b9b-4db8-84c6-54a7e8c5d5b5"
        },
        {
            "conditions": [
                {
                    "path": "sub.elf.level",
                    "type": "eq",
                    "value": 10
                }
            ],
            "config": [],
            "name": "Elf 11",
            "type": "config",
            "uuid": "9ea95f05-c2f7-4049-823d-5319c0a08b41"
        },
        {
            "conditions": [
                {
                    "path": "sub.elf.level",
                    "type": "eq",
                    "value": 11
                }
            ],
            "config": [],
            "name": "Elf 12",
            "type": "config",
            "uuid": "441ba374-efad-4b22-9800-8c043dfa4a94"
        },
        {
            "conditions": [
                {
                    "path": "sub.elf.level",
                    "type": "eq",
                    "value": 12
                }
            ],
            "config": [],
            "name": "Elf 13",
            "type": "config",
            "uuid": "a3372ba8-439f-41ae-a0cd-20c18739d710"
        },
        {
            "conditions": [
                {
                    "path": "sub.elf.level",
                    "type": "eq",
                    "value": 13
                }
            ],
            "config": [],
            "name": "Elf 14",
            "type": "config",
            "uuid": "b87d41bf-b0f5-4d74-82e8-54e1a57e1147"
        },
        {
            "conditions": [
                {
                    "path": "sub.elf.level",
                    "type": "eq",
                    "value": 14
                }
            ],
            "config": [],
            "name": "Elf 15",
            "type": "config",
            "uuid": "7de698b5-83bd-4d52-8444-d11fd6e5601f"
        },
        {
            "conditions": [
                {
                    "path": "sub.elf.level",
                    "type": "eq",
                    "value": 15
                }
            ],
            "config": [],
            "name": "Elf 16",
            "type": "config",
            "uuid": "7c3c3a7f-c34e-4e91-9d50-91e6888c0714"
        },
        {
            "conditions": [
                {
                    "path": "sub.elf.level",
                    "type": "eq",
                    "value": 16
                }
            ],
            "config": [],
            "name": "Elf 17",
            "type": "config",
            "uuid": "8528adb9-52b4-4dcf-ae7e-3ad2137158c1"
        },
        {
            "conditions": [
                {
                    "path": "sub.elf.level",
                    "type": "eq",
                    "value": 17
                }
            ],
            "config": [],
            "name": "Elf 18",
            "type": "config",
            "uuid": "b03c92c8-3a4e-4b7f-b532-937d46c85277"
        },
        {
            "conditions": [
                {
                    "path": "sub.elf.level",
                    "type": "eq",
                    "value": 18
                }
            ],
            "config": [],
            "name": "Elf 19",
            "type": "config",
            "uuid": "c1ba8c10-45a4-4d37-8dc4-b4bf7132b6cc"
        },
        {
            "conditions": [
                {
                    "path": "sub.elf.level",
                    "type": "eq",
                    "value": 19
                }
            ],
            "config": [],
            "name": "Elf 20",
            "type": "config",
            "uuid": "83431304-f126-4e00-98d0-cd33876ceb33"
        }
    ],
    "type": "config",
    "uuid": "23961b53-ed8f-48a5-b0a5-32886688d1c3"
}');
INSERT INTO `race` (id, name, config)
    VALUES (3, 'Halfling', '{
    "conditions": [
        {
            "path": "character.level",
            "type": "lte",
            "value": 1
        }
    ],
    "config": [
        {
            "config": [
                {
                    "given": [
                        2
                    ],
                    "hidden": true,
                    "multiple": true,
                    "path": "statistics.bonus.dexterity",
                    "type": "list",
                    "uuid": "d66b1e76-ffca-4600-b3fe-7b6d798d2b37"
                }
            ],
            "description": "Your **Dexterity** score increases by 2.",
            "name": "Ability Score Increase",
            "type": "config",
            "uuid": "66db04e5-6306-4f1b-a7be-26da0ef28fb6"
        },
        {
            "config": [
                {
                    "hidden": true,
                    "path": "size",
                    "type": "value",
                    "uuid": "020cbf4c-a9d4-48c3-82e7-383e4526e74c",
                    "value": "small"
                }
            ],
            "description": "Halflings average about 3 feet tall and weigh\nabout 40 pounds. Your size is **Small**.",
            "name": "Size",
            "type": "config",
            "uuid": "ce9f1bc4-9274-49b2-a3ce-640a6f69d13c"
        },
        {
            "config": [
                {
                    "hidden": true,
                    "path": "speed",
                    "type": "value",
                    "uuid": "e763562a-02fa-4a87-9e3a-d4654e610d8b",
                    "value": 25
                }
            ],
            "description": "Your base walking speed is 25 feet.",
            "name": "Speed",
            "type": "config",
            "uuid": "7d1f6823-739d-418d-b3ad-33085b42ebcd"
        },
        {
            "name": "Lucky",
            "path": "info.Lucky",
            "type": "value",
            "uuid": "ca99aecb-aadf-407f-b8e6-4b7b2dda1233",
            "value": "When you roll a `1` on the d20 for an attack roll, ability check, or saving throw, you can reroll the die and must use the new roll."
        },
        {
            "name": "Brave",
            "path": "info.Brave",
            "type": "value",
            "uuid": "35b69ae6-e7c6-425f-9d9e-122bc6910878",
            "value": "You have advantage on saving throws against\nbeing frightened."
        },
        {
            "name": "Halfling Nimbleness",
            "path": "info.Halfling Nimbleness",
            "type": "value",
            "uuid": "b77594ff-4c5c-42a7-9361-4226232ec49b",
            "value": "You can move through the space\nof any creature that is of a size larger than yours."
        },
        {
            "description": "You can speak, read, and write Common\nand Halfling. The Halfling language isn\u2019t secret, but\nhalflings are loath to share it with others. They write\nvery little, so they don\u2019t have a rich body of literature.\nTheir oral tradition, however, is very strong. Almost all\nhalflings speak Common to converse with the people\nin whose lands they dwell or through which they are\ntraveling.",
            "given": [
                {
                    "id": "common",
                    "name": "Common",
                    "type": "languages"
                },
                {
                    "id": "halfling",
                    "name": "Halfling",
                    "type": "languages"
                }
            ],
            "list": [],
            "name": "Languages",
            "path": "proficiencies.languages",
            "type": "objectlist",
            "uuid": "db20612d-4ff1-4170-b668-eda8ee25f28b"
        },
        {
            "description": "The two main kinds of halfling, lightfoot and\nstout, are more like closely related families than true subraces. Choose one of these subraces.",
            "name": "Subrace",
            "subtype": true,
            "type": "choice",
            "uuid": "82b29ddc-8930-42dc-88f6-cb268011d424"
        }
    ],
    "description": "The comforts of home are the goals of most halflings\u2019\nlives: a place to settle in peace and quiet, far from marauding monsters and clashing armies; a blazing fire\nand a generous meal; fine drink and fine conversation.\nThough some halflings live out their days in remote agricultural communities, others form nomadic bands that\ntravel constantly, lured by the open road and the wide\nhorizon to discover the wonders of new lands and peoples. But even these wanderers love peace, food, hearth,\nand home, though home might be a wagon jostling along\nan dirt road or a raft floating downriver.\n\n## Small and Practical\n\nThe diminutive halflings survive in a world full of larger\ncreatures by avoiding notice or, barring that, avoiding\noffense. Standing about 3 feet tall, they appear relatively\nharmless and so have managed to survive for centuries\nin the shadow of empires and on the edges of wars and\npolitical strife. They are inclined to be stout, weighing\nbetween 40 and 45 pounds.\n\nHalflings\u2019 skin ranges from tan to pale with a ruddy\ncast, and their hair is usually brown or sandy brown and\nwavy. They have brown or hazel eyes. Halfling men often\nsport long sideburns, but beards are rare among them\nand mustaches even more so. They like to wear simple,\ncomfortable, and practical clothes, favoring bright colors.\n\nHalfling practicality extends beyond their clothing.\nThey\u2019re concerned with basic needs and simple pleasures\nand have little use for ostentation. Even the wealthiest\nof halflings keep their treasures locked in a cellar rather\nthan on display for all to see. They have\na knack for finding the most straightforward solution\nto a problem, and have little patience for dithering.\n\n## Kind and Curious\n\nHalflings are an affable and cheerful people. They\ncherish the bonds of family and friendship as well\nas the comforts of hearth and home, harboring few\ndreams of gold or glory. Even adventurers among\nthem usually venture into the world for reasons of\ncommunity, friendship, wanderlust, or curiosity. They\nlove discovering new things, even simple things, such\nas an exotic food or an unfamiliar style of clothing.\n\nHalflings are easily moved to pity and hate to see any\nliving thing suffer. They are generous, happily sharing\nwhat they have even in lean times.\n\n## Blend into the Crowd\n\nHalflings are adept at fitting into a community of humans, dwarves, or elves, making themselves valuable\nand welcome. The combination of their inherent stealth\nand their unassuming nature helps halflings to avoid unwanted attention.\nHalflings work readily with others, and they are loyal\nto their friends, whether halfling or otherwise. They can\ndisplay remarkable ferocity when their friends, families,\nor communities are threatened.\n\n## Pastoral Pleasantries\n\nMost halflings live in small, peaceful communities with\nlarge farms and well-kept groves. They rarely build\nkingdoms of their own or even hold much land beyond\ntheir quiet shires. They typically don\u2019t recognize any sort\nof halfling nobility or royalty, instead looking to family\nelders to guide them. Families preserve their traditional\nways despite the rise and fall of empires.\n\nMany halflings live among other races, where the\nhalflings\u2019 hard work and loyal outlook offer them abundant rewards and creature comforts. Some halfling\ncommunities travel as a way of life, driving wagons or\nguiding boats from place to place and maintaining no\npermanent home.\n\n## Exploring Opportunities\n\nHalflings usually set out on the adventurer\u2019s path to defend their communities, support their friends, or explore\na wide and wonder-filled world. For them, adventuring\nis less a career than an opportunity or sometimes a\nnecessity.",
    "phases": [
        {
            "conditions": [
                {
                    "path": "sub.halfling.level",
                    "type": "eq",
                    "value": 1
                }
            ],
            "config": [],
            "name": "Halfling 2",
            "type": "config",
            "uuid": "80211004-ea9f-4e48-801f-13e480b1a7a8"
        },
        {
            "conditions": [
                {
                    "path": "sub.halfling.level",
                    "type": "eq",
                    "value": 2
                }
            ],
            "config": [],
            "name": "Halfling 3",
            "type": "config",
            "uuid": "cb457de5-3a57-4eb9-a738-58bd5fbdbdeb"
        },
        {
            "conditions": [
                {
                    "path": "sub.halfling.level",
                    "type": "eq",
                    "value": 3
                }
            ],
            "config": [],
            "name": "Halfling 4",
            "type": "config",
            "uuid": "37773780-191f-4210-9513-58d807a364ac"
        },
        {
            "conditions": [
                {
                    "path": "sub.halfling.level",
                    "type": "eq",
                    "value": 4
                }
            ],
            "config": [],
            "name": "Halfling 5",
            "type": "config",
            "uuid": "571751a9-08d6-44da-b32d-6429b2a35446"
        },
        {
            "conditions": [
                {
                    "path": "sub.halfling.level",
                    "type": "eq",
                    "value": 5
                }
            ],
            "config": [],
            "name": "Halfling 6",
            "type": "config",
            "uuid": "94353b55-0093-4cfc-b766-55436ff113ba"
        },
        {
            "conditions": [
                {
                    "path": "sub.halfling.level",
                    "type": "eq",
                    "value": 6
                }
            ],
            "config": [],
            "name": "Halfling 7",
            "type": "config",
            "uuid": "bc2942bb-eb78-4cdd-8b0c-568182c9e23b"
        },
        {
            "conditions": [
                {
                    "path": "sub.halfling.level",
                    "type": "eq",
                    "value": 7
                }
            ],
            "config": [],
            "name": "Halfling 8",
            "type": "config",
            "uuid": "0561bc34-2f29-414c-a3b4-e1c83a506fdc"
        },
        {
            "conditions": [
                {
                    "path": "sub.halfling.level",
                    "type": "eq",
                    "value": 8
                }
            ],
            "config": [],
            "name": "Halfling 9",
            "type": "config",
            "uuid": "1df2afde-493e-4829-a142-15f1ef3f73a9"
        },
        {
            "conditions": [
                {
                    "path": "sub.halfling.level",
                    "type": "eq",
                    "value": 9
                }
            ],
            "config": [],
            "name": "Halfling 10",
            "type": "config",
            "uuid": "6a488323-8696-4314-8149-9e603a361691"
        },
        {
            "conditions": [
                {
                    "path": "sub.halfling.level",
                    "type": "eq",
                    "value": 10
                }
            ],
            "config": [],
            "name": "Halfling 11",
            "type": "config",
            "uuid": "e711a4be-0dd1-4111-9f30-ef2a3b606c8b"
        },
        {
            "conditions": [
                {
                    "path": "sub.halfling.level",
                    "type": "eq",
                    "value": 11
                }
            ],
            "config": [],
            "name": "Halfling 12",
            "type": "config",
            "uuid": "86749896-b33e-4416-b68d-f34933b343cf"
        },
        {
            "conditions": [
                {
                    "path": "sub.halfling.level",
                    "type": "eq",
                    "value": 12
                }
            ],
            "config": [],
            "name": "Halfling 13",
            "type": "config",
            "uuid": "602ba0f6-47a1-4b78-8079-3b7599fd46f9"
        },
        {
            "conditions": [
                {
                    "path": "sub.halfling.level",
                    "type": "eq",
                    "value": 13
                }
            ],
            "config": [],
            "name": "Halfling 14",
            "type": "config",
            "uuid": "82e4b987-cc23-492e-b7ec-8eb8e73d2d1b"
        },
        {
            "conditions": [
                {
                    "path": "sub.halfling.level",
                    "type": "eq",
                    "value": 14
                }
            ],
            "config": [],
            "name": "Halfling 15",
            "type": "config",
            "uuid": "f27d30a7-e20f-412e-95ec-ade8fddc47b1"
        },
        {
            "conditions": [
                {
                    "path": "sub.halfling.level",
                    "type": "eq",
                    "value": 15
                }
            ],
            "config": [],
            "name": "Halfling 16",
            "type": "config",
            "uuid": "b95c425d-90ce-4995-a549-a596d33aef33"
        },
        {
            "conditions": [
                {
                    "path": "sub.halfling.level",
                    "type": "eq",
                    "value": 16
                }
            ],
            "config": [],
            "name": "Halfling 17",
            "type": "config",
            "uuid": "bdc10c6c-e2a1-4b49-9bad-373393002662"
        },
        {
            "conditions": [
                {
                    "path": "sub.halfling.level",
                    "type": "eq",
                    "value": 17
                }
            ],
            "config": [],
            "name": "Halfling 18",
            "type": "config",
            "uuid": "55f69c84-4c3d-499e-b166-80bbe1a5e5b6"
        },
        {
            "conditions": [
                {
                    "path": "sub.halfling.level",
                    "type": "eq",
                    "value": 18
                }
            ],
            "config": [],
            "name": "Halfling 19",
            "type": "config",
            "uuid": "7bcb86af-e402-4082-b483-b75b9dec7fa5"
        },
        {
            "conditions": [
                {
                    "path": "sub.halfling.level",
                    "type": "eq",
                    "value": 19
                }
            ],
            "config": [],
            "name": "Halfling 20",
            "type": "config",
            "uuid": "266dbd67-1a82-485a-af24-3c4a5f48a485"
        }
    ],
    "type": "config",
    "uuid": "9139627a-af43-45d9-991d-41d6ae621471"
}');
INSERT INTO `race` (id, name, config)
    VALUES (4, 'Human', '{
    "conditions": [
        {
            "path": "character.level",
            "type": "lte",
            "value": 1
        }
    ],
    "config": [
        {
            "description": "In the Forgotten Realms, nine human ethnic groups\nare widely recognized, though over a dozen others are ",
            "name": "Human Ethnicities",
            "options": [
                {
                    "name": "Calishite",
                    "path": "info.Calishite",
                    "type": "value",
                    "uuid": "95ce24a9-7434-40bc-8ffb-cd358ff3cdb2",
                    "value": "Shorter and slighter in build than most other humans,\nCalishites have dusky brown skin, hair, and eyes. They\u2019re\nfound primarily in southwest Faer\u00fbn."
                },
                {
                    "name": "Chondathan",
                    "path": "info.Chondathan",
                    "type": "value",
                    "uuid": "a6a82a98-4f06-4bfa-832d-a0cbe5f958c9",
                    "value": "Chondathans are slender, tawny-skinned folk with brown\nhair that ranges from almost blond to almost black.\nMost are tall and have green or brown eyes, but these\ntraits are hardly universal. Humans of Chondathan\ndescent dominate the central lands of Faer\u00fbn, around\nthe Inner Sea."
                },
                {
                    "name": "Damaran",
                    "path": "info.Damaran",
                    "type": "value",
                    "uuid": "bcf2b360-030b-455d-8b69-ab4a1df59695",
                    "value": "Found primarily in the northwest of Faer\u00fbn, Damarans\nare of moderate height and build, with skin hues ranging\nfrom tawny to fair. Their hair is usually brown or black,\nand their eye color varies widely, though brown is\nmost common."
                },
                {
                    "name": "Illuskan",
                    "path": "info.Illuskan",
                    "type": "value",
                    "uuid": "f1dec0db-5cd1-4d5a-b864-22c386e36245",
                    "value": "Illuskans are tall, fair-skinned folk with blue or steely gray\neyes. Most have raven-black hair, but those who inhabit the\nextreme northwest have blond, red, or light brown hair."
                },
                {
                    "name": "Mulan",
                    "path": "info.Mulan",
                    "type": "value",
                    "uuid": "32c4879a-0657-4b99-873b-492e4ada48d4",
                    "value": "Dominant in the eastern and southeastern shores of the\nInner Sea, the Mulan are generally tall, slim, and amberskinned, with eyes of hazel or brown. Their hair ranges\nfrom black to dark brown, but in the lands where the\nMulan are most prominent, nobles and many other Mulan\nshave off all their hair."
                },
                {
                    "name": "Rashemi",
                    "path": "info.Rashemi",
                    "type": "value",
                    "uuid": "ea6374fa-a5bb-42a8-89f5-3e25414c640f",
                    "value": "Most often found east of the Inner Sea and often\nintermingled with the Mulan, Rashemis tend to be short,\nstout, and muscular. They usually have dusky skin, dark\neyes, and thick black hair."
                },
                {
                    "name": "Shou",
                    "path": "info.Shou",
                    "type": "value",
                    "uuid": "e1065f8c-aa19-4677-b7aa-9a907d784eec",
                    "value": "The Shou are the most numerous and powerful ethnic\ngroup in Kara-Tur, far to the east of Faer\u00fbn. They are\nyellowish-bronze in hue, with black hair and dark\neyes. Shou surnames are usually presented before\nthe given name."
                },
                {
                    "name": "Tethyrian",
                    "path": "info.Tethyrian",
                    "type": "value",
                    "uuid": "5d894bbf-d887-4856-b4d6-a3e957a62cd2",
                    "value": "Widespread along the entire Sword Coast at the western edge of Faer\u00fbn, Tethyrians are of medium build\nand height, with dusky skin that tends to grow fairer the\nfarther north they dwell. Their hair and eye color varies\nwidely, but brown hair and blue eyes are the most common. Tethyrians primarily use Chondathan names."
                },
                {
                    "name": "Turami",
                    "path": "info.Turami",
                    "type": "value",
                    "uuid": "ced966bb-a499-4d8c-9757-4f5b2802daef",
                    "value": "Native to the southern shore of the Inner Sea, the\nTurami people are generally tall and muscular, with dark\nmahogany skin, curly black hair, and dark eyes."
                }
            ],
            "subtype": false,
            "type": "choice",
            "uuid": "8780284a-689a-44dc-9216-100e4115db4f"
        },
        {
            "config": [
                {
                    "hidden": true,
                    "path": "size",
                    "type": "value",
                    "uuid": "8434741e-2d95-41d4-8742-060e79eab3b4",
                    "value": "medium"
                }
            ],
            "description": "Humans vary widely in height and build, from\nbarely 5 feet to well over 6 feet tall. Regardless of your\nposition in that range, your size is Medium.",
            "name": "Size",
            "type": "config",
            "uuid": "a09565c5-4665-4db7-b43c-642bf552e60e"
        },
        {
            "config": [
                {
                    "hidden": true,
                    "path": "speed",
                    "type": "value",
                    "uuid": "2e0a0946-33ad-4978-bba6-52b3da3563ec",
                    "value": 30
                }
            ],
            "description": "Your base walking speed is 30 feet.",
            "name": "Speed",
            "type": "config",
            "uuid": "24d60959-059a-4c2d-9709-084846fc1c5e"
        },
        {
            "add": 1,
            "description": "You can speak, read, and write Common\nand one extra language of your choice. Humans typically\nlearn the languages of other peoples they deal with,\nincluding obscure dialects. They are fond of sprinkling\ntheir speech with words borrowed from other tongues:\nOrc curses, Elvish musical expressions, Dwarvish military phrases, and so on.",
            "given": [
                {
                    "id": "common",
                    "name": "Common",
                    "type": "languages"
                }
            ],
            "list": [
                "languages"
            ],
            "name": "Languages",
            "path": "proficiencies.languages",
            "type": "objectlist",
            "uuid": "7dc9b202-8249-416d-a78c-85b50e774e7a"
        },
        {
            "description": "If your campaign uses the optional feat rules from chapter 6\nof the Player\u2019s Handbook, your Dungeon Master might allow\nthese variant traits, all of which replace the human\u2019s Ability\nScore Increase trait.",
            "name": "Variant Human Traits",
            "subtype": true,
            "type": "choice",
            "uuid": "7c6ad751-3d81-4208-88d4-8eda3fd8f80e"
        }
    ],
    "description": "In the reckonings of most worlds, humans are the youngest of the common races, late to arrive on the world scene\nand short-lived in comparison to dwarves, elves, and\ndragons. Perhaps it is because of their shorter lives that\nthey strive to achieve as much as they can in the years\nthey are given. Or maybe they feel they have something\nto prove to the elder races, and that\u2019s why they build their\nmighty empires on the foundation of conquest and trade.\nWhatever drives them, humans are the innovators, the\nachievers, and the pioneers of the worlds.\n\n## A Broad Spectrum\n\nWith their penchant for migration and conquest, humans\nare more physically diverse than other common races.\nThere is no typical human. An individual can stand from\n5 feet to a little over 6 feet tall and weigh from 125 to 250\npounds. Human skin shades range from nearly black\nto very pale, and hair colors from black to blond (curly,\nkinky, or straight); males might sport facial hair that is\nsparse or thick. A lot of humans have a dash of nonhuman blood, revealing hints of elf, orc, or other lineages.\nHumans reach adulthood in their late teens and rarely\nlive even a single century.\n\n## Variety in All Things\n\nHumans are the most adaptable and ambitious people\namong the common races. They have widely varying\ntastes, morals, and customs in the many different lands\nwhere they have settled. When they settle, though, they\nstay: they build cities to last for the ages, and great kingdoms that can persist for long centuries. An individual\nhuman might have a relatively short life span, but a human nation or culture preserves traditions with origins\nfar beyond the reach of any single human\u2019s memory. They\nlive fully in the present\u2014making them well suited to the\nadventuring life\u2014but also plan for the future, striving to\nleave a lasting legacy. Individually and as a group, humans are adaptable opportunists, and they stay alert to\nchanging political and social dynamics.\n\n## Lasting Institutions\n\nWhere a single elf or dwarf might take on the responsibility of guarding a special location or a powerful secret,\nhumans found sacred orders and institutions for such\npurposes. While dwarf clans and halfling elders pass on\nthe ancient traditions to each new generation, human\ntemples, governments, libraries, and codes of law fix\ntheir traditions in the bedrock of history. Humans dream\nof immortality, but (except for those few who seek undeath or divine ascension to escape death\u2019s clutches) they\nachieve it by ensuring that they will be remembered when\nthey are gone.\n\nAlthough some humans can be xenophobic, in general\ntheir societies are inclusive. Human lands welcome large\nnumbers of nonhumans compared to the proportion of\nhumans who live in nonhuman lands.\n\n## Exemplars of Ambition\n\nHumans who seek adventure are the most daring and\nambitious members of a daring and ambitious race. They\nseek to earn glory in the eyes of their fellows by amassing\npower, wealth, and fame. More than other people, humans champion causes rather than territories or groups.",
    "phases": [
        {
            "conditions": [
                {
                    "path": "sub.human.level",
                    "type": "eq",
                    "value": 1
                }
            ],
            "config": [],
            "name": "Human 2",
            "type": "config",
            "uuid": "d35f0e7c-0cdf-45de-82dc-292f63c720e3"
        },
        {
            "conditions": [
                {
                    "path": "sub.human.level",
                    "type": "eq",
                    "value": 2
                }
            ],
            "config": [],
            "name": "Human 3",
            "type": "config",
            "uuid": "2f2c40ba-1b6a-49fd-954a-2c449377165f"
        },
        {
            "conditions": [
                {
                    "path": "sub.human.level",
                    "type": "eq",
                    "value": 3
                }
            ],
            "config": [],
            "name": "Human 4",
            "type": "config",
            "uuid": "267bcef8-0f61-4a43-b256-fc586af70eee"
        },
        {
            "conditions": [
                {
                    "path": "sub.human.level",
                    "type": "eq",
                    "value": 4
                }
            ],
            "config": [],
            "name": "Human 5",
            "type": "config",
            "uuid": "5c272cf9-fef5-4a80-b367-67ea1712d52c"
        },
        {
            "conditions": [
                {
                    "path": "sub.human.level",
                    "type": "eq",
                    "value": 5
                }
            ],
            "config": [],
            "name": "Human 6",
            "type": "config",
            "uuid": "dda081a5-d4f0-4c95-80d2-db6b4c0c929f"
        },
        {
            "conditions": [
                {
                    "path": "sub.human.level",
                    "type": "eq",
                    "value": 6
                }
            ],
            "config": [],
            "name": "Human 7",
            "type": "config",
            "uuid": "78740a58-097c-4cda-bfa0-d6cacf4c1aa7"
        },
        {
            "conditions": [
                {
                    "path": "sub.human.level",
                    "type": "eq",
                    "value": 7
                }
            ],
            "config": [],
            "name": "Human 8",
            "type": "config",
            "uuid": "dd3721e8-8dcc-4ff5-b0e1-17544dabdb3d"
        },
        {
            "conditions": [
                {
                    "path": "sub.human.level",
                    "type": "eq",
                    "value": 8
                }
            ],
            "config": [],
            "name": "Human 9",
            "type": "config",
            "uuid": "6c778b0c-97b0-42e0-8b79-9d34f89e627a"
        },
        {
            "conditions": [
                {
                    "path": "sub.human.level",
                    "type": "eq",
                    "value": 9
                }
            ],
            "config": [],
            "name": "Human 10",
            "type": "config",
            "uuid": "d2957a47-aa1e-4c5a-a55b-ec25274aa572"
        },
        {
            "conditions": [
                {
                    "path": "sub.human.level",
                    "type": "eq",
                    "value": 10
                }
            ],
            "config": [],
            "name": "Human 11",
            "type": "config",
            "uuid": "9446250d-8328-402f-bbd0-ba6d739e9766"
        },
        {
            "conditions": [
                {
                    "path": "sub.human.level",
                    "type": "eq",
                    "value": 11
                }
            ],
            "config": [],
            "name": "Human 12",
            "type": "config",
            "uuid": "6594476c-76f0-4aea-9ffe-c05a1f4d4121"
        },
        {
            "conditions": [
                {
                    "path": "sub.human.level",
                    "type": "eq",
                    "value": 12
                }
            ],
            "config": [],
            "name": "Human 13",
            "type": "config",
            "uuid": "51d885e3-d7c9-4487-8b01-0589fd8be4ae"
        },
        {
            "conditions": [
                {
                    "path": "sub.human.level",
                    "type": "eq",
                    "value": 13
                }
            ],
            "config": [],
            "name": "Human 14",
            "type": "config",
            "uuid": "e14f3609-c474-4642-84f4-120483144d40"
        },
        {
            "conditions": [
                {
                    "path": "sub.human.level",
                    "type": "eq",
                    "value": 14
                }
            ],
            "config": [],
            "name": "Human 15",
            "type": "config",
            "uuid": "557fa498-b826-4af2-b92e-cf6ef976d175"
        },
        {
            "conditions": [
                {
                    "path": "sub.human.level",
                    "type": "eq",
                    "value": 15
                }
            ],
            "config": [],
            "name": "Human 16",
            "type": "config",
            "uuid": "2b85fa43-d0aa-4d8f-a5b3-7782d9d5fc98"
        },
        {
            "conditions": [
                {
                    "path": "sub.human.level",
                    "type": "eq",
                    "value": 16
                }
            ],
            "config": [],
            "name": "Human 17",
            "type": "config",
            "uuid": "35f5c0c8-524b-4a88-acbb-06ab83f0e5da"
        },
        {
            "conditions": [
                {
                    "path": "sub.human.level",
                    "type": "eq",
                    "value": 17
                }
            ],
            "config": [],
            "name": "Human 18",
            "type": "config",
            "uuid": "b83f4e61-7cac-42d8-994a-1f07e28d74a9"
        },
        {
            "conditions": [
                {
                    "path": "sub.human.level",
                    "type": "eq",
                    "value": 18
                }
            ],
            "config": [],
            "name": "Human 19",
            "type": "config",
            "uuid": "7e656b65-0107-4294-a259-a1b6fbee0326"
        },
        {
            "conditions": [
                {
                    "path": "sub.human.level",
                    "type": "eq",
                    "value": 19
                }
            ],
            "config": [],
            "name": "Human 20",
            "type": "config",
            "uuid": "26973c37-c14b-4be1-ba14-78b9e31f6f97"
        }
    ],
    "type": "config",
    "uuid": "f41a040f-3db5-4a89-aaa5-e05ab46d3802"
}');

INSERT INTO `subrace` (id, name, race_id, config)
    VALUES (1, 'Hill Dwarf', 1, '{
    "conditions": [],
    "config": [
        {
            "config": [
                {
                    "given": [
                        1
                    ],
                    "hidden": true,
                    "multiple": true,
                    "path": "statistics.bonus.wisdom",
                    "type": "list",
                    "uuid": "2a75998f-6836-4634-99ac-1193f999facb"
                }
            ],
            "description": "Your **Wisdom** score increases by 1.",
            "name": "Ability Score Increase",
            "type": "config",
            "uuid": "4b2d5ed8-988a-47a5-bf96-af0331bec966"
        },
        {
            "config": [
                {
                    "given": [
                        "character.level"
                    ],
                    "hidden": true,
                    "multiple": true,
                    "path": "computed.hit_points.bonus",
                    "type": "list",
                    "uuid": "805f31a6-fc18-49f8-8a3f-756651e2a232"
                }
            ],
            "description": "Your hit point maximum\nincreases by 1, and it increases by 1 every time you\ngain a level.",
            "name": "Dwarven Toughness",
            "type": "config",
            "uuid": "296ffd49-0c8f-418d-9ed2-370dd895db17"
        }
    ],
    "description": "As a hill dwarf, you have keen senses, deep intuition, and\nremarkable resilience. The gold dwarves of Faer\u00fbn in\ntheir mighty southern kingdom are hill dwarves, as are\nthe exiled Neidar and the debased Klar of Krynn in the\nDragonlance setting",
    "phases": [
        {
            "conditions": [
                {
                    "path": "sub.hilldwarf.level",
                    "type": "eq",
                    "value": 1
                }
            ],
            "config": [],
            "name": "Hill Dwarf 2",
            "type": "config",
            "uuid": "0ebfdf9f-8d3e-4d5d-b398-bc0bf04872ce"
        },
        {
            "conditions": [
                {
                    "path": "sub.hilldwarf.level",
                    "type": "eq",
                    "value": 2
                }
            ],
            "config": [],
            "name": "Hill Dwarf 3",
            "type": "config",
            "uuid": "0716930f-df60-4124-9817-b6af7d2440b3"
        },
        {
            "conditions": [
                {
                    "path": "sub.hilldwarf.level",
                    "type": "eq",
                    "value": 3
                }
            ],
            "config": [],
            "name": "Hill Dwarf 4",
            "type": "config",
            "uuid": "2c67fa88-e5c5-424f-8655-46c358dea502"
        },
        {
            "conditions": [
                {
                    "path": "sub.hilldwarf.level",
                    "type": "eq",
                    "value": 4
                }
            ],
            "config": [],
            "name": "Hill Dwarf 5",
            "type": "config",
            "uuid": "4bf20162-b7b5-4043-b6f6-0f2674ea3539"
        },
        {
            "conditions": [
                {
                    "path": "sub.hilldwarf.level",
                    "type": "eq",
                    "value": 5
                }
            ],
            "config": [],
            "name": "Hill Dwarf 6",
            "type": "config",
            "uuid": "2418db90-b22f-4178-a340-050488c7b7e2"
        },
        {
            "conditions": [
                {
                    "path": "sub.hilldwarf.level",
                    "type": "eq",
                    "value": 6
                }
            ],
            "config": [],
            "name": "Hill Dwarf 7",
            "type": "config",
            "uuid": "465726d8-8e2a-4fb1-8295-c8bd9d4f69a9"
        },
        {
            "conditions": [
                {
                    "path": "sub.hilldwarf.level",
                    "type": "eq",
                    "value": 7
                }
            ],
            "config": [],
            "name": "Hill Dwarf 8",
            "type": "config",
            "uuid": "f1b61d2c-01a3-4aa8-9788-d6b12e303a81"
        },
        {
            "conditions": [
                {
                    "path": "sub.hilldwarf.level",
                    "type": "eq",
                    "value": 8
                }
            ],
            "config": [],
            "name": "Hill Dwarf 9",
            "type": "config",
            "uuid": "1bdbb25d-4102-434c-8488-85aec03f5d32"
        },
        {
            "conditions": [
                {
                    "path": "sub.hilldwarf.level",
                    "type": "eq",
                    "value": 9
                }
            ],
            "config": [],
            "name": "Hill Dwarf 10",
            "type": "config",
            "uuid": "6fea27f9-37a9-4301-8e27-18b3ea716712"
        },
        {
            "conditions": [
                {
                    "path": "sub.hilldwarf.level",
                    "type": "eq",
                    "value": 10
                }
            ],
            "config": [],
            "name": "Hill Dwarf 11",
            "type": "config",
            "uuid": "14d6c055-cf42-4726-ab2f-a91f84edcc03"
        },
        {
            "conditions": [
                {
                    "path": "sub.hilldwarf.level",
                    "type": "eq",
                    "value": 11
                }
            ],
            "config": [],
            "name": "Hill Dwarf 12",
            "type": "config",
            "uuid": "3ba49155-b848-4d07-b961-6ab7127f34c6"
        },
        {
            "conditions": [
                {
                    "path": "sub.hilldwarf.level",
                    "type": "eq",
                    "value": 12
                }
            ],
            "config": [],
            "name": "Hill Dwarf 13",
            "type": "config",
            "uuid": "10e433bd-b718-4a65-ad31-17e9ec2e45f2"
        },
        {
            "conditions": [
                {
                    "path": "sub.hilldwarf.level",
                    "type": "eq",
                    "value": 13
                }
            ],
            "config": [],
            "name": "Hill Dwarf 14",
            "type": "config",
            "uuid": "97b153b6-8d2b-4933-9730-3aee33d78a01"
        },
        {
            "conditions": [
                {
                    "path": "sub.hilldwarf.level",
                    "type": "eq",
                    "value": 14
                }
            ],
            "config": [],
            "name": "Hill Dwarf 15",
            "type": "config",
            "uuid": "eb2c9a49-75c0-43e7-87fc-229f38c8c155"
        },
        {
            "conditions": [
                {
                    "path": "sub.hilldwarf.level",
                    "type": "eq",
                    "value": 15
                }
            ],
            "config": [],
            "name": "Hill Dwarf 16",
            "type": "config",
            "uuid": "a61da632-3b72-4831-adaa-18aaab2a8710"
        },
        {
            "conditions": [
                {
                    "path": "sub.hilldwarf.level",
                    "type": "eq",
                    "value": 16
                }
            ],
            "config": [],
            "name": "Hill Dwarf 17",
            "type": "config",
            "uuid": "7a68546c-b891-48f1-bdda-218f6af7589d"
        },
        {
            "conditions": [
                {
                    "path": "sub.hilldwarf.level",
                    "type": "eq",
                    "value": 17
                }
            ],
            "config": [],
            "name": "Hill Dwarf 18",
            "type": "config",
            "uuid": "e08d66ba-9788-40dd-a9ca-f0559c0feccb"
        },
        {
            "conditions": [
                {
                    "path": "sub.hilldwarf.level",
                    "type": "eq",
                    "value": 18
                }
            ],
            "config": [],
            "name": "Hill Dwarf 19",
            "type": "config",
            "uuid": "421ff34f-f593-404f-9437-f822bd5563a6"
        },
        {
            "conditions": [
                {
                    "path": "sub.hilldwarf.level",
                    "type": "eq",
                    "value": 19
                }
            ],
            "config": [],
            "name": "Hill Dwarf 20",
            "type": "config",
            "uuid": "f096254e-08ea-422c-8e59-2446fe6b2bbf"
        }
    ],
    "type": "config",
    "uuid": "25306b59-9b26-4232-adf4-9ce0131de0d1"
}');
INSERT INTO `subrace` (id, name, race_id, config)
    VALUES (2, 'Mountain Dwarf', 1, '{
    "conditions": [],
    "config": [
        {
            "config": [
                {
                    "given": [
                        2
                    ],
                    "hidden": true,
                    "multiple": true,
                    "path": "statistics.bonus.strength",
                    "type": "list",
                    "uuid": "65acafac-a57a-41f8-8258-6bb506f94d0c"
                }
            ],
            "description": "Your **Strength** score increases by 2.",
            "name": "Ability Score Increase",
            "type": "config",
            "uuid": "bbeb2291-4443-4dd6-a936-80ed1148862d"
        },
        {
            "description": "You have proficiency with\nlight and medium armor.",
            "given": [
                {
                    "id": "light",
                    "name": "Light Armor",
                    "type": "armor_types"
                },
                {
                    "id": "medium",
                    "name": "Medium Armor",
                    "type": "armor_types"
                }
            ],
            "list": [],
            "name": "Dwarven Armor Training",
            "path": "proficiencies.armor",
            "type": "objectlist",
            "uuid": "dcab5d32-3953-4743-b14e-4f94865946cc"
        }
    ],
    "description": "As a mountain dwarf, you\u2019re strong and hardy, accustomed to a difficult life in rugged terrain. You\u2019re probably\non the tall side (for a dwarf), and tend toward lighter coloration. The shield dwarves of northern Faer\u00fbn, as well\nas the ruling Hylar clan and the noble Daewar clan of\nDragonlance, are mountain dwarves.",
    "phases": [
        {
            "conditions": [
                {
                    "path": "sub.mountaindwarf.level",
                    "type": "eq",
                    "value": 1
                }
            ],
            "config": [],
            "name": "Mountain Dwarf 2",
            "type": "config",
            "uuid": "9f000a25-2dc8-4cb7-b1d7-419676829182"
        },
        {
            "conditions": [
                {
                    "path": "sub.mountaindwarf.level",
                    "type": "eq",
                    "value": 2
                }
            ],
            "config": [],
            "name": "Mountain Dwarf 3",
            "type": "config",
            "uuid": "b30eb774-ec9f-446c-8f3a-72f2f74f1ee3"
        },
        {
            "conditions": [
                {
                    "path": "sub.mountaindwarf.level",
                    "type": "eq",
                    "value": 3
                }
            ],
            "config": [],
            "name": "Mountain Dwarf 4",
            "type": "config",
            "uuid": "83d2ba60-eede-473d-9693-e41eb9251318"
        },
        {
            "conditions": [
                {
                    "path": "sub.mountaindwarf.level",
                    "type": "eq",
                    "value": 4
                }
            ],
            "config": [],
            "name": "Mountain Dwarf 5",
            "type": "config",
            "uuid": "f150c1fb-03e5-44e2-b1e8-407851027b9f"
        },
        {
            "conditions": [
                {
                    "path": "sub.mountaindwarf.level",
                    "type": "eq",
                    "value": 5
                }
            ],
            "config": [],
            "name": "Mountain Dwarf 6",
            "type": "config",
            "uuid": "46fde2c7-1fe4-4265-a961-dc77de3c134f"
        },
        {
            "conditions": [
                {
                    "path": "sub.mountaindwarf.level",
                    "type": "eq",
                    "value": 6
                }
            ],
            "config": [],
            "name": "Mountain Dwarf 7",
            "type": "config",
            "uuid": "d60b931d-deb0-4eb2-a95a-d3a696a7739c"
        },
        {
            "conditions": [
                {
                    "path": "sub.mountaindwarf.level",
                    "type": "eq",
                    "value": 7
                }
            ],
            "config": [],
            "name": "Mountain Dwarf 8",
            "type": "config",
            "uuid": "61f1bbd0-09be-4639-89c3-0f4e758eede5"
        },
        {
            "conditions": [
                {
                    "path": "sub.mountaindwarf.level",
                    "type": "eq",
                    "value": 8
                }
            ],
            "config": [],
            "name": "Mountain Dwarf 9",
            "type": "config",
            "uuid": "b5f84ccf-2661-4563-8151-9d10148d55c0"
        },
        {
            "conditions": [
                {
                    "path": "sub.mountaindwarf.level",
                    "type": "eq",
                    "value": 9
                }
            ],
            "config": [],
            "name": "Mountain Dwarf 10",
            "type": "config",
            "uuid": "2b0416ef-1a8b-4c38-941f-337acdb69f14"
        },
        {
            "conditions": [
                {
                    "path": "sub.mountaindwarf.level",
                    "type": "eq",
                    "value": 10
                }
            ],
            "config": [],
            "name": "Mountain Dwarf 11",
            "type": "config",
            "uuid": "08dc90ef-fe44-4066-9d23-694b9b24d20b"
        },
        {
            "conditions": [
                {
                    "path": "sub.mountaindwarf.level",
                    "type": "eq",
                    "value": 11
                }
            ],
            "config": [],
            "name": "Mountain Dwarf 12",
            "type": "config",
            "uuid": "af5d768c-b683-482d-a165-8cfc194656db"
        },
        {
            "conditions": [
                {
                    "path": "sub.mountaindwarf.level",
                    "type": "eq",
                    "value": 12
                }
            ],
            "config": [],
            "name": "Mountain Dwarf 13",
            "type": "config",
            "uuid": "85319842-c93b-42b4-bf66-7cd31dc8153d"
        },
        {
            "conditions": [
                {
                    "path": "sub.mountaindwarf.level",
                    "type": "eq",
                    "value": 13
                }
            ],
            "config": [],
            "name": "Mountain Dwarf 14",
            "type": "config",
            "uuid": "448c7181-121e-4027-a06c-37002aedd3ad"
        },
        {
            "conditions": [
                {
                    "path": "sub.mountaindwarf.level",
                    "type": "eq",
                    "value": 14
                }
            ],
            "config": [],
            "name": "Mountain Dwarf 15",
            "type": "config",
            "uuid": "9c789ddd-c971-4abd-92fc-7942029699c1"
        },
        {
            "conditions": [
                {
                    "path": "sub.mountaindwarf.level",
                    "type": "eq",
                    "value": 15
                }
            ],
            "config": [],
            "name": "Mountain Dwarf 16",
            "type": "config",
            "uuid": "de7e8528-603a-4f51-8055-7dfea56dc073"
        },
        {
            "conditions": [
                {
                    "path": "sub.mountaindwarf.level",
                    "type": "eq",
                    "value": 16
                }
            ],
            "config": [],
            "name": "Mountain Dwarf 17",
            "type": "config",
            "uuid": "86bdcbea-cda6-449b-9423-3ec94416b81a"
        },
        {
            "conditions": [
                {
                    "path": "sub.mountaindwarf.level",
                    "type": "eq",
                    "value": 17
                }
            ],
            "config": [],
            "name": "Mountain Dwarf 18",
            "type": "config",
            "uuid": "b02446c6-4caf-47af-8337-224e87b51e79"
        },
        {
            "conditions": [
                {
                    "path": "sub.mountaindwarf.level",
                    "type": "eq",
                    "value": 18
                }
            ],
            "config": [],
            "name": "Mountain Dwarf 19",
            "type": "config",
            "uuid": "4ef92b0f-f7e5-4f3f-9491-5874206d7104"
        },
        {
            "conditions": [
                {
                    "path": "sub.mountaindwarf.level",
                    "type": "eq",
                    "value": 19
                }
            ],
            "config": [],
            "name": "Mountain Dwarf 20",
            "type": "config",
            "uuid": "dd8eecdc-15fb-47fe-9d01-2c2678932bc9"
        }
    ],
    "type": "config",
    "uuid": "0af3ca02-c9c1-4336-8ddd-5db7600ef287"
}');
INSERT INTO `subrace` (id, name, race_id, config)
    VALUES (3, 'High Elf', 2, '{
    "conditions": [],
    "config": [
        {
            "config": [
                {
                    "given": [
                        1
                    ],
                    "hidden": true,
                    "multiple": true,
                    "path": "statistics.bonus.intelligence",
                    "type": "list",
                    "uuid": "bfc80f5f-f645-403a-b766-1c37a2a504b5"
                }
            ],
            "description": "Your **Intelligence** score increases by `1`.",
            "name": "Ability Score Increase",
            "type": "config",
            "uuid": "6b6c4c62-23b4-4bc4-ae22-b331ec543ba7"
        },
        {
            "description": "You have proficiency with the\nlongsword, shortsword, shortbow, and longbow.",
            "given": [
                {
                    "id": 22,
                    "name": "Longsword",
                    "type": "martial melee"
                },
                {
                    "id": 27,
                    "name": "Shortsword",
                    "type": "martial melee"
                },
                {
                    "id": 14,
                    "name": "Shortbow",
                    "type": "simple ranged"
                },
                {
                    "id": 37,
                    "name": "Longbow",
                    "type": "martial ranged"
                }
            ],
            "list": [],
            "name": "Elf Weapon Training",
            "path": "proficiencies.weapons",
            "type": "objectlist",
            "uuid": "9f94d8ac-1bd5-4cdf-bcaa-57aa01cc067b"
        },
        {
            "config": [
                {
                    "add": 1,
                    "description": "You know one cantrip of your choice from the wizard spell list. **Intelligence** is your spellcasting ability for it.",
                    "filter": [
                        {
                            "field": "classes",
                            "options": [
                                "Wizard"
                            ],
                            "type": "attribute"
                        },
                        {
                            "field": "level",
                            "options": [
                                "Cantrip"
                            ],
                            "type": "attribute"
                        }
                    ],
                    "list": [
                        "spell"
                    ],
                    "name": "Cantrip",
                    "path": "sub.elf.spell.cantrips",
                    "type": "objectlist",
                    "uuid": "8e2c32c1-da29-4b02-bf48-9669088a1d9e"
                },
                {
                    "hidden": true,
                    "path": "sub.elf.spell.stat",
                    "type": "value",
                    "uuid": "12412749-6d5a-451b-87d8-878fb84d7ac2",
                    "value": "intelligence"
                },
                {
                    "config": [
                        {
                            "given": [
                                "8 + character.proficiency + statistics.modifiers.intelligence"
                            ],
                            "hidden": true,
                            "path": "computed.subElfSpellSafe_dc.formulas",
                            "type": "list",
                            "uuid": "6d119c8e-bdb7-4262-b4db-ee87ae128352"
                        },
                        {
                            "config": [
                                {
                                    "given": [
                                        "character.proficiency + statistics.modifiers.intelligence"
                                    ],
                                    "hidden": true,
                                    "path": "computed.subElfSpellAttack_modifier.formulas",
                                    "type": "list",
                                    "uuid": "39d8e825-1129-4c5e-a437-bb12967e9b6b"
                                }
                            ],
                            "description": "Your **proficiency bonus** + your **Intelligence modifier**",
                            "name": "Spell attack modifier",
                            "type": "config",
                            "uuid": "126a8d1a-7dc6-4e20-b408-a1a9e7579dac"
                        }
                    ],
                    "description": "`8` + your **Proficiency bonus** + your **Intelligence modifier**",
                    "name": "Spell save DC",
                    "type": "config",
                    "uuid": "9124368e-d1fa-42bc-8a88-90e4bf7e1b25"
                }
            ],
            "description": "Your **Intelligence** score increases by .",
            "name": "Ability Score Increase",
            "type": "config",
            "uuid": "98cceb9d-8e4d-4146-b43c-ea88080eea57"
        },
        {
            "add": 1,
            "description": "You can speak, read, and write one\nextra language of your choice.",
            "list": [
                "languages"
            ],
            "name": "Extra Language",
            "path": "proficiencies.languages",
            "type": "objectlist",
            "uuid": "f608d256-a0c1-4ba5-88d2-b463ba0fbb8a"
        }
    ],
    "description": "As a high elf, you have a keen mind and a mastery of\nat least the basics of magic. In many of the worlds of\nD&D, there are two kinds of high elves. One type (which\nincludes the gray elves and valley elves of Greyhawk,\nthe Silvanesti of Dragonlance, and the sun elves of the\nForgotten Realms) is haughty and reclusive, believing\nthemselves to be superior to non-elves and even other\nelves. The other type (including the high elves of Greyhawk, the Qualinesti of Dragonlance, and the moon elves\nof the Forgotten Realms) are more common and more\nfriendly, and often encountered among humans and\nother races.\n\nThe sun elves of Faer\u00fbn (also called gold elves or sunrise elves) have bronze skin and hair of copper, black,\nor golden blond. Their eyes are golden, silver, or black.\nMoon elves (also called silver elves or gray elves) are\nmuch paler, with alabaster skin sometimes tinged with\nblue. They often have hair of silver-white, black, or blue,\nbut various shades of blond, brown, and red are not\nuncommon. Their eyes are blue or green and flecked\nwith gold.",
    "phases": [
        {
            "conditions": [
                {
                    "path": "sub.highelf.level",
                    "type": "eq",
                    "value": 1
                }
            ],
            "config": [],
            "name": "High Elf 2",
            "type": "config",
            "uuid": "93a8f69a-48c3-44fe-b44d-c71720aa7c68"
        },
        {
            "conditions": [
                {
                    "path": "sub.highelf.level",
                    "type": "eq",
                    "value": 2
                }
            ],
            "config": [],
            "name": "High Elf 3",
            "type": "config",
            "uuid": "60e78dfa-9211-4dd2-ada0-caca6ed356ec"
        },
        {
            "conditions": [
                {
                    "path": "sub.highelf.level",
                    "type": "eq",
                    "value": 3
                }
            ],
            "config": [],
            "name": "High Elf 4",
            "type": "config",
            "uuid": "c45e319c-a750-4339-b268-478a6e30e338"
        },
        {
            "conditions": [
                {
                    "path": "sub.highelf.level",
                    "type": "eq",
                    "value": 4
                }
            ],
            "config": [],
            "name": "High Elf 5",
            "type": "config",
            "uuid": "03e95919-5b9d-4498-b689-f1bbf50a67e5"
        },
        {
            "conditions": [
                {
                    "path": "sub.highelf.level",
                    "type": "eq",
                    "value": 5
                }
            ],
            "config": [],
            "name": "High Elf 6",
            "type": "config",
            "uuid": "9649a66a-237f-4d0a-965b-08ac69d48e90"
        },
        {
            "conditions": [
                {
                    "path": "sub.highelf.level",
                    "type": "eq",
                    "value": 6
                }
            ],
            "config": [],
            "name": "High Elf 7",
            "type": "config",
            "uuid": "17f3742e-900b-4e31-87ef-8341b512414d"
        },
        {
            "conditions": [
                {
                    "path": "sub.highelf.level",
                    "type": "eq",
                    "value": 7
                }
            ],
            "config": [],
            "name": "High Elf 8",
            "type": "config",
            "uuid": "f4d57b98-4f00-43e4-b08c-4fcc943ffd79"
        },
        {
            "conditions": [
                {
                    "path": "sub.highelf.level",
                    "type": "eq",
                    "value": 8
                }
            ],
            "config": [],
            "name": "High Elf 9",
            "type": "config",
            "uuid": "deae40e8-c719-4d7b-92f9-ee1b2d36a979"
        },
        {
            "conditions": [
                {
                    "path": "sub.highelf.level",
                    "type": "eq",
                    "value": 9
                }
            ],
            "config": [],
            "name": "High Elf 10",
            "type": "config",
            "uuid": "7401fbe5-81b1-4d1e-b45a-706397e07caa"
        },
        {
            "conditions": [
                {
                    "path": "sub.highelf.level",
                    "type": "eq",
                    "value": 10
                }
            ],
            "config": [],
            "name": "High Elf 11",
            "type": "config",
            "uuid": "18550a53-cc1e-49be-9232-57f5cc891cbb"
        },
        {
            "conditions": [
                {
                    "path": "sub.highelf.level",
                    "type": "eq",
                    "value": 11
                }
            ],
            "config": [],
            "name": "High Elf 12",
            "type": "config",
            "uuid": "db1e27d1-0aef-492d-866b-569e0612a554"
        },
        {
            "conditions": [
                {
                    "path": "sub.highelf.level",
                    "type": "eq",
                    "value": 12
                }
            ],
            "config": [],
            "name": "High Elf 13",
            "type": "config",
            "uuid": "6c16e35a-5f3d-4b7a-96d6-f2964cc483e5"
        },
        {
            "conditions": [
                {
                    "path": "sub.highelf.level",
                    "type": "eq",
                    "value": 13
                }
            ],
            "config": [],
            "name": "High Elf 14",
            "type": "config",
            "uuid": "1e82f0d5-908c-4e3f-a6ed-4dd3359e00bb"
        },
        {
            "conditions": [
                {
                    "path": "sub.highelf.level",
                    "type": "eq",
                    "value": 14
                }
            ],
            "config": [],
            "name": "High Elf 15",
            "type": "config",
            "uuid": "2d02914c-7e05-4401-8433-bb2b07a6b892"
        },
        {
            "conditions": [
                {
                    "path": "sub.highelf.level",
                    "type": "eq",
                    "value": 15
                }
            ],
            "config": [],
            "name": "High Elf 16",
            "type": "config",
            "uuid": "d2951a84-fa7c-4bea-bebe-0e0426dda215"
        },
        {
            "conditions": [
                {
                    "path": "sub.highelf.level",
                    "type": "eq",
                    "value": 16
                }
            ],
            "config": [],
            "name": "High Elf 17",
            "type": "config",
            "uuid": "0ea3eca8-3c98-479d-9514-7a33fd5a2a81"
        },
        {
            "conditions": [
                {
                    "path": "sub.highelf.level",
                    "type": "eq",
                    "value": 17
                }
            ],
            "config": [],
            "name": "High Elf 18",
            "type": "config",
            "uuid": "2f5a967b-84c3-4c7e-ae78-29b7d23e9b8d"
        },
        {
            "conditions": [
                {
                    "path": "sub.highelf.level",
                    "type": "eq",
                    "value": 18
                }
            ],
            "config": [],
            "name": "High Elf 19",
            "type": "config",
            "uuid": "3d3123ab-7c1c-4e18-bc3a-2ce060516bfb"
        },
        {
            "conditions": [
                {
                    "path": "sub.highelf.level",
                    "type": "eq",
                    "value": 19
                }
            ],
            "config": [],
            "name": "High Elf 20",
            "type": "config",
            "uuid": "de13b38a-35f8-430e-a58d-b97d85331890"
        }
    ],
    "type": "config",
    "uuid": "037005f2-2b29-4f48-9ea4-8bf4c8ca6b4f"
}');
INSERT INTO `subrace` (id, name, race_id, config)
    VALUES (4, 'Wood Elf', 2, '{
    "conditions": [],
    "config": [
        {
            "config": [
                {
                    "given": [
                        1
                    ],
                    "hidden": true,
                    "multiple": true,
                    "path": "statistics.bonus.wisdom",
                    "type": "list",
                    "uuid": "96838f67-4514-4607-a29e-375baf3e9da7"
                }
            ],
            "description": "Your **Wisdom** score increases by 1.",
            "name": "Ability Score Increase",
            "type": "config",
            "uuid": "4b938641-c89e-4412-9940-f4f5121c7a43"
        },
        {
            "description": "You have proficiency with the longsword, shortsword, shortbow, and longbow.",
            "given": [
                {
                    "id": 22,
                    "name": "Longsword",
                    "type": "martial melee"
                },
                {
                    "id": 27,
                    "name": "Shortsword",
                    "type": "martial melee"
                },
                {
                    "id": 14,
                    "name": "Shortbow",
                    "type": "simple ranged"
                },
                {
                    "id": 37,
                    "name": "Longbow",
                    "type": "martial ranged"
                }
            ],
            "list": [],
            "name": "Elf Weapon Training",
            "path": "proficiencies.weapons",
            "type": "objectlist",
            "uuid": "79ed548d-aa2c-45bb-abf7-c91287db492b"
        },
        {
            "config": [
                {
                    "hidden": true,
                    "path": "speed",
                    "type": "value",
                    "uuid": "cfe8a812-caa3-4093-9ccc-5d5b37777ff8",
                    "value": 35
                }
            ],
            "description": "Your base walking speed increases\nto 35 feet.",
            "name": "Fleet of Foot",
            "type": "config",
            "uuid": "688b6d5f-1a29-4a3f-b5ce-2f22ddf2aab7"
        },
        {
            "name": "Mask of the Wild",
            "path": "info.Mask of the Wild",
            "type": "value",
            "uuid": "7a43df59-d8d1-4e92-9109-4bb26ffb600d",
            "value": "You can attempt to hide even when\nyou are only lightly obscured by foliage, heavy rain, falling snow, mist, and other natural phenomena"
        }
    ],
    "description": "As a wood elf, you have keen senses and intuition, and\nyour fleet feet carry you quickly and stealthily through\nyour native forests. This category includes the wild elves\n(grugach) of Greyhawk and the Kagonesti of Dragonlance, as well as the races called wood elves in Greyhawk\nand the Forgotten Realms. In Faer\u00fbn, wood elves (also\ncalled wild elves, green elves, or forest elves) are reclusive and distrusting of non-elves.\n\nWood elves\u2019 skin tends to be copperish in hue, sometimes with traces of green. Their hair tends toward\nbrowns and blacks, but it is occasionally blond or copper-colored. Their eyes are green, brown, or hazel.",
    "phases": [
        {
            "conditions": [
                {
                    "path": "sub.woodelf.level",
                    "type": "eq",
                    "value": 1
                }
            ],
            "config": [],
            "name": "Wood Elf 2",
            "type": "config",
            "uuid": "6d146b86-f72d-4eef-8e9f-7332144fe6f6"
        },
        {
            "conditions": [
                {
                    "path": "sub.woodelf.level",
                    "type": "eq",
                    "value": 2
                }
            ],
            "config": [],
            "name": "Wood Elf 3",
            "type": "config",
            "uuid": "e9768964-df60-42d5-aebc-d74d20113fa6"
        },
        {
            "conditions": [
                {
                    "path": "sub.woodelf.level",
                    "type": "eq",
                    "value": 3
                }
            ],
            "config": [],
            "name": "Wood Elf 4",
            "type": "config",
            "uuid": "69b10248-964e-4caa-8a0b-28945b45ce41"
        },
        {
            "conditions": [
                {
                    "path": "sub.woodelf.level",
                    "type": "eq",
                    "value": 4
                }
            ],
            "config": [],
            "name": "Wood Elf 5",
            "type": "config",
            "uuid": "779149e8-ac80-4e81-a6f8-38333764a704"
        },
        {
            "conditions": [
                {
                    "path": "sub.woodelf.level",
                    "type": "eq",
                    "value": 5
                }
            ],
            "config": [],
            "name": "Wood Elf 6",
            "type": "config",
            "uuid": "dc85cd49-1f2c-4714-9c57-1450801a9dbc"
        },
        {
            "conditions": [
                {
                    "path": "sub.woodelf.level",
                    "type": "eq",
                    "value": 6
                }
            ],
            "config": [],
            "name": "Wood Elf 7",
            "type": "config",
            "uuid": "929b6239-42a5-4a87-b251-588313b2df06"
        },
        {
            "conditions": [
                {
                    "path": "sub.woodelf.level",
                    "type": "eq",
                    "value": 7
                }
            ],
            "config": [],
            "name": "Wood Elf 8",
            "type": "config",
            "uuid": "14c994a1-f3ea-41a1-bf1d-889db7b9f79b"
        },
        {
            "conditions": [
                {
                    "path": "sub.woodelf.level",
                    "type": "eq",
                    "value": 8
                }
            ],
            "config": [],
            "name": "Wood Elf 9",
            "type": "config",
            "uuid": "7a442213-b598-4795-b5a2-6b8d0050ec3f"
        },
        {
            "conditions": [
                {
                    "path": "sub.woodelf.level",
                    "type": "eq",
                    "value": 9
                }
            ],
            "config": [],
            "name": "Wood Elf 10",
            "type": "config",
            "uuid": "470dfcc4-9850-41ac-bb96-b71049507e4d"
        },
        {
            "conditions": [
                {
                    "path": "sub.woodelf.level",
                    "type": "eq",
                    "value": 10
                }
            ],
            "config": [],
            "name": "Wood Elf 11",
            "type": "config",
            "uuid": "ee699cf1-8c28-4b05-a7b3-1c132bad7629"
        },
        {
            "conditions": [
                {
                    "path": "sub.woodelf.level",
                    "type": "eq",
                    "value": 11
                }
            ],
            "config": [],
            "name": "Wood Elf 12",
            "type": "config",
            "uuid": "8bf15572-2047-4083-b504-db0201ecbed1"
        },
        {
            "conditions": [
                {
                    "path": "sub.woodelf.level",
                    "type": "eq",
                    "value": 12
                }
            ],
            "config": [],
            "name": "Wood Elf 13",
            "type": "config",
            "uuid": "f77768cf-687e-4639-988c-f83313ac7950"
        },
        {
            "conditions": [
                {
                    "path": "sub.woodelf.level",
                    "type": "eq",
                    "value": 13
                }
            ],
            "config": [],
            "name": "Wood Elf 14",
            "type": "config",
            "uuid": "44ff6786-bd09-47a5-83b2-6ec060aa7da6"
        },
        {
            "conditions": [
                {
                    "path": "sub.woodelf.level",
                    "type": "eq",
                    "value": 14
                }
            ],
            "config": [],
            "name": "Wood Elf 15",
            "type": "config",
            "uuid": "3e55529e-7884-423f-87f5-2df2eef60cdd"
        },
        {
            "conditions": [
                {
                    "path": "sub.woodelf.level",
                    "type": "eq",
                    "value": 15
                }
            ],
            "config": [],
            "name": "Wood Elf 16",
            "type": "config",
            "uuid": "74e92e9c-b26b-4cb3-a89c-14c076533fb4"
        },
        {
            "conditions": [
                {
                    "path": "sub.woodelf.level",
                    "type": "eq",
                    "value": 16
                }
            ],
            "config": [],
            "name": "Wood Elf 17",
            "type": "config",
            "uuid": "29bf6f67-e949-4090-8bdf-863df7407bbf"
        },
        {
            "conditions": [
                {
                    "path": "sub.woodelf.level",
                    "type": "eq",
                    "value": 17
                }
            ],
            "config": [],
            "name": "Wood Elf 18",
            "type": "config",
            "uuid": "2b38c6c5-124e-42c7-8e42-d01a8553db6c"
        },
        {
            "conditions": [
                {
                    "path": "sub.woodelf.level",
                    "type": "eq",
                    "value": 18
                }
            ],
            "config": [],
            "name": "Wood Elf 19",
            "type": "config",
            "uuid": "c947ec75-5043-4e7c-8e06-05d69a86322c"
        },
        {
            "conditions": [
                {
                    "path": "sub.woodelf.level",
                    "type": "eq",
                    "value": 19
                }
            ],
            "config": [],
            "name": "Wood Elf 20",
            "type": "config",
            "uuid": "971526a9-0921-46c0-9c17-4aa2ea6acd19"
        }
    ],
    "type": "config",
    "uuid": "961bd14e-d13a-48bd-9c95-71caa2e22677"
}');
INSERT INTO `subrace` (id, name, race_id, config)
    VALUES (5, 'Lightfoot Halfling', 3, '{
    "conditions": [],
    "config": [
        {
            "config": [
                {
                    "given": [
                        1
                    ],
                    "hidden": true,
                    "multiple": true,
                    "path": "statistics.bonus.charisma",
                    "type": "list",
                    "uuid": "1297ce13-6ecc-4125-91b5-e60d90a1ffa7"
                }
            ],
            "description": "Your **Charisma** score increases by 1.",
            "name": "Ability Score Increase",
            "type": "config",
            "uuid": "f1b4c095-6149-4c57-b90b-994b5f5758aa"
        },
        {
            "name": "Naturally Stealthy",
            "path": "info.Naturally Stealthy",
            "type": "value",
            "uuid": "cab6acd4-05e5-4c30-b5d3-892efa3ad5f8",
            "value": "You can attempt to hide even when\nyou are obscured only by a creature that is at least one\nsize larger than you."
        }
    ],
    "description": "As a lightfoot halfling, you can easily hide from notice,\neven using other people as cover. You\u2019re inclined to be\naffable and get along well with others. In the Forgotten\nRealms, lightfoot halflings have spread the farthest and\nthus are the most common variety.\nLightfoots are more prone to wanderlust than other halflings, and often dwell alongside other races or take up a\nnomadic life. In the world of Greyhawk, these halflings\nare called hairfeet or tallfellows.",
    "phases": [
        {
            "conditions": [
                {
                    "path": "sub.lightfoothalfling.level",
                    "type": "eq",
                    "value": 1
                }
            ],
            "config": [],
            "name": "Lightfoot Halfling 2",
            "type": "config",
            "uuid": "75bf7388-c843-4e23-a04f-c0309967f5f0"
        },
        {
            "conditions": [
                {
                    "path": "sub.lightfoothalfling.level",
                    "type": "eq",
                    "value": 2
                }
            ],
            "config": [],
            "name": "Lightfoot Halfling 3",
            "type": "config",
            "uuid": "25fa666c-efd2-4d2b-832c-b81302ad22e6"
        },
        {
            "conditions": [
                {
                    "path": "sub.lightfoothalfling.level",
                    "type": "eq",
                    "value": 3
                }
            ],
            "config": [],
            "name": "Lightfoot Halfling 4",
            "type": "config",
            "uuid": "5a6bfd03-b8a5-45ab-b49f-dc9de9677340"
        },
        {
            "conditions": [
                {
                    "path": "sub.lightfoothalfling.level",
                    "type": "eq",
                    "value": 4
                }
            ],
            "config": [],
            "name": "Lightfoot Halfling 5",
            "type": "config",
            "uuid": "e7c12f5a-eede-4cc3-b07a-62dee2769547"
        },
        {
            "conditions": [
                {
                    "path": "sub.lightfoothalfling.level",
                    "type": "eq",
                    "value": 5
                }
            ],
            "config": [],
            "name": "Lightfoot Halfling 6",
            "type": "config",
            "uuid": "50c84ea4-f72d-4df5-bc10-c4bc18942a57"
        },
        {
            "conditions": [
                {
                    "path": "sub.lightfoothalfling.level",
                    "type": "eq",
                    "value": 6
                }
            ],
            "config": [],
            "name": "Lightfoot Halfling 7",
            "type": "config",
            "uuid": "137dd99b-e821-41cc-bc7b-1e6e053a87fc"
        },
        {
            "conditions": [
                {
                    "path": "sub.lightfoothalfling.level",
                    "type": "eq",
                    "value": 7
                }
            ],
            "config": [],
            "name": "Lightfoot Halfling 8",
            "type": "config",
            "uuid": "e015758a-0727-4077-8297-c318d43de56f"
        },
        {
            "conditions": [
                {
                    "path": "sub.lightfoothalfling.level",
                    "type": "eq",
                    "value": 8
                }
            ],
            "config": [],
            "name": "Lightfoot Halfling 9",
            "type": "config",
            "uuid": "013a67d9-7280-468d-9f7d-e8f08cbab42a"
        },
        {
            "conditions": [
                {
                    "path": "sub.lightfoothalfling.level",
                    "type": "eq",
                    "value": 9
                }
            ],
            "config": [],
            "name": "Lightfoot Halfling 10",
            "type": "config",
            "uuid": "adf1b0c7-f0ce-4a85-a70e-e49c3a64b75a"
        },
        {
            "conditions": [
                {
                    "path": "sub.lightfoothalfling.level",
                    "type": "eq",
                    "value": 10
                }
            ],
            "config": [],
            "name": "Lightfoot Halfling 11",
            "type": "config",
            "uuid": "e9f40348-a469-43ba-b17f-8798c74ee8ea"
        },
        {
            "conditions": [
                {
                    "path": "sub.lightfoothalfling.level",
                    "type": "eq",
                    "value": 11
                }
            ],
            "config": [],
            "name": "Lightfoot Halfling 12",
            "type": "config",
            "uuid": "6f3bd9d1-f9b8-4a14-9201-42520de1d754"
        },
        {
            "conditions": [
                {
                    "path": "sub.lightfoothalfling.level",
                    "type": "eq",
                    "value": 12
                }
            ],
            "config": [],
            "name": "Lightfoot Halfling 13",
            "type": "config",
            "uuid": "8920e5ef-c121-4ac7-8934-89269e1b8642"
        },
        {
            "conditions": [
                {
                    "path": "sub.lightfoothalfling.level",
                    "type": "eq",
                    "value": 13
                }
            ],
            "config": [],
            "name": "Lightfoot Halfling 14",
            "type": "config",
            "uuid": "a05172de-b8e6-4eb8-b4f7-37fb7be4b5be"
        },
        {
            "conditions": [
                {
                    "path": "sub.lightfoothalfling.level",
                    "type": "eq",
                    "value": 14
                }
            ],
            "config": [],
            "name": "Lightfoot Halfling 15",
            "type": "config",
            "uuid": "017e43dd-56ef-40e8-8fec-7feeee34f79b"
        },
        {
            "conditions": [
                {
                    "path": "sub.lightfoothalfling.level",
                    "type": "eq",
                    "value": 15
                }
            ],
            "config": [],
            "name": "Lightfoot Halfling 16",
            "type": "config",
            "uuid": "d3ec6f78-dddb-443e-bf61-dc1337b06407"
        },
        {
            "conditions": [
                {
                    "path": "sub.lightfoothalfling.level",
                    "type": "eq",
                    "value": 16
                }
            ],
            "config": [],
            "name": "Lightfoot Halfling 17",
            "type": "config",
            "uuid": "4d17cf82-8e6b-497d-9edf-eeea8db078b9"
        },
        {
            "conditions": [
                {
                    "path": "sub.lightfoothalfling.level",
                    "type": "eq",
                    "value": 17
                }
            ],
            "config": [],
            "name": "Lightfoot Halfling 18",
            "type": "config",
            "uuid": "4b826cb5-db75-4c00-a80f-03b8e188674f"
        },
        {
            "conditions": [
                {
                    "path": "sub.lightfoothalfling.level",
                    "type": "eq",
                    "value": 18
                }
            ],
            "config": [],
            "name": "Lightfoot Halfling 19",
            "type": "config",
            "uuid": "f3cc49b4-cc5c-44e5-b055-410b43bc352d"
        },
        {
            "conditions": [
                {
                    "path": "sub.lightfoothalfling.level",
                    "type": "eq",
                    "value": 19
                }
            ],
            "config": [],
            "name": "Lightfoot Halfling 20",
            "type": "config",
            "uuid": "4633d2e2-d0e9-4380-b2ac-d60522b52e32"
        }
    ],
    "type": "config",
    "uuid": "b22d5fba-1ed5-486f-b6a9-88a57a2064a0"
}');
INSERT INTO `subrace` (id, name, race_id, config)
    VALUES (6, 'Stout Halfling', 3, '{
    "conditions": [],
    "config": [
        {
            "config": [
                {
                    "given": [
                        1
                    ],
                    "hidden": true,
                    "multiple": true,
                    "path": "statistics.bonus.constitution",
                    "type": "list",
                    "uuid": "25f9fc1b-0cbd-45e1-93c3-c611083bbc1e"
                }
            ],
            "description": "Your **Constitution** score increases by 1.",
            "name": "Ability Score Increase",
            "type": "config",
            "uuid": "8ac5c882-343b-4f54-aeea-4bb70b6549a6"
        },
        {
            "name": "Stout Resilience",
            "path": "info.Stout Resilience",
            "type": "value",
            "uuid": "d399b7a0-d6c2-4ffd-81a9-92bf8a4379d7",
            "value": "You have advantage on saving\nthrows against poison, and you have resistance against\npoison damage."
        }
    ],
    "description": "As a stout halfling, you\u2019re hardier than average and have\nsome resistance to poison. Some say that stouts have\ndwarven blood. In the Forgotten Realms, these halflings\nare called stronghearts, and they\u2019re most common in\nthe south.",
    "phases": [
        {
            "conditions": [
                {
                    "path": "sub.stouthalfling.level",
                    "type": "eq",
                    "value": 1
                }
            ],
            "config": [],
            "name": "Stout Halfling 2",
            "type": "config",
            "uuid": "bbdc3ff4-72ac-463a-888e-868facb43c38"
        },
        {
            "conditions": [
                {
                    "path": "sub.stouthalfling.level",
                    "type": "eq",
                    "value": 2
                }
            ],
            "config": [],
            "name": "Stout Halfling 3",
            "type": "config",
            "uuid": "1f7fba80-15d8-42fe-8200-c558b55780c5"
        },
        {
            "conditions": [
                {
                    "path": "sub.stouthalfling.level",
                    "type": "eq",
                    "value": 3
                }
            ],
            "config": [],
            "name": "Stout Halfling 4",
            "type": "config",
            "uuid": "2998e987-0d1a-4861-830f-11a8bc852126"
        },
        {
            "conditions": [
                {
                    "path": "sub.stouthalfling.level",
                    "type": "eq",
                    "value": 4
                }
            ],
            "config": [],
            "name": "Stout Halfling 5",
            "type": "config",
            "uuid": "4f762314-8d50-477a-9064-bf12cc51f37e"
        },
        {
            "conditions": [
                {
                    "path": "sub.stouthalfling.level",
                    "type": "eq",
                    "value": 5
                }
            ],
            "config": [],
            "name": "Stout Halfling 6",
            "type": "config",
            "uuid": "f76cbe1b-0538-4b08-a620-869fc822dc70"
        },
        {
            "conditions": [
                {
                    "path": "sub.stouthalfling.level",
                    "type": "eq",
                    "value": 6
                }
            ],
            "config": [],
            "name": "Stout Halfling 7",
            "type": "config",
            "uuid": "a5b2038d-d588-4cbc-8d4e-1d1c299b3a51"
        },
        {
            "conditions": [
                {
                    "path": "sub.stouthalfling.level",
                    "type": "eq",
                    "value": 7
                }
            ],
            "config": [],
            "name": "Stout Halfling 8",
            "type": "config",
            "uuid": "41fa8c4b-eddb-4a53-85c0-1a29218751bf"
        },
        {
            "conditions": [
                {
                    "path": "sub.stouthalfling.level",
                    "type": "eq",
                    "value": 8
                }
            ],
            "config": [],
            "name": "Stout Halfling 9",
            "type": "config",
            "uuid": "c2d7a45d-155e-42ca-85ff-73a3c0f01b5e"
        },
        {
            "conditions": [
                {
                    "path": "sub.stouthalfling.level",
                    "type": "eq",
                    "value": 9
                }
            ],
            "config": [],
            "name": "Stout Halfling 10",
            "type": "config",
            "uuid": "b493c03c-6511-4333-af81-7c959ffeedf1"
        },
        {
            "conditions": [
                {
                    "path": "sub.stouthalfling.level",
                    "type": "eq",
                    "value": 10
                }
            ],
            "config": [],
            "name": "Stout Halfling 11",
            "type": "config",
            "uuid": "53fa87e8-eb2a-4333-8a6d-6584e8451250"
        },
        {
            "conditions": [
                {
                    "path": "sub.stouthalfling.level",
                    "type": "eq",
                    "value": 11
                }
            ],
            "config": [],
            "name": "Stout Halfling 12",
            "type": "config",
            "uuid": "327451cd-055e-4b41-ac69-4937dc55df5b"
        },
        {
            "conditions": [
                {
                    "path": "sub.stouthalfling.level",
                    "type": "eq",
                    "value": 12
                }
            ],
            "config": [],
            "name": "Stout Halfling 13",
            "type": "config",
            "uuid": "b0037668-39da-49b4-a33e-f138fa09908e"
        },
        {
            "conditions": [
                {
                    "path": "sub.stouthalfling.level",
                    "type": "eq",
                    "value": 13
                }
            ],
            "config": [],
            "name": "Stout Halfling 14",
            "type": "config",
            "uuid": "02b1d2dd-648e-4766-878c-f7f730330452"
        },
        {
            "conditions": [
                {
                    "path": "sub.stouthalfling.level",
                    "type": "eq",
                    "value": 14
                }
            ],
            "config": [],
            "name": "Stout Halfling 15",
            "type": "config",
            "uuid": "acf17aaf-c56f-41b8-8df2-d6234b72b7bd"
        },
        {
            "conditions": [
                {
                    "path": "sub.stouthalfling.level",
                    "type": "eq",
                    "value": 15
                }
            ],
            "config": [],
            "name": "Stout Halfling 16",
            "type": "config",
            "uuid": "05d59bc4-7e70-4cdf-9808-780698a7c746"
        },
        {
            "conditions": [
                {
                    "path": "sub.stouthalfling.level",
                    "type": "eq",
                    "value": 16
                }
            ],
            "config": [],
            "name": "Stout Halfling 17",
            "type": "config",
            "uuid": "890cb979-bcab-457e-b8c8-18f8bc8ccca4"
        },
        {
            "conditions": [
                {
                    "path": "sub.stouthalfling.level",
                    "type": "eq",
                    "value": 17
                }
            ],
            "config": [],
            "name": "Stout Halfling 18",
            "type": "config",
            "uuid": "7b1e505e-c747-43e4-bc12-77ff19085abf"
        },
        {
            "conditions": [
                {
                    "path": "sub.stouthalfling.level",
                    "type": "eq",
                    "value": 18
                }
            ],
            "config": [],
            "name": "Stout Halfling 19",
            "type": "config",
            "uuid": "21f46b0e-3956-4512-b8db-4dd1f5f26f02"
        },
        {
            "conditions": [
                {
                    "path": "sub.stouthalfling.level",
                    "type": "eq",
                    "value": 19
                }
            ],
            "config": [],
            "name": "Stout Halfling 20",
            "type": "config",
            "uuid": "2dbd0622-4b6c-4746-8afe-5d2008b395f1"
        }
    ],
    "type": "config",
    "uuid": "981998de-c1f7-4309-9586-0ea6801101d9"
}');
INSERT INTO `subrace` (id, name, race_id, config)
    VALUES (7, 'Standard Human', 4, '{
    "conditions": [],
    "config": [
        {
            "config": [
                {
                    "given": [
                        1
                    ],
                    "hidden": true,
                    "multiple": true,
                    "path": "statistics.bonus.strength",
                    "type": "list",
                    "uuid": "451a0522-f778-4f1c-9168-431b6dd3655e"
                },
                {
                    "given": [
                        1
                    ],
                    "hidden": true,
                    "multiple": true,
                    "path": "statistics.bonus.dexterity",
                    "type": "list",
                    "uuid": "209b3b0c-d2f5-4b67-b207-5ec7fb0aabbd"
                },
                {
                    "given": [
                        1
                    ],
                    "hidden": true,
                    "multiple": true,
                    "path": "statistics.bonus.constitution",
                    "type": "list",
                    "uuid": "e5271fe0-a8af-4956-be9f-5d163c161567"
                },
                {
                    "given": [
                        1
                    ],
                    "hidden": true,
                    "multiple": true,
                    "path": "statistics.bonus.wisdom",
                    "type": "list",
                    "uuid": "cc8405ff-1f5f-4043-9c97-c7f4a9242b14"
                },
                {
                    "given": [
                        1
                    ],
                    "hidden": true,
                    "multiple": true,
                    "path": "statistics.bonus.intelligence",
                    "type": "list",
                    "uuid": "7becd814-af71-4e7a-a7c9-14863a400a9f"
                },
                {
                    "given": [
                        1
                    ],
                    "hidden": true,
                    "multiple": true,
                    "path": "statistics.bonus.charisma",
                    "type": "list",
                    "uuid": "fb8480b7-836e-462b-a2f2-9aeb8c5a6b52"
                }
            ],
            "description": "Your ability scores each increase by 1.",
            "name": "Ability Score Increase",
            "type": "config",
            "uuid": "4f6998ce-72d7-4c79-b893-bb33e8dfe382"
        }
    ],
    "description": "",
    "phases": [
        {
            "conditions": [
                {
                    "path": "sub.standardhuman.level",
                    "type": "eq",
                    "value": 1
                }
            ],
            "config": [],
            "name": "Standard Human 2",
            "type": "config",
            "uuid": "2ab582c4-602b-48a3-b432-0c574cca7010"
        },
        {
            "conditions": [
                {
                    "path": "sub.standardhuman.level",
                    "type": "eq",
                    "value": 2
                }
            ],
            "config": [],
            "name": "Standard Human 3",
            "type": "config",
            "uuid": "88ac92ae-e703-4303-a027-f64cc9ba1290"
        },
        {
            "conditions": [
                {
                    "path": "sub.standardhuman.level",
                    "type": "eq",
                    "value": 3
                }
            ],
            "config": [],
            "name": "Standard Human 4",
            "type": "config",
            "uuid": "e6e93f30-bf40-460c-ab9d-a88299a39fec"
        },
        {
            "conditions": [
                {
                    "path": "sub.standardhuman.level",
                    "type": "eq",
                    "value": 4
                }
            ],
            "config": [],
            "name": "Standard Human 5",
            "type": "config",
            "uuid": "cb5eea30-a249-4469-910f-d4e5c8116792"
        },
        {
            "conditions": [
                {
                    "path": "sub.standardhuman.level",
                    "type": "eq",
                    "value": 5
                }
            ],
            "config": [],
            "name": "Standard Human 6",
            "type": "config",
            "uuid": "e079bc77-66a5-4eb4-9108-11f2c93ce2e2"
        },
        {
            "conditions": [
                {
                    "path": "sub.standardhuman.level",
                    "type": "eq",
                    "value": 6
                }
            ],
            "config": [],
            "name": "Standard Human 7",
            "type": "config",
            "uuid": "f3fafd55-9cbe-41ae-b598-f19e847cd635"
        },
        {
            "conditions": [
                {
                    "path": "sub.standardhuman.level",
                    "type": "eq",
                    "value": 7
                }
            ],
            "config": [],
            "name": "Standard Human 8",
            "type": "config",
            "uuid": "269167d8-d1b5-4404-a985-8c346e354c67"
        },
        {
            "conditions": [
                {
                    "path": "sub.standardhuman.level",
                    "type": "eq",
                    "value": 8
                }
            ],
            "config": [],
            "name": "Standard Human 9",
            "type": "config",
            "uuid": "ac08d03a-69b4-4623-97e7-c55f26c89bb8"
        },
        {
            "conditions": [
                {
                    "path": "sub.standardhuman.level",
                    "type": "eq",
                    "value": 9
                }
            ],
            "config": [],
            "name": "Standard Human 10",
            "type": "config",
            "uuid": "c7d60bbe-c34b-4080-a53d-a3f90cabafbd"
        },
        {
            "conditions": [
                {
                    "path": "sub.standardhuman.level",
                    "type": "eq",
                    "value": 10
                }
            ],
            "config": [],
            "name": "Standard Human 11",
            "type": "config",
            "uuid": "cc3cd9d6-0a2c-4fdb-9305-b33978d777ff"
        },
        {
            "conditions": [
                {
                    "path": "sub.standardhuman.level",
                    "type": "eq",
                    "value": 11
                }
            ],
            "config": [],
            "name": "Standard Human 12",
            "type": "config",
            "uuid": "c55b521b-23c4-45f4-a758-9b860e731597"
        },
        {
            "conditions": [
                {
                    "path": "sub.standardhuman.level",
                    "type": "eq",
                    "value": 12
                }
            ],
            "config": [],
            "name": "Standard Human 13",
            "type": "config",
            "uuid": "071ccbcd-97fb-482f-b654-e3c28d8aa4a6"
        },
        {
            "conditions": [
                {
                    "path": "sub.standardhuman.level",
                    "type": "eq",
                    "value": 13
                }
            ],
            "config": [],
            "name": "Standard Human 14",
            "type": "config",
            "uuid": "ff5a6a59-dbbb-4e7b-869f-be474de269fa"
        },
        {
            "conditions": [
                {
                    "path": "sub.standardhuman.level",
                    "type": "eq",
                    "value": 14
                }
            ],
            "config": [],
            "name": "Standard Human 15",
            "type": "config",
            "uuid": "6b1dc4cf-97aa-4dc8-8111-d05490e36e90"
        },
        {
            "conditions": [
                {
                    "path": "sub.standardhuman.level",
                    "type": "eq",
                    "value": 15
                }
            ],
            "config": [],
            "name": "Standard Human 16",
            "type": "config",
            "uuid": "2f2c8c19-f8f4-4fde-90e3-a6f856ce37d0"
        },
        {
            "conditions": [
                {
                    "path": "sub.standardhuman.level",
                    "type": "eq",
                    "value": 16
                }
            ],
            "config": [],
            "name": "Standard Human 17",
            "type": "config",
            "uuid": "5274ff76-d56a-476a-8a9d-f900d9b19d99"
        },
        {
            "conditions": [
                {
                    "path": "sub.standardhuman.level",
                    "type": "eq",
                    "value": 17
                }
            ],
            "config": [],
            "name": "Standard Human 18",
            "type": "config",
            "uuid": "2ec2db73-7513-4562-bd63-d655607bac7b"
        },
        {
            "conditions": [
                {
                    "path": "sub.standardhuman.level",
                    "type": "eq",
                    "value": 18
                }
            ],
            "config": [],
            "name": "Standard Human 19",
            "type": "config",
            "uuid": "4203c3f4-84c7-4191-a0cd-e737ec62de5b"
        },
        {
            "conditions": [
                {
                    "path": "sub.standardhuman.level",
                    "type": "eq",
                    "value": 19
                }
            ],
            "config": [],
            "name": "Standard Human 20",
            "type": "config",
            "uuid": "d654b2fb-b261-4297-b5de-ff7fc0b3cbf8"
        }
    ],
    "type": "config",
    "uuid": "9e541a9e-c409-457b-b114-98f968a42247"
}');
INSERT INTO `subrace` (id, name, race_id, config)
    VALUES (8, 'Human Variant', 4, '{
    "conditions": [],
    "config": [
        {
            "description": "Two different ability scores of your choice increase by 1.",
            "limit": 2,
            "name": "Ability Score Improvement",
            "type": "ability_score",
            "uuid": "0105d009-f918-4207-8aea-54a8034f73fb"
        },
        {
            "add": 1,
            "description": "You gain proficiency in one skill of your choice.",
            "list": [
                "skills"
            ],
            "name": "Skills",
            "path": "proficiencies.skills",
            "type": "objectlist",
            "uuid": "8003ee93-f8a1-4c36-b5f1-c9a2d45ade28"
        },
        {
            "description": "You gain one feat of your choice.",
            "include": 3,
            "name": "Feat",
            "type": "choice",
            "uuid": "e647ea54-4a30-4a1a-a3f0-a797bf049c39"
        }
    ],
    "description": "",
    "phases": [
        {
            "conditions": [
                {
                    "path": "sub.humanvariant.level",
                    "type": "eq",
                    "value": 1
                }
            ],
            "config": [],
            "name": "Human Variant 2",
            "type": "config",
            "uuid": "59bcef75-4bbd-4d80-ba3f-079735904964"
        },
        {
            "conditions": [
                {
                    "path": "sub.humanvariant.level",
                    "type": "eq",
                    "value": 2
                }
            ],
            "config": [],
            "name": "Human Variant 3",
            "type": "config",
            "uuid": "839dac2b-cec4-4334-a334-a73b691fe035"
        },
        {
            "conditions": [
                {
                    "path": "sub.humanvariant.level",
                    "type": "eq",
                    "value": 3
                }
            ],
            "config": [],
            "name": "Human Variant 4",
            "type": "config",
            "uuid": "8bab626f-2ba1-43f4-a8dc-79ad6e82c5ba"
        },
        {
            "conditions": [
                {
                    "path": "sub.humanvariant.level",
                    "type": "eq",
                    "value": 4
                }
            ],
            "config": [],
            "name": "Human Variant 5",
            "type": "config",
            "uuid": "ff12740f-4f58-40eb-91d1-d16eec3615cd"
        },
        {
            "conditions": [
                {
                    "path": "sub.humanvariant.level",
                    "type": "eq",
                    "value": 5
                }
            ],
            "config": [],
            "name": "Human Variant 6",
            "type": "config",
            "uuid": "03b0d477-d2cc-494e-8ef6-d054ccaf3b2c"
        },
        {
            "conditions": [
                {
                    "path": "sub.humanvariant.level",
                    "type": "eq",
                    "value": 6
                }
            ],
            "config": [],
            "name": "Human Variant 7",
            "type": "config",
            "uuid": "eb800aa8-16e6-4b27-a1dd-4efcda53749a"
        },
        {
            "conditions": [
                {
                    "path": "sub.humanvariant.level",
                    "type": "eq",
                    "value": 7
                }
            ],
            "config": [],
            "name": "Human Variant 8",
            "type": "config",
            "uuid": "151d24e2-bf80-41a0-a30f-ea5136ce1af6"
        },
        {
            "conditions": [
                {
                    "path": "sub.humanvariant.level",
                    "type": "eq",
                    "value": 8
                }
            ],
            "config": [],
            "name": "Human Variant 9",
            "type": "config",
            "uuid": "25e4b784-6a82-45bb-aff4-f4577b6bde21"
        },
        {
            "conditions": [
                {
                    "path": "sub.humanvariant.level",
                    "type": "eq",
                    "value": 9
                }
            ],
            "config": [],
            "name": "Human Variant 10",
            "type": "config",
            "uuid": "b9864c9d-c9f8-44bc-87d1-c7c3bbe7be15"
        },
        {
            "conditions": [
                {
                    "path": "sub.humanvariant.level",
                    "type": "eq",
                    "value": 10
                }
            ],
            "config": [],
            "name": "Human Variant 11",
            "type": "config",
            "uuid": "818df7ca-4024-40e1-809e-ed1064057d54"
        },
        {
            "conditions": [
                {
                    "path": "sub.humanvariant.level",
                    "type": "eq",
                    "value": 11
                }
            ],
            "config": [],
            "name": "Human Variant 12",
            "type": "config",
            "uuid": "0305ac27-2689-4434-bd09-d9488898f1f0"
        },
        {
            "conditions": [
                {
                    "path": "sub.humanvariant.level",
                    "type": "eq",
                    "value": 12
                }
            ],
            "config": [],
            "name": "Human Variant 13",
            "type": "config",
            "uuid": "ace778cf-5dac-4b68-8560-32c2f52e1e7b"
        },
        {
            "conditions": [
                {
                    "path": "sub.humanvariant.level",
                    "type": "eq",
                    "value": 13
                }
            ],
            "config": [],
            "name": "Human Variant 14",
            "type": "config",
            "uuid": "fcc85aa4-71bf-444b-a522-83e5797d3c10"
        },
        {
            "conditions": [
                {
                    "path": "sub.humanvariant.level",
                    "type": "eq",
                    "value": 14
                }
            ],
            "config": [],
            "name": "Human Variant 15",
            "type": "config",
            "uuid": "2507b55f-d3f4-4248-88fb-4b60e4b4a7b6"
        },
        {
            "conditions": [
                {
                    "path": "sub.humanvariant.level",
                    "type": "eq",
                    "value": 15
                }
            ],
            "config": [],
            "name": "Human Variant 16",
            "type": "config",
            "uuid": "bbebf3f8-9754-446a-a9fb-cec396e2578b"
        },
        {
            "conditions": [
                {
                    "path": "sub.humanvariant.level",
                    "type": "eq",
                    "value": 16
                }
            ],
            "config": [],
            "name": "Human Variant 17",
            "type": "config",
            "uuid": "ff9bc8a1-17e9-4301-a1c9-f6459234aa26"
        },
        {
            "conditions": [
                {
                    "path": "sub.humanvariant.level",
                    "type": "eq",
                    "value": 17
                }
            ],
            "config": [],
            "name": "Human Variant 18",
            "type": "config",
            "uuid": "024b603b-e027-4804-8c9d-a0b84c678efa"
        },
        {
            "conditions": [
                {
                    "path": "sub.humanvariant.level",
                    "type": "eq",
                    "value": 18
                }
            ],
            "config": [],
            "name": "Human Variant 19",
            "type": "config",
            "uuid": "b2e50671-c43e-401c-bbd3-15b775f580ca"
        },
        {
            "conditions": [
                {
                    "path": "sub.humanvariant.level",
                    "type": "eq",
                    "value": 19
                }
            ],
            "config": [],
            "name": "Human Variant 20",
            "type": "config",
            "uuid": "92ad6ea2-8bde-4eaa-82f2-9db3345daaef"
        }
    ],
    "type": "config",
    "uuid": "a0c7e359-94fb-409f-9766-412d530ea92e"
}');

INSERT INTO `class` (id, name, config)
    VALUES (1, 'Cleric', '{
    "caster_rank": 1,
    "conditions": [],
    "config": [
        {
            "config": [
                {
                    "hidden": true,
                    "path": "sub.cleric.hit_dice",
                    "type": "value",
                    "uuid": "df63bdd1-bc20-4577-9185-c5573a2a26cd",
                    "value": 8
                },
                {
                    "conditions": [
                        {
                            "path": "character.level",
                            "type": "lte",
                            "value": 1
                        }
                    ],
                    "config": [
                        {
                            "given": [
                                "sub.cleric.hit_dice"
                            ],
                            "hidden": true,
                            "path": "computed.hit_points.formulas",
                            "type": "list",
                            "uuid": "0a16619d-067f-4302-a9e6-5c796d95daeb"
                        },
                        {
                            "given": [
                                "statistics.modifiers.constitution * character.level"
                            ],
                            "hidden": true,
                            "multiple": true,
                            "path": "computed.hit_points.bonus",
                            "type": "list",
                            "uuid": "4f3d2549-65ed-4d41-b3c1-598b2fe4ba42"
                        }
                    ],
                    "description": "`8` + your **Constitution modifier**",
                    "name": "Hit Points at First Level",
                    "type": "config",
                    "uuid": "19f4ee8d-d8b6-4d1d-8249-9467809fa8ef"
                },
                {
                    "config": [
                        {
                            "given": [
                                "5 * (sub.cleric.level - 1)"
                            ],
                            "hidden": true,
                            "multiple": true,
                            "path": "computed.hit_points.bonus",
                            "type": "list",
                            "uuid": "ec310ed9-7eae-4d2b-b35b-60406947f1a2"
                        }
                    ],
                    "description": "`1d8` (`5`) + your **Constitution modifier** per **Cleric** level after 1st",
                    "name": "Hit Points at Higher Levels",
                    "type": "config",
                    "uuid": "67da2006-18bc-4e48-b0d4-6fee507fe22f"
                }
            ],
            "description": "`1d8` per **Cleric** level",
            "name": "Hit Dice",
            "type": "config",
            "uuid": "51398dcd-a8e4-459d-9c8e-6cb65faa4423"
        },
        {
            "config": [
                {
                    "description": "Light armor, medium armor, shields",
                    "given": [
                        {
                            "id": "shield",
                            "name": "Shields",
                            "type": "armor_types"
                        },
                        {
                            "id": "light",
                            "name": "Light Armor",
                            "type": "armor_types"
                        },
                        {
                            "id": "medium",
                            "name": "Medium Armor",
                            "type": "armor_types"
                        }
                    ],
                    "list": [],
                    "name": "Armor",
                    "path": "proficiencies.armor",
                    "type": "objectlist",
                    "uuid": "734c8b5b-1a31-4257-95f9-cfbe370017ec"
                },
                {
                    "description": "Simple weapons",
                    "given": [
                        {
                            "id": "simple melee",
                            "name": "Simple Melee Weapon",
                            "type": "weapon_types"
                        },
                        {
                            "id": "simple ranged",
                            "name": "Simple Ranged Weapon",
                            "type": "weapon_types"
                        }
                    ],
                    "list": [],
                    "name": "Weapons",
                    "path": "proficiencies.weapons",
                    "type": "objectlist",
                    "uuid": "84c69eb0-eafb-4308-b790-d39eb1abac3a"
                },
                {
                    "description": "None",
                    "name": "Tools",
                    "type": "config",
                    "uuid": "bdf385ec-5b2d-4d9d-870b-7127be08f0ef"
                },
                {
                    "description": "Wisdom, Charisma",
                    "given": [
                        {
                            "id": "wisdom",
                            "name": "Wisdom",
                            "type": "statistics"
                        },
                        {
                            "id": "charisma",
                            "name": "Charisma",
                            "type": "statistics"
                        }
                    ],
                    "list": [],
                    "name": "Saving Throws",
                    "path": "proficiencies.saving_throws",
                    "type": "objectlist",
                    "uuid": "7cc0540a-b751-4a66-a0a2-48500aae575a"
                },
                {
                    "add": 2,
                    "description": "Choose two from History, Insight, Medicine,\nPersuasion, and Religion",
                    "filter": [
                        {
                            "method": "proficiency",
                            "objects": [
                                {
                                    "id": "history",
                                    "name": "History",
                                    "type": "skills"
                                },
                                {
                                    "id": "insight",
                                    "name": "Insight",
                                    "type": "skills"
                                },
                                {
                                    "id": "medicine",
                                    "name": "Medicine",
                                    "type": "skills"
                                },
                                {
                                    "id": "persuasion",
                                    "name": "Persuasion",
                                    "type": "skills"
                                },
                                {
                                    "id": "religion",
                                    "name": "Religion",
                                    "type": "skills"
                                }
                            ],
                            "type": "proficiencies"
                        }
                    ],
                    "list": [
                        "skills"
                    ],
                    "name": "Skills",
                    "path": "proficiencies.skills",
                    "type": "objectlist",
                    "uuid": "e7e8c131-0b83-4626-9343-39e5d97f4644"
                }
            ],
            "name": "Proficiencies",
            "type": "config",
            "uuid": "c8980214-0f16-493d-8b98-7577a19eadd9"
        },
        {
            "config": [
                {
                    "description": "(a) a mace or (b) a warhammer (if proficient)",
                    "name": "Weapons",
                    "options": [
                        {
                            "given": [
                                {
                                    "count": 1,
                                    "id": 7,
                                    "name": "Mace",
                                    "type": "simple melee"
                                }
                            ],
                            "list": [],
                            "multiple": true,
                            "name": "Mace",
                            "path": "equipment",
                            "type": "objectlist",
                            "uuid": "37dadd88-8332-4933-889d-05ea2838805f"
                        },
                        {
                            "given": [
                                {
                                    "id": 32,
                                    "name": "Warhammer",
                                    "type": "martial melee"
                                }
                            ],
                            "list": [],
                            "multiple": true,
                            "name": "Warhammer",
                            "path": "equipment",
                            "type": "objectlist",
                            "uuid": "12e512b0-f0d3-432b-ad87-b65e2e903110"
                        }
                    ],
                    "type": "choice",
                    "uuid": "bc0755c0-a65e-4a86-9496-9d3373955b0b"
                },
                {
                    "description": "(a) scale mail, (b) leather armor, or (c) chain mail\n(if proficient)",
                    "name": "Armor",
                    "options": [
                        {
                            "given": [
                                {
                                    "id": 44,
                                    "name": "Scale Mail",
                                    "type": "medium"
                                }
                            ],
                            "list": [],
                            "multiple": true,
                            "name": "Scale Mail",
                            "path": "equipment",
                            "type": "objectlist",
                            "uuid": "f512d4dd-d8b4-4969-8b5c-decef93a1347"
                        },
                        {
                            "given": [
                                {
                                    "count": 1,
                                    "id": 40,
                                    "name": "Leather Armor",
                                    "type": "light"
                                }
                            ],
                            "list": [],
                            "multiple": true,
                            "name": "Leather Armor",
                            "path": "equipment",
                            "type": "objectlist",
                            "uuid": "2a2d7873-ce60-4b6e-887a-7c64489a5694"
                        },
                        {
                            "description": "if proficient",
                            "given": [
                                {
                                    "id": 48,
                                    "name": "Chain Mail",
                                    "type": "heavy"
                                }
                            ],
                            "list": [],
                            "multiple": true,
                            "name": "Chain Mail",
                            "path": "equipment",
                            "type": "objectlist",
                            "uuid": "f7d9fa77-c1f3-4845-a740-2518b9ab6c15"
                        }
                    ],
                    "type": "choice",
                    "uuid": "72e44ca2-225e-4a19-ae8e-779647b11142"
                },
                {
                    "description": "(a) a light crossbow and 20 bolts or (b) any\nsimple weapon",
                    "name": "Weapons",
                    "options": [
                        {
                            "description": "and 20 bolts",
                            "given": [
                                {
                                    "id": 12,
                                    "name": "Crossbow, light",
                                    "type": "simple ranged"
                                },
                                {
                                    "id": 198,
                                    "name": "Crossbow bolts (20)",
                                    "type": "gear"
                                }
                            ],
                            "list": [],
                            "multiple": true,
                            "name": "Light Crossbow",
                            "path": "equipment",
                            "type": "objectlist",
                            "uuid": "440f3194-da8e-418e-b4b2-06a1deb04cd1"
                        },
                        {
                            "add": 1,
                            "filter": [
                                {
                                    "field": "type",
                                    "options": [
                                        "simple melee",
                                        "simple ranged"
                                    ],
                                    "type": "attribute"
                                }
                            ],
                            "list": [
                                "weapon"
                            ],
                            "multiple": true,
                            "name": "Any simple weapon",
                            "path": "equipment",
                            "type": "objectlist",
                            "uuid": "a89d66d4-1780-4d3b-98e2-81a4462856fe"
                        }
                    ],
                    "type": "choice",
                    "uuid": "b2d1e53e-41f8-4a05-8fc3-6489c1760957"
                },
                {
                    "add": 1,
                    "description": "(a) a priest\u2019s pack or (b) an explorer\u2019s pack",
                    "filter": [
                        {
                            "field": "uuid",
                            "options": [
                                "2b9d026d-d989-46e7-8434-b3dbd6a1f4c7",
                                "28d04479-11f4-4b23-aad7-ee92ec818ddd"
                            ],
                            "type": "attribute"
                        }
                    ],
                    "include": 2,
                    "name": "Equipment Packs",
                    "type": "choice",
                    "uuid": "057523f6-4fa2-427d-a886-ab3ea53ea0b2"
                },
                {
                    "add": 1,
                    "filter": [
                        {
                            "field": "group",
                            "options": [
                                "holy symbol"
                            ],
                            "type": "attribute"
                        }
                    ],
                    "given": [
                        {
                            "count": 1,
                            "id": 51,
                            "name": "Shield",
                            "type": "shield"
                        }
                    ],
                    "list": [
                        "gear"
                    ],
                    "multiple": true,
                    "name": "A shield and a holy symbol",
                    "path": "equipment",
                    "type": "objectlist",
                    "uuid": "265a5d58-18a9-438b-8805-f7a37785e138"
                }
            ],
            "description": "You start with the following equipment, in addition to the\nequipment granted by your background:",
            "name": "Equipment",
            "type": "config",
            "uuid": "69a876c4-db04-423b-b7c3-bc0371f7bf0f"
        },
        {
            "config": [
                {
                    "description": "At 1st level, you know three cantrips of your choice from\nthe cleric spell list. You learn additional cleric cantrips\nof your choice at higher levels, as shown in the Cantrips\nKnown column of the Cleric table",
                    "filter": [
                        {
                            "field": "classes",
                            "options": [
                                "Cleric"
                            ],
                            "type": "attribute"
                        },
                        {
                            "field": "level",
                            "options": [
                                "Cantrip"
                            ],
                            "type": "attribute"
                        }
                    ],
                    "limit_formula": "spell.max_cantrips",
                    "list": [
                        "spell"
                    ],
                    "name": "Cantrips",
                    "path": "sub.cleric.spell.cantrips",
                    "type": "objectlist",
                    "uuid": "f0b7f0e8-4179-44cc-a481-70229987e15b"
                },
                {
                    "dict": {
                        "description": "You prepare the list of cleric spells that are available for\nyou to cast, choosing from the cleric spell list. When you\ndo so, choose a number of cleric spells equal to %(limit)s.\nThe spells must be of a level for which you have spell slots.\n\nYou can change your list of prepared spells when you\nfinish a long rest. Preparing a new list of cleric spells\nrequires time spent in prayer and meditation: at least 1\nminute per spell level for each spell on your list.",
                        "limit_default": "your **Wisdom modifier** + your cleric level (minimum of one spell)",
                        "limit_formula": "max(1, sub.cleric.level + statistics.modifiers.wisdom)"
                    },
                    "name": "Preparing Cleric Spells",
                    "path": "abilities.Preparing Cleric Spells",
                    "type": "dict",
                    "uuid": "0d65d204-9a75-4e62-82fe-e4d58af040ad"
                },
                {
                    "name": "Casting Cleric Spells",
                    "path": "info.Casting Cleric Spells",
                    "type": "value",
                    "uuid": "0ca2ffff-ec2b-4cb3-8c26-3ed729a7816b",
                    "value": "The Cleric table shows how many spell slots you have to\ncast your cleric spells of 1st level and higher. To cast one\nof these spells, you must expend a slot of the spell\u2019s level\nor higher. You regain all expended spell slots when you\nfinish a long rest."
                },
                {
                    "config": [
                        {
                            "hidden": true,
                            "path": "sub.cleric.spell.stat",
                            "type": "value",
                            "uuid": "a757d136-5a41-4662-915b-1363e997d3ef",
                            "value": "wisdom"
                        },
                        {
                            "config": [
                                {
                                    "given": [
                                        "8 + character.proficiency + statistics.modifiers.wisdom"
                                    ],
                                    "hidden": true,
                                    "path": "computed.subClericSpellSafe_dc.formulas",
                                    "type": "list",
                                    "uuid": "b273893b-3937-4329-9ea4-6c1f64885a6f"
                                },
                                {
                                    "config": [
                                        {
                                            "given": [
                                                "character.proficiency + statistics.modifiers.wisdom"
                                            ],
                                            "hidden": true,
                                            "path": "computed.subClericSpellAttack_modifier.formulas",
                                            "type": "list",
                                            "uuid": "0ead6985-9c16-49f1-8dbc-574b979c419f"
                                        }
                                    ],
                                    "description": "Your **proficiency bonus** + your **Wisdom modifier**",
                                    "name": "Spell attack modifier",
                                    "type": "config",
                                    "uuid": "8529eb05-e28c-4ec9-a579-242226726ef1"
                                }
                            ],
                            "description": "`8` + your **Proficiency bonus** + your **Wisdom modifier**",
                            "name": "Spell save DC",
                            "type": "config",
                            "uuid": "49225e3f-7150-448f-ba68-95cc10fd3f1d"
                        }
                    ],
                    "description": "**Wisdom** is your spellcasting ability for your cleric spells.\nThe power of your spells comes from your devotion to\nyour deity. You use your **Wisdom** whenever a cleric spell\nrefers to your spellcasting ability. In addition, you use\nyour Wisdom modifier when setting the saving throw\nDC for a cleric spell you cast and when making an attack\nroll with one.",
                    "name": "Spellcasting Ability",
                    "type": "config",
                    "uuid": "fcf16773-b026-4338-95ab-d07f8d001300"
                },
                {
                    "name": "Ritual Casting",
                    "path": "info.Ritual Casting",
                    "type": "value",
                    "uuid": "ac6b10ae-ed8d-43b9-a781-fde1b5747efd",
                    "value": "You can cast a cleric spell as a ritual if that spell has the\nritual tag and you have the spell prepared."
                },
                {
                    "name": "Spellcasting Focus",
                    "path": "info.Spellcasting Focus",
                    "type": "value",
                    "uuid": "bebbcc43-f365-49ab-97fa-b12ff9061cd3",
                    "value": "You can use a holy symbol (found in chapter 5) as a spellcasting focus for your cleric spells."
                }
            ],
            "description": "As a conduit for divine power, you can cast cleric spells.\nSee chapter 10 for the general rules of spellcasting and\nchapter 11 for a selection of cleric spells.",
            "name": "Spellcasting",
            "type": "config",
            "uuid": "3729e21a-69b9-4558-bbf3-caa27a18001d"
        },
        {
            "description": "In a pantheon, every deity has influence over different\naspects of mortal life and civilization, called a deity\u2019s\ndomain. All the domains over which a deity has influence\nare called the deity\u2019s portfolio. For example, the portfolio of the Greek god Apollo includes the domains of\nKnowledge, Life, and Light. As a cleric, you choose one\naspect of your deity\u2019s portfolio to emphasize, and you are\ngranted powers related to that domain.\n\nYour choice might correspond to a particular sect\ndedicated to your deity. Apollo, for example, could be\nworshiped in one region as Phoebus (\u201cradiant\u201d) Apollo,\nemphasizing his influence over the Light domain, and in\na different place as Apollo Acesius (\u201chealing\u201d), emphasizing his association with the Life domain. Alternatively,\nyour choice of domain could simply be a matter of personal preference, the aspect of the deity that appeals\nto you most.\n\nEach domain\u2019s description gives examples of deities\nwho have influence over that domain. Gods are included\nfrom the worlds of the Forgotten Realms, Greyhawk,\nDragonlance, and Eberron campaign settings, as well as\nfrom the Celtic, Greek, Norse, and Egyptian pantheons of\nantiquity.",
            "name": "Divine Domains",
            "options": [],
            "subtype": true,
            "type": "choice",
            "uuid": "b5687d91-d887-4ffe-ac84-7c71439dbcd0"
        }
    ],
    "description": "Arms and eyes upraised toward the sun and a prayer\non his lips, an elf begins to glow with an inner light that\nspills out to heal his battle-worn companions.\n\nChanting a song of glory, a dwarf swings his axe in\nwide swaths to cut through the ranks of orcs arrayed\nagainst him, shouting praise to the gods with every\nfoe\u2019s fall.\n\nCalling down a curse upon the forces of undeath, a\nhuman lifts her holy symbol as light pours from it to drive\nback the zombies crowding in on her companions.\n\nClerics are intermediaries between the mortal world\nand the distant planes of the gods. As varied as the gods\nthey serve, clerics strive to embody the handiwork of\ntheir deities. No ordinary priest, a cleric is imbued with\ndivine magic.\n\n## Healers and Warriors\nDivine magic, as the name suggests, is the power of the\ngods, flowing from them into the world. Clerics are conduits for that power, manifesting it as miraculous effects.\nThe gods don\u2019t grant this power to everyone who seeks it,\nbut only to those chosen to fulfill a high calling.\n\nHarnessing divine magic doesn\u2019t rely on study or training. A cleric might learn formulaic prayers and ancient\nrites, but the ability to cast cleric spells relies on devotion\nand an intuitive sense of a deity\u2019s wishes.\n\nClerics combine the helpful magic of healing and inspiring their allies with spells that harm and hinder foes.\nThey can provoke awe and dread, lay curses of plague\nor poison, and even call down flames from heaven to consume their enemies. For those evildoers who will benefit\nmost from a mace to the head, clerics depend on their\ncombat training to let them wade into melee with the\npower of the gods on their side.\n\n## Divine Agents\nNot every acolyte or officiant at a temple or shrine is a\ncleric. Some priests are called to a simple life of temple\nservice, carrying out their gods\u2019 will through prayer and \nsacrifice, not by magic and strength of arms. In some cities, priesthood amounts to a political office, viewed as a\nstepping stone to higher positions of authority and involving no communion with a god at all. True clerics are rare\nin most hierarchies.\n\nWhen a cleric takes up an adventuring life, it is usually\nbecause his or her god demands it. Pursuing the goals\nof the gods often involves braving dangers beyond the\nwalls of civilization, smiting evil or seeking holy relics in\nancient tombs. Many clerics are also expected to protect\ntheir deities\u2019 worshipers, which can mean fighting rampaging orcs, negotiating peace between warring nations,\nor sealing a portal that would allow a demon prince to\nenter the world.\n\nMost adventuring clerics maintain some connection to\nestablished temples and orders of their faiths. A temple\nmight ask for a cleric\u2019s aid, or a high priest might be in a\nposition to demand it.",
    "features": {
        "casting_stat": "wisdom",
        "max_cantrips": [ 3, 3, 3, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5 ],
        "spell.wizard.max_prepared_formula": "max(1, character.level + statistics.modifiers.wisdom)",
        "slots": [
            [ 2 ],
            [ 3 ],
            [ 4, 2 ],
            [ 4, 3 ],
            [ 4, 3, 2 ],
            [ 4, 3, 3 ],
            [ 4, 3, 3, 1 ],
            [ 4, 3, 3, 2 ],
            [ 4, 3, 3, 3, 1 ],
            [ 4, 3, 3, 3, 2 ],
            [ 4, 3, 3, 3, 2, 1 ],
            [ 4, 3, 3, 3, 2, 1 ],
            [ 4, 3, 3, 3, 2, 1, 1 ],
            [ 4, 3, 3, 3, 2, 1, 1 ],
            [ 4, 3, 3, 3, 2, 1, 1, 1 ],
            [ 4, 3, 3, 3, 2, 1, 1, 1 ],
            [ 4, 3, 3, 3, 2, 1, 1, 1, 1 ],
            [ 4, 3, 3, 3, 3, 1, 1, 1, 1 ],
            [ 4, 3, 3, 3, 3, 2, 1, 1, 1 ],
            [ 4, 3, 3, 3, 3, 2, 2, 1, 1 ]
        ]
    },
    "phases": [
        {
            "conditions": [
                {
                    "path": "sub.cleric.level",
                    "type": "eq",
                    "value": 1
                }
            ],
            "config": [
                {
                    "dict": {
                        "dc_default": "your cleric spell save DC",
                        "dc_formula": "`sub.cleric.spell.save_dc`",
                        "description": "You have the ability to channel divine energy\ndirectly from your deity, using that energy to fuel magical\neffects. When you use your **Channel Divinity**, you choose which\neffect to create. You can use your **Channel Divinity** %(uses)s until\nyou must finish a short or long rest to use your **Channel Divinity** again.\nWhen you finish a short or long rest, you regain your expended uses.\nSome **Channel Divinity** effects require saving throws.\nWhen you use such an effect from this class, the DC equals %(dc)s.",
                        "uses": "once"
                    },
                    "name": "Channel Divinity",
                    "path": "abilities.Channel Divinity",
                    "type": "dict",
                    "uuid": "3adc2b0b-0cd1-4321-a86e-d4bef68e53c2"
                },
                {
                    "dict": {
                        "description": "As an **action**, you present your holy symbol and speak a\nprayer censuring the undead. Each undead that can see\nor hear you within 30 feet of you must make a **Wisdom**\n*saving throw*. If the creature fails its saving throw, it is\nturned for 1 minute or until it takes any damage.\n\nA turned creature must spend its turns trying to move\nas far away from you as it can, and it can\u2019t willingly move\nto a space within 30 feet of you. It also can\u2019t take *reactions*. \nFor its *action*, it can use only the **Dash** action or\ntry to escape from an effect that prevents it from moving.\nIf there\u2019s nowhere to move, the creature can use the\n**Dodge** action."
                    },
                    "name": "Channel Divinity: Turn Undead",
                    "path": "abilities.Channel Divinity: Turn Undead",
                    "type": "dict",
                    "uuid": "1520c5df-2015-4209-90ea-27ab8e440a88"
                }
            ],
            "name": "Cleric 2",
            "type": "config",
            "uuid": "9063617e-cc60-426a-a7e5-82cbaf32abfb"
        },
        {
            "conditions": [
                {
                    "path": "sub.cleric.level",
                    "type": "eq",
                    "value": 2
                }
            ],
            "config": [],
            "name": "Cleric 3",
            "type": "config",
            "uuid": "b519aa2b-87e8-450a-9881-a482bf94c8f1"
        },
        {
            "conditions": [
                {
                    "path": "sub.cleric.level",
                    "type": "eq",
                    "value": 3
                }
            ],
            "config": [
                {
                    "name": "ASI or Feat",
                    "options": [
                        {
                            "description": "You can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can''t increase an ability score above 20 using this feature.",
                            "limit": 2,
                            "name": "Ability Score Improvement",
                            "type": "ability_score",
                            "uuid": "d4c6c91e-5860-4a52-afb9-139920fa4c4b"
                        },
                        {
                            "add": 1,
                            "description": "A feat represents a talent or an area of expertise that gives a character special capabilities. It embodies training, experience, and abilities beyond what a class provides. See chapter 6 of the Player\u2019s Handbook for more information.",
                            "include": 3,
                            "name": "Feat",
                            "type": "multichoice",
                            "uuid": "327507a1-b05d-4032-a39c-c9224671af44"
                        }
                    ],
                    "type": "choice",
                    "uuid": "50a234c6-c1ab-453a-be6f-9a60aad0d801"
                }
            ],
            "name": "Cleric 4",
            "type": "config",
            "uuid": "18fc77ed-661d-4184-be1b-d7e47dc1c3c1"
        },
        {
            "conditions": [
                {
                    "path": "sub.cleric.level",
                    "type": "eq",
                    "value": 4
                }
            ],
            "config": [
                {
                    "dict": {
                        "cr": "\u00bd",
                        "description": "When an undead fails its saving throw against your **Turn Undead** feature, the creature is\ninstantly destroyed if its challenge rating is at or below `%(cr)s`."
                    },
                    "name": "Destroy Undead",
                    "path": "abilities.Destroy Undead",
                    "type": "dict",
                    "uuid": "d220bfe3-07cd-4f0b-ba1e-6a3d23b706e0"
                }
            ],
            "name": "Cleric 5",
            "type": "config",
            "uuid": "5ea3a21d-cb7b-4939-af38-c9d07cd43ab7"
        },
        {
            "conditions": [
                {
                    "path": "sub.cleric.level",
                    "type": "eq",
                    "value": 5
                }
            ],
            "config": [
                {
                    "dict": {
                        "uses": "twice"
                    },
                    "name": "Channel Divinity",
                    "path": "abilities.Channel Divinity",
                    "type": "dict",
                    "uuid": "3653c867-cde5-48c8-836e-45c5e361f4c3"
                }
            ],
            "name": "Cleric 6",
            "type": "config",
            "uuid": "cf675125-d964-4194-8e4b-01ba4978fbba"
        },
        {
            "conditions": [
                {
                    "path": "sub.cleric.level",
                    "type": "eq",
                    "value": 6
                }
            ],
            "config": [],
            "name": "Cleric 7",
            "type": "config",
            "uuid": "57d99a12-3cdc-4ce6-8e3a-2f6d21f376a2"
        },
        {
            "conditions": [
                {
                    "path": "sub.cleric.level",
                    "type": "eq",
                    "value": 7
                }
            ],
            "config": [
                {
                    "name": "ASI or Feat",
                    "options": [
                        {
                            "description": "You can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can''t increase an ability score above 20 using this feature.",
                            "limit": 2,
                            "name": "Ability Score Improvement",
                            "type": "ability_score",
                            "uuid": "34148f65-4035-4185-b64e-b30a0e866cca"
                        },
                        {
                            "add": 1,
                            "description": "A feat represents a talent or an area of expertise that gives a character special capabilities. It embodies training, experience, and abilities beyond what a class provides. See chapter 6 of the Player\u2019s Handbook for more information.",
                            "include": 3,
                            "name": "Feat",
                            "type": "multichoice",
                            "uuid": "671e6216-0f3c-4dac-b22c-97a0b8e8671c"
                        }
                    ],
                    "type": "choice",
                    "uuid": "6f56bd92-af81-49c4-a359-48487098d400"
                },
                {
                    "dict": {
                        "cr": "1"
                    },
                    "name": "Destroy Undead",
                    "path": "abilities.Destroy Undead",
                    "type": "dict",
                    "uuid": "c21d9713-9764-439c-a0f6-d8ebf3ce9a4a"
                }
            ],
            "name": "Cleric 8",
            "type": "config",
            "uuid": "0c57d7ff-db84-460a-bcf3-92291b4fa7fa"
        },
        {
            "conditions": [
                {
                    "path": "sub.cleric.level",
                    "type": "eq",
                    "value": 8
                }
            ],
            "config": [],
            "name": "Cleric 9",
            "type": "config",
            "uuid": "85cda137-8e1e-4260-9bcf-b856350d8172"
        },
        {
            "conditions": [
                {
                    "path": "sub.cleric.level",
                    "type": "eq",
                    "value": 9
                }
            ],
            "config": [
                {
                    "dict": {
                        "description": "You can call on your deity to intervene on your behalf when your need is great.\nImploring your deity\u2019s aid requires you to use your **action*. Describe the assistance you seek, and roll percentile\ndice. If you roll a number equal to or lower than %(level)s, your deity intervenes. The DM chooses the\nnature of the intervention; the effect of any cleric spell or\ncleric domain spell would be appropriate.\nIf your deity intervenes, you can\u2019t use this feature again\nfor 7 days. Otherwise, you can use it again after you finish a long rest.",
                        "level_default": "your cleric level",
                        "level_formula": "sub.cleric.level"
                    },
                    "name": "Divine Intervention",
                    "path": "abilities.Divine Intervention",
                    "type": "dict",
                    "uuid": "dd4d2f7a-b981-4c84-b00e-c33bd318ad54"
                }
            ],
            "name": "Cleric 10",
            "type": "config",
            "uuid": "d17ca9b5-7402-47b0-82be-3728473b2485"
        },
        {
            "conditions": [
                {
                    "path": "sub.cleric.level",
                    "type": "eq",
                    "value": 10
                }
            ],
            "config": [
                {
                    "dict": {
                        "cr": "2"
                    },
                    "name": "Destroy Undead",
                    "path": "abilities.Destroy Undead",
                    "type": "dict",
                    "uuid": "c42ec61c-0569-4beb-9542-f7b8434051ae"
                }
            ],
            "name": "Cleric 11",
            "type": "config",
            "uuid": "1e40acad-a23b-422e-be61-6a6aa2084986"
        },
        {
            "conditions": [
                {
                    "path": "sub.cleric.level",
                    "type": "eq",
                    "value": 11
                }
            ],
            "config": [
                {
                    "name": "ASI or Feat",
                    "options": [
                        {
                            "description": "You can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can''t increase an ability score above 20 using this feature.",
                            "limit": 2,
                            "name": "Ability Score Improvement",
                            "type": "ability_score",
                            "uuid": "94209562-a562-4b6e-b5a5-0118a1de1159"
                        },
                        {
                            "add": 1,
                            "description": "A feat represents a talent or an area of expertise that gives a character special capabilities. It embodies training, experience, and abilities beyond what a class provides. See chapter 6 of the Player\u2019s Handbook for more information.",
                            "include": 3,
                            "name": "Feat",
                            "type": "multichoice",
                            "uuid": "b03934f2-bdbb-465f-a52a-12185f8f8842"
                        }
                    ],
                    "type": "choice",
                    "uuid": "61a85dd4-941c-46d7-b3db-b2d9ad6e059c"
                }
            ],
            "name": "Cleric 12",
            "type": "config",
            "uuid": "756b49b3-febb-4451-9826-7f55d66e973f"
        },
        {
            "conditions": [
                {
                    "path": "sub.cleric.level",
                    "type": "eq",
                    "value": 12
                }
            ],
            "config": [],
            "name": "Cleric 13",
            "type": "config",
            "uuid": "b9fc32ae-8e62-49c4-aa02-a3216434dcca"
        },
        {
            "conditions": [
                {
                    "path": "sub.cleric.level",
                    "type": "eq",
                    "value": 13
                }
            ],
            "config": [
                {
                    "dict": {
                        "cr": "3"
                    },
                    "name": "Destroy Undead",
                    "path": "abilities.Destroy Undead",
                    "type": "dict",
                    "uuid": "fadcecca-4f0a-4db6-ad23-e43df0da916a"
                }
            ],
            "name": "Cleric 14",
            "type": "config",
            "uuid": "6343dfdd-daee-4ab9-bc08-60eb2f5894f7"
        },
        {
            "conditions": [
                {
                    "path": "sub.cleric.level",
                    "type": "eq",
                    "value": 14
                }
            ],
            "config": [],
            "name": "Cleric 15",
            "type": "config",
            "uuid": "1f1187c7-b2da-435c-8ca8-c9163a6df482"
        },
        {
            "conditions": [
                {
                    "path": "sub.cleric.level",
                    "type": "eq",
                    "value": 15
                }
            ],
            "config": [
                {
                    "name": "ASI or Feat",
                    "options": [
                        {
                            "description": "You can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can''t increase an ability score above 20 using this feature.",
                            "limit": 2,
                            "name": "Ability Score Improvement",
                            "type": "ability_score",
                            "uuid": "85888878-ce69-41dd-9e28-579cef91c14d"
                        },
                        {
                            "add": 1,
                            "description": "A feat represents a talent or an area of expertise that gives a character special capabilities. It embodies training, experience, and abilities beyond what a class provides. See chapter 6 of the Player\u2019s Handbook for more information.",
                            "include": 3,
                            "name": "Feat",
                            "type": "multichoice",
                            "uuid": "ff288ddf-736b-4118-ae8a-e756e9f83e2a"
                        }
                    ],
                    "type": "choice",
                    "uuid": "1a6f624b-02a2-47d3-a9e3-5000bff4f1de"
                }
            ],
            "name": "Cleric 16",
            "type": "config",
            "uuid": "1b440ff9-fac1-47e7-8157-bad24f15f88b"
        },
        {
            "conditions": [
                {
                    "path": "sub.cleric.level",
                    "type": "eq",
                    "value": 16
                }
            ],
            "config": [
                {
                    "dict": {
                        "cr": "4"
                    },
                    "name": "Destroy Undead",
                    "path": "abilities.Destroy Undead",
                    "type": "dict",
                    "uuid": "1b702e3b-bab1-42e8-8ab3-a2064f5e0f62"
                }
            ],
            "name": "Cleric 17",
            "type": "config",
            "uuid": "5f00b0b7-b2a1-4d6f-8ad1-bf93ded00d34"
        },
        {
            "conditions": [
                {
                    "path": "sub.cleric.level",
                    "type": "eq",
                    "value": 17
                }
            ],
            "config": [
                {
                    "dict": {
                        "uses": "three times"
                    },
                    "name": "Channel Divinity",
                    "path": "abilities.Channel Divinity",
                    "type": "dict",
                    "uuid": "74c534a6-4ac6-4160-ad9c-ea06de679fac"
                }
            ],
            "name": "Cleric 18",
            "type": "config",
            "uuid": "98d48bc2-959e-4d4b-bfad-50e13b3ec80c"
        },
        {
            "conditions": [
                {
                    "path": "sub.cleric.level",
                    "type": "eq",
                    "value": 18
                }
            ],
            "config": [
                {
                    "name": "ASI or Feat",
                    "options": [
                        {
                            "description": "You can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can''t increase an ability score above 20 using this feature.",
                            "limit": 2,
                            "name": "Ability Score Improvement",
                            "type": "ability_score",
                            "uuid": "0ac65bb4-ae06-4507-89bf-1e5a2a4d9573"
                        },
                        {
                            "add": 1,
                            "description": "A feat represents a talent or an area of expertise that gives a character special capabilities. It embodies training, experience, and abilities beyond what a class provides. See chapter 6 of the Player\u2019s Handbook for more information.",
                            "include": 3,
                            "name": "Feat",
                            "type": "multichoice",
                            "uuid": "2705bef9-e4bd-4e05-a905-efa34a1ef105"
                        }
                    ],
                    "type": "choice",
                    "uuid": "8eb16515-1d66-424c-b660-b5618f24ecfa"
                }
            ],
            "name": "Cleric 19",
            "type": "config",
            "uuid": "a05bd160-1356-41ea-a563-ff5b939a188f"
        },
        {
            "conditions": [
                {
                    "path": "sub.cleric.level",
                    "type": "eq",
                    "value": 19
                }
            ],
            "config": [
                {
                    "dict": {
                        "description": "You can call on your deity to intervene on your behalf when your need is great.\nImploring your deity\u2019s aid requires you to use your action. Describe the assistance\nyou seek, and your deity intervenes. The DM chooses the nature of the intervention;\nthe effect of any cleric spell or cleric domain spell would be appropriate. After your\ndeity intervenes, you can\u2019t use this feature again for 7 days."
                    },
                    "name": "Divine Intervention",
                    "path": "abilities.Divine Intervention",
                    "type": "dict",
                    "uuid": "b2ada324-b86c-451e-b5fc-89d78e751fc8"
                }
            ],
            "name": "Cleric 20",
            "type": "config",
            "uuid": "d8765312-bbf5-448c-9b36-91bd7ecf67aa"
        }
    ],
    "subclass_level": 1,
    "type": "config",
    "uuid": "063aa074-b679-46b5-a9dc-a0f2af99b95f"
}');
INSERT INTO `class` (id, name, config)
    VALUES (2, 'Fighter', '{
    "conditions": [],
    "config": [
        {
            "config": [
                {
                    "hidden": true,
                    "path": "sub.fighter.hit_dice",
                    "type": "value",
                    "uuid": "c89f9a5c-1481-4b62-aac8-d79d54410a89",
                    "value": 10
                },
                {
                    "conditions": [
                        {
                            "path": "character.level",
                            "type": "lte",
                            "value": 1
                        }
                    ],
                    "config": [
                        {
                            "given": [
                                "sub.fighter.hit_dice"
                            ],
                            "hidden": true,
                            "path": "computed.hit_points.formulas",
                            "type": "list",
                            "uuid": "07035d99-3a76-4a4d-a46b-17318d79f0ad"
                        },
                        {
                            "given": [
                                "statistics.modifiers.constitution * character.level"
                            ],
                            "hidden": true,
                            "multiple": true,
                            "path": "computed.hit_points.bonus",
                            "type": "list",
                            "uuid": "1933b150-4603-4f31-aa74-39ff5b700a73"
                        }
                    ],
                    "description": "`10` + your **Constitution modifier**",
                    "name": "Hit Points at First Level",
                    "type": "config",
                    "uuid": "8fc450ea-3fe6-41c1-b74d-b171b3670279"
                },
                {
                    "config": [
                        {
                            "given": [
                                "6 * (sub.fighter.level - 1)"
                            ],
                            "hidden": true,
                            "multiple": true,
                            "path": "computed.hit_points.bonus",
                            "type": "list",
                            "uuid": "93aca1ef-b58b-45ce-805d-891548baaa23"
                        }
                    ],
                    "description": "`1d10` (or `6`) + your **Constitution modifier** per **Fighter** level after 1st",
                    "name": "Hit Points at Higher Levels",
                    "type": "config",
                    "uuid": "af2e6279-9f3c-418e-83d0-39400d676b7a"
                }
            ],
            "description": "`1d10` per **Fighter** level",
            "name": "Hit Dice",
            "type": "config",
            "uuid": "00509e09-d475-4d1e-a2e7-7e4bd8d6a5ec"
        },
        {
            "config": [
                {
                    "description": "All armor, shields",
                    "given": [
                        {
                            "id": "light",
                            "name": "Light Armor",
                            "type": "armor_types"
                        },
                        {
                            "id": "medium",
                            "name": "Medium Armor",
                            "type": "armor_types"
                        },
                        {
                            "id": "heavy",
                            "name": "Heavy Armor",
                            "type": "armor_types"
                        },
                        {
                            "id": "shield",
                            "name": "Shields",
                            "type": "armor_types"
                        }
                    ],
                    "list": [],
                    "name": "Armor Proficiency",
                    "path": "proficiencies.armor",
                    "type": "objectlist",
                    "uuid": "3c9d67af-128b-4d18-8ad9-29996600e92a"
                },
                {
                    "description": "Simple weapons, martial weapons",
                    "given": [
                        {
                            "id": "simple melee",
                            "name": "Simple Melee Weapon",
                            "type": "weapon_types"
                        },
                        {
                            "id": "simple ranged",
                            "name": "Simple Ranged Weapon",
                            "type": "weapon_types"
                        },
                        {
                            "id": "martial melee",
                            "name": "Martial Melee Weapon",
                            "type": "weapon_types"
                        },
                        {
                            "id": "martial ranged",
                            "name": "Martial Ranged Weapon",
                            "type": "weapon_types"
                        }
                    ],
                    "list": [],
                    "name": "Weapon Proficiency",
                    "path": "proficiencies.weapons",
                    "type": "objectlist",
                    "uuid": "b308edf3-05d2-4c4a-aa7d-c1e6166848ca"
                },
                {
                    "description": "None",
                    "name": "Tools",
                    "type": "config",
                    "uuid": "c500eb36-8ff7-48fb-b4a8-da1ee82a045b"
                },
                {
                    "description": "Strength, Constitution",
                    "given": [
                        {
                            "id": "strength",
                            "name": "Strength",
                            "type": "statistics"
                        },
                        {
                            "id": "constitution",
                            "name": "Constitution",
                            "type": "statistics"
                        }
                    ],
                    "list": [],
                    "name": "Saving Throws",
                    "path": "proficiencies.saving_throws",
                    "type": "objectlist",
                    "uuid": "0ba4cec9-83bd-4d53-85a1-cebc41e8c3d5"
                },
                {
                    "add": 2,
                    "description": "Choose two skills from Acrobatics, Animal\nHandling, Athletics, History, Insight, Intimidation,\nPerception, and Survival",
                    "filter": [
                        {
                            "field": "id",
                            "options": [
                                "acrobatics",
                                "animal handling",
                                "athletics",
                                "history",
                                "insight",
                                "intimidation",
                                "perception",
                                "survival"
                            ],
                            "type": "attribute"
                        }
                    ],
                    "list": [
                        "skills"
                    ],
                    "name": "Skill Proficiency",
                    "path": "proficiencies.skills",
                    "type": "objectlist",
                    "uuid": "7704efcd-1281-4f48-85f1-44e07f6ddf97"
                }
            ],
            "name": "Proficiencies",
            "type": "config",
            "uuid": "5ba0541d-138b-4a8f-937a-53a3c85dce0d"
        },
        {
            "config": [
                {
                    "description": "(a) chain mail or (b) leather armor, longbow,\nand 20 arrows",
                    "name": "",
                    "options": [
                        {
                            "given": [
                                {
                                    "count": 1,
                                    "id": 48,
                                    "name": "Chain Mail",
                                    "type": "heavy"
                                }
                            ],
                            "list": [],
                            "multiple": true,
                            "name": "Chain mail",
                            "path": "equipment",
                            "type": "objectlist",
                            "uuid": "95ea96d0-26d7-4890-aa03-82be3c7f8bba"
                        },
                        {
                            "description": "Longbow and 20 arrows",
                            "given": [
                                {
                                    "count": 1,
                                    "id": 40,
                                    "name": "Leather Armor",
                                    "type": "light"
                                },
                                {
                                    "count": 1,
                                    "id": 37,
                                    "name": "Longbow",
                                    "type": "martial ranged"
                                },
                                {
                                    "count": 1,
                                    "id": 196,
                                    "name": "Arrows (20)",
                                    "type": "gear"
                                }
                            ],
                            "list": [],
                            "multiple": true,
                            "name": "Leather armor",
                            "path": "equipment",
                            "type": "objectlist",
                            "uuid": "294c9638-253f-4143-996f-03f5a2a938ca"
                        }
                    ],
                    "type": "choice",
                    "uuid": "169d1d60-1241-43d8-a564-e18d8b8a36c7"
                },
                {
                    "description": "(a) a martial weapon and a shield or (b) two\nmartial weapons",
                    "name": "",
                    "options": [
                        {
                            "add": 1,
                            "filter": [
                                {
                                    "field": "type",
                                    "options": [
                                        "martial melee",
                                        "martial ranged"
                                    ],
                                    "type": "attribute"
                                }
                            ],
                            "given": [
                                {
                                    "count": 1,
                                    "id": 51,
                                    "name": "Shield",
                                    "type": "shield"
                                }
                            ],
                            "list": [
                                "weapon"
                            ],
                            "multiple": true,
                            "name": "Martial weapon and a shield",
                            "path": "equipment",
                            "type": "objectlist",
                            "uuid": "1a509a75-3974-431f-b7e9-625c6068951d"
                        },
                        {
                            "add": 2,
                            "filter": [
                                {
                                    "field": "type",
                                    "options": [
                                        "martial melee",
                                        "martial ranged"
                                    ],
                                    "type": "attribute"
                                }
                            ],
                            "list": [
                                "weapon"
                            ],
                            "multiple": true,
                            "name": "Two martial weapons",
                            "path": "equipment",
                            "type": "objectlist",
                            "uuid": "a3c706b9-ffc7-4df8-95ac-b9d8ade4c954"
                        }
                    ],
                    "type": "choice",
                    "uuid": "1bd5f104-c8f0-4d54-b93d-5c2296d13116"
                },
                {
                    "description": "(a) a light crossbow and 20 bolts or (b) two handaxes",
                    "name": "",
                    "options": [
                        {
                            "description": "and 20 bolts",
                            "given": [
                                {
                                    "count": 1,
                                    "id": 12,
                                    "name": "Crossbow, light",
                                    "type": "simple ranged"
                                },
                                {
                                    "count": 1,
                                    "id": 198,
                                    "name": "Crossbow bolts (20)",
                                    "type": "gear"
                                }
                            ],
                            "list": [],
                            "multiple": true,
                            "name": "Light crossbow",
                            "path": "equipment",
                            "type": "objectlist",
                            "uuid": "88e1a3e2-5af1-40df-8a36-790ad96e5518"
                        },
                        {
                            "given": [
                                {
                                    "count": 2,
                                    "id": 4,
                                    "name": "Handaxe",
                                    "type": "simple melee"
                                }
                            ],
                            "list": [],
                            "multiple": true,
                            "name": "Two handaxes",
                            "path": "equipment",
                            "type": "objectlist",
                            "uuid": "b02952e3-a00c-4dd6-8d0b-00c6735218c5"
                        }
                    ],
                    "type": "choice",
                    "uuid": "6f2d21d7-9655-482b-b87e-6324606d509c"
                },
                {
                    "description": "(a) a dungeoneer\u2019s pack or (b) an explorer\u2019s pack",
                    "filter": [
                        {
                            "field": "uuid",
                            "options": [
                                "9866ea12-0bb0-4257-9455-e532ba3f5764",
                                "28d04479-11f4-4b23-aad7-ee92ec818ddd"
                            ],
                            "type": "attribute"
                        }
                    ],
                    "include": 2,
                    "type": "choice",
                    "uuid": "7da7e7de-49f1-4b77-b898-520b10ffe521"
                }
            ],
            "description": "You start with the following equipment, in addition to the\nequipment granted by your background:",
            "name": "Equipment",
            "type": "config",
            "uuid": "75780f29-19bf-4a5d-b484-59bd571b0386"
        },
        {
            "add": 1,
            "description": "You adopt a particular style of fighting as your specialty.\nChoose one of the following options. You can\u2019t take a\n**Fighting Style** option more than once, even if you later\nget to choose again.",
            "include": 4,
            "name": "Fighting Style",
            "type": "multichoice",
            "uuid": "cc3349fd-2be7-4667-8c83-9c9372e41cae"
        },
        {
            "dict": {
                "description": "You have a limited well of stamina that you can draw on\nto protect yourself from harm. On your turn, you can use\na bonus action to regain hit points equal to 1d10 + %(level)s.\nOnce you use this feature, you must finish a short or\nlong rest before you can use it again.",
                "level_default": "your fighter level",
                "level_formula": "sub.fighter.level"
            },
            "name": "Second Wind",
            "path": "abilities.Second Wind",
            "type": "dict",
            "uuid": "19daade5-50e7-4203-ab87-9b66dcd894ec"
        }
    ],
    "description": "A human in clanging plate armor holds her shield before\nher as she runs toward the massed goblins. An elf behind\nher, clad in studded leather armor, peppers the goblins\nwith arrows loosed from his exquisite bow. The half-orc\nnearby shouts orders, helping the two combatants coordinate their assault to the best advantage.\n\nA dwarf in chain mail interposes his shield between the\nogre\u2019s club and his companion, knocking the deadly blow\naside. His companion, a half-elf in scale armor, swings\ntwo scimitars in a blinding whirl as she circles the ogre,\nlooking for a blind spot in its defenses.\n\nA gladiator fights for sport in an arena, a master with\nhis trident and net, skilled at toppling foes and moving\nthem around for the crowd\u2019s delight\u2014and his own tactical\nadvantage. His opponent\u2019s sword flares with blue light\nan instant before she sends lightning flashing forth to\nsmite him.\n\nAll of these heroes are fighters, perhaps the most diverse class of characters in the worlds of Dungeons &\nDragons. Questing knights, conquering overlords, royal\nchampions, elite foot soldiers, hardened mercenaries,\nand bandit kings\u2014as fighters, they all share an unparalleled mastery with weapons and armor, and a thorough\nknowledge of the skills of combat. And they are well\nacquainted with death, both meting it out and staring it\ndefiantly in the face.\n\n## Well-Rounded Specialists\n\nFighters learn the basics of all combat styles. Every\nfighter can swing an axe, fence with a rapier, wield a\nlongsword or a greatsword, use a bow, and even trap foes\nin a net with some degree of skill. Likewise, a fighter\nis adept with shields and every form of armor. Beyond\nthat basic degree of familiarity, each fighter specializes\nin a certain style of combat. Some concentrate on archery, some on fighting with two weapons at once, and\nsome on augmenting their martial skills with magic.\nThis combination of broad general ability and extensive specialization makes fighters superior combatants\non battlefields and in dungeons alike.\n\n## Trained for Danger\n\nNot every member of the city watch, the village militia,\nor the queen\u2019s army is a fighter. Most of these troops are\nrelatively untrained soldiers with only the most basic\ncombat knowledge. Veteran soldiers, military officers,\ntrained bodyguards, dedicated knights, and similar figures are fighters.\n\nSome fighters feel drawn to use their training as adventurers. The dungeon delving, monster slaying, and other\ndangerous work common among adventurers is second\nnature for a fighter, not all that different from the life he\nor she left behind. There are greater risks, perhaps, but\nalso much greater rewards\u2014few fighters in the city watch\nhave the opportunity to discover a magic flame tongue\nsword, for example.",
    "features": {},
    "phases": [
        {
            "conditions": [
                {
                    "path": "sub.fighter.level",
                    "type": "eq",
                    "value": 1
                }
            ],
            "config": [
                {
                    "dict": {
                        "description": "You can push yourself beyond your normal limits for a moment. On your turn, you can take\none additional **action**. Once you use this feature, you must finish a short or\nlong rest before you can use it again."
                    },
                    "name": "Action Surge",
                    "path": "abilities.Action Surge",
                    "type": "dict",
                    "uuid": "62856683-2ba9-4c1c-af43-d8de8c25c737"
                }
            ],
            "name": "Fighter 2",
            "type": "config",
            "uuid": "7af64bd3-c765-419c-af6d-d17b78d9ba9a"
        },
        {
            "conditions": [
                {
                    "path": "sub.fighter.level",
                    "type": "eq",
                    "value": 2
                }
            ],
            "config": [
                {
                    "description": "Different fighters choose different approaches to perfecting their fighting prowess. The martial archetype you\nchoose to emulate reflects your approach.",
                    "name": "Martial Archetypes",
                    "subtype": true,
                    "type": "choice",
                    "uuid": "d2a27b4d-406f-4973-99c5-fc94846a7b5a"
                }
            ],
            "name": "Fighter 3",
            "type": "config",
            "uuid": "95a489a3-a60c-4477-8cdb-2d9e2d9b7499"
        },
        {
            "conditions": [
                {
                    "path": "sub.fighter.level",
                    "type": "eq",
                    "value": 3
                }
            ],
            "config": [
                {
                    "name": "ASI or Feat",
                    "options": [
                        {
                            "description": "You can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can''t increase an ability score above 20 using this feature.",
                            "limit": 2,
                            "name": "Ability Score Improvement",
                            "type": "ability_score",
                            "uuid": "2e23260a-0592-46dc-8e94-94daffc55d64"
                        },
                        {
                            "add": 1,
                            "description": "A feat represents a talent or an area of expertise that gives a character special capabilities. It embodies training, experience, and abilities beyond what a class provides. See chapter 6 of the Player\u2019s Handbook for more information.",
                            "include": 3,
                            "name": "Feat",
                            "type": "multichoice",
                            "uuid": "6ae742bf-8ce3-4540-a022-5117a2302350"
                        }
                    ],
                    "type": "choice",
                    "uuid": "a636b1d9-c963-4bbe-b175-fc2e964152f5"
                }
            ],
            "name": "Fighter 4",
            "type": "config",
            "uuid": "3b581915-f068-4d25-8f64-23ca511557b7"
        },
        {
            "conditions": [
                {
                    "path": "sub.fighter.level",
                    "type": "eq",
                    "value": 4
                }
            ],
            "config": [
                {
                    "dict": {
                        "description": "You can attack %(times)s, instead of once, whenever you take the **Attack** action on your turn.",
                        "times": "twice"
                    },
                    "name": "Extra Attack",
                    "path": "abilities.Extra Attack",
                    "type": "dict",
                    "uuid": "282f0e30-f23c-4436-90b0-5d33f39c15ec"
                }
            ],
            "name": "Fighter 5",
            "type": "config",
            "uuid": "f823da57-c923-41cb-8cee-3ff0f1659758"
        },
        {
            "conditions": [
                {
                    "path": "sub.fighter.level",
                    "type": "eq",
                    "value": 5
                }
            ],
            "config": [
                {
                    "name": "ASI or Feat",
                    "options": [
                        {
                            "description": "You can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can''t increase an ability score above 20 using this feature.",
                            "limit": 2,
                            "name": "Ability Score Improvement",
                            "type": "ability_score",
                            "uuid": "6080a76e-a16d-4e84-957f-a65b9ef6ded8"
                        },
                        {
                            "add": 1,
                            "description": "A feat represents a talent or an area of expertise that gives a character special capabilities. It embodies training, experience, and abilities beyond what a class provides. See chapter 6 of the Player\u2019s Handbook for more information.",
                            "include": 3,
                            "name": "Feat",
                            "type": "multichoice",
                            "uuid": "1e3941c8-c8ac-49c6-b596-214f0f1b0959"
                        }
                    ],
                    "type": "choice",
                    "uuid": "78d44f6c-bb57-40e1-8f61-156b6a82d6f8"
                }
            ],
            "name": "Fighter 6",
            "type": "config",
            "uuid": "1d2589ca-d729-4838-be23-14cdd5ab65a2"
        },
        {
            "conditions": [
                {
                    "path": "sub.fighter.level",
                    "type": "eq",
                    "value": 6
                }
            ],
            "config": [],
            "name": "Fighter 7",
            "type": "config",
            "uuid": "072e7062-af0e-4ae9-980e-609e96c9e693"
        },
        {
            "conditions": [
                {
                    "path": "sub.fighter.level",
                    "type": "eq",
                    "value": 7
                }
            ],
            "config": [
                {
                    "name": "ASI or Feat",
                    "options": [
                        {
                            "description": "You can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can''t increase an ability score above 20 using this feature.",
                            "limit": 2,
                            "name": "Ability Score Improvement",
                            "type": "ability_score",
                            "uuid": "43f1ee36-6501-48d6-932e-266fed1c5593"
                        },
                        {
                            "add": 1,
                            "description": "A feat represents a talent or an area of expertise that gives a character special capabilities. It embodies training, experience, and abilities beyond what a class provides. See chapter 6 of the Player\u2019s Handbook for more information.",
                            "include": 3,
                            "name": "Feat",
                            "type": "multichoice",
                            "uuid": "74c3c9a8-d414-435e-95a8-7a1818684957"
                        }
                    ],
                    "type": "choice",
                    "uuid": "e999f1f4-4f9d-4403-8dd9-f5f8e0aff095"
                }
            ],
            "name": "Fighter 8",
            "type": "config",
            "uuid": "1a0536cb-7090-4f2d-b02d-c31dee741713"
        },
        {
            "conditions": [
                {
                    "path": "sub.fighter.level",
                    "type": "eq",
                    "value": 8
                }
            ],
            "config": [
                {
                    "dict": {
                        "description": "You can reroll a saving throw that you fail. If you do so, you must use the new roll.\nYou can use this feature %(times) until you have to finish a long rest.",
                        "times": "once"
                    },
                    "name": "Indomitable",
                    "path": "abilities.Indomitable",
                    "type": "dict",
                    "uuid": "a9b01de0-6100-4412-bd5a-d986f194b926"
                }
            ],
            "name": "Fighter 9",
            "type": "config",
            "uuid": "8da08444-ce10-4573-b0c4-0006641894ac"
        },
        {
            "conditions": [
                {
                    "path": "sub.fighter.level",
                    "type": "eq",
                    "value": 9
                }
            ],
            "config": [],
            "name": "Fighter 10",
            "type": "config",
            "uuid": "a3b3b13c-e490-4870-b262-df1d59e19e6d"
        },
        {
            "conditions": [
                {
                    "path": "sub.fighter.level",
                    "type": "eq",
                    "value": 10
                }
            ],
            "config": [
                {
                    "dict": {
                        "times": "three times"
                    },
                    "name": "Extra Attack",
                    "path": "abilities.Extra Attack",
                    "type": "dict",
                    "uuid": "314f8bd1-02af-406f-9c42-9f68c52d6e87"
                }
            ],
            "name": "Fighter 11",
            "type": "config",
            "uuid": "6005fe92-92e0-4785-81fb-5057e3d335e2"
        },
        {
            "conditions": [
                {
                    "path": "sub.fighter.level",
                    "type": "eq",
                    "value": 11
                }
            ],
            "config": [
                {
                    "name": "ASI or Feat",
                    "options": [
                        {
                            "description": "You can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can''t increase an ability score above 20 using this feature.",
                            "limit": 2,
                            "name": "Ability Score Improvement",
                            "type": "ability_score",
                            "uuid": "7e3196f9-f49b-482b-a06e-c1038966fa69"
                        },
                        {
                            "add": 1,
                            "description": "A feat represents a talent or an area of expertise that gives a character special capabilities. It embodies training, experience, and abilities beyond what a class provides. See chapter 6 of the Player\u2019s Handbook for more information.",
                            "include": 3,
                            "name": "Feat",
                            "type": "multichoice",
                            "uuid": "4fc6f7b4-3850-4224-aca2-150b7a037bdf"
                        }
                    ],
                    "type": "choice",
                    "uuid": "2519fb6b-30fb-4962-9a43-8868c945a0fe"
                }
            ],
            "name": "Fighter 12",
            "type": "config",
            "uuid": "fc6731d9-5e81-4b8d-8c5f-bd01607f6a48"
        },
        {
            "conditions": [
                {
                    "path": "sub.fighter.level",
                    "type": "eq",
                    "value": 12
                }
            ],
            "config": [
                {
                    "dict": {
                        "times": "twice"
                    },
                    "name": "Indomitable",
                    "path": "abilities.Indomitable",
                    "type": "dict",
                    "uuid": "628ff491-9227-4e85-aa4a-05f1a6ba5831"
                }
            ],
            "name": "Fighter 13",
            "type": "config",
            "uuid": "40c9f6b2-9d15-4c2e-a3ac-cf69748a6f9f"
        },
        {
            "conditions": [
                {
                    "path": "sub.fighter.level",
                    "type": "eq",
                    "value": 13
                }
            ],
            "config": [
                {
                    "name": "ASI or Feat",
                    "options": [
                        {
                            "description": "You can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can''t increase an ability score above 20 using this feature.",
                            "limit": 2,
                            "name": "Ability Score Improvement",
                            "type": "ability_score",
                            "uuid": "6723d82e-d40e-4020-96de-455f8ac9c13a"
                        },
                        {
                            "add": 1,
                            "description": "A feat represents a talent or an area of expertise that gives a character special capabilities. It embodies training, experience, and abilities beyond what a class provides. See chapter 6 of the Player\u2019s Handbook for more information.",
                            "include": 3,
                            "name": "Feat",
                            "type": "multichoice",
                            "uuid": "fb3fc5f8-3ec5-4529-88d4-b7fe062e15e1"
                        }
                    ],
                    "type": "choice",
                    "uuid": "4c58e200-2233-404d-86df-d92e5896705b"
                }
            ],
            "name": "Fighter 14",
            "type": "config",
            "uuid": "3b9ff636-38ab-4a14-b9d3-5962c9791350"
        },
        {
            "conditions": [
                {
                    "path": "sub.fighter.level",
                    "type": "eq",
                    "value": 14
                }
            ],
            "config": [],
            "name": "Fighter 15",
            "type": "config",
            "uuid": "3ab110a0-635c-4afe-993b-cf302f888a6f"
        },
        {
            "conditions": [
                {
                    "path": "sub.fighter.level",
                    "type": "eq",
                    "value": 15
                }
            ],
            "config": [
                {
                    "name": "ASI or Feat",
                    "options": [
                        {
                            "description": "You can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can''t increase an ability score above 20 using this feature.",
                            "limit": 2,
                            "name": "Ability Score Improvement",
                            "type": "ability_score",
                            "uuid": "51afe85f-459e-4029-ad35-c479c6a4c508"
                        },
                        {
                            "add": 1,
                            "description": "A feat represents a talent or an area of expertise that gives a character special capabilities. It embodies training, experience, and abilities beyond what a class provides. See chapter 6 of the Player\u2019s Handbook for more information.",
                            "include": 3,
                            "name": "Feat",
                            "type": "multichoice",
                            "uuid": "fa0a6645-3331-4c95-bd08-118f77a14038"
                        }
                    ],
                    "type": "choice",
                    "uuid": "f0561c2e-4a48-42d9-900d-2828da8397f5"
                }
            ],
            "name": "Fighter 16",
            "type": "config",
            "uuid": "713e16b5-47f4-4ee6-b123-d61a4bd3dd57"
        },
        {
            "conditions": [
                {
                    "path": "sub.fighter.level",
                    "type": "eq",
                    "value": 16
                }
            ],
            "config": [
                {
                    "dict": {
                        "description": "You can push yourself beyond your normal limits for a moment. On your turn, you can take\none additional **action**. You can use it twice before a rest, but only once on\nthe same turn. Once you use this feature, you must finish a short or\nlong rest before you can use it again."
                    },
                    "name": "Action Surge",
                    "path": "abilities.Action Surge",
                    "type": "dict",
                    "uuid": "493af8da-72cd-48ea-848b-7d1dffc5dfd5"
                },
                {
                    "dict": {
                        "times": "three times"
                    },
                    "name": "Indomitable",
                    "path": "abilities.Indomitable",
                    "type": "dict",
                    "uuid": "918e05a0-aed8-4eaa-9aa1-620fc91d5b25"
                }
            ],
            "name": "Fighter 17",
            "type": "config",
            "uuid": "e6e9243e-e023-4e97-9a31-b813911294a4"
        },
        {
            "conditions": [
                {
                    "path": "sub.fighter.level",
                    "type": "eq",
                    "value": 17
                }
            ],
            "config": [],
            "name": "Fighter 18",
            "type": "config",
            "uuid": "1f2894cb-3d5b-471d-acdb-f62d14d8fb08"
        },
        {
            "conditions": [
                {
                    "path": "sub.fighter.level",
                    "type": "eq",
                    "value": 18
                }
            ],
            "config": [
                {
                    "name": "ASI or Feat",
                    "options": [
                        {
                            "description": "You can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can''t increase an ability score above 20 using this feature.",
                            "limit": 2,
                            "name": "Ability Score Improvement",
                            "type": "ability_score",
                            "uuid": "b633522a-80c0-44d5-95a5-7c1892a94447"
                        },
                        {
                            "add": 1,
                            "description": "A feat represents a talent or an area of expertise that gives a character special capabilities. It embodies training, experience, and abilities beyond what a class provides. See chapter 6 of the Player\u2019s Handbook for more information.",
                            "include": 3,
                            "name": "Feat",
                            "type": "multichoice",
                            "uuid": "a5c95bd4-80e9-4c69-b1a9-3f501e1fbad5"
                        }
                    ],
                    "type": "choice",
                    "uuid": "4659050d-b613-4de8-a11a-5128fc6a2692"
                }
            ],
            "name": "Fighter 19",
            "type": "config",
            "uuid": "067ccc3e-5261-4501-bef9-fdd6a34ef706"
        },
        {
            "conditions": [
                {
                    "path": "sub.fighter.level",
                    "type": "eq",
                    "value": 19
                }
            ],
            "config": [
                {
                    "dict": {
                        "times": "four times"
                    },
                    "name": "Extra Attack",
                    "path": "abilities.Extra Attack",
                    "type": "dict",
                    "uuid": "a7d2b227-3d01-4095-bd84-57dbc9aac04c"
                }
            ],
            "name": "Fighter 20",
            "type": "config",
            "uuid": "92289e6c-5f3a-41a8-8c25-88dac1e24888"
        }
    ],
    "subclass_level": 3,
    "type": "config",
    "uuid": "9809ac5b-f41d-4d13-ab9d-323ca00b0040"
}');
INSERT INTO `class` (id, name, config)
    VALUES (3, 'Rogue', '{
    "conditions": [],
    "config": [
        {
            "config": [
                {
                    "hidden": true,
                    "path": "sub.rogue.hit_dice",
                    "type": "value",
                    "uuid": "570326ba-e82b-4403-9c39-d1c15c934e11",
                    "value": 8
                },
                {
                    "conditions": [
                        {
                            "path": "character.level",
                            "type": "lte",
                            "value": 1
                        }
                    ],
                    "config": [
                        {
                            "given": [
                                "sub.rogue.hit_dice"
                            ],
                            "hidden": true,
                            "path": "computed.hit_points.formulas",
                            "type": "list",
                            "uuid": "6769943d-432b-4f60-a2d5-d4b946f78c7d"
                        },
                        {
                            "given": [
                                "statistics.modifiers.constitution * character.level"
                            ],
                            "hidden": true,
                            "multiple": true,
                            "path": "computed.hit_points.bonus",
                            "type": "list",
                            "uuid": "0e406255-ec18-4254-8bd8-5c26ea4fdf44"
                        }
                    ],
                    "description": "`8` + your **Constitution modifier**",
                    "name": "Hit Points at First Level",
                    "type": "config",
                    "uuid": "d66cf8e3-cc3f-4895-837d-f0412ca8535e"
                },
                {
                    "config": [
                        {
                            "given": [
                                "5 * (sub.rogue.level - 1)"
                            ],
                            "hidden": true,
                            "multiple": true,
                            "path": "computed.hit_points.bonus",
                            "type": "list",
                            "uuid": "a8156093-b7ac-40ca-8ebe-f9bf1b82fefd"
                        }
                    ],
                    "description": "`1d8` (`5`) + your **Constitution modifier** per **Rogue** level after 1st",
                    "name": "Hit Points at Higher Levels",
                    "type": "config",
                    "uuid": "dc6cccba-a686-4a97-8ed7-26611d323b4a"
                }
            ],
            "description": "`1d8` per **Rogue** level",
            "name": "Hit Dice",
            "type": "config",
            "uuid": "9dd7fb71-837f-4909-883f-30f0c36a9820"
        },
        {
            "config": [
                {
                    "description": "Light armor",
                    "given": [
                        {
                            "id": "light",
                            "name": "Light Armor",
                            "type": "armor_types"
                        }
                    ],
                    "list": [],
                    "name": "Armor Proficiency",
                    "path": "proficiencies.armor",
                    "type": "objectlist",
                    "uuid": "133f4b70-7892-40d9-86a5-e02d5a204680"
                },
                {
                    "description": " Simple weapons, hand crossbows, longswords, rapiers, shortswords",
                    "given": [
                        {
                            "id": "simple melee",
                            "name": "Simple Melee Weapon",
                            "type": "weapon_types"
                        },
                        {
                            "id": "simple ranged",
                            "name": "Simple Ranged Weapon",
                            "type": "weapon_types"
                        },
                        {
                            "id": 35,
                            "name": "Crossbow, hand",
                            "type": "martial ranged"
                        },
                        {
                            "id": 22,
                            "name": "Longsword",
                            "type": "martial melee"
                        },
                        {
                            "id": 25,
                            "name": "Rapier",
                            "type": "martial melee"
                        },
                        {
                            "id": 27,
                            "name": "Shortsword",
                            "type": "martial melee"
                        }
                    ],
                    "list": [],
                    "name": "Weapon Proficiency",
                    "path": "proficiencies.weapons",
                    "type": "objectlist",
                    "uuid": "67519027-261c-4b33-9b45-81fc8f8f0be6"
                },
                {
                    "description": "Thieves\u2019 tools",
                    "given": [
                        {
                            "id": 77,
                            "name": "Thieves'' tools",
                            "type": "kit"
                        }
                    ],
                    "list": [],
                    "name": "Tool Proficiency",
                    "path": "proficiencies.tools",
                    "type": "objectlist",
                    "uuid": "3c17e007-4d72-4c00-95e7-2388159df396"
                },
                {
                    "description": "Dexterity, Intelligence",
                    "given": [
                        {
                            "id": "dexterity",
                            "name": "Dexterity",
                            "type": "statistics"
                        },
                        {
                            "id": "intelligence",
                            "name": "Intelligence",
                            "type": "statistics"
                        }
                    ],
                    "list": [],
                    "name": "Saving Throws",
                    "path": "proficiencies.saving_throws",
                    "type": "objectlist",
                    "uuid": "4c41057b-1dbd-4b62-971c-a647ab6788a5"
                },
                {
                    "add": 4,
                    "description": " Choose four from Acrobatics, Athletics,\nDeception, Insight, Intimidation, Investigation,\nPerception, Performance, Persuasion, Sleight of\nHand, and Stealth",
                    "filter": [
                        {
                            "method": "proficiency",
                            "objects": [
                                {
                                    "id": "acrobatics",
                                    "name": "Acrobatics",
                                    "type": "skills"
                                },
                                {
                                    "id": "athletics",
                                    "name": "Athletics",
                                    "type": "skills"
                                },
                                {
                                    "id": "deception",
                                    "name": "Deception",
                                    "type": "skills"
                                },
                                {
                                    "id": "insight",
                                    "name": "Insight",
                                    "type": "skills"
                                },
                                {
                                    "id": "intimidation",
                                    "name": "Intimidation",
                                    "type": "skills"
                                },
                                {
                                    "id": "investigation",
                                    "name": "Investigation",
                                    "type": "skills"
                                },
                                {
                                    "id": "perception",
                                    "name": "Perception",
                                    "type": "skills"
                                },
                                {
                                    "id": "performance",
                                    "name": "Performance",
                                    "type": "skills"
                                },
                                {
                                    "id": "persuasion",
                                    "name": "Persuasion",
                                    "type": "skills"
                                },
                                {
                                    "id": "sleight of hand",
                                    "name": "Sleight of Hand",
                                    "type": "skills"
                                },
                                {
                                    "id": "stealth",
                                    "name": "Stealth",
                                    "type": "skills"
                                }
                            ],
                            "type": "proficiencies"
                        }
                    ],
                    "list": [
                        "skills"
                    ],
                    "name": "Skill Proficiency",
                    "path": "proficiencies.skills",
                    "type": "objectlist",
                    "uuid": "9eff32cf-e4ba-47b9-be2a-7557847a1ee6"
                }
            ],
            "name": "Proficiencies",
            "type": "config",
            "uuid": "1d40199c-78f8-4df0-8f5f-442960a233b4"
        },
        {
            "config": [
                {
                    "description": "(a) a rapier or (b) a shortsword",
                    "name": "",
                    "options": [
                        {
                            "given": [
                                {
                                    "count": 1,
                                    "id": 25,
                                    "name": "Rapier",
                                    "type": "martial melee"
                                }
                            ],
                            "list": [],
                            "multiple": true,
                            "name": "Rapier",
                            "path": "equipment",
                            "type": "objectlist",
                            "uuid": "a9153a01-9470-4855-80ae-d469a0af7dd4"
                        },
                        {
                            "given": [
                                {
                                    "count": 1,
                                    "id": 27,
                                    "name": "Shortsword",
                                    "type": "martial melee"
                                }
                            ],
                            "list": [],
                            "multiple": true,
                            "name": "Shortsword",
                            "path": "equipment",
                            "type": "objectlist",
                            "uuid": "a4a5fa5d-5ba8-4a53-8fc6-c78dc96f718f"
                        }
                    ],
                    "type": "choice",
                    "uuid": "40b2d9a0-16eb-4187-980c-5f8ca43853e5"
                },
                {
                    "description": "(a) a shortbow and quiver of 20 arrows or (b) a shortsword",
                    "options": [
                        {
                            "description": "and quiver of 20 arrows",
                            "given": [
                                {
                                    "count": 1,
                                    "id": 14,
                                    "name": "Shortbow",
                                    "type": "simple ranged"
                                },
                                {
                                    "count": 1,
                                    "id": 269,
                                    "name": "Quiver",
                                    "type": "gear"
                                },
                                {
                                    "count": 1,
                                    "id": 196,
                                    "name": "Arrows (20)",
                                    "type": "gear"
                                }
                            ],
                            "list": [],
                            "multiple": true,
                            "name": "Shortbow",
                            "path": "equipment",
                            "type": "objectlist",
                            "uuid": "5be69849-b098-4ea1-96c8-51cd1310887d"
                        },
                        {
                            "given": [
                                {
                                    "count": 1,
                                    "id": 27,
                                    "name": "Shortsword",
                                    "type": "martial melee"
                                }
                            ],
                            "list": [],
                            "multiple": true,
                            "name": "Shortsword",
                            "path": "equipment",
                            "type": "objectlist",
                            "uuid": "e82723c5-8948-4767-a25f-178d749d9ce8"
                        }
                    ],
                    "type": "choice",
                    "uuid": "d5efc5ab-5c8a-4c03-a40a-088d07dc2388"
                },
                {
                    "description": "(a) a burglar\u2019s pack, (b) a dungeoneer\u2019s pack, or (c) an explorer\u2019s pack",
                    "filter": [
                        {
                            "field": "uuid",
                            "options": [
                                "5e96d2c9-0bbf-4b3f-b5b6-140785f8c535",
                                "9866ea12-0bb0-4257-9455-e532ba3f5764",
                                "28d04479-11f4-4b23-aad7-ee92ec818ddd"
                            ],
                            "type": "attribute"
                        }
                    ],
                    "include": 2,
                    "name": "",
                    "type": "choice",
                    "uuid": "30feb2fe-26e9-4a9e-bd31-ad6a104f3ce4"
                },
                {
                    "description": "Leather armor, two daggers, and thieves\u2019 tools",
                    "given": [
                        {
                            "count": 1,
                            "id": 40,
                            "name": "Leather Armor",
                            "type": "light"
                        },
                        {
                            "count": 2,
                            "id": 1,
                            "name": "Dagger",
                            "type": "simple melee"
                        },
                        {
                            "count": 1,
                            "id": 77,
                            "name": "Thieves'' tools",
                            "type": "kit"
                        }
                    ],
                    "list": [],
                    "multiple": true,
                    "name": "",
                    "path": "equipment",
                    "type": "objectlist",
                    "uuid": "363babd3-522e-4a81-8e95-4b09599ad707"
                }
            ],
            "description": "You start with the following equipment, in addition to the\nequipment granted by your background:",
            "name": "Equipment",
            "type": "config",
            "uuid": "5bba526c-335c-4cfd-a81e-ab6c82d3f88d"
        },
        {
            "add": 2,
            "description": "Choose two of your skill proficiencies, or one of your skill proficiencies and your proficiency with\nthieves\u2019 tools. Your proficiency bonus is doubled for any ability check you make that uses either of the chosen\nproficiencies.",
            "filter": [
                {
                    "filters": [
                        {
                            "method": "proficiency",
                            "objects": [
                                {
                                    "id": 77,
                                    "name": "Thieves'' tools",
                                    "type": "kit"
                                }
                            ],
                            "type": "proficiencies"
                        },
                        {
                            "method": "proficiency",
                            "objects_formula": "proficiencies.skills",
                            "type": "proficiencies"
                        }
                    ],
                    "method": "or",
                    "type": "or"
                }
            ],
            "list": [
                "skills",
                "gear"
            ],
            "name": "Expertise",
            "path": "proficiencies.expertise",
            "type": "objectlist",
            "uuid": "5ddff08a-4169-410f-9dee-31d7793ce548"
        },
        {
            "dict": {
                "description": "You know how to strike subtly and exploit a foe\u2019s distraction. Once per turn, you can deal an\nextra `%(dmg)s` damage to one creature you hit with an **attack** if you have **advantage**\non the attack roll. The attack must use a *finesse* or a *ranged* weapon. You don\u2019t need **advantage**\non the attack roll if another enemy of the target is within 5 feet of it, that enemy isn\u2019t incapacitated, and\nyou don\u2019t have **disadvantage** on the attack roll.",
                "dmg": "1d6"
            },
            "name": "Sneak Attack",
            "path": "abilities.Sneak Attack",
            "type": "dict",
            "uuid": "e225827f-b616-40b1-a239-3c27526d085a"
        },
        {
            "dict": {
                "description": "During your rogue training you learned thieves\u2019 cant, a\nsecret mix of dialect, jargon, and code that allows you to\nhide messages in seemingly normal conversation. Only\nanother creature that knows thieves\u2019 cant understands\nsuch messages. It takes four times longer to convey such\na message than it does to speak the same idea plainly.\n\nIn addition, you understand a set of secret signs and\nsymbols used to convey short, simple messages, such as\nwhether an area is dangerous or the territory of a thieves\u2019\nguild, whether loot is nearby, or whether the people in\nan area are easy marks or will provide a safe house for\nthieves on the run."
            },
            "name": "Thieves\u2019 Cant",
            "path": "abilities.Thieves\u2019 Cant",
            "type": "dict",
            "uuid": "f09bb292-daeb-45e9-9715-25aa5692b2d4"
        }
    ],
    "description": "Signaling for her companions to wait, a halfling creeps\nforward through the dungeon hall. She presses an ear\nto the door, then pulls out a set of tools and picks the\nlock in the blink of an eye. Then she disappears into the\nshadows as her fighter friend moves forward to kick the\ndoor open.\n\nA human lurks in the shadows of an alley while his\naccomplice prepares for her part in the ambush. When\ntheir target\u2014a notorious slaver\u2014passes the alleyway,\nthe accomplice cries out, the slaver comes to investigate,\nand the assassin\u2019s blade cuts his throat before he can\nmake a sound.\n\nSuppressing a giggle, a gnome waggles her fingers and\nmagically lifts the key ring from the guard\u2019s belt. In a moment, the keys are in her hand, the cell door is open, and\nshe and her companions are free to make their escape.\nRogues rely on skill, stealth, and their foes\u2019 vulnerabilities to get the upper hand in any situation. They have a\nknack for finding the solution to just about any problem,\ndemonstrating a resourcefulness and versatility that is\nthe cornerstone of any successful adventuring party.\n\n## Skill and Precision\n\nRogues devote as much effort to mastering the use of\na variety of skills as they do to perfecting their combat\nabilities, giving them a broad expertise that few other\ncharacters can match. Many rogues focus on stealth and\ndeception, while others refine the skills that help them\nin a dungeon environment, such as climbing, finding and\ndisarming traps, and opening locks.\n\nWhen it comes to combat, rogues prioritize cunning\nover brute strength. A rogue would rather make one\nprecise strike, placing it exactly where the attack will\nhurt the target most, than wear an opponent down with a\nbarrage of attacks. Rogues have an almost supernatural\nknack for avoiding danger, and a few learn magical tricks\nto supplement their other abilities.\n\n## A Shady Living\n\nEvery town and city has its share of rogues. Most of them\nlive up to the worst stereotypes of the class, making a\nliving as burglars, assassins, cutpurses, and con artists. Often, these scoundrels are organized into thieves\u2019\nguilds or crime families. Plenty of rogues operate independently, but even they sometimes recruit apprentices to\nhelp them in their scams and heists. A few rogues make\nan honest living as locksmiths, investigators, or exterminators, which can be a dangerous job in a world where\ndire rats\u2014and wererats\u2014haunt the sewers.\n\nAs adventurers, rogues fall on both sides of the law.\nSome are hardened criminals who decide to seek their\nfortune in treasure hoards, while others take up a life of\nadventure to escape from the law. Some have learned\nand perfected their skills with the explicit purpose of\ninfiltrating ancient ruins and hidden crypts in search\nof treasure.",
    "features": {},
    "phases": [
        {
            "conditions": [
                {
                    "path": "sub.rogue.level",
                    "type": "eq",
                    "value": 1
                }
            ],
            "config": [
                {
                    "dict": {
                        "description": "Your quick thinking and agility allow you to move and act quickly. You can take a **bonus\naction** on each of your turns in combat. This action can be used only to take the **Dash**, **Disengage**, or **Hide** action."
                    },
                    "name": "Cunning Action",
                    "path": "abilities.Cunning Action",
                    "type": "dict",
                    "uuid": "dd2bc319-ffbd-4a6f-93e4-65a180840ddd"
                }
            ],
            "name": "Rogue 2",
            "type": "config",
            "uuid": "ff6247f3-b766-4669-b230-9ca8dd6eb1b6"
        },
        {
            "conditions": [
                {
                    "path": "sub.rogue.level",
                    "type": "eq",
                    "value": 2
                }
            ],
            "config": [
                {
                    "dict": {
                        "dmg": "2d6"
                    },
                    "name": "Sneak Attack",
                    "path": "abilities.Sneak Attack",
                    "type": "dict",
                    "uuid": "96f76543-28aa-40dc-9d04-80992953d35f"
                },
                {
                    "description": "Rogues have many features in common, including their\nemphasis on perfecting their skills, their precise and\ndeadly approach to combat, and their increasingly quick\nreflexes. But different rogues steer those talents in varying directions, embodied by the rogue archetypes. Your\nchoice of archetype is a reflection of your focus\u2014not\nnecessarily an indication of your chosen profession, but a\ndescription of your preferred techniques.",
                    "name": "Roguish Archetypes",
                    "subtype": true,
                    "type": "choice",
                    "uuid": "7b97f689-5031-4c66-810d-7ab75837efac"
                }
            ],
            "name": "Rogue 3",
            "type": "config",
            "uuid": "fa8238c9-59db-4855-9fa3-597d1f31e59c"
        },
        {
            "conditions": [
                {
                    "path": "sub.rogue.level",
                    "type": "eq",
                    "value": 3
                }
            ],
            "config": [
                {
                    "name": "ASI or Feat",
                    "options": [
                        {
                            "description": "You can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can''t increase an ability score above 20 using this feature.",
                            "limit": 2,
                            "name": "Ability Score Improvement",
                            "type": "ability_score",
                            "uuid": "1ba9b33b-7d88-4a80-8a22-452f6b8b87e5"
                        },
                        {
                            "add": 1,
                            "description": "A feat represents a talent or an area of expertise that gives a character special capabilities. It embodies training, experience, and abilities beyond what a class provides. See chapter 6 of the Player\u2019s Handbook for more information.",
                            "include": 3,
                            "name": "Feat",
                            "type": "multichoice",
                            "uuid": "996f96ab-6de6-435a-b135-0a7b41c8f683"
                        }
                    ],
                    "type": "choice",
                    "uuid": "c81724ea-dd10-4178-afde-49550e1ec88c"
                }
            ],
            "name": "Rogue 4",
            "type": "config",
            "uuid": "051b282b-dd5d-4764-a480-0d7b900afafe"
        },
        {
            "conditions": [
                {
                    "path": "sub.rogue.level",
                    "type": "eq",
                    "value": 4
                }
            ],
            "config": [
                {
                    "dict": {
                        "dmg": "3d6"
                    },
                    "name": "Sneak Attack",
                    "path": "abilities.Sneak Attack",
                    "type": "dict",
                    "uuid": "8d96a56a-35a5-48f9-843c-2b6ffdda7c2c"
                },
                {
                    "dict": {
                        "description": "When an attacker that you can see hits you with an **attack**,\nyou can use your *reaction* to halve the attack\u2019s damage against you."
                    },
                    "name": "Uncanny Dodge",
                    "path": "abilities.Uncanny Dodge",
                    "type": "dict",
                    "uuid": "21a347ca-8697-4823-83bf-02c718f48aed"
                }
            ],
            "name": "Rogue 5",
            "type": "config",
            "uuid": "e1ea786c-4bee-450e-b112-8b7cf5b43311"
        },
        {
            "conditions": [
                {
                    "path": "sub.rogue.level",
                    "type": "eq",
                    "value": 5
                }
            ],
            "config": [
                {
                    "add": 2,
                    "description": "Choose two of your skill proficiencies, or one of your skill proficiencies and your proficiency with\nthieves\u2019 tools. Your proficiency bonus is doubled for any ability check you make that uses either of the chosen\nproficiencies.",
                    "filter": [
                        {
                            "field": "id",
                            "options": [
                                77
                            ],
                            "type": "attribute"
                        }
                    ],
                    "list": [
                        "skills"
                    ],
                    "name": "Expertise",
                    "path": "proficiencies.expertise",
                    "type": "objectlist",
                    "uuid": "dc4e4477-0a36-4f4a-97aa-b2a836987828"
                }
            ],
            "name": "Rogue 6",
            "type": "config",
            "uuid": "5f66237a-b074-4fcc-a559-1b07391e9a19"
        },
        {
            "conditions": [
                {
                    "path": "sub.rogue.level",
                    "type": "eq",
                    "value": 6
                }
            ],
            "config": [
                {
                    "dict": {
                        "dmg": "4d6"
                    },
                    "name": "Sneak Attack",
                    "path": "abilities.Sneak Attack",
                    "type": "dict",
                    "uuid": "7967dcf9-a9ef-4926-a7f5-ed7c4d392a6c"
                },
                {
                    "dict": {
                        "description": "You can nimbly dodge out of the way of certain area effects, such as a red dragon\u2019s fiery\nbreath or an ice storm spell. When you are subjected to an effect that allows you to make a **Dexterity** saving\nthrow to take only half damage, you instead take no damage if you succeed on the saving throw, and only half\ndamage if you fail."
                    },
                    "name": "Evasion",
                    "path": "abilities.Evasion",
                    "type": "dict",
                    "uuid": "90a19faa-4e36-4289-989f-0e9d662d5be8"
                }
            ],
            "name": "Rogue 7",
            "type": "config",
            "uuid": "222f386d-902f-42c9-a1dd-c384f570f664"
        },
        {
            "conditions": [
                {
                    "path": "sub.rogue.level",
                    "type": "eq",
                    "value": 7
                }
            ],
            "config": [
                {
                    "name": "ASI or Feat",
                    "options": [
                        {
                            "description": "You can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can''t increase an ability score above 20 using this feature.",
                            "limit": 2,
                            "name": "Ability Score Improvement",
                            "type": "ability_score",
                            "uuid": "488e62d3-5552-454b-8441-3c4ca4e5cd4d"
                        },
                        {
                            "add": 1,
                            "description": "A feat represents a talent or an area of expertise that gives a character special capabilities. It embodies training, experience, and abilities beyond what a class provides. See chapter 6 of the Player\u2019s Handbook for more information.",
                            "include": 3,
                            "name": "Feat",
                            "type": "multichoice",
                            "uuid": "edc217a9-ebad-4fdf-bf4c-abe8b523a810"
                        }
                    ],
                    "type": "choice",
                    "uuid": "389ccb7a-2112-403a-b056-6a630b0d1912"
                }
            ],
            "name": "Rogue 8",
            "type": "config",
            "uuid": "7a3bcb3c-1c0d-4509-9b99-96555f531991"
        },
        {
            "conditions": [
                {
                    "path": "sub.rogue.level",
                    "type": "eq",
                    "value": 8
                }
            ],
            "config": [
                {
                    "dict": {
                        "dmg": "5d6"
                    },
                    "name": "Sneak Attack",
                    "path": "abilities.Sneak Attack",
                    "type": "dict",
                    "uuid": "47aacbd6-dff7-46c5-91ce-621131bbc517"
                }
            ],
            "name": "Rogue 9",
            "type": "config",
            "uuid": "f5ea27c9-f892-4a4c-b7d9-31ea78acae7e"
        },
        {
            "conditions": [
                {
                    "path": "sub.rogue.level",
                    "type": "eq",
                    "value": 9
                }
            ],
            "config": [
                {
                    "name": "ASI or Feat",
                    "options": [
                        {
                            "description": "You can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can''t increase an ability score above 20 using this feature.",
                            "limit": 2,
                            "name": "Ability Score Improvement",
                            "type": "ability_score",
                            "uuid": "aa831bbd-56e8-4994-90ef-127e5bf51769"
                        },
                        {
                            "add": 1,
                            "description": "A feat represents a talent or an area of expertise that gives a character special capabilities. It embodies training, experience, and abilities beyond what a class provides. See chapter 6 of the Player\u2019s Handbook for more information.",
                            "include": 3,
                            "name": "Feat",
                            "type": "multichoice",
                            "uuid": "1eff9898-c10b-4982-9776-464716636929"
                        }
                    ],
                    "type": "choice",
                    "uuid": "81177501-5239-4eaa-b2a6-6bb8e69656b1"
                }
            ],
            "name": "Rogue 10",
            "type": "config",
            "uuid": "101f3217-3187-4b1f-99c4-6475da730545"
        },
        {
            "conditions": [
                {
                    "path": "sub.rogue.level",
                    "type": "eq",
                    "value": 10
                }
            ],
            "config": [
                {
                    "dict": {
                        "dmg": "6d6"
                    },
                    "name": "Sneak Attack",
                    "path": "abilities.Sneak Attack",
                    "type": "dict",
                    "uuid": "85e5810f-4e16-44bc-8053-31df99913502"
                },
                {
                    "dict": {
                        "description": "You have refined your chosen skills until they approach perfection. Whenever you make an *ability\ncheck* that lets you add your proficiency bonus, you can treat a d20 roll of 9 or lower as a 10."
                    },
                    "name": "Reliable Talent",
                    "path": "abilities.Reliable Talent",
                    "type": "dict",
                    "uuid": "50ae5218-3ae8-4346-84be-ca62ba4a604a"
                }
            ],
            "name": "Rogue 11",
            "type": "config",
            "uuid": "affb6e04-d69e-4a9c-8355-9f3a586502e4"
        },
        {
            "conditions": [
                {
                    "path": "sub.rogue.level",
                    "type": "eq",
                    "value": 11
                }
            ],
            "config": [
                {
                    "name": "ASI or Feat",
                    "options": [
                        {
                            "description": "You can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can''t increase an ability score above 20 using this feature.",
                            "limit": 2,
                            "name": "Ability Score Improvement",
                            "type": "ability_score",
                            "uuid": "bc6c0bf3-0758-4e2c-8ae3-1f87f596f523"
                        },
                        {
                            "add": 1,
                            "description": "A feat represents a talent or an area of expertise that gives a character special capabilities. It embodies training, experience, and abilities beyond what a class provides. See chapter 6 of the Player\u2019s Handbook for more information.",
                            "include": 3,
                            "name": "Feat",
                            "type": "multichoice",
                            "uuid": "81ab5829-c8f6-4b5f-85b6-741f0614fdc3"
                        }
                    ],
                    "type": "choice",
                    "uuid": "f92de8ef-375d-494d-8347-b9304fc04fe5"
                }
            ],
            "name": "Rogue 12",
            "type": "config",
            "uuid": "917a4bf8-a954-4800-a086-20114382a271"
        },
        {
            "conditions": [
                {
                    "path": "sub.rogue.level",
                    "type": "eq",
                    "value": 12
                }
            ],
            "config": [
                {
                    "dict": {
                        "dmg": "7d6"
                    },
                    "name": "Sneak Attack",
                    "path": "abilities.Sneak Attack",
                    "type": "dict",
                    "uuid": "57d4d950-571a-4bb1-b607-222bcd179e2a"
                }
            ],
            "name": "Rogue 13",
            "type": "config",
            "uuid": "2d4c953f-1ecb-43f6-945b-0e1d97cb55bf"
        },
        {
            "conditions": [
                {
                    "path": "sub.rogue.level",
                    "type": "eq",
                    "value": 13
                }
            ],
            "config": [
                {
                    "dict": {
                        "description": "If you are able to hear, you are aware of the location of any *hidden* or *invisible* creature\nwithin 10 feet of you."
                    },
                    "name": "Blindsense",
                    "path": "abilities.Blindsense",
                    "type": "dict",
                    "uuid": "acec1a13-c78c-4b87-943a-a6e492b7045f"
                }
            ],
            "name": "Rogue 14",
            "type": "config",
            "uuid": "b781903c-205d-493f-8e9a-4ffa3af388cd"
        },
        {
            "conditions": [
                {
                    "path": "sub.rogue.level",
                    "type": "eq",
                    "value": 14
                }
            ],
            "config": [
                {
                    "dict": {
                        "dmg": "8d6"
                    },
                    "name": "Sneak Attack",
                    "path": "abilities.Sneak Attack",
                    "type": "dict",
                    "uuid": "93a29b60-a223-45c2-ab4c-7449958d6fb9"
                },
                {
                    "description": "You have acquired greater mental strength. You gain proficiency in Wisdom saving throws.",
                    "given": [
                        {
                            "id": "wisdom",
                            "name": "Wisdom",
                            "type": "statistics"
                        }
                    ],
                    "list": [],
                    "name": "Slippery Mind",
                    "path": "proficiencies.saving_throws",
                    "type": "objectlist",
                    "uuid": "2085c13e-447d-4c6f-8653-97127779422d"
                }
            ],
            "name": "Rogue 15",
            "type": "config",
            "uuid": "086e6fbf-9b73-4eed-8a7c-6983c5382b0d"
        },
        {
            "conditions": [
                {
                    "path": "sub.rogue.level",
                    "type": "eq",
                    "value": 15
                }
            ],
            "config": [
                {
                    "name": "ASI or Feat",
                    "options": [
                        {
                            "description": "You can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can''t increase an ability score above 20 using this feature.",
                            "limit": 2,
                            "name": "Ability Score Improvement",
                            "type": "ability_score",
                            "uuid": "b81d058f-9f21-443f-aea7-acaadb8bb65f"
                        },
                        {
                            "add": 1,
                            "description": "A feat represents a talent or an area of expertise that gives a character special capabilities. It embodies training, experience, and abilities beyond what a class provides. See chapter 6 of the Player\u2019s Handbook for more information.",
                            "include": 3,
                            "name": "Feat",
                            "type": "multichoice",
                            "uuid": "283cd754-e8ef-4574-8eaa-ab29e7b68bbb"
                        }
                    ],
                    "type": "choice",
                    "uuid": "b7e9f240-4f9c-4b27-93e1-dd856b7b4dbb"
                }
            ],
            "name": "Rogue 16",
            "type": "config",
            "uuid": "25bfaebf-6d9e-4044-8285-4115ffa42c44"
        },
        {
            "conditions": [
                {
                    "path": "sub.rogue.level",
                    "type": "eq",
                    "value": 16
                }
            ],
            "config": [
                {
                    "dict": {
                        "dmg": "9d6"
                    },
                    "name": "Sneak Attack",
                    "path": "abilities.Sneak Attack",
                    "type": "dict",
                    "uuid": "0740bb1f-1e09-4462-ab1c-25b7706b530f"
                }
            ],
            "name": "Rogue 17",
            "type": "config",
            "uuid": "a9c3bda7-2f84-408f-8a9a-f7821c3f5d25"
        },
        {
            "conditions": [
                {
                    "path": "sub.rogue.level",
                    "type": "eq",
                    "value": 17
                }
            ],
            "config": [
                {
                    "dict": {
                        "description": "You are so evasive that attackers rarely gain the upper hand against you. No **attack** roll has **advantage** against you while you aren\u2019t incapacitated."
                    },
                    "name": "Elusive",
                    "path": "abilities.Elusive",
                    "type": "dict",
                    "uuid": "4c8b5dcd-541a-4193-857b-d2c8bfa4daed"
                }
            ],
            "name": "Rogue 18",
            "type": "config",
            "uuid": "9e52795d-faa4-4fab-8f4d-325e2f6a607d"
        },
        {
            "conditions": [
                {
                    "path": "sub.rogue.level",
                    "type": "eq",
                    "value": 18
                }
            ],
            "config": [
                {
                    "dict": {
                        "dmg": "10d6"
                    },
                    "name": "Sneak Attack",
                    "path": "abilities.Sneak Attack",
                    "type": "dict",
                    "uuid": "2edbe6da-c3f7-40c0-bee4-5b25d1d1a788"
                },
                {
                    "name": "ASI or Feat",
                    "options": [
                        {
                            "description": "You can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can''t increase an ability score above 20 using this feature.",
                            "limit": 2,
                            "name": "Ability Score Improvement",
                            "type": "ability_score",
                            "uuid": "02927e3d-c834-4846-9f58-d38dbdadc5d2"
                        },
                        {
                            "add": 1,
                            "description": "A feat represents a talent or an area of expertise that gives a character special capabilities. It embodies training, experience, and abilities beyond what a class provides. See chapter 6 of the Player\u2019s Handbook for more information.",
                            "include": 3,
                            "name": "Feat",
                            "type": "multichoice",
                            "uuid": "91c547e3-0e6c-41bf-a6ac-d2601693645b"
                        }
                    ],
                    "type": "choice",
                    "uuid": "25301a67-a2e3-4d31-a30f-f06ac672bcc0"
                }
            ],
            "name": "Rogue 19",
            "type": "config",
            "uuid": "5dd6e426-003d-41c9-8077-73226ea3649a"
        },
        {
            "conditions": [
                {
                    "path": "sub.rogue.level",
                    "type": "eq",
                    "value": 19
                }
            ],
            "config": [
                {
                    "dict": {
                        "description": "You have an uncanny knack for succeeding when you need to. If your **attack** misses a target within\nrange, you can turn the miss into a hit. Alternatively, if you fail an ability check, you can treat the d20 roll as a 20.\nOnce you use this feature, you can\u2019t use it again until you finish a short or long rest."
                    },
                    "name": "Stroke of Luck",
                    "path": "abilities.Stroke of Luck",
                    "type": "dict",
                    "uuid": "cad54789-ed60-4361-95f0-025332f9692d"
                }
            ],
            "name": "Rogue 20",
            "type": "config",
            "uuid": "db10ebb2-b7b7-40b2-b9b5-adbce0422448"
        }
    ],
    "subclass_level": 3,
    "type": "config",
    "uuid": "9bca98f0-f7b7-4903-b692-353c18b43bba"
}');
INSERT INTO `class` (id, name, config)
    VALUES (4, 'Wizard', '{
    "caster_rank": 1,
    "conditions": [],
    "config": [
        {
            "config": [
                {
                    "hidden": true,
                    "path": "sub.wizard.hit_dice",
                    "type": "value",
                    "uuid": "751c8976-6eef-41aa-bb8f-c730c868e086",
                    "value": 6
                },
                {
                    "conditions": [
                        {
                            "path": "character.level",
                            "type": "lte",
                            "value": 1
                        }
                    ],
                    "config": [
                        {
                            "given": [
                                "sub.wizard.hit_dice"
                            ],
                            "hidden": true,
                            "path": "computed.hit_points.formulas",
                            "type": "list",
                            "uuid": "12e78422-a6b2-4c59-858c-1553331bc63b"
                        },
                        {
                            "given": [
                                "statistics.modifiers.constitution * character.level"
                            ],
                            "hidden": true,
                            "multiple": true,
                            "path": "computed.hit_points.bonus",
                            "type": "list",
                            "uuid": "8d17ea37-1331-47b0-80f8-550148507390"
                        }
                    ],
                    "description": "`6` + your **Constitution modifier**",
                    "name": "Hit Points at First Level",
                    "type": "config",
                    "uuid": "1aee06cf-05b6-4939-978b-f37f488dab4e"
                },
                {
                    "config": [
                        {
                            "given": [
                                "4 * (sub.wizard.level - 1)"
                            ],
                            "hidden": true,
                            "multiple": true,
                            "path": "computed.hit_points.bonus",
                            "type": "list",
                            "uuid": "609d0546-e73f-43e2-a663-c28aedd84698"
                        }
                    ],
                    "description": "`1d6` (`4`) + your **Constitution modifier** per **Wizard** level after 1st",
                    "name": "Hit Points at Higher Levels",
                    "type": "config",
                    "uuid": "128ee3ed-5341-41ec-a671-8aae204bc464"
                }
            ],
            "description": "`1d6` per **Wizard** level",
            "name": "Hit Dice",
            "type": "config",
            "uuid": "65b88912-2d65-4b06-a379-80d61720d696"
        },
        {
            "config": [
                {
                    "description": "None",
                    "name": "Armor",
                    "type": "config",
                    "uuid": "2e489581-ebb2-4b47-8f7e-6719c1063ed2"
                },
                {
                    "description": "Daggers, darts, slings, quarterstaffs, light crossbows",
                    "given": [
                        {
                            "id": 1,
                            "name": "Dagger",
                            "type": "simple melee"
                        },
                        {
                            "id": 13,
                            "name": "Dart",
                            "type": "simple ranged"
                        },
                        {
                            "id": 15,
                            "name": "Sling",
                            "type": "simple ranged"
                        },
                        {
                            "id": 8,
                            "name": "Quarterstaff",
                            "type": "simple melee"
                        },
                        {
                            "id": 12,
                            "name": "Crossbow, light",
                            "type": "simple ranged"
                        }
                    ],
                    "list": [],
                    "name": "Weapon Proficiency",
                    "path": "proficiencies.weapons",
                    "type": "objectlist",
                    "uuid": "642d8ad7-4eb2-43f8-befc-b9d95918bdf0"
                },
                {
                    "description": "None",
                    "name": "Tools",
                    "type": "config",
                    "uuid": "6005a890-504d-4676-9353-34332d871562"
                },
                {
                    "description": "Intelligence, Wisdom",
                    "given": [
                        {
                            "id": "intelligence",
                            "name": "Intelligence",
                            "type": "statistics"
                        },
                        {
                            "id": "wisdom",
                            "name": "Wisdom",
                            "type": "statistics"
                        }
                    ],
                    "list": [],
                    "name": "Saving Throws",
                    "path": "proficiencies.saving_throws",
                    "type": "objectlist",
                    "uuid": "01f23581-8294-46ff-9ddc-356f354608b7"
                },
                {
                    "add": 2,
                    "description": "Choose two from Arcana, History, Insight, Investigation, Medicine, and Religion",
                    "filter": [
                        {
                            "field": "id",
                            "options": [
                                "arcana",
                                "history",
                                "insight",
                                "investigation",
                                "medicine",
                                "religion"
                            ],
                            "type": "attribute"
                        }
                    ],
                    "list": [
                        "skills"
                    ],
                    "name": "Skill Proficiency",
                    "path": "proficiencies.skills",
                    "type": "objectlist",
                    "uuid": "01f49422-429d-4082-8600-1ad796300f50"
                }
            ],
            "name": "Proficiencies",
            "type": "config",
            "uuid": "3e34a3fe-edf7-4711-9691-b606ee2b9a85"
        },
        {
            "config": [
                {
                    "description": "(a) a quarterstaff or (b) a dagger",
                    "options": [
                        {
                            "given": [
                                {
                                    "count": 1,
                                    "id": 8,
                                    "name": "Quarterstaff",
                                    "type": "simple melee"
                                }
                            ],
                            "list": [],
                            "multiple": true,
                            "name": "Quarterstaff",
                            "path": "equipment",
                            "type": "objectlist",
                            "uuid": "6fa0c10b-6ac6-4cdc-808b-1447862d0e37"
                        },
                        {
                            "given": [
                                {
                                    "count": 1,
                                    "id": 1,
                                    "name": "Dagger",
                                    "type": "simple melee"
                                }
                            ],
                            "list": [],
                            "multiple": true,
                            "name": "Dagger",
                            "path": "equipment",
                            "type": "objectlist",
                            "uuid": "29430b20-5b82-4db7-9982-67e86d88e497"
                        }
                    ],
                    "type": "choice",
                    "uuid": "5c38c1b0-9be6-4492-831a-11fc79eec03f"
                },
                {
                    "description": "(a) a component pouch or (b) an arcane focus",
                    "options": [
                        {
                            "given": [
                                {
                                    "count": 1,
                                    "id": 228,
                                    "name": "Component pouch",
                                    "type": "gear"
                                }
                            ],
                            "list": [],
                            "multiple": true,
                            "name": "Component pouch",
                            "path": "equipment",
                            "type": "objectlist",
                            "uuid": "2c3c704b-e112-463b-992c-820c4d158b66"
                        },
                        {
                            "add": 1,
                            "filter": [
                                {
                                    "field": "group",
                                    "options": [
                                        "arcane focus"
                                    ],
                                    "type": "attribute"
                                }
                            ],
                            "given": [],
                            "list": [
                                "gear"
                            ],
                            "multiple": true,
                            "name": "Arcane focus",
                            "path": "equipment",
                            "type": "objectlist",
                            "uuid": "e6893df4-894b-4102-b9a6-91398489aa9b"
                        }
                    ],
                    "type": "choice",
                    "uuid": "cf7942bc-2f6b-4cdd-a439-426761a2091e"
                },
                {
                    "description": "(a) a scholar\u2019s pack or (b) an explorer\u2019s pack",
                    "filter": [
                        {
                            "field": "uuid",
                            "options": [
                                "2199848e-b3e3-40c8-9f8a-af3fdac5911c",
                                "28d04479-11f4-4b23-aad7-ee92ec818ddd"
                            ],
                            "type": "attribute"
                        }
                    ],
                    "include": 2,
                    "type": "choice",
                    "uuid": "bb78219a-0e19-478d-928a-bad753d2a56a"
                },
                {
                    "given": [
                        {
                            "count": 1,
                            "id": 282,
                            "name": "Spellbook",
                            "type": "gear"
                        }
                    ],
                    "list": [],
                    "multiple": true,
                    "name": "A spellbook",
                    "path": "equipment",
                    "type": "objectlist",
                    "uuid": "0927bef2-7a4c-45d3-a155-3f3650cf29cd"
                }
            ],
            "description": "You start with the following equipment, in addition to the\nequipment granted by your background:",
            "name": "Equipment",
            "type": "config",
            "uuid": "21a9d3d0-be32-479e-859c-c1bb4b0979cc"
        },
        {
            "config": [
                {
                    "description": "At 1st level, you know three cantrips of your choice from\nthe wizard spell list. You learn additional wizard cantrips\nof your choice at higher levels, as shown in the Cantrips\nKnown column of the Wizard table.",
                    "filter": [
                        {
                            "field": "classes",
                            "options": [
                                "Wizard"
                            ],
                            "type": "textfield"
                        },
                        {
                            "field": "level",
                            "options": [
                                "Cantrip"
                            ],
                            "type": "attribute"
                        }
                    ],
                    "limit_formula": "spell.max_cantrips",
                    "list": [
                        "spell"
                    ],
                    "name": "Cantrips",
                    "path": "sub.wizard.spell.cantrips",
                    "type": "objectlist",
                    "uuid": "7d2483bd-922e-4e9d-908b-86b359215ec6"
                },
                {
                    "name": "Spellbook",
                    "path": "info.Spellbook",
                    "type": "value",
                    "uuid": "a5225c43-8c6b-47f1-8aff-3d7e2084fbe7",
                    "value": "\nYou have a spellbook containing all your wizard spells of your choice. Your spellbook is the repository of the wizard spells you know, except your cantrips,\nwhich are fixed in your mind."
                },
                {
                    "name": "Casting Wizard Spells",
                    "path": "info.Casting Wizard Spells",
                    "type": "value",
                    "uuid": "ae3be339-f8cb-4885-9f4d-55e47f60a765",
                    "value": "The Wizard table shows how many spell slots you have\nto cast your wizard spells of 1st level and higher. To cast\none of these spells, you must expend a slot of the spell\u2019s\nlevel or higher. You regain all expended spell slots when\nyou finish a long rest."
                },
                {
                    "dict": {
                        "description": "You prepare the list of wizard spells that are available or you to cast. To do so, choose a number of wizard spells\nfrom your spellbook equal to %(limit)s. The spells must be of a level for which you have spell slots.\n\nYou can change your list of prepared spells when you finish a long rest. Preparing a new list of wizard spells\nrequires time spent studying your spellbook and memorizing the incantations and gestures you must make to\ncast the spell: at least 1 minute per spell level for each spell on your list.",
                        "limit_default": "your **Intelligence modifier** + your wizard level (minimum of one spell)",
                        "limit_formula": "max(1, character.level + statistics.modifiers.intelligence)"
                    },
                    "name": "Preparing Wizard Spells",
                    "path": "abilities.Preparing Wizard Spells",
                    "type": "dict",
                    "uuid": "40b135c0-d2b8-4147-ac5e-ea083c690d7d"
                },
                {
                    "config": [
                        {
                            "hidden": true,
                            "path": "sub.wizard.spell.stat",
                            "type": "value",
                            "uuid": "fe6e224e-e57d-4c48-85d9-6a0ab94bc944",
                            "value": "intelligence"
                        },
                        {
                            "config": [
                                {
                                    "given": [
                                        "8 + character.proficiency + statistics.modifiers.intelligence"
                                    ],
                                    "hidden": true,
                                    "path": "computed.subWizardSpellSafe_dc.formulas",
                                    "type": "list",
                                    "uuid": "ca49b542-5855-411a-81f2-dfda7811124a"
                                },
                                {
                                    "config": [
                                        {
                                            "given": [
                                                "character.proficiency + statistics.modifiers.intelligence"
                                            ],
                                            "hidden": true,
                                            "path": "computed.subWizardSpellAttack_modifier.formulas",
                                            "type": "list",
                                            "uuid": "3cf908fd-9b3f-4915-90df-76ec1f766ba3"
                                        },
                                        {
                                            "name": "Ritual Casting",
                                            "path": "info.Ritual Casting",
                                            "type": "value",
                                            "uuid": "8c2ed8db-0f5d-4e70-b050-c66685c2ff30",
                                            "value": "You can cast a wizard spell as a ritual if that spell has the ritual tag and you have the spell in your spellbook. You\ndon\u2019t need to have the spell prepared."
                                        },
                                        {
                                            "name": "Spellcasting Focus",
                                            "path": "info.Spellcasting Focus",
                                            "type": "value",
                                            "uuid": "93aa295a-a614-4dbc-9d94-f030980b0ff7",
                                            "value": "You can use an arcane focus (found in chapter 5) as a\nspellcasting focus for your wizard spells."
                                        },
                                        {
                                            "name": "Learning Spells of 1st Level and Higher",
                                            "path": "info.Learning Spells of 1st Level and Higher",
                                            "type": "value",
                                            "uuid": "899412c9-9054-4c46-b4e3-f5df1bb49af9",
                                            "value": "Each time you gain a wizard level, you can add two wizard spells of your choice to your spellbook for free. Each\nof these spells must be of a level for which you have spell slots, as shown on the Wizard table. On your adventures,\nyou might find other spells that you can add to your spellbook (see the \u201cYour Spellbook\u201d sidebar)."
                                        }
                                    ],
                                    "description": "Your **proficiency bonus** + your **intelligence**",
                                    "name": "Spell attack modifier",
                                    "type": "config",
                                    "uuid": "77525cad-68f4-47e8-a09a-a5a35fce5bd7"
                                }
                            ],
                            "description": "`8` + your **Proficiency bonus** + your **intelligence**",
                            "name": "Spell save DC",
                            "type": "config",
                            "uuid": "b6286af2-3f83-44b4-95b3-d1ffb98dff13"
                        }
                    ],
                    "description": "**Intelligence** is your spellcasting ability for your wizard spells, since you learn your spells through dedicated\nstudy and memorization. You use your Intelligence whenever a spell refers to your spellcasting ability. In\naddition, you use your Intelligence modifier when setting the saving throw DC for a wizard spell you cast and when\nmaking an attack roll with one.",
                    "name": "Spellcasting Ability",
                    "type": "config",
                    "uuid": "b6812539-edb2-40b5-9418-9c0319d0b90b"
                },
                {
                    "dict": {
                        "description": "You have learned to regain some of your magical energy by studying your spellbook. Once per day when you finish a short rest, you can choose expended spell slots to recover. The spell slots can have a combined level that is equal to or less than %(limit)s, and none of the slots can be 6th level or higher.",
                        "limit_default": "half your wizard level (rounded up)",
                        "limit_formula": "ceil(sub.wizard.level / 2.0)"
                    },
                    "name": "Arcane Recovery",
                    "path": "abilities.Arcane Recovery",
                    "type": "dict",
                    "uuid": "acbceb59-e763-49bf-bbb2-e505413774f2"
                }
            ],
            "description": "As a student of arcane magic, you have a spellbook containing spells that show the first glimmerings of your true\npower. See chapter 10 for the general rules of spellcasting and chapter 11 for the wizard spell list.",
            "name": "Spellcasting",
            "type": "config",
            "uuid": "23edbb33-adba-4a28-81a2-9f6a3c4b7467"
        }
    ],
    "description": "Clad in the silver robes that denote her station, an elf\ncloses her eyes to shut out the distractions of the battlefield and begins her quiet chant. Fingers weaving in front\nof her, she completes her spell and launches a tiny bead\nof fire toward the enemy ranks, where it erupts into a conflagration that engulfs the soldiers.\n\nChecking and rechecking his work, a human scribes\nan intricate magic circle in chalk on the bare stone\nfloor, then sprinkles powdered iron along every line and\ngraceful curve. When the circle is complete, he drones\na long incantation. A hole opens in space inside the circle, bringing a whiff of brimstone from the otherworldly\nplane beyond.\n\nCrouching on the floor in a dungeon intersection, a\ngnome tosses a handful of small bones inscribed with\nmystic symbols, muttering a few words of power over\nthem. Closing his eyes to see the visions more clearly,\nhe nods slowly, then opens his eyes and points down the\npassage to his left.\n\nWizards are supreme magic-users, defined and united\nas a class by the spells they cast. Drawing on the subtle\nweave of magic that permeates the cosmos, wizards cast\nspells of explosive fire, arcing lightning, subtle deception,\nand brute-force mind control. Their magic conjures monsters from other planes of existence, glimpses the future,\nor turns slain foes into zombies. Their mightiest spells\nchange one substance into another, call meteors down\nfrom the sky, or open portals to other worlds.\n\n## Scholars of the Arcane\n\nWild and enigmatic, varied in form and function, the\npower of magic draws students who seek to master its\nmysteries. Some aspire to become like the gods, shaping reality itself. Though the casting of a typical spell\nrequires merely the utterance of a few strange words,\nfleeting gestures, and sometimes a pinch or clump of\nexotic materials, these surface components barely hint at\nthe expertise attained after years of apprenticeship and\ncountless hours of study.\n\nWizards live and die by their spells. Everything else is\nsecondary. They learn new spells as they experiment and\ngrow in experience. They can also learn them from other\nwizards, from ancient tomes or inscriptions, and from ancient creatures (such as the fey) that are steeped in magic.\n\n\n## The Lure of Knowledge\n\nWizards\u2019 lives are seldom mundane. The closest a wizard\nis likely to come to an ordinary life is working as a sage\nor lecturer in a library or university, teaching others the\nsecrets of the multiverse. Other wizards sell their services as diviners, serve in military forces, or pursue lives\nof crime or domination.\n\nBut the lure of knowledge and power calls even the\nmost unadventurous wizards out of the safety of their\nlibraries and laboratories and into crumbling ruins and\nlost cities. Most wizards believe that their counterparts\nin ancient civilizations knew secrets of magic that have\nbeen lost to the ages, and discovering those secrets could\nunlock the path to a power greater than any magic available in the present age.",
    "features": {
        "casting_stat": "intelligence",
        "max_cantrips": [ 3, 3, 3, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5 ],
        "spell.cleric.max_prepared_formula": "max(1, character.level + statistics.modifiers.intelligence)",
        "slots": [
            [ 2 ],
            [ 2 ],
            [ 3, 2 ],
            [ 4, 3 ],
            [ 4, 3, 2 ],
            [ 4, 3, 3 ],
            [ 4, 3, 3, 1 ],
            [ 4, 3, 3, 2 ],
            [ 4, 3, 3, 3, 1 ],
            [ 4, 3, 3, 3, 2 ],
            [ 4, 3, 3, 3, 2, 1 ],
            [ 4, 3, 3, 3, 2, 1 ],
            [ 4, 3, 3, 3, 2, 1, 1 ],
            [ 4, 3, 3, 3, 2, 1, 1 ],
            [ 4, 3, 3, 3, 2, 1, 1, 1 ],
            [ 4, 3, 3, 3, 2, 1, 1, 1 ],
            [ 4, 3, 3, 3, 2, 1, 1, 1, 1 ],
            [ 4, 3, 3, 3, 3, 1, 1, 1, 1 ],
            [ 4, 3, 3, 3, 3, 2, 1, 1, 1 ],
            [ 4, 3, 3, 3, 3, 2, 2, 1, 1 ]
        ]
    },
    "phases": [
        {
            "conditions": [
                {
                    "path": "sub.wizard.level",
                    "type": "eq",
                    "value": 1
                }
            ],
            "config": [
                {
                    "description": "The study of wizardry is ancient, stretching back to the earliest mortal discoveries of magic. It is firmly established in the worlds of D&D, with various traditions\ndedicated to its complex study.\n\nThe most common arcane traditions in the multiverse revolve around the schools of magic. Wizards through\nthe ages have cataloged thousands of spells, grouping them into eight categories called schools, as described\nin chapter 10. In some places, these traditions are literally schools. Elsewhere, they are more like academic\ndepartments, with rival faculties competing for students and funding. Even wizards who train apprentices in the\nsolitude of their own towers use the division of magic into schools as a learning device, since the spells of each\nschool require mastery of different techniques.",
                    "name": "Arcane Tradition",
                    "subtype": true,
                    "type": "choice",
                    "uuid": "66d7cd14-d857-47fb-a164-f8fc689b3364"
                }
            ],
            "name": "Wizard 2",
            "type": "config",
            "uuid": "6a914a9d-a4e1-447b-8ba8-3165cfbdbd3d"
        },
        {
            "conditions": [
                {
                    "path": "sub.wizard.level",
                    "type": "eq",
                    "value": 2
                }
            ],
            "config": [],
            "name": "Wizard 3",
            "type": "config",
            "uuid": "ff16a921-71d1-439c-a4de-9115e5937f8e"
        },
        {
            "conditions": [
                {
                    "path": "sub.wizard.level",
                    "type": "eq",
                    "value": 3
                }
            ],
            "config": [
                {
                    "name": "ASI or Feat",
                    "options": [
                        {
                            "description": "You can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can''t increase an ability score above 20 using this feature.",
                            "limit": 2,
                            "name": "Ability Score Improvement",
                            "type": "ability_score",
                            "uuid": "afea1fa2-57ae-4fd8-975e-5afcb33c8a25"
                        },
                        {
                            "add": 1,
                            "description": "A feat represents a talent or an area of expertise that gives a character special capabilities. It embodies training, experience, and abilities beyond what a class provides. See chapter 6 of the Player\u2019s Handbook for more information.",
                            "include": 3,
                            "name": "Feat",
                            "type": "multichoice",
                            "uuid": "327507a1-b05d-4032-a39c-c9224671af44"
                        }
                    ],
                    "type": "choice",
                    "uuid": "10bf3472-d8b8-427e-bf15-08e65c532934"
                }
            ],
            "name": "Wizard 4",
            "type": "config",
            "uuid": "ca008fbe-6385-43b4-af4a-7c8506d53088"
        },
        {
            "conditions": [
                {
                    "path": "sub.wizard.level",
                    "type": "eq",
                    "value": 4
                }
            ],
            "config": [],
            "name": "Wizard 5",
            "type": "config",
            "uuid": "9a6b4d0d-7503-404e-8ad1-f5b022eaddc2"
        },
        {
            "conditions": [
                {
                    "path": "sub.wizard.level",
                    "type": "eq",
                    "value": 5
                }
            ],
            "config": [],
            "name": "Wizard 6",
            "type": "config",
            "uuid": "ade446e7-201b-4212-95cb-d1911d53cc42"
        },
        {
            "conditions": [
                {
                    "path": "sub.wizard.level",
                    "type": "eq",
                    "value": 6
                }
            ],
            "config": [],
            "name": "Wizard 7",
            "type": "config",
            "uuid": "605c6e9c-ad5c-4b67-bedf-ea25b2509417"
        },
        {
            "conditions": [
                {
                    "path": "sub.wizard.level",
                    "type": "eq",
                    "value": 7
                }
            ],
            "config": [
                {
                    "name": "ASI or Feat",
                    "options": [
                        {
                            "description": "You can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can''t increase an ability score above 20 using this feature.",
                            "limit": 2,
                            "name": "Ability Score Improvement",
                            "type": "ability_score",
                            "uuid": "b37e5d43-8e9d-4bec-936d-1a73ed9da5f5"
                        },
                        {
                            "add": 1,
                            "description": "A feat represents a talent or an area of expertise that gives a character special capabilities. It embodies training, experience, and abilities beyond what a class provides. See chapter 6 of the Player\u2019s Handbook for more information.",
                            "include": 3,
                            "name": "Feat",
                            "type": "multichoice",
                            "uuid": "82ac74ba-478f-4ea8-a17a-a1cd80f1e53b"
                        }
                    ],
                    "type": "choice",
                    "uuid": "06279708-9e69-4385-9f8a-34bd55d30fcd"
                }
            ],
            "name": "Wizard 8",
            "type": "config",
            "uuid": "a0dd8ddf-b350-47a8-a9a9-d33327bfc9da"
        },
        {
            "conditions": [
                {
                    "path": "sub.wizard.level",
                    "type": "eq",
                    "value": 8
                }
            ],
            "config": [],
            "name": "Wizard 9",
            "type": "config",
            "uuid": "16a7be11-5754-4d48-a9df-7328e2d0e258"
        },
        {
            "conditions": [
                {
                    "path": "sub.wizard.level",
                    "type": "eq",
                    "value": 9
                }
            ],
            "config": [],
            "name": "Wizard 10",
            "type": "config",
            "uuid": "56fe1d8c-7fb9-4265-a976-a87198096aef"
        },
        {
            "conditions": [
                {
                    "path": "sub.wizard.level",
                    "type": "eq",
                    "value": 10
                }
            ],
            "config": [],
            "name": "Wizard 11",
            "type": "config",
            "uuid": "424333a8-31e0-425d-ab6f-a6145a6bd738"
        },
        {
            "conditions": [
                {
                    "path": "sub.wizard.level",
                    "type": "eq",
                    "value": 11
                }
            ],
            "config": [
                {
                    "name": "ASI or Feat",
                    "options": [
                        {
                            "description": "You can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can''t increase an ability score above 20 using this feature.",
                            "limit": 2,
                            "name": "Ability Score Improvement",
                            "type": "ability_score",
                            "uuid": "6094c2f9-a0cb-4b87-8c60-3994825d4f17"
                        },
                        {
                            "add": 1,
                            "description": "A feat represents a talent or an area of expertise that gives a character special capabilities. It embodies training, experience, and abilities beyond what a class provides. See chapter 6 of the Player\u2019s Handbook for more information.",
                            "include": 3,
                            "name": "Feat",
                            "type": "multichoice",
                            "uuid": "6a0cdf8b-ad6e-46c1-aa5c-5bbfc969e2c7"
                        }
                    ],
                    "type": "choice",
                    "uuid": "38fe3010-fa0c-4116-b314-80ffb40746b6"
                }
            ],
            "name": "Wizard 12",
            "type": "config",
            "uuid": "9b11caa6-6d81-43a3-acaa-6172b8cb3b6d"
        },
        {
            "conditions": [
                {
                    "path": "sub.wizard.level",
                    "type": "eq",
                    "value": 12
                }
            ],
            "config": [],
            "name": "Wizard 13",
            "type": "config",
            "uuid": "7c8d1bba-9725-417f-aa3d-646721e896ba"
        },
        {
            "conditions": [
                {
                    "path": "sub.wizard.level",
                    "type": "eq",
                    "value": 13
                }
            ],
            "config": [],
            "name": "Wizard 14",
            "type": "config",
            "uuid": "d7f28428-ef40-4436-8541-ad33ab33a473"
        },
        {
            "conditions": [
                {
                    "path": "sub.wizard.level",
                    "type": "eq",
                    "value": 14
                }
            ],
            "config": [],
            "name": "Wizard 15",
            "type": "config",
            "uuid": "89aec643-1a67-47b2-b6e9-08a6a73cb0bc"
        },
        {
            "conditions": [
                {
                    "path": "sub.wizard.level",
                    "type": "eq",
                    "value": 15
                }
            ],
            "config": [
                {
                    "name": "ASI or Feat",
                    "options": [
                        {
                            "description": "You can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can''t increase an ability score above 20 using this feature.",
                            "limit": 2,
                            "name": "Ability Score Improvement",
                            "type": "ability_score",
                            "uuid": "f6ac3220-56f0-4b97-84c5-b7db642f4bf9"
                        },
                        {
                            "add": 1,
                            "description": "A feat represents a talent or an area of expertise that gives a character special capabilities. It embodies training, experience, and abilities beyond what a class provides. See chapter 6 of the Player\u2019s Handbook for more information.",
                            "include": 3,
                            "name": "Feat",
                            "type": "multichoice",
                            "uuid": "619801ea-d2e5-41f0-a6b9-166463992a5c"
                        }
                    ],
                    "type": "choice",
                    "uuid": "3b374457-b69b-48de-b8d7-da857d6ad4c9"
                }
            ],
            "name": "Wizard 16",
            "type": "config",
            "uuid": "06b0ba78-714e-4972-9673-b2848c54ab52"
        },
        {
            "conditions": [
                {
                    "path": "sub.wizard.level",
                    "type": "eq",
                    "value": 16
                }
            ],
            "config": [],
            "name": "Wizard 17",
            "type": "config",
            "uuid": "eeff485c-0c37-4d4a-8c54-8beced5fffa6"
        },
        {
            "conditions": [
                {
                    "path": "sub.wizard.level",
                    "type": "eq",
                    "value": 17
                }
            ],
            "config": [
                {
                    "config": [
                        {
                            "dict": {
                                "description": "You can cast *%(first)s* and *%(second)s* at their lowest level without expending a spell slot when you have them prepared. If you want to cast either spell at a higher level, you must expend a spell slot as normal. By spending 8 hours in study, you can exchange one or both of the spells you chose for different spells of the same levels.",
                                "first_default": "your first level mastery spell",
                                "first_formula": "sub.wizard.spell.mastery.first[0].name",
                                "second_default": "your second level mastery spell",
                                "second_formula": "sub.wizard.spell.mastery.second[0].name"
                            },
                            "name": "",
                            "path": "abilities.Spell Mastery",
                            "type": "dict",
                            "uuid": "856a05cf-5a62-48c5-ab5d-4825a0f21a3e"
                        },
                        {
                            "add": 1,
                            "filter": [
                                {
                                    "field": "classes",
                                    "options": [
                                        "Wizard"
                                    ],
                                    "type": "textfield"
                                },
                                {
                                    "field": "level",
                                    "options": [
                                        "1"
                                    ],
                                    "type": "attribute"
                                }
                            ],
                            "list": [
                                "spell"
                            ],
                            "name": "First level Mastery Spell",
                            "path": "sub.wizard.spell.mastery.first",
                            "type": "objectlist",
                            "uuid": "3ee54421-3e99-49cb-8870-0e4f3f1a2454"
                        },
                        {
                            "add": 1,
                            "filter": [
                                {
                                    "field": "classes",
                                    "options": [
                                        "Wizard"
                                    ],
                                    "type": "textfield"
                                },
                                {
                                    "field": "level",
                                    "options": [
                                        "2"
                                    ],
                                    "type": "attribute"
                                }
                            ],
                            "list": [
                                "spell"
                            ],
                            "name": "Second level Mastery Spell",
                            "path": "sub.wizard.spell.mastery.second",
                            "type": "objectlist",
                            "uuid": "df2c8921-1b49-420c-8e41-7f7fb050e399"
                        }
                    ],
                    "description": "You have achieved such mastery over certain spells that you can cast them at will. Choose a\n1st-level wizard spell and a 2nd-level wizard spell that are in your spellbook.",
                    "name": "Spell Mastery",
                    "type": "config",
                    "uuid": "636395fb-ee62-4e5a-830a-c5c75bce3c57"
                }
            ],
            "name": "Wizard 18",
            "type": "config",
            "uuid": "4a21659c-6ee4-4a36-b6f6-1bd47aa32d0b"
        },
        {
            "conditions": [
                {
                    "path": "sub.wizard.level",
                    "type": "eq",
                    "value": 18
                }
            ],
            "config": [
                {
                    "name": "ASI or Feat",
                    "options": [
                        {
                            "description": "You can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can''t increase an ability score above 20 using this feature.",
                            "limit": 2,
                            "name": "Ability Score Improvement",
                            "type": "ability_score",
                            "uuid": "875b79a6-2083-423c-9787-4a1a7b880ea2"
                        },
                        {
                            "add": 1,
                            "description": "A feat represents a talent or an area of expertise that gives a character special capabilities. It embodies training, experience, and abilities beyond what a class provides. See chapter 6 of the Player\u2019s Handbook for more information.",
                            "include": 3,
                            "name": "Feat",
                            "type": "multichoice",
                            "uuid": "dd6e594f-0447-4351-9c0e-17f15b88a63f"
                        }
                    ],
                    "type": "choice",
                    "uuid": "226e845c-9301-4d74-9fe4-060c3b3f6bd2"
                }
            ],
            "name": "Wizard 19",
            "type": "config",
            "uuid": "fed82f69-9adc-47f8-9ef3-52af1027d3f3"
        },
        {
            "conditions": [
                {
                    "path": "sub.wizard.level",
                    "type": "eq",
                    "value": 20
                }
            ],
            "config": [
                {
                    "config": [
                        {
                            "dict": {
                                "description": "You always have *%(first)s* and *%(second)s* prepared. They don\u2019t count against the number of spells you\nhave prepared, and you can cast each of them once at 3rd level without expending a spell slot. When you do so, you\ncan\u2019t do so again until you finish a short or long rest. If you want to cast either spell at a higher level, you\nmust expend a spell slot as normal.",
                                "first_default": "your first 3rd level Signature spell",
                                "first_formula": "sub.wizard.spell.signature[0].name",
                                "second_default": "your second 3rd level Signature spell",
                                "second_formula": "sub.wizard.spell.signature[1].name"
                            },
                            "path": "abilities.Signature Spells",
                            "type": "dict",
                            "uuid": "92ca4efe-632c-4ae7-bbad-15e49ee5cea3"
                        },
                        {
                            "filter": [
                                {
                                    "field": "classes",
                                    "options": [
                                        "Wizard"
                                    ],
                                    "type": "textfield"
                                },
                                {
                                    "field": "level",
                                    "options": [
                                        "3"
                                    ],
                                    "type": "attribute"
                                }
                            ],
                            "limit": 2,
                            "list": [
                                "spell"
                            ],
                            "name": "Spells",
                            "path": "sub.wizard.spell.signature",
                            "type": "objectlist",
                            "uuid": "d132a10a-5395-472e-a0b8-f3f329a6d65f"
                        }
                    ],
                    "description": "You gain mastery over two powerful spells and can cast them with little effort.\nChoose two 3rd-level wizard spells in your spellbook as our signature spells.",
                    "name": "Signature Spells",
                    "type": "config",
                    "uuid": "ebab08bf-870f-4453-b268-11f6966edb3a"
                }
            ],
            "name": "Wizard 20",
            "type": "config",
            "uuid": "ff8c4018-d073-4eef-9e6c-1ca0b361b4f3"
        }
    ],
    "subclass_level": 2,
    "type": "config",
    "uuid": "e3dc2ba1-0014-4797-aa57-83d1f28954e8"
}');

INSERT INTO `subclass` (id, name, class_id, config)
    VALUES (1, 'Life Domain', 1, '{
    "conditions": [],
    "config": [
        {
            "description": "When you choose this domain at 1st level, you gain proficiency with heavy armor.",
            "given": [
                {
                    "id": "heavy",
                    "name": "Heavy Armor",
                    "type": "armor_types"
                }
            ],
            "list": [],
            "name": "Bonus Proficiency",
            "path": "proficiencies.armor",
            "type": "objectlist",
            "uuid": "750c1750-f467-4128-9094-e5d612486dbf"
        },
        {
            "name": "Disciple of Life",
            "path": "info.Disciple of Life",
            "type": "value",
            "uuid": "f395c008-52de-4352-a88a-9b2ababc3ddb",
            "value": "Also starting at 1st level, your healing spells are more\neffective. Whenever you use a spell of 1st level or higher\nto restore hit points to a creature, the creature regains\nadditional hit points equal to 2 + the spell\u2019s level."
        },
        {
            "description": "Each domain has a list of spells\u2014its domain spells\u2014that\nyou gain at the cleric levels noted in the domain description. Once you gain a domain spell, you always have it\nprepared, and it doesn\u2019t count against the number of\nspells you can prepare each day.\n\nIf you have a domain spell that doesn\u2019t appear on the\ncleric spell list, the spell is nonetheless a cleric spell for you",
            "given": [
                {
                    "id": 29,
                    "name": "Bless",
                    "type": "spell"
                },
                {
                    "id": 70,
                    "name": "Cure Wounds",
                    "type": "spell"
                }
            ],
            "list": [],
            "name": "Life Domain Spells",
            "path": "sub.cleric.spell.list",
            "type": "objectlist",
            "uuid": "e7ecaf3c-495a-4c71-a09a-ae6a99950204"
        }
    ],
    "description": "The Life domain focuses on the vibrant positive energy\u2014one of the fundamental forces of the universe\u2014that\nsustains all life. The gods of life promote vitality and\nhealth through healing the sick and wounded, caring for those in need, and driving away the forces of death and\nundeath. Almost any non-evil deity can claim influence\nover this domain, particularly agricultural deities (such\nas Chauntea, Arawai, and Demeter), sun gods (such as\nLathander, Pelor, and Re-Horakhty), gods of healing\nor endurance (such as Ilmater, Mishakal, Apollo, and\nDiancecht), and gods of home and community (such as\nHestia, Hathor, and Boldrei).\n\n## Life Domain Spells\n| Cleric Level | Spells |\n| --- | --- |\n| 1st | bless, cure wounds |\n| 3rd | lesser restoration, spiritual weapon |\n| 5th | beacon of hope, revivify |\n| 7th | death ward, guardian of faith |\n| 9th | mass cure wounds, raise dead |",
    "phases": [
        {
            "conditions": [
                {
                    "path": "sub.lifedomain.level",
                    "type": "eq",
                    "value": 1
                }
            ],
            "config": [
                {
                    "dict": {
                        "description": "You can use your **Channel Divinity** to heal the badly injured.\nAs an **action**, you present your holy symbol and evoke\nhealing energy that can restore a number of hit points\nequal to %(hp)s. Choose any creatures\nwithin 30 feet of you, and divide those hit points among\nthem. This feature can restore a creature to no more than\nhalf of its hit point maximum. You can\u2019t use this feature\non an undead or a construct.",
                        "hp_default": "five times your cleric level",
                        "hp_formula": "5 * character.level"
                    },
                    "name": "Channel Divinity: Preserve Life",
                    "path": "abilities.Channel Divinity: Preserve Life",
                    "type": "dict",
                    "uuid": "3688da16-64e8-42c7-8263-594fd9c804cb"
                }
            ],
            "name": "Life Domain 2",
            "type": "config",
            "uuid": "47c533a5-4611-4815-bee5-5de4474354ed"
        },
        {
            "conditions": [
                {
                    "needle": "Life Domain",
                    "path": "eq",
                    "value": 2
                }
            ],
            "config": [
                {
                    "description": "",
                    "given": [
                        {
                            "id": 178,
                            "name": "Lesser Restoration"
                        },
                        {
                            "id": 278,
                            "name": "Spiritual Weapon"
                        }
                    ],
                    "list": [],
                    "name": "Life Domain Spells",
                    "path": "sub.cleric.spell.list",
                    "type": "objectlist",
                    "uuid": "bbc6c51b-1525-4cb4-95d1-49c3519bdc22"
                }
            ],
            "name": "Life Domain 3",
            "type": "config",
            "uuid": "61d2826a-ea77-4d42-9897-43165c15f713"
        },
        {
            "conditions": [
                {
                    "path": "sub.lifedomain.level",
                    "type": "eq",
                    "value": 3
                }
            ],
            "config": [],
            "name": "Life Domain 4",
            "type": "config",
            "uuid": "8e191111-43bd-4031-8566-3aad823ae55a"
        },
        {
            "conditions": [
                {
                    "path": "sub.lifedomain.level",
                    "type": "eq",
                    "value": 4
                }
            ],
            "config": [
                {
                    "given": [
                        {
                            "id": 25,
                            "name": "Beacon of Hope"
                        },
                        {
                            "id": 248,
                            "name": "Revivify"
                        }
                    ],
                    "list": [],
                    "name": "Life Domain Spells",
                    "path": "sub.cleric.spell.list",
                    "type": "objectlist",
                    "uuid": "e4db07b6-8869-4387-bdf1-70b215daeb53"
                }
            ],
            "name": "Life Domain 5",
            "type": "config",
            "uuid": "e0ed171c-05e1-4fbd-b6c0-13b3df5d178d"
        },
        {
            "conditions": [
                {
                    "path": "sub.lifedomain.level",
                    "type": "eq",
                    "value": 5
                }
            ],
            "config": [
                {
                    "name": "Blessed Healer",
                    "path": "info.Blessed Healer",
                    "type": "value",
                    "uuid": "1632e732-042e-4000-b60b-437ca3af7792",
                    "value": "The healing spells you cast on others heal you as well. When you cast a spell of 1st level\nor higher that restores hit points to a creature other than you, you regain hit points equal to 2 + the spell\u2019s level."
                }
            ],
            "name": "Life Domain 6",
            "type": "config",
            "uuid": "97009adb-2da2-4d12-b14b-42cd8458b9ba"
        },
        {
            "conditions": [
                {
                    "path": "sub.lifedomain.level",
                    "type": "eq",
                    "value": 6
                }
            ],
            "config": [
                {
                    "given": [
                        {
                            "id": 75,
                            "name": "Death Ward"
                        },
                        {
                            "id": 144,
                            "name": "Guardian of Faith"
                        }
                    ],
                    "list": [],
                    "name": "Life Domain Spells",
                    "path": "sub.cleric.spell.list",
                    "type": "objectlist",
                    "uuid": "671e5995-02a8-4b60-9557-663803898b33"
                }
            ],
            "name": "Life Domain 7",
            "type": "config",
            "uuid": "e3f5d9d1-ad68-4eb5-96a1-431d59994f60"
        },
        {
            "conditions": [
                {
                    "path": "sub.lifedomain.level",
                    "type": "eq",
                    "value": 7
                }
            ],
            "config": [
                {
                    "dict": {
                        "description": "You have the ability to infuse your weapon strikes with divine energy. Once on each of your turns\nwhen you hit a creature with a weapon attack, you can cause the attack to deal an extra `%(dmg)s` radiant damage to\nthe target.",
                        "dmg": "1d8"
                    },
                    "name": "Divine Strike",
                    "path": "abilities.Divine Strike",
                    "type": "dict",
                    "uuid": "184315ca-4d1c-45fb-be65-6bf1ff8b593c"
                }
            ],
            "name": "Life Domain 8",
            "type": "config",
            "uuid": "c874b594-95ba-4759-bbb5-d9dddf6e07d0"
        },
        {
            "conditions": [
                {
                    "path": "sub.lifedomain.level",
                    "type": "eq",
                    "value": 8
                }
            ],
            "config": [
                {
                    "given": [
                        {
                            "id": 195,
                            "name": "Mass Cure Wounds"
                        },
                        {
                            "id": 238,
                            "name": "Raise Dead"
                        }
                    ],
                    "list": [],
                    "name": "Life Domain Spells",
                    "path": "sub.cleric.spell.list",
                    "type": "objectlist",
                    "uuid": "7f4ac717-5c49-45a4-8597-a893ac9a60e9"
                }
            ],
            "name": "Life Domain 9",
            "type": "config",
            "uuid": "020c8673-0949-4983-b153-b81d22c5f627"
        },
        {
            "conditions": [
                {
                    "path": "sub.lifedomain.level",
                    "type": "eq",
                    "value": 9
                }
            ],
            "config": [],
            "name": "Life Domain 10",
            "type": "config",
            "uuid": "36a0261f-74fd-4baf-99b3-781acdd4a608"
        },
        {
            "conditions": [
                {
                    "path": "sub.lifedomain.level",
                    "type": "eq",
                    "value": 10
                }
            ],
            "config": [],
            "name": "Life Domain 11",
            "type": "config",
            "uuid": "c492d6d6-0bdf-4f09-8ad6-2370f1374fb7"
        },
        {
            "conditions": [
                {
                    "path": "sub.lifedomain.level",
                    "type": "eq",
                    "value": 11
                }
            ],
            "config": [],
            "name": "Life Domain 12",
            "type": "config",
            "uuid": "62d39698-a944-4149-82fd-922e63fd217d"
        },
        {
            "conditions": [
                {
                    "path": "sub.lifedomain.level",
                    "type": "eq",
                    "value": 12
                }
            ],
            "config": [],
            "name": "Life Domain 13",
            "type": "config",
            "uuid": "49e55a5e-d09d-4ce3-9950-ca32c5e8594e"
        },
        {
            "conditions": [
                {
                    "path": "sub.lifedomain.level",
                    "type": "eq",
                    "value": 13
                }
            ],
            "config": [
                {
                    "dict": {
                        "dmg": "2d8"
                    },
                    "name": "Divine Strike",
                    "path": "abilities.Divine Strike",
                    "type": "dict",
                    "uuid": "d0d1e0f0-a7b7-46c7-8b05-c345626585b0"
                }
            ],
            "name": "Life Domain 14",
            "type": "config",
            "uuid": "a809d932-0ce3-47ba-bc9b-9cec24b016ad"
        },
        {
            "conditions": [
                {
                    "path": "sub.lifedomain.level",
                    "type": "eq",
                    "value": 14
                }
            ],
            "config": [],
            "name": "Life Domain 15",
            "type": "config",
            "uuid": "dcaec399-b092-4647-bc6e-b0d33da7c496"
        },
        {
            "conditions": [
                {
                    "path": "sub.lifedomain.level",
                    "type": "eq",
                    "value": 15
                }
            ],
            "config": [],
            "name": "Life Domain 16",
            "type": "config",
            "uuid": "022b4996-6742-4662-b34f-e4a89f0aacbf"
        },
        {
            "conditions": [
                {
                    "path": "sub.lifedomain.level",
                    "type": "eq",
                    "value": 16
                }
            ],
            "config": [
                {
                    "name": "Supreme Healing",
                    "path": "info.Supreme Healing",
                    "type": "value",
                    "uuid": "800d366b-56c5-4b00-832a-cfd3bdfb0428",
                    "value": "When you would normally roll one or more dice to restore hit points with a spell, you instead\nuse the highest number possible for each die. For example, instead of restoring `2d6` hit points\nto a creature, you restore 12."
                }
            ],
            "name": "Life Domain 17",
            "type": "config",
            "uuid": "b55304fe-3f34-430a-95d9-0a2acb24a14a"
        },
        {
            "conditions": [
                {
                    "path": "sub.lifedomain.level",
                    "type": "eq",
                    "value": 17
                }
            ],
            "config": [],
            "name": "Life Domain 18",
            "type": "config",
            "uuid": "26691edc-3d99-4d58-8f1c-ceaca494e48e"
        },
        {
            "conditions": [
                {
                    "path": "sub.lifedomain.level",
                    "type": "eq",
                    "value": 18
                }
            ],
            "config": [],
            "name": "Life Domain 19",
            "type": "config",
            "uuid": "371ce91a-943e-4f97-a588-da2508a24da3"
        },
        {
            "conditions": [
                {
                    "path": "sub.lifedomain.level",
                    "type": "eq",
                    "value": 19
                }
            ],
            "config": [],
            "name": "Life Domain 20",
            "type": "config",
            "uuid": "210601cb-89f8-4fb0-810d-d74c2c3406c9"
        }
    ],
    "type": "config",
    "uuid": "848b2a50-0497-477e-abac-207e241f0b87"
}');
INSERT INTO `subclass` (id, name, class_id, config)
    VALUES (2, 'Champion', 2, '{
    "conditions": [],
    "config": [
        {
            "dict": {
                "description": "Your weapon attacks score a critical hit on a roll of 19 or 20."
            },
            "name": "Improved Critical",
            "path": "abilities.Improved Critical",
            "type": "dict",
            "uuid": "bf7c81ca-4a52-4770-a3c3-1c205cf08780"
        }
    ],
    "description": "The archetypal **Champion** focuses on the development\nof raw physical power honed to deadly perfection.\nThose who model themselves on this archetype combine\nrigorous training with physical excellence to deal devastating blows.",
    "phases": [
        {
            "conditions": [
                {
                    "path": "sub.champion.level",
                    "type": "eq",
                    "value": 3
                }
            ],
            "config": [],
            "name": "Champion 4",
            "type": "config",
            "uuid": "47479ad1-3404-4e12-b080-16c43e3e0899"
        },
        {
            "conditions": [
                {
                    "path": "sub.champion.level",
                    "type": "eq",
                    "value": 4
                }
            ],
            "config": [],
            "name": "Champion 5",
            "type": "config",
            "uuid": "d99d53ab-5064-4db8-8d1b-f69adc3e2a2d"
        },
        {
            "conditions": [
                {
                    "path": "sub.champion.level",
                    "type": "eq",
                    "value": 5
                }
            ],
            "config": [],
            "name": "Champion 6",
            "type": "config",
            "uuid": "e78a7399-ad12-450d-aef6-db08c3095948"
        },
        {
            "conditions": [
                {
                    "path": "sub.champion.level",
                    "type": "eq",
                    "value": 6
                }
            ],
            "config": [
                {
                    "config": [
                        {
                            "given": [
                                {
                                    "id": "constitution",
                                    "name": "Constitution",
                                    "type": "statistics"
                                },
                                {
                                    "id": "dexterity",
                                    "name": "Dexterity",
                                    "type": "statistics"
                                },
                                {
                                    "id": "strength",
                                    "name": "Strength",
                                    "type": "statistics"
                                },
                                {
                                    "id": "acrobatics",
                                    "name": "Acrobatics",
                                    "type": "skills"
                                },
                                {
                                    "id": "athletics",
                                    "name": "Athletics",
                                    "type": "skills"
                                },
                                {
                                    "id": "sleight of hand",
                                    "name": "Sleight of Hand",
                                    "type": "skills"
                                },
                                {
                                    "id": "stealth",
                                    "name": "Stealth",
                                    "type": "skills"
                                }
                            ],
                            "list": [],
                            "name": "",
                            "path": "proficiencies.talent",
                            "type": "objectlist",
                            "uuid": "299a2815-344f-44b3-ac93-671383392a3b"
                        },
                        {
                            "path": "info.Remarkable Athlete",
                            "type": "value",
                            "uuid": "c2836e4f-a15b-495f-884e-9adf51953727",
                            "value": "When you make a running long jump, the\ndistance you can cover increases by a number of feet\nequal to your **Strength** modifier"
                        }
                    ],
                    "description": "You can add half your proficiency bonus (round up) to any **Strength**, **Dexterity*, or **Constitution* check you make that doesn\u2019t already use your\nproficiency bonus.\nIn addition, when you make a running long jump, the\ndistance you can cover increases by a number of feet\nequal to your Strength modifier",
                    "name": "Remarkable Athlete",
                    "type": "config",
                    "uuid": "a23b638c-646d-49c9-8a95-bcdf80abbe97"
                }
            ],
            "name": "Champion 7",
            "type": "config",
            "uuid": "35928400-721c-4420-ae42-370e099b6231"
        },
        {
            "conditions": [
                {
                    "path": "sub.champion.level",
                    "type": "eq",
                    "value": 7
                }
            ],
            "config": [],
            "name": "Champion 8",
            "type": "config",
            "uuid": "b0da2acf-8052-4eae-bd8b-d2188d3d5479"
        },
        {
            "conditions": [
                {
                    "path": "sub.champion.level",
                    "type": "eq",
                    "value": 8
                }
            ],
            "config": [],
            "name": "Champion 9",
            "type": "config",
            "uuid": "e5959c8f-d584-42f4-950b-6b7ae3ce5884"
        },
        {
            "conditions": [
                {
                    "path": "sub.champion.level",
                    "type": "eq",
                    "value": 9
                }
            ],
            "config": [
                {
                    "add": 1,
                    "description": "You can choose a second option from the **Fighting Style** class feature.",
                    "include": 4,
                    "name": "Additional Fighting Style",
                    "type": "multichoice",
                    "uuid": "9e7daa3e-21ee-43dd-9088-a98b4f6f5bda"
                }
            ],
            "name": "Champion 10",
            "type": "config",
            "uuid": "7fcad074-27e6-437f-ba72-717ebc7e58de"
        },
        {
            "conditions": [
                {
                    "path": "sub.champion.level",
                    "type": "eq",
                    "value": 10
                }
            ],
            "config": [],
            "name": "Champion 11",
            "type": "config",
            "uuid": "7d85cbf7-a6f5-4bca-b954-3034e70b89fc"
        },
        {
            "conditions": [
                {
                    "path": "sub.champion.level",
                    "type": "eq",
                    "value": 11
                }
            ],
            "config": [],
            "name": "Champion 12",
            "type": "config",
            "uuid": "cc6406ee-b2a4-426d-a487-513de29cd23a"
        },
        {
            "conditions": [
                {
                    "path": "sub.champion.level",
                    "type": "eq",
                    "value": 12
                }
            ],
            "config": [],
            "name": "Champion 13",
            "type": "config",
            "uuid": "681956ac-5228-4f17-9470-188311eeaca1"
        },
        {
            "conditions": [
                {
                    "path": "sub.champion.level",
                    "type": "eq",
                    "value": 13
                }
            ],
            "config": [],
            "name": "Champion 14",
            "type": "config",
            "uuid": "54a6ee35-399d-49da-9d2f-57fc323a1ded"
        },
        {
            "conditions": [
                {
                    "path": "sub.champion.level",
                    "type": "eq",
                    "value": 14
                }
            ],
            "config": [
                {
                    "dict": {
                        "description": "Your weapon attacks score a critical hit on a roll of 18\u201320."
                    },
                    "name": "Superior Critical",
                    "path": "abilities.Improved Critical",
                    "type": "dict",
                    "uuid": "91059875-1e11-455e-84e7-680f666b5861"
                }
            ],
            "name": "Champion 15",
            "type": "config",
            "uuid": "c7fc6018-2267-44da-802c-67db13ebce62"
        },
        {
            "conditions": [
                {
                    "path": "sub.champion.level",
                    "type": "eq",
                    "value": 15
                }
            ],
            "config": [],
            "name": "Champion 16",
            "type": "config",
            "uuid": "57cbbebe-47f8-4bfe-a9c3-6b58391d8817"
        },
        {
            "conditions": [
                {
                    "path": "sub.champion.level",
                    "type": "eq",
                    "value": 16
                }
            ],
            "config": [],
            "name": "Champion 17",
            "type": "config",
            "uuid": "fbf215db-26de-4b07-a341-c5b9f6411d5e"
        },
        {
            "conditions": [
                {
                    "path": "sub.champion.level",
                    "type": "eq",
                    "value": 17
                }
            ],
            "config": [
                {
                    "dict": {
                        "description": "You attain the pinnacle of resilience in battle. At the start of each of your turns, you regain hit points\nequal to %(hp)s if you have no more than half of your hit points left. You don\u2019t gain this\nbenefit if you have 0 hit points.",
                        "hp_default": "5 + your **Constitution** modifier",
                        "hp_formula": "5 + statistics.modifiers.constitution"
                    },
                    "path": "abilities.Survivor",
                    "type": "dict",
                    "uuid": "e3b06d4a-dd29-440c-a2e3-6bcf638983de"
                }
            ],
            "name": "Champion 18",
            "type": "config",
            "uuid": "a9737a74-b334-4903-b172-9c156a70e62a"
        },
        {
            "conditions": [
                {
                    "path": "sub.champion.level",
                    "type": "eq",
                    "value": 18
                }
            ],
            "config": [],
            "name": "Champion 19",
            "type": "config",
            "uuid": "70592ac1-a9c3-4dcf-a5a2-5e4662a947f2"
        },
        {
            "conditions": [
                {
                    "path": "sub.champion.level",
                    "type": "eq",
                    "value": 19
                }
            ],
            "config": [],
            "name": "Champion 20",
            "type": "config",
            "uuid": "32194fbd-c7a3-4c22-a742-e05a0f85b968"
        }
    ],
    "type": "config",
    "uuid": "e88dce74-fa04-467e-8f67-e455b7735774"
}');
INSERT INTO `subclass` (id, name, class_id, config)
    VALUES (3, 'Thief', 3, '{
    "conditions": [],
    "config": [
        {
            "dict": {
                "description": "You can use the **bonus action** granted by your **Cunning Action** to make a **Dexterity\n(Sleight of Hand)** check, use your *Thieves\u2019 Tools* to disarm a trap or open a lock, or take the\n**Use an Object** action."
            },
            "name": "Fast Hands",
            "path": "abilities.Fast Hands",
            "type": "dict",
            "uuid": "23667f44-56e7-4673-be19-bc2b9e299213"
        },
        {
            "dict": {
                "description": "You have the ability to climb faster than normal; climbing no longer costs you extra movement.\n\nIn addition, when you make a running jump, the distance you cover increases by a number of feet equal to %(distance)s feet.",
                "distance_default": "a number equal to your **Dexterity** modifier in",
                "distance_formula": "statistics.modifiers.dexterity"
            },
            "name": "Second-Story Work",
            "path": "abilities.Second-Story Work",
            "type": "dict",
            "uuid": "692cb473-40b3-4fb5-bd07-52c6887a39fb"
        }
    ],
    "description": "You hone your skills in the larcenous arts. Burglars,\nbandits, cutpurses, and other criminals typically follow\nthis archetype, but so do rogues who prefer to think of\nthemselves as professional treasure seekers, explorers,\ndelvers, and investigators. In addition to improving your\nagility and stealth, you learn skills useful for delving into\nancient ruins, reading unfamiliar languages, and using\nmagic items you normally couldn\u2019t employ.",
    "phases": [
        {
            "conditions": [
                {
                    "path": "sub.thief.level",
                    "type": "eq",
                    "value": 3
                }
            ],
            "config": [],
            "name": "Thief 4",
            "type": "config",
            "uuid": "be4526e2-c146-491b-bfa5-2512807c3d21"
        },
        {
            "conditions": [
                {
                    "path": "sub.thief.level",
                    "type": "eq",
                    "value": 4
                }
            ],
            "config": [],
            "name": "Thief 5",
            "type": "config",
            "uuid": "dcb2d980-149b-4675-8a4e-1b5aeccf9e90"
        },
        {
            "conditions": [
                {
                    "path": "sub.thief.level",
                    "type": "eq",
                    "value": 5
                }
            ],
            "config": [],
            "name": "Thief 6",
            "type": "config",
            "uuid": "4c16428f-9cec-4bdc-9a6e-c22105335f9a"
        },
        {
            "conditions": [
                {
                    "path": "sub.thief.level",
                    "type": "eq",
                    "value": 6
                }
            ],
            "config": [],
            "name": "Thief 7",
            "type": "config",
            "uuid": "04fc8b7b-6580-4fda-b399-2cec4641b1de"
        },
        {
            "conditions": [
                {
                    "path": "sub.thief.level",
                    "type": "eq",
                    "value": 7
                }
            ],
            "config": [],
            "name": "Thief 8",
            "type": "config",
            "uuid": "b504662a-ae07-43e2-a1c4-153e1cfa52f9"
        },
        {
            "conditions": [
                {
                    "path": "sub.thief.level",
                    "type": "eq",
                    "value": 8
                }
            ],
            "config": [
                {
                    "dict": {
                        "description": "You have advantage on a **Dexterity (Stealth)** check if you move no more than half your speed\non the same turn."
                    },
                    "name": "Supreme Sneak",
                    "path": "abilities.Supreme Sneak",
                    "type": "dict",
                    "uuid": "0f6eec94-3115-4b10-82b4-7cc3d635bb85"
                }
            ],
            "name": "Thief 9",
            "type": "config",
            "uuid": "b3c27d15-0603-46b7-814e-05cc5a34bb3b"
        },
        {
            "conditions": [
                {
                    "path": "sub.thief.level",
                    "type": "eq",
                    "value": 9
                }
            ],
            "config": [],
            "name": "Thief 10",
            "type": "config",
            "uuid": "e2b03399-8821-4ed2-bcbc-62c28f1ad5b6"
        },
        {
            "conditions": [
                {
                    "path": "sub.thief.level",
                    "type": "eq",
                    "value": 10
                }
            ],
            "config": [],
            "name": "Thief 11",
            "type": "config",
            "uuid": "431ff829-049d-4304-97d0-7064b7bbc367"
        },
        {
            "conditions": [
                {
                    "path": "sub.thief.level",
                    "type": "eq",
                    "value": 11
                }
            ],
            "config": [],
            "name": "Thief 12",
            "type": "config",
            "uuid": "2dbafd64-8e8d-43f6-ad97-b61c702e766f"
        },
        {
            "conditions": [
                {
                    "path": "sub.thief.level",
                    "type": "eq",
                    "value": 12
                }
            ],
            "config": [
                {
                    "dict": {
                        "description": "You have learned enough about the workings of magic that you can improvise the use of items\neven when they are not intended for you. You ignore all class, race, and level requirements on the use of\nmagic items."
                    },
                    "name": "Use Magic Device",
                    "path": "abilities.Use Magic Device",
                    "type": "dict",
                    "uuid": "64e74c6a-9fff-49bd-bab2-83a3d1472ab7"
                }
            ],
            "name": "Thief 13",
            "type": "config",
            "uuid": "2c6f1208-e03d-4b9a-ae29-4b14223dd26e"
        },
        {
            "conditions": [
                {
                    "path": "sub.thief.level",
                    "type": "eq",
                    "value": 13
                }
            ],
            "config": [],
            "name": "Thief 14",
            "type": "config",
            "uuid": "6427198f-91f4-44d3-8fee-707c3f86b125"
        },
        {
            "conditions": [
                {
                    "path": "sub.thief.level",
                    "type": "eq",
                    "value": 14
                }
            ],
            "config": [],
            "name": "Thief 15",
            "type": "config",
            "uuid": "4c800e90-8b50-4624-8b03-45120aa6b8b2"
        },
        {
            "conditions": [
                {
                    "path": "sub.thief.level",
                    "type": "eq",
                    "value": 15
                }
            ],
            "config": [],
            "name": "Thief 16",
            "type": "config",
            "uuid": "221e84c7-d571-4db0-b272-3905dfb0cfca"
        },
        {
            "conditions": [
                {
                    "path": "sub.thief.level",
                    "type": "eq",
                    "value": 16
                }
            ],
            "config": [
                {
                    "dict": {
                        "description": "You are adept at laying ambushes and quickly escaping danger. You can take two turns during the first round of any combat. You take\nyour first turn at your normal initiative and your second turn at your initiative minus 10. You can\u2019t use this feature\nwhen you are *surprised*."
                    },
                    "name": "Thief\u2019s Reflexes",
                    "path": "abilities.Thief\u2019s Reflexes",
                    "type": "dict",
                    "uuid": "b32776c2-f1f3-417b-b9fd-df4340e85e5f"
                }
            ],
            "name": "Thief 17",
            "type": "config",
            "uuid": "6f7da631-97b7-4711-b875-26c5fb0ad219"
        },
        {
            "conditions": [
                {
                    "path": "sub.thief.level",
                    "type": "eq",
                    "value": 17
                }
            ],
            "config": [],
            "name": "Thief 18",
            "type": "config",
            "uuid": "3732d1c2-26b1-4698-93a2-98275006e1ec"
        },
        {
            "conditions": [
                {
                    "path": "sub.thief.level",
                    "type": "eq",
                    "value": 18
                }
            ],
            "config": [],
            "name": "Thief 19",
            "type": "config",
            "uuid": "c5b745e3-5c4d-45f3-bf3e-77fc884440f3"
        },
        {
            "conditions": [
                {
                    "path": "sub.thief.level",
                    "type": "eq",
                    "value": 19
                }
            ],
            "config": [],
            "name": "Thief 20",
            "type": "config",
            "uuid": "1b40f057-2450-40d2-ac61-f6d59e684ada"
        }
    ],
    "type": "config",
    "uuid": "6ab1f9b3-2b0d-4c2a-a451-75403280758a"
}');
INSERT INTO `subclass` (id, name, class_id, config)
    VALUES (4, 'School of Evocation', 4, '{
    "conditions": [],
    "config": [
        {
            "name": "Evocation Savant",
            "path": "info.Evocation Savant",
            "type": "value",
            "uuid": "24d752f4-8475-452a-98e4-8a016aca36ad",
            "value": "The gold and time you must spend to copy an *evocation* spell into your spellbook is halved."
        },
        {
            "dict": {
                "description": "You can create pockets of relative safety within the effects of your evocation spells. When\nyou cast an *evocation* spell that affects other creatures that you can see, you can choose a number of them equal\nto 1 + the spell\u2019s level. The chosen creatures automatically succeed on their saving throws against the spell,\nand they take no damage if they would normally take half damage on a successful save."
            },
            "name": "Sculpt Spells",
            "path": "abilities.Sculpt Spells",
            "type": "dict",
            "uuid": "bd5f56dd-4ccf-41ba-ac04-a1bb9fc3a66c"
        }
    ],
    "description": "You focus your study on magic that creates powerful elemental effects such as bitter cold, searing flame, rolling\nthunder, crackling lightning, and burning acid. Some\nevokers find employment in military forces, serving as\nartillery to blast enemy armies from afar. Others use\ntheir spectacular power to protect the weak, while some\nseek their own gain as bandits, adventurers, or aspiring tyrants.",
    "phases": [
        {
            "conditions": [
                {
                    "path": "sub.schoolofevocation.level",
                    "type": "eq",
                    "value": 2
                }
            ],
            "config": [],
            "name": "School of Evocation 3",
            "type": "config",
            "uuid": "2fd09386-9f51-46f9-9113-a4f54047c06a"
        },
        {
            "conditions": [
                {
                    "path": "sub.schoolofevocation.level",
                    "type": "eq",
                    "value": 3
                }
            ],
            "config": [],
            "name": "School of Evocation 4",
            "type": "config",
            "uuid": "26ee37e4-e067-4106-85fc-f02b456fa235"
        },
        {
            "conditions": [
                {
                    "path": "sub.schoolofevocation.level",
                    "type": "eq",
                    "value": 4
                }
            ],
            "config": [],
            "name": "School of Evocation 5",
            "type": "config",
            "uuid": "01737866-d788-4f78-ae15-e82351f85493"
        },
        {
            "conditions": [
                {
                    "path": "sub.schoolofevocation.level",
                    "type": "eq",
                    "value": 5
                }
            ],
            "config": [
                {
                    "dict": {
                        "description": "Your damaging cantrips affect even creatures that avoid the brunt of the effect. When a creature succeeds on a saving throw against your cantrip,\nthe creature takes half the cantrip\u2019s damage (if any) but suffers no additional effect from the cantrip."
                    },
                    "name": "Potent Cantrip",
                    "path": "abilities.Potent Cantrip",
                    "type": "dict",
                    "uuid": "f30f8148-75f4-45c6-aabf-1ecf160e2b36"
                }
            ],
            "name": "School of Evocation 6",
            "type": "config",
            "uuid": "41143d9a-a341-4591-8155-04479f33b332"
        },
        {
            "conditions": [
                {
                    "path": "sub.schoolofevocation.level",
                    "type": "eq",
                    "value": 6
                }
            ],
            "config": [],
            "name": "School of Evocation 7",
            "type": "config",
            "uuid": "6a8c56aa-9399-45e3-8004-58e2a84618da"
        },
        {
            "conditions": [
                {
                    "path": "sub.schoolofevocation.level",
                    "type": "eq",
                    "value": 7
                }
            ],
            "config": [],
            "name": "School of Evocation 8",
            "type": "config",
            "uuid": "c2aea1c8-245e-4054-bc38-914023baa165"
        },
        {
            "conditions": [
                {
                    "path": "sub.schoolofevocation.level",
                    "type": "eq",
                    "value": 8
                }
            ],
            "config": [],
            "name": "School of Evocation 9",
            "type": "config",
            "uuid": "79aff264-5b02-4756-9e4c-2e88c2cfa237"
        },
        {
            "conditions": [
                {
                    "path": "sub.schoolofevocation.level",
                    "type": "eq",
                    "value": 9
                }
            ],
            "config": [
                {
                    "dict": {
                        "description": "You can add your Intelligence modifier (`+%(mod)s`) to one damage roll of any wizard evocation spell you cast.",
                        "mod_default": "?",
                        "mod_formula": "statistics.modifiers.intelligence"
                    },
                    "name": "Empowered Evocation",
                    "path": "abilities.Empowered Evocation",
                    "type": "dict",
                    "uuid": "66488662-d8ac-49ee-8de8-83ca53f081fa"
                }
            ],
            "name": "School of Evocation 10",
            "type": "config",
            "uuid": "5530fdef-493b-4fb7-b2ed-410816aabaa3"
        },
        {
            "conditions": [
                {
                    "path": "sub.schoolofevocation.level",
                    "type": "eq",
                    "value": 10
                }
            ],
            "config": [],
            "name": "School of Evocation 11",
            "type": "config",
            "uuid": "02bffa0e-42fe-47a3-94a8-8e7df2131f11"
        },
        {
            "conditions": [
                {
                    "path": "sub.schoolofevocation.level",
                    "type": "eq",
                    "value": 11
                }
            ],
            "config": [],
            "name": "School of Evocation 12",
            "type": "config",
            "uuid": "02959af7-e0e2-4c05-bbde-9c6fc868b88f"
        },
        {
            "conditions": [
                {
                    "path": "sub.schoolofevocation.level",
                    "type": "eq",
                    "value": 12
                }
            ],
            "config": [],
            "name": "School of Evocation 13",
            "type": "config",
            "uuid": "36cdd1d5-728e-4b4d-9e54-9e2a48c17436"
        },
        {
            "conditions": [
                {
                    "path": "sub.schoolofevocation.level",
                    "type": "eq",
                    "value": 13
                }
            ],
            "config": [
                {
                    "dict": {
                        "description": "You can increase the power of your simpler spells. When you cast a wizard spell of 1st\nthrough 5th level that deals damage, you can deal maximum damage with that spell.\nThe first time you do so, you suffer no adverse effect. If you use this feature again before \nyou finish a long rest, you take `2d12` necrotic damage for each level of the spell,\nimmediately after you cast it. Each time you use this feature again before finishing a long\nrest, the necrotic damage per spell level increases by `1d12`. This damage\nignores resistance and immunity."
                    },
                    "name": "Overchannel",
                    "path": "abilities.Overchannel",
                    "type": "dict",
                    "uuid": "ea278f07-98f0-4b30-9ca3-c4da07e97737"
                }
            ],
            "name": "School of Evocation 14",
            "type": "config",
            "uuid": "05dce540-3a57-4b21-b1f6-0219c8a7eeb5"
        },
        {
            "conditions": [
                {
                    "path": "sub.schoolofevocation.level",
                    "type": "eq",
                    "value": 14
                }
            ],
            "config": [],
            "name": "School of Evocation 15",
            "type": "config",
            "uuid": "4437d3a4-7d70-49b2-9e7a-8768cd2ce5a3"
        },
        {
            "conditions": [
                {
                    "path": "sub.schoolofevocation.level",
                    "type": "eq",
                    "value": 15
                }
            ],
            "config": [],
            "name": "School of Evocation 16",
            "type": "config",
            "uuid": "296eec1f-1919-4c15-ba95-ec6b771b482c"
        },
        {
            "conditions": [
                {
                    "path": "sub.schoolofevocation.level",
                    "type": "eq",
                    "value": 16
                }
            ],
            "config": [],
            "name": "School of Evocation 17",
            "type": "config",
            "uuid": "ffe50d65-7322-4171-a5dc-589b0892d80f"
        },
        {
            "conditions": [
                {
                    "path": "sub.schoolofevocation.level",
                    "type": "eq",
                    "value": 17
                }
            ],
            "config": [],
            "name": "School of Evocation 18",
            "type": "config",
            "uuid": "5ff3fdf4-f7d4-41a0-bcbf-aa85eb0bf8d2"
        },
        {
            "conditions": [
                {
                    "path": "sub.schoolofevocation.level",
                    "type": "eq",
                    "value": 18
                }
            ],
            "config": [],
            "name": "School of Evocation 19",
            "type": "config",
            "uuid": "3ac5ba1a-7faa-4a86-b9f4-b03fb836bdc2"
        },
        {
            "conditions": [
                {
                    "path": "sub.schoolofevocation.level",
                    "type": "eq",
                    "value": 19
                }
            ],
            "config": [],
            "name": "School of Evocation 20",
            "type": "config",
            "uuid": "084ead9a-4b01-48ce-b07c-51453c8a8dab"
        }
    ],
    "type": "config",
    "uuid": "6fad1488-6f14-43b8-8fcf-fdfff1aebf08"
}');

INSERT INTO `background` (id, name, config)
    VALUES (1, 'Acolyte', '{
    "conditions": [
        {
            "path": "character.level",
            "type": "lte",
            "value": 1
        }
    ],
    "config": [
        {
            "description": "Insight, Religion",
            "given": [
                {
                    "id": "religion",
                    "name": "Religion",
                    "type": "skills"
                },
                {
                    "id": "insight",
                    "name": "Insight",
                    "type": "skills"
                }
            ],
            "list": [],
            "multiple": false,
            "name": "Skill Proficiencies:",
            "path": "proficiencies.skills",
            "type": "objectlist",
            "uuid": "0941d880-3b7c-49a2-b78e-f07b743a1b78"
        },
        {
            "add": 2,
            "description": "Two of your choice",
            "list": [
                "languages"
            ],
            "name": "Languages:",
            "path": "proficiencies.languages",
            "type": "objectlist",
            "uuid": "313a7f75-ac09-445b-9cc2-452eff942451"
        },
        {
            "config": [
                {
                    "description": "A holy symbol (a gift to you when you\nentered the priesthood), a prayer book or prayer wheel,\n5 sticks of incense, vestments, a set of common clothes,\nand a pouch containing 15 gp",
                    "given": [
                        {
                            "id": 242,
                            "name": "Reliquary",
                            "type": "gear"
                        },
                        {
                            "id": 213,
                            "name": "Book",
                            "type": "gear"
                        },
                        {
                            "id": 292,
                            "name": "Block of incense",
                            "type": "gear"
                        },
                        {
                            "id": 294,
                            "name": "Vestments",
                            "type": "gear"
                        },
                        {
                            "id": 224,
                            "name": "Clothes, common",
                            "type": "gear"
                        },
                        {
                            "id": 268,
                            "name": "Pouch",
                            "type": "gear"
                        }
                    ],
                    "list": [
                        "gear"
                    ],
                    "multiple": true,
                    "path": "equipment",
                    "type": "objectlist",
                    "uuid": "89807616-d31c-4138-9ed5-e949e0ad4bf0"
                }
            ],
            "description": "A holy symbol (a gift to you when you\nentered the priesthood), a prayer book or prayer wheel,\n5 sticks of incense, vestments, a set of common clothes,\nand a pouch containing 15 gp",
            "name": "Equipment:",
            "type": "config",
            "uuid": "bb5ec0d6-9dcd-4e48-a05b-ae93516073b3"
        },
        {
            "hidden": true,
            "path": "wealth.gp",
            "type": "value",
            "uuid": "5160a2f6-0637-4357-94f2-8d41a35b0b67",
            "value": 15
        },
        {
            "name": "Feature: Shelter of the Faithful",
            "path": "info.Feature: Shelter of the Faithful",
            "type": "value",
            "uuid": "f9258216-06ce-4783-822a-50fac59a6b8b",
            "value": "As an acolyte, you command the respect of those who\nshare your faith, and you can perform the religious\nceremonies of your deity. You and your adventuring companions can expect to receive free healing and care at\na temple, shrine, or other established presence of your\nfaith, though you must provide any material components\nneeded for spells. Those who share your religion will support you (but only you) at a modest lifestyle.\n\nYou might also have ties to a specific temple dedicated\nto your chosen deity or pantheon, and you have a residence there. This could be the temple where you used to\nserve, if you remain on good terms with it, or a temple\nwhere you have found a new home. While near your temple, you can call upon the priests for assistance, provided\nthe assistance you ask for is not hazardous and you remain in good standing with your temple."
        },
        {
            "config": [
                {
                    "name": "Personality Trait",
                    "path": "personality.traits",
                    "suggestions": [
                        "I idolize a particular hero of my faith, and constantly refer to that person\u2019s deeds and example.",
                        "I can find common ground between the fiercest enemies, empathizing with them and always working toward peace.",
                        "I see omens in every event and action. The gods try to speak to us, we just need to listen.",
                        "Nothing can shake my optimistic attitude.",
                        "I quote (or misquote) sacred texts and proverbs in almost every situation.",
                        "I am tolerant (or intolerant) of other faiths and respect (or condemn) the worship of other gods",
                        "I\u2019ve enjoyed fine food, drink, and high society among my temple\u2019s elite. Rough living grates on me.",
                        "I\u2019ve spent so long in the temple that I have little practical experience dealing with people in the outside world."
                    ],
                    "type": "manual",
                    "uuid": "4f9abfa7-463b-4e6f-9e7c-ced3b98c5e2c"
                },
                {
                    "name": "Ideal",
                    "path": "personality.ideals",
                    "suggestions": [
                        "*Tradition*. The ancient traditions of worship and sacrifice must be preserved and upheld. (Lawful)",
                        "*Charity*. I always try to help those in need, no matter what the personal cost. (Good)",
                        "*Change*. We must help bring about the changes the gods are constantly working in the world. (Chaotic)",
                        "*Power*. I hope to one day rise to the top of my faith\u2019s religious hierarchy. (Lawful)",
                        "*Faith*. I trust that my deity will guide my actions. I have faith that if I work hard, things will go well. (Lawful)",
                        "*Aspiration*. I seek to prove myself worthy of my god\u2019s favor by matching my actions against his or her teachings. (Any)"
                    ],
                    "type": "manual",
                    "uuid": "5d9d0bf8-c2de-4307-9df3-ab477a11e043"
                },
                {
                    "name": "Bond",
                    "path": "personality.bonds",
                    "suggestions": [
                        "I would die to recover an ancient relic of my faith that was lost long ago.",
                        "I will someday get revenge on the corrupt temple hierarchy who branded me a heretic.",
                        "I owe my life to the priest who took me in when my parents died.",
                        "Everything I do is for the common people.",
                        "I will do anything to protect the temple where I served.",
                        "I seek to preserve a sacred text that my enemies consider heretical and seek to destroy."
                    ],
                    "type": "manual",
                    "uuid": "d6608541-e169-462e-80dd-ca6a79cccc8f"
                },
                {
                    "name": "Flaw",
                    "path": "personality.flaws",
                    "suggestions": [
                        "I judge others harshly, and myself even more severely.",
                        "I put too much trust in those who wield power within my temple\u2019s hierarchy.",
                        "My piety sometimes leads me to blindly trust those that profess faith in my god.",
                        "I am inflexible in my thinking.",
                        "I am suspicious of strangers and expect the worst of them.",
                        "Once I pick a goal, I become obsessed with it to the detriment of everything else in my life."
                    ],
                    "type": "manual",
                    "uuid": "4c0370a0-5d48-4fa9-9179-6c2a0ac86f16"
                }
            ],
            "description": "Acolytes are shaped by their experience in temples or\nother religious communities. Their study of the history\nand tenets of their faith and their relationships to temples, shrines, or hierarchies affect their mannerisms and\nideals. Their flaws might be some hidden hypocrisy or\nheretical idea, or an ideal or bond taken to an extreme.",
            "name": "Suggested Characteristics",
            "type": "config",
            "uuid": "1c036dc5-7af0-4834-8f17-bf98ade12100"
        }
    ],
    "description": "You have spent your life in the service of a temple to a\nspecific god or pantheon of gods. You act as an intermediary between the realm of the holy and the mortal world,\nperforming sacred rites and offering sacrifices in order to\nconduct worshipers into the presence of the divine. You\nare not necessarily a cleric\u2014performing sacred rites is\nnot the same thing as channeling divine power.\n\nChoose a god, a pantheon of gods, or some other quasidivine being, and work with your DM to detail the nature\nof your religious service. Appendix B contains a sample\npantheon, from the Forgotten Realms setting. Were you\na lesser functionary in a temple, raised from childhood\nto assist the priests in the sacred rites? Or were you a\nhigh priest who suddenly experienced a call to serve your\ngod in a different way? Perhaps you were the leader of a\nsmall cult outside of any established temple structure, or\neven an occult group that served a fiendish master that\nyou now deny.",
    "phases": [
        {
            "conditions": [
                {
                    "path": "sub.acolyte.level",
                    "type": "eq",
                    "value": 1
                }
            ],
            "config": [],
            "name": "Acolyte 2",
            "type": "config",
            "uuid": "e301a13f-218c-419f-853f-e884a58ae4ed"
        },
        {
            "conditions": [
                {
                    "path": "sub.acolyte.level",
                    "type": "eq",
                    "value": 2
                }
            ],
            "config": [],
            "name": "Acolyte 3",
            "type": "config",
            "uuid": "172be65a-5c0c-48a2-b8cc-ddbdf9ffe69b"
        },
        {
            "conditions": [
                {
                    "path": "sub.acolyte.level",
                    "type": "eq",
                    "value": 3
                }
            ],
            "config": [],
            "name": "Acolyte 4",
            "type": "config",
            "uuid": "f2fdc3fb-1237-4006-b1c8-e0b94f3b7b5c"
        },
        {
            "conditions": [
                {
                    "path": "sub.acolyte.level",
                    "type": "eq",
                    "value": 4
                }
            ],
            "config": [],
            "name": "Acolyte 5",
            "type": "config",
            "uuid": "efd328f8-8060-4743-83da-307704330a7e"
        },
        {
            "conditions": [
                {
                    "path": "sub.acolyte.level",
                    "type": "eq",
                    "value": 5
                }
            ],
            "config": [],
            "name": "Acolyte 6",
            "type": "config",
            "uuid": "e79ac14c-9a7c-46da-9657-9c8c62aac820"
        },
        {
            "conditions": [
                {
                    "path": "sub.acolyte.level",
                    "type": "eq",
                    "value": 6
                }
            ],
            "config": [],
            "name": "Acolyte 7",
            "type": "config",
            "uuid": "fd59248f-db25-449f-9d17-e675f3c6b482"
        },
        {
            "conditions": [
                {
                    "path": "sub.acolyte.level",
                    "type": "eq",
                    "value": 7
                }
            ],
            "config": [],
            "name": "Acolyte 8",
            "type": "config",
            "uuid": "bc495783-b271-4b91-b4ae-42d9d546cb01"
        },
        {
            "conditions": [
                {
                    "path": "sub.acolyte.level",
                    "type": "eq",
                    "value": 8
                }
            ],
            "config": [],
            "name": "Acolyte 9",
            "type": "config",
            "uuid": "c95abc51-22e8-4adc-abcf-18d2409faf42"
        },
        {
            "conditions": [
                {
                    "path": "sub.acolyte.level",
                    "type": "eq",
                    "value": 9
                }
            ],
            "config": [],
            "name": "Acolyte 10",
            "type": "config",
            "uuid": "54a11d80-c6bd-4c2d-8afe-b636399ebe93"
        },
        {
            "conditions": [
                {
                    "path": "sub.acolyte.level",
                    "type": "eq",
                    "value": 10
                }
            ],
            "config": [],
            "name": "Acolyte 11",
            "type": "config",
            "uuid": "c948b087-db25-496d-862e-5ba6e5b1af0d"
        },
        {
            "conditions": [
                {
                    "path": "sub.acolyte.level",
                    "type": "eq",
                    "value": 11
                }
            ],
            "config": [],
            "name": "Acolyte 12",
            "type": "config",
            "uuid": "30093795-253a-40a3-87d0-626be44e2d9f"
        },
        {
            "conditions": [
                {
                    "path": "sub.acolyte.level",
                    "type": "eq",
                    "value": 12
                }
            ],
            "config": [],
            "name": "Acolyte 13",
            "type": "config",
            "uuid": "3f5d9a30-9007-482b-aae9-7fc0cff10e17"
        },
        {
            "conditions": [
                {
                    "path": "sub.acolyte.level",
                    "type": "eq",
                    "value": 13
                }
            ],
            "config": [],
            "name": "Acolyte 14",
            "type": "config",
            "uuid": "71307e25-8aa8-4854-a018-7ed25e0be40a"
        },
        {
            "conditions": [
                {
                    "path": "sub.acolyte.level",
                    "type": "eq",
                    "value": 14
                }
            ],
            "config": [],
            "name": "Acolyte 15",
            "type": "config",
            "uuid": "950de95a-4e4c-43a6-b2c2-027b492440da"
        },
        {
            "conditions": [
                {
                    "path": "sub.acolyte.level",
                    "type": "eq",
                    "value": 15
                }
            ],
            "config": [],
            "name": "Acolyte 16",
            "type": "config",
            "uuid": "c9f49179-312f-4714-b5b0-05e5037d7e34"
        },
        {
            "conditions": [
                {
                    "path": "sub.acolyte.level",
                    "type": "eq",
                    "value": 16
                }
            ],
            "config": [],
            "name": "Acolyte 17",
            "type": "config",
            "uuid": "f977ee36-cb89-4549-af1c-b6401e266175"
        },
        {
            "conditions": [
                {
                    "path": "sub.acolyte.level",
                    "type": "eq",
                    "value": 17
                }
            ],
            "config": [],
            "name": "Acolyte 18",
            "type": "config",
            "uuid": "8d2913d0-d0c9-4b53-824e-f8eed7962fed"
        },
        {
            "conditions": [
                {
                    "path": "sub.acolyte.level",
                    "type": "eq",
                    "value": 18
                }
            ],
            "config": [],
            "name": "Acolyte 19",
            "type": "config",
            "uuid": "6ccc687e-d29f-4b04-9613-f20ce924aa42"
        },
        {
            "conditions": [
                {
                    "path": "sub.acolyte.level",
                    "type": "eq",
                    "value": 19
                }
            ],
            "config": [],
            "name": "Acolyte 20",
            "type": "config",
            "uuid": "33982dc0-bb26-4a0a-b42c-0420eb489b72"
        }
    ],
    "type": "config",
    "uuid": "628f5594-53e4-45fa-8900-9fbfc621ac9d"
}');
INSERT INTO `background` (id, name, config)
    VALUES (2, 'Criminal', '{
    "conditions": [
        {
            "path": "character.level",
            "type": "lte",
            "value": 1
        }
    ],
    "config": [
        {
            "description": "Deception, Stealth",
            "given": [
                {
                    "id": "deception",
                    "name": "Deception",
                    "type": "skills"
                },
                {
                    "id": "stealth",
                    "name": "Stealth",
                    "type": "skills"
                }
            ],
            "list": [],
            "name": "Skill Proficiency",
            "path": "proficiencies.skills",
            "type": "objectlist",
            "uuid": "90f01cdc-cd86-46a9-9cba-1760fd44f37b"
        },
        {
            "add": 1,
            "filter": [
                {
                    "field": "type",
                    "options": [
                        "gaming"
                    ],
                    "type": "attribute"
                }
            ],
            "given": [
                {
                    "id": 77,
                    "name": "Thieves'' tools",
                    "type": "kit"
                }
            ],
            "list": [
                "gear"
            ],
            "name": "Tool Proficiency",
            "path": "proficiencies.tools",
            "type": "objectlist",
            "uuid": "dd152ce4-e921-4874-98be-6461145c6b63"
        },
        {
            "description": "A crowbar, a set of dark common clothes including a hood, and a pouch containing 15 gp.",
            "given": [
                {
                    "count": 1,
                    "id": 229,
                    "name": "Crowbar",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 224,
                    "name": "Clothes, common",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 268,
                    "name": "Pouch",
                    "type": "gear"
                }
            ],
            "list": [],
            "multiple": true,
            "name": "Equipment",
            "path": "equipment",
            "type": "objectlist",
            "uuid": "ec770304-e570-4156-ab71-90825f81e88b"
        },
        {
            "hidden": true,
            "path": "wealth.gp",
            "type": "value",
            "uuid": "bd3887c7-910f-45c5-a752-b3486f954d1f",
            "value": 15
        },
        {
            "config": [
                {
                    "name": "Criminal Specialty",
                    "path": "info.Criminal Specialty",
                    "suggestions": [
                        "Blackmailer",
                        "Burglar",
                        "Enforcer",
                        "Fence",
                        "Highway robber",
                        "Hired killer",
                        "Pickpocket",
                        "Smuggler"
                    ],
                    "type": "manual",
                    "uuid": "e864036f-695e-4fcd-9fba-0096b58778e8"
                }
            ],
            "description": "There are many kinds of criminals, and within a thieves\u2019\nguild or similar criminal organization, individual members have particular specialties. Even criminals who\noperate outside of such organizations have strong preferences for certain kinds of crimes over others. Choose\nthe role you played in your criminal life.",
            "name": "Criminal Specialty",
            "type": "config",
            "uuid": "a6ac9664-6c4d-4729-962f-006285965ca8"
        },
        {
            "dict": {
                "description": "You have a reliable and trustworthy contact who acts as your liaison to a network of other criminals. You know how to get messages to and from your contact, even over great distances; specifically, you know the local messengers, corrupt caravan masters, and seedy sailors who can deliver messages for you."
            },
            "name": "Feature: Criminal Contact",
            "path": "abilities.Feature: Criminal Contact",
            "type": "dict",
            "uuid": "d289600a-1eb4-4d7d-9fe0-e1048ed71754"
        },
        {
            "config": [
                {
                    "name": "Personality Trait",
                    "path": "personality.traits",
                    "suggestions": [
                        "I always have a plan for what to do when things go wrong.",
                        "I am always calm, no matter what the situation. I never raise my voice or let my emotions control me.",
                        "The first thing I do in a new place is note the locations of everything valuable\u2014or where such things could be hidden.",
                        "I would rather make a new friend than a new enemy.",
                        "I am incredibly slow to trust. Those who seem the fairest often have the most to hide.",
                        "I don\u2019t pay attention to the risks in a situation. Never tell me the odds.",
                        "The best way to get me to do something is to tell me I can\u2019t do it.",
                        "I blow up at the slightest insult."
                    ],
                    "type": "manual",
                    "uuid": "b1bcd85f-f39e-4d81-88c5-b96088071d63"
                },
                {
                    "name": "Ideal",
                    "path": "personality.ideals",
                    "suggestions": [
                        "*Honor*. I don\u2019t steal from others in the trade. (Lawful)",
                        "*Freedom*. Chains are meant to be broken, as are those who would forge them. (Chaotic)",
                        "*Charity*. I steal from the wealthy so that I can help people in need. (Good)",
                        "*Greed*. I will do whatever it takes to become wealthy. (Evil)",
                        "*People*. I\u2019m loyal to my friends, not to any ideals, and everyone else can take a trip down the Styx for all I care. (Neutral)",
                        "*Redemption*. There\u2019s a spark of good in everyone. (Good)"
                    ],
                    "type": "manual",
                    "uuid": "1fcd6a1e-0ec8-4642-a8c1-7e54e10bf9c3"
                },
                {
                    "name": "Bond",
                    "path": "personality.bonds",
                    "suggestions": [
                        "I\u2019m trying to pay off an old debt I owe to a generous benefactor.",
                        "My ill-gotten gains go to support my family.",
                        "3 Something important was taken from me, and I aim to steal it back.",
                        "I will become the greatest thief that ever lived.",
                        "I\u2019m guilty of a terrible crime. I hope I can redeem myself for it.",
                        "Someone I loved died because of I mistake I made. That will never happen again."
                    ],
                    "type": "manual",
                    "uuid": "a126d267-15fb-4935-8bd2-bbb2bd91294f"
                },
                {
                    "name": "Flaw",
                    "path": "personality.flaws",
                    "suggestions": [
                        "When I see something valuable, I can\u2019t think about anything but how to steal it.",
                        "When faced with a choice between money and my friends, I usually choose the money.",
                        "If there\u2019s a plan, I\u2019ll forget it. If I don\u2019t forget it, I\u2019ll ignore it.",
                        "I have a \u201ctell\u201d that reveals when I\u2019m lying.",
                        "I turn tail and run when things look bad.",
                        "An innocent person is in prison for a crime that I committed. I\u2019m okay with that."
                    ],
                    "type": "manual",
                    "uuid": "0f3e9e83-aaf4-4f4b-990b-84026db7d5a4"
                }
            ],
            "description": "",
            "name": "Suggested Characteristics",
            "type": "config",
            "uuid": "7b47366a-bca4-4100-8bdd-08adb7beb588"
        }
    ],
    "description": "You are an experienced criminal with a history of\nbreaking the law. You have spent a lot of time among\nother criminals and still have contacts within the\ncriminal underworld. You\u2019re far closer than most people\nto the world of murder, theft, and violence that pervades\nthe underbelly of civilization, and you have survived up to\nthis point by flouting the rules and regulations of society.",
    "phases": [
        {
            "conditions": [
                {
                    "path": "sub.criminal.level",
                    "type": "eq",
                    "value": 1
                }
            ],
            "config": [],
            "name": "Criminal 2",
            "type": "config",
            "uuid": "b24da541-0077-43ba-b863-ca95ebac2d57"
        },
        {
            "conditions": [
                {
                    "path": "sub.criminal.level",
                    "type": "eq",
                    "value": 2
                }
            ],
            "config": [],
            "name": "Criminal 3",
            "type": "config",
            "uuid": "cf621468-14a5-447c-9249-833d241e704b"
        },
        {
            "conditions": [
                {
                    "path": "sub.criminal.level",
                    "type": "eq",
                    "value": 3
                }
            ],
            "config": [],
            "name": "Criminal 4",
            "type": "config",
            "uuid": "9c44e2e3-c179-4970-bd84-77f53041f990"
        },
        {
            "conditions": [
                {
                    "path": "sub.criminal.level",
                    "type": "eq",
                    "value": 4
                }
            ],
            "config": [],
            "name": "Criminal 5",
            "type": "config",
            "uuid": "b4f240f2-6221-4ff0-ae72-d2f32a92aea5"
        },
        {
            "conditions": [
                {
                    "path": "sub.criminal.level",
                    "type": "eq",
                    "value": 5
                }
            ],
            "config": [],
            "name": "Criminal 6",
            "type": "config",
            "uuid": "77c0ce74-e903-4476-a50b-fa6cd9d35888"
        },
        {
            "conditions": [
                {
                    "path": "sub.criminal.level",
                    "type": "eq",
                    "value": 6
                }
            ],
            "config": [],
            "name": "Criminal 7",
            "type": "config",
            "uuid": "40261b2c-62cd-4c9a-93d5-d73dc62de446"
        },
        {
            "conditions": [
                {
                    "path": "sub.criminal.level",
                    "type": "eq",
                    "value": 7
                }
            ],
            "config": [],
            "name": "Criminal 8",
            "type": "config",
            "uuid": "a0d08504-4deb-452e-91e3-b4e6ba5389c8"
        },
        {
            "conditions": [
                {
                    "path": "sub.criminal.level",
                    "type": "eq",
                    "value": 8
                }
            ],
            "config": [],
            "name": "Criminal 9",
            "type": "config",
            "uuid": "5f0260ff-4cd0-453c-b47f-55005577f85f"
        },
        {
            "conditions": [
                {
                    "path": "sub.criminal.level",
                    "type": "eq",
                    "value": 9
                }
            ],
            "config": [],
            "name": "Criminal 10",
            "type": "config",
            "uuid": "16ad58e0-e019-4c4f-8b0b-068c102836d8"
        },
        {
            "conditions": [
                {
                    "path": "sub.criminal.level",
                    "type": "eq",
                    "value": 10
                }
            ],
            "config": [],
            "name": "Criminal 11",
            "type": "config",
            "uuid": "b2f2ca9b-3252-40d7-8350-89300252cb69"
        },
        {
            "conditions": [
                {
                    "path": "sub.criminal.level",
                    "type": "eq",
                    "value": 11
                }
            ],
            "config": [],
            "name": "Criminal 12",
            "type": "config",
            "uuid": "314151dd-4d6f-49dc-80bc-6f981a4b3bad"
        },
        {
            "conditions": [
                {
                    "path": "sub.criminal.level",
                    "type": "eq",
                    "value": 12
                }
            ],
            "config": [],
            "name": "Criminal 13",
            "type": "config",
            "uuid": "e066f489-ca0f-497e-aada-abc9fd6499b2"
        },
        {
            "conditions": [
                {
                    "path": "sub.criminal.level",
                    "type": "eq",
                    "value": 13
                }
            ],
            "config": [],
            "name": "Criminal 14",
            "type": "config",
            "uuid": "42f94027-fa35-45d2-8f37-063824b22073"
        },
        {
            "conditions": [
                {
                    "path": "sub.criminal.level",
                    "type": "eq",
                    "value": 14
                }
            ],
            "config": [],
            "name": "Criminal 15",
            "type": "config",
            "uuid": "871c2b28-b346-4e5c-812b-7e755cb71f13"
        },
        {
            "conditions": [
                {
                    "path": "sub.criminal.level",
                    "type": "eq",
                    "value": 15
                }
            ],
            "config": [],
            "name": "Criminal 16",
            "type": "config",
            "uuid": "c17f17ed-d1fd-40bd-bcaf-1111932a61a0"
        },
        {
            "conditions": [
                {
                    "path": "sub.criminal.level",
                    "type": "eq",
                    "value": 16
                }
            ],
            "config": [],
            "name": "Criminal 17",
            "type": "config",
            "uuid": "87b28499-866d-4a9c-8ac4-7a5569dddb25"
        },
        {
            "conditions": [
                {
                    "path": "sub.criminal.level",
                    "type": "eq",
                    "value": 17
                }
            ],
            "config": [],
            "name": "Criminal 18",
            "type": "config",
            "uuid": "09041c2e-b3b0-4ee3-b122-a4978ce8e870"
        },
        {
            "conditions": [
                {
                    "path": "sub.criminal.level",
                    "type": "eq",
                    "value": 18
                }
            ],
            "config": [],
            "name": "Criminal 19",
            "type": "config",
            "uuid": "cf213f54-3abe-439d-b95f-7d68a23f738e"
        },
        {
            "conditions": [
                {
                    "path": "sub.criminal.level",
                    "type": "eq",
                    "value": 19
                }
            ],
            "config": [],
            "name": "Criminal 20",
            "type": "config",
            "uuid": "00e33d6e-ce4b-4cf4-aa1e-bb854f0f2a02"
        }
    ],
    "type": "config",
    "uuid": "c427d072-6d00-4064-b295-0787d2c61cd1"
}');
INSERT INTO `background` (id, name, config)
    VALUES (3, 'Folk Hero', '{
    "conditions": [
        {
            "path": "character.level",
            "type": "lte",
            "value": 1
        }
    ],
    "config": [
        {
            "description": " Animal Handling, Survival",
            "given": [
                {
                    "id": "animal handling",
                    "name": "Animal Handling",
                    "type": "skills"
                },
                {
                    "id": "survival",
                    "name": "Survival",
                    "type": "skills"
                }
            ],
            "list": [],
            "name": "Skill Proficiency",
            "path": "proficiencies.skills",
            "type": "objectlist",
            "uuid": "2d785d22-2080-4e6c-a2eb-5a3465bf2974"
        },
        {
            "add": 1,
            "description": "One type of artisan\u2019s tools, vehicles (land)",
            "filter": [
                {
                    "field": "type",
                    "options": [
                        "artisan"
                    ],
                    "type": "attribute"
                }
            ],
            "list": [
                "gear"
            ],
            "name": "Tool Proficiency",
            "path": "proficiencies.tools",
            "type": "objectlist",
            "uuid": "535e0c04-685a-4637-9212-8e7376a2abdd"
        },
        {
            "add": 1,
            "description": " A set of artisan\u2019s tools (one of your choice),\na shovel, an iron pot, a set of common clothes, and a\npouch containing 10 gp",
            "filter": [
                {
                    "field": "type",
                    "options": [
                        "artisan"
                    ],
                    "type": "attribute"
                }
            ],
            "given": [
                {
                    "count": 1,
                    "id": 278,
                    "name": "Shovel",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 266,
                    "name": "Pot, iron",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 224,
                    "name": "Clothes, common",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 268,
                    "name": "Pouch",
                    "type": "gear"
                }
            ],
            "list": [
                "gear"
            ],
            "multiple": true,
            "name": "Equipment",
            "path": "equipment",
            "type": "objectlist",
            "uuid": "eb0cf537-06f8-4406-a036-3cdc12645269"
        },
        {
            "hidden": true,
            "path": "wealth.gp",
            "type": "value",
            "uuid": "d2fd2a34-f2fe-4b7a-8869-fad14112dcea",
            "value": 10
        },
        {
            "config": [
                {
                    "path": "info.Defining Event",
                    "suggestions": [
                        "I stood up to a tyrant\u2019s agents.",
                        "I saved people during a natural disaster.",
                        "I stood alone against a terrible monster.",
                        "I stole from a corrupt merchant to help the poor.",
                        "I led a militia to fight off an invading army.",
                        "I broke into a tyrant\u2019s castle and stole weapons to arm the people.",
                        "I trained the peasantry to use farm implements as weapons against a tyrant\u2019s soldiers.",
                        "A lord rescinded an unpopular decree after I led a symbolic act of protest against it.",
                        "A celestial, fey, or similar creature gave me a blessing or revealed my secret origin.",
                        "Recruited into a lord\u2019s army, I rose to leadership and was commended for my heroism."
                    ],
                    "type": "manual",
                    "uuid": "86d15f4e-b265-422b-8e90-4b939a44f5fe"
                }
            ],
            "description": "You previously pursued a simple profession among the\npeasantry, perhaps as a farmer, miner, servant, shepherd,\nwoodcutter, or gravedigger. But something happened that\nset you on a different path and marked you for greater\nthings. Choose or randomly determine a defining event\nthat marked you as a hero of the people.",
            "name": "Defining Event",
            "type": "config",
            "uuid": "2dc96e58-ce93-4452-8d10-1eff27207cdb"
        },
        {
            "name": "Feature: Rustic Hospitality",
            "path": "info.Feature: Rustic Hospitality",
            "type": "value",
            "uuid": "efe2eb67-7555-4911-948e-b0321ca2cb61",
            "value": "Since you come from the ranks of the common folk, you\nfit in among them with ease. You can find a place to hide,\nrest, or recuperate among other commoners, unless you\nhave shown yourself to be a danger to them. They will\nshield you from the law or anyone else searching for you,\nthough they will not risk their lives for you."
        },
        {
            "config": [
                {
                    "name": "Personality Trait",
                    "path": "personality.traits",
                    "suggestions": [
                        "I judge people by their actions, not their words.",
                        "If someone is in trouble, I\u2019m always ready to lend help.",
                        "When I set my mind to something, I follow through no matter what gets in my way.",
                        "I have a strong sense of fair play and always try to find the most equitable solution to arguments.",
                        "I\u2019m confident in my own abilities and do what I can to instill confidence in others.",
                        "Thinking is for other people. I prefer action.",
                        "I misuse long words in an attempt to sound smarter.",
                        "I get bored easily. When am I going to get on with my destiny?"
                    ],
                    "type": "manual",
                    "uuid": "56ecddd2-d524-4947-92a1-a851c1f65bcd"
                },
                {
                    "name": "Ideal",
                    "path": "personality.ideals",
                    "suggestions": [
                        "*Respect*. People deserve to be treated with dignity and respect. (Good)",
                        "*Fairness*. No one should get preferential treatment before the law, and no one is above the law. (Lawful)",
                        "*Freedom*. Tyrants must not be allowed to oppress the people. (Chaotic)",
                        "*Might*. If I become strong, I can take what I want\u2014what I deserve. (Evil)",
                        "*Sincerity*. There\u2019s no good in pretending to be something I\u2019m not. (Neutral)",
                        "*Destiny*. Nothing and no one can steer me away from my higher calling. (Any)"
                    ],
                    "type": "manual",
                    "uuid": "876042e8-8ff2-48f6-9b76-d977bc439bfe"
                },
                {
                    "name": "Bond",
                    "path": "personality.bonds",
                    "suggestions": [
                        "I have a family, but I have no idea where they are. One day, I hope to see them again.",
                        "I worked the land, I love the land, and I will protect the land.",
                        "A proud noble once gave me a horrible beating, and I will take my revenge on any bully I encounter.",
                        "My tools are symbols of my past life, and I carry them so that I will never forget my roots.",
                        "I protect those who cannot protect themselves.",
                        "I wish my childhood sweetheart had come with me to pursue my destiny"
                    ],
                    "type": "manual",
                    "uuid": "2dd468bb-1f59-4dc2-bf10-653411d00b75"
                },
                {
                    "name": "Flaw",
                    "path": "personality.flaws",
                    "suggestions": [
                        "The tyrant who rules my land will stop at nothing to see me killed.",
                        "I\u2019m convinced of the significance of my destiny, and blind to my shortcomings and the risk of failure.",
                        "The people who knew me when I was young know my shameful secret, so I can never go home again.",
                        "I have a weakness for the vices of the city, especially hard drink.",
                        "Secretly, I believe that things would be better if I were a tyrant lording over the land.",
                        "I have trouble trusting in my allies."
                    ],
                    "type": "manual",
                    "uuid": "847696ef-ead1-485c-a9a6-179d37997319"
                }
            ],
            "description": "A folk hero is one of the common people, for better or for\nworse. Most folk heroes look on their humble origins as\na virtue, not a shortcoming, and their home communities\nremain very important to them.",
            "name": "Suggested Characteristics",
            "type": "config",
            "uuid": "caa0d5ce-398a-4e7c-9ff3-3891c8bf8598"
        }
    ],
    "description": "You come from a humble social rank, but you are\ndestined for so much more. Already the people of\nyour home village regard you as their champion, and\nyour destiny calls you to stand against the tyrants and\nmonsters that threaten the common folk everywhere.",
    "phases": [
        {
            "conditions": [
                {
                    "path": "sub.folkhero.level",
                    "type": "eq",
                    "value": 1
                }
            ],
            "config": [],
            "name": "Folk Hero 2",
            "type": "config",
            "uuid": "5c708e18-da48-4eef-982c-e7cf4deecb48"
        },
        {
            "conditions": [
                {
                    "path": "sub.folkhero.level",
                    "type": "eq",
                    "value": 2
                }
            ],
            "config": [],
            "name": "Folk Hero 3",
            "type": "config",
            "uuid": "625a8419-2deb-4430-829f-2d2827c158d0"
        },
        {
            "conditions": [
                {
                    "path": "sub.folkhero.level",
                    "type": "eq",
                    "value": 3
                }
            ],
            "config": [],
            "name": "Folk Hero 4",
            "type": "config",
            "uuid": "1171f338-0415-4116-bab9-279de4d96fc9"
        },
        {
            "conditions": [
                {
                    "path": "sub.folkhero.level",
                    "type": "eq",
                    "value": 4
                }
            ],
            "config": [],
            "name": "Folk Hero 5",
            "type": "config",
            "uuid": "55e7d1ca-f182-4394-aeb3-4ad9d65b5551"
        },
        {
            "conditions": [
                {
                    "path": "sub.folkhero.level",
                    "type": "eq",
                    "value": 5
                }
            ],
            "config": [],
            "name": "Folk Hero 6",
            "type": "config",
            "uuid": "98dc4020-6f56-4e9b-acb3-9c5af6ff1ef0"
        },
        {
            "conditions": [
                {
                    "path": "sub.folkhero.level",
                    "type": "eq",
                    "value": 6
                }
            ],
            "config": [],
            "name": "Folk Hero 7",
            "type": "config",
            "uuid": "090883c7-a4f3-4e91-aa38-ca64b648be20"
        },
        {
            "conditions": [
                {
                    "path": "sub.folkhero.level",
                    "type": "eq",
                    "value": 7
                }
            ],
            "config": [],
            "name": "Folk Hero 8",
            "type": "config",
            "uuid": "a74a7fe7-c9f3-49fa-8043-b298cf32765b"
        },
        {
            "conditions": [
                {
                    "path": "sub.folkhero.level",
                    "type": "eq",
                    "value": 8
                }
            ],
            "config": [],
            "name": "Folk Hero 9",
            "type": "config",
            "uuid": "54b8e423-162b-4641-8930-a7dac9494a04"
        },
        {
            "conditions": [
                {
                    "path": "sub.folkhero.level",
                    "type": "eq",
                    "value": 9
                }
            ],
            "config": [],
            "name": "Folk Hero 10",
            "type": "config",
            "uuid": "2a292fa7-20ac-410f-a8e4-2c5a890fcaca"
        },
        {
            "conditions": [
                {
                    "path": "sub.folkhero.level",
                    "type": "eq",
                    "value": 10
                }
            ],
            "config": [],
            "name": "Folk Hero 11",
            "type": "config",
            "uuid": "a6554b90-8ca6-4ad9-93b4-0fdf831240ff"
        },
        {
            "conditions": [
                {
                    "path": "sub.folkhero.level",
                    "type": "eq",
                    "value": 11
                }
            ],
            "config": [],
            "name": "Folk Hero 12",
            "type": "config",
            "uuid": "9feb9eb1-f918-4f76-9aa0-274d0a48e6a4"
        },
        {
            "conditions": [
                {
                    "path": "sub.folkhero.level",
                    "type": "eq",
                    "value": 12
                }
            ],
            "config": [],
            "name": "Folk Hero 13",
            "type": "config",
            "uuid": "42b5c9b4-c456-4b35-a557-51901dc1cf31"
        },
        {
            "conditions": [
                {
                    "path": "sub.folkhero.level",
                    "type": "eq",
                    "value": 13
                }
            ],
            "config": [],
            "name": "Folk Hero 14",
            "type": "config",
            "uuid": "e460c132-4744-41db-a804-05b6538c617c"
        },
        {
            "conditions": [
                {
                    "path": "sub.folkhero.level",
                    "type": "eq",
                    "value": 14
                }
            ],
            "config": [],
            "name": "Folk Hero 15",
            "type": "config",
            "uuid": "d8efe642-0c86-457d-a990-83301b9ab787"
        },
        {
            "conditions": [
                {
                    "path": "sub.folkhero.level",
                    "type": "eq",
                    "value": 15
                }
            ],
            "config": [],
            "name": "Folk Hero 16",
            "type": "config",
            "uuid": "d5d1427f-8601-48f6-aa06-a568401ac918"
        },
        {
            "conditions": [
                {
                    "path": "sub.folkhero.level",
                    "type": "eq",
                    "value": 16
                }
            ],
            "config": [],
            "name": "Folk Hero 17",
            "type": "config",
            "uuid": "4e2fe173-a050-480e-80b3-2b5fa1333b64"
        },
        {
            "conditions": [
                {
                    "path": "sub.folkhero.level",
                    "type": "eq",
                    "value": 17
                }
            ],
            "config": [],
            "name": "Folk Hero 18",
            "type": "config",
            "uuid": "590a3ef3-01ff-496b-843f-59fc94fe5559"
        },
        {
            "conditions": [
                {
                    "path": "sub.folkhero.level",
                    "type": "eq",
                    "value": 18
                }
            ],
            "config": [],
            "name": "Folk Hero 19",
            "type": "config",
            "uuid": "d1e875d2-0d5f-499d-9f9a-694b67d28a0e"
        },
        {
            "conditions": [
                {
                    "path": "sub.folkhero.level",
                    "type": "eq",
                    "value": 19
                }
            ],
            "config": [],
            "name": "Folk Hero 20",
            "type": "config",
            "uuid": "3519141a-9348-4dea-bf0e-ad19fa25970b"
        }
    ],
    "type": "config",
    "uuid": "d77a73fa-4d7b-4963-9224-a3fa77cfe4c5"
}');
INSERT INTO `background` (id, name, config)
    VALUES (4, 'Noble', '{
    "conditions": [
        {
            "path": "character.level",
            "type": "lte",
            "value": 1
        }
    ],
    "config": [
        {
            "description": "History, Persuasion",
            "given": [
                {
                    "id": "history",
                    "name": "History",
                    "type": "skills"
                },
                {
                    "id": "persuasion",
                    "name": "Persuasion",
                    "type": "skills"
                }
            ],
            "list": [],
            "name": "Skill Proficiency",
            "path": "proficiencies.skills",
            "type": "objectlist",
            "uuid": "acea2c60-cb78-41b7-8cf6-5387977fdf20"
        },
        {
            "add": 1,
            "description": "One type of gaming set",
            "filter": [
                {
                    "field": "type",
                    "options": [
                        "gaming"
                    ],
                    "type": "attribute"
                }
            ],
            "list": [
                "gear"
            ],
            "name": "Tool Proficiency",
            "path": "proficiencies.tools",
            "type": "objectlist",
            "uuid": "d92cb0f7-6211-468d-92dc-9ad5f9a73088"
        },
        {
            "add": 1,
            "description": " One of your choice",
            "list": [
                "languages"
            ],
            "name": "Languages",
            "path": "proficiencies.languages",
            "type": "objectlist",
            "uuid": "363401e7-d35e-40b9-b1e8-d9ea3401a2b1"
        },
        {
            "description": "A set of fine clothes, a signet ring, a scroll of\npedigree, and a purse containing 25 gp",
            "given": [
                {
                    "count": 1,
                    "id": 226,
                    "name": "Clothes, fine",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 280,
                    "name": "Signet ring",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 219,
                    "name": "Case, map or scroll",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 268,
                    "name": "Pouch",
                    "type": "gear"
                }
            ],
            "list": [],
            "multiple": true,
            "name": "Equipment",
            "path": "equipment",
            "type": "objectlist",
            "uuid": "07b69d1e-43f3-4583-bf7f-70e8104da4f0"
        },
        {
            "hidden": true,
            "path": "wealth.gp",
            "type": "value",
            "uuid": "75f1003f-3882-4956-b544-fc049054d4c1",
            "value": 25
        },
        {
            "name": "Feature: Position of Privilege",
            "path": "info.Feature: Position of Privilege",
            "type": "value",
            "uuid": "c5c8565c-39dd-4f04-b7c3-4f508035c00c",
            "value": "Thanks to your noble birth, people are inclined to think\nthe best of you. You are welcome in high society, and\npeople assume you have the right to be wherever you are.\nThe common folk make every effort to accommodate you\nand avoid your displeasure, and other people of high birth\ntreat you as a member of the same social sphere. You can\nsecure an audience with a local noble if you need to."
        },
        {
            "config": [
                {
                    "name": "Personality Trait",
                    "path": "personality.traits",
                    "suggestions": [
                        "My eloquent flattery makes everyone I talk to feel like the most wonderful and important person in the world.",
                        "The common folk love me for my kindness and generosity.",
                        "No one could doubt by looking at my regal bearing that I am a cut above the unwashed masses.",
                        "I take great pains to always look my best and follow the latest fashions.",
                        "I don\u2019t like to get my hands dirty, and I won\u2019t be caught dead in unsuitable accommodations.",
                        "Despite my noble birth, I do not place myself above other folk. We all have the same blood.",
                        "My favor, once lost, is lost forever.",
                        "If you do me an injury, I will crush you, ruin your name, and salt your fields."
                    ],
                    "type": "manual",
                    "uuid": "6ceddba2-8e3f-466d-8da7-12be30c73576"
                },
                {
                    "name": "Ideal",
                    "path": "personality.ideals",
                    "suggestions": [
                        "*Respect*. Respect is due to me because of my position, but all people regardless of station deserve to be treated with dignity. (Good)",
                        "*Responsibility*. It is my duty to respect the authority of those above me, just as those below me must respect mine. (Lawful)",
                        "*Independence*. I must prove that I can handle myself without the coddling of my family. (Chaotic)",
                        "*Power*. If I can attain more power, no one will tell me what to do. (Evil)",
                        "*Family*. Blood runs thicker than water. (Any)",
                        "*Noble Obligation*. It is my duty to protect and care for the people beneath me. (Good)"
                    ],
                    "type": "manual",
                    "uuid": "8c2a91d1-6ff3-40a9-9316-0977420c4501"
                },
                {
                    "name": "Bond",
                    "path": "personality.bonds",
                    "suggestions": [
                        "I will face any challenge to win the approval of my family.",
                        "My house\u2019s alliance with another noble family must be sustained at all costs.",
                        "Nothing is more important than the other members of my family.",
                        "I am in love with the heir of a family that my family despises.",
                        "My loyalty to my sovereign is unwavering.",
                        "The common folk must see me as a hero of the people."
                    ],
                    "type": "manual",
                    "uuid": "c57a2bbc-8de7-4560-a661-6e24ffab8c24"
                },
                {
                    "name": "Flaw",
                    "path": "personality.flaws",
                    "suggestions": [
                        "I secretly believe that everyone is beneath me.",
                        "I hide a truly scandalous secret that could ruin my family forever.",
                        "I too often hear veiled insults and threats in every word addressed to me, and I\u2019m quick to anger.",
                        "I have an insatiable desire for carnal pleasures.",
                        "In fact, the world does revolve around me.",
                        "By my words and actions, I often bring shameto my family."
                    ],
                    "type": "manual",
                    "uuid": "43c22cf5-a87b-4c18-883c-88dd6cff8efa"
                }
            ],
            "description": "Nobles are born and raised to a very different lifestyle\nthan most people ever experience, and their personalities\nreflect that upbringing. A noble title comes with a plethora of bonds\u2014responsibilities to family, to other nobles\n(including the sovereign), to the people entrusted to the\nfamily\u2019s care, or even to the title itself. But this responsibility is often a good way to undermine a noble.",
            "name": "Suggested Characteristics",
            "type": "config",
            "uuid": "0d6ffd42-7276-4269-b33b-271e2ece5381"
        }
    ],
    "description": "You understand wealth, power, and privilege. You carry\na noble title, and your family owns land, collects taxes,\nand wields significant political influence. You might be\na pampered aristocrat unfamiliar with work or discomfort, a former merchant just elevated to the nobility, or\na disinherited scoundrel with a disproportionate sense\nof entitlement. Or you could be an honest, hard-working\nlandowner who cares deeply about the people who live\nand work on your land, keenly aware of your responsibility to them.",
    "phases": [
        {
            "conditions": [
                {
                    "path": "sub.noble.level",
                    "type": "eq",
                    "value": 1
                }
            ],
            "config": [],
            "name": "Noble 2",
            "type": "config",
            "uuid": "ee7c739c-9bb4-4356-8832-9c90d60f48ac"
        },
        {
            "conditions": [
                {
                    "path": "sub.noble.level",
                    "type": "eq",
                    "value": 2
                }
            ],
            "config": [],
            "name": "Noble 3",
            "type": "config",
            "uuid": "585b7701-2b6a-4c94-8f85-110f2f7be6e0"
        },
        {
            "conditions": [
                {
                    "path": "sub.noble.level",
                    "type": "eq",
                    "value": 3
                }
            ],
            "config": [],
            "name": "Noble 4",
            "type": "config",
            "uuid": "9af82e08-af17-4d87-98e4-6dc841543a06"
        },
        {
            "conditions": [
                {
                    "path": "sub.noble.level",
                    "type": "eq",
                    "value": 4
                }
            ],
            "config": [],
            "name": "Noble 5",
            "type": "config",
            "uuid": "c5629f21-429a-45ab-a38d-fe6a4ba1c57a"
        },
        {
            "conditions": [
                {
                    "path": "sub.noble.level",
                    "type": "eq",
                    "value": 5
                }
            ],
            "config": [],
            "name": "Noble 6",
            "type": "config",
            "uuid": "196c77ad-a12d-4281-8265-d71f699585ae"
        },
        {
            "conditions": [
                {
                    "path": "sub.noble.level",
                    "type": "eq",
                    "value": 6
                }
            ],
            "config": [],
            "name": "Noble 7",
            "type": "config",
            "uuid": "b9f0db91-b3e1-404d-b034-729dc134ece4"
        },
        {
            "conditions": [
                {
                    "path": "sub.noble.level",
                    "type": "eq",
                    "value": 7
                }
            ],
            "config": [],
            "name": "Noble 8",
            "type": "config",
            "uuid": "64a2bb4b-1c28-49d0-b4e1-c96c03e6f6f8"
        },
        {
            "conditions": [
                {
                    "path": "sub.noble.level",
                    "type": "eq",
                    "value": 8
                }
            ],
            "config": [],
            "name": "Noble 9",
            "type": "config",
            "uuid": "54b8e2a5-c222-4569-884e-fb1bd9841bc2"
        },
        {
            "conditions": [
                {
                    "path": "sub.noble.level",
                    "type": "eq",
                    "value": 9
                }
            ],
            "config": [],
            "name": "Noble 10",
            "type": "config",
            "uuid": "3b4a4949-7b44-489b-91d6-88fd30234384"
        },
        {
            "conditions": [
                {
                    "path": "sub.noble.level",
                    "type": "eq",
                    "value": 10
                }
            ],
            "config": [],
            "name": "Noble 11",
            "type": "config",
            "uuid": "f92b1812-4cee-42b4-90a0-7969fcceb6cc"
        },
        {
            "conditions": [
                {
                    "path": "sub.noble.level",
                    "type": "eq",
                    "value": 11
                }
            ],
            "config": [],
            "name": "Noble 12",
            "type": "config",
            "uuid": "1d954195-be5b-483e-8aa0-ec22f217fde1"
        },
        {
            "conditions": [
                {
                    "path": "sub.noble.level",
                    "type": "eq",
                    "value": 12
                }
            ],
            "config": [],
            "name": "Noble 13",
            "type": "config",
            "uuid": "282486fb-83c8-4ba1-9dd3-209bf7ea604f"
        },
        {
            "conditions": [
                {
                    "path": "sub.noble.level",
                    "type": "eq",
                    "value": 13
                }
            ],
            "config": [],
            "name": "Noble 14",
            "type": "config",
            "uuid": "77dca1a8-fe84-4d35-905b-ff22a793b79a"
        },
        {
            "conditions": [
                {
                    "path": "sub.noble.level",
                    "type": "eq",
                    "value": 14
                }
            ],
            "config": [],
            "name": "Noble 15",
            "type": "config",
            "uuid": "8947e279-560e-434d-8282-be0ad957419f"
        },
        {
            "conditions": [
                {
                    "path": "sub.noble.level",
                    "type": "eq",
                    "value": 15
                }
            ],
            "config": [],
            "name": "Noble 16",
            "type": "config",
            "uuid": "d763e3c1-7df3-4de8-9ca9-3153933f6070"
        },
        {
            "conditions": [
                {
                    "path": "sub.noble.level",
                    "type": "eq",
                    "value": 16
                }
            ],
            "config": [],
            "name": "Noble 17",
            "type": "config",
            "uuid": "8f976ffd-c527-447a-92c9-e90f799fbd0e"
        },
        {
            "conditions": [
                {
                    "path": "sub.noble.level",
                    "type": "eq",
                    "value": 17
                }
            ],
            "config": [],
            "name": "Noble 18",
            "type": "config",
            "uuid": "8b0c77da-d723-4b2f-8d3c-51f1fb364d78"
        },
        {
            "conditions": [
                {
                    "path": "sub.noble.level",
                    "type": "eq",
                    "value": 18
                }
            ],
            "config": [],
            "name": "Noble 19",
            "type": "config",
            "uuid": "76afa1c2-2bf3-413a-8006-73409eb94b7d"
        },
        {
            "conditions": [
                {
                    "path": "sub.noble.level",
                    "type": "eq",
                    "value": 19
                }
            ],
            "config": [],
            "name": "Noble 20",
            "type": "config",
            "uuid": "5fc51f2c-2fda-4242-b17a-6891759e08e5"
        }
    ],
    "type": "config",
    "uuid": "8949d8ae-83b3-4364-982b-8956b0537767"
}');
INSERT INTO `background` (id, name, config)
    VALUES (5, 'Sage', '{
    "conditions": [
        {
            "path": "character.level",
            "type": "lte",
            "value": 1
        }
    ],
    "config": [
        {
            "description": "Arcana, History",
            "given": [
                {
                    "id": "arcana",
                    "name": "Arcana",
                    "type": "skills"
                },
                {
                    "id": "history",
                    "name": "History",
                    "type": "skills"
                }
            ],
            "list": [],
            "name": "Skill Proficiency",
            "path": "proficiencies.skills",
            "type": "objectlist",
            "uuid": "d5d744db-74ae-488a-9fde-116eae0995a9"
        },
        {
            "add": 2,
            "description": "Two of your choice",
            "list": [
                "languages"
            ],
            "name": "Languages",
            "path": "proficiencies.languages",
            "type": "objectlist",
            "uuid": "b57efafc-f882-43bd-bddc-28c92642de93"
        },
        {
            "description": "A bottle of black ink, a quill, a small knife, a\nletter from a dead colleague posing a question you have\nnot yet been able to answer, a set of common clothes,\nand a pouch containing 10 gp",
            "given": [
                {
                    "count": 1,
                    "id": 246,
                    "name": "Ink (1 ounce bottle)",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 247,
                    "name": "Ink pen",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 296,
                    "name": "Small knife",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 259,
                    "name": "Paper (one sheet)",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 224,
                    "name": "Clothes, common",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 268,
                    "name": "Pouch",
                    "type": "gear"
                }
            ],
            "list": [
                "armor",
                "gear",
                "weapon"
            ],
            "multiple": true,
            "name": "Equipment",
            "path": "equipment",
            "type": "objectlist",
            "uuid": "f276db4f-003c-434f-bb6b-23beae746435"
        },
        {
            "hidden": true,
            "path": "wealth.gp",
            "type": "value",
            "uuid": "cde82df5-db56-44b1-a2fb-e573e55cbc1a",
            "value": 10
        },
        {
            "config": [
                {
                    "path": "info.Specialty",
                    "suggestions": [
                        "Alchemist",
                        "Astronomer",
                        "Discredited academic",
                        "Librarian",
                        "Professor",
                        "Researcher",
                        "Wizard\u2019s apprentice",
                        "Scribe"
                    ],
                    "type": "manual",
                    "uuid": "5dc06d82-4d8d-4403-bbc3-6dc46130c7c0"
                }
            ],
            "description": "To determine the nature of your scholarly training, choose from the options in the table below.",
            "name": "Specialty",
            "type": "config",
            "uuid": "206caf2f-99bc-4678-8e60-87539dcc5cea"
        },
        {
            "name": "Feature: Researcher",
            "path": "info.Feature: Researcher",
            "type": "value",
            "uuid": "09d15c1c-9762-4cfa-b8c0-146517c4a0f1",
            "value": "When you attempt to learn or recall a piece of lore, if you\ndo not know that information, you often know where and\nfrom whom you can obtain it. Usually, this information\ncomes from a library, scriptorium, university, or a sage\nor other learned person or creature. Your DM might rule\nthat the knowledge you seek is secreted away in an almost inaccessible place, or that it simply cannot be found.\nUnearthing the deepest secrets of the multiverse can require an adventure or even a whole campaign."
        },
        {
            "config": [
                {
                    "name": "Personality Trait",
                    "path": "personality.traits",
                    "suggestions": [
                        "I use polysyllabic words that convey the impression of great erudition.",
                        "I\u2019ve read every book in the world\u2019s greatest libraries\u2014or I like to boast that I have.",
                        "I\u2019m used to helping out those who aren\u2019t as smart as I am, and I patiently explain anything and everything to others.",
                        "There\u2019s nothing I like more than a good mystery.",
                        "I\u2019m willing to listen to every side of an argument before I make my own judgment.",
                        "I . . . speak . . . slowly . . . when talking . . . to idiots, . . . which . . . almost . . . everyone . . . is . . . compared . . . to me.",
                        "I am horribly, horribly awkward in social situations.",
                        "I\u2019m convinced that people are always trying to steal my secrets."
                    ],
                    "type": "manual",
                    "uuid": "eeb9c74b-d7cc-487e-82e3-32439764ed24"
                },
                {
                    "name": "Ideal",
                    "path": "personality.ideals",
                    "suggestions": [
                        "*Knowledge*. The path to power and self-improvement is through knowledge. (Neutral)",
                        "*Beauty*. What is beautiful points us beyond itself toward what is true. (Good)",
                        "*Logic*. Emotions must not cloud our logical thinking. (Lawful)",
                        "*No Limits*. Nothing should fetter the infinite possibility inherent in all existence. (Chaotic)",
                        "*Power*. Knowledge is the path to power and domination. (Evil)",
                        "*Self-Improvement*. The goal of a life of study is the betterment of oneself. (Any)"
                    ],
                    "type": "manual",
                    "uuid": "e902349a-7ed6-4241-a4e4-8a4e4c23b9f4"
                },
                {
                    "name": "Bond",
                    "path": "personality.bonds",
                    "suggestions": [
                        "It is my duty to protect my students.",
                        "I have an ancient text that holds terrible secrets that must not fall into the wrong hands.",
                        "I work to preserve a library, university, scriptorium, or monastery.",
                        "My life\u2019s work is a series of tomes related to a specific field of lore.",
                        "I\u2019ve been searching my whole life for the answer to a certain question.",
                        "I sold my soul for knowledge. I hope to do great deeds and win it back."
                    ],
                    "type": "manual",
                    "uuid": "879298c8-8cbc-4aee-aa23-4b243f5ccd39"
                },
                {
                    "name": "Flaw",
                    "path": "personality.flaws",
                    "suggestions": [
                        "I am easily distracted by the promise of information.",
                        "Most people scream and run when they see a demon. I stop and take notes on its anatomy.",
                        "Unlocking an ancient mystery is worth the price of a civilization.",
                        "I overlook obvious solutions in favor of complicated ones.",
                        "I speak without really thinking through my words, invariably insulting others.",
                        "I can\u2019t keep a secret to save my life, or anyone else\u2019s"
                    ],
                    "type": "manual",
                    "uuid": "4c6b63b9-8092-4ab4-8b60-c1600f27d68c"
                }
            ],
            "description": "Sages are defined by their extensive studies, and their\ncharacteristics reflect this life of study. Devoted to\nscholarly pursuits, a sage values knowledge highly\u2014\nsometimes in its own right, sometimes as a means\ntoward other ideals.",
            "name": "Suggested Characteristics",
            "type": "config",
            "uuid": "650f4953-757c-4bc9-b147-19b956dec28f"
        }
    ],
    "description": "You spent years learning the lore of the multiverse. You\nscoured manuscripts, studied scrolls, and listened to the\ngreatest experts on the subjects that interest you. Your\nefforts have made you a master in your fields of study.",
    "phases": [
        {
            "conditions": [
                {
                    "path": "sub.sage.level",
                    "type": "eq",
                    "value": 1
                }
            ],
            "config": [],
            "name": "Sage 2",
            "type": "config",
            "uuid": "ec267f4e-d22a-46d6-9555-a7f4f315f793"
        },
        {
            "conditions": [
                {
                    "path": "sub.sage.level",
                    "type": "eq",
                    "value": 2
                }
            ],
            "config": [],
            "name": "Sage 3",
            "type": "config",
            "uuid": "c02a220b-2861-4b8d-83fc-00b7774e9b3f"
        },
        {
            "conditions": [
                {
                    "path": "sub.sage.level",
                    "type": "eq",
                    "value": 3
                }
            ],
            "config": [],
            "name": "Sage 4",
            "type": "config",
            "uuid": "2ba1b51a-30a2-4135-b885-bd212fd6c7a4"
        },
        {
            "conditions": [
                {
                    "path": "sub.sage.level",
                    "type": "eq",
                    "value": 4
                }
            ],
            "config": [],
            "name": "Sage 5",
            "type": "config",
            "uuid": "15108f22-c4c0-4760-84ab-3434684a98c5"
        },
        {
            "conditions": [
                {
                    "path": "sub.sage.level",
                    "type": "eq",
                    "value": 5
                }
            ],
            "config": [],
            "name": "Sage 6",
            "type": "config",
            "uuid": "752d028e-faa4-45ab-a21e-9720e7a9ec8c"
        },
        {
            "conditions": [
                {
                    "path": "sub.sage.level",
                    "type": "eq",
                    "value": 6
                }
            ],
            "config": [],
            "name": "Sage 7",
            "type": "config",
            "uuid": "194d754d-1c79-4bac-a6d4-215afbae66cc"
        },
        {
            "conditions": [
                {
                    "path": "sub.sage.level",
                    "type": "eq",
                    "value": 7
                }
            ],
            "config": [],
            "name": "Sage 8",
            "type": "config",
            "uuid": "2c0d8f8e-5a00-4c20-8a41-2778039ba2cd"
        },
        {
            "conditions": [
                {
                    "path": "sub.sage.level",
                    "type": "eq",
                    "value": 8
                }
            ],
            "config": [],
            "name": "Sage 9",
            "type": "config",
            "uuid": "3e3d2c58-8ce1-4c70-a971-7dd1f41356cf"
        },
        {
            "conditions": [
                {
                    "path": "sub.sage.level",
                    "type": "eq",
                    "value": 9
                }
            ],
            "config": [],
            "name": "Sage 10",
            "type": "config",
            "uuid": "9448e75c-baf3-4142-87e1-6edb8508d2a0"
        },
        {
            "conditions": [
                {
                    "path": "sub.sage.level",
                    "type": "eq",
                    "value": 10
                }
            ],
            "config": [],
            "name": "Sage 11",
            "type": "config",
            "uuid": "2f4dc199-809d-444f-ae0b-93282f09f726"
        },
        {
            "conditions": [
                {
                    "path": "sub.sage.level",
                    "type": "eq",
                    "value": 11
                }
            ],
            "config": [],
            "name": "Sage 12",
            "type": "config",
            "uuid": "9ac618b1-cf72-449c-90eb-308911a7d3eb"
        },
        {
            "conditions": [
                {
                    "path": "sub.sage.level",
                    "type": "eq",
                    "value": 12
                }
            ],
            "config": [],
            "name": "Sage 13",
            "type": "config",
            "uuid": "72a34bbe-7767-4693-9f43-51062a2217af"
        },
        {
            "conditions": [
                {
                    "path": "sub.sage.level",
                    "type": "eq",
                    "value": 13
                }
            ],
            "config": [],
            "name": "Sage 14",
            "type": "config",
            "uuid": "37cdf8c0-3a74-40bf-b9c6-368ced808c49"
        },
        {
            "conditions": [
                {
                    "path": "sub.sage.level",
                    "type": "eq",
                    "value": 14
                }
            ],
            "config": [],
            "name": "Sage 15",
            "type": "config",
            "uuid": "4f70fb2a-04df-4ddb-ac89-6f00d1369e54"
        },
        {
            "conditions": [
                {
                    "path": "sub.sage.level",
                    "type": "eq",
                    "value": 15
                }
            ],
            "config": [],
            "name": "Sage 16",
            "type": "config",
            "uuid": "c765f1a9-2a48-44ab-a8b1-aa851674fcab"
        },
        {
            "conditions": [
                {
                    "path": "sub.sage.level",
                    "type": "eq",
                    "value": 16
                }
            ],
            "config": [],
            "name": "Sage 17",
            "type": "config",
            "uuid": "08757b6b-00c0-429e-9b5a-004ab423d796"
        },
        {
            "conditions": [
                {
                    "path": "sub.sage.level",
                    "type": "eq",
                    "value": 17
                }
            ],
            "config": [],
            "name": "Sage 18",
            "type": "config",
            "uuid": "dada2a7b-00a9-4bde-ab1f-957ba7e267f2"
        },
        {
            "conditions": [
                {
                    "path": "sub.sage.level",
                    "type": "eq",
                    "value": 18
                }
            ],
            "config": [],
            "name": "Sage 19",
            "type": "config",
            "uuid": "79558d26-147b-4a65-a258-ec1505a33ae3"
        },
        {
            "conditions": [
                {
                    "path": "sub.sage.level",
                    "type": "eq",
                    "value": 19
                }
            ],
            "config": [],
            "name": "Sage 20",
            "type": "config",
            "uuid": "c4e754e7-75a5-4823-b831-e6d38c51dd1f"
        }
    ],
    "type": "config",
    "uuid": "17bc5ecf-0a6c-44ad-8a14-705b5d852bed"
}');
INSERT INTO `background` (id, name, config)
    VALUES (6, 'Soldier', '{
    "conditions": [
        {
            "path": "character.level",
            "type": "lte",
            "value": 1
        }
    ],
    "config": [
        {
            "description": "Athletics, Intimidation",
            "given": [
                {
                    "id": "athletics",
                    "name": "Athletics",
                    "type": "skills"
                },
                {
                    "id": "intimidation",
                    "name": "Intimidation",
                    "type": "skills"
                }
            ],
            "list": [],
            "name": "Skill Proficiency",
            "path": "proficiencies.skills",
            "type": "objectlist",
            "uuid": "43411722-34ea-4f47-b9b5-a2dda83c9770"
        },
        {
            "add": 1,
            "description": "One type of gaming set,\nvehicles (land)",
            "filter": [
                {
                    "field": "type",
                    "options": [
                        "gaming"
                    ],
                    "type": "attribute"
                }
            ],
            "list": [
                "gear"
            ],
            "name": "Tool Proficiency",
            "path": "proficiencies.tools",
            "type": "objectlist",
            "uuid": "ab806eec-09b0-40db-99da-566c9f64cd29"
        },
        {
            "add": 1,
            "description": "An insignia of rank, a trophy taken from\na fallen enemy (a dagger, broken blade, or piece of a\nbanner), a set of bone dice or deck of cards, a set of\ncommon clothes, and a pouch containing 10 gp",
            "filter": [
                {
                    "field": "id",
                    "options": [
                        169,
                        132,
                        296
                    ],
                    "type": "attribute"
                }
            ],
            "given": [
                {
                    "count": 1,
                    "id": 133,
                    "name": "A rank insignia from a lost legionnaire",
                    "type": "trinket"
                },
                {
                    "count": 1,
                    "id": 78,
                    "name": "Dice set",
                    "type": "gaming"
                },
                {
                    "count": 1,
                    "id": 80,
                    "name": "Playing card set",
                    "type": "gaming"
                },
                {
                    "count": 1,
                    "id": 224,
                    "name": "Clothes, common",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 268,
                    "name": "Pouch",
                    "type": "gear"
                }
            ],
            "list": [
                "armor",
                "gear",
                "weapon"
            ],
            "multiple": true,
            "name": "Equipment",
            "path": "equipment",
            "type": "objectlist",
            "uuid": "8efc5f8b-1552-42a1-b3b0-c3b99f4a57ce"
        },
        {
            "hidden": true,
            "path": "wealth.gp",
            "type": "value",
            "uuid": "7d305cfc-d142-4d79-9522-0d191f911b0b",
            "value": 10
        },
        {
            "config": [
                {
                    "path": "info.Specialty",
                    "suggestions": [
                        "Officer",
                        "Scout",
                        "Infantry",
                        "Cavalry",
                        "Healer",
                        "Quartermaster",
                        "Standard bearer",
                        "Support staff (cook, blacksmith, or the like)"
                    ],
                    "type": "manual",
                    "uuid": "44605c0c-3152-4542-ad6d-0162dbf54320"
                }
            ],
            "description": "During your time as a soldier, you had a specific role to\nplay in your unit or army. Choose from the options in the table below to determine your role:",
            "name": "Specialty",
            "type": "config",
            "uuid": "5470c17c-46a2-4d0d-aedf-f956b1ead763"
        },
        {
            "name": "Feature: Military Rank",
            "path": "info.Feature: Military Rank",
            "type": "value",
            "uuid": "f0632127-c4b3-4d42-b2d2-60cf9e14036b",
            "value": "You have a military rank from your career as a soldier.\nSoldiers loyal to your former military organization still\nrecognize your authority and influence, and they defer to\nyou if they are of a lower rank. You can invoke your rank\nto exert influence over other soldiers and requisition simple equipment or horses for temporary use. You can also\nusually gain access to friendly military encampments and\nfortresses where your rank is recognized."
        },
        {
            "config": [
                {
                    "name": "Personality Trait",
                    "path": "personality.traits",
                    "suggestions": [
                        "I\u2019m always polite and respectful.",
                        "I\u2019m haunted by memories of war. I can\u2019t get the images of violence out of my mind.",
                        "I\u2019ve lost too many friends, and I\u2019m slow to make new ones.",
                        "I\u2019m full of inspiring and cautionary tales from my military experience relevant to almost every combat situation.",
                        "I can stare down a hell hound without flinching.",
                        "I enjoy being strong and like breaking things.",
                        "I have a crude sense of humor.",
                        "I face problems head-on. A simple, direct solution is the best path to success."
                    ],
                    "type": "manual",
                    "uuid": "bd786c6a-f0b2-4937-85ec-e841f679bf2e"
                },
                {
                    "name": "Ideal",
                    "path": "personality.ideals",
                    "suggestions": [
                        "*Greater Good*. Our lot is to lay down our lives in defense of others. (Good)",
                        "*Responsibility*. I do what I must and obey just authority. (Lawful)",
                        "*Independence*. When people follow orders blindly, they embrace a kind of tyranny. (Chaotic)",
                        "*Might*. In life as in war, the stronger force wins. (Evil)",
                        "*Live and Let Live*. Ideals aren\u2019t worth killing over or going to war for. (Neutral)",
                        "*Nation*. My city, nation, or people are all that matter. (Any)"
                    ],
                    "type": "manual",
                    "uuid": "0e6eb585-701e-4eba-a6ec-d890e320c448"
                },
                {
                    "name": "Bond",
                    "path": "personality.bonds",
                    "suggestions": [
                        "I would still lay down my life for the people I served with.",
                        "Someone saved my life on the battlefield. To this day, I will never leave a friend behind.",
                        "My honor is my life.",
                        "I\u2019ll never forget the crushing defeat my company suffered or the enemies who dealt it.",
                        "Those who fight beside me are those worth dying for.",
                        "I fight for those who cannot fight for themselves."
                    ],
                    "type": "manual",
                    "uuid": "d646b79d-2921-4ce3-b26d-961a986a7498"
                },
                {
                    "name": "Flaw",
                    "path": "personality.flaws",
                    "suggestions": [
                        "The monstrous enemy we faced in battle still leaves me quivering with fear.",
                        "I have little respect for anyone who is not a proven warrior.",
                        "I made a terrible mistake in battle that cost many lives \u2014 and I would do anything to keep that mistake secret.",
                        "My hatred of my enemies is blind and unreasoning.",
                        "I obey the law, even if the law causes misery.",
                        "I\u2019d rather eat my armor than admit when I\u2019m wrong"
                    ],
                    "type": "manual",
                    "uuid": "0642c15c-7669-418a-a2b5-5d2bc7587c95"
                }
            ],
            "description": "The horrors of war combined with the rigid discipline of\nmilitary service leave their mark on all soldiers, shaping\ntheir ideals, creating strong bonds, and often leaving\nthem scarred and vulnerable to fear, shame, and hatred.",
            "name": "Suggested Characteristics",
            "type": "config",
            "uuid": "9d11d102-85e1-4849-a0c7-7e0715cbcb02"
        }
    ],
    "description": "War has been your life for as long as you care to remember. You trained as a youth, studied the use of weapons\nand armor, learned basic survival techniques, including\nhow to stay alive on the battlefield. You might have been\npart of a standing national army or a mercenary company, or perhaps a member of a local militia who rose to\nprominence during a recent war.",
    "phases": [
        {
            "conditions": [
                {
                    "path": "sub.soldier.level",
                    "type": "eq",
                    "value": 1
                }
            ],
            "config": [],
            "name": "Soldier 2",
            "type": "config",
            "uuid": "dc90e4fa-5ef4-41c0-969a-055d79dd76f8"
        },
        {
            "conditions": [
                {
                    "path": "sub.soldier.level",
                    "type": "eq",
                    "value": 2
                }
            ],
            "config": [],
            "name": "Soldier 3",
            "type": "config",
            "uuid": "37564aa2-e195-4ca6-8e07-53bb5fb2d452"
        },
        {
            "conditions": [
                {
                    "path": "sub.soldier.level",
                    "type": "eq",
                    "value": 3
                }
            ],
            "config": [],
            "name": "Soldier 4",
            "type": "config",
            "uuid": "6d3d08ca-33d9-4e06-9b95-a6bc47262a4b"
        },
        {
            "conditions": [
                {
                    "path": "sub.soldier.level",
                    "type": "eq",
                    "value": 4
                }
            ],
            "config": [],
            "name": "Soldier 5",
            "type": "config",
            "uuid": "59d6b7b6-ea0b-4ca0-a7ba-4ac7a8d838f3"
        },
        {
            "conditions": [
                {
                    "path": "sub.soldier.level",
                    "type": "eq",
                    "value": 5
                }
            ],
            "config": [],
            "name": "Soldier 6",
            "type": "config",
            "uuid": "00f8b8fc-fd9e-4844-81df-3f4f6bf00bbb"
        },
        {
            "conditions": [
                {
                    "path": "sub.soldier.level",
                    "type": "eq",
                    "value": 6
                }
            ],
            "config": [],
            "name": "Soldier 7",
            "type": "config",
            "uuid": "24d22526-da49-4113-8e65-dcb560247cb1"
        },
        {
            "conditions": [
                {
                    "path": "sub.soldier.level",
                    "type": "eq",
                    "value": 7
                }
            ],
            "config": [],
            "name": "Soldier 8",
            "type": "config",
            "uuid": "93b7581b-c5ba-407a-b200-3d6fba9fde81"
        },
        {
            "conditions": [
                {
                    "path": "sub.soldier.level",
                    "type": "eq",
                    "value": 8
                }
            ],
            "config": [],
            "name": "Soldier 9",
            "type": "config",
            "uuid": "d1d8ba7c-cd5b-41cf-aa4a-bbec7a3ac887"
        },
        {
            "conditions": [
                {
                    "path": "sub.soldier.level",
                    "type": "eq",
                    "value": 9
                }
            ],
            "config": [],
            "name": "Soldier 10",
            "type": "config",
            "uuid": "e428c6a9-2c61-48cf-80af-9fadb858b98f"
        },
        {
            "conditions": [
                {
                    "path": "sub.soldier.level",
                    "type": "eq",
                    "value": 10
                }
            ],
            "config": [],
            "name": "Soldier 11",
            "type": "config",
            "uuid": "b1320470-6934-4771-b767-0bc0e7097291"
        },
        {
            "conditions": [
                {
                    "path": "sub.soldier.level",
                    "type": "eq",
                    "value": 11
                }
            ],
            "config": [],
            "name": "Soldier 12",
            "type": "config",
            "uuid": "bc467008-9789-4792-a400-23044833e932"
        },
        {
            "conditions": [
                {
                    "path": "sub.soldier.level",
                    "type": "eq",
                    "value": 12
                }
            ],
            "config": [],
            "name": "Soldier 13",
            "type": "config",
            "uuid": "114d717e-ed4a-4333-a26d-311caf874fbf"
        },
        {
            "conditions": [
                {
                    "path": "sub.soldier.level",
                    "type": "eq",
                    "value": 13
                }
            ],
            "config": [],
            "name": "Soldier 14",
            "type": "config",
            "uuid": "67ab926c-cac4-43e4-a461-98be41d8ef7d"
        },
        {
            "conditions": [
                {
                    "path": "sub.soldier.level",
                    "type": "eq",
                    "value": 14
                }
            ],
            "config": [],
            "name": "Soldier 15",
            "type": "config",
            "uuid": "230908fd-484d-4d95-95f5-9f54ffc8019c"
        },
        {
            "conditions": [
                {
                    "path": "sub.soldier.level",
                    "type": "eq",
                    "value": 15
                }
            ],
            "config": [],
            "name": "Soldier 16",
            "type": "config",
            "uuid": "17c7e15b-d668-45fb-a47f-145024e5521e"
        },
        {
            "conditions": [
                {
                    "path": "sub.soldier.level",
                    "type": "eq",
                    "value": 16
                }
            ],
            "config": [],
            "name": "Soldier 17",
            "type": "config",
            "uuid": "ea2e6b11-bb01-4d2e-b059-851e26a4f070"
        },
        {
            "conditions": [
                {
                    "path": "sub.soldier.level",
                    "type": "eq",
                    "value": 17
                }
            ],
            "config": [],
            "name": "Soldier 18",
            "type": "config",
            "uuid": "911e167a-16bf-41b5-9041-605efe31acb5"
        },
        {
            "conditions": [
                {
                    "path": "sub.soldier.level",
                    "type": "eq",
                    "value": 18
                }
            ],
            "config": [],
            "name": "Soldier 19",
            "type": "config",
            "uuid": "9f79ec33-87eb-4e53-84e1-6517d82abfe9"
        },
        {
            "conditions": [
                {
                    "path": "sub.soldier.level",
                    "type": "eq",
                    "value": 19
                }
            ],
            "config": [],
            "name": "Soldier 20",
            "type": "config",
            "uuid": "ecb5a597-439e-47bc-a997-fb0766f80836"
        }
    ],
    "type": "config",
    "uuid": "5ba17745-b07c-4d8d-a306-c0fcc07e4eac"
}');

INSERT INTO `options` (id, name, config)
    VALUES (1, 'Core Attributes', '{
    "config": [
        {
            "name": "Name",
            "path": "name",
            "placeholder": "Name...",
            "type": "manual",
            "uuid": "1c5448ed-7240-408b-b1bc-3ad1559a8521"
        },
        {
            "list": [
                "alignments"
            ],
            "name": "Alignment",
            "path": "alignment",
            "type": "select",
            "uuid": "6f557232-b4db-472f-b9d2-ab3cf7d01c3c"
        },
        {
            "list": [
                "genders"
            ],
            "name": "Gender",
            "path": "gender",
            "type": "select",
            "uuid": "49db5884-6198-4689-b214-15925f2a087f"
        },
        {
            "conditions": [
                {
                    "path": "character.level",
                    "type": "lte",
                    "value": 1
                }
            ],
            "editBase": true,
            "name": "Statistics",
            "path": "statistics",
            "type": "statistics",
            "uuid": "ff2f55a5-15e1-4ebd-8c83-d0b52f98fb08"
        },
        {
            "markup": true,
            "name": "Backstory",
            "path": "backstory",
            "placeholder": "Backstory...",
            "type": "manual",
            "uuid": "df0943dd-cf57-4cd2-a02f-5e320e4b0fc6"
        }
    ],
    "description": "",
    "type": "config",
    "uuid": "60722722-b678-49b6-ba32-1b9ae2ec454d"
}');
INSERT INTO `options` (id, name, config)
    VALUES (2, 'Equipment Packs', '{
    "description": "The starting equipment you get from your class includes\na collection of useful adventuring gear, put together in a\npack. The contents of these packs are listed here. If you are\nbuying your starting equipment, you can purchase a pack\nfor the price shown, which might be cheaper than buying\nthe items individually.",
    "options": [
        {
            "description": "**(16 gp)**  Includes a backpack, a bag of\n1,000 ball bearings, 10 feet of string, a bell, 5 candles, a\ncrowbar, a hammer, 10 pitons, a hooded lantern, 2 flasks of\noil, 5 days rations, a tinderbox, and a waterskin. The pack\nalso has 50 feet of hempen rope strapped to the side of it.",
            "given": [
                {
                    "count": 1,
                    "id": 205,
                    "name": "Backpack",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 206,
                    "name": "Ball bearings (bag of 1,000)",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 291,
                    "name": "String (10 ft)",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 210,
                    "name": "Bell",
                    "type": "gear"
                },
                {
                    "count": 5,
                    "id": 217,
                    "name": "Candle",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 229,
                    "name": "Crowbar",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 237,
                    "name": "Hammer",
                    "type": "gear"
                },
                {
                    "count": 10,
                    "id": 263,
                    "name": "Piton",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 252,
                    "name": "Lantern, hooded",
                    "type": "gear"
                },
                {
                    "count": 2,
                    "id": 258,
                    "name": "Oil (flask)",
                    "type": "gear"
                },
                {
                    "count": 5,
                    "id": 271,
                    "name": "Rations (1 day)",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 286,
                    "name": "Tinderbox",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 289,
                    "name": "Waterskin",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 273,
                    "name": "Rope, hempen (50 feet)",
                    "type": "gear"
                }
            ],
            "list": [
                "gear"
            ],
            "multiple": true,
            "name": "Burglar\u2019s Pack",
            "path": "equipment",
            "type": "objectlist",
            "uuid": "5e96d2c9-0bbf-4b3f-b5b6-140785f8c535"
        },
        {
            "description": "**(39 gp)** Includes a chest, 2 cases for\nmaps and scrolls, a set of fine clothes, a bottle of ink, an\nink pen, a lamp, 2 flasks of oil, 5 sheets of paper, a vial of\nperfume, sealing wax, and soap.",
            "given": [
                {
                    "count": 1,
                    "id": 222,
                    "name": "Chest",
                    "type": "gear"
                },
                {
                    "count": 2,
                    "id": 219,
                    "name": "Case, map or scroll",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 246,
                    "name": "Ink (1 ounce bottle)",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 250,
                    "name": "Lamp",
                    "type": "gear"
                },
                {
                    "count": 2,
                    "id": 258,
                    "name": "Oil (flask)",
                    "type": "gear"
                },
                {
                    "count": 5,
                    "id": 259,
                    "name": "Paper (one sheet)",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 261,
                    "name": "Perfume (vial)",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 277,
                    "name": "Sealing wax",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 281,
                    "name": "Soap",
                    "type": "gear"
                }
            ],
            "list": [
                "gear"
            ],
            "multiple": true,
            "name": "Diplomat\u2019s Pack",
            "path": "equipment",
            "type": "objectlist",
            "uuid": "1f788e04-7367-4fde-917f-b1040d363ae2"
        },
        {
            "description": "**(12 gp)** Includes a backpack, a\ncrowbar, a hammer, 10 pitons, 10 torches, a tinderbox, 10\ndays of rations, and a waterskin. The pack also has 50 feet\nof hempen rope strapped to the side of it.",
            "given": [
                {
                    "count": 1,
                    "id": 205,
                    "name": "Backpack",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 229,
                    "name": "Crowbar",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 237,
                    "name": "Hammer",
                    "type": "gear"
                },
                {
                    "count": 10,
                    "id": 263,
                    "name": "Piton",
                    "type": "gear"
                },
                {
                    "count": 10,
                    "id": 287,
                    "name": "Torch",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 286,
                    "name": "Tinderbox",
                    "type": "gear"
                },
                {
                    "count": 10,
                    "id": 271,
                    "name": "Rations (1 day)",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 289,
                    "name": "Waterskin",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 273,
                    "name": "Rope, hempen (50 feet)",
                    "type": "gear"
                }
            ],
            "list": [
                "gear"
            ],
            "multiple": true,
            "name": "Dungeoneer\u2019s Pack",
            "path": "equipment",
            "type": "objectlist",
            "uuid": "9866ea12-0bb0-4257-9455-e532ba3f5764"
        },
        {
            "description": "**(40 gp)** Includes a backpack, a bedroll,\n2 costumes, 5 candles, 5 days of rations, a waterskin, and a\ndisguise kit.",
            "given": [
                {
                    "count": 1,
                    "id": 205,
                    "name": "Backpack",
                    "type": "gear"
                },
                {
                    "count": 2,
                    "id": 225,
                    "name": "Clothes, costume",
                    "type": "gear"
                },
                {
                    "count": 5,
                    "id": 217,
                    "name": "Candle",
                    "type": "gear"
                },
                {
                    "count": 5,
                    "id": 271,
                    "name": "Rations (1 day)",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 289,
                    "name": "Waterskin",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 72,
                    "name": "Disguise kit",
                    "type": "kit"
                }
            ],
            "list": [
                "gear"
            ],
            "multiple": true,
            "name": "Entertainer\u2019s Pack",
            "path": "equipment",
            "type": "objectlist",
            "uuid": "fac0ec52-a25f-4aec-b6fc-6f0e00166e0a"
        },
        {
            "description": "**(10 gp)** Includes a backpack, a bedroll,\na mess kit, a tinderbox, 10 torches, 10 days of rations, and\na waterskin. The pack also has 50 feet of hempen rope\nstrapped to the side of it",
            "given": [
                {
                    "count": 1,
                    "id": 205,
                    "name": "Backpack",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 209,
                    "name": "Bedroll",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 256,
                    "name": "Mess kit",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 286,
                    "name": "Tinderbox",
                    "type": "gear"
                },
                {
                    "count": 10,
                    "id": 287,
                    "name": "Torch",
                    "type": "gear"
                },
                {
                    "count": 10,
                    "id": 271,
                    "name": "Rations (1 day)",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 289,
                    "name": "Waterskin",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 273,
                    "name": "Rope, hempen (50 feet)",
                    "type": "gear"
                }
            ],
            "list": [
                "gear"
            ],
            "multiple": true,
            "name": "Explorer\u2019s Pack",
            "path": "equipment",
            "type": "objectlist",
            "uuid": "28d04479-11f4-4b23-aad7-ee92ec818ddd"
        },
        {
            "description": "**(19 gp)** Includes a backpack, a blanket, 10\ncandles, a tinderbox, an alms box, 2 blocks of incense, a\ncenser, vestments, 2 days of rations, and a waterskin.",
            "given": [
                {
                    "count": 1,
                    "id": 205,
                    "name": "Backpack",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 211,
                    "name": "Blanket",
                    "type": "gear"
                },
                {
                    "count": 10,
                    "id": 217,
                    "name": "Candle",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 286,
                    "name": "Tinderbox",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 297,
                    "name": "Alms box",
                    "type": "gear"
                },
                {
                    "count": 2,
                    "id": 292,
                    "name": "Block of incense",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 293,
                    "name": "Censer",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 294,
                    "name": "Vestments",
                    "type": "gear"
                },
                {
                    "count": 2,
                    "id": 271,
                    "name": "Rations (1 day)",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 289,
                    "name": "Waterskin",
                    "type": "gear"
                }
            ],
            "list": [
                "gear"
            ],
            "multiple": true,
            "name": "Priest\u2019s Pack",
            "path": "equipment",
            "type": "objectlist",
            "uuid": "2b9d026d-d989-46e7-8434-b3dbd6a1f4c7"
        },
        {
            "description": "**(40 gp)** Includes a backpack, a book of\nlore, a bottle of ink, an ink pen, 10 sheets of parchment, a\nlittle bag of sand, and a small knife.",
            "given": [
                {
                    "count": 1,
                    "id": 205,
                    "name": "Backpack",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 298,
                    "name": "Book of lore",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 246,
                    "name": "Ink (1 ounce bottle)",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 247,
                    "name": "Ink pen",
                    "type": "gear"
                },
                {
                    "count": 10,
                    "id": 260,
                    "name": "Parchment (one sheet)",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 295,
                    "name": "Sand (little bag)",
                    "type": "gear"
                },
                {
                    "count": 1,
                    "id": 296,
                    "name": "Small knife",
                    "type": "gear"
                }
            ],
            "list": [
                "gear"
            ],
            "multiple": true,
            "name": "Scholar\u2019s Pack",
            "path": "equipment",
            "type": "objectlist",
            "uuid": "2199848e-b3e3-40c8-9f8a-af3fdac5911c"
        }
    ],
    "type": "choice"
}');
INSERT INTO `options` (id, name, config)
    VALUES (3, 'Feats', '{
    "description": "A feat represents a talent or an area of expertise that gives\na character special capabilities. It embodies training, experience, and abilities beyond what a class provides. See\nchapter 6 of the Player\u2019s Handbook for more information.\n\nAt certain levels, your class gives you the **Ability Score\nImprovement** feature. Using the optional feats rule, you\ncan forgo taking that feature to take a feat of your choice\ninstead. You can take each feat only once, unless the\nfeat\u2019s description says otherwise.\n\nYou must meet any prerequisite specified in a feat to\ntake that feat. If you ever lose a feat\u2019s prerequisite, you\ncan\u2019t use that feat until you regain the prerequisite. ",
    "options": [],
    "type": "multichoice",
    "uuid": "a3bff055-374b-46c3-9d2f-43ddefecc833"
}');
INSERT INTO `options` (id, name, config)
    VALUES (4, 'Fighting Style', '{
    "description": "You adopt a particular style of fighting as your specialty.\nChoose one of the following options. You can\u2019t take a\n**Fighting Style** option more than once, even if you later\nget to choose again.",
    "options": [
        {
            "config": [
                {
                    "path": "info.Archery",
                    "type": "value",
                    "uuid": "20d17209-a19e-40c9-915c-5f12fa6d68e7",
                    "value": "You gain a +2 bonus to attack rolls you make with ranged weapons."
                }
            ],
            "name": "Archery",
            "type": "config",
            "uuid": "2f2f7c93-aea5-4db8-8714-688f2d841344"
        },
        {
            "config": [
                {
                    "path": "info.Defense",
                    "type": "value",
                    "uuid": "2cd7e6c6-ae70-450a-86e1-2a0303c21d3e",
                    "value": "While you are wearing armor, you gain a +1 bonus to AC."
                },
                {
                    "given": [
                        1
                    ],
                    "hidden": true,
                    "multiple": true,
                    "path": "computed.armor_class.bonus",
                    "type": "list",
                    "uuid": "615f556c-ea64-4d1f-a21c-2c2b0a0d460b"
                }
            ],
            "name": "Defense",
            "type": "config",
            "uuid": "544c85f4-b794-4512-a435-f29201b6381d"
        },
        {
            "config": [
                {
                    "path": "info.Dueling",
                    "type": "value",
                    "uuid": "19ca7b18-f33a-4e62-af1d-3673ef32e4b8",
                    "value": "When you are wielding a melee weapon in one hand and\nno other weapons, you gain a +2 bonus to damage rolls\nwith that weapon."
                }
            ],
            "name": "Dueling",
            "type": "config",
            "uuid": "2ecd9748-a36e-4ec8-8d99-08ce98dd5a8e"
        },
        {
            "config": [
                {
                    "path": "info.Great Weapon Fighting",
                    "type": "value",
                    "uuid": "0d5a2802-f2a1-4261-8a7c-37ab928e1d4c",
                    "value": "When you roll a 1 or 2 on a damage die for an attack you\nmake with a melee weapon that you are wielding with\ntwo hands, you can reroll the die and must use the new\nroll, even if the new roll is a 1 or a 2. The weapon must\nhave the two-handed or versatile property for you to gain\nthis benefit."
                }
            ],
            "name": "Great Weapon Fighting",
            "type": "config",
            "uuid": "a47225b7-a315-48a8-856d-e77673359836"
        },
        {
            "config": [
                {
                    "path": "info.Protection",
                    "type": "value",
                    "uuid": "8dc11eac-18f7-4f68-bd54-6f63bb985600",
                    "value": "When a creature you can see attacks a target other than\nyou that is within 5 feet of you, you can use your *reaction*\nto impose **disadvantage** on the attack roll. You must be\nwielding a shield."
                }
            ],
            "name": "Protection",
            "type": "config",
            "uuid": "6a49e108-44bc-455b-a04c-bef989b5e6d1"
        },
        {
            "config": [
                {
                    "path": "info.Two-Weapon Fighting",
                    "type": "value",
                    "uuid": "6db82b06-05ab-40f3-9176-cd6302f216af",
                    "value": "When you engage in two-weapon fighting, you can add\nyour ability modifier to the damage of the second attack."
                }
            ],
            "name": "Two-Weapon Fighting",
            "type": "config",
            "uuid": "e85ff312-e5ee-47fb-a790-8347df8929c7"
        }
    ],
    "type": "multichoice",
    "uuid": "59f2c018-6490-4fbf-89e1-74875e2256fb"
}');
