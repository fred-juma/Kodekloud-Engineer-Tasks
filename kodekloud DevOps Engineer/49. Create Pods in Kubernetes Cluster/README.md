#### Task

The Nautilus DevOps team has started practicing some pods and services deployment on Kubernetes platform as they are planning to migrate most of their applications on Kubernetes platform. Recently one of the team members has been assigned a task to create a pod as per details mentioned below:



Create a pod named pod-httpd using httpd image with latest tag only and remember to mention the tag i.e httpd:latest.

Labels app should be set to httpd_app, also container should be named as httpd-container.

Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.

#### Solution

Create pod manifest

```bash

thor@jump_host ~$ kubectl run pod-httpd --image=httpd:latest --labels=app=httpd_app -o yaml --dry-run=client > pod-httpd.yml
```

Edit the pod manifest and update the container name

```bash
thor@jump_host ~$ vi pod-httpd.yml

apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    app: httpd_app
  name: pod-httpd
spec:
  containers:
  - image: httpd:latest
    name: httpd-container
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```


Apply the pod manifest to create the object

```bash
thor@jump_host ~$ kubectl apply -f pod-httpd.yml 
pod/pod-httpd created
thor@jump_host ~$ 
```

View created pod

```bash
thor@jump_host ~$ kubectl get pod
NAME        READY   STATUS    RESTARTS   AGE
pod-httpd   1/1     Running   0          13s
thor@jump_host ~$ 
```