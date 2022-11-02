## Instructions

The Nautilus application development team recently finished the beta version of one of their Java-based applications, which they are planning to deploy on one of the app servers in **Stratos DC**. After an internal team meeting, they have decided to use the *tomcat* application server. Based on the requirements mentioned below complete the task:



a. Install *tomcat* server on App Server 1 using *yum*.

b. Configure it to run on port *8088*.

c. There is a *ROOT.war* file on Jump host at location */tmp*. Deploy it on this tomcat server and make sure the webpage works directly on base URL i.e without specifying any sub-directory anything like this *http://URL/ROOT* .

### My Solution
#### SSH into app Server 1
```bash
thor@jump_host ~$ ssh tony@172.16.238.10
The authenticity of host '172.16.238.10 (172.16.238.10)' can't be established.
ECDSA key fingerprint is SHA256:m8HWuW9KuGTLAHOj4/PS5YTny7xlVwmSlEz57P7O7Ms.
ECDSA key fingerprint is MD5:5e:79:b3:96:52:8a:3d:ee:8e:18:6b:5c:0c:24:5d:cc.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '172.16.238.10' (ECDSA) to the list of known hosts.
tony@172.16.238.10's password: 
```
#### Switch to root user once you are logged in
```bash
[tony@stapp01 ~]$ sudo su

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for tony: 
```
#### *Apache tomcat* is a server for Java-based web applications, as such check if java is installed in the server. In our case the results below shows *openjdk version "1.8.0_352"* is already installed in the server.
```bash
[root@stapp01 tony]# java -version
openjdk version "1.8.0_352"
OpenJDK Runtime Environment (build 1.8.0_352-b08)
OpenJDK 64-Bit Server VM (build 25.352-b08, mixed mode)
[root@stapp01 tony]# 
```

#### Now we proceed to install *tomcat* package and other *tomcat* dependencies. Below is a snippet of the installation process.

```bash
[root@stapp01 tony]# yum install tomcat*
Loaded plugins: fastestmirror, ovl
Loading mirror speeds from cached hostfile
 * base: ohioix.mm.fcix.net
 * extras: mirror.genesisadaptive.com
 * updates: centos.mirror.constant.com
Resolving Dependencies
--> Running transaction check
---> Package tomcat.noarch 0:7.0.76-16.el7_9 will be installed
```
#### Using vi text editor, edit the *tomcat* configuration file located at */usr/share/tomcat/conf/tomcat.conf*, and insert at the bottom of the file the line below. Find the full configuration file [here]()

```bash
[root@stapp01 tony]# vi /usr/share/tomcat/conf/tomcat.conf

# System-wide configuration file for tomcat services
.
.
.
.
JAVA_OPTS="-Djava.security.egd=file:/dev/./urandom -Djava.awt.headless=true -Xmx1026m -XX:MaxPermSize=256m -XX:+UseConcMarkSweepGC"
```

#### Add credentials for the web GUI admin and manager roles. This is done by appending the 3 lines below inside the *tomcat* user configuration file. You can find the full configuration file [here]()

```bash
[root@stapp01 tony]# vi /usr/share/tomcat/conf/tomcat-users.xml

<?xml version='1.0' encoding='utf-8'?>
.
.
.
-->
<tomcat-users>
<role rolename="admin-gui"/>
<role rolename="manager-gui"/>
<user username="admin" password="password" roles="manager-gui,admin-gui"/>
.
.
.
```

#### Configure the tcp port that the *tomcat* webserver is listening on from port *8080* to port *8088* by editing the *tomcat* server configuration file */usr/share/tomcat/conf/server.xml*. Find the full configuration file [here]()

```bash
[root@stapp01 tony]# vi /usr/share/tomcat/conf/server.xml 


<?xml version='1.0' encoding='utf-8'?>
.
.
.

    -->
    <Connector port="8088" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443" />
    <!-- A "Connector" using the shared thread pool-->
    <!--
    <Connector executor="tomcatThreadPool"
               port="8088" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443" />
    -->
 ```  
#### Confirm that the port configurations is done by listing the ports in the configuration file

```bash

[root@stapp02 steve]# cat /usr/share/tomcat/conf/server.xml | grep port
<Server port="8005" shutdown="SHUTDOWN">
         Define a non-SSL HTTP/1.1 Connector on port 8080
    <Connector port="8088" protocol="HTTP/1.1"
               port="8088" protocol="HTTP/1.1"
    <!-- Define a SSL HTTP/1.1 Connector on port 8443
    <Connector port="8443" protocol="org.apache.coyote.http11.Http11Protocol"
    <!-- Define an AJP 1.3 Connector on port 8009 -->
    <Connector port="8009" protocol="AJP/1.3" redirectPort="8443" />
    <!-- You should set jvmRoute to support load-balancing via AJP ie :
[root@stapp02 steve]# 
```
#### Now we need to copy the *ROOT.war* file from the *jump host* to the app server. Exit from the app server back to *jump host*, use the *scp* utility to copy the file from jump host's */tmp/* directory to app server's */tmp/* directory, then *ssh* back into the app server.

```bash
[root@stapp01 tony]# exit
exit
[tony@stapp01 ~]$ exit
logout
Connection to 172.16.238.10 closed.
thor@jump_host ~$ 


thor@jump_host ~$ scp /tmp/ROOT.war tony@172.16.238.10:/tmp
tony@172.16.238.10's password: 
ROOT.war                                        100% 4529     8.4MB/s   00:00    
thor@jump_host ~$ 


thor@jump_host ~$ ssh tony@172.16.238.10
tony@172.16.238.10's password: 
Last login: Tue Nov  1 16:09:32 2022 from jump_host.linux-tomcat-v2_app_net
[tony@stapp01 ~]$ 
```
#### At this stage, we are done with all the required configurations, let us now enable and start the *tomcat* service

```bash
[root@stapp01 tony]# systemctl enable tomcat
Created symlink from /etc/systemd/system/multi-user.target.wants/tomcat.service to /usr/lib/systemd/system/tomcat.service.


[root@stapp01 tony]# systemctl start tomcat
[root@stapp01 tony]# 
```

#### Confirm that the service is up and running

```bash

[root@stapp01 tony]# systemctl status tomcat
● tomcat.service - Apache Tomcat Web Application Container
   Loaded: loaded (/usr/lib/systemd/system/tomcat.service; enabled; vendor preset: disabled)
   Active: active (running) since Tue 2022-11-01 16:34:22 UTC; 15s ago
 Main PID: 1084 (java)
   CGroup: /docker/93e45dc75ea0ab5c243c3bc078e1440344e37e83f39a74793204fb177da55e16/system.slice/tomcat.service
           └─1084 /usr/lib/jvm/jre/bin/java -Djava.security.egd=file:/dev/./ura...

Nov 01 16:34:34 stapp01.stratos.xfusioncorp.com server[1084]: Nov 01, 2022 4:34...
Nov 01 16:34:34 stapp01.stratos.xfusioncorp.com server[1084]: INFO: Deployment ...
Nov 01 16:34:34 stapp01.stratos.xfusioncorp.com server[1084]: Nov 01, 2022 4:34...
Nov 01 16:34:34 stapp01.stratos.xfusioncorp.com server[1084]: INFO: Deploying w...
Nov 01 16:34:36 stapp01.stratos.xfusioncorp.com server[1084]: Nov 01, 2022 4:34...
Nov 01 16:34:36 stapp01.stratos.xfusioncorp.com server[1084]: INFO: At least on...
Nov 01 16:34:36 stapp01.stratos.xfusioncorp.com server[1084]: Nov 01, 2022 4:34...
Nov 01 16:34:36 stapp01.stratos.xfusioncorp.com server[1084]: INFO: Deployment ...
Nov 01 16:34:36 stapp01.stratos.xfusioncorp.com server[1084]: Nov 01, 2022 4:34...
Nov 01 16:34:36 stapp01.stratos.xfusioncorp.com server[1084]: INFO: Deploying w...
Hint: Some lines were ellipsized, use -l to show in full.
[root@stapp01 tony]# 
```

#### Test that the *tomcat* server is runnning and serving the deployed *war* file on the configured port *8088*. This is successful as displayed in the output below.

```bash
[root@stapp01 tony]# curl -I http://172.16.238.10:8088
HTTP/1.1 200 OK
Server: Apache-Coyote/1.1
Content-Type: text/html;charset=ISO-8859-1
Transfer-Encoding: chunked
Date: Tue, 01 Nov 2022 16:35:16 GMT
[root@stapp01 tony]#
```

***The End***










