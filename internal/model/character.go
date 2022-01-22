package model

import (
	"database/sql"
	"encoding/json"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
)

type Character struct {
	CharacterAttributes
	ID     int64  `json:"id"`
	UserID int64  `json:"userID"`
	Name   string `json:"name"`
	Level  int    `json:"level"`
}

type CharacterAttributes struct {
}

var CharacterDB = database.NewOperator(
	`character`,
	`SELECT
		id, user_id, name, level, config
	FROM character
	`,
	func(row *sql.Row) (interface{}, error) {
		var (
			c      Character
			config string
		)

		if err := row.Scan(&c.ID, &c.UserID, &c.Name, &c.Level, &config); err != nil {
			return c, err
		}

		if err := json.Unmarshal([]byte(config), &c.CharacterAttributes); err != nil {
			return c, err
		}

		return c, nil
	},
)
