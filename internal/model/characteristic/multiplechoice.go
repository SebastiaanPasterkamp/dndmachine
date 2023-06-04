package characteristic

import (
	"fmt"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/model/character"
)

// MultipleChoiceOption is a characteristic type where one or more
// characteristics can be chosen.
type MultipleChoiceOption struct {
	OptionAttributes
	// Options is a list of Characteristic options that can be chosen.
	Options []UUID `json:"options,omitempty"`
	// Include extends the list of Options with a recurring set of choice
	// characteristics, like feats or fighting styles.
	Include UUID `json:"include,omitempty"`
	// Filter limits the list of options included.
	Filters []Filter `json:"filter,omitempty"`
	// Add defines how many more items may be added to the existing list.
	Add int `json:"add,omitempty"`
	// Limit defines how many items in total may exist in the target list.
	Limit int `json:"limit,omitempty"`
	// Replace defines how many existing items in a list may be removed to be
	// replaced with new items.
	Replace int `json:"replace,omitempty"`
}

func (o *MultipleChoiceOption) Apply(c *character.Object) error {
	return fmt.Errorf("%v: MultipleChoiceOption.Apply", ErrNotYetImplemented)
}
