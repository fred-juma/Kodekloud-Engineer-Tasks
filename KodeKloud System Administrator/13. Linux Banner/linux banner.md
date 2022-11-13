## Instructions 

Apply Linux banner saved in */home/thor/nautilus_banner* to all app servers and db servers.

### My Solution

#### Check to confirm that the banner motd is in the file */home/thor/nautilus_banner* 

```bash
thor@jump_host ~$ cat /home/thor/nautilus_banner 
################################################################################################
  .__   __.      ___      __    __  .___________. __   __       __    __       _______.        # 
       |  \ |  |     /   \    |  |  |  | |           ||  | |  |     |  |  |  |     /       |   #
       |   \|  |    /  ^  \   |  |  |  | `---|  |----`|  | |  |     |  |  |  |    |   (----`   #
       |  . `  |   /  /_\  \  |  |  |  |     |  |     |  | |  |     |  |  |  |     \   \       #
       |  |\   |  /  _____  \ |  `--'  |     |  |     |  | |  `----.|  `--'  | .----)   |      #
       |__| \__| /__/     \__\ \______/      |__|     |__| |_______| \______/  |_______/       #
                                                                                               #
                                                                                               #
                                                                                               # 
                                                                                               #
                                 # #  ( )                                                      #
                                  ___#_#___|__                                                 #
                              _  |____________|  _                                             #
                       _=====| | |            | | |==== _                                      #
                 =====| |.---------------------------. | |====                                 #
   <--------------------'   .  .  .  .  .  .  .  .   '--------------/                          #
     \                                                             /                           #
      \_______________________________________________WWS_________/                            #
  wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww                        #
wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww                       # 
   wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww                         #
                                                                                               #
                                                                                               #
################################################################################################
Warning! All Nautisudo scp /home/thor/nautilus_banner 172.16.238.10:/tmp/^C
```

#### *scp* the banner motd file from the location in *jump_host* to *app server 1* */tmp/* directory
```bash
thor@jump_host ~$ scp /home/thor/nautilus_banner tony@172.16.238.10:/tmp/
tony@172.16.238.10's password: 
thor@jump_host ~$ scp /home/thor/nautilus_banner tony@172.16.238.10:/etc/motd 

```

#### SSH to *app server 1*
```bash
tony@172.16.238.10's password: 
scp: /etc/motd: Permission denied
```

#### copy the banner motd from */tmp/* directory to banner configuration file*/etc/motd*

```bash
thor@jump_host ~$ scp /home/thor/nautilus_banner tony@172.16.238.10:/tmp/
tony@172.16.238.10's password: 
nautilus_banner                                                                                                                           100% 2530    14.1MB/s   00:00    
```

#### Repeat the above procedures for *app server 2* and *app server 3*

#### In the case of *db server*, *scp* fails to copy the banner motd as shown in the result below. This is because *scp* utility is not installed in the server

```bash
thor@jump_host ~$ scp /home/thor/nautilus_banner peter@172.16.239.10:/tmp/
The authenticity of host '172.16.239.10 (172.16.239.10)' can't be established.
ECDSA key fingerprint is SHA256:foHoSaqK40WPB0ATIRnKygq4cGWQbqyaZG0mClX6XDg.
ECDSA key fingerprint is MD5:d0:f6:ac:7a:66:0a:84:f4:95:eb:f1:31:f3:af:93:b8.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '172.16.239.10' (ECDSA) to the list of known hosts.
peter@172.16.239.10's password: 
bash: scp: command not found
lost connection
thor@jump_host ~$ 
```

#### We have to install *scp* utility in *db server*, therefore ssh into *db server*

```bash
thor@jump_host ~$ ssh peter@172.16.239.10
peter@172.16.239.10's password: 
```

#### install the *openssh-clients* package which contain the *scp utility*. Below is a snippet of the installation process

```bash
[peter@stdb01 ~]$ sudo yum -y install openssh-clients

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for peter: 
Loaded plugins: fastestmirror, ovl
Determining fastest mirrors
 * base: linux-mirrors.fnal.gov
 * extras: mirror.team-cymru.com
 * updates: mirror.genesisadaptive.com
base                                                                                                                                                 | 3.6 kB  00:00:00     
extras                                                                                                                                               | 2.9 kB  00:00:00     
updates 
```      
                                                                                                                                          
#### Once the installation is complete, exit back to jump host and then *scp* the banner motd from jump host */home/thor/nautilus_banner* to */tmp/* in the *db server*

```bash
[peter@stdb01 ~]$ exit
logout
Connection to 172.16.239.10 closed.
thor@jump_host ~$ scp /home/thor/nautilus_banner peter@172.16.239.10:/tmp/
peter@172.16.239.10's password: 
nautilus_banner                                                                                                                           100% 2530     6.6MB/s   00:00    
thor@jump_host ~$ 
```

#### SSH into the *db server* and copy the banner motd from */tmp/* to the banner motd configuration file */etc/motd*

```bash
thor@jump_host ~$ ssh peter@172.16.239.10
peter@172.16.239.10's password: 
Last login: Sun Nov 13 11:21:27 2022 from jump_host.linux-banner-v2_db_net
[peter@stdb01 ~]$ sudo cp /tmp/nautilus_banner /etc/motd 
[sudo] password for peter: 
[peter@stdb01 ~]$ 
```

#### Exit back to the jump host and connect back to the *db server* to confirm that the banner has been applied successfully.

```bash
thor@jump_host ~$ ssh tony@172.16.238.10
tony@172.16.238.10's password: 
Permission denied, please try again.
tony@172.16.238.10's password: 
Last login: Sun Nov 13 11:03:25 2022 from jump_host.linux-banner-v2_app_net
################################################################################################
  .__   __.      ___      __    __  .___________. __   __       __    __       _______.        # 
       |  \ |  |     /   \    |  |  |  | |           ||  | |  |     |  |  |  |     /       |   #
       |   \|  |    /  ^  \   |  |  |  | `---|  |----`|  | |  |     |  |  |  |    |   (----`   #
       |  . `  |   /  /_\  \  |  |  |  |     |  |     |  | |  |     |  |  |  |     \   \       #
       |  |\   |  /  _____  \ |  `--'  |     |  |     |  | |  `----.|  `--'  | .----)   |      #
       |__| \__| /__/     \__\ \______/      |__|     |__| |_______| \______/  |_______/       #
                                                                                               #
                                                                                               #
                                                                                               # 
                                                                                               #
                                 # #  ( )                                                      #
                                  ___#_#___|__                                                 #
                              _  |____________|  _                                             #
                       _=====| | |            | | |==== _                                      #
                 =====| |.---------------------------. | |====                                 #
   <--------------------'   .  .  .  .  .  .  .  .   '--------------/                          #
     \                                                             /                           #
      \_______________________________________________WWS_________/                            #
  wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww                        #
wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww                       # 
   wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww                         #
                                                                                               #
                                                                                               #
################################################################################################
Warning! All Nautilus systems are monitored and audited. Logoff immediately if you are not authorized![tony@stapp01 ~]$ 
```

***The End***


