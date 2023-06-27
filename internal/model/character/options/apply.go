package options

import (
	"encoding/json"
	"fmt"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/model/character"
)

func (i *Object) Apply(c *character.Object) (*[]character.UUID, error) {
	var (
		a   Applicator
		err error
	)
	switch i.Type {
	case ClassType:
		o := ClassOption{}
		err = json.Unmarshal(*i.Config, &o)
		a = o
	case DescriptionType:
		o := DescriptionOption{}
		err = json.Unmarshal(*i.Config, &o)
		a = o
	case TabType:
		o := TabOption{}
		err = json.Unmarshal(*i.Config, &o)
		a = o
	default:
		return nil, fmt.Errorf("%w %d:%q: %q",
			ErrUnknownOption, i.ID, i.UUID, i.Type)
	}

	if err != nil {
		return nil, fmt.Errorf("%w: %q %d:%q: %w",
			ErrMalformedOption, i.Type, i.ID, i.UUID, err)
	}

	choices, ok := c.Choices[i.UUID]
	if !ok {
		choices = emptyChoice
	}

	fmt.Printf("Apply %q with %q and %q\n", i.Type, a, choices)

	return a.Apply(c, choices)
}
