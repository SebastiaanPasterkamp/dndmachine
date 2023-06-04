package characteristic_test

import (
	"encoding/json"
	"errors"
	"strings"
	"testing"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/model/character"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/model/characteristic"
)

func TestValueOption_Apply(t *testing.T) {
	t.Parallel()

	var testCases = []struct {
		name              string
		subject           string
		option            string
		expectedError     error
		expectedCharacter string
	}{
		{"apply name", `{"level": 0}`, `{"id": 0, "uuid": "abc", "name": "Set name", "type": "value", "config": {"path": "name", "value": "Testy McTestFace"}}`,
			nil, `{"level": 0, "name": "Testy McTestFace"}`},
		{"override name", `{"level": 1, "name": "Unnamed"}`, `{"id": 1, "uuid": "def", "name": "Set name", "type": "value", "config": {"path": "name", "value": "Testy McTestFace"}}`,
			nil, `{"level": 1, "name": "Testy McTestFace"}`},
		{"unsupported path", "{}", `{"id": 3, "uuid": "ghi", "name": "Set name", "type": "value", "config": {"path": "unsupported", "value": "Nope"}}`,
			characteristic.ErrNotYetImplemented, `{}`},
		{"bad value", "{}", `{"id": 4, "uuid": "jkl", "name": "Bad value", "type": "value", "config": {"path": "name", "value": {"bad": "value"}}}`,
			characteristic.ErrFailedToApply, `{}`},
		{"set ability", `{}`, `{"id": 5, "uuid": "mno", "name": "Set ability", "type": "value", "config": {"path": "abilities.test", "value": {"template": "Do something {{.Count}} times.", "text": "Do something a number of times", "variables": {"Count": {"formula": "1", "default": "a number of"}}}}}`,
			nil, `{"abilities": {"test": {"template": "Do something {{.Count}} times.", "text": "Do something a number of times", "variables": {"Count": {"formula": "1", "default": "a number of"}}}}`},
	}

	for _, tt := range testCases {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			e := character.Object{}
			e.UnmarshalFromReader(strings.NewReader(tt.expectedCharacter))

			expected, err := json.Marshal(&e)
			if err != nil {
				t.Fatalf("Unexpected json marshalling error: %v", err)
			}

			o := characteristic.Option{}
			o.UnmarshalFromReader(strings.NewReader(tt.option))

			c := character.Object{}
			c.UnmarshalFromReader(strings.NewReader(tt.subject))

			err = o.Apply(&c)
			if !errors.Is(err, tt.expectedError) {
				t.Errorf("Unexpected error. Expected %v, got %v.",
					tt.expectedError, err)
			}

			if tt.expectedError != nil {
				return
			}

			result, err := json.Marshal(&c)
			if err != nil {
				t.Fatalf("Unexpected json marshalling error: %v", err)
			}

			if string(result) != string(expected) {
				t.Errorf("Unexpected character Object. Expected %s, got %s.",
					expected, result)
			}
		})
	}
}
