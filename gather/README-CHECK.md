# 如何檢查 WCP Support Bundle 檔案

## 解壓縮檔案

1. 解壓縮 *.tar

```bash
tar xvf wcp-support-bundle-*.tar
ls -la 
```

於該目錄會看到一堆 `vc-suuport.tar.gz.FRAG-*` 的檔案

2. 合併分割檔
```bash
cat vc-support.tar.gz.* | tar -zxv
ls -la
```

於該目錄會看到一個新增資料夾 `vcenter-domain-yyyy-mm-dd--hh-mm*`

## 偵錯

建議使用 `VSCode` 將 `vcenter-domain-yyyy-mm-dd--hh-mm*` 匯入進去






