# Instructions

The production support team of **xFusionCorp Industries** has deployed some of the latest monitoring tools to keep an eye on every service, application, etc. running on the systems. One of the monitoring systems reported about *Apache* service unavailability on one of the app servers in **Stratos DC**.

Identify the faulty app host and fix the issue. Make sure *Apache* service is up and running on all app hosts. They might not hosted any code yet on these servers so you need not to worry about if Apache isn't serving any pages or not, just make sure service is up and running. Also, make sure *Apache* is running on port *8085* on all app servers.

## My Solution
### SSH into application server 1
```bash
thor@jump_host ~$ ssh tony@172.16.238.10
The authenticity of host '172.16.238.10 (172.16.238.10)' can't be established.
ECDSA key fingerprint is SHA256:SySamszyWhhLGFiybhGBqfrr8g55wS/3e37ZpBOvICs.
ECDSA key fingerprint is MD5:6d:31:18:2a:f9:07:f3:29:dd:0a:d3:1f:6e:04:0a:db.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '172.16.238.10' (ECDSA) to the list of known hosts.
tony@172.16.238.10's password: 
```

### Switch to root user
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

### Check the status of httpd service. The results show that the service is down.
```bash
[root@stapp01 tony]# systemctl status httpd
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
     Docs: man:httpd(8)
           man:apachectl(8)
[root@stapp01 tony]# 
```
### Attempt to start the service. Unfortunately the service couldn't start.
```bash
[root@stapp01 tony]# systemctl start httpd
Job for httpd.service failed because the control process exited with error code. See "systemctl status httpd.service" and "journalctl -xe" for details.
[root@stapp01 tony]# 
```
### We need to troubleshoot by digging into httpd logs to find out the issue with the httpd service
### One way is using the journalctl command to examine the systemd logs  for httpd

```bash
[root@stapp01 tony]# journalctl -xe
-- Logs begin at Sun 2022-10-30 08:17:22 UTC, end at Sun 2022-10-30 08:24:45 UTC. --
Oct 30 08:17:22 stapp01.stratos.xfusioncorp.com systemd-journal[211]: Runtime journal is using 8.0M (max allowed 4.0G, trying to leave 4.0G free of 102.3G available → curre
nt limit 4.0G).
Oct 30 08:17:22 stapp01.stratos.xfusioncorp.com systemd-journal[211]: Journal started
-- Subject: The journal has been started
-- Defined-By: systemd
-- Support: http://lists.freedesktop.org/mailman/listinfo/systemd-devel
-- 
-- The system journal process has started up, opened the journal
-- files for writing and is now ready to process requests.
Oct 30 08:17:22 stapp01.stratos.xfusioncorp.com mount[212]: mount: permission denied
Oct 30 08:17:22 stapp01.stratos.xfusioncorp.com mount[214]: mount: permission denied
Oct 30 08:17:22 stapp01.stratos.xfusioncorp.com mount[215]: mount: permission denied
Oct 30 08:17:22 stapp01.stratos.xfusioncorp.com mount[220]: mount: permission denied
Oct 30 08:17:22 stapp01.stratos.xfusioncorp.com rhel-domainname[226]: /usr/lib/systemd/rhel-domainname: line 2: /etc/sysconfig/network: No such file or directory
Oct 30 08:17:22 stapp01.stratos.xfusioncorp.com systemd[1]: systemd-journald.service: Couldn't add fd to fd store: Operation not permitted
Oct 30 08:17:22 stapp01.stratos.xfusioncorp.com systemd[1]: systemd-journald.service: Couldn't add fd to fd store: Operation not permitted
Oct 30 08:17:22 stapp01.stratos.xfusioncorp.com systemd[1]: systemd-journald.service: Couldn't add fd to fd store: Operation not permitted
Oct 30 08:17:22 stapp01.stratos.xfusioncorp.com systemd[1]: systemd-journald.service: Couldn't add fd to fd store: Operation not permitted
Oct 30 08:17:22 stapp01.stratos.xfusioncorp.com systemd[1]: systemd-journald.service: Couldn't add fd to fd store: Operation not permitted
Oct 30 08:17:22 stapp01.stratos.xfusioncorp.com systemd[1]: systemd-journald.service: Couldn't add fd to fd store: Operation not permitted
Oct 30 08:17:22 stapp01.stratos.xfusioncorp.com systemd[1]: systemd-journald.service: Couldn't add fd to fd store: Operation not permitted
Oct 30 08:17:22 stapp01.stratos.xfusioncorp.com systemd[1]: systemd-journald.service: Couldn't add fd to fd store: Operation not permitted
Oct 30 08:17:22 stapp01.stratos.xfusioncorp.com systemd[1]: dev-hugepages.mount mount process exited, code=exited status=32
Oct 30 08:17:22 stapp01.stratos.xfusioncorp.com systemd[1]: Failed to mount Huge Pages File System.
-- Subject: Unit dev-hugepages.mount has failed
-- Defined-By: systemd
-- Support: http://lists.freedesktop.org/mailman/listinfo/systemd-devel
-- 
-- Unit dev-hugepages.mount has failed.
-- 
-- The result is failed.
Oct 30 08:17:22 stapp01.stratos.xfusioncorp.com systemd[1]: Unit dev-hugepages.mount entered failed state.
Oct 30 08:17:22 stapp01.stratos.xfusioncorp.com systemd[1]: sys-fs-fuse-connections.mount mount process exited, code=exited status=32
Oct 30 08:17:22 stapp01.stratos.xfusioncorp.com systemd[1]: Failed to mount FUSE Control File System.
-- Subject: Unit sys-fs-fuse-connections.mount has failed
-- Defined-By: systemd
-- Support: http://lists.freedesktop.org/mailman/listinfo/systemd-devel
-- 
-- Unit sys-fs-fuse-connections.mount has failed.
-- 
-- The result is failed.
Oct 30 08:17:22 stapp01.stratos.xfusioncorp.com systemd[1]: Unit sys-fs-fuse-connections.mount entered failed state.
Oct 30 08:17:22 stapp01.stratos.xfusioncorp.com systemd[1]: sys-kernel-config.mount mount process exited, code=exited status=32
Oct 30 08:17:22 stapp01.stratos.xfusioncorp.com systemd[1]: Failed to mount Configuration File System.
-- Subject: Unit sys-kernel-config.mount has failed
```

### Another way is using the systemctl command 
```bash
[root@stapp01 tony]# systemctl status httpd.service
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; disabled; vendor preset: disabled)
   Active: failed (Result: exit-code) since Sun 2022-10-30 08:29:04 UTC; 15s ago
     Docs: man:httpd(8)
           man:apachectl(8)
  Process: 644 ExecStop=/bin/kill -WINCH ${MAINPID} (code=exited, status=1/FAILURE)
  Process: 643 ExecStart=/usr/sbin/httpd $OPTIONS -DFOREGROUND (code=exited, status=1/FAILURE)
 Main PID: 643 (code=exited, status=1/FAILURE)

Oct 30 08:29:04 stapp01.stratos.xfusioncorp.com httpd[643]: AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using stapp01...s message
Oct 30 08:29:04 stapp01.stratos.xfusioncorp.com httpd[643]: (98)Address already in use: AH00072: make_sock: could not bind to address 0.0.0.0:8085
Oct 30 08:29:04 stapp01.stratos.xfusioncorp.com httpd[643]: no listening sockets available, shutting down
Oct 30 08:29:04 stapp01.stratos.xfusioncorp.com httpd[643]: AH00015: Unable to open logs
Oct 30 08:29:04 stapp01.stratos.xfusioncorp.com systemd[1]: httpd.service: main process exited, code=exited, status=1/FAILURE
Oct 30 08:29:04 stapp01.stratos.xfusioncorp.com kill[644]: kill: cannot find process ""
Oct 30 08:29:04 stapp01.stratos.xfusioncorp.com systemd[1]: httpd.service: control process exited, code=exited status=1
Oct 30 08:29:04 stapp01.stratos.xfusioncorp.com systemd[1]: Failed to start The Apache HTTP Server.
Oct 30 08:29:04 stapp01.stratos.xfusioncorp.com systemd[1]: Unit httpd.service entered failed state.
Oct 30 08:29:04 stapp01.stratos.xfusioncorp.com systemd[1]: httpd.service failed.
Hint: Some lines were ellipsized, use -l to show in full.
```
### With *systemctl* you can use *-l* to output the entire contents of a line, instead of substituting in ellipses (…) for long lines. The *--no-pager* flag will output the entire log to your screen without invoking a tool like *less* that only shows a screen of content at a time.

```bash
[root@stapp01 tony]# systemctl status httpd.service -l --no-pager
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; disabled; vendor preset: disabled)
   Active: failed (Result: exit-code) since Sun 2022-10-30 08:29:04 UTC; 2min 22s ago
     Docs: man:httpd(8)
           man:apachectl(8)
  Process: 644 ExecStop=/bin/kill -WINCH ${MAINPID} (code=exited, status=1/FAILURE)
  Process: 643 ExecStart=/usr/sbin/httpd $OPTIONS -DFOREGROUND (code=exited, status=1/FAILURE)
 Main PID: 643 (code=exited, status=1/FAILURE)

Oct 30 08:29:04 stapp01.stratos.xfusioncorp.com httpd[643]: AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using stapp01.stratos.xfusioncorp.com. Set the 'ServerName' directive globally to suppress this message
Oct 30 08:29:04 stapp01.stratos.xfusioncorp.com httpd[643]: (98)Address already in use: AH00072: make_sock: could not bind to address 0.0.0.0:8085
Oct 30 08:29:04 stapp01.stratos.xfusioncorp.com httpd[643]: no listening sockets available, shutting down
Oct 30 08:29:04 stapp01.stratos.xfusioncorp.com httpd[643]: AH00015: Unable to open logs
Oct 30 08:29:04 stapp01.stratos.xfusioncorp.com systemd[1]: httpd.service: main process exited, code=exited, status=1/FAILURE
Oct 30 08:29:04 stapp01.stratos.xfusioncorp.com kill[644]: kill: cannot find process ""
Oct 30 08:29:04 stapp01.stratos.xfusioncorp.com systemd[1]: httpd.service: control process exited, code=exited status=1
Oct 30 08:29:04 stapp01.stratos.xfusioncorp.com systemd[1]: Failed to start The Apache HTTP Server.
Oct 30 08:29:04 stapp01.stratos.xfusioncorp.com systemd[1]: Unit httpd.service entered failed state.
Oct 30 08:29:04 stapp01.stratos.xfusioncorp.com systemd[1]: httpd.service failed.
[root@stapp01 tony]#
```


### Another way of using journalctl command is by including the *--since today* flag.  This will limit the output of the command to log entries beginning at 00:00:00 of the current day only. Using this option will help restrict the volume of log entries that you need to examine when checking for errors. 
```bash
[root@stapp01 tony]# sudo journalctl -u httpd.service --since today --no-pager
-- Logs begin at Sun 2022-10-30 08:17:22 UTC, end at Sun 2022-10-30 08:33:29 UTC. --
Oct 30 08:24:45 stapp01.stratos.xfusioncorp.com systemd[1]: Starting The Apache HTTP Server...
Oct 30 08:24:45 stapp01.stratos.xfusioncorp.com httpd[578]: AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using stapp01.stratos.xfusioncorp.com. Set the 'ServerName' directive globally to suppress this message
Oct 30 08:24:45 stapp01.stratos.xfusioncorp.com httpd[578]: (98)Address already in use: AH00072: make_sock: could not bind to address 0.0.0.0:8085
Oct 30 08:24:45 stapp01.stratos.xfusioncorp.com httpd[578]: no listening sockets available, shutting down
Oct 30 08:24:45 stapp01.stratos.xfusioncorp.com httpd[578]: AH00015: Unable to open logs
Oct 30 08:24:45 stapp01.stratos.xfusioncorp.com systemd[1]: httpd.service: main process exited, code=exited, status=1/FAILURE
Oct 30 08:24:45 stapp01.stratos.xfusioncorp.com kill[579]: kill: cannot find process ""
Oct 30 08:24:45 stapp01.stratos.xfusioncorp.com systemd[1]: httpd.service: control process exited, code=exited status=1
Oct 30 08:24:45 stapp01.stratos.xfusioncorp.com systemd[1]: Failed to start The Apache HTTP Server.
Oct 30 08:24:45 stapp01.stratos.xfusioncorp.com systemd[1]: Unit httpd.service entered failed state.
Oct 30 08:24:45 stapp01.stratos.xfusioncorp.com systemd[1]: httpd.service failed.
Oct 30 08:29:04 stapp01.stratos.xfusioncorp.com systemd[1]: Starting The Apache HTTP Server...
Oct 30 08:29:04 stapp01.stratos.xfusioncorp.com httpd[643]: AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using stapp01.stratos.xfusioncorp.com. Set the 'ServerName' directive globally to suppress this message
Oct 30 08:29:04 stapp01.stratos.xfusioncorp.com httpd[643]: (98)Address already in use: AH00072: make_sock: could not bind to address 0.0.0.0:8085
Oct 30 08:29:04 stapp01.stratos.xfusioncorp.com httpd[643]: no listening sockets available, shutting down
Oct 30 08:29:04 stapp01.stratos.xfusioncorp.com httpd[643]: AH00015: Unable to open logs
Oct 30 08:29:04 stapp01.stratos.xfusioncorp.com systemd[1]: httpd.service: main process exited, code=exited, status=1/FAILURE
Oct 30 08:29:04 stapp01.stratos.xfusioncorp.com kill[644]: kill: cannot find process ""
Oct 30 08:29:04 stapp01.stratos.xfusioncorp.com systemd[1]: httpd.service: control process exited, code=exited status=1
Oct 30 08:29:04 stapp01.stratos.xfusioncorp.com systemd[1]: Failed to start The Apache HTTP Server.
Oct 30 08:29:04 stapp01.stratos.xfusioncorp.com systemd[1]: Unit httpd.service entered failed state.
Oct 30 08:29:04 stapp01.stratos.xfusioncorp.com systemd[1]: httpd.service failed.
[root@stapp01 tony]# 
```

### Yet another way to diagnose the cause of the problem is using *apachectl* command

```bash
[root@stapp01 tony]# sudo apachectl configtest
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using stapp01.stratos.xfusioncorp.com. Set the 'ServerName' directive globally to suppress this message
Syntax OK
[root@stapp01 tony]# 
```

### Examininig the various logs generated, we can see 2 main issues causnig the *httpd* service to fail.

i) AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using stapp01.stratos.xfusioncorp.com. Set the 'ServerName' directive globally to suppress this message

ii) (98)Address already in use: AH00072: make_sock: could not bind to address 0.0.0.0:8085

### The first issue, the *AH00558* message tells u that Apache couldn’t find a valid ServerName directive in its configuration file. To resolve it, add a line containing *ServerName 127.0.0.1* to the end of the httpd conffiguration file.

### Open the */etc/httpd/conf/httpd.conf* file with root privileges using vi text editor: Add the ServerName 127.0.0.1 line to the end of the file and save it.

### Run *apachectl* to test that the configuration is valid. A successful *apachectl configtest* invocation should result in output like this:
```bash
[root@stapp01 tony]# sudo apachectl configtest
Syntax OK
[root@stapp01 tony]# 
```
### The second issue, AH00072 error message is generated when there is another process listening on the same port that Apache is configured to use, in this case 8085.
### We use the *ss* utility to determine the name of the process that is already bound to an IPv4 interface on port 8085. 

### The flags to the *ss* command alter its default output in the following ways:

-4 restricts ss to only display IPv4-related socket information. -6 to IPv6.

-t restricts the output to tcp sockets only.

-l displays all listening sockets with the -4 and -t restrictions taken into account.

-n ensures that port numbers are displayed, as opposed to protocol names like *httporhttps*. 

-p outputs information about the process that is bound to a port.

```bash
[root@stapp01 tony]# sudo ss -4 -tlnp | grep 8085
LISTEN     0      10     127.0.0.1:8085       
              *:*                   users:(("sendmail",pid=501,fd=4))
[root@stapp01 tony]# sudo ss -6 -tlnp | grep 8085
[root@stapp01 tony]# 
```

### To determine the name of the program, we use the ps utility together with the process ID (pid=501) 
```bash
[root@stapp01 tony]# sudo ps -p 501
    PID TTY          TIME CMD
    501 ?        00:00:00 sendmail
[root@stapp01 tony]# 
```
### From the above diagnostics we can tell that port 8085 is already being used by *sendmail* application. We can confirm this by looking into the *sendmail* configuration file
```bash
[root@stapp01 tony]# cat /etc/mail/sendmail.mc | grep 8085
DAEMON_OPTIONS(`Port=8085,Addr=127.0.0.1, Name=MTA')dnl
[root@stapp01 tony]# 
```
### Workaround here is to kill the service with pid 8085, then reconfigure sendmail to use a different port. In my case, I configured sendmail to use port 8000 which was not in use. The path to sendmail configuration file is  */etc/mail/sendmail.mc*
### With those 2 issues out of the way, we can now start the httpd service, and all should go well. And indeed, checking the status of the httpd service, we can see the service is now up and running

```bash
[root@stapp01 tony]# systemctl start httpd
[root@stapp01 tony]# systemctl status httpd
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; disabled; vendor preset: disabled)
   Active: active (running) since Sun 2022-10-30 08:57:32 UTC; 7s ago
     Docs: man:httpd(8)
           man:apachectl(8)
  Process: 700 ExecStop=/bin/kill -WINCH ${MAINPID} (code=exited, status=1/FAILURE)
 Main PID: 837 (httpd)
   Status: "Processing requests..."
   CGroup: /docker/4fbae3f3d1abba33c51972e8e3eb5aa9caef12e13254bbdbccf5d55c0351e4cf/system.slice/httpd.service
           ├─837 /usr/sbin/httpd -DFOREGROUND
           ├─839 /usr/sbin/httpd -DFOREGROUND
           ├─840 /usr/sbin/httpd -DFOREGROUND
           ├─841 /usr/sbin/httpd -DFOREGROUND
           ├─842 /usr/sbin/httpd -DFOREGROUND
           └─843 /usr/sbin/httpd -DFOREGROUND

Oct 30 08:57:32 stapp01.stratos.xfusioncorp.com systemd[1]: Starting The Apache HTTP Server...
Oct 30 08:57:32 stapp01.stratos.xfusioncorp.com systemd[1]: Started The Apache HTTP Server.
[root@stapp01 tony]# 
```
### Check the status of httpd service in the remaining 2 app servers, and ensure it is up and running on both servers on port 8085.

***The end***