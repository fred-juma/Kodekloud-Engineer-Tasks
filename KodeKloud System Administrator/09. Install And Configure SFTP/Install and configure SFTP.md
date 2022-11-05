## Instructions

Some of the developers from Nautilus project team have asked for *SFTP* access to at least one of the app server in **Stratos DC**. After going through the requirements, the system admins team has decided to configure the *SFTP* server on App Server 3 server in Stratos Datacenter. Please configure it as per the following instructions:



a. Create an SFTP user rose and set its password to LQfKeWWxWD.

b. Password authentication should be enabled for this user.

c. Set its ChrootDirectory to /var/www/appdata.

d. SFTP user should only be allowed to make SFTP connections.


### My Solution

#### *SSH* into the application server

```bash
thor@jump_host ~$ ssh banner@172.16.238.12
The authenticity of host '172.16.238.12 (172.16.238.12)' can't be established.
ECDSA key fingerprint is SHA256:foVdrU6CxuxlRU5CTabcSAM4AG+3LsFFCqsYqltx8Xw.
ECDSA key fingerprint is MD5:d6:0d:1c:74:80:41:06:15:d9:e7:98:29:7e:33:eb:2d.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '172.16.238.12' (ECDSA) to the list of known hosts.
banner@172.16.238.12's password: 
Permission denied, please try again.
banner@172.16.238.12's password: 
Permission denied, please try again.
banner@172.16.238.12's password: 
Permission denied (publickey,gssapi-keyex,gssapi-with-mic,password).
thor@jump_host ~$ ssh banner@172.16.238.12
banner@172.16.238.12's password: 
Permission denied, please try again.
banner@172.16.238.12's password: 
````
#### Switch to *root* user

```bash
[banner@stapp03 ~]$ sudo su

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for banner: 
```

#### Verify whether *openssh-server* is installed or not. In our case the package is already installed.

```bash
[root@stapp03 banner]# rpm -qa | grep ssh
libssh2-1.4.3-12.el7_6.3.x86_64
openssh-7.4p1-22.el7_9.x86_64
openssh-clients-7.4p1-22.el7_9.x86_64
openssh-server-7.4p1-22.el7_9.x86_64
sshpass-1.06-2.el7.x86_64
[root@stapp03 banner]# 
```

#### Create a Linux group named: *sftpusers*

```bash
[root@stapp03 banner]# groupadd sftpusers
[root@stapp03 banner]# 
```

#### Create ChrootDirectory */var/www/appdata*
```bash
[root@stapp03 banner]# mkdir -p /var/www/appdata
```

#### Create a Linux user *rose* with home directory */var/www/appdata/*, disable the user login by the option /sbin/nologin and add the user to the group *sftpusers* created earlier.

```bash
[root@stapp03 banner]# useradd -d /var/www/appdata/ -s /sbin/nologin -g sftpusers rose 
useradd: warning: the home directory already exists.
Not copying any file from skel directory into it.
```

#### Create password to the newly created user *rose*

```bash
[root@stapp03 banner]# passwd rose
Changing password for user rose.
New password: 
Retype new password: 
passwd: all authentication tokens updated successfully.
[root@stapp03 banner]# 
```

#### Change user and group ownership for the ChrootDirectory to *root*

```bash
[root@stapp03 banner]# chown -R root:root /var/www/
```


#### Assign *rwx* permissions to user only for the ChrootDirectory
```bash
[root@stapp03 banner]# sudo chmod 700 /var/www/
[root@stapp03 banner]# 
```

#### Change user ownership of the */var/www/appdata/* directory *rose* and the group to *stfpusers*
```bash
[root@stapp03 banner]# 
[root@stapp03 banner]# chown -R rose:sftpusers /var/www/appdata/
[root@stapp03 banner]# 
```

#### Using *vi* text editor, make the necessary adjustments in the configuration file. The final configurations file is [here]().

```bash
[root@stapp03 banner]# vi /etc/ssh/sshd_config 
[root@stapp03 banner]# 
```

#### With the configuration done, restart the *sshd* service
```bash
[root@stapp03 banner]# sudo systemctl restart sshd
[root@stapp03 banner]#
```

#### Confirm that the service is started, and is running.
```bash
[root@stapp03 banner]# sudo systemctl status sshd
● sshd.service - OpenSSH server daemon
   Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
   Active: active (running) since Wed 2022-11-02 18:56:50 UTC; 25s ago
     Docs: man:sshd(8)
           man:sshd_config(5)
 Main PID: 798 (sshd)
   CGroup: /docker/d49a54a50df65ec9c7380a280289eb6ce96a8d378d4907ed1b86494632839957/system.slice/sshd.service
           ├─608 sshd: banner [priv]
           ├─623 sshd: banner@pts/0
           ├─624 -bash
           └─798 /usr/sbin/sshd -D

Nov 02 18:56:50 stapp03.stratos.xfusioncorp.com systemd[798]: Executing: /usr/sbin/ssh...
Nov 02 18:56:50 stapp03.stratos.xfusioncorp.com sshd[798]: WARNING: 'UsePAM no' is not...
Nov 02 18:56:50 stapp03.stratos.xfusioncorp.com sshd[798]: Server listening on 0.0.0.0...
Nov 02 18:56:50 stapp03.stratos.xfusioncorp.com sshd[798]: Server listening on :: port...
Nov 02 18:56:50 stapp03.stratos.xfusioncorp.com systemd[1]: Got notification message f...
Nov 02 18:56:50 stapp03.stratos.xfusioncorp.com systemd[1]: sshd.service: Got notifica...
Nov 02 18:56:50 stapp03.stratos.xfusioncorp.com systemd[1]: sshd.service: got READY=1
Nov 02 18:56:50 stapp03.stratos.xfusioncorp.com systemd[1]: sshd.service changed start...
Nov 02 18:56:50 stapp03.stratos.xfusioncorp.com systemd[1]: Job sshd.service/start fin...
Nov 02 18:56:50 stapp03.stratos.xfusioncorp.com systemd[1]: Started OpenSSH server dae...
Hint: Some lines were ellipsized, use -l to show in full.
[root@stapp03 banner]# 
```

***The End***






