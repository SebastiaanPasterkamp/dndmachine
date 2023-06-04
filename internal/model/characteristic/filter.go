package characteristic

// FilterType is a string to enumerate the types of filtering methods that exist.
type FilterType string

const (
	// AttributeFilter is a filter method where the value of an attribute of a
	// list item must be present in the list
	AttributeFilter FilterType = "attribute"
	// OrFilter is a filter method where a list item must pass one or more of
	// the filters in a list.
	OrFilter FilterType = "or"
	// ProficienciesFilter is a filter method where a list item must pass one or more of
	// the filters in a list.
	ProficienciesFilter FilterType = "proficiencies"
)

// Filter is a configuration to filter options from a list. The filter type
// defines how the filter is applied.
type Filter struct {
	// Type describes how the filter is applied.
	Type FilterType `json:"type"`
}
