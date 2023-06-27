package options

import (
	"fmt"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/model/character"
)

// Recompute rebuilds a character based on the recorded choices.
func Recompute(c *character.Object, provide OptionsProvider) (*character.Object, error) {
	u := &character.Object{
		ID:     c.ID,
		UserID: c.UserID,
		Level:  c.Level,
		Attributes: character.Attributes{
			Choices: c.Choices,
		},
	}

	// TODO: Get list of bootstrap configurations from the database
	queue := []character.UUID{
		"c4826704-86dc-4daf-985b-d4514ece5bc5",
		"867fde51-ed0d-4ec6-bed4-a6e561f08ff4",
	}

	for i := 0 ; i < len(queue); i++ {
		uuid := queue[i]

		option, err := provide(uuid)
		if err != nil {
			return nil, fmt.Errorf("%w %q: %w",
				ErrMissingOption, uuid, err)
		}

		followup, err := option.Apply(u)
		if err != nil {
			return nil, fmt.Errorf("%s %q %q: %w",
				ErrFailedToApply, uuid, option.Type, err)
		}

		if followup != nil {
			queue = append(queue, *followup...)
		}
	}

	return u, nil
}
