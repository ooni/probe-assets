// Command verify verifies the correcntess of a MaxMind DB.
package main

import (
	"fmt"
	"os"

	"github.com/oschwald/maxminddb-golang"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Fprintf(os.Stderr, "usage: ./verify {database}...\n")
		os.Exit(1)
	}
	var exitcode int
	for _, filename := range os.Args[1:] {
		mmdb, err := maxminddb.Open(filename)
		if err != nil {
			fmt.Fprintf(os.Stderr, "warning: maxminddb.Open %s: %s\n", filename, err.Error())
			exitcode++
			continue
		}
		if err := mmdb.Verify(); err != nil {
			fmt.Fprintf(os.Stderr, "fatal: mmdb.Verify %s: %s\n", filename, err.Error())
			exitcode++
			continue
		}
		fmt.Printf("%s: OK\n", filename)
	}
	if exitcode > 0 {
		exitcode = 1
	}
	os.Exit(exitcode)
}
