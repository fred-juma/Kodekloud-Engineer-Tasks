#### Task

The Nautilus DevOps team is working on to create few jobs in Kubernetes cluster. They might come up with some real scripts/commands to use, but for now they are preparing the templates and testing the jobs with dummy commands. Please create a job template as per details given below:



Create a job countdown-nautilus.

The spec template should be named as countdown-nautilus (under metadata), and the container should be named as container-countdown-nautilus

Use image debian with latest tag only and remember to mention tag i.e debian:latest, and restart policy should be Never.

Use command for i in ten nine eight seven six five four three two one ; do echo $i ; done

Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.


#### Solution

Create the job manifest definition

```bash

thor@jump_host ~$ sudo vi countdown-datacenter.yaml

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for thor: 
```

Populate it with the yaml commands for the job creation

```bash
apiVersion: batch/v1
kind: Job
metadata:
  name: countdown-datacenter
spec:
  template:
    metadata:
      name: countdown-datacenter
    spec:
      containers:
      - name: container-countdown-datacenter
        image: debian:latest
        command: ["/bin/sh", "-c", "for i in ten nine eight seven six five four three two one ; do echo $i ; done"]
      restartPolicy: Never
```

apply the job definition

```bash
thor@jump_host ~$ kubectl apply -f countdown-datacenter.yaml 
job.batch/countdown-datacenter created
```


Confirm the job is created

```bash

thor@jump_host ~$ kubectl get all
NAME                           READY   STATUS      RESTARTS   AGE
pod/countdown-nautilus         0/1     Error       0          4m16s
pod/countdown-nautilus-tt6k5   0/1     Completed   0          5s

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   98m

NAME                           COMPLETIONS   DURATION   AGE
job.batch/countdown-nautilus   1/1           2s         5s
thor@jump_host ~$ 
```


***The end***