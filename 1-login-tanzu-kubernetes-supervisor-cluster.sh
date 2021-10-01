#!/bin/bash
kubectl vsphere login --server=${SUPERVISOR_CLUSTER_CONTROL_PLANE_IP} \
--vsphere-username ${VCENTER_SSO_USER_NAME} \
--insecure-skip-tls-verify

kubectl config get-contexts
kubectl get nodes
