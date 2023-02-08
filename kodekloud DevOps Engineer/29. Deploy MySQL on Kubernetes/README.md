#### Instructiona

A new MySQL server needs to be deployed on Kubernetes cluster. The Nautilus DevOps team was working on to gather the requirements. Recently they were able to finalize the requirements and shared them with the team members to start working on it. Below you can find the details:



1.) Create a PersistentVolume mysql-pv, its capacity should be 250Mi, set other parameters as per your preference.

2.) Create a PersistentVolumeClaim to request this PersistentVolume storage. Name it as mysql-pv-claim and request a 250Mi of storage. Set other parameters as per your preference.

3.) Create a deployment named mysql-deployment, use any mysql image as per your preference. Mount the PersistentVolume at mount path /var/lib/mysql.

4.) Create a NodePort type service named mysql and set nodePort to 30007.

5.) Create a secret named mysql-root-pass having a key pair value, where key is password and its value is YUIidhb667, create another secret named mysql-user-pass having some key pair values, where frist key is username and its value is kodekloud_aim, second key is password and value is YchZHRcLkL, create one more secret named mysql-db-url, key name is database and value is kodekloud_db9

6.) Define some Environment variables within the container:

a) name: MYSQL_ROOT_PASSWORD, should pick value from secretKeyRef name: mysql-root-pass and key: password

b) name: MYSQL_DATABASE, should pick value from secretKeyRef name: mysql-db-url and key: database

c) name: MYSQL_USER, should pick value from secretKeyRef name: mysql-user-pass key key: username

d) name: MYSQL_PASSWORD, should pick value from secretKeyRef name: mysql-user-pass and key: password

Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.


#### Solutions

Create the persistent volume manifest file
```bash
thor@jump_host ~$ vi mysql-pv.yaml
```

```yaml

apiVersion: v1
kind: PersistentVolume
metadata: 
  name: mysql-pv
spec: 
  accessModes: 
    - ReadWriteOnce
  capacity: 
    storage: 250Mi
  hostPath:
    path: /tmd/data
```

Apply the pv manifest 

```bash
thor@jump_host ~$ kubectl apply -f mysql-pv.yaml 
persistentvolume/mysql-pv created
thor@jump_host ~$ 
```

Create the persistent volume claim manifest

```bash
thor@jump_host ~$ vi mysql-pv-claim.yaml
```
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata: 
  name: mysql-pv-claim
spec: 
  accessModes: 
    - ReadWriteOnce
  resources:
    requests: 
      storage: 250Mi
```

Apply the pvc manifest

```bash
thor@jump_host ~$ kubectl apply -f mysql-pv-claim.yaml 
persistentvolumeclaim/mysql-pv-claim created
thor@jump_host ~$ 
```

Create the deployment manifest

```bash
thor@jump_host ~$ kubectl create deployment mysql-deployment --image=mysql -o yaml --dry-run=client > mysql-deployment.yaml
thor@jump_host ~$ 
```

Edit the manifest file to mount the pv

```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
    labels:
        app: mysql-deployment
    name: mysql-deployment
spec:
    replicas: 1
    selector:
        matchLabels:
            app: mysql-deployment
    template:
        metadata:
            labels:
                app: mysql-deployment
        spec:
            containers:
                - image: mysql
                  name: mysql
                  
                  volumeMounts:
                    -  mountPath: "/var/lib/mysql"
                       name: mysql-pv
            volumes:
                - name: mysql-pv
                  persistentVolumeClaim:
                    claimName: mysql-pv-claim
```

Apply the deployment manifest

```bash
thor@jump_host ~$ kubectl apply -f mysql-deployment.yaml 
deployment.apps/mysql-deployment created
thor@jump_host ~$ 
```

Expose the service as type NodePort

```bash
thor@jump_host ~$ kubectl expose deployment mysql-deployment --type=NodePort --port=80 --name=mysql-service --dry-run=client -o yaml > mysql-service.yaml
thor@jump_host ~$ 



apiVersion: v1
kind: Service
metadata:
  labels:
    app: mysql-deployment
  name: mysql
spec:
  ports:
  - port: 80
    nodePort: 30007
    protocol: TCP
    targetPort: 80
  selector:
    app: mysql-deployment
  type: NodePort
```

Apply the service manifest

```bash

thor@jump_host ~$ kubectl apply -f mysql-service.yaml 
service/mysql-service created
thor@jump_host ~$
```

Create *mysql-root-pass* secret object

```bash
thor@jump_host ~$ kubectl create secret generic mysql-root-pass --from-literal=password=YUIidhb667
secret/mysql-root-pass created
thor@jump_host ~$ 
```

Create *mysql-db-url* secret object

```bash
thor@jump_host ~$ kubectl create secret generic mysql-db-url --from-literal=database=kodekloud_db5
secret/mysql-db-url created
thor@jump_host ~$
```

Create *mysql-user-pass* secret object

```bash
thor@jump_host ~$ kubectl create secret generic mysql-user-pass \
> --from-literal=username=kodekloud_roy \
> --from-literal=password=8FmzjvFU6S
secret/mysql-user-pass created
thor@jump_host ~$
```

Update the deployment definition with the environment varaibale from the secret objects created above

```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
    labels:
        app: mysql-deployment
    name: mysql-deployment
spec:
    replicas: 1
    selector:
        matchLabels:
            app: mysql-deployment
    template:
        metadata:
            labels:
                app: mysql-deployment
        spec:
            containers:
                - image: mysql
                  name: mysql
                  env:
                    - name: MYSQL_ROOT_PASSWORD
                      valueFrom:
                        secretKeyRef:
                            name: mysql-root-pass
                            key: password
                    - name: MYSQL_DATABASE
                      valueFrom:
                        secretKeyRef:
                            name: mysql-db-url
                            key: database

                    - name: MYSQL_USER
                      valueFrom:
                        secretKeyRef:
                            name: mysql-user-pass
                            key: username
                    
                    - name: MYSQL_PASSWORD
                      valueFrom:
                        secretKeyRef:
                            name: mysql-user-pass
                            key: password
                
                  volumeMounts:
                    -  mountPath: "/var/lib/mysql"
                       name: mysql-pv
            volumes:
                - name: mysql-pv
                  persistentVolumeClaim:
                    claimName: mysql-pv-claim
```

Apply the updated deployment manifest

```bash
thor@jump_host ~$ kubectl apply -f mysql-deployment.yaml 
deployment.apps/mysql-deployment created
thor@jump_host ~$ 
```

List all objects created, ensure the pod is running

```bash

thor@jump_host ~$ kubectl get all
NAME                                   READY   STATUS    RESTARTS   AGE
pod/mysql-deployment-b4cbbdff5-t8r9d   1/1     Running   0          91s

NAME                 TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)        AGE
service/kubernetes   ClusterIP   10.96.0.1     <none>        443/TCP        70m
service/mysql        NodePort    10.96.11.49   <none>        80:30007/TCP   15s

NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/mysql-deployment   1/1     1            1           91s

NAME                                         DESIRED   CURRENT   READY   AGE
replicaset.apps/mysql-deployment-b4cbbdff5   1         1         1       91s
thor@jump_host ~$ 
```