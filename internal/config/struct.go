package config

import (
	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/service"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/storage"
)

type Arguments struct {
	// Database is the database configuration.
	database.Configuration `json:"database"`
	// Common are the settings for all commands.
	Common
	// Server are the settings for running the D&D Service.
	Server *service.Instance `json:"server" arg:"subcommand:serve"`
	// Storage are the settings for upgrading the database schemas.
	Storage *storage.Instance `arg:"subcommand:storage"`
}

// Common are the settings used for all commands.
type Common struct {
	// ConfigPath is the path to the configuration file to get default values from.
	ConfigPath string `arg:"--config-path,env:DNDMACHINE_CONFIG_PATH" help:"Path to configuration file"`
}
