package cache

func Factory(cfg Configuration) (Repository, error) {
	switch {
	case cfg.InMemory != nil:
		return NewMemory(cfg.InMemory), nil
	default:
		return NewMemory(nil), nil
	}
}
