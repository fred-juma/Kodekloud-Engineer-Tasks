#### Task
The Nautilus DevOps team needs to set up several docker environments for different applications. One of the team members has been assigned a ticket where he has been asked to create some docker networks to be used later. Complete the task based on the following ticket description:



a. Create a docker network named as ecommerce on App Server 1 in Stratos DC.

b. Configure it to use macvlan drivers.

c. Set it to use subnet 172.28.0.0/24 and iprange 172.28.0.1/24.

#### Solution

SSH into app server 1

```bash
thor@jump_host ~$ ssh tony@stapp01
The authenticity of host 'stapp01 (172.16.238.10)' can't be established.
ECDSA key fingerprint is SHA256:8C36kTZvPK9K8CnD3UCQ0HI63MaqpAKWx/0S+3at2QE.
ECDSA key fingerprint is MD5:28:73:0a:42:3b:c1:aa:38:06:e7:6d:76:37:58:1a:b2.
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

List the available docker networks

```bash

[root@stapp01 tony]# docker network ls
NETWORK ID     NAME      DRIVER    SCOPE
324ad64ee20e   bridge    bridge    local
b88f6cfddfe5   host      host      local
b2c504a4ba6c   none      null      local
[root@stapp01 tony]# 
```

Create the *ecommerce* docker network with the specified parameters

```bash

[root@stapp01 tony]# docker network create ecommerce --driver macvlan --subnet 172.28.0.0/24 --ip-range 172.28.0.1/24
10bc70c726ca4ed0204e03fcfed80f4a0b740f9b2cbf9338da11c4fec5a08c17
[root@stapp01 tony]# 
```

List the networks to see the created network

```bash

[root@stapp01 tony]# docker network ls

NETWORK ID     NAME        DRIVER    SCOPE
324ad64ee20e   bridge      bridge    local
10bc70c726ca   ecommerce   macvlan   local
b88f6cfddfe5   host        host      local
b2c504a4ba6c   none        null      local
[root@stapp01 tony]# 
```

Inspect the ecommerce network

```bash
[root@stapp01 tony]#  docker network inspect ecommerce
[
    {
        "Name": "ecommerce",
        "Id": "10bc70c726ca4ed0204e03fcfed80f4a0b740f9b2cbf9338da11c4fec5a08c17",
        "Created": "2023-02-01T13:57:32.676655547Z",
        "Scope": "local",
        "Driver": "macvlan",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "172.28.0.0/24",
                    "IPRange": "172.28.0.1/24"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {},
        "Options": {},
        "Labels": {}
    }
]
[root@stapp01 tony]# 
```

***The End***
