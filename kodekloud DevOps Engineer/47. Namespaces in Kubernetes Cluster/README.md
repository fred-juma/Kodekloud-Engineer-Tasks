#### Task
Create Namespaces in Kubernetes Cluster

The Nautilus DevOps team is planning to deploy some micro services on Kubernetes platform. The team has already set up a Kubernetes cluster and now they want set up some namespaces, deployments etc. Based on the current requirements, the team has shared some details as below:



Create a namespace named dev and create a POD under it; name the pod dev-nginx-pod and use nginx image with latest tag only and remember to mention tag i.e nginx:latest.

Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.


#### Solution

Create *dev* namespace

```bash
thor@jump_host ~$ kubectl create namespace dev
namespace/dev created
thor@jump_host ~$ 
```

Create *dev-nginx-pod* pod

```bash
thor@jump_host ~$ kubectl run dev-nginx-pod --namespace=dev --image=nginx:latest
pod/dev-nginx-pod created
thor@jump_host ~$ 
```

View running pods

```bash
thor@jump_host ~$ kubectl get pod --namespace=dev
NAME            READY   STATUS    RESTARTS   AGE
dev-nginx-pod   1/1     Running   0          15s
thor@jump_host ~$ 
```