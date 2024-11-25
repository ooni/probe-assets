#!/bin/bash
set -euxo pipefail

# Variables you should set when updating:
db_url=https://archive.org/download/ip2country-as/20241101-ip2country_as.mmdb.gz
db_sha256=cf770566b32d8b1b446032921d183c7cfb8e30e96eefff36dbb0aebbd05d7f85

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
