#### Task

The Nautilus DevOps team had a discussion about, how they can train different team members to use Ansible for different automation tasks. There are numerous ways to perform a particular task using Ansible, but we want to utilize each aspect that Ansible offers. The team wants to utilise Ansible's conditionals to perform the following task:

An inventory file is already placed under /home/thor/ansible directory on jump host, with all the Stratos DC app servers included.

Create a playbook /home/thor/ansible/playbook.yml and make sure to use Ansible's when conditionals statements to perform the below given tasks.



Copy blog.txt file present under /usr/src/devops directory on jump host to App Server 1 under /opt/devops directory. Its user and group owner must be user tony and its permissions must be 0755 .

Copy story.txt file present under /usr/src/devops directory on jump host to App Server 2 under /opt/devops directory. Its user and group owner must be user steve and its permissions must be 0755 .

Copy media.txt file present under /usr/src/devops directory on jump host to App Server 3 under /opt/devops directory. Its user and group owner must be user banner and its permissions must be 0755 .

NOTE: You can use ansible_nodename variable from gathered facts with when condition. Additionally, please make sure you are running the play for all hosts i.e use - hosts: all.

Note: Validation will try to run the playbook using command ansible-playbook -i inventory playbook.yml, so please make sure the playbook works this way without passing any extra arguments.


#### Solution

Create the playbook yaml file

```bash

thor@jump_host ~$ sudo vi playbook.yaml

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.
```

Enter the commands provided in the yaml file

```yaml
---
- hosts: all
  become: yes
  gather_facts: true
  tasks:

  - name: Copy blog.txt from local to App Server 1
    copy:
      src: /usr/src/security/blog.txt
      dest: /opt/security/blog.txt
      remote_src: no
      owner: tony
      group: tony
      mode: 0755
    when: ansible_facts.hostname == "stapp01"

  - name: Copy story.txt from local to App Server 2
    copy:
      src: /usr/src/security/story.txt
      dest: /opt/security/story.txt
      remote_src: no
      owner: steve
      group: steve
      mode: 0755
    when: ansible_facts.hostname == "stapp02"
       
  - name: Copy media.txt from local to App Server 3
    copy:
      src: /usr/src/security/media.txt
      dest: /opt/security/media.txt
      remote_src: no
      owner: banner
      group: banner
      mode: 0755
    when: ansible_facts.hostname == "stapp03"
```

View the inventory file contents

```bash
thor@jump_host ~$ cat ansible/inventory 
stapp01 ansible_host=172.16.238.10 ansible_ssh_pass=***** ansible_user=tony
stapp02 ansible_host=172.16.238.11 ansible_ssh_pass=***** ansible_user=steve
stapp03 ansible_host=172.16.238.12 ansible_ssh_pass=***** ansible_user=bannerthor@jump_host ~$ 
```

For the configurations to be applied, we need to enble ssh passwordless authentication, for that execute the following steps

Generate private-public key pair on the jump host

```bash
thor@jump_host ~$ ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/home/thor/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/thor/.ssh/id_rsa.
Your public key has been saved in /home/thor/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:rx/VohDCiXNpmwu2BIn3+U8rQR/1u2ouHMXwMJIxBi0 thor@jump_host.stratos.xfusioncorp.com
The key's randomart image is:
+---[RSA 2048]----+
|    .o+o         |
| . .E++++ .      |
|. + o.B..B .     |
| . o =.+..+ ..   |
|    *.o.So  o..  |
|   o +..oo o..   |
|    . oo..+  .   |
|      .ooo...    |
|       .+=+.     |
+----[SHA256]-----+
```

Copy the public key from jump host to app server 1

```bash
thor@jump_host ~$ ssh-copy-id -i ~/.ssh/id_rsa.pub tony@stapp01
/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/thor/.ssh/id_rsa.pub"
The authenticity of host 'stapp01 (172.16.238.10)' can't be established.
ECDSA key fingerprint is SHA256:UMHmgUFpHyEtaqr/I61+SMxv8exP6orgHqGtTUyKxlY.
ECDSA key fingerprint is MD5:8b:f0:44:32:6f:b8:e1:82:50:91:4d:90:bd:8e:23:9d.
Are you sure you want to continue connecting (yes/no)? yes
/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
tony@stapp01's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'tony@stapp01'"
and check to make sure that only the key(s) you wanted were added.
```

Copy the public key from jump host to app server 2

```bash
thor@jump_host ~$ ssh-copy-id -i ~/.ssh/id_rsa.pub steve@stapp02
/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/thor/.ssh/id_rsa.pub"
The authenticity of host 'stapp02 (172.16.238.11)' can't be established.
ECDSA key fingerprint is SHA256:tpUyPapA+jH7shmKooSnykHZin6gXt6PgAwH7Q58LHU.
ECDSA key fingerprint is MD5:27:ba:dc:42:25:ed:b5:36:b3:fd:79:9d:e0:0d:e9:0f.
Are you sure you want to continue connecting (yes/no)? yes
/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
steve@stapp02's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'steve@stapp02'"
and check to make sure that only the key(s) you wanted were added.
```

Copy the public key from jump host to app server 3

```bash

thor@jump_host ~$ ssh-copy-id -i ~/.ssh/id_rsa.pub banner@stapp03
/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/thor/.ssh/id_rsa.pub"
The authenticity of host 'stapp03 (172.16.238.12)' can't be established.
ECDSA key fingerprint is SHA256:kHZE4Q42McAzbgD7nBSteDiP8FHTHzmZShuOa/sKB+E.
ECDSA key fingerprint is MD5:af:35:75:98:53:49:85:a9:76:69:b8:16:8a:05:fb:fd.
Are you sure you want to continue connecting (yes/no)? yes
/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
banner@stapp03's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'banner@stapp03'"
and check to make sure that only the key(s) you wanted were added.

thor@jump_host ~$
```

Test to confirm that now you can ssh to app servers without password

```bash
thor@jump_host ~$ ssh tony@stapp01
[tony@stapp01 ~]$ 
```

Apply the playbook to create the specified artifacts

```bash
thor@jump_host ~$ ansible-playbook -i /home/thor/ansible/inventory /home/thor/ansible/playbook.yml 

PLAY [all] **********************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************
ok: [stapp01]
ok: [stapp03]
ok: [stapp02]

TASK [Copy blog.txt from jump host to App Server 1] *****************************************************************************************************
skipping: [stapp02]
skipping: [stapp03]
changed: [stapp01]

TASK [Copy story.txt from jump host to App Server 2] ****************************************************************************************************
skipping: [stapp03]
skipping: [stapp01]
changed: [stapp02]

TASK [Copy media.txt from jump host to App Server 3] ****************************************************************************************************
skipping: [stapp01]
skipping: [stapp02]
changed: [stapp03]

PLAY RECAP **********************************************************************************************************************************************
stapp01                    : ok=2    changed=1    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   
stapp02                    : ok=2    changed=1    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   
stapp03                    : ok=2    changed=1    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   

thor@jump_host ~$ 
```


Confirm that the file was copied to app server 1

```bash
thor@jump_host ~$ ssh tony@stapp01 ls /opt/devops
blog.txt
thor@jump_host ~$ 
```

***End***

