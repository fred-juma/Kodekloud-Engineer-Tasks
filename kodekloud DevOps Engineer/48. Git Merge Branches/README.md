
#### View contents of */usr/src/kodekloudrepos* repo

```bash
[root@ststor01 natasha]# cd /usr/src/kodekloudrepos
[root@ststor01 kodekloudrepos]# ls -l
total 4
drwxr-xr-x 3 root root 4096 May 17 17:14 news
[root@ststor01 kodekloudrepos]# cd new
```

Create and checkout a new branch named *xfusion*

```bash
[root@ststor01 news]# git checkout -b xfusion
Switched to a new branch 'xfusion'
[root@ststor01 news]# cp /tmp/index.html .
[root@ststor01 news]# ls -l
total 12
-rw-r--r-- 1 root root 27 May 17 17:18 index.html
-rw-r--r-- 1 root root 34 May 17 17:14 info.txt
-rw-r--r-- 1 root root 26 May 17 17:14 welcome.txt
[root@ststor01 news]# 
```

View git status to see that we are on branch *xfusion*

```bash
[root@ststor01 news]# git status
# On branch xfusion
# Untracked files:
#   (use "git add <file>..." to include in what will be committed)
#
#       index.html
nothing added to commit but untracked files present (use "git add" to track)
```

Add the intracked files to straging

```bash
[root@ststor01 news]# git add .
```

View status of tracked changes added to staging and ready for commit

```bash
[root@ststor01 news]# git status
# On branch xfusion
# Changes to be committed:
#   (use "git reset HEAD <file>..." to unstage)
#
#       new file:   index.html
#
```

Commit the changes

```bash
[root@ststor01 news]# git commit -m "new commit"
[xfusion a011cf1] new commit
 1 file changed, 1 insertion(+)
 create mode 100644 index.html
 ```

 Confirm the status of th repo

 ```bash
[root@ststor01 news]# git status
# On branch xfusion
nothing to commit, working directory clean
[root@ststor01 news]# 
```

Switch to *master* branch

```bash
[root@ststor01 news]# git checkout  master
Switched to branch 'master'
[root@ststor01 news]# 
```

Merge *xfusion* branch to *master* branch

```bash
[root@ststor01 news]# git merge xfusion
Updating 7f63028..a011cf1
Fast-forward
 index.html | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 index.html
[root@ststor01 news]# 
```

Update remote branch with local commits

```bash
[root@ststor01 news]# git push origin -u master
Counting objects: 4, done.
Delta compression using up to 36 threads.
Compressing objects: 100% (2/2), done.
Writing objects: 100% (3/3), 325 bytes | 0 bytes/s, done.
Total 3 (delta 0), reused 0 (delta 0)
To /opt/news.git
   7f63028..a011cf1  master -> master
Branch master set up to track remote branch master from origin.
[root@ststor01 news]# 
```


***The End***