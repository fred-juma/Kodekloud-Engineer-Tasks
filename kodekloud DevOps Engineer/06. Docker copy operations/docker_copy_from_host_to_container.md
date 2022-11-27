#### Instructions

The Nautilus DevOps team has some conditional data present on **App Server 2** in Stratos Datacenter. There is a container ubuntu_latest running on the same server. We received a request to copy some of the data from the docker host to the container. Below are more details about the task:



On App Server 2 in Stratos Datacenter copy an encrypted file */tmp/nautilus.txt.gpg* from docker host to ubuntu_latest container (running on same server) in */opt/* location. Please do not try to modify this file in any way.

#### Solution

SSH into app server 2

```bash
thor@jump_host ~$ ssh steve@172.16.238.11
The authenticity of host '172.16.238.11 (172.16.238.11)' can't be established.
ECDSA key fingerprint is SHA256:sZ4wYaVKtByyu6bVFFb70M0p4FCUM7nVhO1PUH5AA64.
ECDSA key fingerprint is MD5:51:a1:3d:d8:35:60:16:c1:aa:b9:c3:09:d5:63:8f:51.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '172.16.238.11' (ECDSA) to the list of known hosts.
steve@172.16.238.11's password: 
```

Switch to root user
```bash
[steve@stapp02 ~]$ sudo su

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for steve: 
[root@stapp02 steve]# 
```

List running containers in the server. We can see the running conatiner id, status and image among other details

```bash
[root@stapp02 steve]# docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED         STATUS         PORTS     NAMES
f959361deb09   ubuntu    "bash"    2 minutes ago   Up 2 minutes             ubuntu_latest
[root@stapp02 steve]# 
```

Copy the specified file from the docker host to the docker container using the *docker cp* command

```bash
[root@stapp02 steve]# docker cp /tmp/nautilus.txt.gpg f959361deb09:/opt/
[root@stapp02 steve]# 
```

To verify if copy was successful, gain interractive shell of the container

```bash
[root@stapp02 steve]# docker exec -it f959361deb09 /bin/bash
root@f959361deb09:/# 
```

Then list content of */opt/* directory. We can see the file that was copied is present

```bash
root@f959361deb09:/# ls /opt/
nautilus.txt.gpg
root@f959361deb09:/# 
````

***The End***