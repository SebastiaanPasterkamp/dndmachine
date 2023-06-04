package characteristic

import (
	"fmt"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/model/character"
)

// ConfigOption is a characteristic type offering a list of characteristic
// Options.
type ConfigOption struct {
	OptionAttributes
	// Config is a list of Characteristics provided by the config.
	Config []UUID `json:"config"`
}

func (o *ConfigOption) Apply(c *character.Object) error {
	return fmt.Errorf("%v: ConfigOption.Apply", ErrNotYetImplemented)
}
