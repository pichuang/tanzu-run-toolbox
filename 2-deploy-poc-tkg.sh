#!/bin/bash
kubectl apply -f ./tkg/poc-tkg-deploy.yml

kubectl get tkc -o wide
