package main

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
)

func get(t *testing.T, method, path string) *httptest.ResponseRecorder {
	t.Helper()
	rec := httptest.NewRecorder()
	newMux().ServeHTTP(rec, httptest.NewRequest(method, path, nil))
	return rec
}

func TestRootReturnsInfo(t *testing.T) {
	rec := get(t, http.MethodGet, "/")
	if rec.Code != http.StatusOK {
		t.Fatalf("GET / = %d, want 200", rec.Code)
	}
	if ct := rec.Header().Get("Content-Type"); ct != "application/json" {
		t.Errorf("Content-Type = %q, want application/json", ct)
	}
	var got info
	if err := json.NewDecoder(rec.Body).Decode(&got); err != nil {
		t.Fatalf("body is not JSON: %v", err)
	}
	if got.Message != "hello from assignment 6" || got.Version != version || got.Hostname == "" {
		t.Errorf("GET / = %+v", got)
	}
}

func TestHealthz(t *testing.T) {
	rec := get(t, http.MethodGet, "/healthz")
	if rec.Code != http.StatusOK || rec.Body.String() != "ok\n" {
		t.Errorf("GET /healthz = %d %q, want 200 \"ok\\n\"", rec.Code, rec.Body.String())
	}
}

func TestUnknownPathIsNotFound(t *testing.T) {
	if rec := get(t, http.MethodGet, "/nope"); rec.Code != http.StatusNotFound {
		t.Errorf("GET /nope = %d, want 404", rec.Code)
	}
}

func TestOnlyGetIsAllowed(t *testing.T) {
	if rec := get(t, http.MethodPost, "/healthz"); rec.Code != http.StatusMethodNotAllowed {
		t.Errorf("POST /healthz = %d, want 405", rec.Code)
	}
}
