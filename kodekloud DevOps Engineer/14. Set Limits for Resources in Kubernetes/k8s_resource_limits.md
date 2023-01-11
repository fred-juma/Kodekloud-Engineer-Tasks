#### Task

Recently some of the performance issues were observed with some applications hosted on Kubernetes cluster. The Nautilus DevOps team has observed some resources constraints, where some of the applications are running out of resources like memory, cpu etc., and some of the applications are consuming more resources than needed. Therefore, the team has decided to add some limits for resources utilization. Below you can find more details.



Create a pod named httpd-pod and a container under it named as httpd-container, use httpd image with latest tag only and remember to mention tag i.e httpd:latest and set the following limits:

Requests: Memory: 15Mi, CPU: 100m

Limits: Memory: 20Mi, CPU: 100m

Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.


#### Solution

Create the pod manifest file

```bash
thor@jump_host ~$ vi httpd-pod.yaml
thor@jump_host ~$ sudo vi httpd-pod.yaml

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for thor: 
```

Populate the manifest with the pod definition

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: httpd-pod
spec:
  containers:
  - name: httpd-container
    image: httpd:latest
    ports:
    - containerPort: 8080
    resources:
      requests:
        memory: "15Mi"
        cpu: "100m"
      limits:
        memory: "20Mi"
        cpu: "100m"
```

Apply the pod manifest to create the pod

```bash
thor@jump_host ~$ kubectl apply -f httpd-pod.yaml 
pod/httpd-pod created
thor@jump_host ~$ 
```

Check the pod status in real time

```bash
thor@jump_host ~$ watch kubectl get pods

Every 2.0s: kubectl get pods                                                                                                                           Wed Jan 11 15:02:45 2023

NAME        READY   STATUS    RESTARTS   AGE
httpd-pod   1/1     Running   0          49s

```
Get the pod details

```bash
thor@jump_host ~$ kubectl describe pod httpd-pod
Name:         httpd-pod
Namespace:    default
Priority:     0
Node:         kodekloud-control-plane/172.17.0.2
Start Time:   Wed, 11 Jan 2023 15:01:57 +0000
Labels:       <none>
Annotations:  <none>
Status:       Running
IP:           10.244.0.5
IPs:
  IP:  10.244.0.5
Containers:
  httpd-container:
    Container ID:   containerd://c938e74545f53fdcdbbe13e7a2d5a01a2465fb4bce52dcacc132cb6d0c73e1e0
    Image:          httpd:latest
    Image ID:       docker.io/library/httpd@sha256:eb44faad041d2cde46389a286a4dd11e42d99f5e874eb554a24c87fd8f1cce0b
    Port:           8080/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Wed, 11 Jan 2023 15:02:18 +0000
    Ready:          True
    Restart Count:  0
    Limits:
      cpu:     100m
      memory:  20Mi
    Requests:
      cpu:        100m
      memory:     15Mi
    Environment:  <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-btbz8 (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  default-token-btbz8:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-btbz8
    Optional:    false
QoS Class:       Burstable
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                 node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  87s   default-scheduler  Successfully assigned default/httpd-pod to kodekloud-control-plane
  Normal  Pulling    85s   kubelet            Pulling image "httpd:latest"
  Normal  Pulled     69s   kubelet            Successfully pulled image "httpd:latest" in 16.572769225s
  Normal  Created    69s   kubelet            Created container httpd-container
  Normal  Started    66s   kubelet            Started container httpd-container
thor@jump_host ~$
```

***The End***