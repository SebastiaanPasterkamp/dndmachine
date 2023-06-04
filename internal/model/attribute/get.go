package attribute

import (
	"fmt"
	"reflect"
)

// Get returns the value on the parsed path from the the provided
// object, or an error.
func (p Parser) Get(o interface{}) (interface{}, error) {
	rv := reflect.ValueOf(o)

	for _, step := range p.steps {
		switch step.variant {
		case elemStep:
			switch {
			case rv.Kind() == reflect.Struct:
				rv = rv.FieldByName(step.field)
			case rv.Kind() == reflect.Pointer && reflect.Indirect(rv).Kind() == reflect.Struct:
				rv = reflect.Indirect(rv).FieldByName(step.field)
			default:
				return nil, fmt.Errorf("%w: field %q in path %q is not valid",
					ErrPathNotFound, step.field, p.path)
			}

			if !rv.IsValid() {
				return nil, fmt.Errorf("%w: field %q in path %q is not valid",
					ErrPathNotFound, step.field, p.path)
			}

		case listStep:
			if rv.Kind() != reflect.Slice {
				return nil, fmt.Errorf("%w: expected %v, but found %q",
					ErrInvalidPath, step.variant, rv.Kind())
			}

			rv = rv.Index(step.index)

			if !rv.IsValid() {
				return nil, fmt.Errorf("%w: index %d in path %q is not valid",
					ErrPathNotFound, step.index, p.path)
			}

		case dictStep:
			if rv.Kind() != reflect.Map {
				return nil, fmt.Errorf("%w: expected %v, but found %q",
					ErrInvalidPath, step.variant, rv.Kind())
			}

			rv = rv.MapIndex(reflect.ValueOf(step.key))

			if !rv.IsValid() {
				return nil, fmt.Errorf("%w: key %q in path %q is not valid",
					ErrPathNotFound, step.key, p.path)
			}
		}
	}

	if !rv.IsValid() {
		return nil, fmt.Errorf("%w: path %q is not valid",
			ErrPathNotFound, p.path)
	}

	return rv.Interface(), nil
}
