package options

import (
	"encoding/json"
	"fmt"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/model/character"
)

type ClassOption struct {
	ID   string `json:"id"`
	Name string `json:"name"`
}

type ClassChoices struct {
}

func (o ClassOption) Apply(c *character.Object, cfg json.RawMessage) (*[]character.UUID, error) {
	var choice ClassChoices

	err := json.Unmarshal(cfg, &choice)
	if err != nil {
		return nil, fmt.Errorf("%w %q: %w",
			ErrMalformedChoice, ClassType, err)
	}

	if c.Classes == nil {
		c.Classes = map[string]character.Class{}
	}

	c.Classes[o.ID] = character.Class{
		ID:    o.ID,
		Level: 1,
		Name:  o.Name,
	}

	return nil, err
}
