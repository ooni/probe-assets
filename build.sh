#!/bin/sh
set -e

# Variables you should set when updating. You SHOULD probably go to
# https://github.com/ooni/asn-db-generator and follow the release
# procedure described in README.md to generate a new asn.mmdb file.
#
# Regarding the country database, you SHOULD check if a new version
# is available, update the URL and the sha1sum (they don't provide
# anything better than SHA1, so I guess we have to live with it).
country_db_url=https://download.db-ip.com/free/dbip-country-lite-2021-03.mmdb.gz
country_db_sha1sum=35ca83d9210ca48696918a12f1d24d22754f803a
asn_db_url=https://github.com/ooni/asn-db-generator/releases/download/20210331153739/asn.mmdb.gz
asn_db_sha256sum=8705e2afa2b8422cf54fedd707597a06e2737516a5ca72179b37bc717963b21b

# Make sure you are in the master branch of the repository.
if [ "`git branch --show-current`" != "master" ]; then
  echo "FATAL: not on the master branch" 1>&2
  exit 1
fi

# Remove leftovers.
set -x
rm -f ./assets/*.mmdb ./assets/*.mmdb.gz
set +x

# Fetch the country DB file, decompress and verify it.
country_db_file=./assets/country.mmdb
country_db_gzfile=${country_db_file}.gz
set -x
curl -fsSLo $country_db_gzfile $country_db_url
gunzip -k $country_db_gzfile
set +x
sha1sum=`shasum -a1 $country_db_file | awk '{print $1}'`
if [ "$sha1sum" != "$country_db_sha1sum" ]; then
  echo "FATAL: country database does not match the expected sha1sum" 1>&2
  exit 1
fi

# Fetch the asn DB file, verify and decompress it.
asn_db_gzfile=./assets/asn.mmdb.gz
set -x
curl -fsSLo $asn_db_gzfile $asn_db_url
set +x
sha256sum=`shasum -a256 $asn_db_gzfile | awk '{print $1}'`
if [ "$sha256sum" != "$asn_db_sha256sum" ]; then
  echo "FATAL: asn database does not match the expected sha256sum" 1>&2
  exit 1
fi
gunzip -k $asn_db_gzfile

# Make sure what we have downloaded does not emit smoke.
go test -v ./...

# Instructions to make a release.
version=`date +%Y%m%d%H%M%S`
echo "Now you should run the following commands:"
echo ""
echo "- git checkout -b vendor-$version"
echo "- git add assets/*.mmdb"
echo "- git commit -am \"Release $version\""
echo "- git push origin vendor-$version"
echo ""
echo "For updating, you need to go in github.com/ooni/probe-cli and run:"
echo ""
echo "- go get -v github.com/ooni/probe-assets@HEAD"
echo ""
echo "Where HEAD is the latest commit in the vendor-$version branch."
