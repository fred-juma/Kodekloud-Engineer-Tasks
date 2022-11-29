#### Instructions

The Nautilus DevOps team has set up a puppet master and an agent node in Stratos Datacenter. Puppet master is running on jump host itself (also note that Puppet master node is also running as Puppet CA server) and Puppet agent is running on App Server 3. Since it is a fresh set up, the team wants to sign certificates for puppet master as well as puppet agent nodes so that they can proceed with the next steps of set up. You can find more details about the task below:



Puppet server and agent nodes are already have required packages, but you may need to start puppetserver (on master) and puppet service on both nodes.

Assign and sign certificates for both master and agent node.

##### Solution

Switch to root user in the jump_host (puppet master)

```bash
thor@jump_host ~$ sudo su

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for thor: 
```

Check the puppet service status of the puppet master 

```bash
root@jump_host /home/thor# systemctl status puppet
● puppet.service - Puppet agent
   Loaded: loaded (/usr/lib/systemd/system/puppet.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
```

The service is not running, go ahead and start it and check status once more to ensure the service is up and running

```bash

root@jump_host /home/thor# systemctl start puppet
root@jump_host /home/thor# systemctl status puppet
● puppet.service - Puppet agent
   Loaded: loaded (/usr/lib/systemd/system/puppet.service; disabled; vendor preset: disabled)
   Active: active (running) since Mon 2022-11-28 15:48:04 UTC; 2s ago
 Main PID: 13727 (puppet)
    Tasks: 2
   CGroup: /docker/0aa46c43e50d60da416544d0e578e819e4e488f7e91ccab6870248e91e4a4d8a/system.slice/puppet.service
           └─13727 /opt/puppetlabs/puppet/bin/ruby /opt/puppetlabs/puppet/bin/puppet agent --no-daemonize

Nov 28 15:48:07 jump_host.stratos.xfusioncorp.com puppet-agent[13727]: Starting Puppet client version 6.24.0
root@jump_host /home/thor# systemctl status puppetserver
● puppetserver.service - puppetserver Service
   Loaded: loaded (/usr/lib/systemd/system/puppetserver.service; disabled; vendor preset: disabled)
   Active: active (running) since Mon 2022-11-28 15:45:58 UTC; 2min 16s ago
  Process: 13110 ExecStart=/opt/puppetlabs/server/apps/puppetserver/bin/puppetserver start (code=exited, status=0/SUCCESS)
 Main PID: 13173 (java)
    Tasks: 88 (limit: 4915)
   CGroup: /docker/0aa46c43e50d60da416544d0e578e819e4e488f7e91ccab6870248e91e4a4d8a/system.slice/puppetserver.service
           └─13173 /usr/bin/java -Xms512m -Xmx512m -Djruby.logger.class=com.puppetlabs.jruby_utils.jruby.Slf4jLogger -XX:OnOutOfMemoryError="kill -9 %p" -XX:ErrorFile=/var/...
root@jump_host /home/thor# 
```


Check the *hosts* file of the puppet master node to ensure the master IP address / hostname is configured

```bash
root@jump_host /home/thor# cat /etc/hosts
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
172.16.239.3    jump_host.stratos.xfusioncorp.com jump_host
172.17.0.5      jump_host.stratos.xfusioncorp.com jump_host
root@jump_host /home/thor# 
```

Add alias to the hosts file to resolve puppet master node

```bash
root@jump_host /home/thor# vi /etc/hosts

127.0.0.1       localhost
::1     localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
172.16.238.10   stapp01.stratos.xfusioncorp.com
172.16.238.11   stapp02.stratos.xfusioncorp.com
172.16.238.12   stapp03.stratos.xfusioncorp.com
172.16.238.3    jump_host.stratos.xfusioncorp.com jump_host puppet
172.16.239.3    jump_host.stratos.xfusioncorp.com jump_host puppet
172.17.0.5      jump_host.stratos.xfusioncorp.com jump_host
```                                                          

List the certificates installed in the puppet master

```bash
root@jump_host /home/thor# puppetserver ca list --all
Signed Certificates:
    964369dd618d.c.argo-prod-us-east1.internal       (SHA256)  8C:19:47:FD:59:97:CE:0C:1D:DF:52:92:A3:BA:41:22:F2:3D:95:D4:38:D9:EF:85:65:9A:7B:B5:59:D5:CA:E6  alt names: ["DNS:puppet", "DNS:964369dd618d.c.argo-prod-us-east1.internal"]    authorization extensions: [pp_cli_auth: true]
    jump_host.stratos.xfusioncorp.com                (SHA256)  AB:8F:EA:4B:DF:8F:68:CB:6D:20:95:4F:16:32:98:A3:F3:7C:2F:7E:5A:57:34:9E:6B:DD:95:19:13:DD:C7:55  alt names: ["DNS:puppet", "DNS:jump_host.stratos.xfusioncorp.com"]     authorization extensions: [pp_cli_auth: true]
root@jump_host /home/thor# 
```

Switch to root user on application server 3 and check the status of the puppet service

```bash
[root@stapp03 banner]# systemctl status puppet
● puppet.service - Puppet agent
   Loaded: loaded (/usr/lib/systemd/system/puppet.service; disabled; vendor preset: disabled)
   Active: active (running) since Mon 2022-11-28 15:43:49 UTC; 28min ago
 Main PID: 392 (puppet)
   CGroup: /docker/7af4e95afe1a7c6ef25e1496385c4a3e73fd78e1506381431e6cf36454ef19fc/system.slice/puppet.service
           └─392 /opt/puppetlabs/puppet/bin/ruby /opt/puppetlabs/puppet/bin/puppet agent --no-daemonize

Nov 28 16:02:08 stapp03.stratos.xfusioncorp.com puppet-agent[392]: execution expired
Nov 28 16:02:08 stapp03.stratos.xfusioncorp.com puppet-agent[392]: No more routes to ca
Nov 28 16:06:08 stapp03.stratos.xfusioncorp.com puppet-agent[392]: Request to https://puppet:8140/puppet-ca/v1 timed out connect operation after 120.001 seconds
Nov 28 16:06:08 stapp03.stratos.xfusioncorp.com puppet-agent[392]: Wrapped exception:
Nov 28 16:06:08 stapp03.stratos.xfusioncorp.com puppet-agent[392]: execution expired
Nov 28 16:06:08 stapp03.stratos.xfusioncorp.com puppet-agent[392]: No more routes to ca
Nov 28 16:10:08 stapp03.stratos.xfusioncorp.com puppet-agent[392]: Request to https://puppet:8140/puppet-ca/v1 timed out connect operation after 120.001 seconds
Nov 28 16:10:08 stapp03.stratos.xfusioncorp.com puppet-agent[392]: Wrapped exception:
Nov 28 16:10:08 stapp03.stratos.xfusioncorp.com puppet-agent[392]: execution expired
Nov 28 16:10:08 stapp03.stratos.xfusioncorp.com puppet-agent[392]: No more routes to ca
[root@stapp03 banner]# systemctl start puppet
[root@stapp03 banner]# systemctl restart puppet
[root@stapp03 banner]# systemctl status puppet
● puppet.service - Puppet agent
   Loaded: loaded (/usr/lib/systemd/system/puppet.service; disabled; vendor preset: disabled)
   Active: active (running) since Mon 2022-11-28 16:12:39 UTC; 3s ago
 Main PID: 499 (puppet)
   CGroup: /docker/7af4e95afe1a7c6ef25e1496385c4a3e73fd78e1506381431e6cf36454ef19fc/system.slice/puppet.service
           └─499 /opt/puppetlabs/puppet/bin/ruby /opt/puppetlabs/puppet/bin/puppet agent --no-daemonize

Nov 28 16:12:39 stapp03.stratos.xfusioncorp.com systemd[1]: puppet.service changed dead -> running
Nov 28 16:12:39 stapp03.stratos.xfusioncorp.com systemd[1]: Job puppet.service/start finished, result=done
Nov 28 16:12:39 stapp03.stratos.xfusioncorp.com systemd[1]: Started Puppet agent.
Nov 28 16:12:39 stapp03.stratos.xfusioncorp.com systemd[499]: Executing: /opt/puppetlabs/puppet/bin/puppet agent --no-daemonize
[root@stapp03 banner]# 
```

On the puppet master node, issue the command to sign all the certificates

```bash
root@jump_host /home/thor# puppetserver ca sign --all
Successfully signed certificate request for stapp03.stratos.xfusioncorp.com
root@jump_host /home/thor# 
```


Hop back to the puppet agent (application server 3) and issue the agent test command to apply the certificates

```bash
[root@stapp03 banner]# puppet agent -t
Info: Using configured environment 'production'
Info: Retrieving pluginfacts
Info: Retrieving plugin
Info: Retrieving locales
Info: Caching catalog for stapp03.stratos.xfusioncorp.com
Info: Applying configuration version '1669652223'
Notice: Applied catalog in 0.07 seconds
[root@stapp03 banner]# 
```













