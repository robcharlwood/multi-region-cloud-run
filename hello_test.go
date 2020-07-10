package main

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/labstack/echo/v4"
	"github.com/stretchr/testify/assert"
)

func TestHealth(t *testing.T) {
	// Setup
	e := echo.New()
	req := httptest.NewRequest(http.MethodGet, "/health", nil)
	rec := httptest.NewRecorder()
	c := e.NewContext(req, rec)
	c.SetPath("/health/")

	// Assertions
	if assert.NoError(t, health(c)) {
		assert.Equal(t, http.StatusOK, rec.Code)
		assert.Equal(t, "{\n	\"status\": \"OK\"\n}\n", rec.Body.String())
	}
}

func TestHelloWorld(t *testing.T) {
	// Setup
	e := echo.New()
	req := httptest.NewRequest(http.MethodGet, "/", nil)
	rec := httptest.NewRecorder()
	c := e.NewContext(req, rec)
	c.SetPath("/")

	// Assertions
	if assert.NoError(t, helloWorld(c)) {
		assert.Equal(t, http.StatusOK, rec.Code)
		assert.Equal(
			t,
			"{\n	\"message\": \"Hello world!\",\n	\"region\": \"localhost\"\n}\n",
			rec.Body.String(),
		)
	}
}
