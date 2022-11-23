#### Instructions

While troubleshooting one of the issues on app servers in **Stratos Datacenter** DevOps team identified the root cause that the time isn't synchronized properly among the all app servers which causes issues sometimes. So team has decided to use a specific time server for all app servers, so that they all remain in sync. This task needs to be done using Puppet so as per details mentioned below please compete the task:



Create a puppet programming file *beta.pp* under */etc/puppetlabs/code/environments/production/manifests* directory on puppet master node i.e on **Jump Server**. Within the programming file define a custom class *ntpconfig* to install and configure ntp server on app server 1.

Add NTP Server server **1.sg.pool.ntp.org** in default configuration file on app server 1, also remember to use **iburst** option for faster synchronization at startup.

Please note that do not try to **start/restart/stop** ntp service, as we already have a scheduled restart for this service tonight and we don't want these changes to be applied right now.

Notes: :- Please make sure to run the puppet agent test using sudo on agent nodes, otherwise you can face certificate issues. In that case you will have to clean the certificates first and then you will be able to run the puppet agent test.

:- Before clicking on the Check button please make sure to verify puppet server and puppet agent services are up and running on the respective servers, also please make sure to run puppet agent test to apply/test the changes manually first.

:- Please note that once lab is loaded, the puppet server service should start automatically on puppet master server, however it can take upto 2-3 minutes to start.

### Solution

#### Ensure the hosts file on the puppet slave is properly configured with the puppet master's hostname and ip address
```bash
[tony@stapp01 ~]$ cat /etc/hosts
127.0.0.1       localhost
::1     localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
172.16.238.3    jump_host.stratos.xfusioncorp.com
172.16.238.10   stapp01.stratos.xfusioncorp.com stapp01
172.16.239.5    stapp01.stratos.xfusioncorp.com stapp01
172.17.0.4      stapp01.stratos.xfusioncorp.com stapp01
172.16.238.3 puppet
[tony@stapp01 ~]$ 
```

#### Ensure the hosts file on the puppet master is properly configured with the puppet master's hostname and ip address
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
172.16.239.2    jump_host.stratos.xfusioncorp.com jump_host
172.17.0.7      jump_host.stratos.xfusioncorp.com jump_host
172.16.238.3 puppet
thor@jump_host ~$ 
```
#####  On the puppet master, check if puppet modules are installed, from the result below, they are no modules installed.

```bash
puppet module list

thor@jump_host ~$ puppet module list
/opt/puppetlabs/puppet/modules (no modules installed)
```

#### Next we install the puppet modules

```bash
puppet module install puppetlabs-ntp

thor@jump_host ~$ puppet module install puppetlabs-ntp
Notice: Preparing to install into /home/thor/.puppetlabs/etc/code/modules ...
Notice: Created target directory /home/thor/.puppetlabs/etc/code/modules
Notice: Downloading from https://forgeapi.puppet.com ...
Notice: Installing -- do not interrupt ...
/home/thor/.puppetlabs/etc/code/modules
└─┬ puppetlabs-ntp (v9.2.0)
  └── puppetlabs-stdlib (v8.5.0)
thor@jump_host ~$ 
```

#### Now listing the modules displays all installed motdules

```bash
thor@jump_host ~$ puppet module list
/home/thor/.puppetlabs/etc/code/modules
├── puppetlabs-ntp (v9.2.0)
└── puppetlabs-stdlib (v8.5.0)
/opt/puppetlabs/puppet/modules (no modules installed)
thor@jump_host ~$ 
```


#### Check the status of puppet package on the puppet master 
```bash
thor@jump_host ~$ sudo systemctl status puppet
● puppet.service - Puppet agent
   Loaded: loaded (/usr/lib/systemd/system/puppet.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
thor@jump_host ~$ 
```

#### Since the service is not running, start it, then check to ensure it is up and runnning

```bash
thor@jump_host ~$ sudo systemctl start puppet
```

```bash
thor@jump_host ~$ sudo systemctl status puppet
● puppet.service - Puppet agent
   Loaded: loaded (/usr/lib/systemd/system/puppet.service; disabled; vendor preset: disabled)
   Active: active (running) since Mon 2022-11-21 17:34:04 UTC; 3s ago
 Main PID: 13814 (puppet)
    Tasks: 5
   CGroup: /docker/51d2a0c5d07ede307e17065a285c79581258407686fec0f4b76b50a34eebd948/system.slice/puppet.service
           ├─13814 /opt/puppetlabs/puppet/bin/ruby /opt/puppetlabs/puppet/bin/puppet agent --no-daemonize
           └─13829 puppet agent: applying configuration

Nov 21 17:34:07 jump_host.stratos.xfusioncorp.com puppet-agent[13814]: Starting Puppet client version 6.24.0
thor@jump_host ~$ 

thor@jump_host /etc/puppetlabs/code/environments/production/manifests$ sudo systemctl status puppetserver
● puppetserver.service - puppetserver Service
   Loaded: loaded (/usr/lib/systemd/system/puppetserver.service; disabled; vendor preset: disabled)
   Active: active (running) since Tue 2022-11-22 18:43:28 UTC; 8min ago
 Main PID: 13205 (java)
   CGroup: /docker/9ef9136e56e9a94f79eb75b5a33724584b13b2070e5634e4a97c60109bd8fe62/system.slice/puppetserver.service
           └─13205 /usr/bin/java -Xms512m -Xmx512m -Djruby.logger.class=com.puppetlabs.jruby_uti...
thor@jump_host /etc/puppetlabs/code/environments/production/manifests$ 
```


#### Check whether installation is working properly on the puppet master.
```bash
thor@jump_host ~$ sudo /opt/puppetlabs/bin/puppet agent --test
Info: Using configured environment 'production'
Info: Retrieving pluginfacts
Info: Retrieving plugin
Info: Retrieving locales
Info: Caching catalog for jump_host.stratos.xfusioncorp.com
Info: Applying configuration version '1669052163'
Notice: Applied catalog in 0.01 seconds
thor@jump_host ~$ 
```

#### Check whether installation is working properly on the puppet slave
```bash
[tony@stapp01 ~]$ sudo /opt/puppetlabs/bin/puppet agent --test
Info: Using configured environment 'production'
Info: Retrieving pluginfacts
Info: Retrieving plugin
Info: Retrieving locales
Info: Caching catalog for stapp01.stratos.xfusioncorp.com
Info: Applying configuration version '1669142870'
Notice: Applied catalog in 0.01 seconds
```

#### To test that the puppet master is properly configured, we can test with a configuration to be pushed to the client, the configuration echos clien'ts IP address. Create the configuration file *site.pp* and populate as below:

```bash
thor@jump_host ~$ /etc/puppetlabs/code/environments/production/manifests$ cat site.pp 
file {'/tmp/it_works.txt':
  ensure => present,
  mode => '0644',
  content => "It works on ${ipaddress_eth0}!\n"
  }
```

#### Run puppet apply on the master

```bash
thor@jump_host ~$ /etc/puppetlabs/code/environments/production/manifests$ sudo puppet apply site.pp 


```

#### Switch to the slave and ensure the puppet service is running
```bash

[tony@stapp01 ~]$ sudo systemctl status puppet

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for tony: 
● puppet.service - Puppet agent
   Loaded: loaded (/usr/lib/systemd/system/puppet.service; disabled; vendor preset: disabled)
   Active: active (running) since Mon 2022-11-21 17:28:49 UTC; 8min ago
 Main PID: 398 (puppet)
   CGroup: /docker/c4e64812ff009eae2036243164ebe55a4b5d620915d81f5360667c9eb8f86ae2/system.slice/puppet.service
           └─398 /opt/puppetlabs/puppet/bin/ruby /opt/puppetlabs/puppet/bin/puppet agent --no-daemonize

Nov 21 17:28:49 stapp01.stratos.xfusioncorp.com systemd[1]: puppet.service changed dead -> running
Nov 21 17:28:49 stapp01.stratos.xfusioncorp.com systemd[1]: Job puppet.service/start finished, result=done
Nov 21 17:28:49 stapp01.stratos.xfusioncorp.com systemd[1]: Started Puppet agent.
Nov 21 17:28:49 stapp01.stratos.xfusioncorp.com systemd[398]: Executing: /opt/puppetlabs/puppet/bin/puppet a...ize
Nov 21 17:29:04 stapp01.stratos.xfusioncorp.com puppet-agent[398]: Request to https://puppet:8140/puppet-ca/v...0)
Nov 21 17:29:04 stapp01.stratos.xfusioncorp.com puppet-agent[398]: Wrapped exception:
Nov 21 17:29:04 stapp01.stratos.xfusioncorp.com puppet-agent[398]: Failed to open TCP connection to puppet:81...0)
Nov 21 17:29:04 stapp01.stratos.xfusioncorp.com puppet-agent[398]: No more routes to ca
Nov 21 17:31:43 stapp01.stratos.xfusioncorp.com puppet-agent[398]: Starting Puppet client version 6.15.0
Nov 21 17:31:53 stapp01.stratos.xfusioncorp.com puppet-agent[462]: Applied catalog in 0.09 seconds
Hint: Some lines were ellipsized, use -l to show in full.
```

#### Run puppet agent test on the slave to pull the test configuration, the test config runs as expected
 
```bash

[tony@stapp01 ~]$ sudo puppet agent --test
[sudo] password for tony: 
Sorry, try again.
[sudo] password for tony: 
Info: Using configured environment 'production'
Info: Retrieving pluginfacts
Info: Retrieving plugin
Info: Retrieving locales
Info: Caching catalog for stapp01.stratos.xfusioncorp.com
Info: Applying configuration version '1669053595'
Notice: /Stage[main]/Main/File[/tmp/it_works.txt]/ensure: defined content as '{md5}3b12c1cd6dae29638fad1291b132dbec'
Notice: Applied catalog in 0.02 seconds
[tony@stapp01 ~]$ 
```

#### Headback to master and create the puppet programming file *beta.pp* with contents as shown below

```bash
thor@jump_host ~$ /etc/puppetlabs/code/environments/production/manifests$ sudo vi beta.pp

class { 'ntp':
servers => [ '1.sg.pool.ntp.org' ],
}
class ntpconfig {
include ntp
}

node 'jump_host.stratos.xfusioncorp.com','stapp01.stratos.xfusioncorp.com','stapp02.stratos.xfusioncorp.com','stapp03.stratos.xfusioncorp.com' {
include ntpconfig
}

```
### Run puppet apply on the master

```bash
thor@jump_host ~$ /etc/puppetlabs/code/environments/production/manifests$ sudo puppet apply beta.pp 


```

#### Head back to the client and check the status of the ntp service. Notice the service is stopped

```bash

[tony@stapp01 ~]$ puppet resource service ntpd
service { 'ntpd':
  ensure   => 'stopped',
  enable   => 'false',
  provider => 'systemd',
}
[tony@stapp01 ~]$ 
```


#### Run puppet agent test to pull the configurations to the slave

```bash

[tony@stapp01 ~]$ sudo puppet agent --test
Info: Using configured environment 'production'
Info: Retrieving pluginfacts
Info: Retrieving plugin
Notice: /File[/opt/puppetla
......
.......
Info: Computing checksum on file /etc/ntp.conf
Info: /Stage[main]/Ntp::Config/File[/etc/ntp.conf]: Filebucketed /etc/ntp.conf to puppet with sum dc9e5754ad2bb6f6c32b954c04431d0a
Notice: /Stage[main]/Ntp::Config/File[/etc/ntp.conf]/content: content changed '{md5}dc9e5754ad2bb6f6c32b954c04431d0a' to '{md5}d53e0ce4bd75ef0b60a220b049f791b9'
Notice: /Stage[main]/Ntp::Config/File[/etc/ntp/step-tickers]/content: 
--- /etc/ntp/step-tickers       2019-11-27 16:47:41.000000000 +0000
+++ /tmp/puppet-file20221123-539-1dhj26k        2022-11-23 07:26:50.321417075 +0000
@@ -1,3 +1,3 @@
 # List of NTP servers used by the ntpdate service.
 
-0.centos.pool.ntp.org
+server 3.pool.ntp.org iburst

Info: Computing checksum on file /etc/ntp/step-tickers
Info: /Stage[main]/Ntp::Config/File[/etc/ntp/step-tickers]: Filebucketed /etc/ntp/step-tickers to puppet with sum 9b77b3b3eb41daf0b9abb8ed01c5499b
Notice: /Stage[main]/Ntp::Config/File[/etc/ntp/step-tickers]/content: content changed '{md5}9b77b3b3eb41daf0b9abb8ed01c5499b' to '{md5}b60c19dc48f2d5143e987661da2598ec'
Info: Class[Ntp::Config]: Scheduling refresh of Class[Ntp::Service]
Info: Class[Ntp::Service]: Scheduling refresh of Service[ntp]
Notice: /Stage[main]/Ntp::Service/Service[ntp]/ensure: ensure changed 'stopped' to 'running'
Info: /Stage[main]/Ntp::Service/Service[ntp]: Unscheduling refresh on Service[ntp]
Notice: /Stage[main]/Main/File[/tmp/it_works.txt]/ensure: defined content as '{md5}3b12c1cd6dae29638fad1291b132dbec'
Notice: Applied catalog in 18.39 seconds
[tony@stapp01 ~]$ 

```

***The End***








