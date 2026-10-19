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

This product includes <a href='https://db-ip.com'>IP Geolocation by DB-IP</a>.

Report issues for this repo at https://github.com/ooni/probe/issues.

## Release instructions

1. once a month, after the 3rd (when ooni/historical-geoip publishes a new
database), run `./update.bash` (needs `jq`) to point `prepare.bash` at the
newest database, and merge that into master; if it says `prepare.bash`
already uses the newest database, there is nothing to release;

2. run `./build.bash` on master

3. follow on-screen instructions.
