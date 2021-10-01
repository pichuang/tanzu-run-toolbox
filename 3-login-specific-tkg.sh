#!/bin/bash

source source-environment

kubectl vsphere login --server=${SUPERVISOR_CLUSTER_CONTROL_PLANE_IP} \
--vsphere-username ${VCENTER_SSO_USER_NAME} \
--tanzu-kubernetes-cluster-namespace ${TANZU_KUBERNETES_CLUSTER_NAMESPACE} \
--tanzu-kubernetes-cluster-name ${TANZU_KUBERNETES_CLUSTER_NAME} \
--insecure-skip-tls-verify

kubectl config get-contexts
kubectl get nodes
