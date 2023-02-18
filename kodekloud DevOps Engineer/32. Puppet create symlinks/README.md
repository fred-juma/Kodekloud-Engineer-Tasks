#### Task

Some directory structure in the Stratos Datacenter needs to be changed, there is a directory that needs to be linked to the default Apache document root. We need to accomplish this task using Puppet, as per the instructions given below:



Create a puppet programming file media.pp under /etc/puppetlabs/code/environments/production/manifests directory on puppet master node i.e on Jump Server. Within that define a class symlink and perform below mentioned tasks:

Create a symbolic link through puppet programming code. The source path should be /opt/sysops and destination path should be /var/www/html on Puppet agents 2 i.e on App Servers 2.

Create a blank file story.txt under /opt/sysops directory on puppet agent 2 nodes i.e on App Servers 2.

Notes: :- Please make sure to run the puppet agent test using sudo on agent nodes, otherwise you can face certificate issues. In that case you will have to clean the certificates first and then you will be able to run the puppet agent test.

:- Before clicking on the Check button please make sure to verify puppet server and puppet agent services are up and running on the respective servers, also please make sure to run puppet agent test to apply/test the changes manually first.

:- Please note that once lab is loaded, the puppet server service should start automatically on puppet master server, however it can take upto 2-3 minutes to start.


#### Solution

```bash
class symlink {
 

  file { '/opt/sysops':
    ensure => 'link',
    target => '/var/www/html',
  }
  
 
  file { '/opt/itadmin/story.txt':
    ensure => 'present',
  }
}

node 'stapp02.stratos.xfusioncorp.com' {

  include symlink
}

node default {
  notify { 'this node did not match any of the listed definitions': }
}
```

Check the status of the puppet service, and start the service

```bash
root@jump_host /etc/puppetlabs/code/environments/production/manifests# systemctl status puppet
● puppet.service - Puppet agent
   Loaded: loaded (/usr/lib/systemd/system/puppet.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
root@jump_host /etc/puppetlabs/code/environments/production/manifests# systemctl start puppet
root@jump_host /etc/puppetlabs/code/environments/production/manifests# systemctl status puppet
● puppet.service - Puppet agent
   Loaded: loaded (/usr/lib/systemd/system/puppet.service; disabled; vendor preset: disabled)
   Active: active (running) since Sat 2023-02-18 06:43:29 UTC; 2s ago
 Main PID: 14018 (puppet)
    Tasks: 4
   CGroup: /docker/c81f2c1f6283a8f0512cafdca1bf360de018af4cc6afde4fbad9ba097bc5a364/system.slice/puppet.service
           ├─14018 /opt/puppetlabs/puppet/bin/ruby /opt/puppetlabs/puppet/bin...
           └─14034 puppet agent: applying configuration

Feb 18 06:43:31 jump_host.stratos.xfusioncorp.com puppet-agent[14018]: Starti...
Hint: Some lines were ellipsized, use -l to show in full.
root@jump_host /etc/puppetlabs/code/environments/production/manifests# 
```

SSH to application server 2

```bash
thor@jump_host ~$ ssh steve@stapp02
The authenticity of host 'stapp02 (172.16.238.11)' can't be established.
ECDSA key fingerprint is SHA256:97SnKrFCquZhrQC8g3sMBjWgjfsC2RLlmAtKJyBAccs.
ECDSA key fingerprint is MD5:2c:df:86:44:6d:9d:95:45:43:8f:18:7b:f7:d5:0a:17.
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
```

Run the puppet agent test command to pull and apply the confuguration set on the master

```bash
[root@stapp02 steve]# puppet agent -tv
Info: Using configured environment 'production'
Info: Retrieving pluginfacts
Info: Retrieving plugin
Info: Retrieving locales
Info: Caching catalog for stapp02.stratos.xfusioncorp.com
Info: Applying configuration version '1676703673'
Notice: /Stage[main]/Symlink/File[/opt/sysops/story.txt]/ensure: created
Notice: Applied catalog in 0.01 seconds
[root@stapp02 steve]# 
```

***The End***