package options

import (
	"encoding/json"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/model/character"
)

type Applicator interface {
	Apply(c *character.Object, cfg json.RawMessage) error
}
