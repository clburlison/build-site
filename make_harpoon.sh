#!/bin/bash
set -x
source_path=$(dirname "${0}"); cd "${source_path}"

unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
docker pull golang:1.8
docker run --rm -v "$(pwd)"/go:/go golang:1.8 \
  /bin/bash -c "go get github.com/agrison/harpoon; cd /go/src/github.com/agrison/harpoon; go build"
mv go/bin/harpoon /usr/local/bin/harpoon
fi
