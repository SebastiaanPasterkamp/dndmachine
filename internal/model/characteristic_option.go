package model

import (
	"encoding/json"
	"fmt"
	"io"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
)

// UUID is a string-type representing a unique 32-byte ID.
type UUID string

// CharacteristicOption represents choices for a character concerning their
// (sub)race, (sub)classes, and backgrounds. Each characteristic can have
// prerequisites a character should meet before the characteristic can be
// chosen. Once chosen a CharacteristicOption is applied to the character
// immediately. Additional phases can be added for when a character levels up.
// How a characteristic is applied to a character depends on its type.
type CharacteristicOption struct {
	// ID is the primary key of the database entry.
	ID int64 `json:"id"`
	// UUID is a unique ID for the available characteristic. The history of
	// choices is recorded in a character using this ID.
	UUID `json:"uuid"`
	// Name is a short caption explaining the characteristic option.
	Name string `json:"name,omitempty"`
	// Type is the type of characteristic option affecting how the character
	// attribute is modified.
	Type CharacteristicOptionType `json:"type"`
	// Config is the type-specific configuration of a characteristic.
	Config *json.RawMessage `json:"config"`
}

// CharacteristicOptionType is a string to enumerate the types of
// CharacteristicOption objects that exist.
type CharacteristicOptionType string

const (
	// ChoiceType is a CharacteristicOptionType where one only one
	// characteristic can be chosen.
	ChoiceType CharacteristicOptionType = "choice"
	// ConfigType is a CharacteristicOptionType offering a list of
	// CharacteristicOptions.
	ConfigType CharacteristicOptionType = "config"
	// ListType is a CharacteristicOptionType where one or more items from a
	// list can be chosen.
	ListType CharacteristicOptionType = "list"
	// MultipleChoiceType is a CharacteristicOptionType where one or more
	// characteristics can be chosen.
	MultipleChoiceType CharacteristicOptionType = "multiplechoice"
	// ValueType is a CharacteristicOptionType where a property is set to a
	//specific value.
	ValueType CharacteristicOptionType = "value"
)

// CharacteristicOptionAttributes are a collection of non-primary fields stored
// in the config column of the item table.
type CharacteristicOptionAttributes struct {
	// Description is a flavor text explanation of the characteristic option.
	Description string `json:"description,omitempty"`
	// Conditions is an optional list of prerequisites required for the
	// characteristic option to be available.
	Conditions []Condition `json:"conditions,omitempty"`
}

// ChoiceCharacteristicOption is a characteristic type where one only one
// characteristic can be chosen.
type ChoiceCharacteristicOption struct {
	CharacteristicOptionAttributes
	// Options is a list of Characteristic IDs that can be chosen.
	Options []UUID `json:"options,omitempty"`
	// Include extends the list of Options with a recurring set of choice
	// characteristics, like feats or fighting styles.
	Include UUID `json:"include,omitempty"`
	// Filter limits the list of options included.
	Filters []Filter `json:"filter,omitempty"`
}

// ConfigCharacteristicOption is a characteristic type offering a list of
// Characteristics.
type ConfigCharacteristicOption struct {
	CharacteristicOptionAttributes
	// Config is a list of Characteristics provided by the config.
	Config []UUID `json:"config"`
}

// ListCharacteristicOption is a characteristic type where one or more items
// from a list can be chosen.
type ListCharacteristicOption struct {
	CharacteristicOptionAttributes
	// Path is the period + capitalization separated character attribute
	// reference.
	Path string `json:"path"`
	// Hidden indicates if the chosen characteristic is displayed in the UI.
	Hidden bool `json:"hidden,omitempty"`
	// Multiple indicates if the items in the path are expected to be unique.
	Multiple bool `json:"multiple,omitempty"`
	// Given is a list of values typed to be path specific.
	Given *json.RawMessage `json:"given,omitempty"`
}

// MultipleChoiceCharacteristicOption is a characteristic type where one or more
// characteristics can be chosen.
type MultipleChoiceCharacteristicOption struct {
	CharacteristicOptionAttributes
	// Options is a list of Characteristic options that can be chosen.
	Options []UUID `json:"options,omitempty"`
	// Include extends the list of Options with a recurring set of choice
	// characteristics, like feats or fighting styles.
	Include UUID `json:"include,omitempty"`
	// Filter limits the list of options included.
	Filters []Filter `json:"filter,omitempty"`
	// Add defines how many more items may be added to the existing list.
	Add int `json:"add,omitempty"`
	// Limit defines how many items in total may exist in the target list.
	Limit int `json:"limit,omitempty"`
	// Replace defines how many existing items in a list may be removed to be
	// replaced with new items.
	Replace int `json:"replace,omitempty"`
}

// ValueCharacteristicOption is a characteristic type where a property is set to
// a specific value.
type ValueCharacteristicOption struct {
	CharacteristicOptionAttributes
	// Path is the period + capitalization separated character attribute
	// reference.
	Path string `json:"path"`
	// Hidden indicates if the chosen characteristic is displayed in the UI.
	Hidden bool `json:"hidden,omitempty"`
	// Value is to be assigned to the attribute typed to be path specific.
	Value *json.RawMessage `json:"value"`
}

// ConditionType is a string to enumerate the types of condition evaluation
// methods that exist.
type ConditionType string

const (
	// EQ is a condition type where the value must be exactly equal to the
	// target.
	EQ ConditionType = "eq"
	// GTE is a condition type where the value must be equal or greater than the
	// target value.
	GTE ConditionType = "gte"
	// OR is a condition type where at least one of the conditions should
	// evaluate to true.
	OR ConditionType = "or"
	// LTE is a condition type where the value must be equal or less than the
	// target value.
	LTE ConditionType = "lte"
)

// Condition defines a character property that should evaluate to true for the
// condition to be met.
type Condition struct {
	// Path is the period + capitalization separated character attribute
	// reference the condition is referring to.
	Path string `json:"path"`
	// Type defines how the condition is evaluated.
	Type ConditionType `json:"type"`
	// Value is the target the path is compared to.
	Value int `json:"value"`
}

// FilterType is a string to enumerate the types of filtering methods that exist.
type FilterType string

const (
	// AttributeFilter is a filter method where the value of an attribute of a
	// list item must be present in the list
	AttributeFilter FilterType = "attribute"
	// OrFilter is a filter method where a list item must pass one or more of
	// the filters in a list.
	OrFilter FilterType = "or"
	// ProficienciesFilter is a filter method where a list item must pass one or more of
	// the filters in a list.
	ProficienciesFilter FilterType = "proficiencies"
)

// Filter is a configuration to filter options from a list. The filter type
// defines how the filter is applied.
type Filter struct {
	// Type describes how the filter is applied.
	Type FilterType `json:"type"`
}

// GetID returns the primary key of the database.Persistable.
func (c CharacteristicOption) GetID() int64 {
	return c.ID
}

// ExtractFields returns characteristic option attributes in order specified by
// the columns argument.
func (c CharacteristicOption) ExtractFields(columns []string) ([]interface{}, error) {
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
func (c *CharacteristicOption) UpdateFromScanner(row database.Scanner, columns []string) error {
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

// CharacteristicOptionDB is a database Operator to store / retrieve
// characteristic option models.
var CharacteristicOptionDB = database.Operator{
	Table: "characteristic_option",
	NewPersistable: func() database.Persistable {
		return &CharacteristicOption{}
	},
}

// CharacteristicOptionFromReader returns a CharacteristicOption model created
// from a json stream.
func CharacteristicOptionFromReader(r io.Reader) (database.Persistable, error) {
	c := CharacteristicOption{}
	err := c.UnmarshalFromReader(r)
	return &c, err
}

// UnmarshalFromReader updates an equipment item object from a JSON stream.
func (c *CharacteristicOption) UnmarshalFromReader(r io.Reader) error {
	return json.NewDecoder(r).Decode(c)
}

// MarshalToWriter writes an equipment item object as a JSON stream.
func (c *CharacteristicOption) MarshalToWriter(w io.Writer) error {
	return json.NewEncoder(w).Encode(c)
}
