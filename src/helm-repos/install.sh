#!/bin/bash

echo "Adding Helm repos"

repos=()
IFS=',' read -ra repos <<< "${REPOS}"

for r in "${repos[@]}"; do
    kv=()
    IFS="=" read -ra kv <<< "${r}"
    helm repo add ${kv[0]} ${kv[1]}
done

helm repo update

# Move config over from root to $_REMOTE_USER_HOME (Helm/NATS/etc.)
cp -r /root/.config/ ${_REMOTE_USER_HOME}/
chown -R ${_REMOTE_USER}:${_REMOTE_USER} ${_REMOTE_USER_HOME}/.config/ 
