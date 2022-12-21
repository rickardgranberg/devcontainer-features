#!/bin/bash

echo "Activating feature 'oh-my-posh'"

# Ensures depdendencies are installed
has_wget=$(which wget)
set -e

if [[ -z "$has_wget" ]]; then
    apt-get update -y
    apt-get -y install --no-install-recommends wget ca-certificates
fi

version=${VERSION:-latest}
themeURL=${THEMEURL:-"https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/jandedobbeleer.omp.json"}
themeName=${themeURL##*/}
themeTarget="/home/${_REMOTE_USER}/.poshthemes/${themeName}"

arch=$(uname -m)
if [[ $arch == 'x86_64' ]]; then
    arch='amd64'
elif [[ $arch == 'aarch64' ]]; then
    arch='arm64'
fi

installURL=https://github.com/JanDeDobbeleer/oh-my-posh/releases/${version}/download/posh-linux-${arch}
    
if [[ $version != "latest" ]]; then
    version=v${version}
    installURL=https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/${version}/posh-linux-${arch}
fi

wget ${installURL} -O /usr/local/bin/oh-my-posh
chmod +x /usr/local/bin/oh-my-posh

mkdir -p /home/${_REMOTE_USER}/.poshthemes
wget ${themeURL} -O ${themeTarget}
chown ${_REMOTE_USER}:${_REMOTE_USER} ${themeTarget}

# zsh
zshSnippet="eval \"\$(oh-my-posh init zsh --config '${themeTarget}')\""

# bash
bashSnippet="eval \"\$(oh-my-posh init bash --config '${themeTarget}')\""

echo "${zshSnippet}" | tee -a /root/.zshrc >> /home/${_REMOTE_USER}/.zshrc
echo "${bashSnippet}" | tee -a /root/.bashrc >> /home/${_REMOTE_USER}/.bashrc
