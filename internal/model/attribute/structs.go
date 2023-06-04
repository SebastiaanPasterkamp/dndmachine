package attribute

// Parser is a representation of an object path, like
// 'object.Attribute.List[1].Value' that can be used to manipulate
// structs with the Get and Set functions.
type Parser struct {
	path  string
	steps []step
}

type stepType string

const (
	elemStep stepType = "elem"
	listStep stepType = "list"
	dictStep stepType = "dict"
)

type step struct {
	field   string
	variant stepType
	index   int
	key     string
}
