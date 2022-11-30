#### Scenario

The Nautilus DevOps team is planning to host an application on a nginx-based container. There are number of tickets already been created for similar tasks. One of the tickets has been assigned to set up a nginx container on Application Server 1 in Stratos Datacenter. Please perform the task as per details mentioned below:



a. Pull *nginx:stable* docker image on Application Server 1.

b. Create a container named *cluster* using the image you pulled.

c. Map host port *8089* to container port *80*. Please keep the container in running state.



#### Solution

SSH into application server 1

```bash
thor@jump_host ~$ ssh tony@172.16.238.10
The authenticity of host '172.16.238.10 (172.16.238.10)' can't be established.
ECDSA key fingerprint is SHA256:HrXR6L7XhR2r75caDbLNzWR6rqcs1vHkpIpJMmYjnJ0.
ECDSA key fingerprint is MD5:d3:d2:a7:4b:63:ad:fe:19:f6:7f:aa:eb:a6:3c:6e:ad.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '172.16.238.10' (ECDSA) to the list of known hosts.
tony@172.16.238.10's password: 
[tony@stapp01 ~]$ 
[tony@stapp01 ~]$ 
```

Switch to root user

```bash
[tony@stapp01 ~]$ sudo su 

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for tony: 
```

Use docker run command to pull and deploy the container. the options used are:

+ --name: container name
+ -d: run container in detached mode
+ - p: specify ports. 8089 for host port and 80 for container port
+ nginx:stable: image name

```bash
[root@stapp01 tony]# docker run --name cluster -d -p 8089:80 nginx:stable
Unable to find image 'nginx:stable' locally
stable: Pulling from library/nginx
a603fa5e3b41: Pull complete 
50b97857b95c: Pull complete 
0edfe97a837a: Pull complete 
f95a257c65b6: Pull complete 
0bf5e07cb0af: Pull complete 
f3c8f37c59f0: Pull complete 
Digest: sha256:809f0924101d9c07322d69ab0705e1a0d85b1d0f287e320ae19b0826979c56e9
Status: Downloaded newer image for nginx:stable
ea364c2f3251c8ebb0f942e41aefebc6fcae25c013ec771fb6dd98212180f9a9
```

Verify that the image is pulled, and container is created and running

```bash
[root@stapp01 tony]# docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS         PORTS                  NAMES
ea364c2f3251   nginx:stable   "/docker-entrypoint.…"   12 seconds ago   Up 5 seconds   0.0.0.0:8089->80/tcp   cluster
[root@stapp01 tony]# 
```

***The End***