package model

import (
	"encoding/json"
	"io"

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

func (Character) Table() string {
	return `character`
}

func (Character) Columns() []string {
	return []string{"user_id", "name", "level", "config"}
}

func (c Character) NewFromReader(r io.Reader) (database.Persistable, error) {
	var n Character
	err := json.NewDecoder(r).Decode(&n)
	return n, err
}

func (c Character) GetFields() []interface{} {
	config, _ := json.Marshal(c.CharacterAttributes)
	return []interface{}{
		c.UserID,
		c.Name,
		c.Level,
		string(config),
	}
}

func (Character) NewFromRow(row database.Scanner) (database.Persistable, error) {
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
}

var CharacterDB = database.NewOperatorForPersistable(Character{})
