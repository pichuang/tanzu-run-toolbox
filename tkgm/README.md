Tanzu Kubernetes Grid
---
## Q & A
### Q1: kubectl x509: certificate signed by unknown authority

- Reproduce
```bash
$ kubectl run -n debug debug-container --restart=Never --rm -i --tty --image harbor.vmware.local/library/debug-container -- /bin/bash
```

- Error Log
```bash
waiting: rpc error: code = Unknown desc = failed to pull and unpack image "harbor.vmware.local/library/debug-container:latest": failed to resolve reference "harbor.vmware.local/library/debug-container:latest": failed to do request: Head "https://harbor.vmware.local/v2/library/debug-container/manifests/latest": x509: certificate signed by unknown authority
```

A1: 請看`新增額外憑證 (Add Custom CA Certificate Trust to Existing Clusters)`方式

