package assets

import (
	"net"
	"testing"

	"github.com/oschwald/maxminddb-golang"
)

func TestLookupASNAndCountry(t *testing.T) {
	db, err := maxminddb.FromBytes(OOMMDBDatabaseBytes)
	if err != nil {
		t.Fatal(err)
	}
	defer db.Close()
	record, err := OOMMDBLooup(db, net.ParseIP("8.8.8.8"))
	if err != nil {
		t.Fatal(err)
	}
	if record.AutonomousSystemNumber != 15169 {
		t.Fatal("invalid ASN", record.AutonomousSystemNumber)
	}
	if record.AutonomousSystemOrganization != "Google LLC" {
		t.Fatal("invalid organization", record.AutonomousSystemOrganization)
	}
	if record.Country.IsoCode != "US" {
		t.Fatal("invalid country", record.Country.IsoCode)
	}
}
