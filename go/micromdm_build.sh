#!/bin/bash
set -x
go get -u github.com/golang/dep/...
go get github.com/micromdm/micromdm
cd $GOPATH/src/github.com/micromdm/micromdm
dep ensure
./release.sh
