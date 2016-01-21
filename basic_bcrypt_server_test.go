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
	req, _ := http.NewRequest("GET", "/"+entry, nil)
	w := httptest.NewRecorder()
	handler(w, req)
	if w.Code != http.StatusOK {
		t.Errorf("The server didn't return %v", http.StatusOK)
	}
	actual, err := ioutil.ReadAll(w.Body)
	if err != nil {
		t.Fatal(err)
	}
	rpGeneralFormat := regexp.MustCompile(fmt.Sprintf("Hi, for the value '%s' i computed: .+", entry))
	if !rpGeneralFormat.MatchString(string(actual)) {
		t.Errorf("Unexpected message format\n")
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
