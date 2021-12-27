package storage

const (
	// createSchemasTable is the SQL statement to create the schema table to
	// record schema changes applied to the database.
	createSchemasTable = `
		CREATE TABLE schema (
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			version VARCHAR(10) NOT NULL,
			path VARCHAR(64) NOT NULL,
			comment TEXT NOT NULL,
			timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
		)
	`
	// registerChange is the SQL statement used to insert new schema changes.
	registerChange = `
		INSERT INTO schema (version, path, comment, timestamp)
		VALUES (?, ?, ?, ?)
	`
	// getApplicationDate is the SQL statement to obtain the timestamp at which
	// a schema change was applied.
	getApplicationDate = `SELECT timestamp FROM schema WHERE version = ?`
)
