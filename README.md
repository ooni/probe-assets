# OONI Probe Assets

[![Build Status](https://travis-ci.org/ooni/probe-assets.svg?branch=master)](https://travis-ci.org/ooni/probe-assets)

Repository for packaging generic OONI and MK assets. It includes MaxMind DB
files and the CA bundle retrieved from CURL. Go consumers should vendor and use
`assets.go`. A monthly build on Travis ensures that assets are up to date.

This product includes GeoLite2 data created by MaxMind, available from
<a href="http://www.maxmind.com">http://www.maxmind.com</a>.
