#### Task

There are a number of parameters that are used by the applications. We need to define these as environment variables, so that we can use them as needed within different configs. Below is a scenario which needs to be configured on Kubernetes cluster. Please find below more details about the same.



Create a pod named envars.

Container name should be fieldref-container, use image httpd preferable latest tag, use command 'sh', '-c' and args should be 'while true; do echo -en '/n'; printenv NODE_NAME POD_NAME; printenv POD_IP POD_SERVICE_ACCOUNT; sleep 10; done;'

(Note: please take care of indentations)

Define Four environment variables as mentioned below:
a.) The first env should be named as NODE_NAME, set valueFrom fieldref and fieldPath should be spec.nodeName.

b.) The second env should be named as POD_NAME, set valueFrom fieldref and fieldPath should be metadata.name.

c.) The third env should be named as POD_IP, set valueFrom fieldref and fieldPath should be status.podIP.

d.) The fourth env should be named as POD_SERVICE_ACCOUNT, set valueFrom fieldref and fieldPath shoulbe be spec.serviceAccountName.

Set restart policy to Never.

To check the output, exec into the pod and use printenv command.

Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.

#### Solution

Create the pod manifest *envars* and populate it with the pod [definition](envars.yaml)

```bash

thor@jump_host ~$ sudo vi envars.yaml

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for thor: 
thor@jump_host ~$ 
```

Apply the pod definition to create the pods

```bash
thor@jump_host ~$ kubectl apply -f envars.yaml 
pod/envars created
thor@jump_host ~$ 
```

List pods

```bash
thor@jump_host ~$ kubectl get pods
NAME     READY   STATUS    RESTARTS   AGE
envars   1/1     Running   0          3m9s
thor@jump_host ~$ 
```

 exec into the pod and use printenv command to check the output. All the envronment variables are created and respective values populated.


```bash
thor@jump_host ~$ kubectl exec -it envars -- printenv
PATH=/usr/local/apache2/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=envars
HTTPD_PREFIX=/usr/local/apache2
HTTPD_VERSION=2.4.54
HTTPD_SHA256=eb397feeefccaf254f8d45de3768d9d68e8e73851c49afd5b7176d1ecf80c340
HTTPD_PATCHES=
POD_SERVICE_ACCOUNT=default
NODE_NAME=kodekloud-control-plane
POD_NAME=envars
POD_IP=10.244.0.5
KUBERNETES_SERVICE_HOST=10.96.0.1
KUBERNETES_SERVICE_PORT=443
KUBERNETES_SERVICE_PORT_HTTPS=443
KUBERNETES_PORT=tcp://10.96.0.1:443
KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443
KUBERNETES_PORT_443_TCP_PROTO=tcp
KUBERNETES_PORT_443_TCP_PORT=443
KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1
TERM=xterm
HOME=/root
thor@jump_host ~$ 
```