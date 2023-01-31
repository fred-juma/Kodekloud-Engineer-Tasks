
#### Task
There are some jobs/tasks that need to be run regularly on different schedules. Currently the Nautilus DevOps team is working on developing some scripts that will be executed on different schedules, but for the time being the team is creating some cron jobs in Kubernetes cluster with some dummy commands (which will be replaced by original scripts later). Create a cronjob as per details given below:



Create a cronjob named nautilus.

Set schedule to */6 * * * *

Container name should be cron-nautilus.

Use httpd image with latest tag only and remember to mention the tag i.e httpd:latest.

Run a dummy command echo Welcome to xfusioncorp!.

Ensure restart policy is OnFailure.

Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.

#### Solution

Create the job definition file

```yaml

apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: nautilus
spec:
  schedule: "*/6 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
            - name: cron-nautilus
              image: httpd:latest
              command:
                - /bin/sh
                - -c
                - echo Welcome to xfusioncorp!
          restartPolicy: OnFailure 
```

Apply the manifest definition

```bash
thor@jump_host ~$ kubectl apply -f nautilus.yaml 
cronjob.batch/nautilus created
thor@jump_host ~$ 
```

List created cronjobs

```bash

thor@jump_host ~$ kubectl get cronjob -A
NAMESPACE   NAME       SCHEDULE      SUSPEND   ACTIVE   LAST SCHEDULE   AGE
default     nautilus   */6 * * * *   False     0        <none>          20s
thor@jump_host ~$ 
```

***The End***