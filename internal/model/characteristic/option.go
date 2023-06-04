package characteristic

import (
	"encoding/json"
	"fmt"
	"io"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/model/character"
)

// UUID is a string-type representing a unique 32-byte ID.
type UUID string

// Option represents choices for a character concerning their
// (sub)race, (sub)classes, and backgrounds. Each characteristic can have
// prerequisites a character should meet before the characteristic can be
// chosen. Once chosen a Option is applied to the character
// immediately. Additional phases can be added for when a character levels up.
// How a characteristic is applied to a character depends on its type.
type Option struct {
	// ID is the primary key of the database entry.
	ID int64 `json:"id"`
	// UUID is a unique ID for the available characteristic. The history of
	// choices is recorded in a character using this ID.
	UUID `json:"uuid"`
	// Name is a short caption explaining the characteristic option.
	Name string `json:"name,omitempty"`
	// Type is the type of characteristic option affecting how the character
	// attribute is modified.
	Type OptionType `json:"type"`
	// Config is the type-specific configuration of a characteristic.
	Config *json.RawMessage `json:"config"`
}

// OptionType is a string to enumerate the types of
// Option objects that exist.
type OptionType string

const (
	// AbilityScoreType is a OptionType where an ability score is
	// chosen, bonuses are added, or score increases are chosen.
	AbilityScoreType OptionType = "ability-score"
	// ChoiceType is a OptionType where one only one
	// characteristic can be chosen.
	ChoiceType OptionType = "choice"
	// ConfigType is a OptionType offering a list of
	// Options.
	ConfigType OptionType = "config"
	// ListType is a OptionType where one or more items from a
	// list can be chosen.
	ListType OptionType = "list"
	// MultipleChoiceType is a OptionType where one or more
	// characteristics can be chosen.
	MultipleChoiceType OptionType = "multiple-choice"
	// ValueType is a OptionType where a property is set to a
	//specific value.
	ValueType OptionType = "value"
)

// OptionAttributes are a collection of non-primary fields stored
// in the config column of the item table.
type OptionAttributes struct {
	// Description is a flavor text explanation of the characteristic option.
	Description string `json:"description,omitempty"`
	// Conditions is an optional list of prerequisites required for the
	// characteristic option to be available.
	Conditions []Condition `json:"conditions,omitempty"`
}

// GetID returns the primary key of the database.Persistable.
func (c Option) GetID() int64 {
	return c.ID
}

// ExtractFields returns characteristic option attributes in order specified by
// the columns argument.
func (c Option) ExtractFields(columns []string) ([]interface{}, error) {
	fields := make([]interface{}, len(columns))
	for i, column := range columns {
		switch column {
		case "id":
			fields[i] = c.ID
		case "uuid":
			fields[i] = c.UUID
		case "name":
			fields[i] = c.Name
		case "type":
			fields[i] = c.Type
		case "config":
			config, err := json.Marshal(c.Config)
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

// UpdateFromScanner updates the characteristic option object with values
// contained in the database.Scanner.
func (c *Option) UpdateFromScanner(row database.Scanner, columns []string) error {
	fields := make([]interface{}, len(columns))
	for i, column := range columns {
		switch column {
		case "id":
			fields[i] = &c.ID
		case "uuid":
			fields[i] = &c.UUID
		case "name":
			fields[i] = &c.Name
		case "type":
			fields[i] = &c.Type
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
			if err := json.Unmarshal(config, &c.Config); err != nil {
				return fmt.Errorf("failed to unmarshal %q: %w", column, err)
			}
		}
	}

	return nil
}

// OptionDB is a database Operator to store / retrieve
// characteristic option models.
var OptionDB = database.Operator{
	Table: "characteristic_option",
	NewPersistable: func() database.Persistable {
		return &Option{}
	},
}

// OptionFromReader returns a Option model created
// from a json stream.
func OptionFromReader(r io.Reader) (database.Persistable, error) {
	c := Option{}
	err := c.UnmarshalFromReader(r)
	return &c, err
}

// UnmarshalFromReader updates an equipment item object from a JSON stream.
func (c *Option) UnmarshalFromReader(r io.Reader) error {
	return json.NewDecoder(r).Decode(c)
}

// MarshalToWriter writes an equipment item object as a JSON stream.
func (c *Option) MarshalToWriter(w io.Writer) error {
	return json.NewEncoder(w).Encode(c)
}

func (o *Option) Apply(c *character.Object) error {
	var (
		err    error
		option Applicable
	)
	switch o.Type {
	case ValueType:
		option = &ValueOption{Option: *o}
		err = json.Unmarshal(*o.Config, option)
	default:
		return fmt.Errorf("%w: applying %q",
			ErrNotYetImplemented, o.Type)
	}

	if err != nil {
		return fmt.Errorf("%w: unmarshalling %q: %w",
			ErrFailedToApply, o.Type, err)
	}

	return option.Apply(c)
}
