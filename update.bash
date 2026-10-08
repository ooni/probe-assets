#!/bin/bash
set -euo pipefail

# Point prepare.bash at the newest ip2country-as database on archive.org.
# Does nothing when prepare.bash already uses it.

item=ip2country-as
metadata=$(curl -fsSL https://archive.org/metadata/$item)
latest=$(jq -r '[.files[].name | select(test("^[0-9]{8}-ip2country_as\\.mmdb\\.gz$"))] | sort | last' <<<"$metadata")
current=$(sed -n 's|^db_url=.*/||p' prepare.bash | tr -d '[:space:]')

if [[ $latest == "null" ]]; then
	echo "FATAL: no database found in archive.org/details/$item" 1>&2
	exit 1
fi
if [[ ! $latest > $current ]]; then
	echo "prepare.bash already uses the newest database, $current"
	exit 0
fi

db_url=https://archive.org/download/$item/$latest
db_gzfile=$(mktemp)
trap 'rm -f "$db_gzfile"' EXIT
curl -fsSLo "$db_gzfile" "$db_url"

# Check the download against the checksum archive.org publishes.
expected_sha1=$(jq -r --arg name "$latest" '.files[] | select(.name == $name) | .sha1' <<<"$metadata")
if [[ $(shasum -a1 "$db_gzfile" | awk '{print $1}') != "$expected_sha1" ]]; then
	echo "FATAL: $latest does not match the sha1sum archive.org publishes" 1>&2
	exit 1
fi
db_sha256=$(shasum -a256 "$db_gzfile" | awk '{print $1}')

sed -i.bak -e "s|^db_url=.*|db_url=$db_url|" -e "s|^db_sha256=.*|db_sha256=$db_sha256|" prepare.bash
rm prepare.bash.bak
echo "prepare.bash now uses $latest instead of $current"
