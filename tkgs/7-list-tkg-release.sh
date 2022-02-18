#!/bin/bash

kubectl get tanzukubernetesreleases --sort-by=.metadata.name -o=custom-columns=TKR_Name:.metadata.name,Version:.spec.kubernetesVersion
