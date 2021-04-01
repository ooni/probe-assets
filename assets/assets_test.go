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
	t.Log(record)
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
	t.Log(record)
}
