#### Task

We are working on an application that will be deployed on multiple containers within a pod on Kubernetes cluster. There is a requirement to share a volume among the containers to save some temporary data. The Nautilus DevOps team is developing a similar template to replicate the scenario. Below you can find more details about it.



Create a pod named volume-share-nautilus.

For the first container, use image fedora with latest tag only and remember to mention the tag i.e fedora:latest, container should be named as volume-container-nautilus-1, and run a sleep command for it so that it remains in running state. Volume volume-share should be mounted at path /tmp/beta.

For the second container, use image fedora with the latest tag only and remember to mention the tag i.e fedora:latest, container should be named as volume-container-nautilus-2, and again run a sleep command for it so that it remains in running state. Volume volume-share should be mounted at path /tmp/cluster.

Volume name should be volume-share of type emptyDir.

After creating the pod, exec into the first container i.e volume-container-nautilus-1, and just for testing create a file beta.txt with any content under the mounted path of first container i.e /tmp/beta.

The file beta.txt should be present under the mounted path /tmp/cluster on the second container volume-container-nautilus-2 as well, since they are using a shared volume.

Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.

#### Solution

Create the pod manifest
		
```bash

thor@jump_host ~$ vi pod.yaml
```

Populate the pod manifest with the pod specifications

```yaml 
apiVersion: v1
kind: Pod
metadata:
  name: volume-share-nautilus
  namespace: default
  labels:
    name: volume-share
spec:
  containers:
  - name: volume-container-nautilus-1
    image: fedora:latest
    command: ["sleep"]
    args: ["1000"]
    volumeMounts:
    - mountPath: /tmp/beta
      name: volume-share

  - name: volume-container-nautilus-2
    image: fedora:latest
    command: ["sleep"]
    args: ["1000"]
    volumeMounts:
    - mountPath: /tmp/cluster
      name: volume-share

  volumes:
  - name: volume-share
    emptyDir:
```

View the status of created pod

```bash 
thor@jump_host ~$ kubectl get pod
NAME                    READY   STATUS    RESTARTS   AGE
volume-share-nautilus   2/2     Running   0          9s
thor@jump_host ~$ 
```

Describe the created pod

```bash
thor@jump_host ~$ kubectl describe pod volume-share-nautilus
Name:         volume-share-nautilus
Namespace:    default
Priority:     0
Node:         kodekloud-control-plane/172.17.0.2
Start Time:   Mon, 06 Feb 2023 11:10:01 +0000
Labels:       name=volume-share
Annotations:  <none>
Status:       Running
IP:           10.244.0.6
IPs:
  IP:  10.244.0.6
Containers:
  volume-container-nautilus-1:
    Container ID:  containerd://3e604472b6d406cae2b2ae42de54ad104034b74f61784715dc732a7bd2abf064
    Image:         fedora:latest
    Image ID:      docker.io/library/fedora@sha256:3487c98481d1bba7e769cf7bcecd6343c2d383fdd6bed34ec541b6b23ef07664
    Port:          <none>
    Host Port:     <none>
    Command:
      sleep
    Args:
      1000
    State:          Running
      Started:      Mon, 06 Feb 2023 11:10:03 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /tmp/beta from volume-share (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-t9rs7 (ro)
  volume-container-nautilus-2:
    Container ID:  containerd://db4cfe7cf2b403f4b225ce2e36506c6c514e3255ed10927667177109d528701c
    Image:         fedora:latest
    Image ID:      docker.io/library/fedora@sha256:3487c98481d1bba7e769cf7bcecd6343c2d383fdd6bed34ec541b6b23ef07664
    Port:          <none>
    Host Port:     <none>
    Command:
      sleep
    Args:
      1000
    State:          Running
      Started:      Mon, 06 Feb 2023 11:10:04 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /tmp/cluster from volume-share (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-t9rs7 (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  volume-share:
    Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:     
    SizeLimit:  <unset>
  default-token-t9rs7:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-t9rs7
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                 node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  52s   default-scheduler  Successfully assigned default/volume-share-nautilus to kodekloud-control-plane
  Normal  Pulling    52s   kubelet            Pulling image "fedora:latest"
  Normal  Pulled     51s   kubelet            Successfully pulled image "fedora:latest" in 292.345297ms
  Normal  Created    51s   kubelet            Created container volume-container-nautilus-1
  Normal  Started    51s   kubelet            Started container volume-container-nautilus-1
  Normal  Pulling    51s   kubelet            Pulling image "fedora:latest"
  Normal  Pulled     50s   kubelet            Successfully pulled image "fedora:latest" in 360.213649ms
  Normal  Created    50s   kubelet            Created container volume-container-nautilus-2
  Normal  Started    50s   kubelet            Started container volume-container-nautilus-2
thor@jump_host ~$ 
```

Exec into the first container

```bash
thor@jump_host ~$ kubectl exec -it volume-share-nautilus -c volume-container-nautilus-1 /bin/bash
kubectl exec [POD] [COMMAND] is DEPRECATED and will be removed in a future version. Use kubectl exec [POD] -- [COMMAND] instead.
[root@volume-share-nautilus /]# 
```

Create the file *beta.txt* in the directory */tmp/beta/* with some text in it

```bash
[root@volume-share-nautilus /]# echo 'just a bunch of text' > /tmp/beta/beta.txt
[root@volume-share-nautilus /]#
```

Exit from inside container 1 and check whether the file *beta.txt* is present in the directory */tmp/cluster* inside the second container

```bash
thor@jump_host ~$ kubectl exec -it volume-share-nautilus -c volume-container-nautilus-2 -- ls -l /tmp/cluster
total 4
-rw-r--r-- 1 root root 21 Feb  6 11:21 beta.txt
thor@jump_host ~$ 
```

***The End***
