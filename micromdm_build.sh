#!/bin/bash
# This script downloads micromdm + dependencies to build the binaries
set -x
go get -u github.com/golang/dep/...
go get -u github.com/micromdm/micromdm
cd $GOPATH/src/github.com/micromdm/micromdm
dep ensure
./release.sh
