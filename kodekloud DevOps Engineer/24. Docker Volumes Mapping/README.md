#### Task

The Nautilus DevOps team is testing applications containerization, which issupposed to be migrated on docker container-based environments soon. In today's stand-up meeting one of the team members has been assigned a task to create and test a docker container with certain requirements. Below are more details:



a. On App Server 1 in Stratos DC pull nginx image (preferably latest tag but others should work too).

b. Create a new container with name games from the image you just pulled.

c. Map the host volume /opt/sysops with container volume /home. There is an sample.txt file present on same server under /tmp; copy that file to /opt/sysops. Also please keep the container in running state.

#### Solution

SSH to app server 2

```bash
thor@jump_host ~$ ssh steve@stapp02
The authenticity of host 'stapp02 (172.16.238.11)' can't be established.
ECDSA key fingerprint is SHA256:LEPbsifG9XT4JIhPtKDuJlVakwtj2PZDkv1PTH0Zp+A.
ECDSA key fingerprint is MD5:87:e5:65:c4:b7:f3:c5:ae:18:cc:44:a8:a6:2a:c7:9a.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'stapp02,172.16.238.11' (ECDSA) to the list of known hosts.
steve@stapp02's password: 
```

Pull the nginx:latest image

```bash
[steve@stapp02~]$ docker pull nginx:latest
latest: Pulling from library/nginx
8740c948ffd4: Pull complete 
d2c0556a17c5: Pull complete 
c8b9881f2c6a: Pull complete 
693c3ffa8f43: Pull complete 
8316c5e80e6d: Pull complete 
b2fe3577faa4: Pull complete 
Digest: sha256:b8f2383a95879e1ae064940d9a200f67a6c79e710ed82ac42263397367e7cc4e
Status: Downloaded newer image for nginx:latest
docker.io/library/nginx:latest
[steve@stapp02~]$ 
```

Create the games container with the image pulled

```bash
[root@stapp02 steve]# docker run --name games -d -v /opt/sysops:/home nginx:latestUnable to find image 'nginx:latest' locally
latest: Pulling from library/nginx
8740c948ffd4: Pull complete 
d2c0556a17c5: Pull complete 
c8b9881f2c6a: Pull complete 
693c3ffa8f43: Pull complete 
8316c5e80e6d: Pull complete 
b2fe3577faa4: Pull complete 
Digest: sha256:b8f2383a95879e1ae064940d9a200f67a6c79e710ed82ac42263397367e7cc4e
Status: Downloaded newer image for nginx:latest
2b0b65a0c302c88a7570c2499f2bd81e83f41c91db37d54faec197f9ae16246c
[root@stapp02 steve]# 
```

Inspect the docker container for the mapped image

```bash
[root@stapp02 steve]# docker inspect beta
[]
Error: No such object: beta
[root@stapp02 steve]# docker inspect games
[
    {
        "Id": "2b0b65a0c302c88a7570c2499f2bd81e83f41c91db37d54faec197f9ae16246c",
        "Created": "2023-01-28T11:43:53.92610712Z",
        "Path": "/docker-entrypoint.sh",
        "Args": [
            "nginx",
            "-g",
            "daemon off;"
        ],
        "State": {
            "Status": "running",
            "Running": true,
            "Paused": false,
            "Restarting": false,
            "OOMKilled": false,
            "Dead": false,
            "Pid": 1550,
            "ExitCode": 0,
            "Error": "",
            "StartedAt": "2023-01-28T11:43:58.023732448Z",
            "FinishedAt": "0001-01-01T00:00:00Z"
        },
        "Image": "sha256:a99a39d070bfd1cb60fe65c45dea3a33764dc00a9546bf8dc46cb5a11b1b50e9",
        "ResolvConfPath": "/var/lib/docker/containers/2b0b65a0c302c88a7570c2499f2bd81e83f41c91db37d54faec197f9ae16246c/resolv.conf",
        "HostnamePath": "/var/lib/docker/containers/2b0b65a0c302c88a7570c2499f2bd81e83f41c91db37d54faec197f9ae16246c/hostname",
        "HostsPath": "/var/lib/docker/containers/2b0b65a0c302c88a7570c2499f2bd81e83f41c91db37d54faec197f9ae16246c/hosts",
        "LogPath": "/var/lib/docker/containers/2b0b65a0c302c88a7570c2499f2bd81e83f41c91db37d54faec197f9ae16246c/2b0b65a0c302c88a7570c2499f2bd81e83f41c91db37d54faec197f9ae16246c-json.log",
        "Name": "/games",
        "RestartCount": 0,
        "Driver": "vfs",
        "Platform": "linux",
        "MountLabel": "",
        "ProcessLabel": "",
        "AppArmorProfile": "",
        "ExecIDs": null,
        "HostConfig": {
            "Binds": [
                "/opt/sysops:/home"
            ],
            "ContainerIDFile": "",
            "LogConfig": {
                "Type": "json-file",
                "Config": {}
            },
            "NetworkMode": "default",
            "PortBindings": {},
            "RestartPolicy": {
                "Name": "no",
                "MaximumRetryCount": 0
            },
            "AutoRemove": false,
            "VolumeDriver": "",
            "VolumesFrom": null,
            "CapAdd": null,
            "CapDrop": null,
            "CgroupnsMode": "host",
            "Dns": [],
            "DnsOptions": [],
            "DnsSearch": [],
            "ExtraHosts": null,
            "GroupAdd": null,
            "IpcMode": "private",
            "Cgroup": "",
            "Links": null,
            "OomScoreAdj": 0,
            "PidMode": "",
            "Privileged": false,
            "PublishAllPorts": false,
            "ReadonlyRootfs": false,
            "SecurityOpt": null,
            "UTSMode": "",
            "UsernsMode": "",
            "ShmSize": 67108864,
            "Runtime": "runc",
            "ConsoleSize": [
                0,
                0
            ],
            "Isolation": "",
            "CpuShares": 0,
            "Memory": 0,
            "NanoCpus": 0,
            "CgroupParent": "",
            "BlkioWeight": 0,
            "BlkioWeightDevice": [],
            "BlkioDeviceReadBps": null,
            "BlkioDeviceWriteBps": null,
            "BlkioDeviceReadIOps": null,
            "BlkioDeviceWriteIOps": null,
            "CpuPeriod": 0,
            "CpuQuota": 0,
            "CpuRealtimePeriod": 0,
            "CpuRealtimeRuntime": 0,
            "CpusetCpus": "",
            "CpusetMems": "",
            "Devices": [],
            "DeviceCgroupRules": null,
            "DeviceRequests": null,
            "KernelMemory": 0,
            "KernelMemoryTCP": 0,
            "MemoryReservation": 0,
            "MemorySwap": 0,
            "MemorySwappiness": null,
            "OomKillDisable": false,
            "PidsLimit": null,
            "Ulimits": null,
            "CpuCount": 0,
            "CpuPercent": 0,
            "IOMaximumIOps": 0,
            "IOMaximumBandwidth": 0,
            "MaskedPaths": [
                "/proc/asound",
                "/proc/acpi",
                "/proc/kcore",
                "/proc/keys",
                "/proc/latency_stats",
                "/proc/timer_list",
                "/proc/timer_stats",
                "/proc/sched_debug",
                "/proc/scsi",
                "/sys/firmware"
            ],
            "ReadonlyPaths": [
                "/proc/bus",
                "/proc/fs",
                "/proc/irq",
                "/proc/sys",
                "/proc/sysrq-trigger"
            ]
        },
        "GraphDriver": {
            "Data": null,
            "Name": "vfs"
        },
        "Mounts": [
            {
                "Type": "bind",
                "Source": "/opt/sysops",
                "Destination": "/home",
                "Mode": "",
                "RW": true,
                "Propagation": "rprivate"
            }
        ],
        "Config": {
            "Hostname": "2b0b65a0c302",
            "Domainname": "",
            "User": "",
            "AttachStdin": false,
            "AttachStdout": false,
            "AttachStderr": false,
            "ExposedPorts": {
                "80/tcp": {}
            },
            "Tty": false,
            "OpenStdin": false,
            "StdinOnce": false,
            "Env": [
                "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
                "NGINX_VERSION=1.23.3",
                "NJS_VERSION=0.7.9",
                "PKG_RELEASE=1~bullseye"
            ],
            "Cmd": [
                "nginx",
                "-g",
                "daemon off;"
            ],
            "Image": "nginx:latest",
            "Volumes": null,
            "WorkingDir": "",
            "Entrypoint": [
                "/docker-entrypoint.sh"
            ],
            "OnBuild": null,
            "Labels": {
                "maintainer": "NGINX Docker Maintainers <docker-maint@nginx.com>"
            },
            "StopSignal": "SIGQUIT"
        },
        "NetworkSettings": {
            "Bridge": "",
            "SandboxID": "dd03e6ea9103378f601146e1fe92af3ae90cea6e61903b10f6dc0e6e34c850b2",
            "HairpinMode": false,
            "LinkLocalIPv6Address": "",
            "LinkLocalIPv6PrefixLen": 0,
            "Ports": {
                "80/tcp": null
            },
            "SandboxKey": "/var/run/docker/netns/dd03e6ea9103",
            "SecondaryIPAddresses": null,
            "SecondaryIPv6Addresses": null,
            "EndpointID": "a0e7f57cc5a06a3503f4d60c90fa8cec27136a3b0122921ba7e1ac8640c5a386",
            "Gateway": "192.168.3.1",
            "GlobalIPv6Address": "",
            "GlobalIPv6PrefixLen": 0,
            "IPAddress": "192.168.3.2",
            "IPPrefixLen": 24,
            "IPv6Gateway": "",
            "MacAddress": "02:42:c0:a8:03:02",
            "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "NetworkID": "b4c126ca7f2e29f3e9d9f52945e47e9199dcdbcaef7190cebb1079d95044169b",
                    "EndpointID": "a0e7f57cc5a06a3503f4d60c90fa8cec27136a3b0122921ba7e1ac8640c5a386",
                    "Gateway": "192.168.3.1",
                    "IPAddress": "192.168.3.2",
                    "IPPrefixLen": 24,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:c0:a8:03:02",
                    "DriverOpts": null
                }
            }
        }
    }
]
[root@stapp02 steve]# 
```

Check the container status

```bash
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS     NAMES
2b0b65a0c302   nginx:latest   "/docker-entrypoint.…"   59 seconds ago   Up 54 seconds   80/tcp    games
[root@stapp02 steve]# 
```

Copy the file *samples* file from the host server to the container */home/* directory. you could also just copy the file into */opt/sysops/* directory already mapped to the container

```bash
[root@stapp02 steve]# docker cp /tmp/sample.txt games:/home/
```

Log into the container to verify the file is copied

```bash
[root@stapp02 steve]# docker exec -it games /bin/bash
root@2b0b65a0c302:/# ls /home/
sample.txt
root@2b0b65a0c302:/# 
```

***The End***