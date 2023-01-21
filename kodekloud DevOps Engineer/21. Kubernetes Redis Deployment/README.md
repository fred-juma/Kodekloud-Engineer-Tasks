#### Task

The Nautilus application development team observed some performance issues with one of the application that is deployed in Kubernetes cluster. After looking into number of factors, the team has suggested to use some in-memory caching utility for DB service. After number of discussions, they have decided to use Redis. Initially they would like to deploy Redis on kubernetes cluster for testing and later they will move it to production. Please find below more details about the task:



Create a redis deployment with following parameters:

Create a config map called my-redis-config having maxmemory 2mb in redis-config.

Name of the deployment should be redis-deployment, it should use redis:alpine image and container name should be redis-container. Also make sure it has only 1 replica.

The container should request for 1 CPU.

Mount 2 volumes:

a. An Empty directory volume called data at path /redis-master-data.

b. A configmap volume called redis-config at path /redis-master.

c. The container should expose the port 6379.

Finally, redis-deployment should be in an up and running state.
Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.

#### Solution

```bash
thor@jump_host ~$  kubectl create configmap my-redis-config --from-literal=maxmemory=2mb 
```

Or you can create the yaml definition as below:
```yaml
apiVersion: v1

kind: ConfigMap
metadata:
  name: my-redis-config
data:
  maxmemory: 2mb

```

View the created resource

```bash


thor@jump_host ~$ kubectl get configmap
NAME               DATA   AGE
kube-root-ca.crt   1      75m
my-redis-config    1      7s
thor@jump_host ~$ 
```

Create the deployment manifest

```bash
thor@jump_host ~$ kubectl create deployment redis-deployment --image=redis:alpine--replica=1 -o yaml --dry-run=client > redis-deployment.yaml
thor@jump_host ~$ 
```

Update the manifest with the commands provided

```bash

apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis-deployment
  template:
    metadata:
      labels:
        app: redis-deployment
    spec:
      containers:
        - name: redis-container
          image: redis:alpine
          ports:
            - containerPort: 6379
          resources:
            requests:
              cpu: "1"
          volumeMounts:
            - mountPath: /redis-master-data
              name: data
            - mountPath: /redis-master
              name: redis-config
      volumes:
      - name: data
        emptyDir: {}
      - name: redis-config
        configMap:
          name: my-redis-config
```

Apply the deployment manifest

```bash
thor@jump_host ~$ kubectl apply -f redis-deployment.yaml 
deployment.apps/redis-deployment created
thor@jump_host ~$ 
```

***The End***





