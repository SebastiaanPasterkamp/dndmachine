package options

import (
	"encoding/json"
	"fmt"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/model/character"
)

type DescriptionOption struct {
}

type DescriptionChoices struct {
	Name   string `json:"name"`
	Avatar string `json:"avatar,omitempty"`
}

func (o DescriptionOption) Apply(c *character.Object, cfg json.RawMessage) (*[]character.UUID, error) {
	var choice DescriptionChoices

	err := json.Unmarshal(cfg, &choice)
	if err != nil {
		return nil, fmt.Errorf("%w %q: %w",
			ErrMalformedChoice, DescriptionType, err)
	}

	c.Avatar = choice.Avatar
	c.Name = choice.Name

	return nil, err
}
