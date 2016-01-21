package main

import (
	"flag"
	"fmt"
	"golang.org/x/crypto/bcrypt"
	"net/http"
	"os"
	"path"
)

var (
	VERSION    = "0.0.0"
	BUILD_DATE = "0000-01-01T00:00:00Z"
)
var port = flag.Int("port", 8080, "listening port")
var cost = flag.Int("cost", 10, "bcrypt cost")
var isVersion = flag.Bool("version", false, "current app version")

func handler(w http.ResponseWriter, r *http.Request) {
	path := r.URL.Path[1:]
	hashedData, err := bcrypt.GenerateFromPassword([]byte(path), *cost)
	if err != nil {
		panic(err)
	}
	fmt.Fprintf(w, "Hi, for the value '%s' i computed: %s\n", path, string(hashedData))
}

func main() {
	flag.Parse()
	if *isVersion {
		fmt.Printf("%s version: %s\n", path.Base(os.Args[0]), VERSION)
		fmt.Printf("build date: %s\n", BUILD_DATE)
		os.Exit(0)
	}
	http.HandleFunc("/", handler)
	fmt.Printf("Listening on port %d\n", *port)
	http.ListenAndServe(fmt.Sprintf(":%d", *port), nil)
}
