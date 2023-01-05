// Command dumpnets dumps the networks inside a MaxMind database.
package main

import (
	"fmt"
	"os"

	"github.com/ooni/probe-assets/assets"
	"github.com/oschwald/maxminddb-golang"
)

func main() {
	if len(os.Args) != 2 {
		fmt.Fprintf(os.Stderr, "usage: ./dumpnets {database}\n")
		os.Exit(1)
	}
	filename := os.Args[1]
	mmdb, err := maxminddb.Open(filename)
	if err != nil {
		fmt.Fprintf(os.Stderr, "warning: maxminddb.Open %s: %s\n", filename, err.Error())
		os.Exit(1)
	}
	nets := mmdb.Networks(maxminddb.SkipAliasedNetworks)
	for nets.Next() {
		var asn assets.OOMMDBRecord
		net, err := nets.Network(&asn)
		if err != nil {
			fmt.Fprintf(os.Stderr, "fatal: nets.Network: %s\n", err.Error())
			os.Exit(1)
		}
		fmt.Printf("%s, %d\n", net.String(), asn.AutonomousSystemNumber)
	}
	if err := nets.Err(); err != nil {
		fmt.Fprintf(os.Stderr, "fatal: nets.Err: %s\n", err.Error())
		os.Exit(1)
	}
}
