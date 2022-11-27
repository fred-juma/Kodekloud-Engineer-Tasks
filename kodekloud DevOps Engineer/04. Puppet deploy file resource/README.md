#### Instruction

The Puppet master and Puppet agent nodes have been set up by the Nautilus DevOps team so they can perform testing. In Stratos DC all app servers have been configured as Puppet agent nodes. Below are details about the testing scenario they want to proceed with.



Use Puppet file resource and perform the below given task:

Create a Puppet programming file *cluster.pp* under */etc/puppetlabs/code/environments/production/manifests* directory on master node i.e Jump Server.

Using */etc/puppetlabs/code/environments/production/manifests/cluster.pp* create a file *beta.txt* under */opt/itadmin* directory on App Server 3.

Notes: :- Please make sure to run the puppet agent test using sudo on agent nodes, otherwise you can face certificate issues. In that case you will have to clean the certificates first and then you will be able to run the puppet agent test.

:- Before clicking on the Check button please make sure to verify puppet server and puppet agent services are up and running on the respective servers, also please make sure to run puppet agent test to apply/test the changes manually first.

:- Please note that once lab is loaded, the puppet server service should start automatically on puppet master server, however it can take upto 2-3 minutes to start.


#### Solution

#### Check both the puppet master and slave's hosts file to ensure the master's hostname and IP Address entries are present
```bash
thor@jump_host ~$ cat /etc/hosts
127.0.0.1       localhost
::1     localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
172.16.238.10   stapp01.stratos.xfusioncorp.com
172.16.238.11   stapp02.stratos.xfusioncorp.com
172.16.238.12   stapp03.stratos.xfusioncorp.com
172.16.238.3    jump_host.stratos.xfusioncorp.com jump_host
172.16.239.4    jump_host.stratos.xfusioncorp.com jump_host
172.17.0.7      jump_host.stratos.xfusioncorp.com jump_host
172.16.238.3        puppet
thor@jump_host ~$ sudo su
```

#### Switch to root user on the puppet master

```bash
thor@jump_host ~$ sudo su

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for thor: 
```

#### Navigate to the manifests directory and create cluster.pp file and create the configurations as below
```bash
root@jump_host /home/thor# cd /etc/puppetlabs/code/environments/production/manifests

root@jump_host /etc/puppetlabs/code/environments/production/manifests# vi cluster.pp

class file_creator {

file {'/opt/itadmin/beta.txt':
  ensure => present,
  content => "It works on ${ipaddress_eth0}!\n"
  }
}
node 'stapp03.stratos.xfusioncorp.com' {

          include file_creator

        }

node default {
  notify { 'this node did not match any of the listed definitions': }
}
```

#### Check the puppet service status on the master. The puppet service is down, start the service before proceeding. Then test the puppet aganet
```bash
root@jump_host /etc/puppetlabs/code/environments/production/manifests# /opt/puppetlabs/bin/puppet agent --test
Info: Using configured environment 'production'
Info: Retrieving pluginfacts
Info: Retrieving plugin
Info: Retrieving locales
Info: Caching catalog for jump_host.stratos.xfusioncorp.com
Info: Applying configuration version '1669280424'
Notice: this node did not match any of the listed definitions
Notice: /Stage[main]/Main/Node[default]/Notify[this node did not match any of the listed definitions]/message: defined 'message' as 'this node did not match any of the listed definitions'
Notice: Applied catalog in 0.02 seconds
root@jump_host /etc/puppetlabs/code/environments/production/manifests# 
```


#### Apply the puppet configuration *cluster.pp* just created
```bash
root@jump_host /etc/puppetlabs/code/environments/production/manifests# puppet apply cluster.pp 
Notice: Compiled catalog for jump_host.stratos.xfusioncorp.com in environment production in 0.01 seconds
Notice: this node did not match any of the listed definitions
Notice: /Stage[main]/Main/Node[default]/Notify[this node did not match any of the listed definitions]/message: defined 'message' as 'this node did not match any of the listed definitions'
Notice: Applied catalog in 0.02 seconds
root@jump_host /etc/puppetlabs/code/environments/production/manifests# 
```

#### Switch to the app server 3, puppet slave
```bash

root@jump_host /etc/puppetlabs/code/environments/production/manifests# ssh banner@172.16.238.12
The authenticity of host '172.16.238.12 (172.16.238.12)' can't be established.
ECDSA key fingerprint is SHA256:53OlCztT+PXlUrUjJ/BLl8w/PiJ9oxsHB3z8ItXb0Ag.
ECDSA key fingerprint is MD5:27:ad:ca:cc:49:02:e2:14:ed:c2:f9:83:df:e3:ac:06.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '172.16.238.12' (ECDSA) to the list of known hosts.
banner@172.16.238.12's password: 
```

#### Run the puppet agent test command to pull and apply the confuguration set on the master
```bash
[banner@stapp03 ~]$ sudo puppet agent --test

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for banner: 
Info: Using configured environment 'production'
Info: Retrieving pluginfacts
Info: Retrieving plugin
Info: Retrieving locales
Info: Caching catalog for stapp03.stratos.xfusioncorp.com
Info: Applying configuration version '1669280517'
Notice: /Stage[main]/File_creator/File[/opt/itadmin/beta.txt]/ensure: defined content as '{md5}46e95f639f2c786b7f782b9b49e92be5'
Notice: Applied catalog in 0.09 seconds
[banner@stapp03 ~]$ 
```

#### Configuration change is successful and file created with specified contents as shown on the results above

***The End***