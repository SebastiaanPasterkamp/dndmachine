package config

import (
	"github.com/SebastiaanPasterkamp/dndmachine/internal/build"
)

func (Arguments) Version() string {
	return build.Version
}

func (Arguments) Description() string {
	return `The D&D Machine is a Dungeons & Dragons character and campaign
	management tool.`
}
