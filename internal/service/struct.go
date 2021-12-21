package service

// Instance is the collection of parameters for running the D&D service.
type Instance struct {
	// Port is the port number where the service will listen on.
	Port string `json:"port" arg:"--port,env:DNDMACHINE_PORT" default:"8080" help:"Port to listen on"`
}
