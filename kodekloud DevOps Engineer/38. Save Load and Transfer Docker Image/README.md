#### Task

One of the DevOps team members was working on to create a new custom docker image on App Server 1 in Stratos DC. He is done with his changes and image is saved on same server with name apps:datacenter. Recently a requirement has been raised by a team to use that image for testing, but the team wants to test the same on App Server 3. So we need to provide them that image on App Server 3 in Stratos DC.



a. On App Server 1 save the image apps:datacenter in an archive.

b. Transfer the image archive to App Server 3.

c. Load that image archive on App Server 3 with same name and tag which was used on App Server 1.

Note: Docker is already installed on both servers; however, if its service is down please make sure to start it.

#### Solution

SSH to app server 01 and switch to root user

```bash
thor@jump_host ~$ ssh tony@stapp01
The authenticity of host 'stapp01 (172.16.238.10)' can't be established.
ECDSA key fingerprint is SHA256:bC2Omw3S16L927jRCmkvnM7lP35wEXLg++3Sp/mjt4w.
ECDSA key fingerprint is MD5:8b:5a:4c:cc:8a:70:10:ce:ad:17:d7:5e:7b:15:d1:14.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'stapp01,172.16.238.10' (ECDSA) to the list of known hosts.
tony@stapp01's password: 
[tony@stapp01 ~]$ sudo su

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for tony: 
[root@stapp01 tony]# 

```


View images

```bash
[root@stapp01 tony]# docker images
REPOSITORY   TAG          IMAGE ID       CREATED          SIZE
apps         datacenter   f1490c3aa697   25 minutes ago   120MB
ubuntu       latest       74f2314a03de   3 days ago       77.8MB
[root@stapp01 tony]# 
```

Create the image archive

```bash
[root@stapp01 tony]# docker save apps:datacenter > apps.tar
[root@stapp01 tony]# 
```

Transfer the image archive to App Server 3.

```bash
steve@stapp03's password: [root@stapp01 tony]# scp apps.tar banner@stapp03:~
banner@stapp03's password: 
apps.tar                                                                                                               100%  117MB  41.7MB/s   00:02    
[root@stapp01 tony]# 
```

SSH to app server 3 and switch to root user

```bash
[root@stapp01 tony]# ssh banner@stapp03
banner@stapp03's password: 

Permission denied, please try again.
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

Ensure docker daemon is up and running


```bash
[root@stapp03 banner]# sudo systemctl status docker
● docker.service - Docker Application Container Engine
   Loaded: loaded (/usr/lib/systemd/system/docker.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
     Docs: https://docs.docker.com
[root@stapp03 banner]# sudo systemctl start docker
[root@stapp03 banner]# sudo systemctl status docker
● docker.service - Docker Application Container Engine
   Loaded: loaded (/usr/lib/systemd/system/docker.service; disabled; vendor preset: disabled)
   Active: active (running) since Sat 2023-03-04 13:03:35 UTC; 2s ago
     Docs: https://docs.docker.com
 Main PID: 570 (dockerd)
    Tasks: 17
   Memory: 140.4M
   CGroup: /docker/7392b74ed4b4b686b2bed5e1bf79979cb634a6d9785131da0b6e50ff96270bc1/system.slice/docker.service
           └─570 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock

Mar 04 13:03:34 stapp03.stratos.xfusioncorp.com dockerd[570]: time="2023-03-04T13:03:34.408605802Z" level=info msg="ClientConn switching balanc...le=grpc
Mar 04 13:03:34 stapp03.stratos.xfusioncorp.com dockerd[570]: time="2023-03-04T13:03:34.542112757Z" level=warning msg="Your kernel does not sup...eduler"
Mar 04 13:03:34 stapp03.stratos.xfusioncorp.com dockerd[570]: time="2023-03-04T13:03:34.542206622Z" level=warning msg="Your kernel does not sup...weight"
Mar 04 13:03:34 stapp03.stratos.xfusioncorp.com dockerd[570]: time="2023-03-04T13:03:34.542217799Z" level=warning msg="Your kernel does not sup...device"
Mar 04 13:03:34 stapp03.stratos.xfusioncorp.com dockerd[570]: time="2023-03-04T13:03:34.543614819Z" level=info msg="Loading containers: start."
Mar 04 13:03:34 stapp03.stratos.xfusioncorp.com dockerd[570]: time="2023-03-04T13:03:34.937080373Z" level=info msg="Loading containers: done."
Mar 04 13:03:35 stapp03.stratos.xfusioncorp.com dockerd[570]: time="2023-03-04T13:03:35.337399925Z" level=info msg="Docker daemon" commit=b0f5b...20.10.7
Mar 04 13:03:35 stapp03.stratos.xfusioncorp.com dockerd[570]: time="2023-03-04T13:03:35.338590215Z" level=info msg="Daemon has completed initialization"
Mar 04 13:03:35 stapp03.stratos.xfusioncorp.com systemd[1]: Started Docker Application Container Engine.
Mar 04 13:03:35 stapp03.stratos.xfusioncorp.com dockerd[570]: time="2023-03-04T13:03:35.617641430Z" level=info msg="API listen on /var/run/docker.sock"
Hint: Some lines were ellipsized, use -l to show in full.
[root@stapp03 banner]# 
```

Load the image

```bash
[root@stapp03 banner]# docker load -i apps.tar 
202fe64c3ce3: Loading layer [==================================================>]  80.33MB/80.33MB
a41463efa739: Loading layer [==================================================>]  42.17MB/42.17MB
Loaded image: apps:datacenter
[root@stapp03 banner]# 
```
Confirm the image is loaded

```bash

[root@stapp03 banner]# docker images
REPOSITORY   TAG          IMAGE ID       CREATED          SIZE
apps         datacenter   f1490c3aa697   34 minutes ago   120MB
[root@stapp03 banner]# 
```


***The End***




