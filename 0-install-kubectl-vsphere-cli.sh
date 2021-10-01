#!/bin/bash

## Install Kubectl
unzip -o utils/vsphere-plugin.zip -d /tmp
install /tmp/bin/kubectl /usr/bin/
kubectl version
install /tmp/bin/kubectl-vsphere /usr/bin
kubectl vsphere version

## Install Autocomplete
source <(kubectl completion bash)
echo "source <(kubectl completion bash)" >> ~/.bashrc

## Set alias of kubectl to k
echo "alias k='kubectl'" >> ~/.bashrc
complete -F __start_kubectl k
