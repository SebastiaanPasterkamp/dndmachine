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
