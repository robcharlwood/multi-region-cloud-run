package main

import (
	"net/http"
	"os"

	"github.com/facebookgo/grace/gracehttp"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	"github.com/labstack/gommon/log"
)

func getEnvDefault(key, fallback string) string {
	// handles returning env vars or the specified default
	// if it doest not exist
	if value, ok := os.LookupEnv(key); ok {
		return value
	}
	return fallback
}

var host string = getEnvDefault("K_SERVICE", "localhost")

func main() {
	e := echo.New()

	// middleware
	e.Use(middleware.Logger())
	e.Pre(middleware.AddTrailingSlash())
	e.Use(middleware.Secure())
	e.Use(middleware.CORS())
	e.Use(middleware.BodyLimit("1M"))
	e.Use(middleware.Recover())

	// setup logging
	e.Logger.SetLevel(log.INFO)

	// enable HTTPS redirect middleware if not running locally
	if host != "localhost" {
		e.Logger.Info("Enabled HTTPS redirect middleware")
		e.Pre(middleware.HTTPSRedirect())
	}

	// routes
	e.GET("/health/", health)
	e.GET("/", helloWorld)

	// run server with graceful termination
	e.Server.Addr = ":8080"
	e.Logger.Fatal(gracehttp.Serve(e.Server))
}

func health(c echo.Context) error {
	return c.JSONPretty(http.StatusOK, map[string]interface{}{
		"status": "OK",
	}, "	")
}

func helloWorld(c echo.Context) error {
	return c.JSONPretty(http.StatusOK, map[string]interface{}{
		"message": "Hello world!",
		"region":  host,
	}, "	")
}
