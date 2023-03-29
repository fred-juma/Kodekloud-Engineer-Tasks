#### Task

There is an application deployed on Kubernetes cluster. Recently, the Nautilus application development team developed a new version of the application that needs to be deployed now. As per new updates some new changes need to be made in this existing setup. So update the deployment and service as per details mentioned below:



We already have a deployment named nginx-deployment and service named nginx-service. Some changes need to be made in this deployment and service, make sure not to delete the deployment and service.

1.) Change the service nodeport from 30008 to 32165

2.) Change the replicas count from 1 to 5

3.) Change the image from nginx:1.19 to nginx:latest


#### Solution

Get deployment present in the cluster

```bash

thor@jump_host ~$ kubectl get deployment
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   1/1     1            1           73s
thor@jump_host ~$ 
```

Set the image to *nginx:latest*

```bash
thor@jump_host ~$ kubectl set image deployment nginx-deployment nginx-container=nginx:latest
deployment.apps/nginx-deployment image updated
thor@jump_host ~$ 
```

Edit the deployment and increase replicas count from 1 t0 5

```bash

thor@jump_host ~$ kubectl edit deployment nginx-deployment
deployment.apps/nginx-deployment edited
```

Get the deployment and confirm replicas scaled to 5

```bash
thor@jump_host ~$ kubectl get deployment
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   5/5     5            5           4m41s
thor@jump_host ~$ 
```

Get service in the cluster

```bash
thor@jump_host ~$ kubectl get svc
NAME            TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
kubernetes      ClusterIP   10.96.0.1       <none>        443/TCP        3h50m
nginx-service   NodePort    10.96.199.234   <none>        80:30008/TCP   5m8s
```

Edit the *nginx-service* and change nodeport to *32165*

```bash
thor@jump_host ~$ kubectl edit svc nginx-service
service/nginx-service edited
```

Get the service and confirm the port number changed

```bash
thor@jump_host ~$ kubectl get svc
NAME            TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
kubernetes      ClusterIP   10.96.0.1       <none>        443/TCP        3h51m
nginx-service   NodePort    10.96.199.234   <none>        80:32165/TCP   5m41s
thor@jump_host ~$ 
```

Get all resources in the cluster, to confirm all 5 pods are up and running as defined

```bash
thor@jump_host ~$ kubectl get all
NAME                                   READY   STATUS    RESTARTS   AGE
pod/nginx-deployment-c7ff8fb84-8v2v7   1/1     Running   0          98s
pod/nginx-deployment-c7ff8fb84-fj4js   1/1     Running   0          98s
pod/nginx-deployment-c7ff8fb84-km2lk   1/1     Running   0          3m3s
pod/nginx-deployment-c7ff8fb84-ks82z   1/1     Running   0          98s
pod/nginx-deployment-c7ff8fb84-m9rgt   1/1     Running   0          98s

NAME                    TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
service/kubernetes      ClusterIP   10.96.0.1       <none>        443/TCP        3h51m
service/nginx-service   NodePort    10.96.199.234   <none>        80:32165/TCP   6m12s

NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx-deployment   5/5     5            5           6m12s

NAME                                          DESIRED   CURRENT   READY   AGE
replicaset.apps/nginx-deployment-57bf6d6978   0         0         0       6m11s
replicaset.apps/nginx-deployment-c7ff8fb84    5         5         5       3m3s
thor@jump_host ~$ 
```

***The End***

