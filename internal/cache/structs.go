package cache

type Configuration struct {
	InMemorySettings
	RedisSettings
}

type InMemorySettings struct {
}

type RedisSettings struct {
	Address  string `json:"address" arg:"--redis-address,env:DNDMACHINE_REDIS_ADDRESS" placeholder:"host:port" help:"The address of the redis cache service."`
	Password string `json:"password" arg:"--redis-password,env:DNDMACHINE_REDIS_PASSWORD" help:"The redis passsword to use.`
	Database int    `json:"database" arg:"--redis-database,env:DNDMACHINE_REDIS_DATABASE" placeholder:"#" help:"The redis database to use."`
}
