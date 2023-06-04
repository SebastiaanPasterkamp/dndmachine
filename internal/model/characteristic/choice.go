package characteristic

import (
	"fmt"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/model/character"
)

// ChoiceOption is a characteristic type where one only one
// characteristic can be chosen.
type ChoiceOption struct {
	OptionAttributes
	// Options is a list of Characteristic IDs that can be chosen.
	Options []UUID `json:"options,omitempty"`
	// Include extends the list of Options with a recurring set of choice
	// characteristics, like feats or fighting styles.
	Include UUID `json:"include,omitempty"`
	// Filter limits the list of options included.
	Filters []Filter `json:"filter,omitempty"`
}

func (o *ChoiceOption) Apply(c *character.Object) error {
	return fmt.Errorf("%v: ChoiceOption.Apply", ErrNotYetImplemented)
}
