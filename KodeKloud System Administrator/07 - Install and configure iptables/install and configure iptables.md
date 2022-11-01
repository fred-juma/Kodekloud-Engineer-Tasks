# Instructions

We have one of our websites up and running on our Nautilus infrastructure in **Stratos DC**. Our security team has raised a concern that right now *Apache’s* port i.e *8083* is open for all since there is no firewall installed on these hosts. So we have decided to add some security layer for these hosts and after discussions and recommendations we have come up with the following requirements:



Install *iptables* and all its dependencies on each app host.

Block incoming port *8083* on all apps for everyone except for *LBR* host.

Make sure the rules remain, even after system reboot.

### My Solution

#### This documentation is for configurations applied to app server 1. The same configurations should be applied to the rest of the other app servers.

#### SSH into app server 1.

```bash
thor@jump_host ~$ ssh tony@172.16.238.10
The authenticity of host '172.16.238.10 (172.16.238.10)' can't be established.
ECDSA key fingerprint is SHA256:SySamszyWhhLGFiybhGBqfrr8g55wS/3e37ZpBOvICs.
ECDSA key fingerprint is MD5:6d:31:18:2a:f9:07:f3:29:dd:0a:d3:1f:6e:04:0a:db.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '172.16.238.10' (ECDSA) to the list of known hosts.
tony@172.16.238.10's password: 
[tony@stapp01 ~]$ 
```

#### Switch to *root* user
```bash
[tony@stapp01 ~]$ sudo su

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for tony: 
[root@stapp01 tony]# 
```
#### Ensure that *firewalld* package is not installed, and if it is remove it before installing and configuring iptables. In our case the package is not installed.

```bash
[root@stapp01 tony]# rpm -qa | grep firewalld
[root@stapp01 tony]#
```

#### Check whether the *iptables* package and other dependencies, mainly *iptables-services* is installed.

```bash
[root@stapp01 tony]# rpm -qa | grep iptables
iptables-1.4.21-33.el7.x86_64
[root@stapp01 tony]# 

[root@stapp01 tony]# rpm -qa | grep iptables-services
[root@stapp01 tony]# 
```

#### We have *iptables* package already installed, however the *iptables-services* is not. Let's go ahead and install it in the following steps.
#### The *iptables-services* automate restoration of saved rules at reboot. Below is a snippet of the installation process. 

```bash
[root@stapp01 tony]# yum install iptables-services
Loaded plugins: fastestmirror, ovl
Determining fastest mirrors
epel/x86_64/metalink                                                                                                                            |  19 kB  00:00:00     
 * base: mirror.dal.nexril.net
 * epel: mirror.team-cymru.com
 * extras: ftp.ussg.iu.edu
 * remi-php72: mirror.team-cymru.com
 * remi-safe: mirror.team-cymru.com
 * updates: mirror.pit.teraswitch.com
```
#### Enable the service to persist reboots and then start it.

```bash
[root@stapp01 tony]# sudo systemctl enable iptables
Created symlink from /etc/systemd/system/basic.target.wants/iptables.service to /usr/lib/systemd/system/iptables.service.

[root@stapp01 tony]# sudo systemctl start iptables
```


#### *iptables* often come with some pre-configured rules, check the current *iptable* fileter table for such. This prints out the three chains for the default filter table, namely: *INPUT*, *OUTPUT* and *FORWARD*

#### In ourcase, as shown in the results below, there are no rules preconfigured in this particular server except the default policies. If there was some, you can flush them by issuing the command *iptables -F*

```bash
[root@stapp01 tony]# iptables -L 
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         
[root@stapp01 tony]# 

```

#### Flushing the iptables rules

```bash
[root@stapp03 banner]# iptables -F
[root@stapp03 banner]# 
```

#### Next, let us check the *ip address* for the *LBR* host. Confirmed as *172.16.238.14* as per the results below.

```bash
[root@stapp01 tony]# cat /etc/hosts
127.0.0.1       localhost
::1     localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
172.16.238.10   stapp01
172.16.238.11   stapp02
172.16.238.12   stapp03
172.16.238.14   stlb01
172.16.238.15   ststor01
172.16.238.10   stapp01.stratos.xfusioncorp.com stapp01
172.16.239.6    stapp01.stratos.xfusioncorp.com stapp01
172.17.0.6      stapp01.stratos.xfusioncorp.com stapp01
[root@stapp01 tony]# 
```

#### We now insert the first rule to the *INPUT* chain to *accept* connection from *LBR* host destined to the app server on port *8083*

```bash
[root@stapp01 tony]# iptables -I INPUT -p tcp --dport 8083 -s 172.16.238.14 -j ACCEPT
```

#### Next, append another rule to the *INPUT* chain to *drop* all other connections from anywhere to the app server port *8083*
```bash
[root@stapp01 tony]# iptables -A INPUT -p tcp --dport 8083 -s 0.0.0.0/0 -j DROP
```

#### Explanations of some of the options used with the iptables command:

+ **-I** - Inserts rule to the selected chain 
+ **-A** - Appends rule to the list of rules at the end of the selected chain.
+ **-p** - The protocol to check i.e. TCP/UDP/ICMP/all
+ **--dport** - The destination port 
+ **-s** - The source specification IP address/network/hostname
+ **-j** - This is the target of the rule and specifies what to do in the case of a match i.e. ACCEPT/REJECT/DROP/LOG

#### List all of the available chains in the filter table to confirm that the two entries specified have been added. 
```bash
[root@stapp01 tony]# iptables -L 
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
ACCEPT     tcp  --  stlb01               anywhere             tcp dpt:us-srv
DROP       tcp  --  anywhere             anywhere             tcp dpt:us-srv

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         
[root@stapp01 tony]# 
```

#### Save the changes made to the rule-set 

```bash
[root@stapp01 tony]# /sbin/iptables-save 
# Generated by iptables-save v1.4.21 on Mon Oct 31 14:05:46 2022
*filter
:INPUT ACCEPT [230:17972]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [152:17344]
-A INPUT -s 172.16.238.14/32 -p tcp -m tcp --dport 8083 -j ACCEPT
-A INPUT -p tcp -m tcp --dport 8083 -j DROP
COMMIT
# Completed on Mon Oct 31 14:05:46 2022
# Generated by iptables-save v1.4.21 on Mon Oct 31 14:05:46 2022
*nat
:PREROUTING ACCEPT [2:120]
:INPUT ACCEPT [2:120]
:OUTPUT ACCEPT [2:120]
:POSTROUTING ACCEPT [10:748]
:DOCKER_OUTPUT - [0:0]
:DOCKER_POSTROUTING - [0:0]
-A OUTPUT -d 127.0.0.11/32 -j DOCKER_OUTPUT
-A POSTROUTING -d 127.0.0.11/32 -j DOCKER_POSTROUTING
-A DOCKER_OUTPUT -d 127.0.0.11/32 -p tcp -m tcp --dport 53 -j DNAT --to-destination 127.0.0.11:45019
-A DOCKER_OUTPUT -d 127.0.0.11/32 -p udp -m udp --dport 53 -j DNAT --to-destination 127.0.0.11:54969
-A DOCKER_POSTROUTING -s 127.0.0.11/32 -p tcp -m tcp --sport 45019 -j SNAT --to-source :53
-A DOCKER_POSTROUTING -s 127.0.0.11/32 -p udp -m udp --sport 54969 -j SNAT --to-source :53
COMMIT
# Completed on Mon Oct 31 14:05:46 2022
[root@stapp01 tony]# 
```

#### Automate the restoration of the saved rules by reading the file at reboot 

```bash
[root@stapp01 tony]# sudo service iptables save
iptables: Saving firewall rules to /etc/sysconfig/iptables:[  OK  ]
[root@stapp01 tony]# 
```

***The End***