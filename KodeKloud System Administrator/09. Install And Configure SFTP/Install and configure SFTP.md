#### Documentation to be cleaned up!


Some of the developers from Nautilus project team have asked for SFTP access to at least one of the app server in Stratos DC. After going through the requirements, the system admins team has decided to configure the SFTP server on App Server 3 server in Stratos Datacenter. Please configure it as per the following instructions:



a. Create an SFTP user rose and set its password to LQfKeWWxWD.

b. Password authentication should be enabled for this user.

c. Set its ChrootDirectory to /var/www/appdata.

d. SFTP user should only be allowed to make SFTP connections.


thor@jump_host ~$ ssh banner@172.16.238.12
The authenticity of host '172.16.238.12 (172.16.238.12)' can't be established.
ECDSA key fingerprint is SHA256:foVdrU6CxuxlRU5CTabcSAM4AG+3LsFFCqsYqltx8Xw.
ECDSA key fingerprint is MD5:d6:0d:1c:74:80:41:06:15:d9:e7:98:29:7e:33:eb:2d.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '172.16.238.12' (ECDSA) to the list of known hosts.
banner@172.16.238.12's password: 
Permission denied, please try again.
banner@172.16.238.12's password: 
Permission denied, please try again.
banner@172.16.238.12's password: 
Permission denied (publickey,gssapi-keyex,gssapi-with-mic,password).
thor@jump_host ~$ ssh banner@172.16.238.12
banner@172.16.238.12's password: 
Permission denied, please try again.
banner@172.16.238.12's password: 
[banner@stapp03 ~]$ sudo su

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for banner: 



[root@stapp03 banner]# rpm -qa | grep ssh
libssh2-1.4.3-12.el7_6.3.x86_64
openssh-7.4p1-22.el7_9.x86_64
openssh-clients-7.4p1-22.el7_9.x86_64
openssh-server-7.4p1-22.el7_9.x86_64
sshpass-1.06-2.el7.x86_64
[root@stapp03 banner]# 




[root@stapp03 banner]# groupadd sftpusers
[root@stapp03 banner]# 


[root@stapp03 banner]# mkdir -p /var/www/appdata


[root@stapp03 banner]# useradd -d /var/www/appdata/ -s /sbin/nologin -g sftpusers rose 
useradd: warning: the home directory already exists.
Not copying any file from skel directory into it.



[root@stapp03 banner]# useradd  -s /sbin/nologin -g sftpusers rose 
Creating mailbox file: File exists
[root@stapp03 banner]# 




[root@stapp03 banner]# passwd rose
Changing password for user rose.
New password: 
Retype new password: 
passwd: all authentication tokens updated successfully.
[root@stapp03 banner]# 




[root@stapp03 banner]# chown -R root:root /var/www/
[root@stapp03 banner]# sudo chmod 700 /var/www/
[root@stapp03 banner]# 



[root@stapp03 banner]# 
[root@stapp03 banner]# chown -R rose:sftpusers /var/www/appdata/
[root@stapp03 banner]# 



[root@stapp03 banner]# vi /etc/ssh/sshd_config 
[root@stapp03 banner]# 


#       $OpenBSD: sshd_config,v 1.100 2016/08/15 12:32:04 naddy Exp $

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/local/bin:/usr/bin

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

# If you want to change the port on a SELinux system, you have to tell
# SELinux about this change.
# semanage port -a -t ssh_port_t -p tcp #PORTNUMBER
#
#Port 22
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::

HostKey /etc/ssh/ssh_host_rsa_key
#HostKey /etc/ssh/ssh_host_dsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key

# Ciphers and keying
#RekeyLimit default none

# Logging
#SyslogFacility AUTH
SyslogFacility AUTHPRIV
#LogLevel INFO

# Authentication:

#LoginGraceTime 2m
#PermitRootLogin yes
#StrictModes yes
#MaxAuthTries 6
#MaxSessions 10

#PubkeyAuthentication yes

# The default is to check both .ssh/authorized_keys and .ssh/authorized_keys2
# but this is overridden so installations will only check .ssh/authorized_keys
AuthorizedKeysFile      .ssh/authorized_keys

#AuthorizedPrincipalsFile none

#AuthorizedKeysCommand none
#AuthorizedKeysCommandUser nobody

# For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
#HostbasedAuthentication no
# Change to yes if you don't trust ~/.ssh/known_hosts for
# HostbasedAuthentication
#IgnoreUserKnownHosts no
# Don't read the user's ~/.rhosts and ~/.shosts files
#IgnoreRhosts yes

# To disable tunneled clear text passwords, change to no here!
PasswordAuthentication yes
#PermitEmptyPasswords no
PasswordAuthentication yes

# Change to no to disable s/key passwords
#ChallengeResponseAuthentication yes
ChallengeResponseAuthentication no

# Kerberos options
#KerberosAuthentication no
#KerberosOrLocalPasswd yes
#KerberosTicketCleanup yes
#KerberosGetAFSToken no
#KerberosUseKuserok yes

# GSSAPI options
GSSAPIAuthentication yes
GSSAPICleanupCredentials no
#GSSAPIStrictAcceptorCheck yes
#GSSAPIKeyExchange no
#GSSAPIEnablek5users no

# Set this to 'yes' to enable PAM authentication, account processing,
# and session processing. If this is enabled, PAM authentication will
# be allowed through the ChallengeResponseAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via ChallengeResponseAuthentication may bypass
# the setting of "PermitRootLogin without-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and ChallengeResponseAuthentication to 'no'.
# WARNING: 'UsePAM no' is not supported in Red Hat Enterprise Linux and may cause several
# problems.
UsePAM no

AllowAgentForwarding no
AllowTcpForwarding no
#GatewayPorts no
X11Forwarding no
#X11DisplayOffset 10
#X11UseLocalhost yes
#PermitTTY yes
#PrintMotd yes
#PrintLastLog yes
#TCPKeepAlive yes
#UseLogin no
#UsePrivilegeSeparation sandbox
#PermitUserEnvironment no
#Compression delayed
#ClientAliveInterval 0
#ClientAliveCountMax 3
#ShowPatchLevel no
#UseDNS yes
#PidFile /var/run/sshd.pid
#MaxStartups 10:30:100
PermitTunnel yes
ChrootDirectory /var/www
#VersionAddendum none

# no default banner path
#Banner none

# Accept locale-related environment variables
AcceptEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES
AcceptEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT
AcceptEnv LC_IDENTIFICATION LC_ALL LANGUAGE
AcceptEnv XMODIFIERS

# override default of no subsystems
Subsystem       sftp    /usr/libexec/openssh/sftp-server

# Example of overriding settings on a per-user basis
Match User rose
#       X11Forwarding no
#       AllowTcpForwarding no
#       PermitTTY no
        ForceCommand internal-sftp






  [root@stapp03 banner]# sudo systemctl restart sshd
[root@stapp03 banner]#


[root@stapp03 banner]# sudo systemctl status sshd
● sshd.service - OpenSSH server daemon
   Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
   Active: active (running) since Wed 2022-11-02 18:56:50 UTC; 25s ago
     Docs: man:sshd(8)
           man:sshd_config(5)
 Main PID: 798 (sshd)
   CGroup: /docker/d49a54a50df65ec9c7380a280289eb6ce96a8d378d4907ed1b86494632839957/system.slice/sshd.service
           ├─608 sshd: banner [priv]
           ├─623 sshd: banner@pts/0
           ├─624 -bash
           └─798 /usr/sbin/sshd -D

Nov 02 18:56:50 stapp03.stratos.xfusioncorp.com systemd[798]: Executing: /usr/sbin/ssh...
Nov 02 18:56:50 stapp03.stratos.xfusioncorp.com sshd[798]: WARNING: 'UsePAM no' is not...
Nov 02 18:56:50 stapp03.stratos.xfusioncorp.com sshd[798]: Server listening on 0.0.0.0...
Nov 02 18:56:50 stapp03.stratos.xfusioncorp.com sshd[798]: Server listening on :: port...
Nov 02 18:56:50 stapp03.stratos.xfusioncorp.com systemd[1]: Got notification message f...
Nov 02 18:56:50 stapp03.stratos.xfusioncorp.com systemd[1]: sshd.service: Got notifica...
Nov 02 18:56:50 stapp03.stratos.xfusioncorp.com systemd[1]: sshd.service: got READY=1
Nov 02 18:56:50 stapp03.stratos.xfusioncorp.com systemd[1]: sshd.service changed start...
Nov 02 18:56:50 stapp03.stratos.xfusioncorp.com systemd[1]: Job sshd.service/start fin...
Nov 02 18:56:50 stapp03.stratos.xfusioncorp.com systemd[1]: Started OpenSSH server dae...
Hint: Some lines were ellipsized, use -l to show in full.
[root@stapp03 banner]# 







