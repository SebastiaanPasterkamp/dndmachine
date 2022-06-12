package model

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"io"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
)

// Characteristic contains the racial, class, and background attributes of a
// Player Character.
type Characteristic struct {
	CharacteristicAttributes
	// ID is the primary key of the database entry.
	ID int64 `json:"id"`
	// Sub is the foreign key referencing the parent Characteristic.
	Sub JSONInt64 `json:"sub,omitempty"`
	// Name is a short caption explaining the characteristic option.
	Name string `json:"name"`
	// Phases is a list of Characteristic Option UUIDs to configure for a
	// character. Multiple configurations can defined and filtered by character
	// or class level, attribute requirements (multi-classing), or other
	// filters.
	Phases []UUID `json:"phases"`
}

// CharacteristicAttributes are a collection of non-primary fields stored in the
// config column of the item table.
type CharacteristicAttributes struct {
	// Description is a flavor text explanation of the Characteristic option.
	Description string `json:"description,omitempty"`
}

// GetID returns the primary key of the database.Persistable.
func (c Characteristic) GetID() int64 {
	return c.ID
}

// ExtractFields returns characteristics attributes in order specified by the
// columns argument.
func (c Characteristic) ExtractFields(columns []string) ([]interface{}, error) {
	fields := make([]interface{}, len(columns))
	for i, column := range columns {
		switch column {
		case "id":
			fields[i] = c.ID
		case "sub":
			if c.Sub > 0 {
				fields[i] = c.Sub
			} else {
				fields[i] = sql.NullInt64{}
			}
		case "name":
			fields[i] = c.Name
		case "config":
			config, err := json.Marshal(c.CharacteristicAttributes)
			if err != nil {
				return fields, fmt.Errorf("failed to serialize %q: %w", column, err)
			}

			fields[i] = config
		case "phases":
			config, err := json.Marshal(c.Phases)
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

// UpdateFromScanner updates the characteristic object with values contained in
// the database.Scanner.
func (c *Characteristic) UpdateFromScanner(row database.Scanner, columns []string) error {
	fields := make([]interface{}, len(columns))
	for i, column := range columns {
		switch column {
		case "id":
			fields[i] = &c.ID
		case "sub":
			var value sql.NullInt64
			fields[i] = &value
		case "name":
			fields[i] = &c.Name
		case "config":
			config := []byte{}
			fields[i] = &config
		case "phases":
			phases := []byte{}
			fields[i] = &phases
		default:
			return fmt.Errorf("%w: %q", database.ErrUnknownColumn, column)
		}
	}

	if err := row.Scan(fields...); err != nil {
		return fmt.Errorf("failed to scan fields for %q: %w", columns, err)
	}

	for i, column := range columns {
		switch column {
		case "sub":
			value := fields[i].(*sql.NullInt64)
			if value.Valid {
				c.Sub = JSONInt64(value.Int64)
			} else {
				c.Sub = 0
			}
		case "config":
			config := *fields[i].(*[]byte)
			if len(config) < 2 {
				continue
			}
			if err := json.Unmarshal(config, &c.CharacteristicAttributes); err != nil {
				return fmt.Errorf("failed to unmarshal %q: %w", column, err)
			}
		case "phases":
			config := *fields[i].(*[]byte)
			if len(config) < 2 {
				continue
			}
			if err := json.Unmarshal(config, &c.Phases); err != nil {
				return fmt.Errorf("failed to unmarshal %q: %w", column, err)
			}
		}
	}

	return nil
}

// RaceDB is a database Operator to store / retrieve characteristic models.
var RaceDB = database.Operator{
	Table: "race",
	NewPersistable: func() database.Persistable {
		return &Characteristic{}
	},
}

// ClassDB is a database Operator to store / retrieve characteristic models.
var ClassDB = database.Operator{
	Table: "class",
	NewPersistable: func() database.Persistable {
		return &Characteristic{}
	},
}

// BackgroundDB is a database Operator to store / retrieve characteristic models.
var BackgroundDB = database.Operator{
	Table: "background",
	NewPersistable: func() database.Persistable {
		return &Characteristic{}
	},
}

// CharacteristicFromReader returns a characteristic model created from a json
// stream.
func CharacteristicFromReader(r io.Reader) (database.Persistable, error) {
	c := Characteristic{}
	err := c.UnmarshalFromReader(r)
	return &c, err
}

// UnmarshalFromReader updates an equipment item object from a JSON stream.
func (c *Characteristic) UnmarshalFromReader(r io.Reader) error {
	return json.NewDecoder(r).Decode(c)
}

// MarshalToWriter writes an equipment item object as a JSON stream.
func (c *Characteristic) MarshalToWriter(w io.Writer) error {
	return json.NewEncoder(w).Encode(c)
}
