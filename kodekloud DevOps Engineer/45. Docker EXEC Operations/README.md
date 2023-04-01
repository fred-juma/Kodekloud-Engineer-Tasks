#### Task
One of the Nautilus DevOps team members was working to configure services on a kkloud container that is running on App Server 2 in Stratos Datacenter. Due to some personal work he is on PTO for the rest of the week, but we need to finish his pending work ASAP. Please complete the remaining work as per details given below:



a. Install apache2 in kkloud container using apt that is running on App Server 2 in Stratos Datacenter.

b. Configure Apache to listen on port 3000 instead of default http port. Do not bind it to listen on specific IP or hostname only, i.e it should listen on localhost, 127.0.0.1, container ip, etc.

c. Make sure Apache service is up and running inside the container. Keep the container in running state at the end.


#### Solution

SSH into app server2

```bash
thor@jump_host ~$ ssh steve@stapp02
The authenticity of host 'stapp02 (172.16.238.11)' can't be established.
ECDSA key fingerprint is SHA256:16M39383K+PWinxqwnvS0Vm6leRT4EMx8APpMV7Lcbs.
ECDSA key fingerprint is MD5:2f:5e:79:3b:5d:bc:e3:05:ce:45:4c:60:ec:06:a1:00.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'stapp02,172.16.238.11' (ECDSA) to the list of known hosts.
steve@stapp02's password: 
[steve@stapp02 ~]$ sudo su

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for steve: 
[root@stapp02 steve]# 

```

View running docker containers

```bash
[root@stapp02 steve]# docker ps
CONTAINER ID   IMAGE          COMMAND       CREATED              STATUS              PORTS     NAMES
82750aa34e04   ubuntu:18.04   "/bin/bash"   About a minute ago   Up About a minute             kkloud
[root@stapp02 steve]# docker images
REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
ubuntu       18.04     3941d3b032a8   3 weeks ago   63.1MB
[root@stapp02 steve]# 
```

Exec into the docker container

```bash

[root@stapp02 steve]# docker exec -it 82750aa34e04 /bin/bash
root@82750aa34e04:/# 
```

Install apache2


```bash
root@82750aa34e04:/# apt install apache2
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following additional packages will be installed:
  apache2-bin apache2-data apache2-utils file libapr1 libaprutil1 libaprutil1-dbd-sqlite3 libaprutil1-ldap libexpat1 libgdbm-compat4 libgdbm5 libicu60
  liblua5.2-0 libmagic-mgc libmagic1 libperl5.26 libxml2 mime-support netbase perl perl-modules-5.26 ssl-cert xz-utils
```

Install an editor
```bash
root@82750aa34e04:/# apt install vim
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following additional packages will be installed:
  libgpm2 libmpdec2 libpython3.6 libpython3.6-minimal libpython3.6-stdlib libreadline7 readline-common vim-common vim-runtime xxd
Suggested packages:
  gpm readline-doc ctags vim-doc vim-scripts
The following NEW packages will be installed:
```

Edit the apache listening port from *80* to *3000*


```bash
root@82750aa34e04:/# vim /etc/apache2/ports.conf 


# If you just change the port or add more ports here, you will likely also
# have to change the VirtualHost statement in
# /etc/apache2/sites-enabled/000-default.conf

Listen 3000

<IfModule ssl_module>
        Listen 443
</IfModule>

<IfModule mod_gnutls.c>
        Listen 443
</IfModule>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet

root@82750aa34e04:/# 
```


Check the apache2 service, start it and ensure it is running


```bash

root@82750aa34e04:/# service apache2 status  
 * apache2 is not running
root@82750aa34e04:/# service apache2 start 
 * Starting Apache httpd web server apache2                                                                                                              AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 192.168.3.2. Set the 'ServerName' directive globally to suppress this message
 * 
root@82750aa34e04:/# service apache2 status
 * apache2 is running
root@82750aa34e04:/# 
```

Test that the default apache2 website is served on port 3000 using localhost

```bash
root@82750aa34e04:/# curl localhost:3000

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <!--
    Modified from the Debian original for Ubuntu
    Last updated: 2016-11-16
    See: https://launchpad.net/bugs/1288690
  -->
```

Also test that apache2 website is served on port 3000 using loopback IP address

```bash
  root@82750aa34e04:/# curl 127.0.0.1:3000

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <!--
    Modified from the Debian original for Ubuntu
    Last updated: 2016-11-16
    See: https://launchpad.net/bugs/1288690
  -->
  <head>
  ```


  ***The End***