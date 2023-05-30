#### Task

The Nautilus DevOps team wants to install and set up a simple httpd web server on all app servers in Stratos DC. Additionally, they want to deploy a sample web page for now using Ansible only. Therefore, write the required playbook to complete this task. Find more details about the task below.



We already have an inventory file under /home/thor/ansible directory on jump host. Create a playbook.yml under /home/thor/ansible directory on jump host itself.

Using the playbook, install httpd web server on all app servers. Additionally, make sure its service should up and running.

Using blockinfile Ansible module add some content in /var/www/html/index.html file. Below is the content:

Welcome to XfusionCorp!

This is Nautilus sample file, created using Ansible!

Please do not modify this file manually!

The /var/www/html/index.html file's user and group owner should be apache on all app servers.

The /var/www/html/index.html file's permissions should be 0644 on all app servers.

Note:

i. Validation will try to run the playbook using command ansible-playbook -i inventory playbook.yml so please make sure the playbook works this way without passing any extra arguments.

ii. Do not use any custom or empty marker for blockinfile module.

#### Solution

Check the inventory file

```bash

thor@jump_host ~$ cd /home/thor/ansible
thor@jump_host ~/ansible$ ls -l
total 8
-rw-r--r-- 1 thor thor  36 May 30 07:05 ansible.cfg
-rw-r--r-- 1 thor thor 237 May 30 07:05 inventory
thor@jump_host ~/ansible$ cat inventory 
stapp01 ansible_host=172.16.238.10 ansible_ssh_pass=Ir0nM@n ansible_user=tony
stapp02 ansible_host=172.16.238.11 ansible_ssh_pass=Am3ric@ ansible_user=steve
stapp03 ansible_host=172.16.238.12 ansible_ssh_pass=BigGr33n ansible_user=bannerthor@jump_host ~/ansible$ 

```


Test ansible Connection to all app servers

```bash
thor@jump_host ~/ansible$ ansible -m ping all -i inventory
stapp02 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    }, 
    "changed": false, 
    "ping": "pong"
}
stapp03 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    }, 
    "changed": false, 
    "ping": "pong"
}
stapp01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    }, 
    "changed": false, 
    "ping": "pong"
}
thor@jump_host ~/ansible$ 

```

Create playbook.yaml


```bash

thor@jump_host ~/ansible$ touch playbook.yml


- name: Install httpd and setup index.html
  hosts: stapp01, stapp02, stapp03
  become: yes
  tasks:

     - name: Install httpd
       package:
         name: httpd
         state: present

     - name: Start service httpd, if not started
       service:
         name: httpd
         state: started

     - name: Add content block in index.html and set permissions
       blockinfile:
         path: /var/www/html/index.html
         create: yes
         owner: apache
         group: apache
         mode: "0744"
         block: |
           Welcome to XfusionCorp!
           This is Nautilus sample file, created using Ansible!
           Please do not modify this file manually!
```
Run the playbook

```bash
thor@jump_host ~/ansible$ ansible-playbook -i inventory playbook.yml

PLAY [Install httpd and setup index.html] *************************************************************

TASK [Gathering Facts] ********************************************************************************
ok: [stapp02]
ok: [stapp01]
ok: [stapp03]

TASK [Install httpd] **********************************************************************************
changed: [stapp03]
changed: [stapp01]
changed: [stapp02]

TASK [Start service httpd, if not started] ************************************************************
changed: [stapp02]
changed: [stapp03]
changed: [stapp01]

TASK [Add content block in index.html and set permissions] ********************************************
changed: [stapp03]
changed: [stapp02]
changed: [stapp01]

PLAY RECAP ********************************************************************************************
stapp01                    : ok=4    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
stapp02                    : ok=4    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
stapp03                    : ok=4    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

thor@jump_host ~/ansible$ 
```

Confirm httpd is installed on the 3 app servers by checking the httpd version in all the servers

```bash
thor@jump_host ~/ansible$ ansible -i inventory all -m shell -a "rpm -qa | grep -e httpd" 

[WARNING]: Consider using the yum, dnf or zypper module rather than running 'rpm'.  If you need to use
command because yum, dnf or zypper is insufficient you can add 'warn: false' to this command task or
set 'command_warnings=False' in ansible.cfg to get rid of this message.
stapp03 | CHANGED | rc=0 >>
httpd-tools-2.4.6-98.el7.centos.7.x86_64
httpd-2.4.6-98.el7.centos.7.x86_64
stapp02 | CHANGED | rc=0 >>
httpd-tools-2.4.6-98.el7.centos.7.x86_64
httpd-2.4.6-98.el7.centos.7.x86_64
stapp01 | CHANGED | rc=0 >>
httpd-tools-2.4.6-98.el7.centos.7.x86_64
httpd-2.4.6-98.el7.centos.7.x86_64
thor@jump_host ~/ansible$ 
```


Check if the httpd service is running in each of the 3 app servers

```bash
thor@jump_host ~/ansible$ ansible -i inventory all -m shell -a "sudo systemctl status httpd"
[WARNING]: Consider using 'become', 'become_method', and 'become_user' rather than running sudo
stapp01 | CHANGED | rc=0 >>
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; disabled; vendor preset: disabled)
   Active: active (running) since Tue 2023-05-30 11:11:06 UTC; 2min 8s ago
     Docs: man:httpd(8)
           man:apachectl(8)
 Main PID: 920 (httpd)
   Status: "Total requests: 0; Current requests/sec: 0; Current traffic:   0 B/sec"
   CGroup: /docker/d1bda01fdef01972821ff60d2d01b4e3cf24adb6440b22892cc16991e248725f/system.slice/httpd.service
           ├─920 /usr/sbin/httpd -DFOREGROUND
           ├─921 /usr/sbin/httpd -DFOREGROUND
           ├─922 /usr/sbin/httpd -DFOREGROUND
           ├─923 /usr/sbin/httpd -DFOREGROUND
           ├─924 /usr/sbin/httpd -DFOREGROUND
           └─925 /usr/sbin/httpd -DFOREGROUND





stapp03 | CHANGED | rc=0 >>
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; disabled; vendor preset: disabled)
   Active: active (running) since Tue 2023-05-30 11:11:05 UTC; 2min 8s ago
     Docs: man:httpd(8)
           man:apachectl(8)
 Main PID: 996 (httpd)
   Status: "Total requests: 0; Current requests/sec: 0; Current traffic:   0 B/sec"
   CGroup: /docker/ba3b6ae789033dd8b78e5dc8225946e9fbe67b6b5910d26cc2004b6ab19873a3/system.slice/httpd.service
           ├─ 996 /usr/sbin/httpd -DFOREGROUND
           ├─ 997 /usr/sbin/httpd -DFOREGROUND
           ├─ 998 /usr/sbin/httpd -DFOREGROUND
           ├─ 999 /usr/sbin/httpd -DFOREGROUND
           ├─1000 /usr/sbin/httpd -DFOREGROUND
           └─1001 /usr/sbin/httpd -DFOREGROUND




stapp02 | CHANGED | rc=0 >>
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; disabled; vendor preset: disabled)
   Active: active (running) since Tue 2023-05-30 11:11:05 UTC; 2min 8s ago
     Docs: man:httpd(8)
           man:apachectl(8)
 Main PID: 947 (httpd)
   Status: "Total requests: 0; Current requests/sec: 0; Current traffic:   0 B/sec"
   CGroup: /docker/a5552ca3e0efb937b60bef52de30c2cd7952d682be100966729bab2dcd84d597/system.slice/httpd.service
           ├─947 /usr/sbin/httpd -DFOREGROUND
           ├─948 /usr/sbin/httpd -DFOREGROUND
           ├─949 /usr/sbin/httpd -DFOREGROUND
           ├─950 /usr/sbin/httpd -DFOREGROUND
           ├─951 /usr/sbin/httpd -DFOREGROUND
           └─952 /usr/sbin/httpd -DFOREGROUND


thor@jump_host ~/ansible$
```


***The End***

