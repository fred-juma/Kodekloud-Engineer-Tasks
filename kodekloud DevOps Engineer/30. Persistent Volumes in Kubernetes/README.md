#### Task

The Nautilus DevOps team is working on a Kubernetes template to deploy a web application on the cluster. There are some requirements to create/use persistent volumes to store the application code, and the template needs to be designed accordingly. Please find more details below:



Create a PersistentVolume named as pv-nautilus. Configure the spec as storage class should be manual, set capacity to 3Gi, set access mode to ReadWriteOnce, volume type should be hostPath and set path to /mnt/security (this directory is already created, you might not be able to access it directly, so you need not to worry about it).

Create a PersistentVolumeClaim named as pvc-nautilus. Configure the spec as storage class should be manual, request 3Gi of the storage, set access mode to ReadWriteOnce.

Create a pod named as pod-nautilus, mount the persistent volume you created with claim name pvc-nautilus at document root of the web server, the container within the pod should be named as container-nautilus using image nginx with latest tag only (remember to mention the tag i.e nginx:latest).

Create a node port type service named web-nautilus using node port 30008 to expose the web server running within the pod.

Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.

#### Solution

Create the pv manifest file

```bash

thor@jump_host ~$ vi pv-nautilus.yaml
```

Populate the manifest with the provided specs

```yaml
apiVersion: v1
kind: PersistentVolume
metadata: 
  name: pv-nautilus
spec: 
  storageClassName: manual
  accessModes: 
    - ReadWriteOnce
  capacity: 
    storage: 3Gi
  hostPath:
    path: /mnt/security
    ```

Apply the pv manifest to create the pv object

```bash
thor@jump_host ~$ kubectl apply -f pv-nautilus.yaml 
persistentvolume/pv-nautilus created
thor@jump_host ~$ 
```

Create the pvc manifest file

```bash
thor@jump_host ~$ vi pvc-nautilus.yaml
```

Populate the manifest with the provided specs

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata: 
  name: pvc-nautilus
spec: 
  storageClassName: manual
  accessModes: 
    - ReadWriteOnce
  resources:
    requests: 
      storage: 3Gi
    ```

Apply the pv manifest to create the pv object

```bash
thor@jump_host ~$ kubectl apply -f pvc-nautilus.yaml 
persistentvolumeclaim/mysql-pv-claim created
thor@jump_host ~$ 
```

View status of pv and pvc

```bash
thor@jump_host ~$ kubectl get persistentvolume
NAME          CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS     CLAIM                    STORAGECLASS   REASON   AGE
pv-nautilus   3Gi        RWO            Retain           Released   default/mysql-pv-claim   manual                  11m
thor@jump_host ~$ kubectl get persistentvolumeclaim
NAME             STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
mysql-pv-claim   Pending                                      manual         73s
thor@jump_host ~$ 
```
Create pod manifest

```bash
thor@jump_host ~$ vi pod-nautilus.yaml
```

Populate the manifest file with the provided specs

```yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: pod-nautilus
  labels:
    name: pod-nautilus
spec:
  containers:
  - name: container-nautilus
    image: nginx:latest
    volumeMounts:
      - name: pvc-nautilus
        mountPath: /var/www/html
  volumes:
    - name: pvc-nautilus
      persistentVolumeClaim:
        claimName: pvc-nautilus
```

Apply the pod manifest to create pod object

```bash
thor@jump_host ~$ kubectl apply -f pod-nautilus.yaml 
pod/pod-nautilus created
thor@jump_host ~$ 
```

View the created pod

```bash
Every 2.0s: kubectl get pod           Sun Feb 12 06:25:56 2023

NAME          READY   STATUS    RESTARTS   AGE
pod-nautilus   1/1     Running   0          30s
```


Expose the service

```bash
thor@jump_host ~$ kubectl expose pod pod-nautilus --type=NodePort --port=80 --name=web-nautilus --dry-run=client -o yaml > web-nautilus.yaml
thor@jump_host ~$ 
```

Populate the service manifest

```yaml

apiVersion: v1
kind: Service
metadata:
  labels:
    name: web-nautilus
  name: web-nautilus
spec:
  ports:
  - port: 80
    nodePort: 30008
    protocol: TCP
    targetPort: 80
  selector:
    name: pod-nautilus
  type: NodePort
```

Apply the service Manifest

```bash

thor@jump_host ~$ kubectl apply -f web-nautilus.yaml 
service/web-nautilus created
thor@jump_host ~$ 
```

If you navigate to the URL you will be greeted by the message *It Works*


***The End***