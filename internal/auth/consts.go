package auth

// ContextField is a string type for storing auth fields in the context.
type ContextField string

const (
	// CurrentUser is the context key to store and retrieve the current logged in
	// user.
	CurrentUser = ContextField("user")
)

const (
	// SessionCookie is the name of the session cookie.
	SessionCookie = "session"
)

const (
	// SQLColumns the context key to store and retrieve the SQL fields permitted
	// to access by the partial policy query.
	SQLColumns = ContextField("sql fields")
	// SQLClause the context key to store and retrieve the SQL where clause
	// from a partial policy query.
	SQLClause = ContextField("sql clause")
	// SQLValues the context key to store and retrieve the SQL where clause
	// values from a partial policy query.
	SQLValues = ContextField("sql values")
)
