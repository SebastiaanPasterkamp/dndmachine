package options_test

import (
	"encoding/json"
	"errors"
	"testing"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/model/character"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/model/character/options"
)

func TestDescriptionOption_Apply(t *testing.T) {
	testCases := []struct {
		name          string
		option        options.OptionType
		config        []byte
		choice        []byte
		expectedError error
		expectedName  string
	}{
		{
			"Working", options.DescriptionType, []byte(`{}`), []byte(`{"name":"Testy McTestFace"}`),
			nil, "Testy McTestFace",
		},
		{
			"Unknown Option", "unknown", []byte(`{}`), []byte(`{}`),
			options.ErrUnknownOption, "",
		},
		{
			"Malformed Option", options.DescriptionType, []byte(`{`), []byte(`{}`),
			options.ErrMalformedOption, "",
		},
		{
			"Malformed Choice", options.DescriptionType, []byte(`{}`), []byte(`{`),
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

			err := o.Apply(&c)
			if !errors.Is(err, tt.expectedError) {
				t.Errorf("Unexpected error: Expected %q, got %q", tt.expectedError, err)
			}

			if c.Name != tt.expectedName {
				t.Errorf("Unexpected name: Expected %q, got %q",
					tt.expectedName, c.Name)
			}
		})
	}
}
