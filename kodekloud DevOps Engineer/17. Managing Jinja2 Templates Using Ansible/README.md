#### Task

One of the Nautilus DevOps team members is working on to develop a role for httpd installation and configuration. Work is almost completed, however there is a requirement to add a jinja2 template for index.html file. Additionally, the relevant task needs to be added inside the role. The inventory file ~/ansible/inventory is already present on jump host that can be used. Complete the task as per details mentioned below:



a. Update ~/ansible/playbook.yml playbook to run the httpd role on App Server 3.

b. Create a jinja2 template index.html.j2 under /home/thor/ansible/role/httpd/templates/ directory and add a line This file was created using Ansible on <respective server> (for example This file was created using Ansible on stapp01 in case of App Server 1). Also please make sure not to hard code the server name inside the template. Instead, use inventory_hostname variable to fetch the correct value.

c. Add a task inside /home/thor/ansible/role/httpd/tasks/main.yml to copy this template on App Server 3 under /var/www/html/index.html. Also make sure that /var/www/html/index.html file's permissions are 0755.

d. The user/group owner of /var/www/html/index.html file must be respective sudo user of the server (for example tony in case of stapp01).

Note: Validation will try to run the playbook using command ansible-playbook -i inventory playbook.yml so please make sure the playbook works this way without passing any extra arguments.

#### Solution

View the ansible inventory file

```bash
thor@jump_host ~$ cat ~/ansible/inventory
stapp01 ansible_host=172.16.238.10 ansible_user=tony ansible_ssh_pass=Ir0nM@n
stapp02 ansible_host=172.16.238.11 ansible_user=steve ansible_ssh_pass=Am3ric@
stapp03 ansible_host=172.16.238.12 ansible_user=banner ansible_ssh_pass=BigGr33nthor@jump_host ~$ 
```


Update the playbook to specify host as app server 3

```bash
thor@jump_host ~$ cat ~/ansible/playbook.yml
---
- name: Install httpd on app server3
  hosts: stapp03
  become: yes
  become_user: root
  roles:
    - role/httpd
```

Create the jinja template

```bash

thor@jump_host ~$ cd /home/thor/ansible/role/httpd/templates/

thor@jump_host ~/ansible/role/httpd/templates$ sudo vi index.html.j2
[sudo] password for thor: 

<html>
<head>
<title>Welcome to {{ inventory_hostname }}</title>
</head>
<body>
<h1>This file was created using Ansible on {{ inventory_hostname }}</h1>
</body>
</html>
```

Update the ansible playbook to copy the index file to app3 server and specify the source, destination, user, group and file permissions

```bash
thor@jump_host ~/ansible/role/httpd/templates$ sudo vi /home/thor/ansible/role/httpd/tasks/main.yml

---
# tasks file for role/test

- name: install the latest version of HTTPD
  yum:
    name: httpd
    state: latest

- name: Start service httpd
  service:
    name: httpd
    state: started

- name: Copy index.html.j2 template to /var/www/html/
  template:
    src: /home/thor/ansible/role/httpd/templates/index.html.j2
    dest: /var/www/html/index.html
    owner: "{{ ansible_user }}"
    group: "{{ ansible_user }}"
    mode: "0755"
```


Now run the playbook

```bash
thor@jump_host ~/ansible/role/httpd/templates$ ansible-playbook -i ~/ansible/inventory ~/ansible/playbook.yml

PLAY [Install httpd on app server3] *******************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************
ok: [stapp03]

TASK [role/httpd : install the latest version of HTTPD] ***********************************************************************************************************************
ok: [stapp03]

TASK [role/httpd : Start service httpd] ***************************************************************************************************************************************
ok: [stapp03]

TASK [role/httpd : Copy index.html.j2 template to /var/www/html/] *************************************************************************************************************
changed: [stapp03]

TASK [Start the httpd service] ************************************************************************************************************************************************
changed: [stapp03]

PLAY RECAP ********************************************************************************************************************************************************************
stapp03                    : ok=5    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

thor@jump_host ~/ansible/role/httpd/templates$ 
```

Now let us confirm that all the resources were created as specified

SSH to app server 3

```bash
thor@jump_host ~$ ssh banner@stapp03
The authenticity of host 'stapp03 (172.16.238.12)' can't be established.
ECDSA key fingerprint is SHA256:m0fmX4zCkUCEHs7DWQqPSDYtu8zISpPZNHWpFFhOWYM.
ECDSA key fingerprint is MD5:e4:b0:2f:b0:a0:8d:68:7b:6f:cd:c4:0c:e8:78:a3:d2.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'stapp03,172.16.238.12' (ECDSA) to the list of known hosts.
banner@stapp03's password: 
[banner@stapp03 ~]$ 
```

Check if the httpd service installed and running

```bash
[banner@stapp03 ~]$ systemctl status httpd
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; vendor preset: disabled)
   Active: active (running) since Sun 2023-01-15 06:16:08 UTC; 18min ago
     Docs: man:httpd(8)
           man:apachectl(8)
 Main PID: 987 (httpd)
   Status: "Total requests: 0; Current requests/sec: 0; Current traffic:   0 B/sec"
   CGroup: /docker/783bb241bdae1378482d39ffacac04721b425db81bb435e52eb07d67b2704cd7/system.slice/httpd.service
           ├─987 /usr/sbin/httpd -DFOREGROUND
           ├─988 /usr/sbin/httpd -DFOREGROUND
           ├─989 /usr/sbin/httpd -DFOREGROUND
           ├─990 /usr/sbin/httpd -DFOREGROUND
           ├─991 /usr/sbin/httpd -DFOREGROUND
           └─992 /usr/sbin/httpd -DFOREGROUND

Jan 15 06:34:18 stapp03.stratos.xfusioncorp.com systemd[1]: httpd.service: got READY=1
Jan 15 06:34:18 stapp03.stratos.xfusioncorp.com systemd[1]: httpd.service: got STATUS=Total requests: 0; Current requests/sec: 0; Current traffic:   0 B/sec
Jan 15 06:34:28 stapp03.stratos.xfusioncorp.com systemd[1]: Got notification message for unit httpd.service
Jan 15 06:34:28 stapp03.stratos.xfusioncorp.com systemd[1]: httpd.service: Got notification message from PID 987 (READY=1, STATUS=Total requests: 0; Current reques... 0 B/sec)
Jan 15 06:34:28 stapp03.stratos.xfusioncorp.com systemd[1]: httpd.service: got READY=1
Jan 15 06:34:28 stapp03.stratos.xfusioncorp.com systemd[1]: httpd.service: got STATUS=Total requests: 0; Current requests/sec: 0; Current traffic:   0 B/sec
Jan 15 06:34:38 stapp03.stratos.xfusioncorp.com systemd[1]: Got notification message for unit httpd.service
Jan 15 06:34:38 stapp03.stratos.xfusioncorp.com systemd[1]: httpd.service: Got notification message from PID 987 (READY=1, STATUS=Total requests: 0; Current reques... 0 B/sec)
Jan 15 06:34:38 stapp03.stratos.xfusioncorp.com systemd[1]: httpd.service: got READY=1
Jan 15 06:34:38 stapp03.stratos.xfusioncorp.com systemd[1]: httpd.service: got STATUS=Total requests: 0; Current requests/sec: 0; Current traffic:   0 B/sec
Hint: Some lines were ellipsized, use -l to show in full.
[banner@stapp03 ~]$ 
```

Confirm that the index file was create on the specified location


```bash
[banner@stapp03 ~]$ ls /var/www/html/
index.html
[banner@stapp03 ~]$ 
```

Confirm the contents of the index.html file is as specified

```html
[banner@stapp03 ~]$ cat /var/www/html/index.html 
<html>
<head>
<title>Welcome to stapp03</title>
</head>
<body>
<h1>This file was created using Ansible on stapp03</h1>
</body>
</html>
[banner@stapp03 ~]$ 
```

Finally curl the index file to see if httpd is able to serve the file


```bash

[banner@stapp03 ~]$ curl localhost
<html>
<head>
<title>Welcome to stapp03</title>
</head>
<body>
<h1>This file was created using Ansible on stapp03</h1>
</body>
</html>

[banner@stapp03 ~]$ 
```