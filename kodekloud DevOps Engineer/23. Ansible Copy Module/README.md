#### Task

There is data on jump host that needs to be copied on all application servers in Stratos DC. Nautilus DevOps team want to perform this task using Ansible. Perform the task as per details mentioned below:



a. On jump host create an inventory file /home/thor/ansible/inventory and add all application servers as managed nodes.

b. On jump host create a playbook /home/thor/ansible/playbook.yml to copy /usr/src/dba/index.html file to all application servers at location /opt/dba.

Note: Validation will try to run the playbook using command ansible-playbook -i inventory playbook.yml so please make sure the playbook works this way without passing any extra arguments.

#### Solution

Create the inventory

```bash
thor@jump_host ~$ cd /home/thor/ansible/
thor@jump_host ~/ansible$ sudo vi inventory

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for thor: 
```

```yaml
[appservers]
172.16.238.10 ansible_user=tony ansible_password=<app1_password>
172.16.238.11 ansible_user=steve ansible_password=<app2_password>
172.16.238.12 ansible_user=banner ansible_password=<app3_password>
```

Test authentication of the ansible master to the client hosts

```bash

thor@jump_host ~/ansible$ ansible -m ping all -i inventory
172.16.238.11 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    }, 
    "changed": false, 
    "ping": "pong"
}
172.16.238.12 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    }, 
    "changed": false, 
    "ping": "pong"
}
172.16.238.10 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    }, 
    "changed": false, 
    "ping": "pong"
}
thor@jump_host ~/ansible$ 
```

Create the playbook

```bash
thor@jump_host ~/ansible$ sudo vi playbook.yml
```

```yaml
---
- name: Copy files from jumphost to all servers
  hosts: all
  become: yes 

  tasks:
  - name: Copy /usr/src/dba/index.html file to /opt/dba
    copy:
        src: /usr/src/dba/index.html
        dest: /opt/dba
```

Run the playbook to apply changes

```bash
thor@jump_host ~/ansible$ ansible-playbook -i inventory playbook.yml

PLAY [Copy files from jumphost to all servers] ***************************************************

TASK [Gathering Facts] ***************************************************************************
ok: [172.16.238.11]
ok: [172.16.238.12]
ok: [172.16.238.10]

TASK [Copy /usr/src/dba/index.html file to /opt/dba] *********************************************
changed: [172.16.238.12]
changed: [172.16.238.11]
changed: [172.16.238.10]

PLAY RECAP ***************************************************************************************
172.16.238.10              : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
172.16.238.11              : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
172.16.238.12              : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

thor@jump_host ~/ansible$ 
```

Confirm with server 1 that the file was copied successfully

```bash
thor@jump_host ~/ansible$ ssh tony@stapp01 ls -l /opt/dba/
The authenticity of host 'stapp01 (172.16.238.10)' can't be established.
ECDSA key fingerprint is SHA256:cY8skyQy8+I2asaNd9JvzzBNPhZ/AxW6CNnMn6ZbTqM.
ECDSA key fingerprint is MD5:1e:c6:82:84:a6:7c:ef:59:f3:e0:98:51:bd:7d:6a:77.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'stapp01' (ECDSA) to the list of known hosts.
tony@stapp01's password: 
total 4
-rw-r--r-- 1 root root 35 Jan 26 08:42 index.html
thor@jump_host ~/ansible$ 
```