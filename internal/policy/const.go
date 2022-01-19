package policy

type PolicyContext string

const (
	Clause = PolicyContext("sql clause")
	Values = PolicyContext("sql values")
)
