package attribute

import (
	"fmt"
	"regexp"
	"strconv"
)

var re = regexp.MustCompile(`^(?:(?:\.|^)([a-zA-Z]+)|\[(\d+)]|\["([^"]+)"\])`)

// NewParser takes a path string and returns a Parser object to Get / Set
// struct values with.
func NewParser(path string) (*Parser, error) {
	p := Parser{
		path:  path,
		steps: []step{},
	}

	offset := 0
	for offset < len(path) {
		m := re.FindStringSubmatch(path[offset:])
		if len(m) == 0 || len(m[0]) == 0 {
			return nil, fmt.Errorf("%w: %q at offset %d of %q",
				ErrMalformedPath, path[offset:], offset, path)
		}
		offset += len(m[0])

		s := step{}
		switch {
		case m[1] != "":
			s = step{field: m[1], variant: elemStep}
		case m[2] != "":
			idx, _ := strconv.Atoi(m[2])
			s = step{field: m[2], variant: listStep, index: idx}
		case m[3] != "":
			s = step{field: m[3], variant: dictStep, key: m[3]}
		default:
			return nil, fmt.Errorf("%w: %q", ErrMalformedPath, path)
		}
		p.steps = append(p.steps, s)
	}

	// fmt.Printf("Parsed: %q\n", p)

	return &p, nil
}
