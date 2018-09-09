Clonning DB Different SID by RMAN and Recreate Controlfile
==========================================================
--1. Backup RMAN on source
nano /z02/backup/scripts/rmanfull.sh
====================================
#!/bin/sh
source /home/orekel/.bash_profile
/z01/app/orekel/product/12102/db_1/bin/rman target sys/orekel789 cmdfile=/z02/backup/scripts/rmanfull.rman log=/z02/backup/scripts/rmanfull_`date +%Y%m%d`.log

nano /z02/backup/scripts/rmanfull.rman
======================================
RUN{
  ALLOCATE CHANNEL BKP1 TYPE DISK;
  ALLOCATE CHANNEL BKP2 TYPE DISK;
  BACKUP AS COMPRESSED BACKUPSET FULL DATABASE TAG 'FULLBACKUP' FORMAT '/z02/backup/FULLBKP_%I_%d_%s_%p_%T.bkp';
  BACKUP AS COMPRESSED BACKUPSET CURRENT CONTROLFILE TAG 'Controlfile' FORMAT '/z02/backup/Ctrlfile_%I_%d_%s_%p_%T.bkp';
  BACKUP AS COMPRESSED BACKUPSET SPFILE TAG 'SPFile' FORMAT '/z02/backup/SPFile_%I_%d_%s_%p_%T.bkp';
  SQL 'ALTER SYSTEM SWITCH LOGFILE';
  BACKUP AS COMPRESSED BACKUPSET ARCHIVELOG ALL DELETE ALL INPUT TAG 'Archivelog' FORMAT '/z02/backup/Arc_%I_%d_%s_%p_%T.bkp';
  RELEASE CHANNEL BKP1;
  RELEASE CHANNEL BKP2;
  CROSSCHECK BACKUP;
  CROSSCHECK ARCHIVELOG ALL;
  DELETE NOPROMPT OBSOLETE RECOVERY WINDOW OF 14 DAYS;
  DELETE NOPROMPT EXPIRED BACKUP;
}

chmod +x /z02/backup/scripts/rmanfull.sh

nohup sh /z02/backup/scripts/rmanfull.sh >> /z02/backup/scripts/nohuprmanfull_`date +%Y%m%d`.log 2>&1 &

--2. Copy RMAN to target
scp -r /z02/backup orekel@jeruk.buah.net:/z02

--3. Restore DB in target
SQL> STARTUP NOMOUNT;
ORACLE instance started.

Total System Global Area  763363328 bytes
Fixed Size		    2929064 bytes
Variable Size		  532680280 bytes
Database Buffers	  222298112 bytes
Redo Buffers		    5455872 bytes
SQL>

[orekel@jeruk dbs]$ rlwrap rman target sys/orekel789

Recovery Manager: Release 12.1.0.2.0 - Production on Sun Apr 2 18:20:50 2017

Copyright (c) 1982, 2014, Oracle and/or its affiliates.  All rights reserved.

connected to target database: ORANGE (not mounted)

RMAN> restore controlfile from '/z02/restore/Ctrlfile_3525338189_ORANGE_5_1_20170402.bkp';

Starting restore at 02-APR-17
using target database control file instead of recovery catalog
allocated channel: ORA_DISK_1
channel ORA_DISK_1: SID=12 device type=DISK

channel ORA_DISK_1: restoring control file
channel ORA_DISK_1: restore complete, elapsed time: 00:00:01
output file name=/z02/control-orange/control01.ctl
output file name=/z01/app/orekel/fast_recovery_area/orange/control02.ctl
Finished restore at 02-APR-17

RMAN> STARTUP MOUNT;

database is already started
database mounted
released channel: ORA_DISK_1

RMAN> CATALOG START WITH '/z02/restore' NOPROMPT;

Starting implicit crosscheck backup at 02-APR-17
allocated channel: ORA_DISK_1
channel ORA_DISK_1: SID=12 device type=DISK
Crosschecked 4 objects
Finished implicit crosscheck backup at 02-APR-17

Starting implicit crosscheck copy at 02-APR-17
using channel ORA_DISK_1
Finished implicit crosscheck copy at 02-APR-17

searching for all files in the recovery area
cataloging files...
no files cataloged

searching for all files that match the pattern /z02/restore

List of Files Unknown to the Database
=====================================
File Name: /z02/restore/FULLBKP_3525338189_ORANGE_3_1_20170402.bkp
File Name: /z02/restore/FULLBKP_3525338189_ORANGE_4_1_20170402.bkp
File Name: /z02/restore/FULLBKP_3525338189_ORANGE_1_1_20170402.bkp
File Name: /z02/restore/SPFile_3525338189_ORANGE_6_1_20170402.bkp
File Name: /z02/restore/Arc_3525338189_ORANGE_8_1_20170402.bkp
File Name: /z02/restore/FULLBKP_3525338189_ORANGE_2_1_20170402.bkp
File Name: /z02/restore/scripts/nohuprmanfull_20170402.log
File Name: /z02/restore/scripts/rmanfull.rman
File Name: /z02/restore/scripts/rmanfull_20170402.log
File Name: /z02/restore/scripts/rmanfull.sh
File Name: /z02/restore/Ctrlfile_3525338189_ORANGE_5_1_20170402.bkp
File Name: /z02/restore/Arc_3525338189_ORANGE_7_1_20170402.bkp
cataloging files...
cataloging done

List of Cataloged Files
=======================
File Name: /z02/restore/FULLBKP_3525338189_ORANGE_3_1_20170402.bkp
File Name: /z02/restore/FULLBKP_3525338189_ORANGE_4_1_20170402.bkp
File Name: /z02/restore/FULLBKP_3525338189_ORANGE_1_1_20170402.bkp
File Name: /z02/restore/SPFile_3525338189_ORANGE_6_1_20170402.bkp
File Name: /z02/restore/Arc_3525338189_ORANGE_8_1_20170402.bkp
File Name: /z02/restore/FULLBKP_3525338189_ORANGE_2_1_20170402.bkp
File Name: /z02/restore/Ctrlfile_3525338189_ORANGE_5_1_20170402.bkp
File Name: /z02/restore/Arc_3525338189_ORANGE_7_1_20170402.bkp

List of Files Which Were Not Cataloged
=======================================
File Name: /z02/restore/scripts/nohuprmanfull_20170402.log
  RMAN-07517: Reason: The file header is corrupted
File Name: /z02/restore/scripts/rmanfull.rman
  RMAN-07517: Reason: The file header is corrupted
File Name: /z02/restore/scripts/rmanfull_20170402.log
  RMAN-07517: Reason: The file header is corrupted
File Name: /z02/restore/scripts/rmanfull.sh
  RMAN-07517: Reason: The file header is corrupted

RMAN> LIST BACKUP SUMMARY;


List of Backups
===============
Key     TY LV S Device Type Completion Time #Pieces #Copies Compressed Tag
------- -- -- - ----------- --------------- ------- ------- ---------- ---
5       B  F  A DISK        02-APR-17       1       2       YES        FULLBACKUP
6       B  F  A DISK        02-APR-17       1       2       YES        FULLBACKUP
7       B  F  A DISK        02-APR-17       1       2       YES        FULLBACKUP
8       B  F  A DISK        02-APR-17       1       1       YES        SPFILE
9       B  A  A DISK        02-APR-17       1       1       YES        ARCHIVELOG
10      B  F  A DISK        02-APR-17       1       2       YES        FULLBACKUP
11      B  F  A DISK        02-APR-17       1       1       YES        CONTROLFILE
12      B  A  A DISK        02-APR-17       1       1       YES        ARCHIVELOG

RUN{
 ALLOCATE CHANNEL BKP1 TYPE DISK;
 ALLOCATE CHANNEL BKP2 TYPE DISK;
 RESTORE DATABASE;
 RELEASE CHANNEL BKP1;
 RELEASE CHANNEL BKP2;
7> }

released channel: ORA_DISK_1
allocated channel: BKP1
channel BKP1: SID=12 device type=DISK

allocated channel: BKP2
channel BKP2: SID=249 device type=DISK

Starting restore at 02-APR-17

channel BKP1: starting datafile backup set restore
channel BKP1: specifying datafile(s) to restore from backup set
channel BKP1: restoring datafile 00001 to /z02/datafile-orange/system01.dbf
channel BKP1: restoring datafile 00004 to /z02/datafile-orange/undotbs01.dbf
channel BKP1: restoring datafile 00006 to /z02/datafile-orange/users01.dbf
channel BKP1: reading from backup piece /z02/restore/FULLBKP_3525338189_ORANGE_2_1_20170402.bkp
channel BKP2: starting datafile backup set restore
channel BKP2: specifying datafile(s) to restore from backup set
channel BKP2: restoring datafile 00003 to /z02/datafile-orange/sysaux01.dbf
channel BKP2: restoring datafile 00005 to /z02/datafile-orange/example01.dbf
channel BKP2: reading from backup piece /z02/restore/FULLBKP_3525338189_ORANGE_1_1_20170402.bkp
channel BKP2: piece handle=/z02/restore/FULLBKP_3525338189_ORANGE_1_1_20170402.bkp tag=FULLBACKUP
channel BKP2: restored backup piece 1
channel BKP2: restore complete, elapsed time: 00:01:16
channel BKP1: piece handle=/z02/restore/FULLBKP_3525338189_ORANGE_2_1_20170402.bkp tag=FULLBACKUP
channel BKP1: restored backup piece 1
channel BKP1: restore complete, elapsed time: 00:01:28
Finished restore at 02-APR-17

released channel: BKP1

released channel: BKP2

RMAN> RECOVER DATABASE;

Starting recover at 02-APR-17
allocated channel: ORA_DISK_1
channel ORA_DISK_1: SID=12 device type=DISK

starting media recovery

archived log for thread 1 with sequence 9 is already on disk as file /z01/app/orekel/fast_recovery_area/ORANGE/onlinelog/o1_mf_3_d7058vxv_.log
archived log for thread 1 with sequence 10 is already on disk as file /z01/app/orekel/fast_recovery_area/ORANGE/onlinelog/o1_mf_1_d7055y03_.log
archived log for thread 1 with sequence 11 is already on disk as file /z01/app/orekel/fast_recovery_area/ORANGE/onlinelog/o1_mf_2_d7056j62_.log
archived log file name=/z01/app/orekel/fast_recovery_area/ORANGE/onlinelog/o1_mf_3_d7058vxv_.log thread=1 sequence=9
archived log file name=/z01/app/orekel/fast_recovery_area/ORANGE/onlinelog/o1_mf_1_d7055y03_.log thread=1 sequence=10
archived log file name=/z01/app/orekel/fast_recovery_area/ORANGE/onlinelog/o1_mf_2_d7056j62_.log thread=1 sequence=11
media recovery complete, elapsed time: 00:00:02
Finished recover at 02-APR-17

RMAN> ALTER DATABASE OPEN RESETLOGS;

Statement processed

RMAN> EXIT


Recovery Manager complete.
[orekel@jeruk dbs]$

SQL> SELECT NAME,OPEN_MODE FROM V$DATABASE
  2  UNION ALL
  3  SELECT INSTANCE_NAME,STATUS FROM V$INSTANCE;

NAME		 OPEN_MODE
---------------- --------------------
ORANGE		 READ WRITE
orange		 OPEN

Elapsed: 00:00:00.06
SQL> SHU IMMEDIATE;
Database closed.
Database dismounted.
ORACLE instance shut down.
SQL>

--4. Backup controlfile and pfile
SQL> ALTER DATABASE BACKUP CONTROLFILE TO TRACE AS '/home/orekel/controlfile.sql';
SQL> create pfile='/home/orekel/initDEV.ora' from spfile;

File created.

Elapsed: 00:00:00.19
SQL>

nano /home/orekel/initDEV.ora
=============================
change audit_file_dest from /z01/app/orekel/admin/orange/adump to /z01/app/orekel/admin/DEV/adump
mkdir -p /z01/app/orekel/admin/DEV/adump
change /z02/control-orange/control01.ctl to /z02/control-DEV/control01.ctl
mkdir -p /z02/control-DEV
change /z01/app/orekel/fast_recovery_area/orange/control02.ctl to /z01/app/orekel/fast_recovery_area/DEV/control02.ctl
mkdir -p /z01/app/orekel/fast_recovery_area/DEV
change *.db_name='orange' to *.db_name='DEV'
add *.instance_name='DEV'

--5. Copy passwordfile
[orekel@jeruk ~]$ cd $ORACLE_HOME/dbs
[orekel@jeruk dbs]$ ls
hc_orange.dat  init.ora  lkORANGE  orapworange  snapcf_orange.f  spfileorange.ora
[orekel@jeruk dbs]$ cp orapworange orapwDEV
[orekel@jeruk dbs]$

--6. Change DB Name and SID
[orekel@jeruk dbs]$ source ~/DEVprofile.env
[orekel@jeruk dbs]$ env|grep ORA
ORACLE_UNQNAME=DEV
ORACLE_SID=DEV
ORACLE_BASE=/z01/app/orekel
ORACLE_HOSTNAME=jeruk.buah.net
ORACLE_HOME=/z01/app/orekel/product/12102/db_1
[orekel@jeruk dbs]$ rlwrap sqlplus SYS/orekel789 AS SYSDBA

SQL*Plus: Release 12.1.0.2.0 Production on Sun Apr 2 18:28:35 2017

Copyright (c) 1982, 2014, Oracle.  All rights reserved.

Connected to an idle instance.

SQL> STARTUP NOMOUNT PFILE='/home/orekel/initDEV.ora';
ORACLE instance started.

Total System Global Area  763363328 bytes
Fixed Size		    2929064 bytes
Variable Size		  578817624 bytes
Database Buffers	  176160768 bytes
Redo Buffers		    5455872 bytes
SQL>

vi /home/orekel/controlfile.sql
===============================
Take #2 Resetlogs
Delete recover because of shutdown immediate
Delete all remarks/comments

SQL> CREATE CONTROLFILE SET DATABASE "DEV" RESETLOGS NOARCHIVELOG
    MAXLOGFILES 16
    MAXLOGMEMBERS 3
    MAXDATAFILES 100
    MAXINSTANCES 8
    MAXLOGHISTORY 292
LOGFILE
  GROUP 1 '/z01/app/orekel/fast_recovery_area/ORANGE/onlinelog/o1_mf_1_d7055y03_.log'  SIZE 150M BLOCKSIZE 512,
  GROUP 2 '/z01/app/orekel/fast_recovery_area/ORANGE/onlinelog/o1_mf_2_d7056j62_.log'  SIZE 150M BLOCKSIZE 512,
  GROUP 3 '/z01/app/orekel/fast_recovery_area/ORANGE/onlinelog/o1_mf_3_d7058vxv_.log'  SIZE 150M BLOCKSIZE 512
DATAFILE
  '/z02/datafile-orange/system01.dbf',
  '/z02/datafile-orange/sysaux01.dbf',
  '/z02/datafile-orange/undotbs01.dbf',
  '/z02/datafile-orange/example01.dbf',
  '/z02/datafile-orange/users01.dbf'
CHARACTER SET WE8MSWIN1252;

Control file created.

Elapsed: 00:00:00.43
SQL> ALTER DATABASE OPEN RESETLOGS;

Database altered.

Elapsed: 00:00:12.06
SQL> ALTER TABLESPACE TEMP ADD TEMPFILE '/z02/datafile-orange/temp01.dbf' SIZE 62914560  REUSE AUTOEXTEND ON NEXT 8388608  MAXSIZE 15360M;

Tablespace altered.

Elapsed: 00:00:00.16
SQL> SELECT NAME,OPEN_MODE FROM V$DATABASE
UNION ALL
SELECT INSTANCE_NAME,STATUS FROM V$INSTANCE;

NAME		 OPEN_MODE
---------------- --------------------
DEV		 READ WRITE
DEV		 OPEN

Elapsed: 00:00:00.11
SQL> !lsnrctl start

LSNRCTL for Linux: Version 12.1.0.2.0 - Production on 02-APR-2017 18:32:26

Copyright (c) 1991, 2014, Oracle.  All rights reserved.

Starting /z01/app/orekel/product/12102/db_1/bin/tnslsnr: please wait...

TNSLSNR for Linux: Version 12.1.0.2.0 - Production
System parameter file is /z01/app/orekel/product/12102/db_1/network/admin/listener.ora
Log messages written to /z01/app/orekel/diag/tnslsnr/jeruk/listener/alert/log.xml
Listening on: (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=jeruk.buah.net)(PORT=1521)))
Listening on: (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=EXTPROC1521)))

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=jeruk.buah.net)(PORT=1521)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 12.1.0.2.0 - Production
Start Date                02-APR-2017 18:32:28
Uptime                    0 days 0 hr. 0 min. 0 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /z01/app/orekel/product/12102/db_1/network/admin/listener.ora
Listener Log File         /z01/app/orekel/diag/tnslsnr/jeruk/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=jeruk.buah.net)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=EXTPROC1521)))
The listener supports no services
The command completed successfully

SQL> !lsnrctl status

LSNRCTL for Linux: Version 12.1.0.2.0 - Production on 02-APR-2017 18:32:32

Copyright (c) 1991, 2014, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=jeruk.buah.net)(PORT=1521)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 12.1.0.2.0 - Production
Start Date                02-APR-2017 18:32:28
Uptime                    0 days 0 hr. 0 min. 4 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /z01/app/orekel/product/12102/db_1/network/admin/listener.ora
Listener Log File         /z01/app/orekel/diag/tnslsnr/jeruk/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=jeruk.buah.net)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=EXTPROC1521)))
The listener supports no services
The command completed successfully

SQL> ALTER SYSTEM REGISTER;

System altered.

Elapsed: 00:00:00.00
SQL> !lsnrctl status

LSNRCTL for Linux: Version 12.1.0.2.0 - Production on 02-APR-2017 18:32:36

Copyright (c) 1991, 2014, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=jeruk.buah.net)(PORT=1521)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 12.1.0.2.0 - Production
Start Date                02-APR-2017 18:32:28
Uptime                    0 days 0 hr. 0 min. 8 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /z01/app/orekel/product/12102/db_1/network/admin/listener.ora
Listener Log File         /z01/app/orekel/diag/tnslsnr/jeruk/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=jeruk.buah.net)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=EXTPROC1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcps)(HOST=jeruk.buah.net)(PORT=5500))(Security=(my_wallet_directory=/z01/app/orekel/admin/DEV/xdb_wallet))(Presentation=HTTP)(Session=RAW))
Services Summary...
Service "DEV.buah.net" has 1 instance(s).
  Instance "DEV", status READY, has 1 handler(s) for this service...
Service "orangeXDB.buah.net" has 1 instance(s).
  Instance "DEV", status READY, has 1 handler(s) for this service...
The command completed successfully

SQL>