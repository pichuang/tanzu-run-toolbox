## Gather Logs
1. 於跳板機部署一次 tkc.yaml
2. 於跳板機執行 `gather.sh`
3. 針對最後 kubectl get pods --all-namespaces |grep -vi "Running" >> log 產生出來非 Running 狀態的 Pods 進行 Log Collection ，詳細如圖

![](dump-failed-pod-logs.png)
