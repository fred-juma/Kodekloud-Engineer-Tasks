#### Task

New packages need to be installed on some of the app servers in Stratos Datacenter. The Nautilus DevOps team has decided to install the same using Puppet. Since jump host is already configured to run as Puppet master server and all app servers are already configured to work as puppet agent nodes, we need to create the required manifests on the Puppet master server so that it can be applied on the required Puppet agent node. Please find more details about the task below.


Create a Puppet programming file cluster.pp under /etc/puppetlabs/code/environments/production/manifests directory on master node i.e Jump Host to perform the below given tasks.

Install package nginx using puppet package resource and start its service using puppet service resource on Puppet agent node 3 i.e App Server 3.

	

#### Solution

Create the *cluster.pp* manifest file in the specified location

```bash
thor@jump_host ~$ sudo vi /etc/puppetlabs/code/environments/production/manifests/cluster.pp

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for thor: 
thor@jump_host ~$ sudo vi /etc/puppetlabs/code/environments/production/manifests/demo.pp
thor@jump_host ~$ 
```

Edit the file and update it with the *nginx* package installation and service start commands


```bash
class install_nginx {

# Install nginx package  
 package { 'nginx':
 ensure => installed,
 }
# Start nginx service
 service { 'nginx':
 ensure => running,
 enable => true,
 }

}

node 'stapp01.stratos.xfusioncorp.com','stapp02.stratos.xfusioncorp.com','stapp03.stratos.xfusioncorp.com' {
 include install_nginx
}
```

Ensure the puppet service is up and running in the jump host

```bash
thor@jump_host ~$ sudo systemctl status puppet
● puppet.service - Puppet agent
   Loaded: loaded (/usr/lib/systemd/system/puppet.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
thor@jump_host ~$ sudo systemctl start puppet
thor@jump_host ~$ sudo systemctl status puppet
● puppet.service - Puppet agent
   Loaded: loaded (/usr/lib/systemd/system/puppet.service; disabled; vendor preset: disabled)
   Active: active (running) since Mon 2023-03-20 07:57:36 UTC; 2s ago
 Main PID: 13832 (puppet)
    Tasks: 2
   CGroup: /docker/af974b76a07d25ccdd810b296d59190a3fee684e2fb931d3c68aebb178732578/system.slice/puppet.service
           └─13832 /opt/puppetlabs/puppet/bin/ruby /opt/puppetlabs/puppet/b...
thor@jump_host ~$ 



thor@jump_host ~$ puppet parser validate /etc/puppetlabs/code/environments/production/manifests/demo.pp
thor@jump_host ~$ 
```

Log into each of the 3 appservers and apply the *puppe agent -tv* command to install the *nginx* package and start the service.

SSH into app server 1


```bash
thor@jump_host ~$ ssh tony@stapp01
The authenticity of host 'stapp01 (172.16.238.10)' can't be established.
ECDSA key fingerprint is SHA256:1prvJqZd+M3X585BGTlDdXzJg119gNX2gPh26XMGx9E.
ECDSA key fingerprint is MD5:d7:e9:bd:aa:64:93:16:e8:40:03:d6:12:4d:69:00:69.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'stapp01,172.16.238.10' (ECDSA) to the list of known hosts.
tony@stapp01's password: 
[tony@stapp01 ~]$ sudo su

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for tony: 
```

Apply the *puppe agent -tv* command 

```bash
[root@stapp01 tony]# puppet agent -tv
Info: Using configured environment 'production'
Info: Retrieving pluginfacts
Info: Retrieving plugin
Info: Retrieving locales
Info: Caching catalog for stapp01.stratos.xfusioncorp.com
Info: Applying configuration version '1679557558'
Notice: /Stage[main]/Install_nginx/Package[nginx]/ensure: created
Notice: /Stage[main]/Install_nginx/Service[nginx]/ensure: ensure changed 'stopped' to 'running'
Info: /Stage[main]/Install_nginx/Service[nginx]: Unscheduling refresh on Service[nginx]
Notice: Applied catalog in 25.80 seconds
[root@stapp01 tony]# 
```

Check status of the *nginx* package

```bash

root@stapp01 tony]# systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; vendor preset: disabled)
   Active: active (running) since Thu 2023-03-23 07:46:29 UTC; 2min 46s ago
 Main PID: 1294 (nginx)

```

***The End***
