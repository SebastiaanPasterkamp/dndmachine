package character

// Object is the database.Persistable and api.JSONable implementation of a
// character model.
type Object struct {
	Attributes
	Progress
	ID     int64  `json:"id"`
	UserID int64  `json:"userID"`
	Name   string `json:"name"`
	Level  int    `json:"level"`
}

// Progress is a collection of fields not under the player's control defining
// the various leveling systems available.
type Progress struct {
	AdventureCheckpoints        float32            `json:"adventure_checkpoints,omitempty"`
	AdventureCheckpointsAtLevel float32            `json:"adventure_checkpoints_at_level,omitempty"`
	AdventureCheckpointsToLevel float32            `json:"adventure_checkpoints_to_level,omitempty"`
	Downtime                    float32            `json:"downtime,omitempty"`
	Experience                  int                `json:"xp,omitempty"`
	ExperienceAtLevel           int                `json:"xp_at_level"`
	ExperienceToLevel           int                `json:"xp_to_level"`
	Renown                      float32            `json:"renown,omitempty"`
	TreasureCheckpoints         map[string]float32 `json:"treasure_checkpoints,omitempty"`
}

// Attributes are a collection of non-primary fields stored in the config column
// of the character table.
type Attributes struct {
	Abilities map[string]Ability `json:"abilities"`
}

// Ability is a struct with a description template string plus zero
// or more values that can be inserted into the template. Some values are static
// while others are computed as a formula (..._formula), and typically come with
// a default fallback value (..._default).
type Ability struct {
	// Template is the template description of the ability.
	Template string `json:"template"`
	// Variables is a list of template values providing both a formula value as
	// well as a default placeholder.
	Variables map[string]AbilityVariable `json:"variables"`
	// Text is the result of expanding all variables in the text template.
	Text string `json:"text"`
}

type AbilityVariable struct {
	// Formula can be a hardcoded value or mathematical expression to compute
	// a value based on character Object attributes.
	Formula string `json:"formula"`
	// Default is a placeholder in case the formula doesn't yield a valid value.
	Default string `json:"default"`
}
