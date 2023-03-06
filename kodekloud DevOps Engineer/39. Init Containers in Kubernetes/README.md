#### Task

There are some applications that need to be deployed on Kubernetes cluster and these apps have some pre-requisites where some configurations need to be changed before deploying the app container. Some of these changes cannot be made inside the images so the DevOps team has come up with a solution to use init containers to perform these tasks during deployment. Below is a sample scenario that the team is going to test first.



Create a Deployment named as ic-deploy-devops.

Configure spec as replicas should be 1, labels app should be ic-devops, template's metadata lables app should be the same ic-devops.

The initContainers should be named as ic-msg-devops, use image debian, preferably with latest tag and use command '/bin/bash', '-c' and 'echo Init Done - Welcome to xFusionCorp Industries > /ic/official'. The volume mount should be named as ic-volume-devops and mount path should be /ic.

Main container should be named as ic-main-devops, use image debian, preferably with latest tag and use command '/bin/bash', '-c' and 'while true; do cat /ic/official; sleep 5; done'. The volume mount should be named as ic-volume-devops and mount path should be /ic.

Volume to be named as ic-volume-devops and it should be an emptyDir type.

Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.


#### Solution

Create the deployment manifest

```bash

thor@jump_host ~$ kubectl create deployment ic-deploy-devops --replicas=1 --image=debian:latest -o yaml --dry-run=client > ic-deploy-devops.yaml
thor@jump_host ~$ 
```

Edit the deployment manifest and update with the specifications provided

```bash
thor@jump_host ~$ sudo vi ic-deploy-devops.yaml 

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for thor: 
thor@jump_host ~$ 
```

ic-deploy-devops.yaml

```yaml
deploymen
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: ic-deploy-devops
  name: ic-deploy-devops
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ic-devops
  template:
    metadata:
      labels:
        app: ic-devops
    spec:
      containers:
      - image: debian:latest
        name: ic-main-devops
        command: ["/bin/bash"]
        args: ["-c", "while true; do cat /ic/official; sleep 5; done"]
        volumeMounts:
        - mountPath: /ic
          name: ic-volume-devops


      initContainers:
      - image: debian:latest
        name: ic-msg-devops
        command: ["/bin/bash"]
        args: ["-c", "echo Init Done - Welcome to xFusionCorp Industries > /ic/official"]
        volumeMounts:
        - mountPath: /ic
          name: ic-volume-devops

      volumes:
      - name: ic-volume-devops
        emptyDir:
```
     
Apply the manifest file

```bash
thor@jump_host ~$ kubectl apply -f ic-deploy-devops.yaml 
deployment.apps/ic-deploy-devops created
thor@jump_host ~$ 
```

View created objects

```bash

thor@jump_host ~$ kubectl get all
NAME                                    READY   STATUS    RESTARTS   AGE
pod/ic-deploy-devops-5749cb6798-gzvll   1/1     Running   0          37s

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   74m

NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/ic-deploy-devops   1/1     1            1           37s

NAME                                          DESIRED   CURRENT   READY   AGE
replicaset.apps/ic-deploy-devops-5749cb6798   1         1         1       37s
thor@jump_host ~$ 
```