#### Scenario

The Nautilus DevOps team is planning to set up a Jenkins CI server to create/manage some deployment pipelines for some of the projects. They want to set up the Jenkins server on Kubernetes cluster. Below you can find more details about the task:



1) Create a namespace **jenkins**

2) Create a Service for jenkins deployment. Service name should be **jenkins-service** under jenkins namespace, type should be NodePort, **nodePort** should be **30008**

3) Create a Jenkins Deployment under jenkins namespace, It should be name as **jenkins-deployment** , labels app should be **jenkins** , container name should be **jenkins-container** , use **jenkins/jenkins** image , containerPort should be **8080** and replicas count should be **1**.

Make sure to wait for the pods to be in running state and make sure you are able to access the Jenkins login screen in the browser before hitting the Check button.

Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.

#### Solution

create the namespace

```bash
thor@jump_host ~$ kubectl create namespace jenkins
namespace/jenkins created
thor@jump_host ~$ 
```

View all namespaces to check the just created namespace

```bash
r@jump_host ~$ kubectl get namespaces
NAME                 STATUS   AGE
default              Active   147m
jenkins              Active   41s
kube-node-lease      Active   147m
kube-public          Active   147m
kube-system          Active   147m
local-path-storage   Active   146m
thor@jump_host ~$ 
```
Set the **jenkins** namespace as the default one

```bash
thor@jump_host ~$ kubectl config set-context --current --namespace=jenkins
Context "kind-kodekloud" modified.
thor@jump_host ~$ 
```

Verify *jenkins* is the default nameapce

```bash
thor@jump_host ~$ kubectl get all
No resources found in jenkins namespace.
thor@jump_host ~$ 
```

#### Create the deployment manifest file

```bash
thor@jump_host ~$ kubectl create deployment jenkins-deployment --image=jenkins/jenkins --replicas=1 --namespace=jenkins --dry-run=client -o yaml > jenkins-deployment.yaml
thor@jump_host ~$ 
```

Edit the deployment to match the [manifest file](jenkins-deployment.yaml)

```bash
thor@jump_host ~$ vi jenkins-deployment.yaml 
thor@jump_host ~$ 
```
 
Apply the configuration to create deployment resources: deployment, replicaSet and Pod

```bash
thor@jump_host ~$ kubectl apply -f jenkins-deployment.yaml 
deployment.apps/jenkins-deployment created
thor@jump_host ~$ 
```

Create the service manifest file

```bash
thor@jump_host ~$ kubectl expose deployment jenkins-deployment --type=NodePort --port=50000 --name=jenkins-service --dry-run=client -o yaml > jenkins-service.yaml
thor@jump_host ~$ 
```

Edit the service to match the [manifest file](jenkins-service.yaml)

```bash
thor@jump_host ~$ vi jenkins-service.yaml 
thor@jump_host ~$ 
```
 
Apply the configuration to create service resource

```bash
thor@jump_host ~$ kubectl apply -f jenkins-service.yaml service/jenkins-service created
thor@jump_host ~$ 
```

View all created resources

```bash
thor@jump_host ~$ kubectl get all
NAME                                     READY   STATUS    RESTARTS   AGE
pod/jenkins-deployment-98bd7fcf7-flspx   1/1     Running   0          7m4s

NAME                      TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)           AGE
service/jenkins-service   NodePort   10.96.249.161   <none>        50000:30008/TCP   3m54s

NAME                                 READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/jenkins-deployment   1/1     1            1           7m4s

NAME                                           DESIRED   CURRENT   READY   AGE
replicaset.apps/jenkins-deployment-98bd7fcf7   1         1         1       7m4s
thor@jump_host ~$ 
```

View the jenkins web page on the browser

Kubernetes Jenkins Deployment              |  
:-------------------------:|
![Kubernetes Jenkins Deployment](../images/k8s-jenkins-deployment.JPG)


***The End***

