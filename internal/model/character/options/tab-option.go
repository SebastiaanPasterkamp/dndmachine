package options

import (
	"encoding/json"
	"fmt"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/model/character"
)

type TabOption struct {
	OptionType string `json:"type"`
}

type TabChoices struct {
	UUID character.UUID `json:"choice"`
}

func (o TabOption) Apply(c *character.Object, cfg json.RawMessage) (*[]character.UUID, error) {
	var choice TabChoices

	err := json.Unmarshal(cfg, &choice)
	if err != nil {
		return nil, fmt.Errorf("%w %q: %w",
			ErrMalformedChoice, TabType, err)
	}

	if choice.UUID == "" {
		return nil, nil
	}

	followup := []character.UUID{choice.UUID}

	return &followup, nil
}
