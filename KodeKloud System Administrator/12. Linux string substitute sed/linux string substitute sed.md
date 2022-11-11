### Instructions

There is some data on Nautilus **App Server 2** in Stratos DC. Data needs to be altered in several of the files. On Nautilus **App Server 2**, alter the */home/BSD.txt* file as per details given below:



a. Delete all lines containing word code and save results in */home/BSD_DELETE.txt* file. (Please be aware of case sensitivity)

b. Replace all occurrence of word the to their and save results in */home/BSD_REPLACE.txt* file.

Note: Let's say you are asked to replace word to with from. In that case, make sure not to alter any words containing this string; for example upto, contributor etc.

#### My solution

#### SSH into app server 2
```bash
thor@jump_host ~$ ssh steve@172.16.238.11
The authenticity of host '172.16.238.11 (172.16.238.11)' can't be established.
ECDSA key fingerprint is SHA256:dN5eAQ+owfK8uK3gyusRJV3jQJZhtPU73P97bWI1J88.
ECDSA key fingerprint is MD5:09:ae:f6:80:67:b3:b9:77:57:95:96:fd:ab:2a:ff:fe.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '172.16.238.11' (ECDSA) to the list of known hosts.
steve@172.16.238.11's password: 
````

#### Switch to *root* user
```bash
[steve@stapp02 ~]$ sudo su

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for steve: 
[root@stapp02 steve]# 
```

#### List the occurances of the string *code*
[root@stapp02 steve]# cat /home/BSD.txt | grep code
1. Redistributions of source code must retain the above copyright
1. Redistributions of source code must retain the above copyright
1. Redistributions of source code must retain the above copyright
1. Redistributions of source code must retain the above copyright
1. Redistributions of source code must retain the above copyright
1. Redistributions of source code must retain the above copyright

#### Use 'sed' command to delete every occurance of string *code* and save the result to a file */home/BSD_DELETE.txt* while preserving the contents of original file */home/BSD.txt*

```bash
[root@stapp02 steve]# sed '/\<code\>/d' /home/BSD.txt > /home/BSD_DELETE.txt
[root@stapp02 steve]# 
```

#### After performing the opertaion, confirm that the contents of original file  */home/BSD.txt* is intact

```bash
[root@stapp02 steve]# cat /home/BSD.txt | grep code
1. Redistributions of source code must retain the above copyright
1. Redistributions of source code must retain the above copyright
1. Redistributions of source code must retain the above copyright
1. Redistributions of source code must retain the above copyright
1. Redistributions of source code must retain the above copyright
1. Redistributions of source code must retain the above copyright
```

#### Also confirm that all instances of *code* were deleted in the new file */home/BSD_DELETE.txt* 

```bash
[root@stapp02 steve]# cat /home/BSD_DELETE.txt | grep code
[root@stapp02 steve]# 
```

#### The other instruction is to replace the occurances of string *the* in */home/BSD.txt* and save result in a new file */home/BSD_REPLACE.txt* while preserving the contents of the original file

#### List the occurances of string *the* in the original file */home/BSD.txt*

```bash
[root@stapp02 steve]# cat /home/BSD.txt | grep the
modification, are permitted provided that the following conditions are met:
1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
   must display the following acknowledgement:
   This product includes software developed by the <organization>.
4. Neither the name of the <organization> nor the
modification, are permitted provided that the following conditions are met:
1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
   must display the following acknowledgement:
   This product includes software developed by the <organization>.
```

#### Use sed to perform the replacement operation and save the result to the new file as instructed above

```bash

sed 's/\bthe\b/their/g' /home/BSD.txt > /home/BSD_REPLACE.txt
```

#### Confirm that the new file */home/BSD_REPLACE.txt* contains all instances of string *the* replaced by string *their*

```bash
[root@stapp02 steve]# cat /home/BSD_REPLACE.txt | grep their
modification, are permitted provided that their following conditions are met:
1. Redistributions of source code must retain their above copyright
   notice, this list of conditions and their following disclaimer.
2. Redistributions in binary form must reproduce their above copyright
   notice, this list of conditions and their following disclaimer in their
   documentation and/or other materials provided with their distribution.
   must display their following acknowledgement:
   This product includes software developed by their <organization>.
4. Neither their name of their <organization> nor their
modification, are permitted provided that their following conditions are met:
1. Redistributions of source code must retain their above copyright
   notice, this list of conditions and their following disclaimer.
2. Redistributions in binary form must reproduce their above copyright
   notice, this list of conditions and their following disclaimer in their
   documentation and/or other materials provided with their distribution.
   ```

   ***The End***