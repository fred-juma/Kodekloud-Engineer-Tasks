#### Task

To manage all servers within the stack using Ansible, the Nautilus DevOps team is planning to use a common sudo user among all servers. Ansible will be able to use this to perform different tasks on each server. This is not finalized yet, but the team has decided to first perform testing. The DevOps team has already installed Ansible on jump host using yum, and they now have the following requirement:



On jump host make appropriate changes so that Ansible can use yousuf as a default ssh user for all hosts. Make changes in Ansible's default configuration only —please do not try to create a new config.

#### Solution


Locate the location of the ansible configuration file
```bash
thor@jump_host ~$ ls /etc/ansible/ansible.cfg
/etc/ansible/ansible.cfg
```
Edit the configuration file, look for *remote_user* and make its value to the default ssh user *yousuf*

```bash
thor@jump_host ~$ vi /etc/ansible/ansible.cfg

# SSH timeout
#timeout = 10

# default user to use for playbooks if user is not specified
# (/usr/bin/ansible will use current user as default)
remote_user = yousuf
```


***The End***