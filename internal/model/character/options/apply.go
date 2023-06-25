package options

import (
	"encoding/json"
	"fmt"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/model/character"
)

func (i Object) Apply(c *character.Object) error {
	var (
		a   Applicator
		err error
	)
	switch i.Type {
	case DescriptionType:
		d := DescriptionOption{}
		err = json.Unmarshal(*i.Config, &d)
		a = d
	default:
		return fmt.Errorf("%w %d:%q: %q",
			ErrUnknownOption, i.ID, i.UUID, i.Type)
	}

	if err != nil {
		return fmt.Errorf("%w: %q %d:%q: %w",
			ErrMalformedOption, i.Type, i.ID, i.UUID, err)
	}

	choices, ok := c.Choices[i.UUID]
	if !ok {
		choices = emptyChoice
	}

	return a.Apply(c, choices)
}
