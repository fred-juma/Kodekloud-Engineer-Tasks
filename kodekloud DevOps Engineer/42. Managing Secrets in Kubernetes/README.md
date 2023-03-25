#### Task

The Nautilus DevOps team is working to deploy some tools in Kubernetes cluster. Some of the tools are licence based so that licence information needs to be stored securely within Kubernetes cluster. Therefore, the team wants to utilize Kubernetes secrets to store those secrets. Below you can find more details about the requirements:



We already have a secret key file official.txt under /opt location on jump host. Create a generic secret named official, it should contain the password/license-number present in official.txt file.

Also create a pod named secret-xfusion.

Configure pod's spec as container name should be secret-container-xfusion, image should be centos preferably with latest tag (remember to mention the tag with image). Use sleep command for container so that it remains in running state. Consume the created secret and mount it under /opt/demo within the container.

To verify you can exec into the container secret-container-xfusion, to check the secret key under the mounted path /opt/demo. Before hitting the Check button please make sure pod/pods are in running state, also validation can take some time to complete so keep patience.

#### Solution

Create the secret object

```bash
thor@jump_host ~$ kubectl create secret generic official \
> --from-file=/opt/official.txt
secret/official created
thor@jump_host ~$ 
```

Get the created secret

```bash

thor@jump_host ~$ kubectl get secret
NAME                  TYPE                                  DATA   AGE
default-token-dfnqz   kubernetes.io/service-account-token   3      152m
official              Opaque                                1      16s
thor@jump_host ~$ 
```

Describe the created secret

```bash
thor@jump_host ~$ kubectl describe secret official
Name:         official
Namespace:    default
Labels:       <none>
Annotations:  <none>

Type:  Opaque

Data
====
official.txt:  7 bytes
thor@jump_host ~$ 
```

Create pod manifest

```bash

thor@jump_host ~$ kubectl run secret-xfusion --image=centos:latest -o yaml --dry-run=client --command -- sleep 4800 > secret-xfusion.yaml
thor@jump_host ~$ 
```

Edit the manifest to edit container name, add secret volume and volumeMount path


```bash

thor@jump_host ~$ vi secret-xfusion.yaml 

apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: secret-xfusion
  name: secret-xfusion
spec:
  volumes:
  - name: official-secret-volume
    secret:
      secretName: official
  containers:
  - command:
    - sleep
    - "4800"
    image: centos:latest
    name: secret-container-xfusion
    volumeMounts:
    - name: official-secret-volume
      readOnly: true
      mountPath: "/opt/demo"
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```


Create the pod object

```bash
thor@jump_host ~$ kubectl create -f secret-xfusion.yaml 
pod/secret-xfusion created
thor@jump_host ~$ 
```

Get the pod

```bash
thor@jump_host ~$ kubectl get pod
NAME             READY   STATUS    RESTARTS   AGE
secret-xfusion   1/1     Running   0          26s
thor@jump_host ~$ 
```

Exec into the pod container to confirm the volume is mounted and secret object is present


```bash

thor@jump_host ~$ kubectl exec secret-xfusion -it -- /bin/bash 
[root@secret-xfusion /]# ls /opt/demo/
official.txt
[root@secret-xfusion /]# cat /opt/demo/official.txt 
5ecur3
[root@secret-xfusion /]# 
```

***The End***
