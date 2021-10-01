#!/bin/bash

source source-environment

kubectl vsphere login --server=${SUPERVISOR_CLUSTER_CONTROL_PLANE_IP} \
--vsphere-username ${VCENTER_SSO_USER_NAME} \
--insecure-skip-tls-verify

echo
kubectl config use-context ${TANZU_KUBERNETES_CLUSTER_NAMESPACE}
kubectl get nodes
