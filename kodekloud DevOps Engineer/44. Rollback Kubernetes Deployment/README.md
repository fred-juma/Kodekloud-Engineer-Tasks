#### Task

This morning the Nautilus DevOps team rolled out a new release for one of the applications. Recently one of the customers logged a complaint which seems to be about a bug related to the recent release. Therefore, the team wants to rollback the recent release.



There is a deployment named nginx-deployment; roll it back to the previous revision.

Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.


#### Solution

Get all objects in the cluster default namespace

```bash

thor@jump_host ~$ kubectl get all
NAME                                    READY   STATUS    RESTARTS   AGE
pod/nginx-deployment-5546d5b87b-88pkg   1/1     Running   0          2m39s
pod/nginx-deployment-5546d5b87b-dnc59   1/1     Running   0          2m36s
pod/nginx-deployment-5546d5b87b-jlqrd   1/1     Running   0          2m57s

NAME                    TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
service/kubernetes      ClusterIP   10.96.0.1       <none>        443/TCP        117m
service/nginx-service   NodePort    10.96.139.198   <none>        80:30008/TCP   3m8s

NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx-deployment   3/3     3            3           3m8s

NAME                                          DESIRED   CURRENT   READY   AGE
replicaset.apps/nginx-deployment-5546d5b87b   3         3         3       2m57s
replicaset.apps/nginx-deployment-74fb588559   0         0         0       3m8s
thor@jump_host ~$ 
```

rollback the deployment

```bash

thor@jump_host ~$ kubectl rollout  undo deployment nginx-deployment
deployment.apps/nginx-deployment rolled back
thor@jump_host ~$ 
```

Get the deployment and other objects status after rollback

```bash
thor@jump_host ~$ kubectl get all
NAME                                    READY   STATUS              RESTARTS   AGE
pod/nginx-deployment-5546d5b87b-88pkg   1/1     Terminating         0          3m8s
pod/nginx-deployment-5546d5b87b-jlqrd   1/1     Running             0          3m26s
pod/nginx-deployment-74fb588559-krhzf   0/1     ContainerCreating   0          1s
pod/nginx-deployment-74fb588559-shnwj   1/1     Running             0          12s
pod/nginx-deployment-74fb588559-zqwvw   1/1     Running             0          5s

NAME                    TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
service/kubernetes      ClusterIP   10.96.0.1       <none>        443/TCP        118m
service/nginx-service   NodePort    10.96.139.198   <none>        80:30008/TCP   3m37s

NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx-deployment   3/3     3            3           3m37s

NAME                                          DESIRED   CURRENT   READY   AGE
replicaset.apps/nginx-deployment-5546d5b87b   1         1         1       3m26s
replicaset.apps/nginx-deployment-74fb588559   3         3         2       3m37s
thor@jump_host ~$ 
```


***The End***



