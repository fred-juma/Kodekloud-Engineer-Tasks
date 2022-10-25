# Instructions

The Nautilus production support team and security team had a meeting last month in which they decided to use local yum repositories for maintaing packages needed for their servers. For now they have decided to configure a local yum repo on **Nautilus Backup Server**. This is one of the pending items from last month, so please configure a local yum repository on **Nautilus Backup Server** as per details given below.



a. We have some packages already present at location */packages/downloaded_rpms/* on **Nautilus Backup Server**.

b. Create a yum repo named *yum_local* and make sure to set Repository ID to *yum_local*. Configure it to use package's location */packages/downloaded_rpms/*.

c. Install package *vim-enhanced* from this newly created repo.

## My Solution

### Log in to the **Nautilus Backup Server**

```bash
thor@jump_host ~$ ssh clint@172.16.238.16
The authenticity of host '172.16.238.16 (172.16.238.16)' can't be established.
ECDSA key fingerprint is SHA256:6r0zS8xOk6vvJ7eipsqHeo2TDLRNbIFUCdd7dANMbW8.
ECDSA key fingerprint is MD5:17:8a:55:83:c3:a0:df:b6:d4:86:7f:71:5f:5a:e9:40.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '172.16.238.16' (ECDSA) to the list of known hosts.
clint@172.16.238.16's password: 
[clint@stbkp01 ~]$
```


### Setup the local repo, first move the default local repo to */tmp/* directory

```bash
[clint@stbkp01 ~]$ cd /etc/yum.repos.d/
[clint@stbkp01 yum.repos.d]$
[clint@stbkp01 yum.repos.d]$ sudo mv local.repo /tmp/
[clint@stbkp01 yum.repos.d]$ 
```
### create the new repo *yum_local.repo* using the *vi* editor and supplying the commands below

```bash
sudo vi yum_local.repo

[yum_local]
name=yum_local
gpgcheck=0
enabled=1
baseurl=file:///packages/downloaded_rpms/
```
### clean all the yum cache of metadata and packages. It will help to reclaim used space

```bash
[clint@stbkp01 yum.repos.d]$ sudo yum clean all
Loaded plugins: fastestmirror, ovl
Cleaning repos: yum_local
Cleaning up list of fastest mirrors
Other repos take up 73 M of disk space (use --verbose for details)
[clint@stbkp01 yum.repos.d]$ 
```

### Confirm new repo is in the repolist

```bash
[clint@stbkp01 yum.repos.d]$ yum repolist all
Loaded plugins: fastestmirror, ovl
ovl: Error while doing RPMdb copy-up:
[Errno 13] Permission denied: '/var/lib/rpm/Sigmd5'
Determining fastest mirrors
yum_local                                          | 2.9 kB     00:00     
yum_local/primary_db                                 |  57 kB   00:00     
repo id                        repo name                       status
yum_local                      yum_local                       enabled: 55
repolist: 55
[clint@stbkp01 yum.repos.d]$ 

```
### And finally test the new local repo by installing the specified package. The installation was successful

```bash
[clint@stbkp01 yum.repos.d]$ sudo yum install vim-enhanced
```


