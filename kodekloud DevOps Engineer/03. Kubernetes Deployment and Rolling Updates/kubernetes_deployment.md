#### Instructions

There is a production deployment planned for next week. The Nautilus DevOps team wants to test the deployment update and rollback on Dev environment first so that they can identify the risks in advance. Below you can find more details about the plan they want to execute.



Create a namespace *nautilus*. Create a deployment called *httpd-deploy* under this new namespace, It should have one container called *httpd*, use *httpd:2.4.27* image and *4* replicas. The deployment should use *RollingUpdate* strategy with *maxSurge=1*, and *maxUnavailable=2*. Also create a *NodePort* type service named *httpd-service* and *expose* the deployment on *nodePort: 30008*.

Now upgrade the deployment to version *httpd:2.4.43* using a rolling update.

Finally, once all pods are updated undo the recent update and roll back to the previous/original version.

Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.

#### Solution

#### List all the resources in the cluster
```bash
thor@jump_host ~$ kubectl get all
NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   38m
thor@jump_host ~$ 
```

#### List the configured namespaces in the cluster

```bash
thor@jump_host ~$ kubectl get namespaces
NAME                 STATUS   AGE
default              Active   38m
kube-node-lease      Active   38m
kube-public          Active   38m
kube-system          Active   38m
local-path-storage   Active   38m
thor@jump_host ~$ 
```

#### Create the *nautilus* namespace
```bash
thor@jump_host ~$ kubectl create namespace nautilus
namespace/nautilus created
thor@jump_host ~$ 
```

#### Set the nautilus namespace to be the current / working namespace so that we do not have to specify the namespace option in the commands each time

```bash
thor@jump_host ~$ kubectl config set-context $(kubectl config current-context) --namespace=nautilus
Context "kind-kodekloud" modified.
thor@jump_host ~$ 
```


#### List namespaces to confirm successful creation of the *nautilus* namespace
```bash
thor@jump_host ~$ kubectl get namespaces
NAME                 STATUS   AGE
default              Active   39m
kube-node-lease      Active   39m
kube-public          Active   39m
kube-system          Active   39m
local-path-storage   Active   38m
nautilus             Active   10s
thor@jump_host ~$ 
```



#### Create the *httpd-deploy* definition manifest file
```bash
thor@jump_host ~$ kubectl create deployment httpd-deploy --image=httpd:2.4.27 --replicas=4 --namespace=nautilus --dry-run=client -o yaml > httpd-deploy.yaml
thor@jump_host ~$ 
```


#### Edit the *httpd-deploy* definition manifest file to add the strategy options: type: RollingUpdate, maxSurge: 1 and maxUnavailable: 2. Refere to the [file here](httpd-deploy.yaml)
ame: httpd

#### Next apply the deployment the configuration file

```bash
thor@jump_host ~$ kubectl apply -f httpd-deploy.yaml 
deployment.apps/httpd-deploy created
thor@jump_host ~$ 
```

#### Create the *httpd-service* service definition manifest file
```bash
thor@jump_host ~$ kubectl expose deployment httpd-deploy --type=NodePort  --port=80 --name=httpd-service --dry-run=client -o yaml > httpd-service.yaml
thor@jump_host ~$ 
```

#### Edit the *httpd-service.yaml* definition file to specify the *nodePort:30008*. REfer to the file [here]()


#### Apply the service configuration file
```bash
thor@jump_host ~$ kubectl apply -f httpd-service.yaml 
service/httpd-service created
thor@jump_host ~$ 
```

#### Check the rolling update history. So far there is none.

```bash
thor@jump_host ~$ kubectl rollout history deployment httpd-deploy --namespace=nautilus
deployment.apps/httpd-deploy 
REVISION  CHANGE-CAUSE
1         <none>
```

#### Optionally list the pods in the deployment
```bash

thor@jump_host ~$ kubectl get pods -o wide --namespace=nautilus
NAME                           READY   STATUS    RESTARTS   AGE   IP           NODE                      NOMINATED NODE   READINESS GATES
httpd-deploy-8fdd86555-bxpt5   1/1     Running   0          12m   10.244.0.7   kodekloud-control-plane   <none>           <none>
httpd-deploy-8fdd86555-jvplw   1/1     Running   0          12m   10.244.0.6   kodekloud-control-plane   <none>           <none>
httpd-deploy-8fdd86555-q6w2m   1/1     Running   0          12m   10.244.0.8   kodekloud-control-plane   <none>           <none>
httpd-deploy-8fdd86555-xg6zb   1/1     Running   0          12m   10.244.0.5   kodekloud-control-plane   <none>           <none>
thor@jump_host ~$ 
```
#### Rollout the update by updating image to *httpd=httpd:2.4.43*
```bash
thor@jump_host ~$ kubectl set image deployment httpd-deploy httpd=httpd:2.4.43 --record
deployment.apps/httpd-deploy image updated
thor@jump_host ~$ 
```

#### Checkout the rolling update status
```bash
thor@jump_host ~$ kubectl rollout status deployment httpd-deploy
deployment "httpd-deploy" successfully rolled out
thor@jump_host ~$ 
```

#### Rollout the update by updating image to *httpd=httpd:2.4.27*

```bash
thor@jump_host ~$ kubectl set image deployment httpd-deploy httpd=httpd:2.4.27 --record
deployment.apps/httpd-deploy image updated
thor@jump_host ~$ 
```

#### Checkout the rolling update history
```bash
thor@jump_host ~$ kubectl rollout history deployment httpd-deploy 
deployment.apps/httpd-deploy 
REVISION  CHANGE-CAUSE
2         kubectl set image deployment httpd-deploy httpd=httpd:2.4.43 --record=true
3         kubectl set image deployment httpd-deploy httpd=httpd:2.4.27 --record=true
```

***The End***