#!/bin/sh
set -ex

# autogen_get_geoip is copied from MK v0.10.0. It downloads the
# maxmind DB databases from MaxMind's site.
autogen_get_geoip() {
    echo "* Fetching geoip databases"
    base=https://geolite.maxmind.com/download/geoip/database
    if [ ! -f "country.mmdb" ]; then
        curl -fsSLO $base/GeoLite2-Country.tar.gz
        tar -xf GeoLite2-Country.tar.gz
        mv GeoLite2-Country_20??????/GeoLite2-Country.mmdb country.mmdb
        rm -rf GeoLite2-Country_20??????
    fi
    if [ ! -f "asn.mmdb" ]; then
        curl -fsSLO $base/GeoLite2-ASN.tar.gz
        tar -xf GeoLite2-ASN.tar.gz
        mv GeoLite2-ASN_20??????/GeoLite2-ASN.mmdb asn.mmdb
        rm -rf GeoLite2-ASN_20??????
    fi
}

version=`date +%Y%m%d`
autogen_get_geoip
curl -fsSLo ca-bundle.pem https://curl.haxx.se/ca/cacert.pem
tar -cvzf "generic-assets-${version}.tar.gz"                                   \
  "README.md" "asn.mmdb" "ca-bundle.pem" "country.mmdb"
