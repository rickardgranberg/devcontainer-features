#!/usr/bin/env bash

PROTOC_VER=${VERSION:-"23.0"}
ARCH="$(uname -m)"
# Install proto compiler

has_wget=$(which wget)
set -e

if [[ -z "$has_wget" ]]; then
    apt-get update -y
    apt-get -y install --no-install-recommends wget ca-certificates unzip
fi

wget -q https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VER}/protoc-${PROTOC_VER}-linux-${ARCH}.zip
unzip -qq protoc-${PROTOC_VER}-linux-${ARCH}.zip
mv bin/protoc /usr/local/bin/
chmod 0755 /usr/local/bin/protoc
mv include/google /usr/local/include/
chmod -R a+rX /usr/local/include/google
rm -f protoc-${PROTOC_VER}-linux-${ARCH}.zip 

