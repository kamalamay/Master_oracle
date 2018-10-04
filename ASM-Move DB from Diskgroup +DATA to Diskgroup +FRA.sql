### Move Database from Diskgroup +DATA to Diskgroup +FRA ###
############################################################
Reference:
https://github.com/AzizPW/Oracle/blob/master/ResizeRedoLog.sql
https://docs.oracle.com/database/121/OSTMG/GUID-3B8D0956-0888-452D-A9E4-9FB8D98577E0.htm#OSTMG89997
https://docs.oracle.com/cd/B28359_01/server.111/b28310/onlineredo003.htm#ADMIN11320

## Identify size and location of datafiles, redo log, control files, tempfiles, and spfile
##########################################################################################
[orekel@iwak ~]$ . db_profile; rlwrap sqlplus / as sysdba

SQL*Plus: Release 12.2.0.1.0 Production on Thu Oct 4 10:33:50 2018

Copyright (c) 1982, 2016, Oracle.  All rights reserved.


Connected to:
Oracle Database 12c Enterprise Edition Release 12.2.0.1.0 - 64bit Production

--Total database size
SQL> --Total database size
SELECT /*+ PARALLEL(4)*/ 'Datafiles' "COMPONENTS", ROUND((SUM(BYTES))/1024/1024/1024, 2)DATAFILES_GB FROM DBA_DATA_FILES UNION ALL
SELECT /*+ PARALLEL(4)*/ 'Tempfiles' "COMPONENTS", ROUND((SUM(BYTES))/1024/1024/1024, 2)TEMPFILES_GB FROM DBA_TEMP_FILES UNION ALL
SELECT /*+ PARALLEL(4)*/ 'Redo Logs' "COMPONENTS", ROUND((SUM(BYTES))/1024/1024/1024, 2)REDO_GB FROM V$LOG UNION ALL
SELECT /*+ PARALLEL(4)*/ 'Stby Logs' "COMPONENTS", ROUND((SUM(BYTES))/1024/1024/1024, 2)REDO_GB FROM V$STANDBY_LOG UNION ALL
SELECT 'TOTAL' "COMPONENT", SUM(DATAFILES_GB)TOTAL_GB FROM(
SELECT /*+ PARALLEL(4)*/ 'Datafiles' "COMPONENTS", ROUND((SUM(BYTES))/1024/1024/1024, 2)DATAFILES_GB FROM DBA_DATA_FILES UNION ALL
SELECT /*+ PARALLEL(4)*/ 'Tempfiles' "COMPONENTS", ROUND((SUM(BYTES))/1024/1024/1024, 2)TEMPFILES_GB FROM DBA_TEMP_FILES UNION ALL
SELECT /*+ PARALLEL(4)*/ 'Redo Logs' "COMPONENTS", ROUND((SUM(BYTES))/1024/1024/1024, 2)REDO_GB FROM V$LOG UNION ALL
SELECT /*+ PARALLEL(4)*/ 'Stby Logs' "COMPONENTS", ROUND((SUM(BYTES))/1024/1024/1024, 2)REDO_GB FROM V$STANDBY_LOG);

COMPONENT DATAFILES_GB
--------- ------------
Datafiles	  1.33
Tempfiles	   .03
Redo Logs	   .59
Stby Logs
TOTAL		  1.95

Elapsed: 00:00:00.37
SQL> --Redo log information
SQL> COL MEMBER FOR A80;
SQL> SELECT * FROM V$LOGFILE ORDER BY 1,3,4;

    GROUP# STATUS     TYPE    MEMBER									       IS_     CON_ID
---------- ---------- ------- -------------------------------------------------------------------------------- --- ----------
	 1	      ONLINE  +DATA/BANDENG/ONLINELOG/group_1.263.968473483				       NO	    0
	 1	      ONLINE  +DATA/BANDENG/ONLINELOG/group_1.266.968473537				       YES	    0
	 2	      ONLINE  +DATA/BANDENG/ONLINELOG/group_2.264.968473485				       NO	    0
	 2	      ONLINE  +DATA/BANDENG/ONLINELOG/group_2.268.968473547				       YES	    0
	 3	      ONLINE  +DATA/BANDENG/ONLINELOG/group_3.265.968473485				       NO	    0
	 3	      ONLINE  +DATA/BANDENG/ONLINELOG/group_3.267.968473543				       YES	    0

6 rows selected.

Elapsed: 00:00:00.02
SQL> COL STATUS FOR A10;
SQL> SELECT GROUP#, THREAD#, SEQUENCE#, ROUND((BYTES/1024/1024),2)REDO_MB, MEMBERS, ARCHIVED, STATUS, FIRST_CHANGE# FROM V$LOG ORDER BY 1;

    GROUP#    THREAD#  SEQUENCE#    REDO_MB    MEMBERS ARC STATUS     FIRST_CHANGE#
---------- ---------- ---------- ---------- ---------- --- ---------- -------------
	 1	    1	       4	200	     2 YES INACTIVE	    1645594
	 2	    1	       5	200	     2 NO  CURRENT	    1645602
	 3	    1	       3	200	     2 YES INACTIVE	    1642647

Elapsed: 00:00:00.01
SQL> sho parameter pfile;

NAME				     TYPE	 VALUE
------------------------------------ ----------- ------------------------------
spfile				     string	 +DATA/BANDENG/PARAMETERFILE/spfile.270.968474557
SQL> COL NAME FOR A60;
SQL> SELECT NAME FROM V$CONTROLFILE;

NAME
------------------------------------------------------------
+DATA/BANDENG/CONTROLFILE/current.262.968473473
+DATA/BANDENG/CONTROLFILE/current.261.968473475

Elapsed: 00:00:00.00
SQL> COL TABLESPACE_NAME FOR A20;
COL FILE_ID FOR 9999;
COL FILE_NAME FOR A55;
COL AUTOEXTENSIBLE FOR A3;
COL OL FOR A10;
COL ENABLED FOR A15;
COL STATUS FOR A10;
SELECT * FROM (
  SELECT /*+ PARALLEL(8)*/
  TABLESPACE_NAME,FILE_ID,FILE_NAME,ROUND(VD.BYTES/1024/1024/1024,2)SIZE_GB,ROUND(MAXBYTES/1024/1024/1024,2)MAX_GB,AUTOEXTENSIBLE,DDF.STATUS,ONLINE_STATUS OL,VD.ENABLED
  FROM DBA_DATA_FILES DDF JOIN V$DATAFILE VD ON VD.NAME=DDF.FILE_NAME ORDER BY 1,2
)
UNION ALL
SELECT * FROM (
  SELECT /*+ PARALLEL(8)*/
  TABLESPACE_NAME,FILE_ID,FILE_NAME,ROUND(VT.BYTES/1024/1024/1024,2)SIZE_GB,ROUND(MAXBYTES/1024/1024/1024,2)MAX_GB,AUTOEXTENSIBLE,'',DTF.STATUS OL,VT.ENABLED
  FROM DBA_TEMP_FILES DTF JOIN V$TEMPFILE VT ON VT.NAME=DTF.FILE_NAME ORDER BY 1,2
);

TABLESPACE_NAME      FILE_ID FILE_NAME							SIZE_GB     MAX_GB AUT STATUS	  OL	     ENABLED
-------------------- ------- ------------------------------------------------------- ---------- ---------- --- ---------- ---------- ---------------
SYSAUX			   3 +DATA/BANDENG/DATAFILE/sysaux.258.968473329		    .48 	32 YES AVAILABLE  ONLINE     READ WRITE
SYSTEM			   1 +DATA/BANDENG/DATAFILE/system.257.968473211		    .79 	32 YES AVAILABLE  SYSTEM     READ WRITE
UNDOTBS1		   4 +DATA/BANDENG/DATAFILE/undotbs1.259.968473383		    .06 	32 YES AVAILABLE  ONLINE     READ WRITE
USERS			   7 +DATA/BANDENG/DATAFILE/users.260.968473385 		      0 	32 YES AVAILABLE  ONLINE     READ WRITE
TEMP			   1 +DATA/BANDENG/TEMPFILE/temp.269.968473617			    .03 	32 YES		  ONLINE     READ WRITE

Elapsed: 00:00:00.47
SQL>

## Identify ASM Disks
#####################
SQL> --ASM information
SQL> COL PATH FOR A50;
SQL> COL NAME FOR A20;
SQL> SELECT MOUNT_STATUS,HEADER_STATUS,STATE,ROUND(TOTAL_MB/1024,2)TOTAL_GB,ROUND(FREE_MB/1024,2)FREE_GB,NAME,PATH FROM V$ASM_DISK ORDER BY NAME;

MOUNT_S HEADER_STATU STATE	TOTAL_GB    FREE_GB NAME		 PATH
------- ------------ -------- ---------- ---------- -------------------- --------------------------------------------------
CACHED	MEMBER	     NORMAL	      10       8.54 DATA_0000		 /dev/oracleasm/DATA02_10G
CACHED	MEMBER	     NORMAL	      10       8.56 DATA_0001		 /dev/oracleasm/DATA01_10G
CACHED	MEMBER	     NORMAL	      10       8.56 DATA_0002		 /dev/oracleasm/DATA03_10G
CACHED	MEMBER	     NORMAL	      10       8.58 DATA_0003		 /dev/oracleasm/DATA04_10G
CACHED	MEMBER	     NORMAL	       5       4.91 FRA_0000		 /dev/oracleasm/FRA01_5G
CACHED	MEMBER	     NORMAL	       5       4.91 FRA_0001		 /dev/oracleasm/FRA02_5G
CACHED	MEMBER	     NORMAL	       5       4.92 FRA_0002		 /dev/oracleasm/FRA03_5G
CACHED	MEMBER	     NORMAL	       5       4.92 FRA_0003		 /dev/oracleasm/FRA04_5G

8 rows selected.

Elapsed: 00:00:00.21
SQL> SELECT NAME,TYPE,ROUND(TOTAL_MB/1024,2)TOTAL_GB,ROUND(FREE_MB/1024,2)FREE_GB,ROUND(USABLE_FILE_MB/1024,2)USABLE_FILE_GB,STATE,SECTOR_SIZE,BLOCK_SIZE
FROM V$ASM_DISKGROUP ORDER BY NAME;

NAME		     TYPE     TOTAL_GB	  FREE_GB USABLE_FILE_GB STATE	     SECTOR_SIZE BLOCK_SIZE
-------------------- ------ ---------- ---------- -------------- ----------- ----------- ----------
DATA		     NORMAL	 39.98	    34.24	   12.12 CONNECTED	     512       4096
FRA		     NORMAL	 19.98	    19.66	    7.33 MOUNTED	     512       4096

Elapsed: 00:00:00.08
SQL> COL PATH FOR A40;
COL ASMDISK FOR A15;
COL DISKGROUP FOR A10;
SELECT DG.NAME DISKGROUP,DG.TYPE,D.NAME ASMDISK,D.PATH,ROUND(D.TOTAL_MB/1024,2)TOTAL_GB,ROUND(D.FREE_MB/1024,2)FREE_GB,
D.VOTING_FILE,DG.SECTOR_SIZE,DG.BLOCK_SIZE FROM V$ASM_DISKGROUP DG JOIN V$ASM_DISK D ON DG.GROUP_NUMBER=D.GROUP_NUMBER ORDER BY 3;

DISKGROUP  TYPE   ASMDISK	  PATH					     TOTAL_GB	 FREE_GB V SECTOR_SIZE BLOCK_SIZE
---------- ------ --------------- ---------------------------------------- ---------- ---------- - ----------- ----------
DATA	   NORMAL DATA_0000	  /dev/oracleasm/DATA02_10G			   10	    8.54 N	   512	     4096
DATA	   NORMAL DATA_0001	  /dev/oracleasm/DATA01_10G			   10	    8.56 N	   512	     4096
DATA	   NORMAL DATA_0002	  /dev/oracleasm/DATA03_10G			   10	    8.56 N	   512	     4096
DATA	   NORMAL DATA_0003	  /dev/oracleasm/DATA04_10G			   10	    8.58 N	   512	     4096
FRA	   NORMAL FRA_0000	  /dev/oracleasm/FRA01_5G			    5	    4.91 N	   512	     4096
FRA	   NORMAL FRA_0001	  /dev/oracleasm/FRA02_5G			    5	    4.91 N	   512	     4096
FRA	   NORMAL FRA_0002	  /dev/oracleasm/FRA03_5G			    5	    4.92 N	   512	     4096
FRA	   NORMAL FRA_0003	  /dev/oracleasm/FRA04_5G			    5	    4.92 N	   512	     4096

8 rows selected.

Elapsed: 00:00:00.09
SQL> exit
Disconnected from Oracle Database 12c Enterprise Edition Release 12.2.0.1.0 - 64bit Production

## Identify configuration of database in cluster or High Availability Service
#############################################################################
[orekel@iwak ~]$ srvctl config database -db bandeng
Database unique name: BANDENG
Database name: BANDENG
Oracle home: /z02/app/orekel/product/12.2.0.1/db1
Oracle user: orekel
Spfile: +DATA/BANDENG/PARAMETERFILE/spfile.270.968474557
Password file: 
Domain: centos.org
Start options: open
Stop options: immediate
Database role: PRIMARY
Management policy: AUTOMATIC
Disk Groups: DATA
Services: 
OSDBA group: 
OSOPER group: 
Database instance: BANDENG
[orekel@iwak ~]$

## Move spfile from +DATA to +FRA
#################################
SQL> create pfile='/home/orekel/initBANDENG.ora' from spfile;

File created.

Elapsed: 00:00:00.14
SQL> create spfile='+FRA' from pfile='/home/orekel/initBANDENG.ora';

File created.

Elapsed: 00:00:00.66
SQL> exit
Disconnected from Oracle Database 12c Enterprise Edition Release 12.2.0.1.0 - 64bit Production
[orekel@iwak ~]$ srvctl stop database -db bandeng
[orekel@iwak ~]$ . grid_profile; rlwrap asmcmd
ASMCMD> cd +FRA
ASMCMD> ls -l
Type  Redund  Striped  Time             Sys  Name
                                        Y    BANDENG/
ASMCMD> cd BANDENG
ASMCMD> ls -l
Type  Redund  Striped  Time             Sys  Name
                                        Y    AUTOBACKUP/
                                        Y    PARAMETERFILE/
ASMCMD> ls -l PARAMETERFILE
Type           Redund  Striped  Time             Sys  Name
PARAMETERFILE  MIRROR  COARSE   OCT 04 10:00:00  Y    spfile.257.988627741
ASMCMD> exit
[orekel@iwak ~]$ . db_profile; srvctl modify database -db bandeng -help

Modifies the configuration for the database.

Usage: srvctl modify database -db <db_unique_name> [-dbname <db_name>] [-instance <inst_name>] [-oraclehome <oracle_home>] [-user <oracle_user>] [-domain <domain>] [-spfile <spfile>] [-pwfile <password_file_path>] [-role {PRIMARY | PHYSICAL_STANDBY | LOGICAL_STANDBY | SNAPSHOT_STANDBY}] [-startoption <start_options>] [-stopoption <stop_options>] [-policy {AUTOMATIC | MANUAL | NORESTART}] [-diskgroup "<diskgroup_list>"|-nodiskgroup] [-force]
    -db <db_unique_name>           Unique name for the database
    -dbname <db_name>              Database name (DB_NAME), if different from the unique name given by the -db option
    -instance <inst_name>          Instance name
    -oraclehome <path>             Oracle home path
    -user <oracle_user>            Oracle user
    -domain <domain>               Domain for database. Must be set if database has DB_DOMAIN set.
    -spfile <spfile>               Server parameter file path
    -pwfile <password_file_path>   Password file path
    -role <role>                   Role of the database (PRIMARY, PHYSICAL_STANDBY, LOGICAL_STANDBY, SNAPSHOT_STANDBY)
    -startoption <start_options>   Startup options for the database. Examples of startup options are OPEN, MOUNT, or "READ ONLY".
    -stopoption <stop_options>     Stop options for the database. Examples of shutdown options are NORMAL, TRANSACTIONAL, IMMEDIATE, or ABORT.
    -policy <dbpolicy>             Management policy for the database (AUTOMATIC, MANUAL, or NORESTART)
    -diskgroup "<diskgroup_list>"  Comma separated list of disk group names
    -nodiskgroup                   To remove database''s dependency upon disk groups
    -force                         Force the modify operation to stop database and service resources on some nodes as necessary, or to change management policy of all service to match new database management policy
    -verbose                       Verbose output
    -help                          Print usage
[orekel@iwak ~]$ srvctl config database -db bandeng 
Database unique name: BANDENG
Database name: BANDENG
Oracle home: /z02/app/orekel/product/12.2.0.1/db1
Oracle user: orekel
Spfile: +FRA/BANDENG/PARAMETERFILE/spfile.257.988627741
Password file: 
Domain: centos.org
Start options: open
Stop options: immediate
Database role: PRIMARY
Management policy: AUTOMATIC
Disk Groups: DATA,FRA
Services: 
OSDBA group: 
OSOPER group: 
Database instance: BANDENG
[orekel@iwak ~]$ srvctl modify database -db bandeng -spfile +FRA/BANDENG/PARAMETERFILE/spfile.257.988627741
[orekel@iwak ~]$ srvctl config database -db bandeng 
Database unique name: BANDENG
Database name: BANDENG
Oracle home: /z02/app/orekel/product/12.2.0.1/db1
Oracle user: orekel
Spfile: +FRA/BANDENG/PARAMETERFILE/spfile.257.988627741
Password file: 
Domain: centos.org
Start options: open
Stop options: immediate
Database role: PRIMARY
Management policy: AUTOMATIC
Disk Groups: DATA,FRA
Services: 
OSDBA group: 
OSOPER group: 
Database instance: BANDENG

## Move controlfiles from +DATA to +FRA
#######################################
[orekel@iwak ~]$ srvctl stop database -db bandeng
[orekel@iwak ~]$ rlwrap rman target=/

Recovery Manager: Release 12.2.0.1.0 - Production on Thu Oct 4 11:15:15 2018

Copyright (c) 1982, 2017, Oracle and/or its affiliates.  All rights reserved.

connected to target database (not started)

RMAN> STARTUP NOMOUNT;

Oracle instance started

Total System Global Area    1191182336 bytes

Fixed Size                     8620032 bytes
Variable Size                855640064 bytes
Database Buffers             318767104 bytes
Redo Buffers                   8155136 bytes

RMAN> RESTORE CONTROLFILE TO '+FRA/BANDENG/CONTROLFILE/Current.261.968473475' FROM '+DATA/BANDENG/CONTROLFILE/Current.261.968473475';

Starting restore at 04-Oct-18 11:16:23
using target database control file instead of recovery catalog
allocated channel: ORA_DISK_1
channel ORA_DISK_1: SID=258 device type=DISK

channel ORA_DISK_1: copied control file copy
Finished restore at 04-Oct-18 11:16:25

RMAN> RESTORE CONTROLFILE TO '+FRA/BANDENG/CONTROLFILE/Current.262.968473473' FROM '+DATA/BANDENG/CONTROLFILE/Current.262.968473473';

Starting restore at 04-Oct-18 11:17:06
using channel ORA_DISK_1

channel ORA_DISK_1: copied control file copy
Finished restore at 04-Oct-18 11:17:07

RMAN> SHUTDOWN IMMEDIATE;

Oracle instance shut down

RMAN> exit


Recovery Manager complete.
[orekel@iwak ~]$ . grid_profile; rlwrap asmcmd
ASMCMD> ls -l +FRA/BANDENG/CONTROLFILE
Type         Redund  Striped  Time             Sys  Name
CONTROLFILE  HIGH    FINE     OCT 04 11:00:00  Y    current.259.988629385
CONTROLFILE  HIGH    FINE     OCT 04 11:00:00  Y    current.260.988629427
ASMCMD> exit

## Startup DB and failed because of invalid controlfile
#######################################################
[orekel@iwak ~]$ . db_profile; srvctl start database -db bandeng
PRCR-1079 : Failed to start resource ora.bandeng.db
CRS-5017: The resource action "ora.bandeng.db start" encountered the following error: 
ORA-00205: error in identifying control file, check alert log for more info
. For details refer to "(:CLSN00107:)" in "/z02/app/orekel/diag/crs/iwak/crs/trace/ohasd_oraagent_orekel.trc".

CRS-2674: Start of 'ora.bandeng.db' on 'iwak' failed
[orekel@iwak ~]$ rlwrap sqlplus / as sysdba

SQL*Plus: Release 12.2.0.1.0 Production on Thu Oct 4 11:21:08 2018

Copyright (c) 1982, 2016, Oracle.  All rights reserved.

Connected to an idle instance.

SQL> STARTUP NOMOUNT;
ORACLE instance started.

Total System Global Area 1191182336 bytes
Fixed Size		    8620032 bytes
Variable Size		  855640064 bytes
Database Buffers	  318767104 bytes
Redo Buffers		    8155136 bytes
SQL> SHO PARAMETER CONTROL_F

NAME				     TYPE	 VALUE
------------------------------------ ----------- ------------------------------
control_file_record_keep_time	     integer	 60
control_files			     string	 +FRA/BANDENG/CONTROLFILE/current.262.968473473, +FRA/BANDENG/CONTROLFILE/current.261.968473475
SQL> ALTER SYSTEM SET control_files='+FRA/BANDENG/CONTROLFILE/current.259.988629385','+FRA/BANDENG/CONTROLFILE/current.260.988629427' SCOPE=SPFILE;

System altered.

Elapsed: 00:00:00.04
SQL> SHU IMMEDIATE;
ORA-01507: database not mounted


ORACLE instance shut down.
SQL> exit
Disconnected from Oracle Database 12c Enterprise Edition Release 12.2.0.1.0 - 64bit Production

## Startup DB and ensure controlfiles are correct
#################################################
[orekel@iwak ~]$ . db_profile; srvctl start database -db bandeng
[orekel@iwak ~]$ rlwrap sqlplus / as sysdba

SQL*Plus: Release 12.2.0.1.0 Production on Thu Oct 4 11:24:13 2018

Copyright (c) 1982, 2016, Oracle.  All rights reserved.


Connected to:
Oracle Database 12c Enterprise Edition Release 12.2.0.1.0 - 64bit Production

SQL> SELECT NAME FROM V$CONTROLFILE;

NAME
----------------------------------------------------------------------------------------------------------------------------------------------------------------
+FRA/BANDENG/CONTROLFILE/current.259.988629385
+FRA/BANDENG/CONTROLFILE/current.260.988629427

Elapsed: 00:00:00.01
SQL> exit
Disconnected from Oracle Database 12c Enterprise Edition Release 12.2.0.1.0 - 64bit Production

## Move database files from +DATA to +FRA
#########################################
[orekel@iwak ~]$ . db_profile; srvctl stop database -db bandeng
[orekel@iwak ~]$ rman target=/

Recovery Manager: Release 12.2.0.1.0 - Production on Thu Oct 4 11:26:22 2018

Copyright (c) 1982, 2017, Oracle and/or its affiliates.  All rights reserved.

connected to target database (not started)

RMAN> STARTUP MOUNT;

Oracle instance started
database mounted

Total System Global Area    1191182336 bytes

Fixed Size                     8620032 bytes
Variable Size                855640064 bytes
Database Buffers             318767104 bytes
Redo Buffers                   8155136 bytes

RMAN> CONFIGURE DEVICE TYPE DISK PARALLELISM 2;

using target database control file instead of recovery catalog
new RMAN configuration parameters:
CONFIGURE DEVICE TYPE DISK PARALLELISM 2 BACKUP TYPE TO BACKUPSET;
new RMAN configuration parameters are successfully stored

RMAN> RUN{           
2> BACKUP AS COPY DATABASE FORMAT '+FRA';
3> }

Starting backup at 04-Oct-18 11:29:47
allocated channel: ORA_DISK_1
channel ORA_DISK_1: SID=261 device type=DISK
allocated channel: ORA_DISK_2
channel ORA_DISK_2: SID=28 device type=DISK
channel ORA_DISK_1: starting datafile copy
input datafile file number=00001 name=+DATA/BANDENG/DATAFILE/system.257.968473211
channel ORA_DISK_2: starting datafile copy
input datafile file number=00003 name=+DATA/BANDENG/DATAFILE/sysaux.258.968473329
output file name=+FRA/BANDENG/DATAFILE/system.261.988630189 tag=TAG20181004T112948 RECID=2 STAMP=988630264
channel ORA_DISK_1: datafile copy complete, elapsed time: 00:01:21
channel ORA_DISK_1: starting datafile copy
input datafile file number=00004 name=+DATA/BANDENG/DATAFILE/undotbs1.259.968473383
output file name=+FRA/BANDENG/DATAFILE/sysaux.262.988630189 tag=TAG20181004T112948 RECID=1 STAMP=988630255
channel ORA_DISK_2: datafile copy complete, elapsed time: 00:01:20
channel ORA_DISK_2: starting datafile copy
input datafile file number=00007 name=+DATA/BANDENG/DATAFILE/users.260.968473385
output file name=+FRA/BANDENG/DATAFILE/undotbs1.263.988630269 tag=TAG20181004T112948 RECID=3 STAMP=988630272
channel ORA_DISK_1: datafile copy complete, elapsed time: 00:00:04
output file name=+FRA/BANDENG/DATAFILE/users.264.988630273 tag=TAG20181004T112948 RECID=4 STAMP=988630272
channel ORA_DISK_2: datafile copy complete, elapsed time: 00:00:01
Finished backup at 04-Oct-18 11:31:13

Starting Control File and SPFILE Autobackup at 04-Oct-18 11:31:13
piece handle=+FRA/BANDENG/AUTOBACKUP/2018_10_04/s_988629918.265.988630275 comment=NONE
Finished Control File and SPFILE Autobackup at 04-Oct-18 11:31:14

RMAN> SWITCH DATABASE TO COPY;

datafile 1 switched to datafile copy "+FRA/BANDENG/DATAFILE/system.261.988630189"
datafile 3 switched to datafile copy "+FRA/BANDENG/DATAFILE/sysaux.262.988630189"
datafile 4 switched to datafile copy "+FRA/BANDENG/DATAFILE/undotbs1.263.988630269"
datafile 7 switched to datafile copy "+FRA/BANDENG/DATAFILE/users.264.988630273"

RMAN> REPORT SCHEMA;

Report of database schema for database with db_unique_name BANDENG

List of Permanent Datafiles
===========================
File Size(MB) Tablespace           RB segs Datafile Name
---- -------- -------------------- ------- ------------------------
1    810      SYSTEM               ***     +FRA/BANDENG/DATAFILE/system.261.988630189
3    490      SYSAUX               ***     +FRA/BANDENG/DATAFILE/sysaux.262.988630189
4    65       UNDOTBS1             ***     +FRA/BANDENG/DATAFILE/undotbs1.263.988630269
7    5        USERS                ***     +FRA/BANDENG/DATAFILE/users.264.988630273

List of Temporary Files
=======================
File Size(MB) Tablespace           Maxsize(MB) Tempfile Name
---- -------- -------------------- ----------- --------------------
1    32       TEMP                 32767       +DATA/BANDENG/TEMPFILE/temp.269.968473617

RMAN> SQL 'ALTER DATABASE OPEN';

sql statement: ALTER DATABASE OPEN

RMAN> exit


Recovery Manager complete.

## Change parameter db_create_file_dest from +DATA to +FRA
##########################################################
[orekel@iwak ~]$ . db_profile; rlwrap sqlplus / as sysdba

SQL*Plus: Release 12.2.0.1.0 Production on Thu Oct 4 11:35:57 2018

Copyright (c) 1982, 2016, Oracle.  All rights reserved.


Connected to:
Oracle Database 12c Enterprise Edition Release 12.2.0.1.0 - 64bit Production

SQL> sho parameter create

NAME				     TYPE	 VALUE
------------------------------------ ----------- ------------------------------
create_bitmap_area_size 	     integer	 8388608
create_stored_outlines		     string
db_create_file_dest		     string	 +DATA
db_create_online_log_dest_1	     string
db_create_online_log_dest_2	     string
db_create_online_log_dest_3	     string
db_create_online_log_dest_4	     string
db_create_online_log_dest_5	     string
SQL> ALTER SYSTEM SET db_create_file_dest='+FRA';

System altered.

Elapsed: 00:00:00.07
SQL> sho parameter create

NAME				     TYPE	 VALUE
------------------------------------ ----------- ------------------------------
create_bitmap_area_size 	     integer	 8388608
create_stored_outlines		     string
db_create_file_dest		     string	 +FRA
db_create_online_log_dest_1	     string
db_create_online_log_dest_2	     string
db_create_online_log_dest_3	     string
db_create_online_log_dest_4	     string
db_create_online_log_dest_5	     string

## Move tempfile from +DATA to +FRA
###################################
SQL> SELECT NAME FROM V$TEMPFILE;

NAME
----------------------------------------------------------------------------------------------------------------------------------------------------------------
+DATA/BANDENG/TEMPFILE/temp.269.968473617

Elapsed: 00:00:00.01
SQL> EXIT
Disconnected from Oracle Database 12c Enterprise Edition Release 12.2.0.1.0 - 64bit Production
[orekel@iwak ~]$ . db_profile; srvctl stop database -db bandeng
[orekel@iwak ~]$ . db_profile; srvctl start database -db bandeng -o mount
[orekel@iwak ~]$ rlwrap rman target=/

Recovery Manager: Release 12.2.0.1.0 - Production on Thu Oct 4 11:41:47 2018

Copyright (c) 1982, 2017, Oracle and/or its affiliates.  All rights reserved.

connected to target database: BANDENG (DBID=4201625281, not open)

RMAN> RUN{
2> SET NEWNAME FOR TEMPFILE 1 TO '+FRA';
3> SWITCH TEMPFILE ALL;
4> }

executing command: SET NEWNAME

using target database control file instead of recovery catalog
renamed tempfile 1 to +FRA in control file

RMAN> SQL 'ALTER DATABASE OPEN';

sql statement: ALTER DATABASE OPEN

RMAN> EXIT


Recovery Manager complete.
[orekel@iwak ~]$ . db_profile; rlwrap sqlplus / as sysdba

SQL*Plus: Release 12.2.0.1.0 Production on Thu Oct 4 11:44:19 2018

Copyright (c) 1982, 2016, Oracle.  All rights reserved.


Connected to:
Oracle Database 12c Enterprise Edition Release 12.2.0.1.0 - 64bit Production

SQL> COL TABLESPACE_NAME FOR A20;
COL FILE_ID FOR 9999;
COL FILE_NAME FOR A55;
COL AUTOEXTENSIBLE FOR A3;
COL OL FOR A10;
COL ENABLED FOR A15;
COL STATUS FOR A10;
SELECT * FROM (
  SELECT /*+ PARALLEL(8)*/
  TABLESPACE_NAME,FILE_ID,FILE_NAME,ROUND(VD.BYTES/1024/1024/1024,2)SIZE_GB,ROUND(MAXBYTES/1024/1024/1024,2)MAX_GB,AUTOEXTENSIBLE,DDF.STATUS,ONLINE_STATUS OL,VD.ENABLED
  FROM DBA_DATA_FILES DDF JOIN V$DATAFILE VD ON VD.NAME=DDF.FILE_NAME ORDER BY 1,2
)
UNION ALL
SELECT * FROM (
  SELECT /*+ PARALLEL(8)*/
  TABLESPACE_NAME,FILE_ID,FILE_NAME,ROUND(VT.BYTES/1024/1024/1024,2)SIZE_GB,ROUND(MAXBYTES/1024/1024/1024,2)MAX_GB,AUTOEXTENSIBLE,'',DTF.STATUS OL,VT.ENABLED
  FROM DBA_TEMP_FILES DTF JOIN V$TEMPFILE VT ON VT.NAME=DTF.FILE_NAME ORDER BY 1,2
);

TABLESPACE_NAME      FILE_ID FILE_NAME							SIZE_GB     MAX_GB AUT STATUS	  OL	     ENABLED
-------------------- ------- ------------------------------------------------------- ---------- ---------- --- ---------- ---------- ---------------
SYSAUX			   3 +FRA/BANDENG/DATAFILE/sysaux.262.988630189 		    .48 	32 YES AVAILABLE  ONLINE     READ WRITE
SYSTEM			   1 +FRA/BANDENG/DATAFILE/system.261.988630189 		    .79 	32 YES AVAILABLE  SYSTEM     READ WRITE
UNDOTBS1		   4 +FRA/BANDENG/DATAFILE/undotbs1.263.988630269		    .06 	32 YES AVAILABLE  ONLINE     READ WRITE
USERS			   7 +FRA/BANDENG/DATAFILE/users.264.988630273			      0 	32 YES AVAILABLE  ONLINE     READ WRITE
TEMP			   1 +FRA/BANDENG/TEMPFILE/temp.266.988631015			    .03 	32 YES		  ONLINE     READ WRITE

Elapsed: 00:00:00.82

## Recreate redologs in +FRA
############################
SQL> --Redo log information
SQL> COL MEMBER FOR A80;
SQL> SELECT * FROM V$LOGFILE ORDER BY 1,3,4;

    GROUP# STATUS     TYPE    MEMBER									       IS_     CON_ID
---------- ---------- ------- -------------------------------------------------------------------------------- --- ----------
	 1	      ONLINE  +DATA/BANDENG/ONLINELOG/group_1.263.968473483				       NO	    0
	 1	      ONLINE  +DATA/BANDENG/ONLINELOG/group_1.266.968473537				       YES	    0
	 2	      ONLINE  +DATA/BANDENG/ONLINELOG/group_2.264.968473485				       NO	    0
	 2	      ONLINE  +DATA/BANDENG/ONLINELOG/group_2.268.968473547				       YES	    0
	 3	      ONLINE  +DATA/BANDENG/ONLINELOG/group_3.265.968473485				       NO	    0
	 3	      ONLINE  +DATA/BANDENG/ONLINELOG/group_3.267.968473543				       YES	    0

6 rows selected.

Elapsed: 00:00:00.02
SQL> COL STATUS FOR A10;
SQL> SELECT GROUP#, THREAD#, SEQUENCE#, ROUND((BYTES/1024/1024),2)REDO_MB, MEMBERS, ARCHIVED, STATUS, FIRST_CHANGE# FROM V$LOG ORDER BY 1;

    GROUP#    THREAD#  SEQUENCE#    REDO_MB    MEMBERS ARC STATUS     FIRST_CHANGE#
---------- ---------- ---------- ---------- ---------- --- ---------- -------------
	 1	    1	       4	200	     2 YES INACTIVE	    1645594
	 2	    1	       5	200	     2 NO  CURRENT	    1645602
	 3	    1	       3	200	     2 YES INACTIVE	    1642647

Elapsed: 00:00:00.01
SQL> ALTER DATABASE DROP LOGFILE GROUP 1;

Database altered.

Elapsed: 00:00:00.22
SQL> ALTER DATABASE ADD LOGFILE GROUP 1 ('+FRA') SIZE 200M;

Database altered.

Elapsed: 00:00:02.50
SQL> ALTER DATABASE DROP LOGFILE GROUP 3;

Database altered.

Elapsed: 00:00:00.06
SQL> ALTER DATABASE ADD LOGFILE GROUP 3 ('+FRA') SIZE 200M;

Database altered.

Elapsed: 00:00:02.40
SQL> SELECT GROUP#, THREAD#, SEQUENCE#, ROUND((BYTES/1024/1024),2)REDO_MB, MEMBERS, ARCHIVED, STATUS, FIRST_CHANGE# FROM V$LOG ORDER BY 1;

    GROUP#    THREAD#  SEQUENCE#    REDO_MB    MEMBERS ARC STATUS     FIRST_CHANGE#
---------- ---------- ---------- ---------- ---------- --- ---------- -------------
	 1	    1	       0	200	     1 YES UNUSED		  0
	 2	    1	       5	200	     2 NO  CURRENT	    1645602
	 3	    1	       0	200	     1 YES UNUSED		  0

Elapsed: 00:00:00.00
SQL> ALTER SYSTEM CHECKPOINT GLOBAL;

System altered.

Elapsed: 00:00:00.03
SQL> ALTER SYSTEM SWITCH LOGFILE;

System altered.

Elapsed: 00:00:00.01
SQL> SELECT GROUP#, THREAD#, SEQUENCE#, ROUND((BYTES/1024/1024),2)REDO_MB, MEMBERS, ARCHIVED, STATUS, FIRST_CHANGE# FROM V$LOG ORDER BY 1;

    GROUP#    THREAD#  SEQUENCE#    REDO_MB    MEMBERS ARC STATUS     FIRST_CHANGE#
---------- ---------- ---------- ---------- ---------- --- ---------- -------------
	 1	    1	       6	200	     1 NO  CURRENT	    1702033
	 2	    1	       5	200	     2 NO  INACTIVE	    1645602
	 3	    1	       0	200	     1 YES UNUSED		  0

Elapsed: 00:00:00.06
SQL> ALTER DATABASE DROP LOGFILE GROUP 2;

Database altered.

Elapsed: 00:00:00.07
SQL> ALTER DATABASE ADD LOGFILE GROUP 2 ('+FRA') SIZE 200M;

Database altered.

Elapsed: 00:00:03.08
SQL> SELECT * FROM V$LOGFILE ORDER BY 1,3,4;

    GROUP# STATUS     TYPE    MEMBER									       IS_     CON_ID
---------- ---------- ------- -------------------------------------------------------------------------------- --- ----------
	 1	      ONLINE  +FRA/BANDENG/ONLINELOG/group_1.267.988631803				       NO	    0
	 2	      ONLINE  +FRA/BANDENG/ONLINELOG/group_2.270.988632051				       NO	    0
	 3	      ONLINE  +FRA/BANDENG/ONLINELOG/group_3.268.988631835				       NO	    0

Elapsed: 00:00:00.01
SQL> SELECT GROUP#, THREAD#, SEQUENCE#, ROUND((BYTES/1024/1024),2)REDO_MB, MEMBERS, ARCHIVED, STATUS, FIRST_CHANGE# FROM V$LOG ORDER BY 1;

    GROUP#    THREAD#  SEQUENCE#    REDO_MB    MEMBERS ARC STATUS     FIRST_CHANGE#
---------- ---------- ---------- ---------- ---------- --- ---------- -------------
	 1	    1	       6	200	     1 NO  CURRENT	    1702033
	 2	    1	       0	200	     1 YES UNUSED		  0
	 3	    1	       0	200	     1 YES UNUSED		  0

Elapsed: 00:00:00.01
SQL> EXIT;