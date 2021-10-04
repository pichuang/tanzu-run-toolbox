#!/bin/bash
mkdir -p /tmp/tanzu-gather && cd /tmp/tanzu-gather
touch log
kubectl get nodes -owide > log
echo "" >> log
kubectl version >> log
echo "" >> log
kubectl get deployment --all-namespaces >> log
echo "" >> log
kubectl get svc --all-namespaces >> log
echo "" >> log
kubectl get pods --all-namespaces |grep -vi "Running" >> log

