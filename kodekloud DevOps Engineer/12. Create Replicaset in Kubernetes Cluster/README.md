#### Task

The Nautilus DevOps team is going to deploy some applications on kubernetes cluster as they are planning to migrate some of their existing applications there. Recently one of the team members has been assigned a task to write a template as per details mentioned below:



Create a ReplicaSet using httpd image with latest tag only and remember to mention tag i.e httpd:latest and name it as httpd-replicaset.

Labels app should be httpd_app, labels type should be front-end. The container should be named as httpd-container; also make sure replicas counts are 4.

Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.


Create the replicaSet definitio file and populate it with the specified [configs](httpd-replicaset.yaml)

```bash

thor@jump_host ~$ sudo vi httpd-replicaset.yaml

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for thor: 
thor@jump_host ~$ 
```



Apply the definition file

```bash

thor@jump_host ~$ kubectl apply -f httpd-replicaset.yaml 
replicaset.apps/httpd-replicaset created
thor@jump_host ~$ 
```

List all created resources

```bash
thor@jump_host ~$ kubectl get all
NAME                         READY   STATUS    RESTARTS   AGE
pod/httpd-replicaset-2lhpl   1/1     Running   0          21s
pod/httpd-replicaset-dw864   1/1     Running   0          21s
pod/httpd-replicaset-jf2zn   1/1     Running   0          21s
pod/httpd-replicaset-qzcjk   1/1     Running   0          21s

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   17m

NAME                               DESIRED   CURRENT   READY   AGE
replicaset.apps/httpd-replicaset   4         4         4       21s
thor@jump_host ~$ 
```

Describe the replicaSet

```bash
thor@jump_host ~$ kubectl describe replicaset httpd-replicaset
Name:         httpd-replicaset
Namespace:    default
Selector:     app=httpd_app,type=front-end
Labels:       app=httpd_app
              type=front-end
Annotations:  <none>
Replicas:     4 current / 4 desired
Pods Status:  4 Running / 0 Waiting / 0 Succeeded / 0 Failed
Pod Template:
  Labels:  app=httpd_app
           type=front-end
  Containers:
   httpd-container:
    Image:        httpd:latest
    Port:         <none>
    Host Port:    <none>
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Events:
  Type    Reason            Age   From                   Message
  ----    ------            ----  ----                   -------
  Normal  SuccessfulCreate  45s   replicaset-controller  Created pod: httpd-replicaset-dw864
  Normal  SuccessfulCreate  45s   replicaset-controller  Created pod: httpd-replicaset-jf2zn
  Normal  SuccessfulCreate  45s   replicaset-controller  Created pod: httpd-replicaset-qzcjk
  Normal  SuccessfulCreate  45s   replicaset-controller  Created pod: httpd-replicaset-2lhpl
thor@jump_host ~$ 
```

***The End***