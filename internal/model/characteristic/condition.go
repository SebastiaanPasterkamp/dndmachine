package characteristic

// ConditionType is a string to enumerate the types of condition evaluation
// methods that exist.
type ConditionType string

const (
	// EQ is a condition type where the value must be exactly equal to the
	// target.
	EQ ConditionType = "eq"
	// GTE is a condition type where the value must be equal or greater than the
	// target value.
	GTE ConditionType = "gte"
	// OR is a condition type where at least one of the conditions should
	// evaluate to true.
	OR ConditionType = "or"
	// LTE is a condition type where the value must be equal or less than the
	// target value.
	LTE ConditionType = "lte"
)

// Condition defines a character property that should evaluate to true for the
// condition to be met.
type Condition struct {
	// Path is the period + capitalization separated character attribute
	// reference the condition is referring to.
	Path string `json:"path"`
	// Type defines how the condition is evaluated.
	Type ConditionType `json:"type"`
	// Value is the target the path is compared to.
	Value int `json:"value"`
}
