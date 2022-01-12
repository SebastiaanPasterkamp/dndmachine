package cache

import (
	"context"
	"encoding/json"
	"fmt"
	"time"
)

type Memory struct {
	db map[string][]byte
}

func NewMemory(ctx context.Context, _ InMemorySettings) (*Memory, error) {
	return &Memory{db: map[string][]byte{}}, nil
}

func (m *Memory) Set(_ context.Context, key string, value interface{}, _ time.Duration) error {
	obj, err := json.Marshal(value)
	if err != nil {
		return fmt.Errorf("%v: %q", ErrNotStored, err)
	}

	m.db[key] = obj

	return nil
}

func (m *Memory) Get(_ context.Context, key string, value interface{}) error {
	obj, ok := m.db[key]
	if !ok {
		return ErrNotFound
	}

	if err := json.Unmarshal(obj, value); err != nil {
		return fmt.Errorf("%v: %q", ErrNotFound, err)
	}

	return nil
}

func (m *Memory) Del(_ context.Context, key string) error {
	delete(m.db, key)

	return nil
}
