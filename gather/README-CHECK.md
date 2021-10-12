# 如何檢查 WCP Support Bundle 檔案

## 解壓縮檔案

1. 解壓縮 *.tar

```bash
tar xvf wcp-support-bundle-*.tar
ls -la 
```

於該目錄會看到一堆 `vc-suuport.tar.gz.FRAG-*` 的檔案

如下輸出
```bash
$ ls -la vc-support.tar.gz.*
-rw-r-----@ 1 pichuang  staff  10485760 Oct  5 18:20 vc-support.tar.gz.FRAG-00000
-rw-r-----@ 1 pichuang  staff  10485760 Oct  5 18:20 vc-support.tar.gz.FRAG-00001
-rw-r-----@ 1 pichuang  staff  10485760 Oct  5 18:20 vc-support.tar.gz.FRAG-00002
-rw-r-----@ 1 pichuang  staff  10485760 Oct  5 18:20 vc-support.tar.gz.FRAG-00003
-rw-r-----@ 1 pichuang  staff  10485760 Oct  5 18:20 vc-support.tar.gz.FRAG-00004
-rw-r-----@ 1 pichuang  staff  10485760 Oct  5 18:20 vc-support.tar.gz.FRAG-00005
-rw-r-----@ 1 pichuang  staff  10485760 Oct  5 18:21 vc-support.tar.gz.FRAG-00006
-rw-r-----@ 1 pichuang  staff  10485760 Oct  5 18:21 vc-support.tar.gz.FRAG-00007
-rw-r-----@ 1 pichuang  staff  10485760 Oct  5 18:21 vc-support.tar.gz.FRAG-00008
```

2. 合併分割檔
```bash
cat vc-support.tar.gz.* | tar -zxv
ls -la
```

於該目錄會看到一個新增資料夾 `vcenter-domain-yyyy-mm-dd--hh-mm*`

如下輸出
```bash
$ ls -l | grep ^d
drwxr-xr-x  16 pichuang  staff         512 Oct  7 02:09 vc-pichuang.local-2021-10-05--10.19-26250
```

## 偵錯

建議使用 `VSCode` 將 `vcenter-domain-yyyy-mm-dd--hh-mm*` 匯入進去

## Appendix: 常見 Log Files 位置
- vCenter Server Update
  - `/var/log/vmware/applmgmt/software-packages.log`
- Supervisor Cluster upgrade
  - vCenter: `/var/log/vmware/wcp/wcpsvc.log`
  - Control Plane: `/var/log/vmware/upgrade-ctl-cli.log`
  - Cnotrol Plane: `/var/log/vmware/upgrade-ctl-compupgrade.log`
- ESXi Spherelet Update
  - `/var/log/spherelet.log`
- Tanzu Kubenretes Cluster
  - `/var/log/cloud-init-output.log`
  - `/var/log/pods`


