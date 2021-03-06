package model

import (
	"encoding/json"
	"fmt"
	"io"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
)

// Character is the database.Persistable and api.JSONable implementation of a
// character model.
type Character struct {
	CharacterAttributes
	ID     int64  `json:"id"`
	UserID int64  `json:"userID"`
	Name   string `json:"name"`
	Level  int    `json:"level"`
}

// CharacterAttributes are a collection of non-primary fields stored in the
// config column of the character table.
type CharacterAttributes struct {
}

// GetID returns the primary key of the database.Persistable.
func (c Character) GetID() int64 {
	return c.ID
}

// ExtractFields returns character attributes in order specified by the columns
// argument.
func (c Character) ExtractFields(columns []string) ([]interface{}, error) {
	fields := make([]interface{}, len(columns))
	for i, column := range columns {
		switch column {
		case "id":
			fields[i] = c.ID
		case "user_id":
			fields[i] = c.UserID
		case "name":
			fields[i] = c.Name
		case "level":
			fields[i] = c.Level
		case "config":
			config, err := json.Marshal(c.CharacterAttributes)
			if err != nil {
				return fields, fmt.Errorf("failed to serialize %q: %w", column, err)
			}

			fields[i] = config
		default:
			return fields, fmt.Errorf("%w: %q", database.ErrUnknownColumn, column)
		}
	}

	return fields, nil
}

// UpdateFromScanner updates the character object with values contained in the
// database.Scanner.
func (c *Character) UpdateFromScanner(row database.Scanner, columns []string) error {
	fields := make([]interface{}, len(columns))
	for i, column := range columns {
		switch column {
		case "id":
			fields[i] = &c.ID
		case "user_id":
			fields[i] = &c.UserID
		case "name":
			fields[i] = &c.Name
		case "level":
			fields[i] = &c.Level
		case "config":
			config := []byte{}
			fields[i] = &config
		default:
			return fmt.Errorf("%w: %q", database.ErrUnknownColumn, column)
		}
	}

	if err := row.Scan(fields...); err != nil {
		return fmt.Errorf("failed to scan fields for %q: %w", columns, err)
	}

	for i, column := range columns {
		switch column {
		case "config":
			config := *fields[i].(*[]byte)
			if len(config) < 2 {
				continue
			}
			if err := json.Unmarshal(config, &c.CharacterAttributes); err != nil {
				return fmt.Errorf("failed to unmarshal %q: %w", column, err)
			}
		}
	}

	return nil
}

// CharacterDB is a database Operator to store / retrieve character models.
var CharacterDB = database.Operator{
	Table: "character",
	NewPersistable: func() database.Persistable {
		return &Character{}
	},
}

// CharacterFromReader returns a character model created from a json stream.
func CharacterFromReader(r io.Reader) (database.Persistable, error) {
	c := Character{}
	err := c.UnmarshalFromReader(r)
	return &c, err
}

// UnmarshalFromReader updates a character object from a JSON stream.
func (c *Character) UnmarshalFromReader(r io.Reader) error {
	return json.NewDecoder(r).Decode(c)
}

// MarshalToWriter writes a character object as a JSON stream.
func (c *Character) MarshalToWriter(w io.Writer) error {
	return json.NewEncoder(w).Encode(c)
}
