#### Task

The Puppet master and Puppet agent nodes have been set up by the Nautilus DevOps team to perform some testing. In Stratos DC all app servers have been configured as Puppet agent nodes. They want to setup a password less SSH connection between Puppet master and Puppet agent nodes and this task needs to be done using Puppet itself. Below are details about the task:



Create a Puppet programming file demo.pp under /etc/puppetlabs/code/environments/production/manifests directory on the Puppet master node i.e on Jump Server. Define a class ssh_node1 for agent node 1 i.e App Server 1, ssh_node2 for agent node 2 i.e App Server 2, ssh_node3 for agent node3 i.e App Server 3. You will need to generate a new ssh key for thor user on Jump Server, that needs to be added on all App Servers.

Configure a password less SSH connection from puppet master i.e jump host to all App Servers. However, please make sure the key is added to the authorized_keys file of each app's sudo user (i.e tony for App Server 1).

Notes: :- Before clicking on the Check button please make sure to verify puppet server and puppet agent services are up and running on the respective servers, also please make sure to run puppet agent test to apply/test the changes manually first.

#### Solution

Change to super user on jump_host

```bash
thor@jump_host ~$ sudo su

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for thor: 
```

Retrieve the SSH public key from the jump host

```bash
root@jump_host /etc/puppetlabs/code/environments/production/manifests# cat /root/.ssh/id_rsa.pub 
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDQTBjNonA/XWKvEQQKMrk2dyNCNedIWtb6Ic7o5wj3ok6rgIr5rqefrLSDN2RmyCDd+UBcVqtBH4DMt/CjVESU9qTVT40uN3t9Ao0h+G/ZAJnypBFZjBDrM7eArJPy5jvoDqDpyLKCco+hfbMfBPi0Fp0PaUb5QIWwUC3XJARIqlUavzbQvoyxJuh9722uqmdx71h3VCRpraUhSfTF8A735ig/Y+ieV5SJHSGP0Goc9U4N8b79n2ievcbKti+Fz///2h4LjIDekwx1xUJBbxLa34kwais9rRyd6uFYqZ7SezcYdqxzm8nm0/U9zehzWQRluqOI54iqsN58feuZq8lf root@jump_host.stratos.xfusioncorp.com
root@jump_host /etc/puppetlabs/code/environments/production/manifests# 
```

Create the puppet programming file 

```bash
root@jump_host /home/thor# touch /etc/puppetlabs/code/environments/production/manifests/cluster.pp
root@jump_host /home/thor# 

```

Configure the file with the directions provided

```bash
root@jump_host /etc/puppetlabs/code/environments/production/manifests# vi cluster.pp


$public_key= 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC53e/iLsfuvdHCqZVWP/Rh2MEak/HYitFGNpzA9H2XyCdXTrPBFqq5hAHGDmd1G73HX59ba85JOfbbk45d6QTWask53qFyjcau4/77kM/f+Y1u0T2Bhy6Jq7tk6v9zqrnBY7kw/4kJS8VwTtufTuNoCb3MgV5KUpn1CthkT/B26DTdtvyDqiSwfIZQR29G3kYqIKGk1lyF942gGgBdYDWMGjHsSfOYtK8jzU1WGJ1rCfloVq3KXlARXKiHZOczYpPP9+Sz3Z3ZzKccLAiQ+R6v1t7HT3KFjZNTnxCwDIX9mC82k96cOW2hs4IWMDi5Ojn/hwegUgYTl4en1IqksIID'

class ssh_node1 {
   ssh_authorized_key { 'tony@stapp01':
     user   => 'tony',
     ensure => present,
     type   => 'ssh-rsa',
     key    => $public_key,
   }
 }

 class ssh_node2 {
   ssh_authorized_key { 'steve@stapp02':
     user   => 'steve',
     ensure => present,
     type   => 'ssh-rsa',
     key    => $public_key,
   }
 }

 class ssh_node3 {
   ssh_authorized_key { 'banner@stapp03':
     user   => 'banner',
     ensure => present,
     type   => 'ssh-rsa',
     key    => $public_key,
   }
 }

 node stapp01.stratos.xfusioncorp.com {
   include ssh_node1
 }
 node stapp02.stratos.xfusioncorp.com {
   include ssh_node2
 }
 node stapp03.stratos.xfusioncorp.com {
   include ssh_node3
 }

 ```

 Validate the puppet programming file

 ```bash
 root@jump_host /etc/puppetlabs/code/environments/production/manifests# puppet parser validate cluster.pp 
root@jump_host /etc/puppetlabs/code/environments/production/manifests# 
```

Check the status of puppet package on the puppet master

```bash
root@jump_host /etc/puppetlabs/code/environments/production/manifests# sudo systemctl status puppet
● puppet.service - Puppet agent
   Loaded: loaded (/usr/lib/systemd/system/puppet.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
root@jump_host /etc/puppetlabs/code/environments/production/manifests# 
```

Start the service 

```bash
root@jump_host /etc/puppetlabs/code/environments/production/manifests# sudo systemctl start puppet
root@jump_host /etc/puppetlabs/code/environments/production/manifests# sudo systemctl status puppet
● puppet.service - Puppet agent
   Loaded: loaded (/usr/lib/systemd/system/puppet.service; disabled; vendor preset: disabled)
   Active: active (running) since Tue 2023-02-14 11:21:53 UTC; 4s ago
 Main PID: 13850 (puppet)
    Tasks: 5
   CGroup: /docker/715278e7668c426dd9f5a9baa6ae4e1bc96d5393f7db4a2f5848ca70ce4df208/system.slice/puppet.service
           ├─13850 /opt/puppetlabs/puppet/bin/ruby /opt/puppetlabs/puppet/bin/puppe...
           └─13865 puppet agent: applying configuration

Feb 14 11:21:56 jump_host.stratos.xfusioncorp.com puppet-agent[13850]: Starting Pup...
Hint: Some lines were ellipsized, use -l to show in full.
root@jump_host /etc/puppetlabs/code/environments/production/manifests# 
```
Apply the configuration

```bash
root@jump_host /etc/puppetlabs/code/environments/production/manifests# puppet apply cluster.pp 
Notice: Compiled catalog for jump_host.stratos.xfusioncorp.com in environment production in 0.04 seconds
Notice: this node did not match any of the listed definitions
Notice: /Stage[main]/Main/Node[default]/Notify[this node did not match any of the listed definitions]/message: defined 'message' as 'this node did not match any of the listed definitions'
Notice: Applied catalog in 0.01 seconds
root@jump_host /etc/puppetlabs/code/environments/production/manifests# 
```

Switch to the app server 1, one of the puppet slave andrun puppet agent test

```bash
[root@stapp01 tony]#  sudo /opt/puppetlabs/bin/puppet agent --test
Info: Using configured environment 'production'
Info: Retrieving pluginfacts
Info: Retrieving plugin
Info: Retrieving locales
Info: Caching catalog for stapp01.stratos.xfusioncorp.com
Info: Applying configuration version '1676443817'
Notice: /Stage[main]/Ssh_node1/Ssh_authorized_key[tony@stapp01]/ensure: created
Notice: Applied catalog in 0.08 seconds
[root@stapp01 tony]# 
```