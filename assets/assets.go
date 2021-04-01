// Package assets contains the embedded assets.
//
// We embed uncompressed GeoIP databases in MaxMind
// format. This design choice makes the binaries larger. But,
// it also allows us to avoid:
//
// 1. Writing the data on a local cache and continuously
// checking the cache to check whether it needs to be
// updated. Therefore, we're reducing the number of disk
// accesses that we perform for every measurement session.
//
// 2. Having to decompress the data and keep it in memory,
// which would cause more memory to be used by the OONI
// process: not only the memory consumed by embedding the
// compressed database, but also the memory consumed by
// caching the uncompressed bytes in cache.
//
// 3. Having the decompress the data each time we use the
// databases, which is causing high CPU usage.
//
// Additionally, this reduces the OONI code complexity.
package assets

import _ "embed"

//go:embed asn.mmdb
var asnDatabaseData []byte

// ASNDatabaseData returns the ASN database data in MaxMind
// format. You can pass these bytes directly to geoip2.FromBytes.
func ASNDatabaseData() []byte {
	return asnDatabaseData
}

//go:embed country.mmdb
var countryDatabaseData []byte

// CountryDatabaseData returns the country database data
// in MaxMind format. You can pass these bytes directly
// to geoip2.FromBytes.
func CountryDatabaseData() []byte {
	return countryDatabaseData
}
