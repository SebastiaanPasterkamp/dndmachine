package model

import (
	"encoding/json"
	"fmt"
	"io"
)

// Equipment is the database.Persistable and api.JSONable implementation of a
// equipment item model.
type Equipment struct {
	EquipmentAttributes
	ID   int64  `json:"id"`
	Type string `json:"type"`
	Name string `json:"name"`
}

// EquipmentAttributes are a collection of non-primary fields stored in the
// config column of the item table.
type EquipmentAttributes struct {
	Description string         `json:"description,omitempty"`
	Value       Value          `json:"value,omitempty"`
	Cost        Value          `json:"cost,omitempty"`
	Weight      Weight         `json:"weight,omitempty"`
	Property    []string       `json:"property,omitempty"`
	Armor       Armor          `json:"armor,omitempty"`
	Requirement map[string]int `json:"requirement,omitempty"`
	Damage      Damage         `json:"damage,omitempty"`
	Versatile   Damage         `json:"versatile,omitempty"`
	Range       Range          `json:"range,omitempty"`
	Group       string         `json:"group,omitempty"`
}

// Value describes various currency notations
type Value struct {
	Platinum int `json:"pp,omitempty"`
	Gold     int `json:"gp,omitempty"`
	Electrum int `json:"ep,omitempty"`
	Silver   int `json:"sp,omitempty"`
	Copper   int `json:"cp,omitempty"`
}

// Weight describes various weight notations
type Weight struct {
	Pound float32 `json:"lb,omitempty"`
	Ounce float32 `json:"oz,omitempty"`
}

// Damage denotes the dice size, bonus, and type of damage
type Damage struct {
	DiceCount int    `json:"dice_count,omitempty"`
	DiceSize  int    `json:"dice_size,omitempty"`
	Bonus     int    `json:"bonus,omitempty"`
	Type      string `json:"type"`
}

// Range describes the distance for ranged weapons
type Range struct {
	Min int `json:"min,omitempty"`
	Max int `json:"max,omitempty"`
}

// Armor denotes the value, formula, or bonus attribute of armor equipment.
type Armor struct {
	Formula      string `json:"formula,omitempty"`
	Value        int    `json:"value,omitempty"`
	Bonus        int    `json:"bonus,omitempty"`
	Disadvantage bool   `json:"disadvantage,omitempty"`
}

// GetID returns the primary key of the database.Persistable.
func (e Equipment) GetID() int64 {
	return e.ID
}

// ExtractFields returns equipment attributes in order specified by the columns
// argument.
func (e Equipment) ExtractFields(columns []string) ([]interface{}, error) {
	fields := make([]interface{}, len(columns))
	for i, column := range columns {
		switch column {
		case "id":
			fields[i] = e.ID
		case "type":
			fields[i] = e.Type
		case "name":
			fields[i] = e.Name
		case "config":
			config, err := json.Marshal(e.EquipmentAttributes)
			if err != nil {
				return fields, fmt.Errorf("failed to serialize %q: %w", column, err)
			}

			fields[i] = config
		default:
			return fields, fmt.Errorf("%w: %q", ErrUnknownColumn, column)
		}
	}

	return fields, nil
}

// UpdateFromScanner updates the equipment object with values contained in the
// database.Scanner.
func (e *Equipment) UpdateFromScanner(row Scanner, columns []string) error {
	fields := make([]interface{}, len(columns))
	for i, column := range columns {
		switch column {
		case "id":
			fields[i] = &e.ID
		case "type":
			fields[i] = &e.Type
		case "name":
			fields[i] = &e.Name
		case "config":
			config := []byte{}
			fields[i] = &config
		default:
			return fmt.Errorf("%w: %q", ErrUnknownColumn, column)
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
			if err := json.Unmarshal(config, &e.EquipmentAttributes); err != nil {
				return fmt.Errorf("failed to unmarshal %q: %w", column, err)
			}
		}
	}

	return nil
}

// Migrate adjusts an Equipment object to migrate fields from the UserAttributes
// struct to the main User struct.
func (e *Equipment) Migrate(row Scanner, columns []string) error {
	fields := make([]interface{}, len(columns))
	for i, column := range columns {
		switch column {
		case "id":
			fields[i] = &e.ID
		case "type":
			fields[i] = &e.Type
		case "name":
			fields[i] = &e.Name
		case "config":
			config := []byte{}
			fields[i] = &config
		default:
			return fmt.Errorf("%w: %q", ErrUnknownColumn, column)
		}
	}

	if err := row.Scan(fields...); err != nil {
		return fmt.Errorf("failed to migrate fields for %q: %w", columns, err)
	}

	for i, column := range columns {
		switch column {
		case "config":
			config := *fields[i].(*[]byte)
			if len(config) < 2 {
				continue
			}
			if err := json.Unmarshal(config, &e.EquipmentAttributes); err != nil {
				return fmt.Errorf("failed to unmarshal %q for attributes: %w: %q", column, err, string(config))
			}
			if err := json.Unmarshal(config, &e.EquipmentAttributes.Weight); err != nil {
				return fmt.Errorf("failed to unmarshal %q for weight: %w", column, err)
			}
			if err := json.Unmarshal(config, &e.EquipmentAttributes.Value); err != nil {
				return fmt.Errorf("failed to unmarshal %q for value: %w", column, err)
			}
			if err := json.Unmarshal(config, &e); err != nil {
				return fmt.Errorf("failed to unmarshal %q for object: %w", column, err)
			}
		}
	}

	return nil
}

// UnmarshalFromReader updates an equipment item object from a JSON stream.
func (e *Equipment) UnmarshalFromReader(r io.Reader) error {
	return json.NewDecoder(r).Decode(e)
}
