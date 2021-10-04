## Gather Logs
1. 於跳板機部署一次 tkc.yaml
2. 切換至 TKC 叢集，如使用以下示意用 Script
```bash
kubectl vsphere login --server=${SUPERVISOR_CLUSTER_CONTROL_PLANE_IP} \
--vsphere-username ${VCENTER_SSO_USER_NAME} \
--tanzu-kubernetes-cluster-namespace ${TANZU_KUBERNETES_CLUSTER_NAMESPACE} \
--tanzu-kubernetes-cluster-name ${TANZU_KUBERNETES_CLUSTER_NAME} \
--insecure-skip-tls-verify
```

4. 於跳板機執行 `gather.sh`
5. 針對最後 kubectl get pods --all-namespaces |grep -vi "Running" >> log 產生出來非 Running 狀態的 Pods 進行 Log Collection ，詳細如圖

![](dump-failed-pod-logs.png)

5. 截圖收集
