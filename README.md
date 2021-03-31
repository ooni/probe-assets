# OONI Probe Assets

[![Open issues](https://img.shields.io/github/issues-raw/ooni/probe-engine/assets)](https://github.com/ooni/probe-engine/issues?q=label%3Aassets+is%3Aopen)

Repository for packaging generic OONI assets. It includes MaxMind DB files
retrieved from CURL. Every release is a different branch to avoid making
the history of the main branch too heavy. You should pin your golang code
to the most recent branch using:

```bash
go get -v github.com/ooni/probe-assets@HEAD
```
where HEAD is the most recent commit inside such a branch.

This product includes GeoLite2 data created by MaxMind, available from
<a href="https://www.maxmind.com">https://www.maxmind.com</a>. This product
includes <a href='https://db-ip.com'>IP Geolocation by DB-IP</a>.

Report issues for this repo at https://github.com/ooni/probe-engine/issues.
