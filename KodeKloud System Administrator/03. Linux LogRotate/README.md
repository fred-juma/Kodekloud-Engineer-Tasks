# Instructions
The Nautilus DevOps team is ready to launch a new application, which they will deploy on app servers in Stratos Datacenter. They are expecting significant traffic/usage of *tomcat* on app servers after that. This will generate massive logs, creating huge log files. To utilise the storage efficiently, they need to compress the log files and need to rotate old logs. Check the requirements shared below:



a. In all app servers install *tomcat* package.

b. Using *logrotate* configure *tomcat* logs rotation to monthly and keep only 3 rotated logs.

(If by default log rotation is set, then please update configuration as needed)



## My Solution
### The below configurations should be applied on all the three app servers. For this documentation we shall only demonstarate with 1 server. 

### SSH into app server 
```bash
thor@jump_host ~$ ssh tony@172.16.238.10
The authenticity of host '172.16.238.10 (172.16.238.10)' can't be established.
ECDSA key fingerprint is SHA256:eiEtcM5Fb/aTjS0ZnqzPEe4vCXqkdiSo8zwkwLh0+dw.
ECDSA key fingerprint is MD5:51:5e:03:e5:37:ae:ef:66:38:57:82:da:77:05:02:53.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '172.16.238.10' (ECDSA) to the list of known hosts.
tony@172.16.238.10's password: 
```

### Install *tomcat* package  

```bash
[tony@stapp01 ~]$ sudo yum install tomcat
```

### Check if the log rotation configuration file was created during *tomcat* installation....sure enough it was!
```bash
[tony@stapp01 ~]$ ls -l /etc/logrotate.d/
total 8
-rw-r--r-- 1 root root 132 Nov 16  2020 tomcat
-rw-r--r-- 1 root root 103 Nov  5  2018 yum
```

### Go ahead and configure the *tomcat* logrotate configuration as specified in the instructions i.e. logs rotation to be monthly and keep only 3 rotated logs

```bash
[tony@stapp01 ~]$ sudo vi /etc/logrotate.d/tomcat

/var/log/tomcat/catalina.out {
    copytruncate
    monthly
    rotate 3
    compress
    missingok
    create 0644 tomcat tomcat
}
```


### Run an experimentation with the just created *tomcat* log rotation  configuration by forcing an execution using option *-f*, and specifying the configuration file you want to use, in this case *catalina.out*. The configuration file name can be found on the first line of the *tomcat* log configuration file which displays the path where the logs and the rotated logs will be stored and the file where the logs will be stored.

```bash
[tony@stapp01 ~]$ sudo logrotate  -f /etc/logrotate.d/catalina.out
[sudo] password for tony: 
```
### Finally you can list the content of the log storage directory to confirm that the script executed succefully and the log rotation ran and the resulting file saved with the yyyymmdd appended to the file name. And yes we can confirm that from the result shown below!

```bash
[tony@stapp01 ~]$ sudo ls -l  /var/log/tomcat
total 4
-rw-rw---- 1 tomcat tomcat  0 Oct 26 18:40 catalina.out
-rw-rw---- 1 tomcat tomcat 48 Nov 16  2020 catalina.out-20221026.gz
[tony@stapp01 ~]$ 
```