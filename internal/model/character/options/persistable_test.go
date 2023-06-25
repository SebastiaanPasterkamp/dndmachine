package options_test

import (
	"encoding/json"
	"errors"
	"fmt"
	"reflect"
	"testing"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/model"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/model/character"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/model/character/options"
)

func TestOption_ExtractFields(t *testing.T) {
	empty := []byte(`{}`)

	example := options.Object{
		ID:     1,
		UUID:   "f00-b4r",
		Name:   "test",
		Type:   options.DescriptionType,
		Config: (*json.RawMessage)(&empty),
	}

	testCases := []struct {
		name           string
		option         options.Object
		columns        []string
		expectedFields []interface{}
		expectedError  error
	}{
		{
			"Working",
			example,
			[]string{"id", "uuid", "name", "type", "config"},
			[]interface{}{int64(1), character.UUID("f00-b4r"), "test", options.DescriptionType, empty},
			nil,
		},
		{
			"Fewer fields",
			example,
			[]string{"id", "type"},
			[]interface{}{int64(1), options.DescriptionType},
			nil,
		},
		{
			"Unknown Column",
			example,
			[]string{"id", "uuid", "unknown"},
			nil,
			model.ErrUnknownColumn,
		},
	}

	for _, tt := range testCases {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			result, err := tt.option.ExtractFields(tt.columns)
			if !errors.Is(err, tt.expectedError) {
				t.Errorf("Unexpected error: Expected %q, got %q", tt.expectedError, err)
			}

			if !reflect.DeepEqual(result, tt.expectedFields) {
				t.Errorf("Unexpected result. Expected %q, got %q",
					tt.expectedFields, result)
			}
		})
	}
}

type Scanner struct {
	Fields []interface{}
}

func (s Scanner) Scan(dest ...interface{}) error {
	for i, v := range s.Fields {
		switch d := dest[i].(type) {
		case *string:
			s, ok := v.(string)
			if !ok {
				return fmt.Errorf("failed to cast %T to %T", v, d)
			}
			*d = s
		case *[]byte:
			s, ok := v.([]byte)
			if !ok {
				return fmt.Errorf("failed to cast %T to %T", v, d)
			}
			*d = s
		case *options.OptionType:
			t, ok := v.(options.OptionType)
			if !ok {
				return fmt.Errorf("failed to cast %T to %T", v, d)
			}
			*d = t
		case *character.UUID:
			u, ok := v.(character.UUID)
			if !ok {
				return fmt.Errorf("failed to cast %T to %T", v, d)
			}
			*d = u
		case **json.RawMessage:
			u, ok := v.(*json.RawMessage)
			if !ok {
				return fmt.Errorf("failed to cast %T to %T", v, d)
			}
			*d = u
		case *int64:
			i, ok := v.(int64)
			if !ok {
				return fmt.Errorf("failed to cast %T to %T", v, d)
			}
			*d = i
		default:
			return fmt.Errorf("unsupported type %T", dest[i])
		}
	}
	return nil
}

func TestOption_UpdateFromScanner(t *testing.T) {
	empty := []byte(`{}`)

	testCases := []struct {
		name           string
		fields         []interface{}
		columns        []string
		expectedOption options.Object
		expectedError  error
	}{
		{
			"Working",
			[]interface{}{int64(1), character.UUID("f00-b4r"), "test", options.DescriptionType, empty},
			[]string{"id", "uuid", "name", "type", "config"},
			options.Object{
				ID:     1,
				UUID:   "f00-b4r",
				Name:   "test",
				Type:   options.DescriptionType,
				Config: (*json.RawMessage)(&empty),
			},
			nil,
		},
		{
			"Fewer fields",
			[]interface{}{int64(1), options.DescriptionType},
			[]string{"id", "type"},
			options.Object{
				ID:   1,
				Type: options.DescriptionType,
			},
			nil,
		},
		{
			"Unknown Column",
			[]interface{}{},
			[]string{"id", "uuid", "unknown"},
			options.Object{},
			model.ErrUnknownColumn,
		},
		{
			"Invalid Column",
			[]interface{}{int64(1), "bad value"},
			[]string{"id", "uuid"},
			options.Object{ID: 1},
			model.ErrInvalidRecord,
		},
	}

	for _, tt := range testCases {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			row := Scanner{
				Fields: tt.fields,
			}

			o := options.Object{}

			err := o.UpdateFromScanner(row, tt.columns)
			if !errors.Is(err, tt.expectedError) {
				t.Errorf("Unexpected error: Expected %q, got %q.", tt.expectedError, err)
			}

			if !reflect.DeepEqual(o, tt.expectedOption) {
				t.Errorf("Unexpected result. Expected %v, got %v.",
					tt.expectedOption, o)
			}
		})
	}
}

func TestOption_GetID(t *testing.T) {
	expected := int64(1)

	o := options.Object{
		ID:   1,
		UUID: "f00-b4r",
		Name: "test",
	}

	id := o.GetID()

	if id != expected {
		t.Errorf("Unexpected ID. Expected %T %d, got %T %d.",
			expected, expected, id, id)
	}
}
