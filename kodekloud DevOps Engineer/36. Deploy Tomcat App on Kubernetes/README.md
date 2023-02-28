#### Task

A new java-based application is ready to be deployed on a Kubernetes cluster. The development team had a meeting with the DevOps team to share the requirements and application scope. The team is ready to setup an application stack for it under their existing cluster. Below you can find the details for this:



Create a namespace named tomcat-namespace-xfusion.

Create a deployment for tomcat app which should be named as tomcat-deployment-xfusion under the same namespace you created. Replica count should be 1, the container should be named as tomcat-container-xfusion, its image should be gcr.io/kodekloud/centos-ssh-enabled:tomcat and its container port should be 8080.

Create a service for tomcat app which should be named as tomcat-service-xfusion under the same namespace you created. Service type should be NodePort and nodePort should be 32227.

Before clicking on Check button please make sure the application is up and running.

You can use any labels as per your choice.

Note: The kubectl on jump_host has been configured to work with the kubernetes cluster.

#### solution

Create the namespace

```bash

thor@jump_host ~$ kubectl create namespace tomcat-namespace-xfusion
namespace/tomcat-namespace-xfusion created
thor@jump_host ~$ 
```

Create deployment

```bash
thor@jump_host ~$ kubectl create deployment tomcat-deployment-xfusion --image=gcr.io/kodekloud/centos-ssh-enabled:tomcat --replicas=1 --namespace=tomcat-namespace-xfusion -o=yaml --dry-run=client > deploy.yaml
thor@jump_host ~$ 
```

Update the deployment manifest

```bash

apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: tomcat-deployment-xfusion
  name: tomcat-deployment-xfusion
  namespace: tomcat-namespace-xfusion
spec:
  replicas: 1
  selector:
    matchLabels:
      app: tomcat-deployment-xfusion
  template:
    metadata:
      labels:
        app: tomcat-deployment-xfusion
    spec:
      containers:
      - image: gcr.io/kodekloud/centos-ssh-enabled:tomcat
        name: tomcat-container-xfusion
        ports:
          - containerPort: 8080
```

Set the created namespace *tomcat-namespace-xfusion* as the current context

```bash
thor@jump_host ~$ kubectl config set-context --current --namespace=tomcat-namespace-xfusion
Context "kind-kodekloud" modified.
thor@jump_host ~$ 
```


Apply the deployment definition to create defined objects

```bash
thor@jump_host ~$ kubectl apply -f deploy.yaml 
deployment.apps/tomcat-deployment-xfusion created
thor@jump_host ~$
```

View created objects created

```bash
thor@jump_host ~$ kubectl get allNAME                                             READY   STATUS    RESTARTS   AGE
pod/tomcat-deployment-xfusion-5cc9cbb5f6-n2c9c   1/1     Running   0          108s

NAME                                        READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/tomcat-deployment-xfusion   1/1     1            1           108s

NAME                                                   DESIRED   CURRENT   READY   AGE
replicaset.apps/tomcat-deployment-xfusion-5cc9cbb5f6   1         1         1       108s
thor@jump_host ~$ 
```

Expose the deployment as a service

```bash
thor@jump_host ~$ kubectl expose deployment tomcat-deployment-xfusion --type=NodePort  --port=8080 --name=tomcat-service-xfusion --dry-run=client -o yaml > service.yaml
thor@jump_host ~$ 
```

Update the service definition file

```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app: tomcat-deployment-xfusion
  name: tomcat-service-xfusion
spec:
  ports:
  - port: 8080
    nodePort: 32227
    protocol: TCP
    targetPort: 8080
  selector:
    app: tomcat-deployment-xfusion
  type: NodePort
```

Apply the service definition to create the service object

```bash
thor@jump_host ~$ kubectl apply -f service.yaml 
service/tomcat-service-xfusion created
thor@jump_host ~$ 
```

View the created service

```bash

thor@jump_host ~$ kubectl get service
NAME                     TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
tomcat-service-xfusion   NodePort   10.96.10.218   <none>        8080:32227/TCP   37s
thor@jump_host ~$ 
```

***The End***
