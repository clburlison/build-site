#!/bin/bash
# This script is called via a Github webhook when changes are made to the
# master branch. It builds the binaries (via micromdm_build.sh) then wraps the
# output directory to a zip file. Then moves to the web share.
set -x
source_path=$(dirname "${0}"); cd "${source_path}"

VERSION=None

unamestr=`uname`
if [[ "$unamestr" != 'Linux' ]]; then
echo "This script needs to be ran on a Linux host."
exit 1
fi
docker pull golang:1.8
docker run --rm -v "$(pwd)"/go:/go \
  -v "$(pwd)"/micromdm_build.sh:/micromdm_build.sh \
  golang:1.8 \
  /micromdm_build.sh > build.log 2>&1
cd go/src/github.com/micromdm/micromdm
VERSION="$(build/micromdm-linux-amd64 version | awk '{print $3}')"

# Validate that we got a proper version
if [ "$VERSION" == "None" ]; then
echo "A valid version was not found."
exit 1
fi

# Check if we already have a build with this version
if [ -d "/build-site/www/$VERSION" ]; then
echo "We have already built this version. Please remove from www if you need to rebuild."
exit 2
fi

rm -rf /tmp/"$VERSION"
mkdir -p /tmp/"$VERSION"
zip -r /tmp/"$VERSION"/"$VERSION".zip build

MD5_HASH=$(md5 -q /tmp/"$VERSION"/"$VERSION".zip)

# write info.html
cat << EOF > /tmp/"$VERSION"/info.html
<text class="info">
<br>$(git --no-pager show -s --format='%an') - $(git --no-pager show -s --format='%ad' --date=short)<br><br>
Commit Message: $(git --no-pager log -1 --pretty=%B)<br><br>
More details: <a href="https://github.com/micromdm/micromdm/commit/$(git rev-parse HEAD)">$(git rev-parse HEAD)</a><br><br>
MD5: $(MD5_HASH)
</text>
EOF

# write md5 hash file
echo $MD5_HASH > /tmp/"$VERSION"/MD5

# move build log
mv ./build.log > /tmp/"$VERSION"/

mv /tmp/"$VERSION" ../../../../../www/
rm -rf /tmp/"$VERSION"
