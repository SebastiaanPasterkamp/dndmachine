package character

import (
	"encoding/json"
	"fmt"
	"io"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
)

// GetID returns the primary key of the database.Persistable.
func (c Object) GetID() int64 {
	return c.ID
}

// ExtractFields returns character attributes in order specified by the columns
// argument.
func (c Object) ExtractFields(columns []string) ([]interface{}, error) {
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
		case "progress":
			config, err := json.Marshal(c.Progress)
			if err != nil {
				return fields, fmt.Errorf("failed to serialize %q: %w", column, err)
			}

			fields[i] = config
		case "config":
			config, err := json.Marshal(c.Attributes)
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
func (c *Object) UpdateFromScanner(row database.Scanner, columns []string) error {
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
		case "progress":
			progress := []byte{}
			fields[i] = &progress
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
		case "progress":
			config := *fields[i].(*[]byte)
			if len(config) < 2 {
				continue
			}
			if err := json.Unmarshal(config, &c.Progress); err != nil {
				return fmt.Errorf("failed to unmarshal %q: %w", column, err)
			}
		case "config":
			config := *fields[i].(*[]byte)
			if len(config) < 2 {
				continue
			}
			if err := json.Unmarshal(config, &c.Attributes); err != nil {
				return fmt.Errorf("failed to unmarshal %q: %w", column, err)
			}
		}
	}

	return nil
}

// DB is a database Operator to store / retrieve character objects.
var DB = database.Operator{
	Table: "character",
	NewPersistable: func() database.Persistable {
		return &Object{}
	},
}

// FromReader returns a character object created from a json stream.
func FromReader(r io.Reader) (database.Persistable, error) {
	c := Object{}
	err := c.UnmarshalFromReader(r)
	return &c, err
}

// UnmarshalFromReader updates a character object from a JSON stream.
func (c *Object) UnmarshalFromReader(r io.Reader) error {
	return json.NewDecoder(r).Decode(c)
}

// MarshalToWriter writes a character object as a JSON stream.
func (c *Object) MarshalToWriter(w io.Writer) error {
	return json.NewEncoder(w).Encode(c)
}
