#### Task
The Nautilus DevOps team is working on to setup some pre-requisites for an application that will send the greetings to different users. There is a sample deployment, that needs to be tested. Below is a scenario which needs to be configured on Kubernetes cluster. Please find below more details about it.



Create a pod named print-envars-greeting.

Configure spec as, the container name should be print-env-container and use bash image.

Create three environment variables:

a. GREETING and its value should be Welcome to

b. COMPANY and its value should be Stratos

c. GROUP and its value should be Datacenter

Use command to echo ["$(GREETING) $(COMPANY) $(GROUP)"] message.

You can check the output using <kubctl logs -f [ pod-name ]> command.

Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.

#### Solution

Create the pod manifest file

```bash
thor@jump_host ~$ kubectl run print-envars-greeting --image=bash -o yaml --dry-run=client > pod.yaml
thor@jump_host ~$ 
```

Edit pod manifest file with the provided configs

```bash
thor@jump_host ~$ vi pod.yaml 

apiVersion: v1
kind: Pod
metadata:
  name: print-envars-greeting
spec:
  containers:
  - image: bash
    name: print-env-container
    env:
      - name: GREETING
        value: Welcome to
      - name: COMPANY
        value: Stratos
      - name: GROUP
        value: Datacenter
    command: ["/bin/sh"]
    args: ["-c", "echo $(GREETING) $(COMPANY) $(GROUP)"]
```

Apply the pod definition

```bash
thor@jump_host ~$ kubectl apply -f pod.yaml 
pod/print-envars-greeting created
thor@jump_host ~$ 
```

View created resources

```bash
thor@jump_host ~$ kubectl get all
NAME                        READY   STATUS             RESTARTS   AGE
pod/print-envars-greeting   0/1     CrashLoopBackOff   1          15s

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   99m
thor@jump_host ~$ 
```

Print logs to view the greeting

```bash
thor@jump_host ~$ kubectl logs print-envars-greeting
Welcome to DevOps Datacenter
thor@jump_host ~$ 
```


***The End***



