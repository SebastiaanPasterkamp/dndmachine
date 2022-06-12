package model

import (
	"encoding/json"
)

// JSONInt64 is an int64 type that resets the int64 value to 0 if the json
// value was null.
type JSONInt64 int64

// UnmarshalJSON for the JSONInt64 sets the int64 value back to 0 if the key
// wa set to value null
func (i *JSONInt64) UnmarshalJSON(data []byte) error {
	*i = 0

	if string(data) == "null" {
		return nil
	}

	// The key isn't set to null
	var temp int64
	if err := json.Unmarshal(data, &temp); err != nil {
		return err
	}

	*i = JSONInt64(temp)
	return nil
}
