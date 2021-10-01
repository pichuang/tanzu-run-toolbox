#!/bin/bash

# Ref
# SSH to Tanzu Kubernetes Cluster Nodes as the System User Using a Password
# https://docs.vmware.com/en/VMware-vSphere/7.0/vmware-vsphere-with-tanzu/GUID-37DC1DF2-119B-4E9E-8CA6-C194F39DDEDA.html

source source-environment

kubectl config use-context ${TANZU_KUBERNETES_CLUSTER_NAMESPACE}

echo ===
echo List of VMs and IPs
echo ===

kubectl get virtualmachines -o=custom-columns=VM_NAME:.metadata.name,VM_IP:.status.vmIp

#
# Obtain SSH Password
#

SSH_PASSWORD=$(kubectl get secrets $TANZU_KUBERNETES_CLUSTER_NAME-ssh-password -o jsonpath='{.data}' | jq -r .[] | base64 --decode)

#
# Obtain first control plan VM IPs
#

SPECIFIC_CONTROL_VM_NAME=$(kubectl get virtualmachines -o=custom-columns=:.metadata.name --no-headers | grep "control-plane" | head -1)

# echo $SPECIFIC_CONTROL_VM_NAME

VM_IP=$(kubectl get virtualmachines $SPECIFIC_CONTROL_VM_NAME -o jsonpath='{.status.vmIp}')

echo
echo "Control VM - $SPECIFIC_CONTROL_VM_NAME IP: $VM_IP"
echo "SSH Username: vmware-system-user"
echo "SSH Password: $SSH_PASSWORD"
echo

echo Use:
echo "ssh vmware-system-user@$VM_IP"
echo
