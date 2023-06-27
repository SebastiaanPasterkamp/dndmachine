package options

import (
	"encoding/json"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/model/character"
)

type Applicator interface {
	Apply(c *character.Object, cfg json.RawMessage) (*[]character.UUID, error)
}

// OptionsProvider is a function that returns character.options Objects based on
// the uuid.
type OptionsProvider func(character.UUID) (*Object, error)
