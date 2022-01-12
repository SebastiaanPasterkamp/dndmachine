package cache

import (
	"context"
	"log"
)

func Factory(ctx context.Context, cfg Configuration) (repo Repository, err error) {
	kind := "in-memory"
	switch {
	case cfg.RedisSettings.Address != "":
		kind = "redis"
		repo, err = NewRedis(ctx, cfg.RedisSettings)
	default:
		repo, err = NewMemory(ctx, cfg.InMemorySettings)
	}

	if err == nil {
		log.Printf("Initialized %q cache\n", kind)
	}

	return
}
