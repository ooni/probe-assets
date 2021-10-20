package assets

import (
	"net"
	"testing"

	"github.com/oschwald/geoip2-golang"
)

func TestASN(t *testing.T) {
	data := ASNDatabaseData()
	db, err := geoip2.FromBytes(data)
	if err != nil {
		t.Fatal(err)
	}
	defer db.Close()
	record, err := db.ASN(net.ParseIP("8.8.8.8"))
	if err != nil {
		t.Fatal(err)
	}
	if record.AutonomousSystemNumber != 15169 {
		t.Fatal("invalid ASN", record.AutonomousSystemNumber)
	}
	if record.AutonomousSystemOrganization != "Google LLC" {
		t.Fatal("invalid organization", record.AutonomousSystemOrganization)
	}
}

func TestCountry(t *testing.T) {
	data := CountryDatabaseData()
	db, err := geoip2.FromBytes(data)
	if err != nil {
		t.Fatal(err)
	}
	defer db.Close()
	record, err := db.Country(net.ParseIP("8.8.8.8"))
	if err != nil {
		t.Fatal(err)
	}
	if record.Country.IsoCode != "US" {
		t.Fatal("invalid country", record.Country.IsoCode)
	}
}
