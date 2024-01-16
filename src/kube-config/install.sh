#!/bin/bash

echo "Activating feature kube-config"

 set -e
#
# Copy localhost's ~/.kube/config file into the container and swap out localhost
# for host.docker.internal whenever a new shell starts to keep them in sync.
snippet=$(cat << 'EOF'
if [ -d "/usr/local/share/kube-localhost" ]; then
    mkdir -p $HOME/.kube
    sudo cp /usr/local/share/kube-localhost/* $HOME/.kube
    sudo chown -R $(id -u) $HOME/.kube
    sed -i -e "s/localhost/host.docker.internal/g" $HOME/.kube/config

    if [ -d "/usr/local/share/minikube-localhost" ]; then
        mkdir -p $HOME/.minikube
        sudo cp -r /usr/local/share/minikube-localhost/ca.crt $HOME/.minikube
        sudo cp -r /usr/local/share/minikube-localhost/client.crt $HOME/.minikube
        sudo cp -r /usr/local/share/minikube-localhost/client.key $HOME/.minikube
        sudo chown -R $(id -u) $HOME/.minikube
        sed -i -r "s|(\s*certificate-authority:\s).*|\\1$HOME\/.minikube\/ca.crt|g" $HOME/.kube/config
        sed -i -r "s|(\s*client-certificate:\s).*|\\1$HOME\/.minikube\/client.crt|g" $HOME/.kube/config
        sed -i -r "s|(\s*client-key:\s).*|\\1$HOME\/.minikube\/client.key|g" $HOME/.kube/config
    fi
fi
EOF
)

echo "${snippet}" | tee -a /root/.bashrc /root/.zshrc ${_REMOTE_USER_HOME}/.bashrc >> ${_REMOTE_USER_HOME}/.zshrc

