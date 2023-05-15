#!/usr/bin/env bash

patissuer_ver=${VERSION:-"0.1.12"}
arch="$(uname -m)"

if [[ $arch == 'x86_64' ]]; then
    arch='amd64'
elif [[ $arch == 'aarch64' ]]; then
    arch='arm64'
fi

# Install patissuer for use of private repos:
# Add this to derived images to support CI/CD:
#ARG GOGET_PAT_TOKEN
#ENV GOGET_PAT_TOKEN=${GOGET_PAT_TOKEN}
has_wget=$(which wget)
has_xdg=$(which xdg-open)
set -e

if [[ -z "$has_wget" || -z "$has_xdg" ]]; then
    apt-get update -y
    apt-get -y install --no-install-recommends --reinstall wget ca-certificates unzip libnss3-tools xdg-utils dnsutils netcat
    apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*
fi


wget -q https://github.com/rickardgranberg/patissuer/releases/download/v${patissuer_ver}/patissuer_${patissuer_ver}_linux_${arch}.zip
unzip -qqo patissuer_${patissuer_ver}_linux_${arch}.zip
mv patissuer /usr/local/bin/
chmod 0755 /usr/local/bin/patissuer
rm -f patissuer_${patissuer_ver}_linux_${arch}.zip

install_dir=${_REMOTE_USER_HOME}/.patissuer

mkdir -p ${install_dir}
chown -R ${_REMOTE_USER}:${_REMOTE_USER} ${install_dir}
cp devops-auth.sh ${install_dir}
chmod +rx ${install_dir}/devops-auth.sh

cat << EOF > ${install_dir}/patissuer.env
export PATISSUER_AAD_TENANT_ID=${AADTENANTID}
export PATISSUER_AAD_CLIENT_ID=${AADCLIENTID}
export PATISSUER_ORG_URL=https://${AZDOFQDN}/${AZDOORGANIZATION}
export PATISSUER_TOKEN_SCOPE=${TOKENSCOPE}
export AZDO_FQDN=${AZDOFQDN}
export AZDO_ORG_NAME=${AZDOORGANIZATION}
export AZDO_PROJECT_NAME=${AZDOPROJECT}
export AZDO_ORG_PROJECT_NAME=${AZDOORGANIZATION}/${AZDOPROJECT}
export AZDO_NPM_ARTIFACT_FEED=${AZDONPMARTIFACTFEED}
export GIT_ALIAS=${GITALIAS}
export TOKEN_VAR=${TOKENVARIABLE}
EOF

# Add things to run when shell starts
cat << EOF > ${install_dir}/entrypoint.sh
#!/bin/bash
    . \${HOME}/.patissuer/devops-auth.sh \${${TOKENVARIABLE}}
fi
EOF
chmod +rx ${install_dir}/entrypoint.sh

add_auth="$(cat << 'EOF'
. ${HOME}/.patissuer/entrypoint.sh
EOF
)"

echo "${add_auth}"  >> ${_REMOTE_USER_HOME}/.bashrc
