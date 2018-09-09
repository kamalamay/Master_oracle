0000205: Flashback with Snapshot Standby SKN Database (only in Oracle 11g)
Description
Snapshot Standby Database help physical standby to open in READ-WRITE mode easily
A snapshot standby database is a fully update-able standby database that is created by converting a physical standby database into a snapshot standby database.

A snapshot Standby is open in the read-write mode and hence it is possible to process transactions independently of the primary database. At the same time, it maintains protection by continuing to receive data from the production database, archiving it for later use.
Using a single command change made while the database is in read-write mode can throw away the changes made to the standby database only and re-synchronize the standby database with the production database.
1. Snapshot standby database receives and archives, but does not apply the redo data.

2. Redo data received from the primary database is applied automatically once it is converted back into a physical standby database.

3. Snapshot standby database cannot be the target of a switchover or failover. A snapshot standby database must first be converted back into a physical standby database before performing a role transition to it.

 Steps to convert Physical Standby Database to the Snapshot Standby Database
I have 2 node primary cluster database and 2 node standby cluster database with the ASM. It is running on 11gR2
Note: In the snapshot standby database, there is no step to be performed in the primary database. 

===all the steps are performed only in the physical standby database===


==1. STATUS OF THE STANDBY DATABASE
SQL> SELECT NAME, OPEN_MODE FROM GV$DATABASE;

NAME OPEN_MODE
--------- --------------------
BHU MOUNTED
BHU MOUNTED

==2. CHECKING RECOVERY AREA AND ALLOCATE SIZE

SQL> SHOW PARAMETER DB_RECOV;

NAME TYPE VALUE
------------------------------------ ----------- -------------db_recovery_file_dest string +BHU_RECO
db_recovery_file_dest_size big integer 4G


==3. CHECKING WHETHER FLASHBACK IS ENABLED OR NOT. TO OPEN A STANDBY DATABASE IN THE READ/WRITE MODE, WE NEED TO HAVE THE FLASHBACK WITH ENOUGH SIZE.

SQL> SELECT FLASHBACK_ON FROM GV$DATABASE;

FLASHBACK_ON
------------------
YES
YES

==4. CHECKING THE STATUS OF RECOVERY PROCESS, IF IT IS ENABLED THEN WE HAVE TO STOP THE RECOVERY.

SQL> SELECT PROCESS, CLIENT_PROCESS, THREAD#, SEQUENCE#, BLOCK# FROM V$MANAGED_STANDBY WHERE PROCESS = 'MRP0' OR CLIENT_PROCESS='LGWR';

PROCESS CLIENT_P THREAD# SEQUENCE# BLOCK#
--------- -------- ---------- ---------- ----------
RFS LGWR 2 74 6080
MRP0 N/A 2 74 6078
RFS LGWR 1 78 7145

SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;

Database altered.


==5. AFTER CANCELING THE RECOVERY PROCESS, CHECK THE STATUS

SQL> SELECT PROCESS, CLIENT_PROCESS, THREAD#, SEQUENCE#, BLOCK# FROM V$MANAGED_STANDBY WHERE PROCESS = 'MRP0' OR CLIENT_PROCESS='LGWR';

PROCESS CLIENT_P THREAD# SEQUENCE# BLOCK#
--------- -------- ---------- ---------- ----------
RFS LGWR 2 74 6150
RFS LGWR 1 78 7216


==6. CONVERTING THE STANDBY DATABASE AS A SNAPSHOT STANDBY DATABASE

SQL> ALTER DATABASE CONVERT TO SNAPSHOT STANDBY;

Database altered.


==7. CHECKING THE STATUS OF THE DATABASE

SQL> SELECT OPEN_MODE, DATABASE_ROLE FROM GV$DATABASE;

OPEN_MODE DATABASE_ROLE
-------------------- ----------------
MOUNTED SNAPSHOT STANDBY
MOUNTED SNAPSHOT STANDBY


==8. NOW WE ARE STOPPING & STARTING THE DATABASE TO OPEN MODE

$ srvctl stop database -d SKNDRC
$ srvctl start database -d SKNDRC -o open

==9. CHECKING THE STATUS OF THE DATABASE

SQL> SELECT OPEN_MODE, DATABASE_ROLE FROM GV$DATABASE;

OPEN_MODE DATABASE_ROLE
-------------------- ----------------
READ WRITE SNAPSHOT STANDBY
READ WRITE SNAPSHOT STANDBY

==10. CHECKING THE SYSTEM CREATED THE RESTORE POINT

SQL> SELECT NAME, SCN, TIME FROM V$RESTORE_POINT;

NAME SCN
---------------------------------------------------------------------
TIME
---------------------------------------------------------------------
SNAPSHOT_STANDBY_REQUIRED_11/21/2011 10:48:00 20539509
21-NOV-11 10.48.00.000000000 AM






--> BACK TO NORMAL CONDITION ::


==1. NOW WE ARE STOPPING & CONVERTING SNAPSHOT DATABASE IN TO PHYSICAL STANDBY DATABASE

$ srvctl stop database -d SKNDRC

# I am using single instance to perform the conversion from the snapshot standby database to the physical standby database

$ sqlplus / as sysdba

SQL*Plus: Release 11.2.0.2.0 Production on Mon Nov 21 10:53:16 2011

Copyright (c) 1982, 2010, Oracle. All rights reserved.

Connected to an idle instance.

SQL> startup mount
ORA-32004: obsolete or deprecated parameter(s) specified for RDBMS instance
ORACLE instance started.

Total System Global Area 1.4431E+10 bytes
Fixed Size 2240272 bytes
Variable Size 3892314352 bytes
Database Buffers 1.0503E+10 bytes
Redo Buffers 34148352 bytes
Database mounted.

SQL> ALTER DATABASE CONVERT TO PHYSICAL STANDBY;

Database altered.

Once we convert from the snapshot standby database to the physical standby database, database will go to the no mount stage.


SQL> select open_mode,database_role from v$database;
select open_mode,database_role from v$database
                 *
ERROR at line 1:
ORA-01507: database not mounted


NOW WE ARE STOPPING & STARTING THE DATABASE TO MOUNT STAGE AND CHECKING THE RECOVERY PROCESS


$ srvctl stop database -d SKNDRC

$ srvctl start instance -d SKNDRC -i SKNDRC1 -o MOUNT


==2. CHECKING THE RESTORE POINT, SYSTEM WILL REMOVE IT AUTOMATICALLY ONCE WE ARE CONVERTED TO PHYSICAL STANDBY DATABASE

SQL> SELECT NAME, SCN, TIME FROM V$RESTORE_POINT;

no rows selected

==3. Aktifkan Real Time Apply
alter database recover managed standby database using current logfile disconnect;


==4. CHECKING THE RECOVERY PROCESS

SQL> SELECT PROCESS, CLIENT_PROCESS, THREAD#, SEQUENCE#, BLOCK# FROM V$MANAGED_STANDBY WHERE PROCESS = 'MRP0' OR CLIENT_PROCESS='LGWR';

PROCESS CLIENT_P THREAD# SEQUENCE# BLOCK#
--------- -------- ---------- ---------- ----------
RFS LGWR 2 83 3495
RFS LGWR 1 87 4407
MRP0 N/A 2 83 3495