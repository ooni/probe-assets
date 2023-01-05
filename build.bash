#!/bin/bash
set -euo pipefail

# See https://remarkablemark.org/blog/2017/10/12/check-git-dirty/
[[ -z $(git status -s) ]] || {
	echo "fatal: repository contains modified or untracked files"
	exit 1
}

# Make sure you are in the master branch of the repository.
# See https://git-blame.blogspot.com/2013/06/checking-current-branch-programatically.html
__ref=$(git symbolic-ref --short -q HEAD)
[[ $__ref == "master" || $__ref == "main" ]] || {
	echo "FATAL: not on the master branch" 1>&2
	exit 1
}

./prepare.bash

if [[ $# -ge 1 && $1 == "-n" ]]; then
	exit 0 # dry-run
fi

# Instructions to make a release.
version=$(cat VERSION)
version=$((version + 1))
echo $version >VERSION
set -x
git commit -m "Bump version to 0.$version.0" VERSION
git checkout -b vendor-0.$version.0
git add -f assets/*.mmdb
git commit -am "Release 0.$version.0"
git tag -m "Tag v0.$version.0" -s v0.$version.0
set +x
echo "Now you should run the following commands:"
echo ""
echo "- git push origin master vendor-0.$version.0 v0.$version.0"
echo ""
echo "For updating, you need to go in github.com/ooni/probe-cli and run:"
echo ""
echo "- go get -v github.com/ooni/probe-assets@v0.$version.0"
echo ""
