nano /home/orekel/script/rmanFull.sh
------------------------------------
#!/bin/bash
source /home/orekel/.bash_profile; export NLS_DATE_FORMAT='DD-Mon-RR HH24:MI:SS';
$ORACLE_HOME/bin/rman target=/ cmdfile='/home/orekel/script/rmanFull.rman' log=/home/orekel/RMAN/backup/rman_`date +%Y%m%d`.log

nano /home/orekel/script/rmanFull.rman
--------------------------------------
run {
  CONFIGURE DEVICE TYPE DISK PARALLELISM 16;
  CROSSCHECK BACKUP;
  DELETE NOPROMPT EXPIRED BACKUP;
  CROSSCHECK ARCHIVELOG ALL;
  DELETE NOPROMPT EXPIRED ARCHIVELOG ALL;
  BACKUP AS COMPRESSED BACKUPSET SPFILE TAG 'SPFile' FORMAT '/home/orekel/RMAN/backup/SPF_%I%d%T_%s_%p.bkp';
  BACKUP AS COMPRESSED BACKUPSET DATABASE TAG 'FULLBACKUP' FORMAT '/home/orekel/RMAN/backup/DB_%I%d%T_%s_%p.bkp';
  SQL 'ALTER SYSTEM ARCHIVE LOG CURRENT';
  BACKUP AS COMPRESSED BACKUPSET ARCHIVELOG ALL DELETE ALL INPUT TAG 'Archivelog' FORMAT '/home/orekel/RMAN/backup/ARC_%I%d%T_%s_%p.bkp';
  DELETE NOPROMPT OBSOLETE RECOVERY WINDOW OF 14 DAYS;
  BACKUP AS COMPRESSED BACKUPSET CURRENT CONTROLFILE TAG 'Controlfile' FORMAT '/home/orekel/RMAN/backup/CTRL_%I%d%T_%s_%p.bkp';
  BACKUP AS COMPRESSED BACKUPSET CURRENT CONTROLFILE FOR STANDBY TAG 'StbyControl' FORMAT '/home/orekel/RMAN/backup/SBCT_%I%d%T_%s_%p.bkp';
  CONFIGURE DEVICE TYPE DISK PARALLELISM 1;
}

nohup /home/orekel/RMAN/script/rman.sh >> /home/orekel/RMAN/script/nohuprman_`date +%Y%m%d`.log 2>&1 &

Differential Incremental 1
--------------------------
run{
  CONFIGURE DEVICE TYPE DISK PARALLELISM 16;
  BACKUP AS COMPRESSED BACKUPSET INCREMENTAL LEVEL 1 DATABASE TAG 'Incremental_1' format '/home/orekel/RMAN/backup/INCR1_%I%d%T_%s_%p.bkp';
  sql 'alter system archive log current';
  backup as compressed backupset archivelog all delete all input tag 'Archivelog' format '/home/orekel/RMAN/backup/ARCH_%I%d%T_%s_%p.bkp';
  CROSSCHECK BACKUP;
  CONFIGURE DEVICE TYPE DISK PARALLELISM 1;}

Cumulative Incremental 1
------------------------
run{
  CONFIGURE DEVICE TYPE DISK PARALLELISM 16;
  BACKUP AS COMPRESSED BACKUPSET INCREMENTAL LEVEL 1 CUMULATIVE DATABASE TAG 'Incremental_1' format '/home/orekel/RMAN/backup/INCR1_%I%d%T_%s_%p.bkp';
  sql 'alter system archive log current';
  backup as compressed backupset archivelog all delete all input tag 'Archivelog' format '/home/orekel/RMAN/backup/ARCH_%I%d%T_%s_%p.bkp';
  CROSSCHECK BACKUP;
  CONFIGURE DEVICE TYPE DISK PARALLELISM 1;}

--Change to default
CONFIGURE RETENTION POLICY CLEAR;
configure channel device type sbt parms sbt_library=pathname';
ALLOCATE CHANNEL FOR MAINTENANCE DEVICE TYPE SBT PARMS 'SBT_LIBRARY=/usr/local/oracle/backup/lib/libobk.so, ENV=(OB_DEVICE=oramaster_drive1@mspbackup,OB_MEDIA_FAMILY=RMAN_DEFAULT)';

ALLOCATE CHANNEL CHANN1 DEVICE TYPE sbt PARMS 'SBT_LIBRARY=/usr/local/oracle/backup/lib/libobk.so, ENV=(OB_DEVICE_1=stape2)';