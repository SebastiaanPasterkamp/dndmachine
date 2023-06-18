package main

import (
	"context"
	"fmt"
	"log"
	"os"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/build"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/config"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/graceful"
	"golang.org/x/sync/errgroup"
)

func main() {
	ctx := graceful.Shutdown(context.Background())

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
	defer db.Close()

	if err := db.Ping(); err != nil {
		log.Fatalf("failed to establish a connection to the database: %v", err)
	}

	switch {
	case args.Storage != nil:
		if err := args.Storage.Command(db); err != nil {
			log.Fatalf("failed to execute storage command: %v", err)
		}
	case args.Server != nil:
		g, gCtx := errgroup.WithContext(ctx)

		g.Go(func() error {
			if err := args.Server.Launch(gCtx, db); err != nil {
				return fmt.Errorf("failed to launch service: %w", err)
			}

			return nil
		})
		g.Go(func() error {
			<-gCtx.Done()
			if err := args.Server.Shutdown(context.Background()); err != nil {
				return fmt.Errorf("failed to shutdown service: %w", err)
			}

			return nil
		})

		if err := g.Wait(); err != nil {
			log.Fatalf("exit reason: %v\n", err)
		}

		log.Println("Terminated")
	default:
		log.Fatalf("unknown command")
	}
}
