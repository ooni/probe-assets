package assets

import (
	"bytes"
	"compress/gzip"
	"io/ioutil"
	"net"
	"testing"

	"github.com/oschwald/geoip2-golang"
)

func TestASN(t *testing.T) {
	data := ASNDatabaseDataGzip()
	reader, err := gzip.NewReader(bytes.NewReader(data))
	if err != nil {
		t.Fatal(err)
	}
	defer reader.Close()
	data, err = ioutil.ReadAll(reader)
	if err != nil {
		t.Fatal(err)
	}
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
	data := CountryDatabaseDataGzip()
	reader, err := gzip.NewReader(bytes.NewReader(data))
	if err != nil {
		t.Fatal(err)
	}
	defer reader.Close()
	data, err = ioutil.ReadAll(reader)
	if err != nil {
		t.Fatal(err)
	}
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
