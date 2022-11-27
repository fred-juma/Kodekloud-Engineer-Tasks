## Instructions

As per new application requirements shared by the Nautilus project development team, serveral new packages need to be installed on all app servers in **Stratos Datacenter**. Most of them are completed except for *net-tools*.



Therefore, install the *net-tools* package on all app-servers.


### My Solution

#### SSH into app server 1
```bash

thor@jump_host ~$ ssh tony@172.16.238.10
The authenticity of host '172.16.238.10 (172.16.238.10)' can't be established.
ECDSA key fingerprint is SHA256:Fg7OM6VWTADCsEpglsHbPTSPI21cQv0Khp0iUaxiAeU.
ECDSA key fingerprint is MD5:0d:3f:c3:20:c8:18:e3:ec:3e:45:9c:2a:6d:f4:fd:1b.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '172.16.238.10' (ECDSA) to the list of known hosts.
tony@172.16.238.10's password: 
```

#### Switch to *root* user
```bash
[tony@stapp01 ~]$ sudo su

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for tony: 
[root@stapp01 tony]# 
```

#### Check if the *net-tools* package is intalled. The command output return nothing meaning that the package is missing
```bash
[root@stapp01 tony]# rpm -qa | grep net-tools
[root@stapp01 tony]#
```

#### Use the *yum* package mananger to install the *net-tools* package. Below is a snippet of the installation progress

```bash
[root@stapp01 tony]# yum install -y net-tools
Loaded plugins: fastestmirror, ovl
Determining fastest mirrors
 * base: mirrors.gigenet.com
 * extras: mirror.grid.uchicago.edu
 * updates: tx-mirror.tier.net
base                                                                                                                                                 | 3.6 kB  00:00:00     
extras           
```

#### Repeat the same process for the remaining 2 app servers.

***The End***