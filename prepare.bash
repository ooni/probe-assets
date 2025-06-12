#!/bin/bash
set -euxo pipefail

# Variables you should set when updating:
db_url=https://archive.org/download/ip2country-as/20250601-ip2country_as.mmdb.gz	
db_sha256=46e151c64dbf39e619e561643b314e337325f5fd3ab339f19c82070f8db3d4b1

# Remove leftovers.
rm -f ./assets/*.mmdb ./assets/*.mmdb.gz

db_file=./assets/geoinfo.mmdb
db_gzfile=$db_file.gz
curl -fsSLo $db_gzfile $db_url
checksum=$(shasum -a256 $db_gzfile | awk '{print $1}')
gunzip -k $db_gzfile
if [ "$checksum" != "$db_sha256" ]; then
	echo "FATAL: database does not match the expected sha256sum" 1>&2
	exit 1
fi

# Verify the downloaded database.
go run ./cmd/verify $db_file

# Make sure the database does not emit smoke.
set -x
go test -v ./...
set +x
