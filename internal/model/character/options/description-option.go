package options

import (
	"encoding/json"
	"fmt"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/model/character"
)

type DescriptionOption struct {
}

type DescriptionChoices struct {
	Name string `json:"name"`
}

func (d DescriptionOption) Apply(c *character.Object, cfg json.RawMessage) error {
	var choice DescriptionChoices

	err := json.Unmarshal(cfg, &choice)
	if err != nil {
		return fmt.Errorf("%w %q: %w",
			ErrMalformedChoice, DescriptionType, err)
	}

	c.Name = choice.Name

	return nil
}
