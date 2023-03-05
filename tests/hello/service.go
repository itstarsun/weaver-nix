package main

import (
	"context"
	"os"

	"github.com/ServiceWeaver/weaver"
)

//go:generate weaver generate

type Service interface {
	GetArgs(context.Context) ([]string, error)
	GetEnv(context.Context) ([]string, error)
	GetConfig(context.Context) (*Config, error)
}

type Config struct {
	weaver.AutoMarshal
	Value string
}

type impl struct {
	weaver.Implements[Service]
	weaver.WithConfig[Config]
}

func (*impl) GetArgs(context.Context) ([]string, error) {
	return os.Args[1:], nil
}

func (*impl) GetEnv(context.Context) ([]string, error) {
	return os.Environ(), nil
}

func (i *impl) GetConfig(context.Context) (*Config, error) {
	return i.Config(), nil
}
