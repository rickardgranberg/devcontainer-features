#!/bin/bash

echo "Activating feature 'bash-completion'"

installPath="/usr/share/bash-completion/completions/"
# Ensures depdendencies are installed

if [[ ! -d ${installPath} ]]; then
    apt-get update -y
    apt-get -y install --no-install-recommends bash-completion
fi

completions=()
IFS=',' read -ra completions <<< "${COMPLETIONS}"

for c in "${completions[@]}"; do
    snippet=". ${installPath}${c}"
    echo "${snippet}" | tee -a /root/.bashrc >> ${_REMOTE_USER_HOME}/.bashrc
done