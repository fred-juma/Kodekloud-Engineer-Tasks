#### Task

The Nautilus development team has completed development of one of the node applications, which they are planning to deploy on a Kubernetes cluster. They recently had a meeting with the DevOps team to share their requirements. Based on that, the DevOps team has listed out the exact requirements to deploy the app. Find below more details:



Create a deployment using gcr.io/kodekloud/centos-ssh-enabled:node image, replica count must be 2.

Create a service to expose this app, the service type must be NodePort, targetPort must be 8080 and nodePort should be 30012.

Make sure all the pods are in Running state after the deployment.

You can check the application by clicking on NodeApp button on top bar.

You can use any labels as per your choice.

Note: The kubectl on jump_host has been configured to work with the kubernetes cluster.

#### Solution

Create deployment
```bash

thor@jump_host ~$ kubectl create deployment --image=gcr.io/kodekloud/centos-ssh-enabled:node --replicas=2 node
deployment.apps/node created
thor@jump_host ~$ 
```


Check that the resources are created

```bash

thor@jump_host ~$ watch kubectl get all

Every 2.0s: kubectl get all                                                                                                                            Mon Jan 16 07:28:20 2023

NAME                        READY   STATUS    RESTARTS   AGE
pod/node-6b49f77658-rfkwp   1/1     Running   0          109s
pod/node-6b49f77658-t5vmz   1/1     Running   0          109s

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   126m

NAME                   READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/node   2/2     2            2           109s

NAME                              DESIRED   CURRENT   READY   AGE
replicaset.apps/node-6b49f77658   2         2         2       109s
```

Create service definition file

```bash
thor@jump_host ~$ kubectl expose deployment node --type=NodePort  --port=8080 --name=node-service --dry-run=client -o yaml > node-service.yaml
thor@jump_host ~$ 
```

Update the file with the provided parameters

```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app: node
  name: node-service
spec:
  ports:
  - port: 8080
    targetPort: 8080
    nodePort: 30012
  selector:
  	```

Apply the service definition file 

```bash
thor@jump_host ~$ kubectl apply -f node-service.yaml 
service/node-service created
```

View all created resources

```bash

thor@jump_host ~$ kubectl get all
NAME                        READY   STATUS    RESTARTS   AGE
pod/node-6b49f77658-rfkwp   1/1     Running   0          12m
pod/node-6b49f77658-t5vmz   1/1     Running   0          12m

NAME                   TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
service/kubernetes     ClusterIP   10.96.0.1      <none>        443/TCP          2m6s
service/node-service   NodePort    10.96.59.166   <none>        8080:30012/TCP   33s

NAME                   READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/node   2/2     2            2           12m

NAME                              DESIRED   CURRENT   READY   AGE
replicaset.apps/node-6b49f77658   2         2         2       12m
thor@jump_host ~$ 
```

Visit the resulting node app through the service port to see its contents


Kubernetes Node Deployment              |  
:-------------------------:|
![Kubernetes Node Deployment](https://github.com/fred-juma/Kodekloud-Engineer-Tasks/blob/main/images/node.JPG)

***The End***
