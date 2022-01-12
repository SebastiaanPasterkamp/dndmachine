package cache

import (
	"context"
	"encoding/json"
	"fmt"
	"time"

	"github.com/go-redis/redis/v8"
)

type Redis struct {
	rdb *redis.Client
}

func NewRedis(ctx context.Context, cfg RedisSettings) (*Redis, error) {
	rdb := redis.NewClient(&redis.Options{
		Addr:     cfg.Address,
		Password: cfg.Password,
		DB:       cfg.Database,
	})

	err := rdb.Ping(ctx).Err()
	if err != nil {
		return nil, fmt.Errorf("%v: %q", ErrBadConfig, err)
	}

	return &Redis{rdb: rdb}, nil
}

func (r *Redis) Set(ctx context.Context, key string, value interface{}, TTL time.Duration) error {
	obj, err := json.Marshal(value)
	if err != nil {
		return fmt.Errorf("%v: %q", ErrNotStored, err)
	}

	if err := r.rdb.Set(ctx, key, obj, TTL).Err(); err != nil {
		return fmt.Errorf("%v: %v", ErrNotStored, err)
	}

	return nil
}

func (r *Redis) Get(ctx context.Context, key string, value interface{}) error {
	obj, err := r.rdb.Get(ctx, key).Result()
	if err != nil {
		return fmt.Errorf("%v: %q", ErrNotFound, err)
	}

	if err := json.Unmarshal([]byte(obj), value); err != nil {
		return fmt.Errorf("%v: %q", ErrNotFound, err)
	}

	return nil
}

func (r *Redis) Del(ctx context.Context, key string) error {
	if err := r.rdb.Del(ctx, key).Err(); err != nil {
		return fmt.Errorf("failed to delete from redis: %v", err)
	}

	return nil
}
