#### Task

Several new developers and DevOps engineers just joined the xFusionCorp industries. They have been assigned the Nautilus project, and as per the onboarding process we need to create user accounts for new joinees on at least one of the app servers in Stratos DC. We also need to create groups and make new users members of those groups. We need to accomplish this task using Ansible. Below you can find more information about the task.



There is already an inventory file ~/playbooks/inventory on jump host.

On jump host itself there is a list of users in ~/playbooks/data/users.yml file and there are two groups — admins and developers —that have list of different users. Create a playbook ~/playbooks/add_users.yml on jump host to perform the following tasks on app server 3 in Stratos DC.

a. Add all users given in the users.yml file on app server 3.

b. Also add developers and admins groups on the same server.

c. As per the list given in the users.yml file, make each user member of the respective group they are listed under.

d. Make sure home directory for all of the users under developers group is /var/www (not the default i.e /var/www/{USER}). Users under admins group should use the default home directory (i.e /home/devid for user devid).

e. Set password Rc5C9EyvbU for all of the users under developers group and TmPcZjtRQx for of the users under admins group. Make sure to use the password given in the ~/playbooks/secrets/vault.txt file as Ansible vault password to encrypt the original password strings. You can use ~/playbooks/secrets/vault.txt file as a vault secret file while running the playbook (make necessary changes in ~/playbooks/ansible.cfg file).

f. All users under admins group must be added as sudo users. To do so, simply make them member of the wheel group as well.

Note: Validation will try to run the playbook using command ansible-playbook -i inventory add_users.yml so please make sure playbook works this way, without passing any extra arguments.

#### Solution

Check playbook inventory

```bash
thor@jump_host ~$ cat ~/playbooks/inventory
stapp01 ansible_host=172.16.238.10 ansible_ssh_pass=Ir0nM@n ansible_user=tony
stapp02 ansible_host=172.16.238.11 ansible_ssh_pass=Am3ric@ ansible_user=steve
stapp03 ansible_host=172.16.238.12 ansible_ssh_pass=BigGr33n ansible_user=bannerthor@jump_host ~$ 
```

check files in the playbook directory

```bash

thor@jump_host ~$ ls -l
total 4
drwxr-xr-x 4 thor thor 4096 May  2 07:26 playbooks
thor@jump_host ~$ cd playbooks/
thor@jump_host ~/playbooks$ ls -l
total 16
-rw-r--r-- 1 thor thor   36 May  2 07:25 ansible.cfg
drwxr-xr-x 2 thor thor 4096 May  2 07:04 data
-rw-r--r-- 1 thor thor  237 May  2 07:25 inventory
drwxr-xr-x 2 thor thor 4096 May  2 07:26 secrets
thor@jump_host ~/playbooks$ 
```

Check contents of users.yaml file

```bash
thor@jump_host ~$ vi ~/playbooks/data/users.yml

admins:
  - rob
  - david
  - joy

developers:
  - tim
  - ray
  - jim
  - mark
```

Create the yaml file add_users.yml

```bash
thor@jump_host ~/playbooks$ touch add_users.yml
thor@jump_host ~/playbooks$ 



---
- name: Ansbile Add User & Group
  hosts: stapp03                                                                                                
  become: yes                                                                                                    
  tasks:                                                                                                         
  - name: Creating Admin Groups                                                                                  
    group:                                                                                                       
     name:                                                                                                       
      admins                                                                                                     
     state: present                                                                                              
  - name: Creating Dev Groups                                                                                    
    group:                                                                                                       
     name:                                                                                                       
      developers                                                                                                 
     state: present                                                                                              
  - name: Creating Admins Group Users                                                                            
    user:                                                                                                        
     name: "{{ item }}"                                                                                          
     password: "{{ 'TmPcZjtRQx' | password_hash ('sha512') }}"                                                   
     groups: admins,wheel
     state: present                                                                                              
    loop:                                                                                                        
    - rob                                                                                                        
    - joy                                                                                                        
    - david                                                                                                      
  - name: Creating Developers Group Users                                                                        
    user:                                                                                                        
     name: "{{ item }}"                                                                                          
     password: "{{ 'Rc5C9EyvbU' | password_hash ('sha512') }}"                                                   
     home: "/var/www/{{ item }}"                                                                                             
     group: developers                                                                                           
     state: present                                                                                              
    loop:                                                                                                        
    - tim                                                                                                        
    - jim                                                                                                        
    - mark                                                                                                       
    - ray

```

Check the ansible.cfg file

```bash
thor@jump_host ~/playbooks$ vi ansible.cfg

[defaults]
host_key_checking = False
vault_password_file = /home/thor/playbooks/secrets/vault.txt
```


dry-run the playbook to check the effect

```bash
thor@jump_host ~/playbooks$ ansible-playbook -i inventory add_users.yml  --check

PLAY [Ansbile Add User & Group] ************************************************

TASK [Gathering Facts] *********************************************************
ok: [stapp03]

TASK [Creating Admin Groups] ***************************************************
changed: [stapp03]

TASK [Creating Dev Groups] *****************************************************
changed: [stapp03]

TASK [Creating Admins Group Users] *********************************************
changed: [stapp03] => (item=rob)
changed: [stapp03] => (item=joy)
changed: [stapp03] => (item=david)

TASK [Creating Developers Group Users] *****************************************
changed: [stapp03] => (item=tim)
changed: [stapp03] => (item=jim)
changed: [stapp03] => (item=mark)
changed: [stapp03] => (item=ray)

PLAY RECAP *********************************************************************
stapp03                    : ok=5    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

thor@jump_host ~/playbooks$ 

```

The playbook runs successfully without errors. Now you can run to apply the changes

```bash

thor@jump_host ~/playbooks$ ansible-playbook -i inventory add_users.yml  

PLAY [Ansbile Add User & Group] ************************************************

TASK [Gathering Facts] *********************************************************
ok: [stapp03]

TASK [Creating Admin Groups] ***************************************************
changed: [stapp03]

TASK [Creating Dev Groups] *****************************************************
changed: [stapp03]

TASK [Creating Admins Group Users] *********************************************
changed: [stapp03] => (item=rob)
changed: [stapp03] => (item=joy)
changed: [stapp03] => (item=david)

TASK [Creating Developers Group Users] *****************************************
changed: [stapp03] => (item=tim)
changed: [stapp03] => (item=jim)
changed: [stapp03] => (item=mark)
changed: [stapp03] => (item=ray)

PLAY RECAP *********************************************************************
stapp03                    : ok=5    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

thor@jump_host ~/playbooks$ 
```


Verify the users were created

```bash

thor@jump_host ~/playbooks$ ansible stapp03 -a "cat /etc/passwd" -i inventory 
stapp03 | CHANGED | rc=0 >>
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
sync:x:5:0:sync:/sbin:/bin/sync
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
halt:x:7:0:halt:/sbin:/sbin/halt
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
operator:x:11:0:operator:/root:/sbin/nologin
games:x:12:100:games:/usr/games:/sbin/nologin
ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
nobody:x:99:99:Nobody:/:/sbin/nologin
systemd-network:x:192:192:systemd Network Management:/:/sbin/nologin
dbus:x:81:81:System message bus:/:/sbin/nologin
sshd:x:74:74:Privilege-separated SSH:/var/empty/sshd:/sbin/nologin
ansible:x:1000:1000::/home/ansible:/bin/bash
banner:x:1001:1001::/home/banner:/bin/bash
rob:x:1002:1004::/home/rob:/bin/bash
joy:x:1003:1005::/home/joy:/bin/bash
david:x:1004:1006::/home/david:/bin/bash
tim:x:1005:1003::/var/www/tim:/bin/bash
jim:x:1006:1003::/var/www/jim:/bin/bash
mark:x:1007:1003::/var/www/mark:/bin/bash
ray:x:1008:1003::/var/www/ray:/bin/bash
thor@jump_host ~/playbooks$ 

```

Verify groups were created

```bash

thor@jump_host ~/playbooks$ ansible stapp03 -a "cat /etc/group" -i inventory 
stapp03 | CHANGED | rc=0 >>
root:x:0:
bin:x:1:
daemon:x:2:
sys:x:3:
adm:x:4:
tty:x:5:
disk:x:6:
lp:x:7:
mem:x:8:
kmem:x:9:
wheel:x:10:ansible,banner,rob,joy,david
cdrom:x:11:
mail:x:12:
man:x:15:
dialout:x:18:
floppy:x:19:
games:x:20:
tape:x:33:
video:x:39:
ftp:x:50:
lock:x:54:
audio:x:63:
nobody:x:99:
users:x:100:
utmp:x:22:
utempter:x:35:
input:x:999:
systemd-journal:x:190:
systemd-network:x:192:
dbus:x:81:
ssh_keys:x:998:
sshd:x:74:
ansible:x:1000:
banner:x:1001:
admins:x:1002:rob,joy,david
developers:x:1003:
rob:x:1004:
joy:x:1005:
david:x:1006:
thor@jump_host ~/playbooks$ 
```

Verify you are able to log n as user **rob**

```bash
thor@jump_host ~/playbooks$ ssh rob@stapp03
The authenticity of host 'stapp03 (172.16.238.12)' can't be established.
ECDSA key fingerprint is SHA256:aqJKOOU9ddonzUWVF/U64AF4FH89O/SmklSVoknH8aI.
ECDSA key fingerprint is MD5:6f:d0:0b:81:c0:56:2a:89:e4:fe:17:02:6e:82:08:d8.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'stapp03' (ECDSA) to the list of known hosts.
rob@stapp03's password: 
[rob@stapp03 ~]$ 
[rob@stapp03 ~]$ pwd
/home/rob
[rob@stapp03 ~]$ id
uid=1002(rob) gid=1004(rob) groups=1004(rob),10(wheel),1002(admins)
[rob@stapp03 ~]$ 
````

