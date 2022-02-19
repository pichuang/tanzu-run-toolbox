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


### Q2: Waited for due to client-side throttling, not priority and fairness

- Reproduce
```
kubectl ...
```

- Error Output
```
Retrieving repositories... I0219 01:07:10.119928 1817225 request.go:665] Waited for 1.037018729s due to client-side throttling, not priority and fairness, request: GET:https://192.168.67.206:6443/apis/storage.k8s.io/v1beta1?timeout=32s
```

A2:
`chown -R $user:$user ~/.kube/cache` and this is a bug?


### Q3: cert-manager x509: certificate signed by unknown authority


- Error Output
```bash
Error from server (InternalError): error when creating "self-signed-issue.yaml": Internal error occurred: failed calling webhook "webhook.cert-manager.io": failed to call webhook: Post "https://cert-manager-webhook.cert-manager.svc:443/mutate?timeout=10s": x509: certificate signed by unknown authority
```


A3:
```bash
$ kubectl get validatingwebhookconfigurations.admissionregistration.k8s.io cert-manager-webhook
$ kubectl get validatingwebhookconfigurations cert-manager-webhook -o yaml

# cert-manager.io/inject-ca-from-secret: cert-manager/cert-manager-webhook-ca

$ kubectl get secret cert-manager-webhook-ca
NAME                      TYPE     DATA   AGE
cert-manager-webhook-ca   Opaque   3      51m

$ kubectl describe secret cert-manager-webhook-ca
Name:         cert-manager-webhook-ca
Namespace:    cert-manager
Labels:       <none>
Annotations:  cert-manager.io/allow-direct-injection: true

Type:  Opaque

Data
====
ca.crt:   668 bytes
tls.crt:  668 bytes
tls.key:  306 bytes

```


https://cert-manager.io/docs/concepts/ca-injector/#injecting-ca-data-from-a-secret-resource
https://cert-manager.io/docs/concepts/webhook/#diagnosing-other-webhook-problems

`cert-manager-cainjector` didn't work

Are you trying to use cert-manager to issue a certificate for your own webhook and get that injected into your webhook's configuration as described in cert-manager cainjector doc?
If so, you might need to add the cert-manager.io/inject-ca-from: annotations to your ValidatingWebhookConfiguration and MutatingWebhookConfiguration (looking at the config you posted I only see this annotation on the CustomResourceDefinition).

https://github.com/cert-manager/cert-manager/issues/4713


## Q4: cert-manager MountVolume.SetUp failed for volume "kube-api-access-cfjbq" : failed to sync configmap cache: timed out waiting for the condition


A4: no matches for kind \"MutatingWebhookConfiguration\

```bash
kubectl delete pod cert-manager-cainjector-5c7f6467dc-9fmcb
```

https://github.com/cert-manager/cert-manager/issues/4695

## Q5: --leader-elect failed

- Reproduce
```bash
kubectl logs cert-manager-cainjector-5c7f6467dc-z9764
```

- Error Output
```bash
I0218 17:54:34.662513       1 start.go:91] "starting" version="canary" revision=""
I0218 17:54:35.713212       1 request.go:645] Throttling request took 1.03661617s, request: GET:https://100.96.0.1:443/apis/co
ntrolplane.antrea.tanzu.vmware.com/v1beta2?timeout=32s
I0218 17:54:36.318541       1 leaderelection.go:243] attempting to acquire leader lease  kube-system/cert-manager-cainjector-leader-election...
I0218 17:54:52.657371       1 leaderelection.go:253] successfully acquired lease kube-system/cert-manager-cainjector-leader-el
ection                                                                                                                        I0218 17:54:52.658139       1 recorder.go:52] cert-manager/controller-runtime/manager/events "msg"="Normal"  "message"="cert-m
anager-cainjector-5c7f6467dc-z9764_6c593d00-ab07-46be-a5dc-7e439ea461c0 became leader" "object"={"kind":"ConfigMap","namespace":"kube-system","name":"cert-manager-cainjector-leader-election","uid":"a99b53d1-7543-46d5-9f59-5e02d61c687a","apiVersion":"v1
","resourceVersion":"301896"} "reason"="LeaderElection"
I0218 17:54:53.708061       1 request.go:645] Throttling request took 1.044961057s, request: GET:https://100.96.0.1:443/apis/m
etrics.k8s.io/v1beta1?timeout=32s
E0218 17:54:54.311914       1 start.go:119] cert-manager/ca-injector "msg"="manager goroutine exited" "error"=null
I0218 17:54:55.458034       1 request.go:645] Throttling request took 1.047603008s, request: GET:https://100.96.0.1:443/apis/a
cme.cert-manager.io/v1alpha3?timeout=32s
I0218 17:54:56.458154       1 request.go:645] Throttling request took 2.047476112s, request: GET:https://100.96.0.1:443/apis/packaging.carvel.dev/v1alpha1?timeout=32s
E0218 17:54:57.462310       1 start.go:151] cert-manager/ca-injector "msg"="Error registering certificate based controllers. R
etrying after 5 seconds." "error"="no matches for kind \"MutatingWebhookConfiguration\" in version \"admissionregistration.k8s
.io/v1beta1\""
Error: error registering secret controller: no matches for kind "MutatingWebhookConfiguration" in version "admissionregistrati
on.k8s.io/v1beta1"
```

A5:

`--leader-election-namespace` 預設為 Namespace kube-system，要修改成 cert-manager 安裝所在的 namesapce，這邊我的 namespace 是使用 cert-manager 估要修改

```bash
kubectl get deployment cert-manager-cainjector -o yaml | kubectl neat > cert-manager-cainjector.yaml
cp cert-manager-cainjector.yaml cert-manager-cainjector.yaml.bak
vim cert-manager-cainjector.yaml
kubectl apply -f cert-manager-cainjector.yaml --force
kubectl get pods -w
```

In cert-manager-cainjector.yaml
From
```
- --leader-election-namespace=kube-system
```
to
```
- --leader-election-namespace=cert-manager
```


Q6: 在Kubernetes 中刪除namespace 的時候卡在Terminating 無法
$ kubectl describe ns cert-manager
Name:         cert-manager
Labels:       kapp.k14s.io/app=1645205001589335916
              kapp.k14s.io/association=v1.0da7ffcb7e9cabbcf464eb8289d3e170
              kubernetes.io/metadata.name=cert-manager
Annotations:  kapp-controller.carvel.dev/exclude-global-packages:
              kapp.k14s.io/identity: v1;//Namespace/cert-manager;v1
              kapp.k14s.io/original:
                {"apiVersion":"v1","kind":"Namespace","metadata":{"labels":{"kapp.k14s.io/app":"1645205001589335916","kapp.k14s.io/association":"v1.0da7ff...
              kapp.k14s.io/original-diff-md5: 29ebb5c3316dc4ab62b6d834ff0316e6
Status:       Terminating

No resource quota.

No LimitRange resource.

A6:

```bash
NAMESPACE=cert-manager
kubectl proxy &
kubectl get namespace $NAMESPACE -o json |jq '.spec = {"finalizers":[]}' >temp.json
curl -k -H "Content-Type: application/json" -X PUT --data-binary @temp.json 127.0.0.1:8001/api/v1/namespaces/$NAMESPACE/finalize
```

Q7: 