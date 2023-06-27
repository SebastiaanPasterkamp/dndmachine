package options_test

import (
	"encoding/json"
	"errors"
	"testing"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/model/character"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/model/character/options"
)

func TestClassOption_Apply(t *testing.T) {
	testCases := []struct {
		name          string
		option        options.OptionType
		config        []byte
		choice        []byte
		expectedError error
		expectedClass string
	}{
		{
			"Working", options.ClassType, []byte(`{"id":"cleric","Name":"Cleric"}`), []byte(`{}`),
			nil, "cleric",
		},
		{
			"Unknown Option", "unknown", []byte(`{}`), []byte(`{}`),
			options.ErrUnknownOption, "",
		},
		{
			"Malformed Option", options.ClassType, []byte(`{`), []byte(`{}`),
			options.ErrMalformedOption, "",
		},
		{
			"Malformed Choice", options.ClassType, []byte(`{}`), []byte(`{`),
			options.ErrMalformedChoice, "",
		},
	}

	for _, tt := range testCases {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			o := options.Object{
				ID:     1,
				UUID:   character.UUID("f00-b4r"),
				Type:   tt.option,
				Config: (*json.RawMessage)(&tt.config),
			}

			c := character.Object{
				Attributes: character.Attributes{
					Choices: map[character.UUID]json.RawMessage{
						o.UUID: tt.choice,
					},
				},
			}

			_, err := o.Apply(&c)
			if !errors.Is(err, tt.expectedError) {
				t.Errorf("Unexpected error: Expected %q, got %q", tt.expectedError, err)
			}

			if tt.expectedError != nil {
				return
			}

			class, ok := c.Classes[tt.expectedClass]
			if !ok {
				t.Errorf("Missing class: Expected %q, got %q",
					tt.expectedClass, class)
			} else if class.ID != tt.expectedClass {
				t.Errorf("Unexpected class ID: Expected %q, got %q",
					tt.expectedClass, class)
			}
		})
	}
}
