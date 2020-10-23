# OONI Probe Assets

![build](https://github.com/ooni/probe-assets/workflows/build/badge.svg) [![Open issues](https://img.shields.io/github/issues-raw/ooni/probe-engine/assets)](https://github.com/ooni/probe-engine/issues?q=label%3Aassets+is%3Aopen)

Repository for packaging generic OONI assets. It includes MaxMind DB files
retrieved from CURL. Go consumers should vendor and use `assets.go`. A periodic
build on GitHub actions ensures that assets are up to date.

This product includes GeoLite2 data created by MaxMind, available from
<a href="https://www.maxmind.com">https://www.maxmind.com</a>. This product
includes <a href='https://db-ip.com'>IP Geolocation by DB-IP</a>.
