#!/bin/bash
set -e
set -o pipefail

assets_go=assets.go
asn_database_name=asn.mmdb
ca_bundle_name=ca-bundle.pem
country_database_name=country.mmdb
sha256sums=SHA256SUMS

# assets_get_geoip is copied from MK v0.10.0. It downloads the
# maxmind DB databases from MaxMind's site.
assets_get_geoip() {
    echo "* Fetching geoip databases"
    base=https://geolite.maxmind.com/download/geoip/database
    if [ ! -f "$country_database_name" ]; then
        curl -fsSLO $base/GeoLite2-Country.tar.gz
        tar -xf GeoLite2-Country.tar.gz
        mv GeoLite2-Country_20??????/GeoLite2-Country.mmdb $country_database_name
        rm -rf GeoLite2-Country_20?????? GeoLite2-Country.tar.gz
    fi
    if [ ! -f "$asn_database_name" ]; then
        curl -fsSLO $base/GeoLite2-ASN.tar.gz
        tar -xf GeoLite2-ASN.tar.gz
        mv GeoLite2-ASN_20??????/GeoLite2-ASN.mmdb $asn_database_name
        rm -rf GeoLite2-ASN_20?????? GeoLite2-ASN.tar.gz
    fi
}

# assets_rewrite_assets_go rewrites $assets_go
assets_rewrite_assets_go() {
  echo "* Updating $assets_go"
  rm -rf $assets_go
  echo "package resources"                                         >> $assets_go
  echo ""                                                          >> $assets_go
  echo "const ("                                                   >> $assets_go
  echo "  // Version contains the assets version."                 >> $assets_go
  echo "  Version = $1"                                            >> $assets_go
  echo ""                                                          >> $assets_go
  echo "  // ASNDatabaseName is the ASN-DB file name"              >> $assets_go
  echo "  ASNDatabaseName = \"$asn_database_name\""                >> $assets_go
  echo ""                                                          >> $assets_go
  echo "  // CABundleName is the name of the CA bundle file"       >> $assets_go
  echo "  CABundleName = \"$ca_bundle_name\""                      >> $assets_go
  echo ""                                                          >> $assets_go
  echo "  // CountryDatabaseName is country-DB file name"          >> $assets_go
  echo "  CountryDatabaseName = \"$country_database_name\""        >> $assets_go
  echo ""                                                          >> $assets_go
  echo "  // RepositoryURL is the asset's repository URL"          >> $assets_go
  echo "  RepositoryURL = \"https://github.com/ooni/probe-assets\"" >> $assets_go
  echo ")"                                                         >> $assets_go
  echo ""                                                          >> $assets_go
  echo "// ResourceInfo contains information on a resource."       >> $assets_go
  echo "type ResourceInfo struct {"                                >> $assets_go
  echo "  // URLPath is the resource's URL path."                  >> $assets_go
  echo "  URLPath string"                                          >> $assets_go
  echo ""                                                          >> $assets_go
  echo "  // GzSHA256 is used to validate the downloaded file."    >> $assets_go
  echo "  GzSHA256 string"                                         >> $assets_go
  echo ""                                                          >> $assets_go
  echo "  // SHA256 is used to check whether the assets file"      >> $assets_go
  echo "  // stored locally is still up-to-date."                  >> $assets_go
  echo "  SHA256 string"                                           >> $assets_go
  echo "}"                                                         >> $assets_go
  echo ""                                                          >> $assets_go
  echo "// All contains info on all known assets."                 >> $assets_go
  echo "var All = map[string]ResourceInfo{"                        >> $assets_go
  for name in $asn_database_name $ca_bundle_name $country_database_name; do
    local gzsha256=$(grep $name.gz$ $sha256sums | awk '{print $1}')
    local sha256=$(grep $name$ $sha256sums | awk '{print $1}')
    if [ -z $gzsha256 -o -z $sha256 ]; then
      echo "FATAL: cannot get GzSHA256 or SHA256" 1>&2
      exit 1
    fi
    echo "    \"$name\": ResourceInfo{"                           >> $assets_go
    echo "      URLPath: \"/releases/download/$1/$name.gz\","     >> $assets_go
    echo "      GzSHA256: \"$gzsha256\","                         >> $assets_go
    echo "      SHA256: \"$sha256\","                             >> $assets_go
    echo "    },"                                                 >> $assets_go
  done
  echo "}"                                                        >> $assets_go
  go fmt $assets_go
}

rm -rf assets
mkdir assets
version=`date +%Y%m%d%H%M%S`
assets_get_geoip
curl -fsSLo $ca_bundle_name https://curl.haxx.se/ca/cacert.pem
mv $ca_bundle_name assets/
mv $asn_database_name assets/
mv $country_database_name assets/
rm -rf $sha256sums
shasum -a 256 assets/*                                           >> $sha256sums
go build -v ./cmd/gzipidempotent
(
  set -x
  cd assets
  ../gzipidempotent
)
for file in assets/*.gz; do
  gunzip -c $file > AAA_temporary
  cmp $(echo $file|sed 's/.gz$//g') AAA_temporary
  rm AAA_temporary
done
shasum -a 256 assets/*.mmdb.gz assets/*.pem.gz                   >> $sha256sums
if git diff --quiet; then
  echo "Nothing changed, nothing to do."
  exit 0
fi
assets_rewrite_assets_go $version
git add $sha256sums $assets_go
echo "# To continue with the release run"
echo "- git commit -am \"Release $version\""
echo "- git tag -sm \"ooni/probe-assets $version\" $version"
echo "- git push origin master $version"
