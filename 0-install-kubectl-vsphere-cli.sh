#!/bin/bash
apt install unzip -y
unzip -o utils/vsphere-plugin.zip -d /tmp
install /tmp/bin/kubectl /usr/bin/
kubectl version
install /tmp/bin/kubectl-vsphere /usr/bin
kubectl vsphere version
