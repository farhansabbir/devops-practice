// Command hello is a small HTTP service that the CI pipeline builds, tests and
// packages as a GitHub Actions artifact. It is not deployed anywhere.
//
//	GET /         JSON with a greeting, the build version and the hostname
//	GET /healthz  "ok"
package main

import (
	"encoding/json"
	"io"
	"log"
	"net/http"
	"os"
	"time"
)

// version is set at build time with -ldflags "-X main.version=<commit sha>".
var version = "dev"

type info struct {
	Message  string `json:"message"`
	Version  string `json:"version"`
	Hostname string `json:"hostname"`
}

func newMux() *http.ServeMux {
	mux := http.NewServeMux()
	mux.HandleFunc("GET /{$}", root)
	mux.HandleFunc("GET /healthz", healthz)
	return mux
}

func root(w http.ResponseWriter, _ *http.Request) {
	host, _ := os.Hostname()
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(info{Message: "hello from assignment 6", Version: version, Hostname: host})
}

func healthz(w http.ResponseWriter, _ *http.Request) {
	w.Header().Set("Content-Type", "text/plain; charset=utf-8")
	_, _ = io.WriteString(w, "ok\n")
}

func main() {
	addr := os.Getenv("ADDR")
	if addr == "" {
		addr = ":8080"
	}
	srv := &http.Server{Addr: addr, Handler: newMux(), ReadHeaderTimeout: 5 * time.Second}
	log.Printf("hello %s listening on %s", version, addr)
	log.Fatal(srv.ListenAndServe())
}
