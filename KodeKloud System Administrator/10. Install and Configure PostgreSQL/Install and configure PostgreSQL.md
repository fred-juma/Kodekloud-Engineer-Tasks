## Instructions

The Nautilus application development team has shared that they are planning to deploy one newly developed application on Nautilus infra in **Stratos DC**. The application uses *PostgreSQL* database, so as a pre-requisite we need to set up *PostgreSQL* database server as per requirements shared below:



a. Install and configure *PostgreSQL* database on Nautilus database server.

b. Create a database user *kodekloud_cap* and set its password to *ksH85UJjhb*

c. Create a database *kodekloud_db8* and grant full permissions to user *kodekloud_cap* on this database.

d. Make appropriate settings to allow all local clients (local socket connections) to connect to the *kodekloud_db8* database through *kodekloud_cap* user using *md5* method (Please do not try to encrypt password with *md5sum*).

e. At the end its good to test the db connection using these new credentials from *root* user or server's *sudo* user.

### My solution

#### SSH into the database server
```bash
thor@jump_host ~$ ssh peter@172.16.239.10
peter@172.16.239.10's password: 
Last login: Fri Nov  4 11:09:00 2022 from jump_host.linux-postgresql-v2_db_net
[peter@stdb01 ~]$ sudo su
[sudo] password for peter: 
[root@stdb01 peter]# 
```

#### Install the postgresql-server package and all of its dependencies:

```bash
[peter@stdb01 ~]$ sudo yum install postgresql-server
Loaded plugins: fastestmirror, ovl
ovl: Error while doing RPMdb copy-up:
[Errno 13] Permission denied: '/var/lib/rpm/Sigmd5'
You need to be root to perform this command.
[peter@stdb01 ~]$ sudo yum install postgresql-server
Loaded plugins: fastestmirror, ovl
Loading mirror speeds from cached hostfile
 * base: mirror.grid.uchicago.edu
 * extras: ftp.ussg.iu.edu
 * updates: mirrors.gigenet.com
Resolving Dependencies
```

#### The Postgres package comes with a handy script called postgresql-setup which helps with low-level database cluster administration. To create a database cluster, run the script using *sudo* and with the *initdb* option:

```bash
[peter@stdb01 ~]$ sudo /usr/bin/postgresql-setup initdb
Initializing database ... OK

[peter@stdb01 ~]$ 
```

#### Use systemctl to enable and start the *postgres* service:

```bash
peter@stdb01 ~]$ sudo systemctl enable postgresql
Created symlink from /etc/systemd/system/multi-user.target.wants/postgresql.service to /usr/lib/systemd/system/postgresql.service.
[peter@stdb01 ~]$ 

peter@stdb01 ~]$ sudo systemctl start postgresql
```

#### Now check the service status to confirm that postgres is up and running

```bash
[peter@stdb01 ~]$ sudo systemctl status postgresql
● postgresql.service - PostgreSQL database server
   Loaded: loaded (/usr/lib/systemd/system/postgresql.service; enabled; vendor preset: disabled)
   Active: inactive (dead)
[peter@stdb01 ~]$ sudo systemctl start postgresql
[peter@stdb01 ~]$ sudo systemctl status postgresql
● postgresql.service - PostgreSQL database server
   Loaded: loaded (/usr/lib/systemd/system/postgresql.service; enabled; vendor preset: disabled)
   Active: active (running) since Sat 2022-11-05 06:18:19 UTC; 6s ago
  Process: 1198 ExecStart=/usr/bin/pg_ctl start -D ${PGDATA} -s -o -p ${PGPORT} -w -t 300 (code=exited, status=0/SUCCESS)
  Process: 1193 ExecStartPre=/usr/bin/postgresql-check-db-dir ${PGDATA} (code=exited, status=0/SUCCESS)
   CGroup: /docker/1ffcc7f5251bfdfee1d033ab264406e217016e5963f2b844b3c628b51f6b24aa/system.slice/postgresql.service
           ├─1200 /usr/bin/postgres -D /var/lib/pgsql/data -p 5432
           ├─1201 postgres: logger process   
           ├─1203 postgres: checkpointer process   
           ├─1204 postgres: writer process   
           ├─1205 postgres: wal writer process   
           ├─1206 postgres: autovacuum launcher process   
           └─1207 postgres: stats collector process   

Nov 05 06:18:18 stdb01.stratos.xfusioncorp.com systemd[1]: Starting PostgreSQ...
Nov 05 06:18:18 stdb01.stratos.xfusioncorp.com pg_ctl[1198]: LOG:  could not ...
Nov 05 06:18:18 stdb01.stratos.xfusioncorp.com pg_ctl[1198]: HINT:  Is anothe...
Nov 05 06:18:19 stdb01.stratos.xfusioncorp.com systemd[1]: Started PostgreSQL...
Hint: Some lines were ellipsized, use -l to show in full.
[peter@stdb01 ~]$ 
```

#### PostgreSQL uses a concept called roles to handle client authentication and authorization. roles is similar to Linux users. Next we create a user role with the credentials provided in the instructions section above.

#### Switching Over to the postgres Account
```bash
[peter@stdb01 ~]$ sudo -i -u postgres
-bash-4.2$ 

You can now access a Postgres prompt immediately by typing: psql. This will log you into the PostgreSQL prompt, and from here you are free to interact with the database management system right away.
```

#### Gain access to the postgres prompt by the *psql* command

```bash
-bash-4.2$ psql
psql (9.2.24)
Type "help" for help.

Exit out of the PostgreSQL prompt by typing: \q
```

#### Create the specified role / user
```sql

postgres=# CREATE USER kodekloud_cap WITH PASSWORD 'ksH85UJjhb';
CREATE ROLE
postgres=# 
```

#### Create the database
```sql
postgres=# CREATE DATABASE kodekloud_db8 WITH OWNER kodekloud_cap;
CREATE DATABASE
postgres=# 
```

#### List the databases in the server using the *\l+* command to confirm that the just created database is displayed as shown below.

```sql
postgres=# \l+
                                                                        List of databases
     Name      |     Owner     | Encoding |   Collate   |    Ctype    |   Access privileges   |  Size   | Tablespace |                Description                 
---------------+---------------+----------+-------------+-------------+-----------------------+---------+------------+--------------------------------------------
 kodekloud_db8 | kodekloud_cap | UTF8     | en_US.UTF-8 | en_US.UTF-8 |                       | 6121 kB | pg_default | 
 postgres      | postgres      | UTF8     | en_US.UTF-8 | en_US.UTF-8 |                       | 6229 kB | pg_default | default administrative connection database
 template0     | postgres      | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +| 6113 kB | pg_default | unmodifiable empty database
               |               |          |             |             | postgres=CTc/postgres |         |            | 
 template1     | postgres      | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +| 6121 kB | pg_default | default template for new databases
               |               |          |             |             | postgres=CTc/postgres |         |            | 
(4 rows)

```

#### List the database roles/users using the *\du* command

```sql
postgres=# \du
                               List of roles
   Role name   |                   Attributes                   | Member of 
---------------+------------------------------------------------+-----------
 kodekloud_cap |                                                | {}
 postgres      | Superuser, Create role, Create DB, Replication | {}

postgres=# 
postgres=# 
```

#### Now we need to modify the postgers configuration to allow all local clients (local socket connections) to connect to the *kodekloud_db8* database through *kodekloud_cap* user using *md5* method.

#### Because the configuration files are owned by *postgresql* default user *postgres*, we need to first configure password for the user:

```sql
postgres=# \password postgres
Enter new password: 
Enter it again: 
postgres=# 
```

#### Next using vi editor, edit the *postgresql* configuration file */var/lib/pgsql/data/pg_hba.conf* by replacing *local* method *peer* with *md5*

```bash
[peter@stdb01 ~]$ sudo ls /var/lib/pgsql/data/
base         pg_ident.conf  pg_serial     pg_tblspc    postgresql.conf
global       pg_log         pg_snapshots  pg_twophase  postmaster.opts
pg_clog      pg_multixact   pg_stat_tmp   PG_VERSION   postmaster.pid
pg_hba.conf  pg_notify      pg_subtrans   pg_xlog
[peter@stdb01 ~]$ 
```

#### configuration snapshot before modifying the method setting
```bash
[peter@stdb01 ~]$ sudo cat /var/lib/pgsql/data/pg_hba.conf | grep peer
# "krb5", "ident", "peer", "pam", "ldap", "radius" or "cert".  Note that
local   all             all                                     peer
#local   replication     postgres                                peer
[peter@stdb01 ~]$
```

#### Configuration snapshot after modifying the method to md5
```bash
[peter@stdb01 ~]$ sudo cat /var/lib/pgsql/data/pg_hba.conf | grep md5
# METHOD can be "trust", "reject", "md5", "password", "gss", "sspi",
# "password" sends passwords in clear text; "md5" is preferred since
local   all             all                                     md5
[peter@stdb01 ~]$
```

#### Test connection to the database was successful, forgot to capture the output screenshot.

***The End***

