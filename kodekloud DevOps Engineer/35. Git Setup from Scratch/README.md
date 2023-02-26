#### Task

Some new developers have joined xFusionCorp Industries and have been assigned Nautilus project. They are going to start development on a new application, and some pre-requisites have been shared with the DevOps team to proceed with. Please note that all tasks need to be performed on storage server in Stratos DC.



a. Install git, set up any values for user.email and user.name globally and create a bare repository /opt/cluster.git.

b. There is an update hook (to block direct pushes to master branch) under /tmp on storage server itself; use the same to block direct pushes to master branch in /opt/cluster.git repo.

c. Clone /opt/cluster.git repo in /usr/src/kodekloudrepos/cluster directory.

d. Create a new branch xfusioncorp_cluster in repo that you cloned in /usr/src/kodekloudrepos.

e. There is a readme.md file in /tmp on storage server itself; copy that to repo, add/commit in the new branch you created, and finally push your branch to origin.

f. Also create master branch from your branch and remember you should not be able to push to master as per hook you have set up.


#### Solution

SSH to Storage Server

```bash

thor@jump_host ~$ ssh natasha@ststor01
The authenticity of host 'ststor01 (172.16.238.15)' can't be established.
ECDSA key fingerprint is SHA256:RSLqG0MRBUIKTkzVvU9Za+nmL9jeDge/NECCt7izOGY.
ECDSA key fingerprint is MD5:d9:bd:df:fa:7b:a1:de:a7:ef:3b:10:eb:76:c1:c2:35.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'ststor01,172.16.238.15' (ECDSA) to the list of known hosts.
natasha@ststor01's password: 
[natasha@ststor01 ~]$ 
```

Install git

```bash

[natasha@ststor01 ~]$ sudo yum install git-all -y

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for natasha: 
Loaded plugins: fastestmirror, ovl
Determining fastest mirrors
 * base: ftp.ussg.iu.edu
 * extras: mirror.vacares.com
 * updates: mirror.centos.iad1.serverforge.org
base                                                                       
```

Configure git global username and email

```bash
[natasha@ststor01 ~]$ git config --global user.name "natasha"
[natasha@ststor01 ~]$ git config --global user.email natasha@.stratos.xfusioncorp.com
[natasha@ststor01 ~]$ 
```

Verify the global configs

```bash

[natasha@ststor01 games.git]$ git config --list
user.name=natasha
user.email=natasha@.stratos.xfusioncorp.com
[natasha@ststor01 games.git]$ 
```


Create a bare repository

```bash
[natasha@ststor01 ~]$ sudo git init --bare /opt/games.git
Initialized empty Git repository in /opt/games.git/
[natasha@ststor01 ~]$
``` 


Navigate into the remote repo and view the contents

```bash
[natasha@ststor01 ~]$ cd /opt/games.git/
[natasha@ststor01 games.git]$ ls -l
total 36
drwxr-xr-x 3 root root 4096 Feb 25 11:35 –bare
drwxr-xr-x 2 root root 4096 Feb 25 11:47 branches
-rw-r--r-- 1 root root   66 Feb 25 11:47 config
-rw-r--r-- 1 root root   73 Feb 25 11:47 description
-rw-r--r-- 1 root root   23 Feb 25 11:47 HEAD
drwxr-xr-x 3 root root 4096 Feb 25 11:47 hooks
drwxr-xr-x 2 root root 4096 Feb 25 11:47 info
drwxr-xr-x 4 root root 4096 Feb 25 11:47 objects
drwxr-xr-x 4 root root 4096 Feb 25 11:47 refs
[natasha@ststor01 games.git]$ 
```

Copy the hook from */tmp/* to the repo

```bash
[root@ststor01 games.git]# cp /tmp/update hooks/
```

Navigate to the new directory *kodekloudrepos*

```bash
[root@ststor01 update]# cd /usr/src/kodekloudrepos/
[root@ststor01 kodekloudrepos]# 
```

Clone the games repo into this new directory

```bash
[root@ststor01 kodekloudrepos]# git clone /opt/games.git
Cloning into 'games'...
warning: You appear to have cloned an empty repository.
done.
[root@ststor01 kodekloudrepos]# 
```

Navigate into the cloned repo

```bash
[root@ststor01 kodekloudrepos]# cd games/
```

Create the *xfusioncorp_games* branch

```bash
[root@ststor01 games]# git checkout -b xfusioncorp_games
Switched to a new branch 'xfusioncorp_games'
[root@ststor01 games]# 
```

Copy the */tmp/readme.md* file to the repo and verify successful copy

```bash
[root@ststor01 games]# cp /tmp/readme.md .
[root@ststor01 games]# ls -l
total 4
-rw-r--r-- 1 root root 33 Feb 25 12:01 readme.md
[root@ststor01 games]# 
```

Check git status

```bash
[root@ststor01 games]# git status
# On branch xfusioncorp_games
#
# Initial commit
#
# Untracked files:
#   (use "git add <file>..." to include in what will be committed)
#
#       readme.md
nothing added to commit but untracked files present (use "git add" to track)
```

git add *readme.md* 

```bash
[root@ststor01 games]# git add readme.md 
```

git commit *readme.md*

```bash
[root@ststor01 games]# git commit -m "create readme"
[xfusioncorp_games (root-commit) 005e0e2] create readme
 Committer: root <root@ststor01.stratos.xfusioncorp.com>
Your name and email address were configured automatically based
on your username and hostname. Please check that they are accurate.
You can suppress this message by setting them explicitly:

    git config --global user.name "Your Name"
    git config --global user.email you@example.com

After doing this, you may fix the identity used for this commit with:

    git commit --amend --reset-author

 1 file changed, 1 insertion(+)
 create mode 100644 readme.md
[root@ststor01 games]# 
```

git push the to xfusioncorp_games branch

```bash
[root@ststor01 games]# git push origin xfusioncorp_games
Counting objects: 3, done.
Writing objects: 100% (3/3), 251 bytes | 0 bytes/s, done.
Total 3 (delta 0), reused 0 (delta 0)
To /opt/games.git/
 * [new branch]      xfusioncorp_games -> xfusioncorp_games
[root@ststor01 games]# 
```

Create master branch

```bash
[root@ststor01 games]# git checkout -b master
Switched to a new branch 'master'
[root@ststor01 games]# 
```

Attempt to push to master branch fails because the hook is configured to disable direct push to master branch

```bash
[root@ststor01 games]# git push origin master
Total 0 (delta 0), reused 0 (delta 0)
remote: Manual pushing to this repo's master branch is restricted
remote: error: hook declined to update refs/heads/master
To /opt/games.git/
 ! [remote rejected] master -> master (hook declined)
error: failed to push some refs to '/opt/games.git/'
[root@ststor01 games]# 
```

***The End***




