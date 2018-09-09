STEP BY STEP RAC CLONING WITH ASM

http://dba-sansar.blogspot.com/2011/08/step-by-step-rac-cloning-with-asm.html

Assumtion: Source Server: svloradb1, DB: SVLDB, SID: SVLDB1, SVLDB2, port: 1521

Target Server: svloradb2, DB: SVLSTDBY, SID: SVLSTDBY1, SVLSTDBY2, port: 1521

1) Ensure that you have latest backup taken at the source database

export ORACLE_SID=SVLDB1
export NLS_LANG=american
export NLS_DATE_FORMAT='Mon DD YYYY HH24:MI:SS'
Make a note of the finish time. This time required later.
Finished backup Aug 15 2011 23:00:32 (make sure to capture archivelog finish time)


RMAN> run {
 allocate channel ch1 type disk;
 backup database format '/home/oracle/rman_bkup/full_hot_bkup_%t_%s_%d';
 backup current controlfile format '/home/oracle/rman_bkup/ctrl_bkup_%t_%s_%d';
 sql 'alter system archive log current';
 backup archivelog all format '/home/oracle/rman_bkup/arch_bkup_%s_%t_%d';
 release channel ch1;
 }

Above backup shuld be available at the target server at the same location as source.

2)Make sure you create a backup directory on both source and target for rman

/home/oracle/rman_bkup

3) Create and copy tnsnames entry of target to the source

the following is the tnsnames.ora entry of target that i am copying it to the source.

SVLSTANDBY =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = svloradb2-vip.localdomain)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = SVLSTDBY)
      (INSTANCE_NAME = SVLSTDBY1)
    )
  )

4) Create Listener on the target server

LISTENER_SVLORADB2 =
  (DESCRIPTION_LIST =
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1))
      (ADDRESS = (PROTOCOL = TCP)(HOST = svloradb2-vip.localdomain)(PORT = 1522)(IP = FIRST))
      (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.1.75)(PORT = 1522)(IP = FIRST))
    )
  )

SID_LIST_LISTENER_SVLORADB2 =
  (SID_LIST =
    (SID_DESC =
      (GLOBAL_DBNAME = SVLSTDBY)
      (ORACLE_HOME = /u01/app/oracle/product/10.2.0/db_1)
      (SID_NAME = SVLSTDBY1)
    )
  )

5) Start Listener on the target server

LSNRCTL START LISTENER_SVLORADB2

7) Create pfile on Source server and copy it over to target

sqlplus "/as sysdba"
SQL> create pfile='/tmp/initSVLSTDBY.ora' from spfile;
File created.
scp /tmp/initSVLSTANDBY.ora 192.168.1.75:$ORACLE_HOME/dbs

Go to target server and perform following:
a) Change the db name for target server (SVLDB to SVLSTANDBY in my case)
simply vi to initSVLSTDBY file and
:%s///g

b) Remove/uncomment RAC specific parameters i.e.
*.cluster_database_instances=1
*.cluster_database=true
#SVLSTDBY.instance_number=1
#SVLSTDBY.thread=1
#SVLSTDBY.undo_tablespace='UNDOTBS1'
#*.remote_listener='LISTENERS_SVLSTDBY'

sample initSVLSTDBY.ora file
----------------------------------
SVLSTDBY1.__db_cache_size=180355072
SVLSTDBY1.__java_pool_size=4194304
SVLSTDBY1.__large_pool_size=4194304
SVLSTDBY1.__shared_pool_size=92274688
SVLSTDBY1.__streams_pool_size=0
*.audit_file_dest='/u01/app/oracle/admin/SVLSTDBY/adump'
*.background_dump_dest='/u01/app/oracle/admin/SVLSTDBY/bdump'
#*.cluster_database_instances=1
#*.cluster_database=true
*.compatible='10.2.0.1.0'
*.control_files='+DATA/SVLSTDBY/controlfile/current.256.758671835','+DATA/SVLSTDBY/controlfile/current.257.758671837'
*.core_dump_dest='/u01/app/oracle/admin/SVLSTANDBY/cdump'
*.db_block_size=8192
*.db_create_file_dest='+DATA'
*.db_domain='STANDBY'
*.db_file_multiblock_read_count=16
*.db_name='SVLSTDBY'
*.db_recovery_file_dest='+DATA'
*.db_recovery_file_dest_size=2147483648
*.dispatchers='(PROTOCOL=TCP) (SERVICE=SVLSTDBYXDB)'
*.db_file_name_convert='+DATA/SVLDB/', '+DATA/SVLSTDBY/'
*.log_file_name_convert='+DATA/SVLDB/','+DATA/SVLSTDBY/'
#SVLSTDBY.instance_number=1
*.job_queue_processes=10
*.open_cursors=300
*.pga_aggregate_target=94371840
*.processes=150
#*.remote_listener='LISTENERS_SVLSTDBY'
*.remote_login_passwordfile='exclusive'
*.sga_target=285212672
#SVLDB1.thread=1
*.undo_management='AUTO'
*.undo_tablespace='UNDOTBS1'
#SVLSTDBY.undo_tablespace='UNDOTBS1'
*.user_dump_dest='/u01/app/oracle/admin/SVLSTDBY/udump'

c) Create following directory
/u01/app/oracle/admin/SVLSTDBY/adump
/u01/app/oracle/admin/SVLSTDBY/bdump
/u01/app/oracle/admin/SVLSTDBY/cdump
/u01/app/oracle/admin/SVLSTDBY/udump

[oracle]$ export ORACLE_SID=+ASM1
[oracle]$ export ORACLE_HOME=/u01/app/oracle/product/10.2.0/db_1
[oracle]$ asmcmd
ASMCMD> lsdg
State    Type    Rebal  Unbal  Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Name
MOUNTED  EXTERN  N      N         512   4096  1048576    823953   430321                0          430321              0  DATA/
MOUNTED  EXTERN  N      N         512   4096  1048576    394342   112542                0          112542              0  FLASH/

ASMCMD> cd data
ASMCMD> mkdir SVLSTDBY
ASMCMD> cd SVLSTDBY
ASMCMD> mkdir PARAMETERFILE
ASMCMD> mkdir DATAFILE
ASMCMD> mkdir TEMPFILE
ASMCMD> mkdir ARCHIVELOG
ASMCMD> mkdir CONTROLFILE
ASMCMD> mkdir ONLINELOG
ASMCMD> mkdir STANDBYLOG
ASMCMD> mkdir dgbroker
ASMCMD> pwd
+data/SVLSTDBY
ASMCMD> ls
PARAMETERFILE/
DATAFILE/
TEMPFILE/
ARCHIVELOG/
CONTROLFILE/
ONLINELOG/
STANDBYLOG/
dgbroker/

Create the Same Directories under the FLASH diskgroup.


d) Changing ASM Disk Group:
Since I am moving from DATA/FRA diskgroup to DATA/FRA diskgroup I don't have to use covert file_name parameters.

e) Edit /etc/oratab file, add database entry

SVLSTDBY:/u01/app/oracle/product/10.2.0/db_1:N

f) Copy password file from source to target.
scp oracle@source_server:/u01/app/oracle/product/10.2.0/db_1/orapwSOURCEDB /u01/app/oracle/product/10.2.0/db_1/orapwTARGETDB

8) Start the target database in nomount mode

sqlplus  / as sysdba

create spfile from pfile;

startup nomount

exit

9) Start listener at the target server

lsnrctl start LISTENER_SVLORADB2

10) Check the connection from source to target

From source server test the connection to the target database using the command:

sqlplus sys/password@TARGETDB_CLONE as sysdba

11) Duplicate Database now

export ORACLE_SID=SVLSTDBY1
export NLS_LANG=american
export NLS_DATE_FORMAT='Mon DD YYYY HH24:MI:SS'

rman target sys@ catalog rman/password@ auxiliary sys@
rman target sys@SVLDB catalog rman/rman@RMN1 auxiliary sys@SVLSTDBY

[oracle@svloradb2 rman_bkup]$ rman target sys@SVLDB catalog rman/rman@RMN1 auxiliary sys@SVLSTANDBY

Recovery Manager: Release 10.2.0.1.0 - Production on Mon Aug 15 00:50:55 2011

Copyright (c) 1982, 2005, Oracle.  All rights reserved.

target database Password:
connected to target database: SVLDB (DBID=2180978007)
connected to recovery catalog database
auxiliary database Password:
connected to auxiliary database: SVLSTDBY (not mounted)

RMAN>



run {
allocate auxiliary channel ch1 type disk;
allocate auxiliary channel ch2 type disk;
SET UNTIL TIME 'Aug 15 2011 23:00:32';
duplicate target database to SVLSTDBY;
}



Issue while running RMAN duplicate:
RMAN-06136: ORACLE error from auxiliary database: ORA-01503: CREATE CONTROLFILE failed
ORA-01276: Cannot add file +DATA/svldb/controlfile/current.256.758671835.  File has an Oracle Managed Files file name.

solution-1
--------------
ORA-01276: Cannot add file string. File has an Oracle Managed Files file name.
Cause: An attempt was made to add to the database a datafile, log file, control file, snapshot control file, backup control file, datafile copy, control file copy or backuppiece with an Oracle Managed Files file name.
Action: Retry the operation with a new file name.

The second one is the root error. The problem here is that when you try to create a tablespace by means of an ASM instance which is 
managed by OMF you cannot give a name to the datafiles, it is a paradox, you cannot manage a file that is oracle managed, but you want 
to recreate it using the definition provided by the export file.

The workaround here is to manually create it, letting asm to give a name to it.

solution-2
-------------------
LOG_FILE_NAME_CONVERT=(‘SOURCE_DB_STORAGE’,'CLONE_DB_STORAGE’)
DB_FILE_NAME_CONVERT=(‘SOURCE_DB_STORAGE’,'CLONE_DB_STORAGE’)

LOG_FILE_NAME_CONVERT=('+DATA/svldb','+DATA/svlstdby')
DB_FILE_NAME_CONVERT=('+DATA/svldb','+DATA/svlstdby')

Issue was resolved by trying out the following:
a)db_file and log_file convert method.
b) changing controlfile name

 
Register the clone database and the database instances with the Oracle Cluster Registry (OCR)
============================================================================================
 
$ srvctl add database -d SVLSTDBY -o /u01/app/oracle/product/10.2.0/db_1
$ srvctl add instance -d SVLSTDBY -i SVLSTDBY1 -n svloradb2
 
Register the ASM instance with the OCR:
$ srvctl add asm -n svloradb2 -i +ASM1 -o /u01/app/oracle/product/10.2.0/db_1 -p /u01/app/oracle/product/10.2.0/db_1/dbs/spfile+ASM1.ora
# $ srvctl add asm -n standby_host2 -i +ASM2 -o /u01/app/oracle/product/10.2.0/db_1 –p /u01/app/oracle/product/10.2.0/db_1/dbs/spfile+ASM2.ora

Establish the dependency between the database instance and the ASM instance.
$ srvctl modify instance -d SVLSTDBY -i SVLSTDBY1 -s +ASM1
#$ srvctl modify instance –d SVLSTDBY –i SVLSTDBY2 –s +ASM2
$ srvctl enable asm -n svloradb2 -i +ASM1
#$ srvctl enable asm -n standby_host2 -i +ASM2

Start ASM
$ srvctl start asm -n svloradb2
Start Database:

srvctl start database -d SVLSTDBY

[oracle@svloradb2 dbs]$ /u01/crs/oracle/product/10.2.0/crs/bin/crs_stat -t
Name           Type           Target    State     Host
------------------------------------------------------------
ora....Y1.inst application    ONLINE    ONLINE    svloradb2
ora....TDBY.db application    ONLINE    ONLINE    svloradb2
ora....SM1.asm application    ONLINE    ONLINE    svloradb2
ora....B2.lsnr application    ONLINE    ONLINE    svloradb2
ora....db2.gsd application    ONLINE    ONLINE    svloradb2
ora....db2.ons application    ONLINE    ONLINE    svloradb2
ora....db2.vip application    ONLINE    ONLINE    svloradb2

Success cloning/duplicate log:
=========================================
[oracle@svloradb2 dbs]$ rman target sys@SVLDB catalog rman/rman@RMN1 auxiliary sys@SVLSTDBY

Recovery Manager: Release 10.2.0.1.0 - Production on Mon Aug 15 23:13:41 2011

Copyright (c) 1982, 2005, Oracle.  All rights reserved.

target database Password:
connected to target database: SVLDB (DBID=2180978007)
connected to recovery catalog database
auxiliary database Password:
connected to auxiliary database: SVLSTDBY (not mounted)

RMAN> run {
allocate auxiliary channel ch1 type disk;
allocate auxiliary channel ch2 type disk;
SET UNTIL TIME 'Aug 15 2011 23:00:32';
duplicate target database to SVLSTDBY;
}2> 3> 4> 5> 6>

allocated channel: ch1
channel ch1: sid=153 devtype=DISK

allocated channel: ch2
channel ch2: sid=152 devtype=DISK

executing command: SET until clause

Starting Duplicate Db at Aug 15 2011 23:14:08

contents of Memory Script:
{
   set until scn  881005;
   set newname for datafile  1 to
 "+DATA/svlstdby/datafile/system.264.758671851";
   set newname for datafile  2 to
 "+DATA/svlstdby/datafile/undotbs1.265.758671869";
   set newname for datafile  3 to
 "+DATA/svlstdby/datafile/sysaux.266.758671873";
   set newname for datafile  4 to
 "+DATA/svlstdby/datafile/users.268.758671889";
   restore
   check readonly
   clone database
   ;
}
executing Memory Script

executing command: SET until clause

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

Starting restore at Aug 15 2011 23:14:09

channel ch1: starting datafile backupset restore
channel ch1: specifying datafile(s) to restore from backup set
restoring datafile 00001 to +DATA/svlstdby/datafile/system.264.758671851
restoring datafile 00002 to +DATA/svlstdby/datafile/undotbs1.265.758671869
restoring datafile 00003 to +DATA/svlstdby/datafile/sysaux.266.758671873
restoring datafile 00004 to +DATA/svlstdby/datafile/users.268.758671889
channel ch1: reading from backup piece /home/oracle/rman_bkup/full_hot_bkup_759279484_16_SVLDB
channel ch1: restored backup piece 1
piece handle=/home/oracle/rman_bkup/full_hot_bkup_759279484_16_SVLDB tag=TAG20110815T225803
channel ch1: restore complete, elapsed time: 00:01:27
Finished restore at Aug 15 2011 23:15:39
sql statement: CREATE CONTROLFILE REUSE SET DATABASE "SVLSTDBY" RESETLOGS ARCHIVELOG
  MAXLOGFILES    192
  MAXLOGMEMBERS      3
  MAXDATAFILES     1024
  MAXINSTANCES    32
  MAXLOGHISTORY      292
 LOGFILE
  GROUP  1 ( '+DATA/svlstdby/onlinelog/group_1.258.758671839', '+DATA/svlstdby/onlinelog/group_1.259.758671839' ) SIZE 50 M  REUSE,
  GROUP  2 ( '+DATA/svlstdby/onlinelog/group_2.260.758671841', '+DATA/svlstdby/onlinelog/group_2.261.758671845' ) SIZE 50 M  REUSE,
  GROUP  3 ( '+DATA/svlstdby/onlinelog/group_3.262.758671845', '+DATA/svlstdby/onlinelog/group_3.263.758671847' ) SIZE 50 M  REUSE
 DATAFILE
  '+DATA/svlstdby/datafile/system.261.759280455'
 CHARACTER SET AL32UTF8


contents of Memory Script:
{
   switch clone datafile all;
}
executing Memory Script

datafile 2 switched to datafile copy
input datafile copy recid=1 stamp=759280542 filename=+DATA/svlstdby/datafile/undotbs1.259.759280455
datafile 3 switched to datafile copy
input datafile copy recid=2 stamp=759280542 filename=+DATA/svlstdby/datafile/sysaux.260.759280455
datafile 4 switched to datafile copy
input datafile copy recid=3 stamp=759280542 filename=+DATA/svlstdby/datafile/users.258.759280455

contents of Memory Script:
{
   set until time  "Aug 15 2011 23:00:32";
   recover
   clone database
    delete archivelog
   ;
}
executing Memory Script

executing command: SET until clause

Starting recover at Aug 15 2011 23:15:42

starting media recovery

channel ch1: starting archive log restore to default destination
channel ch1: restoring archive log
archive log thread=1 sequence=40
channel ch1: reading from backup piece /home/oracle/rman_bkup/arch_bkup_19_759279636_SVLDB
channel ch1: restored backup piece 1
piece handle=/home/oracle/rman_bkup/arch_bkup_19_759279636_SVLDB tag=TAG20110815T230035
channel ch1: restore complete, elapsed time: 00:00:02
archive log filename=+DATA/svlstdby/archivelog/2011_08_15/thread_1_seq_40.262.759280547 thread=1 sequence=40
channel clone_default: deleting archive log(s)
archive log filename=+DATA/svlstdby/archivelog/2011_08_15/thread_1_seq_40.262.759280547 recid=1 stamp=759280547
media recovery complete, elapsed time: 00:00:02
Finished recover at Aug 15 2011 23:15:49

contents of Memory Script:
{
   shutdown clone;
   startup clone nomount ;
}
executing Memory Script

database dismounted
Oracle instance shut down

connected to auxiliary database (not started)
Oracle instance started

Total System Global Area     285212672 bytes

Fixed Size                     1218992 bytes
Variable Size                121636432 bytes
Database Buffers             159383552 bytes
Redo Buffers                   2973696 bytes
sql statement: CREATE CONTROLFILE REUSE SET DATABASE "SVLSTDBY" RESETLOGS ARCHIVELOG
  MAXLOGFILES    192
  MAXLOGMEMBERS      3
  MAXDATAFILES     1024
  MAXINSTANCES    32
  MAXLOGHISTORY      292
 LOGFILE
  GROUP  1 ( '+DATA/svlstdby/onlinelog/group_1.258.758671839', '+DATA/svlstdby/onlinelog/group_1.259.758671839' ) SIZE 50 M  REUSE,
  GROUP  2 ( '+DATA/svlstdby/onlinelog/group_2.260.758671841', '+DATA/svlstdby/onlinelog/group_2.261.758671845' ) SIZE 50 M  REUSE,
  GROUP  3 ( '+DATA/svlstdby/onlinelog/group_3.262.758671845', '+DATA/svlstdby/onlinelog/group_3.263.758671847' ) SIZE 50 M  REUSE
 DATAFILE
  '+DATA/svlstdby/datafile/system.261.759280455'
 CHARACTER SET AL32UTF8


contents of Memory Script:
{
   set newname for tempfile  1 to
 "+DATA/svlstdby/tempfile/temp.267.758671881";
   switch clone tempfile all;
   catalog clone datafilecopy  "+DATA/svlstdby/datafile/undotbs1.259.759280455";
   catalog clone datafilecopy  "+DATA/svlstdby/datafile/sysaux.260.759280455";
   catalog clone datafilecopy  "+DATA/svlstdby/datafile/users.258.759280455";
   switch clone datafile all;
}
executing Memory Script

executing command: SET NEWNAME

renamed temporary file 1 to +DATA/svlstdby/tempfile/temp.267.758671881 in control file

cataloged datafile copy
datafile copy filename=+DATA/svlstdby/datafile/undotbs1.259.759280455 recid=1 stamp=759280571

cataloged datafile copy
datafile copy filename=+DATA/svlstdby/datafile/sysaux.260.759280455 recid=2 stamp=759280571

cataloged datafile copy
datafile copy filename=+DATA/svlstdby/datafile/users.258.759280455 recid=3 stamp=759280571

datafile 2 switched to datafile copy
input datafile copy recid=1 stamp=759280571 filename=+DATA/svlstdby/datafile/undotbs1.259.759280455
datafile 3 switched to datafile copy
input datafile copy recid=2 stamp=759280571 filename=+DATA/svlstdby/datafile/sysaux.260.759280455
datafile 4 switched to datafile copy
input datafile copy recid=3 stamp=759280571 filename=+DATA/svlstdby/datafile/users.258.759280455

contents of Memory Script:
{
   Alter clone database open resetlogs;
}
executing Memory Script

database opened
Finished Duplicate Db at Aug 15 2011 23:17:15

RMAN>


INSTANCE_NAME    HOST_NAME                                                        STARTUP_TIME         STATUS
---------------- ---------------------------------------------------------------- -------------------- ------------
SVLSTDBY1        svloradb2.localdomain                                            Aug 15 2011 23:16:02 OPEN

uncomment RAC Specific parameters and and start the database:

*.cluster_database_instances=1
*.cluster_database=true
#SVLSTDBY.instance_number=1
#SVLSTDBY.thread=1
#SVLSTDBY.undo_tablespace='UNDOTBS1'
#*.remote_listener='LISTENERS_SVLSTDBY'

END of cloning RAC Database with ASM option step_by_step method.