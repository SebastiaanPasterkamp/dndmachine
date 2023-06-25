package character

import (
	"encoding/json"
	"fmt"
	"io"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/model"
)

// ExtractFields returns character attributes in order specified by the columns
// argument.
func (o Object) ExtractFields(columns []string) ([]interface{}, error) {
	fields := make([]interface{}, len(columns))
	for i, column := range columns {
		switch column {
		case "id":
			fields[i] = o.ID
		case "user_id":
			fields[i] = o.UserID
		case "name":
			fields[i] = o.Name
		case "level":
			fields[i] = o.Level
		case "config":
			config, err := json.Marshal(o.Attributes)
			if err != nil {
				return fields, fmt.Errorf("failed to serialize %q: %w", column, err)
			}

			fields[i] = config
		default:
			return fields, fmt.Errorf("%w: %q", model.ErrUnknownColumn, column)
		}
	}

	return fields, nil
}

// UpdateFromScanner updates the character object with values contained in the
// sql Row Scanner.
func (o *Object) UpdateFromScanner(row model.Scanner, columns []string) error {
	fields := make([]interface{}, len(columns))
	for i, column := range columns {
		switch column {
		case "id":
			fields[i] = &o.ID
		case "user_id":
			fields[i] = &o.UserID
		case "name":
			fields[i] = &o.Name
		case "level":
			fields[i] = &o.Level
		case "config":
			config := []byte{}
			fields[i] = &config
		default:
			return fmt.Errorf("%w: %q", model.ErrUnknownColumn, column)
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
			if err := json.Unmarshal(config, &o.Attributes); err != nil {
				return fmt.Errorf("failed to unmarshal %q: %w", column, err)
			}
		}
	}

	return nil
}

// GetID returns the primary key of the database.Persistable.
func (c Object) GetID() int64 {
	return c.ID
}

// UnmarshalFromReader updates a character object from a JSON stream.
func (c *Object) UnmarshalFromReader(r io.Reader) error {
	return json.NewDecoder(r).Decode(c)
}
