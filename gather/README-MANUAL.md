## Gather Logs

### 針對 TKC
1. 於跳板機部署一次 tkc.yaml
2. 切換至 TKC 叢集，如使用以下示意用 Script
```bash
kubectl vsphere login --server=${SUPERVISOR_CLUSTER_CONTROL_PLANE_IP} \
--vsphere-username ${VCENTER_SSO_USER_NAME} \
--tanzu-kubernetes-cluster-namespace ${TANZU_KUBERNETES_CLUSTER_NAMESPACE} \
--tanzu-kubernetes-cluster-name ${TANZU_KUBERNETES_CLUSTER_NAME} \
--insecure-skip-tls-verify
```

3. 於跳板機執行 `gather.sh`
4. 針對最後 `kubectl get pods --all-namespaces |grep -vi "Running"` 產生出來非 Running 狀態的 Pods 進行 Log Collection ，詳細如圖

![](dump-failed-pod-logs.png)

5. 截圖收集

## 針對 VCSA
1. 登入 VMware vCenter - `ssh root@vcenter.local`
2. Enable SHELL
3. 查詢 `/var/log/vmware/wcp/wcpsvc.log`
4. 截圖收集有疑慮的地方
