package options_test

import (
	"encoding/json"
	"errors"
	"testing"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/model/character"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/model/character/options"
)

func TestTabOption_Apply(t *testing.T) {
	testCases := []struct {
		name          string
		option        options.OptionType
		config        []byte
		choice        []byte
		expectedError error
		expectedUUID  string
	}{
		{
			"Empty", options.TabType, []byte(`{"type":"class"}`), []byte(`{}`),
			nil, "",
		},
		{
			"Working", options.TabType, []byte(`{"type":"class"}`), []byte(`{"choice":"6a09ab55-21bc-4b87-82a3-e35110c1c3ae"}`),
			nil, "6a09ab55-21bc-4b87-82a3-e35110c1c3ae",
		},
		{
			"Unknown Option", "unknown", []byte(`{}`), []byte(`{}`),
			options.ErrUnknownOption, "",
		},
		{
			"Malformed Option", options.TabType, []byte(`{`), []byte(`{}`),
			options.ErrMalformedOption, "",
		},
		{
			"Malformed Choice", options.TabType, []byte(`{}`), []byte(`{`),
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

			followup, err := o.Apply(&c)
			if !errors.Is(err, tt.expectedError) {
				t.Errorf("Unexpected error: Expected %q, got %q", tt.expectedError, err)
			}

			if tt.expectedError != nil {
				return
			}

			next := ""
			if followup != nil && len(*followup) == 1 {
				next = string((*followup)[0])
			}

			if next != tt.expectedUUID {
				t.Errorf("Unexpected follow-up UUID: Expected %q, got %q",
					tt.expectedUUID, next)
			}
		})
	}
}
