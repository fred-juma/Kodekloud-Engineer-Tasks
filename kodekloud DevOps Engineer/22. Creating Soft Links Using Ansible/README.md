#### Task

The Nautilus DevOps team is practicing some of the Ansible modules and creating and testing different Ansible playbooks to accomplish tasks. Recently they started testing an Ansible file module to create soft links on all app servers. Below you can find more details about it.



Write a playbook.yml under /home/thor/ansible directory on jump host, an inventory file is already present under /home/thor/ansible directory on jump host itself. Using this playbook accomplish below given tasks:

Create an empty file /opt/sysops/blog.txt on app server 1; its user owner and group owner should be tony. Create a symbolic link of source path /opt/sysops to destination /var/www/html.

Create an empty file /opt/sysops/story.txt on app server 2; its user owner and group owner should be steve. Create a symbolic link of source path /opt/sysops to destination /var/www/html.

Create an empty file /opt/sysops/media.txt on app server 3; its user owner and group owner should be banner. Create a symbolic link of source path /opt/sysops to destination /var/www/html.

Note: Validation will try to run the playbook using command ansible-playbook -i inventory playbook.yml so please make sure playbook works this way without passing any extra arguments.

#### Solution

View the inventory file

```bash

thor@jump_host ~$ cat /home/thor/ansible/ansible.cfg 
[defaults]
host_key_checking = Falsethor@jump_host ~$ 
```

Create the playbook yaml file

```bash
thor@jump_host ~/ansible$ sudo vi playbook.yml

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for thor: 
```

Populate the playbook with the instructions provided

```yaml

---

- hosts: stapp01
  gather_facts: false
  become: true

  tasks:
    - name: Create empty file
      file:
        path: /opt/sysops/blog.txt
        state: touch
        owner: tony
        group: tony
    - name: Create symbolic link
      file:
        state: link
        src: /opt/sysops
        dest: /var/www/html

- hosts: stapp02
  gather_facts: false
  become: true

  tasks:
    - name: Create empty file
      file:
        path: /opt/sysops/story.txt
        state: touch
        owner: steve
        group: steve
    - name: Create symbolic link
      file:
        state: link
        src: /opt/sysops
        dest: /var/www/html

- hosts: stapp03
  gather_facts: false
  become: true

  tasks:
    - name: Create empty file
      file:
        path: /opt/sysops/media.txt
        state: touch
        owner: banner
        group: banner

    - name: Create symbolic link
      file:
        state: link
        src: /opt/sysops
        dest: /var/www/html
```

Run the playbook to create the resources

```bash
thor@jump_host ~/ansible$ ansible-playbook -i inventory playbook.yml

PLAY [stapp01] ***********************************************************************************

TASK [Create empty file] *************************************************************************
changed: [stapp01]

TASK [Create symbolic link] **********************************************************************
changed: [stapp01]

PLAY [stapp02] ***********************************************************************************

TASK [Create empty file] *************************************************************************
changed: [stapp02]

TASK [Create symbolic link] **********************************************************************
changed: [stapp02]

PLAY [stapp03] ***********************************************************************************

TASK [Create empty file] *************************************************************************
changed: [stapp03]

TASK [Create symbolic link] **********************************************************************
changed: [stapp03]

PLAY RECAP ***************************************************************************************
stapp01                    : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
stapp02                    : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
stapp03                    : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

thor@jump_host ~/ansible$
```

Log in to app server 1 to confirm the resources were provisioned

***The End***