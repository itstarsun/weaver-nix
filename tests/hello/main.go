package main

import (
	"context"
	"fmt"
	"log"
	"net/http"

	"github.com/ServiceWeaver/weaver"
)

func main() {
	root := weaver.Init(context.Background())

	l, err := root.Listener("hello", weaver.ListenerOptions{
		LocalAddress: "localhost:8080",
	})
	if err != nil {
		log.Fatal(err)
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello, world!")
	})

	http.Serve(l, nil)
}
