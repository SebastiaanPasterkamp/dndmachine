package options_test

import (
	"encoding/json"
	"errors"
	"fmt"
	"testing"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/model/character"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/model/character/options"
)

func TestRecompute(t *testing.T) {
	testCases := []struct {
		name          string
		option        options.OptionType
		uuid          string
		config        []byte
		choice        []byte
		expectedError error
		expectedName  string
	}{
		{
			"Working", options.DescriptionType, "f00-b4r", []byte(`{}`), []byte(`{"name":"Testy McTestFace"}`),
			nil, "Testy McTestFace",
		},
		{
			"Unknown Option", "unknown", "f00-b4r", []byte(`{}`), []byte(`{}`),
			options.ErrUnknownOption, "",
		},
		{
			"Malformed Option", options.DescriptionType, "f00-b4r", []byte(`{`), []byte(`{}`),
			options.ErrMalformedOption, "",
		},
		{
			"Malformed Choice", options.DescriptionType, "f00-b4r", []byte(`{}`), []byte(`{`),
			options.ErrMalformedChoice, "",
		},
		{
			"Missing Option", options.DescriptionType, "b4d-f00", []byte(`{}`), []byte(`{"name":"Testy McTestFace"}`),
			options.ErrMissingOption, "",
		},
	}

	one := character.UUID("c4826704-86dc-4daf-985b-d4514ece5bc5")
	decision := []byte(`{"type":"decision"}`)
	two := character.UUID("867fde51-ed0d-4ec6-bed4-a6e561f08ff4")
	class := []byte(`{"type":"class"}`)

	for _, tt := range testCases {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			option := map[character.UUID]options.Object{
				one: {
					ID:     1,
					UUID:   one,
					Type:   options.DescriptionType,
					Config: (*json.RawMessage)(&decision),
				},
				two: {
					ID:     2,
					UUID:   two,
					Type:   options.TabType,
					Config: (*json.RawMessage)(&class),
				},
				character.UUID("f00-b4r"): {
					ID:     3,
					UUID:   character.UUID("f00-b4r"),
					Type:   tt.option,
					Config: (*json.RawMessage)(&tt.config),
				},
			}

			provider := func(uuid character.UUID) (*options.Object, error) {
				o, ok := option[uuid]
				if !ok {
					return nil, fmt.Errorf("%w: uuid %q does not match %q",
						options.ErrMissingOption, uuid, o.UUID)
				}

				return &o, nil
			}

			choice := []byte(`{"choice":"` + tt.uuid + `"}`)
			c := character.Object{
				Attributes: character.Attributes{
					Choices: map[character.UUID]json.RawMessage{
						two:                     choice,
						character.UUID(tt.uuid): tt.choice,
					},
				},
			}

			u, err := options.Recompute(&c, provider)
			if !errors.Is(err, tt.expectedError) {
				t.Errorf("Unexpected error: Expected %q, got %q", tt.expectedError, err)
			}

			if u == nil {
				return
			}

			if u.Name != tt.expectedName {
				t.Errorf("Unexpected name: Expected %q, got %q",
					tt.expectedName, u.Name)
			}
		})
	}
}
