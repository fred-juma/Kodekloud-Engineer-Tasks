#### Task
Last week, the Nautilus DevOps team deployed a redis app on Kubernetes cluster, which was working fine so far. This morning one of the team members was making some changes in this existing setup, but he made some mistakes and the app went down. We need to fix this as soon as possible. Please take a look.



The deployment name is redis-deployment. The pods are not in running state right now, so please look into the issue and fix the same.

Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.


#### Solution

list all resources in the default namespace

```bash
thor@jump_host ~$ kubectl get all
NAME                                   READY   STATUS              RESTARTS   AGE
pod/redis-deployment-76cc9c56f-dwg6k   0/1     ContainerCreating   0          32s

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   127m

NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/redis-deployment   0/1     1            0           33s

NAME                                         DESIRED   CURRENT   READY   AGE
replicaset.apps/redis-deployment-76cc9c56f   1         1         0       32s
thor@jump_host ~$ 
```

We can see that the deployment is not ready and pod is stucj at *ContainerCreating*

Let's view the pod status

```bash
thor@jump_host ~$ kubectl describe pod redis-deployment-76cc9c56f-dwg6k
Name:           redis-deployment-76cc9c56f-dwg6k
Namespace:      default
Priority:       0
Node:           kodekloud-control-plane/172.17.0.2
Start Time:     Mon, 20 Feb 2023 15:38:53 +0000
Labels:         app=redis
                pod-template-hash=76cc9c56f
Annotations:    <none>
Status:         Pending
IP:             
IPs:            <none>
Controlled By:  ReplicaSet/redis-deployment-76cc9c56f
Containers:
  redis-container:
    Container ID:   
    Image:          redis:alpin
    Image ID:       
    Port:           6379/TCP
    Host Port:      0/TCP
    State:          Waiting
      Reason:       ContainerCreating
    Ready:          False
    Restart Count:  0
    Requests:
      cpu:        300m
    Environment:  <none>
    Mounts:
      /redis-master from config (rw)
      /redis-master-data from data (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-q8l7j (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             False 
  ContainersReady   False 
  PodScheduled      True 
Volumes:
  data:
    Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:     
    SizeLimit:  <unset>
  config:
    Type:      ConfigMap (a volume populated by a ConfigMap)
    Name:      redis-cofig
    Optional:  false
  default-token-q8l7j:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-q8l7j
    Optional:    false
QoS Class:       Burstable
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                 node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type     Reason       Age                From               Message
  ----     ------       ----               ----               -------
  Normal   Scheduled    87s                default-scheduler  Successfully assigned default/redis-deployment-76cc9c56f-dwg6k to kodekloud-control-plane
  Warning  FailedMount  23s (x8 over 87s)  kubelet            MountVolume.SetUp failed for volume "config" : configmap "redis-cofig" not found
thor@jump_host ~$ 
```

The event points at configMap volume *FailedMount* and the reson is given as *configmap "redis-cofig" not found*

Let's list and view configMaps

```bash

thor@jump_host ~$ kubectl get configmap
NAME               DATA   AGE
kube-root-ca.crt   1      139m
redis-config       2      13m
```

```yaml
# Please edit the object below. Lines beginning with a '#' will be ignored,
# and an empty file will abort the edit. If an error occurs while saving this file will be
# reopened with the relevant failures.
#
apiVersion: v1
data:
  maxmemory: 2mb
  maxmemory-policy: allkeys-lru
kind: ConfigMap
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","data":{"maxmemory":"2mb","maxmemory-policy":"allkeys-lru"},"kind":"ConfigMap","metadata":{"annotations":{},"name":"redis-config","namespace":"default"}}
  creationTimestamp: "2023-02-20T15:38:52Z"
  name: redis-config
  namespace: default
  resourceVersion: "13306"
  uid: 0cc0067e-86c8-46ae-87b8-57443475e81b


thor@jump_host ~$ kubectl set image deployment/redis-deployment redis-container=redis:alpine
deployment.apps/redis-deployment image updated
```

From the above outputs, we note that the configMap is named *redis-config* and not *redis-config*.

We should edit the configMap name in the deployment with the correct name.

```bash
thor@jump_host ~$ kubectl edit deployment redis-deployment
deployment.apps/redis-deployment edited
thor@jump_host ~$ 
```

Next view all resources

```bash
Every 2.0s: kubectl get all                                                                                                      Wed Feb 22 12:10:59 2023

NAME                                    READY   STATUS              RESTARTS   AGE
pod/redis-deployment-6589b5b779-l7dwv   0/1     ErrImagePull        0          59s
pod/redis-deployment-76cc9c56f-jmtv7    0/1     ContainerCreating   0          2m49s

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   62m

NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/redis-deployment   0/1     1            0           2m49s

NAME                                          DESIRED   CURRENT   READY   AGE
replicaset.apps/redis-deployment-6589b5b779   1         1         0       59s
replicaset.apps/redis-deployment-76cc9c56f    1   
```


Now we see the pod is displaying error *ErrImagePull*

Let's describe the pod details and view the events

```bash
Events:
  Type     Reason     Age                  From               Message
  ----     ------     ----                 ----               -------
  Normal   Scheduled  2m23s                default-scheduler  Successfully assigned default/redis-deployment-6589b5b779-l7dwv to kodekloud-control-plane
  Normal   Pulling    59s (x4 over 2m22s)  kubelet            Pulling image "redis:alpin"
  Warning  Failed     58s (x4 over 2m22s)  kubelet            Failed to pull image "redis:alpin": rpc error: code = NotFound desc = failed to pull and unpack image "docker.io/library/redis:alpin": failed to resolve reference "docker.io/library/redis:alpin": docker.io/library/redis:alpin: not found
  Warning  Failed     58s (x4 over 2m22s)  kubelet            Error: ErrImagePull
  Warning  Failed     33s (x6 over 2m21s)  kubelet            Error: ImagePullBackOff
  Normal   BackOff    22s (x7 over 2m21s)  kubelet            Back-off pulling image "redis:alpin"
```

From the above output, image pull is failing because the configured container image *redis:alpin* is not found in the docker hub. This is because there is a typo in the image name.We should update the image to *redis:alpine*

```bash
thor@jump_host ~$ kubectl set image deployment/redis-deployment redis-container=redis:alpine
deployment.apps/redis-deployment image updated
thor@jump_host ~$ 
```

Now view the status of the resources. Everything is now fine and the pod is running.

```bash
Every 2.0s: kubectl get all                                                                                                      Wed Feb 22 12:15:09 2023

NAME                                    READY   STATUS    RESTARTS   AGE
pod/redis-deployment-5bb6dd57fd-9skkr   1/1     Running   0          14s

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   66m

NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/redis-deployment   1/1     1            1           6m59s

NAME                                          DESIRED   CURRENT   READY   AGE
replicaset.apps/redis-deployment-5bb6dd57fd   1         1         1       14s
replicaset.apps/redis-deployment-6589b5b779   0         0         0       5m9s
replicaset.apps/redis-deployment-76cc9c56f    0         0         0       6m59s
```

***The End***



