### Instructions
The Nautilus DevOps team has started practicing some pods, and services deployment on Kubernetes platform, as they are planning to migrate most of their applications on Kubernetes. Recently one of the team members has been assigned a task to create a deploymnt as per details mentioned below:

Create a deployment named nginx to deploy the application nginx using the image nginx:latest (remember to mention the tag as well)

Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.

### Solution
#### create the deployment file using vi text editor, populate the file with the deployment configureations as referenced [here](deployment.yaml)

```bash
thor@jump_host ~$ sudo vi deployment.yaml

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for thor: 
thor@jump_host ~$ 
```

#### Run the deployment to create it using the *kubectl* utility

```bash
thor@jump_host ~$ kubectl apply -f deployment.yaml 
deployment.apps/nginx created
thor@jump_host ~$ 
````


#### Confirm the successful creation of the deployment
```bash
thor@jump_host ~$ kubectl get deployment
NAME    READY   UP-TO-DATE   AVAILABLE   AGE
nginx   1/1     1            1           20s
thor@jump_host ~$ 
```

#### Confirm that the specified number of pod replicas are created and running
```bash
thor@jump_host ~$ kubectl get pods
NAME                     READY   STATUS    RESTARTS   AGE
nginx-675bf46755-bbwsj   1/1     Running   0          37s
thor@jump_host ~$ 
```

***The End***