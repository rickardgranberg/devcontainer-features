#!/usr/bin/env bash

DOCKERSCOUT_VER=${VERSION:-"0.12.0"}
# Install Docker Scout CLI plugin

arch="$(uname -m)"

if [[ $arch == 'x86_64' ]]; then
    arch='amd64'
elif [[ $arch == 'aarch64' ]]; then
    arch='arm64'
fi

has_wget=$(which wget)
set -e

if [[ -z "$has_wget" ]]; then
    apt-get update -y
    apt-get -y install --no-install-recommends --reinstall wget ca-certificates
    apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*
fi

install_dir=/usr/bin
wget -q https://github.com/docker/scout-cli/releases/download/v${DOCKERSCOUT_VER}/docker-scout_${DOCKERSCOUT_VER}_linux_${arch}.tar.gz
tar -xvf docker-scout_${DOCKERSCOUT_VER}_linux_${arch}.tar.gz
mv docker-scout ${install_dir}
chmod 0755 ${install_dir}/docker-scout
rm -f docker-scout_${DOCKERSCOUT_VER}_linux_${arch}.tar.gz

install_scout="$(cat << EOF
if [[ ! -f \${HOME}/.docker/cli-plugins/docker-scout ]]; then
    mkdir -p \${HOME}/.docker/cli-plugins
    cp ${install_dir}/docker-scout \${HOME}/.docker/cli-plugins/
fi
EOF
)"

echo "${install_scout}" | tee -a /root/.bashrc >> ${_REMOTE_USER_HOME}/.bashrc
