package attribute_test

import (
	"encoding/json"
	"errors"
	"strings"
	"testing"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/model/attribute"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/model/character"
)

func TestGet(t *testing.T) {
	t.Parallel()

	var testCases = []struct {
		name          string
		subject       string
		path          string
		expectedParse error
		expectedGet   error
		expectedValue interface{}
	}{
		{"get string", `{"level": 1, "name": "Example"}`, "Name",
			nil, nil, "Example"},
		{"get integer", `{"level": 2, "name": "Example"}`, "Level",
			nil, nil, 2},
		{"undefined key", `{}`, `Abilities["example"]`,
			nil, attribute.ErrPathNotFound, nil},
		{"malformed path", `{}`, "Level.",
			attribute.ErrMalformedPath, nil, nil},
		{"nonexistent", `{}`, "Nonexistent",
			nil, attribute.ErrPathNotFound, nil},
	}

	for _, tt := range testCases {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			t.Parallel()

			s := character.Object{}
			err := s.UnmarshalFromReader(strings.NewReader(tt.subject))
			if err != nil {
				t.Fatal(err)
			}

			p, err := attribute.NewParser(tt.path)
			if !errors.Is(err, tt.expectedParse) {
				t.Errorf("Unexpected Parse error. Expected %v, got %v.",
					tt.expectedParse, err)
			}

			result, err := p.Get(s)
			if !errors.Is(err, tt.expectedGet) {
				t.Fatalf("Unexpected Get error. Expected %v, got %v.",
					tt.expectedGet, err)
			}

			if result != tt.expectedValue {
				t.Errorf("Unexpected character Object. Expected %v, got %v.",
					tt.expectedValue, result)
			}
		})
	}
}

func TestSet(t *testing.T) {
	t.Parallel()

	var testCases = []struct {
		name              string
		subject           string
		path              string
		value             interface{}
		expectedParse     error
		expectedSet       error
		expectedCharacter string
	}{
		{"set string", `{"level": 1, "name": "Example"}`, "Name", "Updated",
			nil, nil, `{"level": 1, "name": "Updated"}`},
		{"set integer", `{"level": 1, "name": "Example"}`, "Level", 2,
			nil, nil, `{"level": 2, "name": "Example"}`},
		{"add key to existing map", `{"abilities": {}}`, `Abilities["example"]`, character.Ability{Text: "created"},
			nil, nil, `{"abilities": {"example": {"text": "created"}}}`},
		{"add key to new map", `{}`, `Abilities["example"]`, character.Ability{Text: "created"},
			nil, nil, `{"abilities": {"example": {"text": "created"}}}`},
		{"replace key in map", `{"abilities": {"example": {"text": "outdated"}}}`, `Abilities["example"]`, character.Ability{Text: "replaced"},
			nil, nil, `{"abilities": {"example": {"text": "replaced"}}}`},
		{"update object in map", `{"abilities": {"example": {"template": "original", "text": "outdated"}}}`, `Abilities["example"].Text`, "replaced",
			nil, nil, `{"abilities": {"example": {"template": "original", "text": "replaced"}}}`},
		{"malformed path", `{}`, "Level.", nil,
			attribute.ErrMalformedPath, nil, `{}`},
		{"nonexistent", `{}`, "Nonexistent", nil,
			nil, attribute.ErrPathNotFound, `{}`},
	}

	for _, tt := range testCases {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			t.Parallel()

			s := character.Object{}
			err := s.UnmarshalFromReader(strings.NewReader(tt.subject))
			if err != nil {
				t.Fatal(err)
			}

			e := character.Object{}
			err = e.UnmarshalFromReader(strings.NewReader(tt.expectedCharacter))
			if err != nil {
				t.Fatal(err)
			}

			expected, err := json.Marshal(&e)
			if err != nil {
				t.Fatalf("Unexpected json marshalling error: %v", err)
			}

			p, err := attribute.NewParser(tt.path)
			if !errors.Is(err, tt.expectedParse) {
				t.Errorf("Unexpected Parse error. Expected %v, got %v.",
					tt.expectedParse, err)
			}

			err = p.Set(&s, tt.value)
			if !errors.Is(err, tt.expectedSet) {
				t.Fatalf("Unexpected Set error. Expected %v, got %v.",
					tt.expectedSet, err)
			}

			result, err := json.Marshal(&s)
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
