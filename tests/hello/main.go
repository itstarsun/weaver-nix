package main

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/ServiceWeaver/weaver"
)

func main() {
	root := weaver.Init(context.Background())

	l, err := root.Listener("hello", weaver.ListenerOptions{
		LocalAddress: "localhost:8080",
	})
	if err != nil {
		panic(err)
	}

	s, err := weaver.Get[Service](root)
	if err != nil {
		panic(err)
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello, world!")
	})

	http.HandleFunc("/args", func(w http.ResponseWriter, r *http.Request) {
		send(w)(s.GetArgs(r.Context()))
	})

	http.HandleFunc("/env", func(w http.ResponseWriter, r *http.Request) {
		send(w)(s.GetEnv(r.Context()))
	})

	http.HandleFunc("/config", func(w http.ResponseWriter, r *http.Request) {
		send(w)(s.GetConfig(r.Context()))
	})

	panic(http.Serve(l, nil))
}

func send(w http.ResponseWriter) func(v any, err error) {
	return func(v any, err error) {
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		_ = json.NewEncoder(w).Encode(v)
	}
}
