package characteristic

import (
	"encoding/json"
	"fmt"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/model/character"
)

// ValueOption is a characteristic type where a property is set to
// a specific value.
type ValueOption struct {
	Option
	OptionAttributes
	// Path is the period + capitalization separated character attribute
	// reference.
	Path string `json:"path"`
	// Hidden indicates if the chosen characteristic is displayed in the UI.
	Hidden bool `json:"hidden,omitempty"`
	// Value is to be assigned to the attribute typed to be path specific.
	Value *json.RawMessage `json:"value"`
}

func (o *ValueOption) Apply(c *character.Object) error {
	var err error
	switch o.Path {
	case "name":
		err = json.Unmarshal(*o.Value, &c.Name)
	default:
		return fmt.Errorf("%w ValueOption.Apply with path %q",
			ErrNotYetImplemented, o.Path)
	}

	if err != nil {
		return fmt.Errorf("%w: applying %q to %q: %w",
			ErrFailedToApply, o.Value, o.Path, err)
	}

	return nil
}
