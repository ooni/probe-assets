#!/bin/bash
set -euxo pipefail

# Variables you should set when updating. You SHOULD check on
# https://db-ip.com/ if a new version is available.
db_url=https://archive.org/download/ip2country-as/20230501-ip2country_as.mmdb.gz
db_sha256=d2fc4c8f9d8d0b8fe8ef695d49f711d82c2d23c3dd7ba1995956055480a56b4c

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
