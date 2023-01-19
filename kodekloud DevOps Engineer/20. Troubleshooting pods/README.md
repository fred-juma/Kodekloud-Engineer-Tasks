#### Task

One of the junior DevOps team members was working on to deploy a stack on Kubernetes cluster. Somehow the pod is not coming up and its failing with some errors. We need to fix this as soon as possible. Please look into it.



There is a pod named webserver and the container under it is named as nginx-container. It is using image nginx:latest

There is a sidecar container as well named sidecar-container which is using ubuntu:latest image.

Look into the issue and fix it, make sure pod is in running state and you are able to access the app.

Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.

#### Solution

View the pod and the status

```bash

thor@jump_host ~$ kubectl get pod webserver
NAME        READY   STATUS             RESTARTS   AGE
webserver   1/2     ImagePullBackOff   0          3m44s
thor@jump_host ~$ 
```

Describe pod details

```bash
thor@jump_host ~$ kubectl describe pod webserver
Name:         webserver
Namespace:    default
Priority:     0
Node:         kodekloud-control-plane/172.17.0.2
Start Time:   Thu, 19 Jan 2023 08:16:30 +0000
Labels:       app=web-app
Annotations:  <none>
Status:       Pending
IP:           10.244.0.5
IPs:
  IP:  10.244.0.5
Containers:
  nginx-container:
    Container ID:   
    Image:          nginx:latests
    Image ID:       
    Port:           <none>
    Host Port:      <none>
    State:          Waiting
      Reason:       ImagePullBackOff
    Ready:          False
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/log/nginx from shared-logs (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-rs8qh (ro)
  sidecar-container:
    Container ID:  containerd://b143c2e1f50f5b51de51def862c05d8da4191d546cdfc9dbf4b1fe8d3c6f7c2a
    Image:         ubuntu:latest
    Image ID:      docker.io/library/ubuntu@sha256:27cb6e6ccef575a4698b66f5de06c7ecd61589132d5a91d098f7f3f9285415a9
    Port:          <none>
    Host Port:     <none>
    Command:
      sh
      -c
      while true; do cat /var/log/nginx/access.log /var/log/nginx/error.log; sleep 30; done
    State:          Running
      Started:      Thu, 19 Jan 2023 08:16:43 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/log/nginx from shared-logs (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-rs8qh (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             False 
  ContainersReady   False 
  PodScheduled      True 
Volumes:
  shared-logs:
    Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:     
    SizeLimit:  <unset>
  default-token-rs8qh:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-rs8qh
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                 node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type     Reason     Age                    From               Message
  ----     ------     ----                   ----               -------
  Normal   Scheduled  4m9s                   default-scheduler  Successfully assigned default/webserver to kodekloud-control-plane
  Normal   Pulling    4m7s                   kubelet            Pulling image "ubuntu:latest"
  Normal   Pulled     3m57s                  kubelet            Successfully pulled image "ubuntu:latest" in 9.264541054s
  Normal   Created    3m57s                  kubelet            Created container sidecar-container
  Normal   Started    3m56s                  kubelet            Started container sidecar-container
  Warning  Failed     3m4s (x4 over 3m55s)   kubelet            Error: ImagePullBackOff
  Warning  Failed     2m49s (x4 over 4m7s)   kubelet            Failed to pull image "nginx:latests": rpc error: code = NotFound desc = failed to pull and unpack image "docker.io/library/nginx:latests": failed to resolve reference "docker.io/library/nginx:latests": docker.io/library/nginx:latests: not found
  Normal   Pulling    2m49s (x4 over 4m8s)   kubelet            Pulling image "nginx:latests"
  Warning  Failed     2m49s (x4 over 4m7s)   kubelet            Error: ErrImagePull
  Normal   BackOff    2m34s (x5 over 3m55s)  kubelet            Back-off pulling image "nginx:latests"
thor@jump_host ~$
````

From the above details, we note that there is a typo on the image tag "nginx:latests" instead of "nginx:latest"

We update the image with the correct tag.

First query the pod name

```bash
thor@jump_host ~$ kubectl get all
NAME            READY   STATUS             RESTARTS   AGE
pod/webserver   1/2     ImagePullBackOff   0          9m12s

NAME                    TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
service/kubernetes      ClusterIP   10.96.0.1       <none>        443/TCP        79m
service/nginx-service   NodePort    10.96.116.137   <none>        80:30008/TCP   9m11s
thor@jump_host ~$ 
```

Set the image with correct tag

```bash
thor@jump_host ~$ kubectl set image pod/webserver nginx-container=nginx:latest
pod/webserver image updated
thor@jump_host ~$
```

Check status of pods to see that it in now running


```bash

thor@jump_host ~$ kubectl get pod
NAME        READY   STATUS    RESTARTS   AGE
webserver   2/2     Running   0          11m
thor@jump_host ~$ 
```


***The End***



