#!/bin/bash
# This script is called via a Github webhook when changes are made to the
# master branch. It builds the binaries (via micromdm_build.sh) then wraps the
# output directory to a zip file. Then moves to the web share.
set -x
source_path=$(dirname "${0}"); cd "${source_path}"

unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
VERSION="$(build/micromdm-linux-amd64 version | awk '{print $3}')"
else
echo "This script needs to be ran on a Linux host."
exit 1
fi
docker pull golang:1.8
docker run --rm -v "$(pwd)"/go:/go \
  -v "$(pwd)"/micromdm_build.sh:/micromdm_build.sh \
  golang:1.8 \
  /micromdm_build.sh
cd go/src/github.com/micromdm/micromdm
zip -r "$VERSION".zip build

# This sed command does not provide a Darwin safe json file
cat << EOF > "$VERSION".json
{
  "git_commit": "$(git rev-parse HEAD)",
  "git_message": "$(git --no-pager log -1 --pretty=%B | sed -E ':a;N;$!ba;s/\r{0,1}\n/\\n/g')"
}
EOF

mv "$VERSION".* ../../../../../www/
