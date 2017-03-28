#!/bin/bash
# This script downloads harpoon from github, builds a binary, and stores it in /usr/local/bin/.
# Harpoon is used to read webhooks from github and trigger builds.
set -x
source_path=$(dirname "${0}"); cd "${source_path}"

unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
docker pull golang:1.8
docker run --rm -v "$(pwd)"/go:/go golang:1.8 \
  /bin/bash -c "go get -u github.com/agrison/harpoon; cd /go/src/github.com/agrison/harpoon; go build"
mv go/bin/harpoon /usr/local/bin/harpoon
else
echo "This script needs to be ran on a Linux host."
exit 1
fi
