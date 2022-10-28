### Instructions
xFusionCorp Industries has planned to setup a common email server in Stork DC. After several meetings and recommnendations they have decided to use *postfix* as their **Mail Transfer Agent** and *dovecot* as an *IMAP/POP3* server. We would like you to perform the following steps:

a. Install and configure *postfix* on stork DC mail server.

b. Create an email account anita@stratos.xfusioncorp.com identified by dCV3szSGNA. Set its mail directory to /home/anita/Maildir.

c. Install and configure dovecot on the same server

## My solution

### SSH into the mail server with the provided credentials
```bash
thor@jump_host ~$ ssh groot@172.16.238.17
The authenticity of host '172.16.238.17 (172.16.238.17)' can't be established.
ECDSA key fingerprint is SHA256:9ZMWa71vfLouWfPv0Ia0GnGpBUq/c8WCY8VAAEYzQbs.
ECDSA key fingerprint is MD5:c5:55:b0:24:6b:12:00:63:9c:3c:78:ed:c3:c4:74:66.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '172.16.238.17' (ECDSA) to the list of known hosts.
groot@172.16.238.17's password: 
[groot@stmail01 ~]$ 
```

### Install the postfix package

```bash
[groot@stmail01 ~]$ sudo yum install postfix -y

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for groot: 
Loaded plugins: fastestmirror, ovl
Loading mirror speeds from cached hostfile
 * base: tx-mirror.tier.net
 * extras: mirror.lstn.net
 * updates: ftp.ussg.iu.edu
Resolving Dependencies
--> Running transaction check
---> Package postfix.x86_64 2:2.10.1-9.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

========================================================================================
 Package            Arch              Version                     Repository       Size
========================================================================================
Installing:
 postfix            x86_64            2:2.10.1-9.el7              base            2.4 M

Transaction Summary
========================================================================================
Install  1 Package

Total download size: 2.4 M
Installed size: 12 M
Downloading packages:
postfix-2.10.1-9.el7.x86_64.rpm                                  | 2.4 MB  00:00:00     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : 2:postfix-2.10.1-9.el7.x86_64                                        1/1 
  Verifying  : 2:postfix-2.10.1-9.el7.x86_64                                        1/1 

Installed:
  postfix.x86_64 2:2.10.1-9.el7                                                         

Complete!
[groot@stmail01 ~]$ 
```
### Confirm the mailserver hostname. You will need the information in subsequent step

```bash
[groot@stmail01 ~]$ hostname
stmail01.stratos.xfusioncorp.com
```

### Open with vi editor the postfix configuration file and apply the necessary configuration parameters. Refer to the configuration file here for the applied parameters.

```bash
[groot@stmail01 ~]$ sudo vi /etc/postfix/main.cf
```
### You can switch to root user inorder to start the postfix service. While I did this with sudo, the service could not start until when I changed to root user

```bash
[groot@stmail01 ~]$ sudo su
[sudo] password for groot: 
[root@stmail01 groot]# 
```
### Check the postfix service status

```bash
root@stmail01 groot]# systemctl status postfix
● postfix.service - Postfix Mail Transport Agent
   Loaded: loaded (/usr/lib/systemd/system/postfix.service; enabled; vendor preset: disabled)
   Active: failed (Result: exit-code) since Thu 2022-10-27 21:27:19 UTC; 9min ago
```
### Enable postfix service persist running after server restart 

```bash
[root@stmail01 groot]# systemctl enable postfix
[root@stmail01 groot]# 
```
### Start the postfix service

```bash
[root@stmail01 groot]# systemctl start postfix
[root@stmail01 groot]#
```

### Check the status of the postfix service. It should be up and running

```bash
[root@stmail01 groot]# systemctl status postfix
● postfix.service - Postfix Mail Transport Agent
   Loaded: loaded (/usr/lib/systemd/system/postfix.service; enabled; vendor preset: disabled)
   Active: active (running) since Thu 2022-10-27 20:37:26 UTC; 3s ago
  Process: 1163 ExecStart=/usr/sbin/postfix start (code=exited, status=0/SUCCESS)
  Process: 1162 ExecStartPre=/usr/libexec/postfix/chroot-update (code=exited, status=0/SUCCESS)
  Process: 1158 ExecStartPre=/usr/libexec/postfix/aliasesdb (code=exited, status=0/SUCCESS)
 Main PID: 1234 (master)
   CGroup: /docker/50abd63575e80df8b39172cf818662ccbed340c6815b021acd4def8bcfa2795b/system.slice/postfix.service
           ├─1234 /usr/libexec/postfix/master -w
           ├─1235 pickup -l -t unix -u
           └─1236 qmgr -l -t unix -u

Oct 27 20:37:26 stmail01.stratos.xfusioncorp.com postfix[1163]: /usr/sbin/postconf: w...
Oct 27 20:37:26 stmail01.stratos.xfusioncorp.com postfix/master[1234]: daemon started...
Oct 27 20:37:26 stmail01.stratos.xfusioncorp.com systemd[1]: Child 1163 belongs to po...
Oct 27 20:37:26 stmail01.stratos.xfusioncorp.com systemd[1]: postfix.service: control...
Oct 27 20:37:26 stmail01.stratos.xfusioncorp.com systemd[1]: postfix.service got fina...
Oct 27 20:37:26 stmail01.stratos.xfusioncorp.com systemd[1]: New main PID 1234 belong...
Oct 27 20:37:26 stmail01.stratos.xfusioncorp.com systemd[1]: Main PID loaded: 1234
Oct 27 20:37:26 stmail01.stratos.xfusioncorp.com systemd[1]: postfix.service changed ...
Oct 27 20:37:26 stmail01.stratos.xfusioncorp.com systemd[1]: Job postfix.service/star...
Oct 27 20:37:26 stmail01.stratos.xfusioncorp.com systemd[1]: Started Postfix Mail Tra...
Hint: Some lines were ellipsized, use -l to show in full.
```

### Create the specified postfix user account 

```bash
[root@stmail01 groot]# useradd anita -c "dCV3szSGNA"
[root@stmail01 groot]# passwd anita
Changing password for user anita.
New password: 
Retype new password: 
passwd: all authentication tokens updated successfully.
[root@stmail01 groot]# 
```

### Create another postfix user for testing the email sending functionality with
```bash
[root@stmail01 groot]# useradd difre
[root@stmail01 groot]# passwd difre
Changing password for user difre.
New password: 
Retype new password: 
passwd: all authentication tokens updated successfully.
[root@stmail01 groot]# 
```

### Let's now test and confirm that postfix is well configured and that we can send/receive emails

```bash
[root@stmail01 groot]# telnet localhost smtp
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
220 stmail01.stratos.xfusioncorp.com ESMTP Postfix


ehlo localhost
250-stmail01.stratos.xfusioncorp.com
250-PIPELINING
250-SIZE 10240000
250-VRFY
250-ETRN
250-ENHANCEDSTATUSCODES
250-8BITMIME
250 DSN


mail from: anita@stratos.xfusioncorp.com
250 2.1.0 Ok

rcpt to: difre@stratos.xfusioncorp.com

250 2.1.5 Ok

data
354 End data with <CR><LF>.<CR><LF>
Subject: Test Message
Welcome to postfix mail server
.
250 2.0.0 Ok: queued as E82CA3996047

quit
221 2.0.0 Bye
Connection closed by foreign host.
```

### Access the mail directory for the user anita and read the new email received to confirm that the email sent was received. From the output below, we confirm that postfix is correctly configured and we are able to send/receive emails

```bash
[root@stmail01 groot]# ll /home/anita/Maildir/new/
total 4
-rw------- 1 anita anita 525 Oct 27 20:50 1666903856.V801I39181abM968112.stmail01.stratos.xfusioncorp.com
[root@stmail01 groot]# cat /home/anita/Maildir/new/1666903856.V801I39181abM968112.stmail01.stratos.xfusioncorp.com 
Return-Path: <difre@stratos.xfusioncorp.com>
X-Original-To: anita@stratos.xfusioncorp.com
Delivered-To: anita@stratos.xfusioncorp.com
Received: from localhost (localhost [127.0.0.1])
        by stmail01.stratos.xfusioncorp.com (Postfix) with ESMTP id 80B9A399604E
        for <anita@stratos.xfusioncorp.com>; Thu, 27 Oct 2022 20:50:22 +0000 (UTC)
Subject: Test Message
Message-Id: <20221027205030.80B9A399604E@stmail01.stratos.xfusioncorp.com>
Date: Thu, 27 Oct 2022 20:50:22 +0000 (UTC)
From: difre@stratos.xfusioncorp.com

Welcome to postfix mail server
[root@stmail01 groot]# 
```

### Finally, let us install and configure dovecot package. Below is a trancated view of the installation process.
```bash
[root@stmail01 groot]# yum install dovecot -y
Loaded plugins: fastestmirror, ovl
Loading mirror speeds from cached hostfile
 * base: tx-mirror.tier.net
 * extras: mirror.lstn.net
 * updates: ftp.ussg.iu.edu
Resolving Dependencies
```

### Open the dovecot configuration file with vi editor and apply the appropriate settings to the config file. You can find the configuration file here.

```bash
[root@stmail01 groot]# vi /etc/dovecot/dovecot.conf
```

### Check the status of the dovecot service

```bash
[root@stmail01 groot]# systemctl status dovecot
● dovecot.service - Dovecot IMAP/POP3 email server
   Loaded: loaded (/usr/lib/systemd/system/dovecot.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
     Docs: man:dovecot(1)
           http://wiki2.dovecot.org/

Oct 27 21:43:14 stmail01.stratos.xfusioncorp.com systemd[1]: Collecting dovecot.service
Oct 27 21:43:31 stmail01.stratos.xfusioncorp.com systemd[1]: Collecting dovecot.service
Hint: Some lines were ellipsized, use -l to show in full.
[root@stmail01 groot]# 
```

### Enable the dovecot service to persist beyond server restarts
```bash
[root@stmail01 groot]# systemctl enable  dovecot
Created symlink from /etc/systemd/system/multi-user.target.wants/dovecot.service to /usr/lib/systemd/system/dovecot.service.
[root@stmail01 groot]# systemctl start  dovecot
[root@stmail01 groot]# 
```

### Start the dovecot service
```bash
[root@stmail01 groot]# systemctl start dovecot
```

### Confirm the status to ensure that dovecot is now up and running
```bash
[root@stmail01 groot]# systemctl status  dovecot
● dovecot.service - Dovecot IMAP/POP3 email server
   Loaded: loaded (/usr/lib/systemd/system/dovecot.service; enabled; vendor preset: disabled)
   Active: active (running) since Thu 2022-10-27 21:44:03 UTC; 19s ago
     Docs: man:dovecot(1)
           http://wiki2.dovecot.org/
  Process: 1731 ExecStart=/usr/sbin/dovecot (code=exited, status=0/SUCCESS)
  Process: 1730 ExecStartPre=/usr/sbin/portrelease dovecot (code=exited, status=0/SUCCESS)
  Process: 1728 ExecStartPre=/usr/libexec/dovecot/prestartscript (code=exited, status=0/SUCCESS)
 Main PID: 1732 (dovecot)
   CGroup: /docker/85b3bc7f907bfa33092df156d5a252db4342fcf3f338f9d3115bcd97984e5b5c/system.slice/dovecot.service
           ├─1732 /usr/sbin/dovecot
           ├─1733 dovecot/anvil
           ├─1734 dovecot/log
           └─1736 dovecot/config

Oct 27 21:44:03 stmail01.stratos.xfusioncorp.com systemd[1731]: Executing: /usr/sbin/...
Oct 27 21:44:03 stmail01.stratos.xfusioncorp.com dovecot[1732]: master: Dovecot v2.2....
Oct 27 21:44:03 stmail01.stratos.xfusioncorp.com systemd[1]: Child 1731 belongs to do...
Oct 27 21:44:03 stmail01.stratos.xfusioncorp.com systemd[1]: dovecot.service: control...
Oct 27 21:44:03 stmail01.stratos.xfusioncorp.com systemd[1]: dovecot.service got fina...
Oct 27 21:44:03 stmail01.stratos.xfusioncorp.com systemd[1]: New main PID 1732 belong...
Oct 27 21:44:03 stmail01.stratos.xfusioncorp.com systemd[1]: Main PID loaded: 1732
Oct 27 21:44:03 stmail01.stratos.xfusioncorp.com systemd[1]: dovecot.service changed ...
Oct 27 21:44:03 stmail01.stratos.xfusioncorp.com systemd[1]: Job dovecot.service/star...
Oct 27 21:44:03 stmail01.stratos.xfusioncorp.com systemd[1]: Started Dovecot IMAP/POP...
Hint: Some lines were ellipsized, use -l to show in full.
[root@stmail01 groot]#
```

***The end***






