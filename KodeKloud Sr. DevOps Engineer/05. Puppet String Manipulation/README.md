#### Task

There is some data on App Server 2 in Stratos DC. The Nautilus development team shared some requirement with the DevOps team to alter some of the data as per recent changes. The DevOps team is working to prepare a Puppet programming file to accomplish this. Below you can find more details about the task.



Create a Puppet programming file blog.pp under /etc/puppetlabs/code/environments/production/manifests directory on Puppet master node i.e Jump Server and by using puppet file_line resource perform the following tasks.

We have a file /opt/data/blog.txt on App Server 2. Use the Puppet programming file mentioned above to replace line Welcome to Nautilus Industries! to Welcome to xFusionCorp Industries!, no other data should be altered in this file.
Notes: :- Please make sure to run the puppet agent test using sudo on agent nodes, otherwise you can face certificate issues. In that case you will have to clean the certificates first and then you will be able to run the puppet agent test.

:- Before clicking on the Check button please make sure to verify puppet server and puppet agent services are up and running on the respective servers, also please make sure to run puppet agent test to apply/test the changes manually first.

:- Please note that once lab is loaded, the puppet server service should start automatically on puppet master server, however it can take upto 2-3 minutes to start.



#### Solution

Switch to root user on the jump host

```bash

thor@jump_host ~$ sudo su

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for thor: 
```

Create puppet manifest'blog.pp' and populate it with the code to perform string replacement

```bash
root@jump_host /home/thor# cd /etc/puppetlabs/code/environments/production/manifests
root@jump_host /etc/puppetlabs/code/environments/production/manifests# vi blog.pp


class string_manipulator {
  file_line { 'line_replace':
  path => '/opt/data/blog.txt',
  match => 'Welcome to Nautilus Industries!',
  line => 'Welcome to xFusionCorp Industries!',
 }
}

node 'stapp02.stratos.xfusioncorp.com' {
  include string_manipulator
```

Validate for errors the syntax of the puppet manifest file created 'blog.pp'

```bash

root@jump_host /etc/puppetlabs/code/environments/production/manifests# puppet parser validate blog.pp 
root@jump_host /etc/puppetlabs/code/environments/production/manifests# 
```

SSH to application server 2

```bash

thor@jump_host ~$ ssh steve@stapp02
The authenticity of host 'stapp02 (172.16.238.11)' can't be established.
ECDSA key fingerprint is SHA256:+4rGR6Hic1Qy+uS/3hiveH8ymWA7I73kd8ocTsLbBsY.
ECDSA key fingerprint is MD5:64:e1:89:10:a1:12:50:91:e5:0d:cb:7d:0d:ef:6c:d6.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'stapp02,172.16.238.11' (ECDSA) to the list of known hosts.
steve@stapp02's password: 
```

View the original content of the file to be manipulated

```bash
[steve@stapp02 ~]$ cat /opt/data/blog.txt
This is  Nautilus sample file, created using Puppet!
Welcome to Nautilus Industries!
Please do not modify this file manually!
[steve@stapp02 ~]$ 
```

Apply the puppet manifest created in the jump host

```bash
[root@stapp02 steve]# puppet agent -tv
Info: Using configured environment 'production'
Info: Retrieving pluginfacts
Info: Retrieving plugin
Info: Retrieving locales
Info: Loading facts
Info: Caching catalog for stapp02.stratos.xfusioncorp.com
Info: Applying configuration version '1686745802'
Notice: /Stage[main]/String_manipulator/File_line[line_replace]/ensure: created
Notice: Applied catalog in 0.17 seconds
```

View the content of the file after applying the manipulation

```bash
[root@stapp02 steve]# cat /opt/data/blog.txt
This is  Nautilus sample file, created using Puppet!
Welcome to xFusionCorp Industries!
Please do not modify this file manually!
[root@stapp02 steve]# 
```

***The End***


