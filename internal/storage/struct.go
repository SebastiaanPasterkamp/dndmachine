package storage

type Instance struct {
	// Path to the directory containing schema migrations.
	Path string `json:"path" env:"DNDMACHINE_SCHEMA_PATH" args:"--schema-dir" default:"schema" help:"Path to directory containing schema migrations."`
	// Upgrade is the command to apply all unapplied schema changes. It can
	// upgrade a blank database.
	Upgrade *CmdUpgrade `arg:"subcommand:upgrade" help:"Apply all unapplied schema changes. The database can be empty."`
	// Version is the command to list the current and unapplied schema versions.
	Version *CmdVersion `json:"version" arg:"subcommand:version" help:"List the current and unapplied schema versions."`
	// Import is the command to transfer an existing database to the current
	// database.
	Import *CmdImport `arg:"subcommand:import" help:"Transfer an existing source database to the current database."`
	// CmdExport is the command to export the schema and contents of an existing database.
	Export *CmdExport `arg:"subcommand:export" help:"Export the schema and contents of an existing database."`
}

type CmdVersion struct{}

type CmdUpgrade struct {
	RejectOutOfOrder bool `json:"reject_out_of_order" default:"false" arg:"--reject-out-of-order" help:"Reject out of order schema changes. May raise non-zero exit status."`
}

type CmdExport struct {
	// Output is filename where the SQL statements will be written to.
	Output string `json:"output" arg:"--output" default:"-" placeholder:"dump.sql" help:"Write output to this file."`
	// Table limits the export to a single table.
	Table string `json:"table" arg:"--table" help:"Limit the export to a single table."`
}

type CmdImport struct {
	// Source is the DSN of the source database to import.
	Source string `json:"source" arg:"--source-database,required" help:"The source database DSN to import."`
}
