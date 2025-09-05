#!/bin/bash
set -euxo pipefail

# Variables you should set when updating:
db_url=https://archive.org/download/ip2country-as/20250801-ip2country_as.mmdb.gz	
db_sha256=75c26b4f1f210ce5d477e9a8a68b9eabb0e8ff67fba5ccc459fa09bf6520a7b7

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
