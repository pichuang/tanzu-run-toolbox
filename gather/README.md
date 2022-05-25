# 如何收集 Tanzu 相關問題資訊

## 1. 紀錄問題

1. 務必提供狀況描述
2. 紀錄疑似有問題的截圖（vCenter 畫面、kubectl CLI 畫面），並文字說明
3. 提供 YAML 檔案（Cluster create yaml）

## 2. 收集 Tanzu Log
依據 [VMware vSphere - Collect the Support Bundle for Workload Management
](https://docs.vmware.com/en/VMware-vSphere/7.0/vmware-vsphere-with-tanzu/GUID-CC9A47FF-E623-4C73-A28E-ACEE88EF4BBD.html)

請依序點選
1. 登入 vCenter
2. 點選 `Menu`
3. 點選 `Workload Management`
4. 點選 `Clusters`
5. 點選 `EXPORT LOGS`
6. 獲得 `wcp-support-bundle-domain-yyyymmdd--hh-mm.tar` 

![](export-logs.jpeg)

e.g. 
(Supervisor Cluster 

## (Optioanl) 收集 NSX-T Log

依據 [VMware NSX-T Data Center - Collect Support Bundles](https://docs.vmware.com/en/VMware-NSX-T-Data-Center/3.1/administration/GUID-73D9AF0D-4000-4EF2-AC66-6572AD1A0B30.html) 所述

請依序點選
1. 登入 NSX Manager
2. 點選 `System`
3. 點選 `Support Bundle`
4. 選擇節點
5. 點選 `Start Bundle Collection`
6. 點選 `Download`

## (Optional) 收集 AVI Networks Log

依據 [Collecting Tech Support Logs in Avi Vantage](https://avinetworks.com/docs/20.1/collecting-tech-support-logs/) 所述

請依序點選
1. 登入 ALB
2. 點選 `System`
3. 點選 `Tech Support`
4. 點選 `General Tech Support`
6. 點選 Type: `Debug Logs`
7. 點選 Generate

![](https://avinetworks.com/docs/20.1/collecting-tech-support-logs/img/navigating-to-tech-support.png)

## (Optional) 收集特定 Tanzu Kubernetes Cluster Bundle

依據 [How to collect a diagnostic log bundle from a Tanzu Kubernetes Guest Cluster on vSphere with Tanzu (80949)](https://kb.vmware.com/s/article/80949) 所述

執行範例: `./tkc-support-bundler create –k /tmp/kubeconfig –o /tmp/ -c tkg-cluster-01 –n namespace01` 

## 3. 提供給窗口

因 `wcp-support-bundle-domain-yyyymmdd--hh-mm.tar` 檔案很大，可採用 Google Drive / One Drive / Dropbox 放置於內，提供給代理商或原廠窗口進行偵測

## 4. 如何進行除錯?

請參考 [README-CHECK.md](README-CHECK.md) 一文
