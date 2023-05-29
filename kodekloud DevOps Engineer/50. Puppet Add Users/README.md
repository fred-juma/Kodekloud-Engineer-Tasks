#### Task

A new teammate has joined the Nautilus application development team, the application development team has asked the DevOps team to create a new user account for the new teammate on application server 1 in Stratos Datacenter. The task needs to be performed using Puppet only. You can find more details below about the task.



Create a Puppet programming file beta.pp under /etc/puppetlabs/code/environments/production/manifests directory on master node i.e Jump Server, and using Puppet user resource add a user on all app servers as mentioned below:

Create a user javed and set its UID to 1479 on Puppet agent nodes 1 i.e App Servers 1.
Notes: :- Please make sure to run the puppet agent test using sudo on agent nodes, otherwise you can face certificate issues. In that case you will have to clean the certificates first and then you will be able to run the puppet agent test.

:- Before clicking on the Check button please make sure to verify puppet server and puppet agent services are up and running on the respective servers, also please make sure to run puppet agent test to apply/test the changes manually first.

:- Please note that once lab is loaded, the puppet server service should start automatically on puppet master server, however it can take upto 2-3 minutes to start.

#### Solution

start the puppet daemon

```bash
root@jump_host /etc/puppetlabs/code/environments/production/manifests# sudo systemctl start puppet
root@jump_host /etc/puppetlabs/code/environments/production/manifests# sudo systemctl status puppet
● puppet.service - Puppet agent
   Loaded: loaded (/usr/lib/systemd/system/puppet.service; disabled; vendor preset: disabled)
   Active: active (running) since Tue 2023-05-09 07:27:31 UTC; 1s ago
 Main PID: 13806 (puppet)
    Tasks: 2
   CGroup: /docker/22884671d34992acb41088ae0da9f74738db78cb49a993fcf5859f429bd8e0a9/system.slice/puppet.service
           └─13806 /opt/puppetlabs/puppet/bin/ruby /opt/puppetlabs/puppet/bin/puppet agent --no-daemonize
root@jump_host /etc/puppetlabs/code/environments/production/manifests# 
```

Edit the *beta* manifest

```bash
root@jump_host /etc/puppetlabs/code/environments/production/manifests# vi beta.pp 

class add_user{

user { 'javed':
ensure => present,
uid => 1479,
}
}

node 'stapp01.stratos.xfusioncorp.com', 'stapp02.stratos.xfusioncorp.com', 'stapp03.stratos.xfusioncorp.com' {
  include add_user
}

```

Perform validity check on the *beta* manifest

```bash
root@jump_host /etc/puppetlabs/code/environments/production/manifests# puppet parser validate beta.pp 
root@jump_host /etc/puppetlabs/code/environments/production/manifests# 
```

SSH into app server 1

```bash

root@jump_host /etc/puppetlabs/code/environments/production/manifests# ssh tony@stapp01
The authenticity of host 'stapp01 (172.16.238.10)' can't be established.
ECDSA key fingerprint is SHA256:sx9bxnuuNOESKcn8Qb0ihJfiN7hj0c4iJXYbnonL2l4.
ECDSA key fingerprint is MD5:7c:86:62:0c:8c:96:47:93:a1:62:61:86:ee:74:96:a5.
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
[root@stapp01 tony]# 
```

Confir that user *javed* does not exist on the node

```bash
[root@stapp01 tony]# cat /etc/passwd | grep javed
```

Apply the puppet manifest on the node

```bash
[root@stapp01 tony]# puppet agent -tv
Info: Using configured environment 'production'
Info: Retrieving pluginfacts
Info: Retrieving plugin
Info: Retrieving locales
Info: Caching catalog for stapp01.stratos.xfusioncorp.com
Info: Applying configuration version '1683618658'
Notice: /Stage[main]/Add_user/User[javed]/ensure: created
Notice: Applied catalog in 0.20 seconds
[root@stapp01 tony]# 
```

Confirm that the user *javed* is created on the node

```bash

[tony@stapp01 ~]$ cat /etc/passwd | grep javed
javed:x:1479:1479::/home/javed:/bin/bash
[tony@stapp01 ~]$ 
```