
# Instructions

PAM (Pluggable Authentication Module) Authentication For *Apache*


We have a requirement where we want to password protect a directory in the Apache web server document root. We want to password protect *http://<website-url>:<apache_port>/protected* URL as per the following requirements (you can use any website-url for it like localhost since there are no such specific requirements as of now). Setup the same on **App server 3** as per below mentioned requirements:



a. We want to use basic authentication.

b. We do not want to use *htpasswd* file based authentication. Instead, we want to use *PAM authentication*, i.e *Basic Auth + PAM* so that we can authenticate with a Linux user.

c. We already have a user *kareem* with password *Rc5C9EyvbU* which you need to provide access to.

d. You can access the website using APP button on the top bar.

## My solution

### SSH to the specified app server
```bash
thor@jump_host ~$ ssh banner@172.16.238.12
The authenticity of host '172.16.238.12 (172.16.238.12)' can't be established.
ECDSA key fingerprint is SHA256:SySamszyWhhLGFiybhGBqfrr8g55wS/3e37ZpBOvICs.
ECDSA key fingerprint is MD5:6d:31:18:2a:f9:07:f3:29:dd:0a:d3:1f:6e:04:0a:db.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '172.16.238.12' (ECDSA) to the list of known hosts.
banner@172.16.238.12's password: 
```

### Switch to root user

```bash
[banner@stapp03 ~]$ sudo su
We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for banner: 
[root@stapp03 banner]# 
```

### Confirm the port *httpd* service is listening on from the *httpd* configuration file. This is port *8080* from the output below
```bash
[root@stapp03 banner]# cat  /etc/httpd/conf/httpd.conf | grep -i listen
# Listen: Allows you to bind Apache to specific IP addresses and/or
# Change this to Listen on specific IP addresses as shown below to 
#Listen 12.34.56.78:80
Listen 8080
[root@stapp03 banner]# 
```


### Confirm from the *httpd* configuration file the *document root*. This is */var/www/html* form the output below

```bash
[root@stapp03 banner]# cat  /etc/httpd/conf/httpd.conf | grep -i documentroot
# DocumentRoot: The directory out of which you will serve your
DocumentRoot "/var/www/html"
    # access content that does not live under the DocumentRoot.
[root@stapp03 banner]# 
```

### Start the httpd service

```bash
[root@stapp03 banner]# systemctl status httpd
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
     Docs: man:httpd(8)
           man:apachectl(8)
[root@stapp03 banner]# systemctl status httpd

[root@stapp03 banner]# systemctl start  httpd
[root@stapp03 banner]# 

```

### Browse to the *http://localhost:8080* to confirm the webpage is being served by httpd. All seems to be working fine
```bash
[root@stapp03 banner]# curl localhost:8080
<?php
/**
 * Front to the WordPress application. This file doesn't do anything, but loads
 * wp-blog-header.php which does and tells WordPress to load the theme.
 *
 * @package WordPress
 */

/**
 * Tells WordPress to load the WordPress theme and output it.
 *
 * @var bool
 */
define( 'WP_USE_THEMES', true );

/** Loads the WordPress Environment and Template */
require( dirname( __FILE__ ) . '/wp-blog-header.php' );
[root@stapp03 banner]#
```

### Browse to the protected URL *http://localhost:8080/protected* to confirm the webpage is being served by httpd. All seems to be working fine, except that the URL is not actually protected yet, and is not asking for user authentication.
```bash
[root@stapp03 banner]# curl localhost:8080/protected
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
<title>301 Moved Permanently</title>
</head><body>
<h1>Moved Permanently</h1>
<p>The document has moved <a href="http://localhost:8080/protected/">here</a>.</p>
</body></html>
[root@stapp03 banner]# 
```
### Check whether the Apache module *mod_authnz_pam* is installed. The output shows that it is not installed

```bash
[root@stapp03 banner]# rpm -qa | grep mod_authnz_pam
[root@stapp03 banner]# 
````

### install the Apache module *mod_authnz_pam*. Below is a truncated view of the installation process

```bash
[root@stapp03 banner]# yum -y install mod_authnz_pam
Loaded plugins: fastestmirror, ovl
Determining fastest mirrors
epel/x86_64/metalink                                             |  21 kB  00:00:00     
 * base: mirror.grid.uchicago.edu
 * epel: mirror.team-cymru.com
 * extras: mirror.grid.uchicago.edu
 * remi-php72: mirror.team-cymru.com
 * remi-safe: mirror.team-cymru.com
 * updates: mirror.grid.uchicago.edu
base 
```

### Uncomment the command in the 55-authnz_pam.conf file. See the configuration file [here](https://github.com/fred-juma/Kodekloud-System-Administrator/blob/main/KodeKloud%20System%20Administrator/05%20-%20PAM%20Authentication%20for%20apache/55-authnz_pam.conf) 
```bash
vi /etc/httpd/conf.modules.d/55-authnz_pam.conf
```

### Configure the authnz_pam.conf PAM authorization module with the appropriate commands. The configuration file [here](https://github.com/fred-juma/Kodekloud-System-Administrator/blob/main/KodeKloud%20System%20Administrator/05%20-%20PAM%20Authentication%20for%20apache/authnz_pam.conf) has the commands.

```bash
vi /etc/httpd/conf.d/authnz_pam.conf
```

### Optionally you can add list of Linux users who will be denied from logging in to the protected site

```bash
[root@stapp03 banner]# vi /etc/httpd/conf.d/denyusers
[root@stapp03 banner]# chgrp apache /etc/httpd/conf.d/denyusers
[root@stapp03 banner]# chmod 640 /etc/httpd/conf.d/denyusers
[root@stapp03 banner]# chgrp apache /etc/shadow
[root@stapp03 banner]#  chmod 440 /etc/shadow
```

### We are now done with the necessary configurations. Restart the httpd service for the configrations to be applied.

```bash
[root@stapp03 banner]# systemctl restart httpd
[root@stapp03 banner]# systemctl status httpd
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; disabled; vendor preset: disabled)
   Active: active (running) since Sat 2022-10-29 07:42:12 UTC; 7s ago
     Docs: man:httpd(8)
           man:apachectl(8)
  Process: 889 ExecStop=/bin/kill -WINCH ${MAINPID} (code=exited, status=0/SUCCESS)
 Main PID: 898 (httpd)
   Status: "Processing requests..."
   CGroup: /docker/50f558520cd3768fd6191d6bd3ac32195cc17a564988997787fe7bca6c99d591/system.slice/httpd.service
           ├─898 /usr/sbin/httpd -DFOREGROUND
           ├─900 /usr/sbin/httpd -DFOREGROUND
           ├─901 /usr/sbin/httpd -DFOREGROUND
           ├─902 /usr/sbin/httpd -DFOREGROUND
           ├─903 /usr/sbin/httpd -DFOREGROUND
           └─904 /usr/sbin/httpd -DFOREGROUND

Oct 29 07:42:12 stapp03.stratos.xfusioncorp.com systemd[1]: Starting The Apache HTTP ...
Oct 29 07:42:12 stapp03.stratos.xfusioncorp.com systemd[1]: Started The Apache HTTP S...
Hint: Some lines were ellipsized, use -l to show in full.
[root@stapp03 banner]# 
```

### Access the protected site from the browser to confirm that it is password protected and prompting for authentication. Use the provided credentials to log in. This confirm successful PAM configuration. Alternatively using curl returns an output saying that the site directory is protected

```bash
[root@stapp03 banner]# curl http://localhost:8080/protected/
This is KodeKloud Protected Directory
[root@stapp03 banner]# 
```

***The end***




