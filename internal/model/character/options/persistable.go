package options

import (
	"encoding/json"
	"fmt"
	"io"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/model"
)

// ExtractFields returns characteristic option attributes in order specified by
// the columns argument.
func (o Object) ExtractFields(columns []string) ([]interface{}, error) {
	fields := make([]interface{}, len(columns))
	for i, column := range columns {
		switch column {
		case "id":
			fields[i] = o.ID
		case "uuid":
			fields[i] = o.UUID
		case "name":
			fields[i] = o.Name
		case "type":
			fields[i] = o.Type
		case "config":
			fields[i] = []byte("")
			if o.Config != nil {
				fields[i] = []byte(*o.Config)
			}
		default:
			return nil, fmt.Errorf("%w: %q", model.ErrUnknownColumn, column)
		}
	}

	return fields, nil
}

// UpdateFromScanner updates the characteristic option object with values
// contained in the sql Row Scanner.
func (o *Object) UpdateFromScanner(row model.Scanner, columns []string) error {
	fields := make([]interface{}, len(columns))
	for i, column := range columns {
		switch column {
		case "id":
			fields[i] = &o.ID
		case "uuid":
			fields[i] = &o.UUID
		case "name":
			fields[i] = &o.Name
		case "type":
			fields[i] = &o.Type
		case "config":
			config := []byte("")
			fields[i] = &config
		default:
			return fmt.Errorf("%w: %q", model.ErrUnknownColumn, column)
		}
	}

	if err := row.Scan(fields...); err != nil {
		return fmt.Errorf("%w for %q: %w", model.ErrInvalidRecord, columns, err)
	}

	for i, column := range columns {
		switch column {
		case "config":
			config := fields[i].(*[]byte)
			if len(*config) < 2 {
				continue
			}
			o.Config = (*json.RawMessage)(config)
		}
	}

	return nil
}

// GetID returns the primary key of the Persistable.
func (i Object) GetID() int64 {
	return i.ID
}

// Creator implements the database.PersistableCreator function type to
// create persistable objects. It returns a new options.Instance.
func Creator() *Object {
	return &Object{}
}

// Reader returns a options.Instance created from a json stream.
func Reader(r io.Reader) (*Object, error) {
	i := Object{}
	err := i.UnmarshalFromReader(r)
	return &i, err
}

// UnmarshalFromReader updates a character options.Instance from a JSON stream.
func (i *Object) UnmarshalFromReader(r io.Reader) error {
	return json.NewDecoder(r).Decode(i)
}
