#### Task

The Nautilus DevOps team had a meeting with development team last week to discuss about some new requirements for an application deployment. Team is working on to setup a mariadb database server on Nautilus DB Server in Stratos Datacenter. They want to setup the same using Puppet. Below you can find more details about the requirements:



Create a puppet programming file official.pp under /etc/puppetlabs/code/environments/production/manifests directory on puppet master node i.e on Jump Server. Define a class mysql_database in puppet programming code and perform below mentioned tasks:

Install package mariadb-server (whichever version is available by default in yum repo) on puppet agent node i.e on DB Server also start its service.

Create a database kodekloud_db4 , a database userkodekloud_pop and set passwordGyQkFRVNr3 for this new user also remember host should be localhost. Finally grant some usual permissions like select, update (or full) ect to this newly created user on newly created database.

Notes: :- Please make sure to run the puppet agent test using sudo on agent nodes, otherwise you can face certificate issues. In that case you will have to clean the certificates first and then you will be able to run the puppet agent test.

:- Before clicking on the Check button please make sure to verify puppet server and puppet agent services are up and running on the respective servers, also please make sure to run puppet agent test to apply/test the changes manually first.

:- Please note that once lab is loaded, the puppet server service should start automatically on puppet master server, however it can take upto 2-3 minutes to start.


#### Solution

Check the status of puppet package on the puppet master


thor@jump_host ~$ sudo systemctl status puppet
[sudo] password for thor: 
Sorry, try again.
[sudo] password for thor: 
● puppet.service - Puppet agent
   Loaded: loaded (/usr/lib/systemd/system/puppet.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
thor@jump_host ~$ 

Since the service is not running, start it, then check to ensure it is up and runnning

thor@jump_host ~$ sudo systemctl start puppet
thor@jump_host ~$ sudo systemctl status puppet
● puppet.service - Puppet agent
   Loaded: loaded (/usr/lib/systemd/system/puppet.service; disabled; vendor preset: disabled)
   Active: active (running) since Sat 2023-01-07 11:11:26 UTC; 2s ago
 Main PID: 13885 (puppet)
    Tasks: 5
   CGroup: /docker/aada0aa8e1c3f5dee40058b54e836b500fd1f16ba0855b2580568881c1cd757b/system.slice/puppet.service
           ├─13885 /opt/puppetlabs/puppet/bin/ruby /opt/puppetlabs/puppet/bin/puppet agent --no-daemonize
           └─13900 puppet agent: applying configuration

Jan 07 11:11:28 jump_host.stratos.xfusioncorp.com puppet-agent[13885]: Starting Puppet client version 6.24.0
thor@jump_host ~$ 


thor@jump_host /etc/puppetlabs/code/environments/production/manifests$ puppet parser validate official.pp
thor@jump_host /etc/puppetlabs/code/environments/production/manifests$ 

class mysql_database {
  package { 'mariadb-server':
    ensure => installed,
  }

  service { 'mariadb':
    ensure => running,
    enable => true,
  }

  # Create the database
  mysql::db { 'kodekloud_db4':
    user     => 'kodekloud_pop',
    password => 'GyQkFRVNr3',
    host     => 'localhost',
    grant    => ['ALL'],
  }
}

node 'stdb01.stratos.xfusioncorp.com' {
  include mysql_database
}
     

Check whether installation is working properly on the puppet master.

thor@jump_host ~$ sudo /opt/puppetlabs/bin/puppet agent --test
Info: Using configured environment 'production'
Info: Retrieving pluginfacts
Info: Retrieving plugin
Info: Retrieving locales
Info: Loading facts
Info: Caching catalog for jump_host.stratos.xfusioncorp.com
Info: Applying configuration version '1673089923'
Notice: Applied catalog in 0.05 seconds
thor@jump_host ~$ 


Check puppet status on the slave node

[peter@stdb01 ~]$ sudo systemctl status puppet
● puppet.service - Puppet agent
   Loaded: loaded (/usr/lib/systemd/system/puppet.service; disabled; vendor preset: disabled)
   Active: active (running) since Sat 2023-01-07 11:02:09 UTC; 12min ago
 Main PID: 497 (puppet)
   CGroup: /docker/7af75922e62820ab8a4c4eb5b5583c0707a68ced55319e8816713f320822a076/system.slice/puppet.service
           └─497 /opt/puppetlabs/puppet/bin/ruby /opt/puppetlabs/puppet/bin/puppet agent --no-daemonize

Jan 07 11:06:57 stdb01.stratos.xfusioncorp.com puppet-agent[528]: (/File[/opt/puppetlabs/puppet/cache/lib/puppet/type/mysql_datadir.rb]/ensure) defined content as '...3a652ac'
Jan 07 11:06:57 stdb01.stratos.xfusioncorp.com puppet-agent[528]: (/File[/opt/puppetlabs/puppet/cache/lib/puppet/type/mysql_grant.rb]/ensure) defined content as '{m...e50619f'
Jan 07 11:06:57 stdb01.stratos.xfusioncorp.com puppet-agent[528]: (/File[/opt/puppetlabs/puppet/cache/lib/puppet/type/mysql_login_path.rb]/ensure) defined content a...f1e9ec3'
Jan 07 11:06:57 stdb01.stratos.xfusioncorp.com puppet-agent[528]: (/File[/opt/puppetlabs/puppet/cache/lib/puppet/type/mysql_plugin.rb]/ensure) defined content as '{...aac1e72'
Jan 07 11:06:57 stdb01.stratos.xfusioncorp.com puppet-agent[528]: (/File[/opt/puppetlabs/puppet/cache/lib/puppet/type/mysql_user.rb]/ensure) defined content as '{md...55bd0aa'
Jan 07 11:06:57 stdb01.stratos.xfusioncorp.com puppet-agent[528]: (/File[/opt/puppetlabs/puppet/cache/lib/puppet_x]/ensure) created
Jan 07 11:06:57 stdb01.stratos.xfusioncorp.com puppet-agent[528]: (/File[/opt/puppetlabs/puppet/cache/lib/puppet_x/stdlib]/ensure) created
Jan 07 11:06:57 stdb01.stratos.xfusioncorp.com puppet-agent[528]: (/File[/opt/puppetlabs/puppet/cache/lib/puppet_x/stdlib.rb]/ensure) defined content as '{md5}a1adb...fea21c8'
Jan 07 11:06:57 stdb01.stratos.xfusioncorp.com puppet-agent[528]: (/File[/opt/puppetlabs/puppet/cache/lib/puppet_x/stdlib/toml_dumper.rb]/ensure) defined content as...8f9bcb8'
Jan 07 11:07:01 stdb01.stratos.xfusioncorp.com puppet-agent[528]: Applied catalog in 0.10 seconds
Hint: Some lines were ellipsized, use -l to show in full.
[peter@stdb01 ~]$ 


[peter@stdb01 ~]$ rpm -qa | grep mariadb
[peter@stdb01 ~]$ 


Check whether installation is working properly on the puppet slave

[peter@stdb01 ~]$ sudo su

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for peter: 
[root@stdb01 peter]#  rpm -qa | grep mariadb

[root@stdb01 peter]# puppet agent -tv
Info: Using configured environment 'production'
Info: Retrieving pluginfacts
Info: Retrieving plugin
Info: Retrieving locales
Info: Loading facts
Info: Caching catalog for stdb01.stratos.xfusioncorp.com
Info: Applying configuration version '1673094861'
Notice: /Stage[main]/Mysql_database/Package[mariadb-server]/ensure: created
Notice: /Stage[main]/Mysql_database/Service[mariadb]/ensure: ensure changed 'stopped' to 'running'
Info: /Stage[main]/Mysql_database/Service[mariadb]: Unscheduling refresh on Service[mariadb]
Notice: /Stage[main]/Mysql_database/Mysql::Db[kodekloud_db4]/Mysql_database[kodekloud_db4]/ensure: created
Notice: /Stage[main]/Mysql_database/Mysql::Db[kodekloud_db4]/Mysql_user[kodekloud_pop@localhost]/ensure: created
Notice: /Stage[main]/Mysql_database/Mysql::Db[kodekloud_db4]/Mysql_grant[kodekloud_pop@localhost/kodekloud_db4.*]/ensure: created
Notice: Applied catalog in 33.02 seconds
[root@stdb01 peter]# 



[root@stdb01 peter]#  rpm -qa | grep mariadb
mariadb-server-5.5.68-1.el7.x86_64
mariadb-libs-5.5.68-1.el7.x86_64
mariadb-5.5.68-1.el7.x86_64
[root@stdb01 peter]# 




[root@stdb01 peter]# systemctl status mariadb
● mariadb.service - MariaDB database server
   Loaded: loaded (/usr/lib/systemd/system/mariadb.service; enabled; vendor preset: disabled)
   Active: active (running) since Sat 2023-01-07 12:35:07 UTC; 1min 25s ago
 Main PID: 1455 (mysqld_safe)
   CGroup: /docker/3624a75f6f13954180efb30c6b1c185f5546e13ccf9bdebb2d10f754ded14db8/system.slice/mariadb.service
           ├─1455 /bin/sh /usr/bin/mysqld_safe --basedir=/usr
           └─1619 /usr/libexec/mysqld --basedir=/usr --datadir=/var/lib/mysql --...

Jan 07 12:35:05 stdb01.stratos.xfusioncorp.com systemd[1455]: Executing: /usr/bi...
Jan 07 12:35:05 stdb01.stratos.xfusioncorp.com systemd[1456]: Executing: /usr/li...
Jan 07 12:35:05 stdb01.stratos.xfusioncorp.com mysqld_safe[1455]: 230107 12:35:0...
Jan 07 12:35:05 stdb01.stratos.xfusioncorp.com mysqld_safe[1455]: 230107 12:35:0...
Jan 07 12:35:07 stdb01.stratos.xfusioncorp.com systemd[1]: Child 1456 belongs to...
Jan 07 12:35:07 stdb01.stratos.xfusioncorp.com systemd[1]: mariadb.service: cont...
Jan 07 12:35:07 stdb01.stratos.xfusioncorp.com systemd[1]: mariadb.service got f...
Jan 07 12:35:07 stdb01.stratos.xfusioncorp.com systemd[1]: mariadb.service chang...
Jan 07 12:35:07 stdb01.stratos.xfusioncorp.com systemd[1]: Job mariadb.service/s...
Jan 07 12:35:07 stdb01.stratos.xfusioncorp.com systemd[1]: Started MariaDB datab...
Hint: Some lines were ellipsized, use -l to show in full.
[root@stdb01 peter]# 



[root@stdb01 peter]# mysql -u kodekloud_pop -p kodekloud_db4 -h localhost
Enter password: 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 29
Server version: 5.5.68-MariaDB MariaDB Server

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [kodekloud_db4]> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| kodekloud_db4      |
| test               |
+--------------------+
3 rows in set (0.00 sec)

MariaDB [kodekloud_db4]> 


