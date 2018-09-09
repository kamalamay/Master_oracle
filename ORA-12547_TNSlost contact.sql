[root@zeusr2 ~]# su - goldengate
[goldengate@zeusr2 ~]$ sqlplus / as sysdba

SQL*Plus: Release 11.2.0.2.0 Production on Tue May 5 11:50:23 2015

Copyright (c) 1982, 2010, Oracle.  All rights reserved.

ERROR:
ORA-12547: TNS:lost contact


Enter user-name: 
[goldengate@zeusr2 ~]$ sqlplus /nolog

SQL*Plus: Release 11.2.0.2.0 Production on Tue May 5 11:50:44 2015

Copyright (c) 1982, 2010, Oracle.  All rights reserved.

SQL> conn / as sysdba
ERROR:
ORA-12547: TNS:lost contact


SQL>

http://amardeepsidhu.com/blog/2011/05/18/ora-12547-tns-lost-contact/comment-page-1/

ORA-12547: TNS:lost contact

18

Very simple issue but took some amount of time in troubleshooting so thought about posting it here. May be it proves to be useful for someone.

Scenario was: Oracle is installed from “oracle” user and all runs well. There is a new OS user “test1″ that also needs to use sqlplus. So granted the necessary permissions on ORACLE_HOME to test1. Tried to connect sqlplus scott/tiger@DB and yes it works. But while trying sqlplus scott/tiger it throws:
	
$ sqlplus scott/tiger
 
SQL*Plus: Release 10.2.0.5.0 - Production on Wed May 18 09:32:35 2011
 
Copyright (c) 1982, 2010, Oracle.  All Rights Reserved.
 
ERROR:
ORA-12547: TNS:lost contact
 
 
Enter user-name: ^C
$

Did a lot of troubleshooting including checking tnsnames.ora, sqlnet.ora, listener.ora and so on. Nothing was hitting my mind so finally raised an SR. And it has to do with the permissions of the $ORACLE_HOME/bin/oracle binary. The permissions of oracle executable should be rwsr-s–x or 6751 but they were not. See below:
	
$ id
uid=241(test1) gid=202(users) groups=1(staff),13(dba)
$
 
$ cd $ORACLE_HOME/bin
$ ls -ltr oracle
-rwxr-xr-x    1 oracle   dba       136803483 Mar 16 20:32 oracle
$
 
$ chmod 6751 oracle
$ ls -ltr oracle
-rwsr-s--x    1 oracle   dba       136803483 Mar 16 20:32 oracle
$
 
$ sqlplus scott/tiger
 
SQL*Plus: Release 10.2.0.5.0 - Production on Wed May 18 10:23:27 2011
 
Copyright (c) 1982, 2010, Oracle.  All Rights Reserved.
 
 
Connected to:
Oracle Database 10g Enterprise Edition Release 10.2.0.5.0 - 64bit Production
With the Partitioning, OLAP, Data Mining and Real Application Testing options
 
SQL> show user
USER is "SCOTT"
SQL>