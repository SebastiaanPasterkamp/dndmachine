package characteristic

import (
	"encoding/json"
	"fmt"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/model/character"
)

// ListOption is a characteristic type where one or more items from a list can
// be chosen.
type ListOption struct {
	OptionAttributes
	// Path is the period + capitalization separated character attribute
	// reference.
	Path string `json:"path"`
	// Hidden indicates if the chosen characteristic is displayed in the UI.
	Hidden bool `json:"hidden,omitempty"`
	// Multiple indicates if the items in the path are expected to be unique.
	Multiple bool `json:"multiple,omitempty"`
	// Given is a list of values typed to be path specific.
	Given *json.RawMessage `json:"given,omitempty"`
}

func (o *ListOption) Apply(c *character.Object) error {
	return fmt.Errorf("%v: ListOption.Apply", ErrNotYetImplemented)
}
