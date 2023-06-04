package characteristic

import (
	"github.com/SebastiaanPasterkamp/dndmachine/internal/model/character"
)

type Applicable interface {
	Apply(c *character.Object) error
}
