# Workload Cluster 常見維運操作

## 擴增縮減節點
```shell
$ tanzu cluster list
  NAME          NAMESPACE  STATUS    CONTROLPLANE  WORKERS  KUBERNETES        ROLES   PLAN
  dev-02180200  default    running   1/1           1/1      v1.22.5+vmware.1  <none>  dev
  project-sre   default    running   1/1           1/1      v1.22.5+vmware.1  <none>  dev

# Worker Node 可隨需擴增、縮減
$ tanzu cluster scale dev-02180200 --worker-machine-count 2
Successfully updated worker node machine deployment replica count for cluster dev-02180200
Workload cluster 'dev-02180200' is being scaled

# Wait a minutes...
$ tanzu cluster list
  NAME          NAMESPACE  STATUS    CONTROLPLANE  WORKERS  KUBERNETES        ROLES   PLAN
  dev-02180200  default    running   1/1           2/2      v1.22.5+vmware.1  <none>  dev
  project-sre   default    running   1/1           1/1      v1.22.5+vmware.1  <none>  dev

# Control Plane 最小 1 台，高可用建議 3 台，為確保效能，不要設定超過 3 台
$ tanzu cluster scale dev-02180200 --controlplane-machine-count 3
```

## 對節點 (Node) 上 Label
```shell
# 列舉所有節點的 Label 資訊
$ kubectl get nodes --show-labels
NAME                                 STATUS   ROLES                  AGE     VERSION            LABELS
dev-02180200-control-plane-t8hkp     Ready    control-plane,master   59m     v1.22.5+vmware.1   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/instance-type=vsphere-vm.cpu-2.mem-4gb.os-ubuntu,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=dev-02180200-control-plane-t8hkp,kubernetes.io/os=linux,node-role.kubernetes.io/control-plane=,node-role.kubernetes.io/master=,node.kubernetes.io/exclude-from-external-load-balancers=,node.kubernetes.io/instance-type=vsphere-vm.cpu-2.mem-4gb.os-ubuntu
dev-02180200-md-0-656555cc95-tdlm8   Ready    <none>                 54m     v1.22.5+vmware.1   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/instance-type=vsphere-vm.cpu-2.mem-4gb.os-ubuntu,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=dev-02180200-md-0-656555cc95-tdlm8,kubernetes.io/os=linux,node.kubernetes.io/instance-type=vsphere-vm.cpu-2.mem-4gb.os-ubuntu
dev-02180200-md-0-656555cc95-vthcp   Ready    <none>                 3m40s   v1.22.5+vmware.1   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/instance-type=vsphere-vm.cpu-2.mem-4gb.os-ubuntu,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=dev-02180200-md-0-656555cc95-vthcp,kubernetes.io/os=linux,node.kubernetes.io/instance-type=vsphere-vm.cpu-2.mem-4gb.os-ubuntu

# 列出所有角色為 control-plane 的節點
$ kubectl get nodes -l node-role.kubernetes.io/control-plane=
$ kubectl get nodes -l node-role.kubernetes.io/master=
NAME                               STATUS   ROLES                  AGE   VERSION
dev-02180200-control-plane-t8hkp   Ready    control-plane,master   61m   v1.22.5+vmware.1

# 列舉特定節點的 Label 資訊
$ kubectl label --list node dev-02180200-md-0-656555cc95-tdlm8
beta.kubernetes.io/os=linux
kubernetes.io/arch=amd64
kubernetes.io/hostname=dev-02180200-md-0-656555cc95-tdlm8
kubernetes.io/os=linux
node.kubernetes.io/instance-type=vsphere-vm.cpu-2.mem-4gb.os-ubuntu
beta.kubernetes.io/arch=amd64
beta.kubernetes.io/instance-type=vsphere-vm.cpu-2.mem-4gb.os-ubuntu

# 針對特定節點新增 Label - Ingress
$ kubectl label node dev-02180200-md-0-656555cc95-tdlm8 node-role.kubernetes.io/ingress=""
node/dev-02180200-md-0-656555cc95-tdlm8 labeled

$ kubectl label --list node dev-02180200-md-0-656555cc95-tdlm8
kubernetes.io/arch=amd64
kubernetes.io/hostname=dev-02180200-md-0-656555cc95-tdlm8
kubernetes.io/os=linux
node-role.kubernetes.io/ingress=
node.kubernetes.io/instance-type=vsphere-vm.cpu-2.mem-4gb.os-ubuntu
beta.kubernetes.io/arch=amd64
beta.kubernetes.io/instance-type=vsphere-vm.cpu-2.mem-4gb.os-ubuntu
beta.kubernetes.io/os=linux

$ kubectl get nodes
NAME                                 STATUS   ROLES                  AGE     VERSION
dev-02180200-control-plane-t8hkp     Ready    control-plane,master   64m     v1.22.5+vmware.1
dev-02180200-md-0-656555cc95-tdlm8   Ready    ingress                58m     v1.22.5+vmware.1
dev-02180200-md-0-656555cc95-vthcp   Ready    <none>                 8m12s   v1.22.5+vmware.1

# 特定節點移除 Label - Ingress
$ kubectl label node dev-02180200-md-0-656555cc95-tdlm8 node-role.kubernetes.io/ingress-
node/dev-02180200-md-0-656555cc95-tdlm8 labeled

$ kubectl get nodes
NAME                                 STATUS   ROLES                  AGE    VERSION
dev-02180200-control-plane-t8hkp     Ready    control-plane,master   65m    v1.22.5+vmware.1
dev-02180200-md-0-656555cc95-tdlm8   Ready    <none>                 59m    v1.22.5+vmware.1
dev-02180200-md-0-656555cc95-vthcp   Ready    <none>                 9m3s   v1.22.5+vmware.1
```

## 使用 Tanzu Package
```shell
# 確認內建已包含 kapp-controller
$ kubectl get pods -n tkg-system | grep kapp-controller
kapp-controller-d57d45ff7-7wg9n                          1/1     Running   0          60m

# 預設已安裝，確認安裝 tanzu package repository tanzu-core 及 tanzu-standard
$ tanzu package repository list -A
| Retrieving repositories...
  NAME            REPOSITORY                                               TAG                     STATUS               DETAILS  NAMESPACE
  tanzu-standard  projects.registry.vmware.com/tkg/packages/standard/repo  v1.4.1                  Reconcile succeeded           tanzu-package-repo-global
  tanzu-core      projects.registry.vmware.com/tkg/packages/core/repo      v1.22.5_vmware.1-tkg.3  Reconcile succeeded           tkg-system

# 查詢最新版本
$ skopeo inspect docker://projects.registry.vmware.com/tkg/packages/standard/repo:v1.4.1
$ skopeo inspect docker://projects.registry.vmware.com/tkg/packages/core/repo:v1.22.5_vmware.1-tkg.3

# 更新 tanzu package repository
$ tanzu package repository update tanzu-standard --url projects.registry.vmware.com/tkg/packages/standard/repo:v1.5.0 -n tanzu-package-repo-global
$ tanzu package repository update tanzu-core --url projects.registry.vmware.com/tkg/packages/core/repo:v1.22.5_vmware.1-tkg.3 -n tkg-system

# 確認 Taznu Package Repos 更新
$ tanzu package repository get tanzu-standard -n tanzu-package-repo-global
$ tanzu package repository get tanzu-core -n tkg-system

# 確認 Tanzu Package 可用套件更新
$ tanzu package available list -n tanzu-package-repo-global
$ tanzu package available list  -n tkg-system
```

## 預設已裝 Metrics-server
```bash
# 確認 Metrics Server 可用
$ kubectl top node
NAME                                 CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%
dev-02180200-control-plane-t8hkp     180m         9%     1952Mi          50%
dev-02180200-md-0-656555cc95-tdlm8   76m          3%     1053Mi          27%
dev-02180200-md-0-656555cc95-vthcp   52m          2%     512Mi           13%

$ kubectl get all -n kube-system | grep metrics-server
pod/metrics-server-7df57df8b4-rp7kb                            1/1     Running            0                69m
service/metrics-server           ClusterIP   100.98.39.217     <none>        443/TCP                  23h
deployment.apps/metrics-server           1/1     1            1           23h
replicaset.apps/metrics-server-5fcfb49595           0         0         0       23h
replicaset.apps/metrics-server-7df57df8b4           1         1         1       77m

$ tanzu package available list metrics-server.tanzu.vmware.com -A
| Retrieving package versions for metrics-server.tanzu.vmware.com...
  NAME                             VERSION               RELEASED-AT                    NAMESPACE
  metrics-server.tanzu.vmware.com  0.5.1+vmware.1-tkg.1  2022-02-15 01:10:37 +0800 CST  tkg-system
```

## 安裝 Cert-Manager
- [參考文件 1.5.1](https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/1.5/vmware-tanzu-kubernetes-grid-15/GUID-packages-cert-manager.html)
```bash
# Retrieve the version of the available package
$ tanzu package available list cert-manager.tanzu.vmware.com -A
| Retrieving package versions for cert-manager.tanzu.vmware.com...
  NAME                           VERSION               RELEASED-AT                    NAMESPACE
  cert-manager.tanzu.vmware.com  1.1.0+vmware.2-tkg.1  2020-11-25 02:00:00 +0800 CST  tanzu-package-repo-global

# Install the Cert Manager package
$ tanzu package install cert-manager \
    --package-name cert-manager.tanzu.vmware.com \
    --version 1.1.0+vmware.2-tkg.1 \
    --namespace cert-manager \
    --create-namespace

- Installing package 'cert-manager.tanzu.vmware.com' I0219 01:23:11.452431 1833955 request.go:665] Waited for 1.035908589s due to client-side throttling, not priority and fairness, request: GET:https://192.168.67.206:6443/apis/security.antrea.tanzu.vmware.com/v1alpha1?timeout=32s
| Installing package 'cert-manager.tanzu.vmware.com'
| Creating namespace 'cert-manager'
| Getting package metadata for 'cert-manager.tanzu.vmware.com'
| Creating service account 'cert-manager-cert-manager-sa'
| Creating cluster admin role 'cert-manager-cert-manager-cluster-role'
| Creating cluster role binding 'cert-manager-cert-manager-cluster-rolebinding'
| Creating package resource
- Waiting for 'PackageInstall' reconciliation for 'cert-manager'
- 'PackageInstall' resource install status: Reconciling
 Added installed package 'cert-manager'

# Confirm that the cert-manager package has been installed:
$ tanzu package installed list -n cert-manager
| Retrieving installed packages...
  NAME          PACKAGE-NAME                   PACKAGE-VERSION       STATUS
  cert-manager  cert-manager.tanzu.vmware.com  1.1.0+vmware.2-tkg.1  Reconcile succeeded

# Confirm that the cert-manager app has been successfully reconciled in your TARGET-NAMESPACE.
$ kubectl get apps cert-manager -n cert-manager
NAME           DESCRIPTION           SINCE-DEPLOY   AGE
cert-manager   Reconcile succeeded   3m41s          3m51s

# Get Pods
$ kubectl get pods -n cert-manager
NAME                                       READY   STATUS             RESTARTS      AGE
cert-manager-66bb8d46d9-twz7x              1/1     Running            0             6m22s
cert-manager-cainjector-5c7f6467dc-9fmcb   0/1     CrashLoopBackOff   5 (33s ago)   6m22s
cert-manager-webhook-5886cd8ff-6k6l9       1/1     Running            0             6m22s

# 移除 cert-manager
$ tanzu package installed delete cert-manager -n cert-manager

```

## 使用 cert-manager
```bash
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
 name: selfsigned-issuer
spec:
 selfSigned: {}
```

```
apiVersion: certmanager.k8s.io/v1alpha1
kind: Certificate
metadata:
 name: hello-ca-tls
 namespace: foobar
spec:
 # name of the tls secret to store
 # the generated certificate/key pair
 secretName: hello-deployment-tls-ca-key-pair
 isCA: true
 issuerRef:
   # issuer created in step 1
   name: hello-myself-tls
   kind: Issuer
 commonName: "foo1.bar1"
 dnsNames:
 # one or more fully-qualified domain name
 # can be defined here
 - foo1.bar1
```