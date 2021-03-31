// Package assets contains the embedded assets
package assets

import _ "embed"

//go:embed asn.mmdb.gz
var asnDatabaseDataGzip []byte

// ASNDatabaseDataGzip returns the gzipped ASN database data.
func ASNDatabaseDataGzip() []byte {
	return asnDatabaseDataGzip
}

//go:embed country.mmdb.gz
var countryDatabaseDataGzip []byte

// CountryDatabaseDataGzip returns the gzipped country database data.
func CountryDatabaseDataGzip() []byte {
	return countryDatabaseDataGzip
}
