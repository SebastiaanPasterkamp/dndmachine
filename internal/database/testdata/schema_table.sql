-- Schema versioning table for testing the database.Import function

CREATE TABLE schema (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    version VARCHAR(10) NOT NULL,
    path VARCHAR(64) NOT NULL,
    comment TEXT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
)
