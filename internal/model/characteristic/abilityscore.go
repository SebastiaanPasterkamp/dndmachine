package characteristic

import (
	"fmt"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/model/character"
)

// AbilityScoreOption is a characteristic type where a the ability
// scores are configured or updated.
type AbilityScoreOption struct {
	OptionAttributes
	// Hidden indicates if the chosen characteristic is displayed in the UI.
	Hidden bool `json:"hidden,omitempty"`
	// Increase offers a budget of points to be assigned to increase the base
	// statistics. Any value of zero or below means no ability score increases
	// are granted.
	Increase int `json:"increase,omitempty"`
	// Bonuses is a dictionary of statistics with a bonus value assigned to the
	// statistic defined in the key. These bonuses are typically granted as
	// racial traits.
	Bonuses map[string]int `json:"bonus,omitempty"`
}

func (o *AbilityScoreOption) Apply(c *character.Object) error {
	return fmt.Errorf("%v: AbilityScoreOption.Apply", ErrNotYetImplemented)
}
