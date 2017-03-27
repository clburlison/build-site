#!/bin/bash
set -x
source_path=$(dirname "${0}"); cd "${source_path}"
docker pull golang:1.8

docker run --rm -v "$(pwd)"/go:/go golang:1.8 \
  /go/micromdm_build.sh

cd go/src/github.com/micromdm/micromdm
VERSION="$(build/micromdm-linux-amd64 version | awk '{print $3}')"
# VERSION="$(build/micromdm-darwin-amd64 version | awk '{print $3}')"
zip -r "$VERSION".zip build

cat << EOF > "$VERSION".json
{
  "git_commit": "$(git rev-parse HEAD)",
  "git_message": "$(git --no-pager log -1 --pretty=%B | sed -E ':a;N;$!ba;s/\r{0,1}\n/\\n/g')"
}
EOF

mv "$VERSION".* ../../../../../www/
