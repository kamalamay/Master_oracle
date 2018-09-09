[grid@asem ~]$ asmcmd
ASMCMD> lsdg
State    Type    Rebal  Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  NORMAL  N         512   4096  1048576      4094     3992                0            1996              0             N  ARC/
MOUNTED  NORMAL  N         512   4096  1048576      6141     1931             2047             -58              0             N  DATA/
ASMCMD> exit
[grid@asem ~]$ exit
logout
[orekel@asem ~]$ rlwrap sqlplus sys as sysdba

SQL*Plus: Release 11.2.0.4.0 Production on Tue Oct 14 14:42:13 2014

Copyright (c) 1982, 2013, Oracle.  All rights reserved.

Enter password: 

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.4.0 - 64bit Production
With the Partitioning, Automatic Storage Management, OLAP, Data Mining
and Real Application Testing options

SQL> shutdown immediate;
Database closed.
Database dismounted.
ORACLE instance shut down.
SQL> STARTUP MOUNT;
ORACLE instance started.

Total System Global Area  835104768 bytes
Fixed Size		    2257840 bytes
Variable Size		  536874064 bytes
Database Buffers	  289406976 bytes
Redo Buffers		    6565888 bytes
Database mounted.
SQL> ALTER DATABASE FORCE LOGGING;

Database altered.

SQL> ALTER DATABASE ARCHIVELOG;

Database altered.

SQL> ALTER SYSTEM SET LOG_ARCHIVE_DEST_1='LOCATION=+ARC VALID_FOR=(ALL_LOGFILES,ALL_ROLES)' SCOPE=SPFILE;

System altered.

SQL> ALTER SYSTEM SET LOG_ARCHIVE_FORMAT='%t_%s_%r.ARC' SCOPE=SPFILE/*Asli ini ga penting, kan udah ada ASM :p */;

System altered.

SQL> SHUTDOWN IMMEDIATE;
ORA-01109: database not open


Database dismounted.
ORACLE instance shut down.
SQL> STARTUP;
ORACLE instance started.

Total System Global Area  835104768 bytes
Fixed Size		    2257840 bytes
Variable Size		  536874064 bytes
Database Buffers	  289406976 bytes
Redo Buffers		    6565888 bytes
Database mounted.
Database opened.
SQL> SELECT LOG_MODE, FORCE_LOGGING, NAME FROM V$DATABASE;

LOG_MODE     FOR NAME
------------ --- ---------
ARCHIVELOG   YES ASEM

SQL> ARCHIVE LOG LIST;
Database log mode	       Archive Mode
Automatic archival	       Enabled
Archive destination	       +ARC
Oldest online log sequence     2
Next log sequence to archive   4
Current log sequence	       4
SQL>