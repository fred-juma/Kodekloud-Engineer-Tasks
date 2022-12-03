#### Scenario

The Nautilus DevOps team has started testing their Ansible playbooks on different servers within the stack. They have placed some playbooks under **/home/thor/playbook/** directory on jump host which they want to test. Some of these playbooks have already been tested on different servers, but now they want to test them on app server 2 in Stratos DC. However, they first need to create an inventory file so that Ansible can connect to the respective app. Below are some requirements:



a. Create an ini type Ansible inventory file **/home/thor/playbook/inventory** on jump host.

b. Add **App Server 3** in this inventory along with required variables that are needed to make it work.

c. The inventory hostname of the host should be the server name as per the wiki, for example **stapp01** for app server 1 in Stratos DC.

Note: Validation will try to run the playbook using command ansible-playbook -i inventory playbook.yml so please make sure the playbook works this way without passing any extra arguments.



#### Solution

Confirm hosts file entries inclusion of app server 1

```bash
thor@jump_host ~$ cat /etc/hosts
127.0.0.1       localhost
::1     localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
172.16.238.10   stapp01
172.16.238.11   stapp02
172.16.238.12   stapp03
172.16.238.3    jump_host.stratos.xfusioncorp.com jump_host
172.16.239.5    jump_host.stratos.xfusioncorp.com jump_host
172.17.0.4      jump_host.stratos.xfusioncorp.com jump_host
```

Navigate into the *playbook* directory and list contents

```bash
thor@jump_host ~$ cd playbook/

thor@jump_host ~/playbook$ ls -l
total 12
-rw-r--r-- 1 thor thor  36 Dec  2 17:17 ansible.cfg
-rw-rw-r-- 1 thor thor 120 Dec  2 17:23 inventory
-rw-r--r-- 1 thor thor 250 Dec  2 17:17 playbook.yml
```


thor@jump_host ~/playbook$ cat ansible.cfg 
[defaults]
host_key_checking = Falsethor@jump_host ~/playbook$ 

View the playbook manifest definition file

```bash
thor@jump_host ~$ cat playbook/playbook.yml 
---
- hosts: all
  become: yes
  become_user: root
  tasks:
    - name: Install httpd package    
      yum: 
        name: httpd 
        state: installed
    
    - name: Start service httpd
      service:
        name: httpd
        state: startedthor@jump_host ~$ cd playbook/
```

The ansible host uses ssh to connect to the client nodes, now you got to setup *SSH* authentication between the host and the clients.

Generate *SSH* key-pair in the ansible host
```bash
thor@jump_host ~$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/thor/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/thor/.ssh/id_rsa.
Your public key has been saved in /home/thor/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:GDiJ84ebBrs42Dcoylo0kOgsMd49qtaB336Duh2nGic thor@jump_host.stratos.xfusioncorp.com
The key's randomart image is:
+---[RSA 2048]----+
|                 |
|.. . o           |
|* o + .          |
|++.o.o o         |
|.+=.ooo S        |
|.o =.+.          |
|..=E*o..         |
|=++=Bo+o         |
|B=.===. .        |
+----[SHA256]-----+
thor@jump_host ~$ ls -l /home/thor/.ssh/
total 12
-rw------- 1 thor thor  567 Dec  2 18:33 authorized_keys
-rw------- 1 thor thor 1679 Dec  2 18:34 id_rsa
-rw-r--r-- 1 thor thor  420 Dec  2 18:34 id_rsa.pub
```

Copy the public key generated to the ansible client node

```bash
thor@jump_host ~/playbook$ ssh-copy-id -i ~/.ssh/id_rsa.pub banner@172.16.238.12
/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/thor/.ssh/id_rsa.pub"
The authenticity of host '172.16.238.12 (172.16.238.12)' can't be established.
ECDSA key fingerprint is SHA256:IzlRDolLlDT7Iah3say6o6DT7gPiO7dzMbn4+L9FYpI.
ECDSA key fingerprint is MD5:ae:93:a9:97:1f:d0:06:89:7f:5f:35:b7:dc:06:11:0e.
Are you sure you want to continue connecting (yes/no)? yes
/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
banner@172.16.238.12's password: 
Permission denied, please try again.
banner@172.16.238.12's password: 
Permission denied, please try again.
banner@172.16.238.12's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'banner@172.16.238.12'"
and check to make sure that only the key(s) you wanted were added.

thor@jump_host ~/playbook$ 
```

Confirm that you can *SSH* to the client without password

```bash
thor@jump_host ~$ ssh banner@172.16.238.12
[tony@stapp01 ~]$ exit
logout
Connection to 172.16.238.10 closed.
thor@jump_host ~$ 
```

Add the private key to ssh keyring

```bash
thor@jump_host ~/playbook$ eval "$(ssh-agent -s)"
Agent pid 744
thor@jump_host ~/playbook$ ssh-add ~/.ssh/id_rsa
Identity added: /home/thor/.ssh/id_rsa (/home/thor/.ssh/id_rsa)
thor@jump_host ~/playbook$ 
````


Now create the *inventory* file and add content as listed below

```bash
thor@jump_host ~/playbook$ cat inventory 
stapp01 ansible_host=172.16.238.12  ansible_user=banner  ansible_ssh_private_key_file=/home/thor/.ssh/id_rsa
thor@jump_host ~/playbook$ 
```



Run the playbook to deploy the resources on the client node
```bash
thor@jump_host ~/playbook$ ansible-playbook -i inventory playbook.yml

PLAY [all] ********************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************
ok: [stapp03]

TASK [Install httpd package] **************************************************************************************************************************************************
changed: [stapp03]

TASK [Start service httpd] ****************************************************************************************************************************************************
changed: [stapp03]

PLAY RECAP ********************************************************************************************************************************************************************
stapp03                    : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

thor@jump_host ~/playbook$ 
```

You can use option *-vvv* for verbose output

```bash
thor@jump_host ~/playbook$ ansible-playbook -vvv -i inventory playbook.yml
```

***The End***