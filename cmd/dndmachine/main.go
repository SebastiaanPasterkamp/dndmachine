package main

import (
	"log"
	"os"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/build"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/config"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
)

func main() {
	log.Printf("%s %s (%s-%s @ %s)\n",
		build.Name, build.Version, build.Branch, build.Commit, build.Timestamp)

	args, err := config.Initialize(os.Args)
	if err != nil {
		log.Fatalf("error initializing configuration: %v", err)
	}

	db, err := database.Connect(args.Configuration)
	if err != nil {
		log.Fatalf("error connecting to the database: %v", err)
	}

	switch {
	case args.Storage != nil:
		if err := args.Storage.Do(db); err != nil {
			log.Fatalf("failed to execute storage command: %v", err)
		}
	case args.Server != nil:
		if err := args.Server.Launch(db); err != nil {
			log.Fatalf("encountered error while running server: %v", err)
		}
	default:
		log.Fatalf("unknown command")
	}
}
