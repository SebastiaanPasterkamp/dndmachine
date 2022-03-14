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
	CharacterProgress
	ID     int64  `json:"id"`
	UserID int64  `json:"userID"`
	Name   string `json:"name"`
	Level  int    `json:"level"`
}

// CharacterProgress is a collection of fields not under the player's
// control defining the various leveling systems available.
type CharacterProgress struct {
	AdventureCheckpoints        float32            `json:"adventure_checkpoints,omitempty"`
	AdventureCheckpointsAtLevel float32            `json:"adventure_checkpoints_at_level,omitempty"`
	AdventureCheckpointsToLevel float32            `json:"adventure_checkpoints_to_level,omitempty"`
	Downtime                    float32            `json:"downtime,omitempty"`
	Experience                  int                `json:"xp,omitempty"`
	ExperienceAtLevel           int                `json:"xp_at_level"`
	ExperienceToLevel           int                `json:"xp_to_level"`
	Renown                      float32            `json:"renown,omitempty"`
	TreasureCheckpoints         map[string]float32 `json:"treasure_checkpoints,omitempty"`
}

// CharacterAttributes are a collection of non-primary fields stored in the
// config column of the character table.
type CharacterAttributes struct {
	Abilities           map[string]CharacterAbilities `json:"abilities"`
	AdventureLeague     bool                          `json:"adventure_league,omitempty"`
	Alignment           string                        `json:"alignment"`
	Appearance          string                        `json:"appearance,omitempty"`
	Armors              []interface{}                 `json:"armors"` // TODO: Create armor model
	ArmorBonus          int                           `json:"armor_bonus,omitempty"`
	ArmorClass          int                           `json:"armor_class"`
	ArmorClassUnarmored int                           `json:"armor_class_unarmored"`
	Background          string                        `json:"background"`
	Challenge           map[string]int                `json:"challenge"`
	Classes             map[string]interface{}        `json:"classes"` // TODO: Create character class model
	Equipment           []Equipment                   `json:"equipment"`
	Gender              string                        `json:"gender"`
	HitPoints           int                           `json:"hit_points"`
	Info                map[string]string             `json:"info"`
	Languages           []string                      `json:"languages"`
	PassiveAbilities    map[string]int                `json:"passive_abilities"`
	Personality         map[string]string             `json:"personality"`
	Proficiencies       CharacterProficiencies        `json:"proficiencies"`
	ProficiencyBonus    int                           `json:"proficiency_bonus"`
	Race                string                        `json:"race"`
	SavingThrows        map[string]int                `json:"saving_throws"`
	Size                string                        `json:"size"`
	Skills              map[string]int                `json:"skills"`
	Speeds              map[string]int                `json:"speeds"`
	Statistics          map[string]interface{}        `json:"statistics"` // TODO: Make statistics model
	Wealth              map[string]int                `json:"wealth,omitempty"`
	Weapons             []Equipment                   `json:"weapons"`
}

// CharacterAbilities is a struct with a description template string plus zero
// or more values that can be inserted into the template. Some values are static
// while others are computed as a formula (..._formula), and typically come with
// a default fallback value (..._default).
type CharacterAbilities struct {
	Description string            `json:"description"`
	Fields      map[string]string `json:",inline,omitempty"`
}

// CharacterProficiencies is a structure listing all character proficiencies
// available.
type CharacterProficiencies struct {
	Advantage   []string `json:"advantage,omitempty"`
	Armor       []string `json:"armor,omitempty"`
	Expertise   []string `json:"expertise,omitempty"`
	Musical     []string `json:"musical,omitempty"`
	SavingThrow []string `json:"saving_throw,omitempty"`
	Skill       []string `json:"skill,omitempty"`
	Talent      []string `json:"talent,omitempty"`
	Tool        []string `json:"tool,omitempty"`
	Weapon      []string `json:"weapon,omitempty"`
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
		case "progress":
			config, err := json.Marshal(c.CharacterProgress)
			if err != nil {
				return fields, fmt.Errorf("failed to serialize %q: %w", column, err)
			}

			fields[i] = config
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
			if err := json.Unmarshal(config, &c.CharacterProgress); err != nil {
				return fmt.Errorf("failed to unmarshal %q: %w", column, err)
			}
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

// Migrate adjusts an Character object to migrate fields from the
// CharacterAttributes and CharacterProgress structs to the main Character
// struct, and visa versa.
func (c *Character) Migrate(row database.Scanner, columns []string) error {
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
		return fmt.Errorf("failed to migrate fields for %q: %w", columns, err)
	}

	for i, column := range columns {
		switch column {
		case "progress":
			config := *fields[i].(*[]byte)
			if len(config) < 2 {
				continue
			}
			if err := json.Unmarshal(config, &c.CharacterProgress); err != nil {
				return fmt.Errorf("failed to unmarshal %q for attributes: %w: %q", column, err, string(config))
			}
			if err := json.Unmarshal(config, &c.CharacterAttributes); err != nil {
				return fmt.Errorf("failed to unmarshal %q for progress: %w", column, err)
			}
			if err := json.Unmarshal(config, &c); err != nil {
				return fmt.Errorf("failed to unmarshal %q for object: %w", column, err)
			}
		case "config":
			config := *fields[i].(*[]byte)
			if len(config) < 2 {
				continue
			}
			if err := json.Unmarshal(config, &c.CharacterAttributes); err != nil {
				return fmt.Errorf("failed to unmarshal %q for attributes: %w: %q", column, err, string(config))
			}
			if err := json.Unmarshal(config, &c.CharacterProgress); err != nil {
				return fmt.Errorf("failed to unmarshal %q for progress: %w", column, err)
			}
			if err := json.Unmarshal(config, &c); err != nil {
				return fmt.Errorf("failed to unmarshal %q for object: %w", column, err)
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
