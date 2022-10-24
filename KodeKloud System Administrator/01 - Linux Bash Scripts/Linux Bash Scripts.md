

# Linux Bash Scripts

## Instructions
The production support team of **xFusionCorp Industries** is working on developing some bash scripts to automate different day to day tasks. One is to create a bash script for taking websites backup. They have a static website running on **App Server 1** in Stratos Datacenter, and they need to create a bash script named *beta_backup.sh* which should accomplish the following tasks. (Also remember to place the script under */scripts* directory on App Server 1)



a. Create a zip archive named **xfusioncorp_beta.zip** of */var/www/html/beta* directory.

b. Save the archive in */backup/* on App Server 1. This is a temporary storage, as backups from this location will be clean on weekly basis. Therefore, we also need to save this backup archive on Nautilus Backup Server.

c. Copy the created archive to **Nautilus Backup Server** in */backup/* location.

d. Please make sure script won't ask for password while copying the archive file. Additionally, the respective server user (for example, *tony* in case of **App Server 1**) must be able to run it.

## Solution steps 

Log into applications server 1 with the provided credentials 
```bash
thor@jump_host ~$ ssh tony@172.16.238.10
The authenticity of host '172.16.238.10 (172.16.238.10)' can't be established.
ECDSA key fingerprint is SHA256:SySamszyWhhLGFiybhGBqfrr8g55wS/3e37ZpBOvICs.
ECDSA key fingerprint is MD5:6d:31:18:2a:f9:07:f3:29:dd:0a:d3:1f:6e:04:0a:db.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '172.16.238.10' (ECDSA) to the list of known hosts.
ton@172.16.238.10's password: 
```
Change to the */scripts/* directory  
```bash
[tony@stapp03 ~]$ cd /scripts/
```
Create the scripts file and modify it's permissions to make it executable
```bash
[tony@stapp03 ~]$ touch beta_backup.sh && chmod + x beta_backup.sh 
```
Generate SSH key pair

```bash
[tony@stapp03 ~]$ ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa): 
Created directory '/root/.ssh'.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /root/.ssh/id_rsa.
Your public key has been saved in /root/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:e88Pmg46DCUx0cSK0jHBtvXYhkV7zfuPDXiWetY26is root@stapp01.stratos.xfusioncorp.com
The key's randomart image is:
+---[RSA 2048]----+
| ....*o          |
|  = + +. o       |
| o * X. . o      |
|. + = =.   .     |
| .   +  S .      |
|    .    . o .   |
|     o  o o B.   |
|      o. oEOo*+  |
|      .. .==B=+. |
+----[SHA256]-----+
```

Copy the public key to the backup server
```bash
[tony@stapp03 ~]$ ssh-copy-id clint@172.16.238.16
/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/root/.ssh/id_rsa.pub"
/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
clint@172.16.238.16's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'clint@172.16.238.16'"
and check to make sure that only the key(s) you wanted were added.
```
Using vi editor, insert the following commands into the bash script file *beta_backup.sh* created earlier. Save the file when done.
```bash
#!/bin/bash
yum install zip -y && \
zip -r /backup/xfusioncorp_beta.zip /var/www/html/beta && \
scp /backup/xfusioncorp_beta.zip clint@172.16.238.16:/backup
```

Run the script
```bash
[tony@stapp03 ~]$ ./beta_backup.sh
Loaded plugins: fastestmirror, ovl
Determining fastest mirrors
epel/x86_64/metalink                                                |  20 kB  00:00:00     
 * base: bay.uchicago.edu
 * epel: mirror.grid.uchicago.edu
 * extras: linux-mirrors.fnal.gov
 * remi-php72: mirror.team-cymru.com
 * remi-safe: mirror.team-cymru.com
 * updates: mirror.us.oneandone.net
base                                                                | 3.6 kB  00:00:00     
epel                                                                | 4.7 kB  00:00:00     
extras                                                              | 2.9 kB  00:00:00     
remi-php72                                                          | 3.0 kB  00:00:00     
remi-safe                                                           | 3.0 kB  00:00:00     
updates                                                             | 2.9 kB  00:00:00     
(1/9): base/7/x86_64/primary_db                                     | 6.1 MB  00:00:00     
(2/9): epel/x86_64/group_gz                                         |  97 kB  00:00:00     
(3/9): epel/x86_64/updateinfo                                       | 1.0 MB  00:00:00     
(4/9): epel/x86_64/primary_db                                       | 7.0 MB  00:00:00     
(5/9): base/7/x86_64/group_gz                                       | 153 kB  00:00:00     
(6/9): extras/7/x86_64/primary_db                                   | 249 kB  00:00:00     
(7/9): remi-php72/primary_db                                        | 263 kB  00:00:00     
(8/9): remi-safe/primary_db                                         | 2.3 MB  00:00:00     
(9/9): updates/7/x86_64/primary_db                                  |  17 MB  00:00:00     
Package zip-3.0-11.el7.x86_64 already installed and latest version
Nothing to do
  adding: var/www/html/beta/ (stored 0%)
  adding: var/www/html/beta/index.html (stored 0%)
  adding: var/www/html/beta/.gitkeep (stored 0%)
xfusioncorp_beta.zip                                     100%  588     1.0MB/s   00:00
```
## Verification:
Verify that the zip archive is created and copied to the backup server */backup/* directory
```bash
[tony@stapp03 ~]$ ssh clint@172.16.238.16 ls /backup/
xfusioncorp_ecommerce.zip
```
Verify that the zip archive is created and copied to the application server */backup/* directory

```bash
[tony@stapp03 ~]$ ls /backup/
xfusioncorp_beta.zip
```


