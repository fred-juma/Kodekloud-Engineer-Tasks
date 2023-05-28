#### Task

Nautilus DevOps team is testing some applications deployment on some of the application servers. They need to deploy a nginx container on Application Server 2. Please complete the task as per details given below:



On Application Server 2 create a container named nginx_2 using image nginx with alpine tag and make sure container is in running state.

#### Solution

SSH to app server 02

```bash
thor@jump_host ~$ ssh steve@stapp02
The authenticity of host 'stapp02 (172.16.238.11)' can't be established.
ECDSA key fingerprint is SHA256:MU50nds2FLmB+WDkYb4ydm4UWqFaMq16jC3pRiHMjvQ.
ECDSA key fingerprint is MD5:35:2b:01:a1:f9:b9:5d:52:39:66:c3:6f:94:ca:c7:32.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'stapp02,172.16.238.11' (ECDSA) to the list of known hosts.
steve@stapp02's password: 


[steve@stapp02 ~]$ sudo su

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for steve: 
Sorry, try again.
[sudo] password for steve: 
[root@stapp02 steve]# 
```

Pull docker image

```bash
[root@stapp02 steve]# docker pull nginx:alpine
alpine: Pulling from library/nginx
f56be85fc22e: Pull complete 
97c80f11709c: Pull complete 
afb503c1f124: Pull complete 
f8c948b732dd: Pull complete 
d021bba29710: Pull complete 
cadcca1af197: Pull complete 
4aacde79cec4: Pull complete 
Digest: sha256:2e776a66a3556f001aba13431b26e448fe8acba277bf93d2ab1a785571a46d90
Status: Downloaded newer image for nginx:alpine
docker.io/library/nginx:alpine
[root@stapp02 steve]# 
```

Run the docker image to create container

```bash
[root@stapp02 steve]# docker run -d --name nginx_2 nginx:alpine
efd3bc9a803341ff8adb82a5ccdfad35ad6f90c4a67d8291ce8a7984bbc9cd67
[root@stapp02 steve]# 
```

Check running container

```bash

CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS     NAMES
efd3bc9a8033   nginx:alpine   "/docker-entrypoint.…"   13 seconds ago   Up 10 seconds   80/tcp    nginx_2
[root@stapp02 steve]# 
```




