#### Task

One of the Nautilus developer was working to test new changes on a container. He wants to keep a backup of his changes to the container. A new request has been raised for the DevOps team to create a new image from this container. Below are more details about it:



a. Create an image media:devops on Application Server 3 from a container ubuntu_latest that is running on same server.


#### Solution

SSH to app server 3 

```bash
thor@jump_host ~$ ssh banner@stapp03
The authenticity of host 'stapp03 (172.16.238.12)' can't be established.
ECDSA key fingerprint is SHA256:z4qEljiblU5OyZN6t+zKuNi2yPhu+qEfOx1LxaoHTNc.
ECDSA key fingerprint is MD5:1c:f5:4c:ff:7f:e0:6c:e9:55:31:f5:74:11:19:7d:32.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'stapp03,172.16.238.12' (ECDSA) to the list of known hosts.
banner@stapp03's password: 
[banner@stapp03 ~]$ sudo su

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for banner: 
[root@stapp03 banner]# 
```

List runnning docker containers

```bash
CONTAINER ID   IMAGE     COMMAND       CREATED         STATUS         PORTS     NAMES
bf6d25f3edad   ubuntu    "/bin/bash"   7 minutes ago   Up 7 minutes             ubuntu_latest
[root@stapp03 banner]# 
```

Use docker commit to create a docker image of the running docker container

```bash
[root@stapp03 banner]# docker commit ubuntu_latest media:devops
```


View created image

```bash
[root@stapp03 banner]# docker images
REPOSITORY   TAG       IMAGE ID       CREATED          SIZE
media        devops    60bddef5354a   19 seconds ago   118MB
ubuntu       latest    1f6ddc1b2547   11 days ago      77.8MB
[root@stapp03 banner]# 
```

***The End***