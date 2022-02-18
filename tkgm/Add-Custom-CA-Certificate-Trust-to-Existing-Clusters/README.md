# Add Custom CA Certificate Trust to Existing Clusters

```shell
# 切換至 Management Cluste 叢集
kubectl config use-context tkgm-admin@tkgm

# 列舉 kubeadmconfigtemplate 並且選擇指定的 Cluster
kubectl get kubeadmconfigtemplate
kubectl get kubeadmconfigtemplate project-sre-md-0


# 備份既有設定
kubectl get kubeadmconfigtemplate project-sre-md-0 -o yaml | kubectl neat > project-sre-md-0.backup.yaml
cp project-sre-md-0.backup.yaml project-sre-md-0.ca.yaml

# 修改檔案，下面是修改前和修改後差異
vimdiff project-sre-md-0.backup.yaml project-sre-md-0.ca.yaml

# 執行 project-sre-md-0.ca.yaml
kubectl apply -f project-sre-md-0.ca.yaml --force

# 強制重新部署 Machine，這邊會讓 Machine 全部重建 (Rebuild)，而不是重開 (Restart)
kubectl patch machinedeployments.cluster.x-k8s.io project-sre-md-0 --type merge -p "{\"spec\":{\"template\":{\"metadata\":{\"annotations\":{\"date\":\"`date +'%s'`\"}}}}}"

# 切換至 Workload Cluster 叢集
kubectl config use-context project-sre-admin@project-sre

# 等待 Ready
watch -n4 kubectl get nodes -owide

# 跑一個私有倉庫的映像檔試試
kubectl run -n default debug-container --restart=Never --rm -i --tty --image harbor.vmware.local/library/debug-container  -- /bin/bash
```

## References
- [Add Custom CA Certificate Trust to Existing Clusters][1]

[1]: https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/1.5/vmware-tanzu-kubernetes-grid-15/GUID-cluster-lifecycle-secrets.html#add-custom-ca-certificate-trust-to-existing-clusters-4
