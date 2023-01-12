#### Task

The Nautilus DevOps team is planning to set up a Nagios monitoring tool to monitor some applications, services etc. They are planning to deploy it on Kubernetes cluster. Below you can find more details.



1) Create a deployment nagios-deployment for Nagios core. The container name must be nagios-container and it must use jasonrivers/nagios image.

2) Create a user and password for the Nagios core web interface, user must be xFusionCorp and password must be LQfKeWWxWD. (you can manually perform this step after deployment)

3) Create a service nagios-service for Nagios, which must be of targetPort type. nodePort must be 30008.

You can use any labels as per your choice.

Note: The kubectl on jump_host has been configured to work with the kubernetes cluster.

#### Solution

Create the deployment manifest definition


```bash

thor@jump_host ~$ kubectl create deployment --image=jasonrivers/nagios nagios-deployment --replicas=2 --dry-run=client -o yaml > nagios-deployment.yaml
thor@jump_host ~$ 
```

Inspect the [depolyment](nagios-deployment.yaml) definition and ensure it is correct

Then apply the deployment definition to create the deployment resources

```bash
thor@jump_host ~$ kubectl apply -f nagios-deployment.yaml 
deployment.apps/nagios-deployment created
thor@jump_host ~$ 
```

Create the service definition file

```bash
thor@jump_host ~$ kubectl expose deployment nagios-deployment --type=NodePort  --port=80 --name=nagios-service --dry-run=client -o yaml > nagios-service.yaml
thor@jump_host ~$ 
```

Inspect the [depolyment](nagios-service.yaml) definition and ensure it is correct

Then apply the service definition to create the service resource
```bash
thor@jump_host ~$ kubectl apply -f nagios-service.yaml 
service/nagios-service created
thor@jump_host ~$ 
```

View all created resources 

```bash

thor@jump_host ~$ kubectl get all
NAME                                     READY   STATUS    RESTARTS   AGE
pod/nagios-deployment-74ccd9c66d-rnlg9   1/1     Running   0          2m15s

NAME                     TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
service/kubernetes       ClusterIP   10.96.0.1      <none>        443/TCP        123m
service/nagios-service   NodePort    10.96.207.99   <none>        80:30008/TCP   26s

NAME                                READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nagios-deployment   1/1     1            1           2m15s

NAME                                           DESIRED   CURRENT   READY   AGE
replicaset.apps/nagios-deployment-74ccd9c66d   1         1         1       2m15s
thor@jump_host ~$ 
```

Log in interractively in the pod and create the nagios username and password

```bash
thor@jump_host ~$ kubectl exec -it nagios-deployment-74ccd9c66d-rnlg9 -- /bin/bash
root@nagios-deployment-74ccd9c66d-rnlg9:/# htpasswd /opt/nagios/etc/htpasswd.users xFusionCorp
New password: 
Re-type new password: 
Adding password for user xFusionCorp
root@nagios-deployment-74ccd9c66d-rnlg9:/# 
```

View the nagios deployment through the service port

Kubernetes Nagios Deployment              |  
:-------------------------:|
![Kubernetes Jenkins Deployment](https://github.com/fred-juma/Kodekloud-Engineer-Tasks/blob/main/images/nagios.JPG)

***The End***