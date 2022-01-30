package database

// Scanner is an interface that implements the Scan function. Scan is
// implemented by *sql.Row and *sql.Rows.
type Scanner interface {
	Scan(dest ...interface{}) error
}

// Persistable is an interface to a struct that can be stored in, and retrieved
// from a database.
type Persistable interface {
	GetID() int64
	ExtractFields(fields []string) ([]interface{}, error)
}
