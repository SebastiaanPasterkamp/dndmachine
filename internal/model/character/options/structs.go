package options

import (
	"encoding/json"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/model/character"
)

// emptyChoice is the default json formatted empty object
var emptyChoice json.RawMessage = []byte(`{}`)

// OptionType is a string to enumerate the types of Option objects that exist.
type OptionType string

const (
	// DescriptionType is a OptionType to configure the base character
	// description.
	DescriptionType OptionType = "character-description"
)

// Object represents choices for a character concerning their
// (sub)race, (sub)classes, and backgrounds. Each characteristic can have
// prerequisites a character should meet before the characteristic can be
// chosen. Once chosen a Option is applied to the character
// immediately. Additional phases can be added for when a character levels up.
// How a characteristic is applied to a character depends on its type.
type Object struct {
	// ID is the primary key of the database entry.
	ID int64 `json:"id"`
	// UUID is a unique ID for the available characteristic. The history of
	// choices is recorded in a character using this ID.
	UUID character.UUID `json:"uuid"`
	// Name is a short caption explaining the characteristic option.
	Name string `json:"name,omitempty"`
	// Type is the type of characteristic option affecting how the character
	// attribute is modified.
	Type OptionType `json:"type"`
	// Config is the type-specific configuration of a characteristic.
	Config *json.RawMessage `json:"config"`
}
