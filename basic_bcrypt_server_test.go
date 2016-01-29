package main

import (
	"fmt"
	"golang.org/x/crypto/bcrypt"
	"io/ioutil"
	"net/http"
	"net/http/httptest"
	"regexp"
	"testing"
)

func testBCryptEntry(t *testing.T, entry string) {
	req, _ := http.NewRequest("GET", "/v1/"+entry, nil)
	w := httptest.NewRecorder()
	handlerV1(w, req)
	if w.Code != http.StatusOK {
		t.Errorf("The server didn't return %v", http.StatusOK)
	}
	actual, err := ioutil.ReadAll(w.Body)
	if err != nil {
		t.Fatal(err)
	}
	rpGeneralFormat := regexp.MustCompile(fmt.Sprintf("Hi, for the value '%s' i computed: .+", entry))
	if !rpGeneralFormat.MatchString(string(actual)) {
		t.Errorf(fmt.Sprintf("Unexpected message format: %s\n", actual))
	}
	rpExtractHash := regexp.MustCompile(fmt.Sprintf("(?:^Hi, for the value '%s' i computed[:] )([^\t\n\f\r ]+).*", entry))
	extractedValues := rpExtractHash.FindStringSubmatch(string(actual))
	if len(extractedValues) <= 1 {
		t.Fatal("Unable to extract the hash from the server")
	}
	server_hash := extractedValues[1]
	err = bcrypt.CompareHashAndPassword([]byte(server_hash), []byte(entry))
	if err != nil {
		t.Errorf(fmt.Sprintf("The hash '%s' and the plain password '%s' are not equivalent", server_hash, entry))
	}
}

func TestBasicBCryptServer(t *testing.T) {
	entries := []string{"", "hello", "world"}
	for _, entry := range entries {
		testBCryptEntry(t, entry)
	}
}

func TestVersion(t *testing.T) {
	req, _ := http.NewRequest("GET", "/_version", nil)
	w := httptest.NewRecorder()
	handlerVersion(w, req)
	if w.Code != http.StatusOK {
		t.Errorf("The server didn't return %v", http.StatusOK)
	}
	actual, err := ioutil.ReadAll(w.Body)
	if err != nil {
		t.Fatal(err)
	}
	rpGeneralFormat := regexp.MustCompile(fmt.Sprintf("version: %s\nbuild date: %s\n", VERSION, BUILD_DATE))
	if !rpGeneralFormat.MatchString(string(actual)) {
		t.Errorf(fmt.Sprintf("Unexpected version format: %s\n", actual))
	}
}
