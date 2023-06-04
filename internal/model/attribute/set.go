package attribute

import (
	"fmt"
	"reflect"
)

// Set updates the value on the parsed path on the provided object, or an error.
func (p Parser) Set(o interface{}, v interface{}) error {
	rvPtr := reflect.ValueOf(o)
	value := reflect.ValueOf(v)

	for _, step := range p.steps {
		if rvPtr.Kind() != reflect.Pointer {
			return fmt.Errorf("%w: cannot set value on path %q as %T is not a pointer",
				ErrUnsupportedOperation, p.path, rvPtr.Interface())
		}

		rv := rvPtr.Elem()

		switch step.variant {
		case elemStep:
			if rv.Kind() != reflect.Struct {
				return fmt.Errorf("%w: field %q in path %q expects a pointer to %v but found %T instead",
					ErrInvalidPath, step.field, p.path, reflect.Struct, rvPtr.Interface())
			}

			nxt := rv.FieldByName(step.field)
			if !nxt.IsValid() {
				return fmt.Errorf("%w: interface %T does not have field %v",
					ErrPathNotFound, rv.Interface(), step.field)
			}

			rvPtr = nxt.Addr()

		case listStep:
			if rv.Kind() != reflect.Slice {
				return fmt.Errorf("%w: index %d in path %q expects a pointer to %v but found %T instead",
					ErrInvalidPath, step.index, p.path, reflect.Slice, rvPtr.Interface())
			}

			if rv.Len() <= step.index {
				rv.Grow(step.index - rv.Len())
			}

			rvPtr = rv.Index(step.index).Addr()
			// TODO: fix nil value

		case dictStep:
			if rv.Kind() != reflect.Map {
				return fmt.Errorf("%w: key %q in path %q expects a pointer to %v but found %T instead",
					ErrInvalidPath, step.key, p.path, reflect.Map, rvPtr.Interface())
			}

			key := reflect.ValueOf(step.key)

			if rv.IsNil() {
				mapType := rv.Type()
				nxt := reflect.MakeMap(reflect.MapOf(mapType.Key(), mapType.Elem()))
				rv.Set(nxt)
			}

			elem := rv.MapIndex(key)
			nxt := reflect.New(rv.Type().Elem())

			if elem.Kind() != reflect.Invalid {
				nxt.Elem().Set(reflect.ValueOf(elem.Interface()))
			}

			defer func() {
				rv.SetMapIndex(key, nxt.Elem())
			}()

			rvPtr = nxt
		}
	}

	rvPtr.Elem().Set(value)

	return nil
}
