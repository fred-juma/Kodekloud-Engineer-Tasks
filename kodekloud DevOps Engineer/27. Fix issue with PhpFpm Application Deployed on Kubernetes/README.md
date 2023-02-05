#### Task

We deployed a Nginx and PHPFPM based application on Kubernetes cluster last week and it had been working fine. This morning one of the team members was troubleshooting an issue with this stack and he was supposed to run Nginx welcome page for now on this stack till issue with phpfpm is fixed but he made a change somewhere which caused some issue and the application stopped working. Please look into the issue and fix the same:



The deployment name is nginx-phpfpm-dp and service name is nginx-service. Figure out the issues and fix them. FYI Nginx is configured to use default http port, node port is 30008 and copy index.php under /tmp/index.php to deployment under /var/www/html. Please do not try to delete/modify any other existing components like deployment name, service name etc.

Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.

#### Solution

Inspect the resources in the default namespace

```bash
thor@jump_host ~$ kubectl get all
NAME                                   READY   STATUS    RESTARTS   AGE
pod/nginx-phpfpm-dp-5cccd45499-2l78l   2/2     Running   0          33m

NAME                    TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
service/kubernetes      ClusterIP      10.96.0.1       <none>        443/TCP          66m
service/nginx-service   LoadBalancer   10.96.159.127   <pending>     8097:30008/TCP   33m

NAME                              READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx-phpfpm-dp   1/1     1            1           33m

NAME                                         DESIRED   CURRENT   READY   AGE
replicaset.apps/nginx-phpfpm-dp-5cccd45499   1         1         1       33m
thor@jump_host ~$ 
```

Inpsect the deployment 

```bash
thor@jump_host ~$ kubectl edit deployment nginx-phpfpm-dp 


# and an empty file will abort the edit. If an error occurs while saving this file will be
# reopened with the relevant failures.
#
apiVersion: apps/v1
kind: Deployment
metadata:
  annotations:
    deployment.kubernetes.io/revision: "1"
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"apps/v1","kind":"Deployment","metadata":{"annotations":{},"labels":{"app":"nginx-fpm"},"name":"nginx-phpfpm-dp","namespace":"default"},"spec":{"selector":{"matchLabels":{"app":"nginx-fpm","tier":"frontend"}},"strategy":{"type":"Recreate"},"template":{"metadata":{"labels":{"app":"nginx-fpm","tier":"frontend"}},"spec":{"containers":[{"image":"nginx:latest","name":"nginx-container","volumeMounts":[{"mountPath":"/var/www/html","name":"shared-files"},{"mountPath":"/etc/nginx/nginx.conf","name":"nginx-config-volume","subPath":"nginx.conf"}]},{"image":"php:7.3-fpm","name":"php-fpm-container","volumeMounts":[{"mountPath":"/var/www/html","name":"shared-files"}]}],"volumes":[{"name":"nginx-persistent-storage","persistentVolumeClaim":{"claimName":"nginx-pv-claim"}},{"emptyDir":{},"name":"shared-files"},{"configMap":{"name":"nginx-config"},"name":"nginx-config-volume"}]}}}}
  creationTimestamp: "2023-02-05T05:57:57Z"
  generation: 1
  labels:
    app: nginx-fpm
  name: nginx-phpfpm-dp
  namespace: default
  resourceVersion: "28133"
  uid: d5c8067c-4e14-48fc-861d-8e289ef7c24d
spec:
  progressDeadlineSeconds: 600
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app: nginx-fpm
      tier: frontend
  strategy:
    type: Recreate
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: nginx-fpm
        tier: frontend
    spec:
      containers:
      - image: nginx:latest
        imagePullPolicy: Always
        name: nginx-container
        resources: {}
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
        volumeMounts:
        - mountPath: /var/www/html
        name: shared-files
        - mountPath: /etc/nginx/nginx.conf
          name: nginx-config-volume
          subPath: nginx.conf
      - image: php:7.3-fpm
        imagePullPolicy: IfNotPresent
        name: php-fpm-container
        resources: {}
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
        volumeMounts:
        - mountPath: /var/www/html
          name: shared-files
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      terminationGracePeriodSeconds: 30
      volumes:
      - name: nginx-persistent-storage
        persistentVolumeClaim:
          claimName: nginx-pv-claim
      - emptyDir: {}
        name: shared-files
      - configMap:
          defaultMode: 420
          name: nginx-config
        name: nginx-config-volume
status:
  availableReplicas: 1
  conditions:
  - lastTransitionTime: "2023-02-05T05:58:55Z"
    lastUpdateTime: "2023-02-05T05:58:55Z"
    message: Deployment has minimum availability.
    reason: MinimumReplicasAvailable
    status: "True"
    type: Available
  - lastTransitionTime: "2023-02-05T05:57:58Z"
    lastUpdateTime: "2023-02-05T05:58:55Z"
    message: ReplicaSet "nginx-phpfpm-dp-5cccd45499" has successfully progressed.
    reason: NewReplicaSetAvailable
    status: "True"
    type: Progressing
  observedGeneration: 1
  readyReplicas: 1
  replicas: 1
```

Inspect the nginx service

```bash

# Please edit the object below. Lines beginning with a '#' will be ignored,
# and an empty file will abort the edit. If an error occurs while saving this file will be
# reopened with the relevant failures.
#
apiVersion: v1
kind: Service
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","kind":"Service","metadata":{"annotations":{},"labels":{"app":"nginx-fpm"},"name":"nginx-service","namespace":"default"},"spec":{"ports":[{"nodePort":30008,"port":8097}],"selector":{"app":"nginx-fpm","tier":"frontend"},"type":"LoadBalancer"}}
  creationTimestamp: "2023-02-02T15:15:42Z"
  labels:
    app: nginx-fpm
  name: nginx-service
  namespace: default
  resourceVersion: "3817"
  uid: 5ecb780c-df7b-4df3-94d4-b8fe69d08d0e
spec:
  clusterIP: 10.96.159.127
  clusterIPs:
  - 10.96.159.127
  externalTrafficPolicy: Cluster
  ipFamilies:
  - IPv4
  ipFamilyPolicy: SingleStack
  ports:
  - nodePort: 30008
    port: 8097
    protocol: TCP
    targetPort: 8097
  selector:
    app: nginx-fpm
    tier: frontend
  sessionAffinity: None
  type: LoadBalancer
status:
  loadBalancer: {}
```

Inspect the configmap

```bash
# Please edit the object below. Lines beginning with a '#' will be ignored,
# and an empty file will abort the edit. If an error occurs while saving this file will be
# reopened with the relevant failures.
#
apiVersion: v1
data:
  nginx.conf: |
    events {
    }
    http {
      server {
        listen 80 default_server;
        listen [::]:80 default_server;

        # Set nginx to serve files from the shared volume!
        root /var/www/html;
        index  index.html index.ph p index.htm;
        server_name _;
        location / {
          try_files $uri $uri/ =404;
        }
        location ~ \.php$ {
          include fastcgi_params;
          fastcgi_param REQUEST_METHOD $request_method;
          fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
          fastcgi_pass 127.0.0.1:9000;
        }
      }
    }
kind: ConfigMap
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","data":{"nginx.conf":"events {\n}\nhttp {\n  server {\n    listen 80 default_server;\n    listen [::]:80 default_server;\n\n    # Set nginx to serve files from the shared volume!\n    root /var/www/html;\n    index  index.html index.ph p index.htm;\n    server_name _;\n    location / {\n      try_files $uri $uri/ =404;\n    }\n    location ~ \\.php$ {\n      include fastcgi_params;\n      fastcgi_param REQUEST_METHOD $request_method;\n      fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;\n      fastcgi_pass 127.0.0.1:9000;\n    }\n  }\n}\n"},"kind":"ConfigMap","metadata":{"annotations":{},"name":"nginx-config","namespace":"default"}}
  creationTimestamp: "2023-02-05T06:44:35Z"
  name: nginx-config
  namespace: default
  resourceVersion: "10171"
  uid: aec8152e-b24a-4f41-ae62-09b03f2b82ca
~                                           
```

The config map is configured listen to the appp on port 80, while the service on port 8097. Edit the service to use port 80 instead of port 8097
Also note that there is a type on the index.php



New (edited) service config

```bash
# Please edit the object below. Lines beginning with a '#' will be ignored,
# and an empty file will abort the edit. If an error occurs while saving this file will be
# reopened with the relevant failures.
#
apiVersion: v1
kind: Service
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","kind":"Service","metadata":{"annotations":{},"labels":{"app":"nginx-fpm"},"name":"nginx-service","namespace":"default"},"spec":{"ports":[{"nodePort":30008,"port":80}],"selector":{"app":"nginx-fpm","tier":"frontend"},"type":"LoadBalancer"}}
  creationTimestamp: "2023-02-05T06:44:36Z"
  labels:
    app: nginx-fpm
  name: nginx-service
  namespace: default
  resourceVersion: "10180"
  uid: f26ac5e5-2ed3-466c-933e-8c8aea5ea0c9
spec:
  clusterIP: 10.96.186.17
  clusterIPs:
  - 10.96.186.17
  externalTrafficPolicy: Cluster
  ipFamilies:
  - IPv4
  ipFamilyPolicy: SingleStack
  ports:
  - nodePort: 30008
    port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: nginx-fpm
    tier: frontend
  sessionAffinity: None
  type: LoadBalancer
status:
  loadBalancer: {} 
```

Confirm that the service port forward is 80:30008
```bash
thor@jump_host ~$ kubectl get svc
NAME            TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
kubernetes      ClusterIP      10.96.0.1      <none>        443/TCP        98m
nginx-service   LoadBalancer   10.96.186.17   <pending>     80:30008/TCP   2m47s
thor@jump_host ~$ 
```

REctify the configmap *index.ph p* to *index.php*


```bash 

thor@jump_host ~$ kubectl get configmap
NAME               DATA   AGE
kube-root-ca.crt   1      98m
nginx-config       1      3m35s
thor@jump_host ~$
```

Now we need to delete the pods and create news, for that, perform a rolling update of the deployment

```bash
thor@jump_host ~$ kubectl rollout restart deployment nginx-phpfpm-dp
deployment.apps/nginx-phpfpm-dp restarted
thor@jump_host ~$ 
```

Check the identity of the new pod created after the rolling update

```bash
thor@jump_host ~$ kubectl get pod
NAME                               READY   STATUS    RESTARTS   AGE
nginx-phpfpm-dp-67849f7c8d-k4pfq   2/2     Running   0          60s
thor@jump_host ~$ 
```

Finally copy the *index.php* file from the host to the pod

```bash
thor@jump_host ~$ kubectl cp /tmp/index.php nginx-phpfpm-dp-67849f7c8d-k4pfq:/var/www/html -c nginx-container
thor@jump_host ~$ 
```

Confirm the file is successfully copied into the container

```bash
thor@jump_host ~$ kubectl exec -it nginx-phpfpm-dp-67849f7c8d-k4pfq -- ls -l /var/www/html
Defaulting container name to nginx-container.
Use 'kubectl describe pod/nginx-phpfpm-dp-67849f7c8d-k4pfq -n default' to see all of the containers in this pod.
total 4
-rw-r--r-- 1 root root 168 Feb  5 07:01 index.php
thor@jump_host ~$ 
```

***The End***