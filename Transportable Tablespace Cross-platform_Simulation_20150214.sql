azizdb on windows
-----------------
D:\>sc start oracleserviceazizdb && sqlplus sys as sysdba

SERVICE_NAME: oracleserviceazizdb
        TYPE               : 10  WIN32_OWN_PROCESS
        STATE              : 2  START_PENDING
                                (NOT_STOPPABLE, NOT_PAUSABLE, IGNORES_SHUTDOWN)
        WIN32_EXIT_CODE    : 0  (0x0)
        SERVICE_EXIT_CODE  : 0  (0x0)
        CHECKPOINT         : 0x0
        WAIT_HINT          : 0x7d0
        PID                : 4448
        FLAGS              :

SQL*Plus: Release 11.2.0.1.0 Production on Sat Feb 14 14:30:41 2015

Copyright (c) 1982, 2010, Oracle.  All rights reserved.

Enter password:

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.1.0 - 64bit Production
With the Partitioning, OLAP, Data Mining and Real Application Testing options

SQL> SET LINES 200 PAGES 5000;
SQL> SELECT A.platform_id, A.platform_name, B.endian_format FROM v$database A, v$transportable_platform B WHERE  B.platform_id (+) = A.platform_id;

PLATFORM_ID PLATFORM_NAME                                                                                 ENDIAN_FORMAT
----------- ----------------------------------------------------------------------------------------------------- --------------
         12 Microsoft Windows x86 64-bit                                                                      Little

SQL> SELECT * FROM V$TRANSPORTABLE_PLATFORM ORDER BY 1;

PLATFORM_ID PLATFORM_NAME                                                                                 ENDIAN_FORMAT
----------- ----------------------------------------------------------------------------------------------------- --------------
          1 Solaris[tm] OE (32-bit)                                                                           Big
          2 Solaris[tm] OE (64-bit)                                                                           Big
          3 HP-UX (64-bit)                                                                                    Big
          4 HP-UX IA (64-bit)                                                                                 Big
          5 HP Tru64 UNIX                                                                                     Little
          6 AIX-Based Systems (64-bit)                                                                        Big
          7 Microsoft Windows IA (32-bit)                                                                     Little
          8 Microsoft Windows IA (64-bit)                                                                     Little
          9 IBM zSeries Based Linux                                                                           Big
         10 Linux IA (32-bit)                                                                                 Little
         11 Linux IA (64-bit)                                                                                 Little
         12 Microsoft Windows x86 64-bit                                                                      Little
         13 Linux x86 64-bit                                                                                  Little
         15 HP Open VMS                                                                                       Little
         16 Apple Mac OS                                                                                      Big
         17 Solaris Operating System (x86)                                                                    Little
         18 IBM Power Based Linux                                                                             Big
         19 HP IA Open VMS                                                                                    Little
         20 Solaris Operating System (x86-64)                                                                 Little
         21 Apple Mac OS (x86-64)                                                                             Little

20 rows selected.

SQL> CREATE TABLESPACE DIGODA DATAFILE 'D:\ORA\PRASTYO\ORADATA\AZIZDB\DIGODA01.DBF' SIZE 128M;

Tablespace created.

SQL> CREATE TABLESPACE DIPUKUL DATAFILE 'D:\ORA\PRASTYO\ORADATA\AZIZDB\DIPUKUL01.DBF' SIZE 256M;

Tablespace created.

SQL> SET LINES 200 PAGES 5000;
SQL> COL FILE_NAME FORMAT A60;
SQL> COL TBS FORMAT A20;
SQL> SELECT /*+PARALLEL(8)*/X.TABLESPACE_NAME TBS, X.FILE_NAME, ROUND((X.BYTES/1024/1024/1024), 2)SIZE_GB, Y.FREE_GB, ROUND((MAXBYTES/1024/1024/1024), 2)MAX_GB,

  2  X.STATUS, X.AUTOEXTENSIBLE AUEXT, INCREMENT_BY INCR, ONLINE_STATUS OL
  3  FROM DBA_DATA_FILES X JOIN (SELECT FILE_ID, ROUND((SUM(BYTES))/1024/1024/1024, 2) FREE_GB FROM DBA_FREE_SPACE Y GROUP BY FILE_ID) Y
  4  ON X.FILE_ID=Y.FILE_ID ORDER BY 1, 2;

TBS                  FILE_NAME                                                       SIZE_GB    FREE_GB     MAX_GB STATUS    AUE       INCR OL
-------------------- ------------------------------------------------------------ ---------- ---------- ---------- --------- --- ---------- -------
AZIZTBS              D:\ORA\PRASTYO\ORADATA\AZIZDB\AZIZTBS01.DBF                         .13        .12          0 AVAILABLE NO           0 ONLINE
DIGODA               D:\ORA\PRASTYO\ORADATA\AZIZDB\DIGODA01.DBF                          .13        .12          0 AVAILABLE NO           0 ONLINE
DIPUKUL              D:\ORA\PRASTYO\ORADATA\AZIZDB\DIPUKUL01.DBF                         .25        .25          0 AVAILABLE NO           0 ONLINE
EXAMPLE              D:\ORA\PRASTYO\ORADATA\AZIZDB\EXAMPLE01.DBF                         .09        .01         32 AVAILABLE YES         80 ONLINE
SYSAUX               D:\ORA\PRASTYO\ORADATA\AZIZDB\SYSAUX01.DBF                          .49        .03         32 AVAILABLE YES       1280 ONLINE
SYSTEM               D:\ORA\PRASTYO\ORADATA\AZIZDB\SYSTEM01.DBF                          .67        .01         32 AVAILABLE YES       1280 SYSTEM
UNDOTBS1             D:\ORA\PRASTYO\ORADATA\AZIZDB\UNDOTBS01.DBF                         .04        .03         32 AVAILABLE YES        640 ONLINE
USERS                D:\ORA\PRASTYO\ORADATA\AZIZDB\USERS01.DBF                             0          0         32 AVAILABLE YES        160 ONLINE

8 rows selected.

SQL> CREATE TABLE AZIZPW.goda (nomor number, KET VARCHAR2(50)) TABLESPACE DIGODA;

Table created.

SQL> INSERT INTO AZIZPW.goda VALUES(101, 'TERKUTUK');

1 row created.

SQL> COMMIT;

Commit complete.

SQL> SELECT * FROM AZIZPW.goda;

     NOMOR KET
---------- --------------------------------------------------
       101 TERKUTUK

SQL> CREATE TABLE AZIZPW.MOBIL (NOPOL VARCHAR2(9), MOBIL VARCHAR2(50)) TABLESPACE DIPUKUL;

Table created.

SQL> INSERT INTO AZIZPW.MOBIL VALUES('B1221KOX', 'BMW M4');

1 row created.

SQL> COMMIT;

Commit complete.

SQL> SELECT * FROM AZIZPW.MOBIL;

NOPOL     MOBIL
--------- --------------------------------------------------
B1221KOX  BMW M4

SQL> execute sys.dbms_tts.transport_set_check('DIGODA,DIPUKUL', true);

PL/SQL procedure successfully completed.

SQL> SELECT * FROM SYS.TRANSPORT_SET_VIOLATIONS;

no rows selected

SQL> ALTER TABLESPACE DIGODA READ ONLY;

Tablespace altered.

SQL> ALTER TABLESPACE DIPUKUL READ ONLY;

Tablespace altered.

SQL> SET LINES 200 PAGES 5000;
SQL> COL NAME FORMAT A70;
SQL> SELECT NAME, STATUS, ENABLED FROM V$DATAFILE ORDER BY 1;

NAME                                                                   STATUS  ENABLED
---------------------------------------------------------------------- ------- ----------
D:\ORA\PRASTYO\ORADATA\AZIZDB\AZIZTBS01.DBF                            ONLINE  READ WRITE
D:\ORA\PRASTYO\ORADATA\AZIZDB\DIGODA01.DBF                             ONLINE  READ ONLY
D:\ORA\PRASTYO\ORADATA\AZIZDB\DIPUKUL01.DBF                            ONLINE  READ ONLY
D:\ORA\PRASTYO\ORADATA\AZIZDB\EXAMPLE01.DBF                            ONLINE  READ WRITE
D:\ORA\PRASTYO\ORADATA\AZIZDB\SYSAUX01.DBF                             ONLINE  READ WRITE
D:\ORA\PRASTYO\ORADATA\AZIZDB\SYSTEM01.DBF                             SYSTEM  READ WRITE
D:\ORA\PRASTYO\ORADATA\AZIZDB\UNDOTBS01.DBF                            ONLINE  READ WRITE
D:\ORA\PRASTYO\ORADATA\AZIZDB\USERS01.DBF                              ONLINE  READ WRITE

8 rows selected.

SQL> SET LINES 200 PAGES 5000;
SQL> COL DIRECTORY_PATH FORMAT A75;
SQL> SELECT * FROM DBA_DIRECTORIES;

OWNER                          DIRECTORY_NAME                 DIRECTORY_PATH
------------------------------ ------------------------------ ---------------------------------------------------------------------------
SYS                            SUBDIR                         D:\ora\prastyo\product\11.2.0\dbhome_1\demo\schema\order_entry\/2002/Sep
SYS                            SS_OE_XMLDIR                   D:\ora\prastyo\product\11.2.0\dbhome_1\demo\schema\order_entry\
SYS                            LOG_FILE_DIR                   D:\ora\prastyo\product\11.2.0\dbhome_1\demo\schema\log\
SYS                            DATA_FILE_DIR                  D:\ora\prastyo\product\11.2.0\dbhome_1\demo\schema\sales_history\
SYS                            XMLDIR                         c:\ade\aime_dadvfh0169\oracle/rdbms/xml
SYS                            MEDIA_DIR                      D:\ora\prastyo\product\11.2.0\dbhome_1\demo\schema\product_media\
SYS                            DATA_PUMP_DIR                  D:\ora\prastyo/admin/azizdb/dpdump/
SYS                            ORACLE_OCM_CONFIG_DIR          D:\ora\prastyo\product\11.2.0\dbhome_1/ccr/state

8 rows selected.

SQL> CREATE DIRECTORY DRIVE_D AS 'D:\';
'
Directory created.

SQL> SET LINES 200 PAGES 5000;
SQL> COL DIRECTORY_PATH FORMAT A75;
SQL> SELECT * FROM DBA_DIRECTORIES;

OWNER                          DIRECTORY_NAME                 DIRECTORY_PATH
------------------------------ ------------------------------ ---------------------------------------------------------------------------
SYS                            DRIVE_D                        D:\
SYS                            SUBDIR                         D:\ora\prastyo\product\11.2.0\dbhome_1\demo\schema\order_entry\/2002/Sep
SYS                            SS_OE_XMLDIR                   D:\ora\prastyo\product\11.2.0\dbhome_1\demo\schema\order_entry\
SYS                            LOG_FILE_DIR                   D:\ora\prastyo\product\11.2.0\dbhome_1\demo\schema\log\
SYS                            DATA_FILE_DIR                  D:\ora\prastyo\product\11.2.0\dbhome_1\demo\schema\sales_history\
SYS                            XMLDIR                         c:\ade\aime_dadvfh0169\oracle/rdbms/xml
SYS                            MEDIA_DIR                      D:\ora\prastyo\product\11.2.0\dbhome_1\demo\schema\product_media\
SYS                            DATA_PUMP_DIR                  D:\ora\prastyo/admin/azizdb/dpdump/
SYS                            ORACLE_OCM_CONFIG_DIR          D:\ora\prastyo\product\11.2.0\dbhome_1/ccr/state

9 rows selected.

SQL>

Export datapump:
D:\>expdp sys/orekel789 DIRECTORY=DRIVE_D DUMPFILE=TTSLINUX.DMP LOGFILE=TTSLINUX_IMPDP.LOG TRANSPORT_TABLESPACES=DIGODA,DIPUKUL TRANSPORT_FULL_CHECK=Y

Export: Release 11.2.0.1.0 - Production on Sat Feb 14 15:12:23 2015

Copyright (c) 1982, 2009, Oracle and/or its affiliates.  All rights reserved.

UDE-28009: operation generated ORACLE error 28009
ORA-28009: connection as SYS should be as SYSDBA or SYSOPER

Username: SYS AS SYSDBA
Password:

Connected to: Oracle Database 11g Enterprise Edition Release 11.2.0.1.0 - 64bit Production
With the Partitioning, OLAP, Data Mining and Real Application Testing options
Starting "SYS"."SYS_EXPORT_TRANSPORTABLE_01":  SYS/******** AS SYSDBA DIRECTORY=DRIVE_D DUMPFILE=TTSLINUX.DMP LOGFILE=TTSLINUX_IMPDP.LOG TRANSPORT_TABLESPACES=D
IGODA,DIPUKUL TRANSPORT_FULL_CHECK=Y
Processing object type TRANSPORTABLE_EXPORT/PLUGTS_BLK
Processing object type TRANSPORTABLE_EXPORT/TABLE
Processing object type TRANSPORTABLE_EXPORT/POST_INSTANCE/PLUGTS_BLK
Master table "SYS"."SYS_EXPORT_TRANSPORTABLE_01" successfully loaded/unloaded
******************************************************************************
Dump file set for SYS.SYS_EXPORT_TRANSPORTABLE_01 is:
  D:\TTSLINUX.DMP
******************************************************************************
Datafiles required for transportable tablespace DIGODA:
  D:\ORA\PRASTYO\ORADATA\AZIZDB\DIGODA01.DBF
Datafiles required for transportable tablespace DIPUKUL:
  D:\ORA\PRASTYO\ORADATA\AZIZDB\DIPUKUL01.DBF
Job "SYS"."SYS_EXPORT_TRANSPORTABLE_01" successfully completed at 15:13:50

*/
D:\>

---
asem on Oracle Linux 6.5
------------------------
SQL> SET LINES 200 PAGES 5000;
SQL> COL HOST_NAME FORMAT A25;
COL DB_ROLE FORMAT A15;
COL OS FORMAT A25;
PLATFORM_NAME OS, INS.HOST_NAME,
COL DBSTAT FORMAT A20;
COL INSNAME FORMAT A10;
COL DBNAME FORMAT A10;
SELECT /*+ PARALLEL(4)*/DB.NAME DBNAME, DB.LOG_MODE, DB.OPEN_MODE, DB.DATABASE_ROLE DB_ROLE, DB.PLATFORM_NAME OS, INS.HOST_NAME,
  2  INS.INSTANCE_NAME INSNAME, INS.DATABASE_STATUS DBSTAT FROM GV$INSTANCE INS JOIN GV$DATABASE DB USING (INST_ID) /*Database info*/ORDER BY 1;

DBNAME     LOG_MODE     OPEN_MODE            DB_ROLE         OS                        HOST_NAME                 INSNAME    DBSTAT
---------- ------------ -------------------- --------------- ------------------------- ------------------------- ---------- --------------------
ASEM       ARCHIVELOG   READ WRITE           PRIMARY         Linux x86 64-bit          asem                      asem       ACTIVE

SQL> SELECT BANNER FROM V$VERSION;

BANNER
--------------------------------------------------------------------------------
Oracle Database 11g Enterprise Edition Release 11.2.0.4.0 - 64bit Production
PL/SQL Release 11.2.0.4.0 - Production
CORE    11.2.0.4.0      Production
TNS for Linux: Version 11.2.0.4.0 - Production
NLSRTL Version 11.2.0.4.0 - Production

SELECT /*+ PARALLEL(8)*/ DDF.TABLESPACE_NAME NAME, ROUND(((DDF.BYTES/1024)/1024), 2) TOTAL_MB, ROUND((((DDF.BYTES-DFS.BYTES)/1024)/1024), 2) USED_MB,
ROUND((((DDF.BYTES-DFS.BYTES)/DDF.BYTES)*100), 2) "Used(%)", ROUND(((DFS.BYTES/1024)/1024), 2) FREE_MB, ROUND((1-((DDF.BYTES-DFS.BYTES)/DDF.BYTES))*100,2) "Free(%)"
FROM (SELECT TABLESPACE_NAME, SUM(BYTES) BYTES FROM DBA_DATA_FILES GROUP BY TABLESPACE_NAME) DDF
JOIN (SELECT TABLESPACE_NAME, SUM(BYTES) BYTES FROM DBA_FREE_SPACE GROUP BY TABLESPACE_NAME) DFS
  5  ON DDF.TABLESPACE_NAME=DFS.TABLESPACE_NAME ORDER BY 1/*Checking the tablespaces, version 1.5*/;

NAME                             TOTAL_MB    USED_MB    Used(%)    FREE_MB    Free(%)
------------------------------ ---------- ---------- ---------- ---------- ----------
AZIZTBS                                 5          1         20          4         80
EXAMPLE                            345.63     309.88      89.66      35.75      10.34
SYSAUX                                550     514.88      93.61      35.13       6.39
SYSTEM                                760     753.75      99.18       6.25        .82
UNDOTBS1                              235     157.31      66.94      77.69      33.06
USERS                                   5       4.38       87.5        .63       12.5

6 rows selected.

SQL> SELECT /*+ PARALLEL(4)*/ROUND((SUM(BYTES))/1024/1024/1024, 2)DBSIZE_GB FROM DBA_DATA_FILES;

 DBSIZE_GB
----------
      1.86

SQL> SELECT A.platform_id, A.platform_name, B.endian_format FROM v$database A, v$transportable_platform B WHERE  B.platform_id (+) = A.platform_id;

PLATFORM_ID PLATFORM_NAME                                                                                         ENDIAN_FORMAT
----------- ----------------------------------------------------------------------------------------------------- --------------
         13 Linux x86 64-bit                                                                                      Little

SQL>

azizdb on windows
-----------------
D:\>rman target sys

Recovery Manager: Release 11.2.0.1.0 - Production on Sat Feb 14 15:19:31 2015

Copyright (c) 1982, 2009, Oracle and/or its affiliates.  All rights reserved.

target database Password:
connected to target database: AZIZDB (DBID=2308340256)

RMAN> convert tablespace DIGODA to platform="Linux x86 64-bit" FORMAT 'D:\%U';

Starting conversion at source at 14-FEB-15
using target database control file instead of recovery catalog
allocated channel: ORA_DISK_1
channel ORA_DISK_1: SID=25 device type=DISK
channel ORA_DISK_1: starting datafile conversion
input datafile file number=00007 name=D:\ORA\PRASTYO\ORADATA\AZIZDB\DIGODA01.DBF
converted datafile=D:\DATA_D-AZIZDB_I-2308340256_TS-DIGODA_FNO-7_01PV8SSG
channel ORA_DISK_1: datafile conversion complete, elapsed time: 00:00:07
Finished conversion at source at 14-FEB-15

RMAN> convert tablespace DIPUKUL to platform="Linux x86 64-bit" FORMAT 'D:\%U';

Starting conversion at source at 14-FEB-15
using channel ORA_DISK_1
channel ORA_DISK_1: starting datafile conversion
input datafile file number=00008 name=D:\ORA\PRASTYO\ORADATA\AZIZDB\DIPUKUL01.DBF
converted datafile=D:\DATA_D-AZIZDB_I-2308340256_TS-DIPUKUL_FNO-8_02PV8SU2
channel ORA_DISK_1: datafile conversion complete, elapsed time: 00:00:15
Finished conversion at source at 14-FEB-15

RMAN>

Copy dari source (windows) ke target (linux)
---
[2015-02-14 15:22.19]  /media/d
[prastyo.AzizWi] ➤ ls -lhtr
total 196699
drwxrwxrwx    1 Administ Administ       0 Mar 22  2014 LINUX_UNIX
drwx------    1 Administ UsersGrp       0 Apr 10  2014 ora
drwxrwxrwx    1 Administ Administ       0 Sep 15 16:45 ORACLE_DB
-rwxrwxrwx    1 Administ Administ      68 Dec 14 23:22 AUTORUN.INF
drwxrwxrwx    1 Administ Administ       0 Jan 11 19:13 MULTIMEDIA
drwxrwxrwx    1 Administ Administ       0 Jan 18 22:57 DONT_OPEN
drwx------    1 Administ 42949672       0 Jan 20 15:57 Oracle_InMemory
drwxrwxrwx    1 Administ Administ       0 Feb  8 18:16 vmware
drwxrwxrwx    1 Administ Administ       0 Feb 10 15:52 EXE
drwxrwxrwx    1 Administ Administ       0 Feb 11 20:04 NIKAH
drwxrwxrwx    1 Administ Administ       0 Feb 13 14:07 KAREPMU
drwx------    1 Administ 42949672       0 Feb 14 11:33 John Wick (2014)
d---rwx---    1 Administ 42949672       0 Feb 14 14:28 System Volume Information
drwx------    1 Administ UsersGrp       0 Feb 14 14:29 $RECYCLE.BIN
-rwxrwx---    1 Administ 42949672    1.3K Feb 14 15:13 TTSLINUX_IMPDP.LOG
-rwxrwx---    1 Administ 42949672   84.0K Feb 14 15:13 TTSLINUX.DMP
-rwxrwx---    1 Administ 42949672  128.0M Feb 14 15:19 DATA_D-AZIZDB_I-2308340256_TS-DIGODA_FNO-7_01PV8SSG
-rwxrwx---    1 Administ 42949672  256.0M Feb 14 15:20 DATA_D-AZIZDB_I-2308340256_TS-DIPUKUL_FNO-8_02PV8SU2
                                                                                                                                                                  ✔
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
[2015-02-14 15:22.34]  /media/d
[prastyo.AzizWi] ➤ scp TTS* orekel@169.254.112.40:/home/orekel/Downloads/
orekel@169.254.112.40's password:
TTSLINUX.DMP                                                                                                                     100%   84KB  84.0KB/s   00:00
TTSLINUX_IMPDP.LOG                                                                                                               100% 1306     1.3KB/s   00:00
                                                                                                                                                                  ✔
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
[2015-02-14 15:23.05]  /media/d
[prastyo.AzizWi] ➤ scp DATA* orekel@169.254.112.40:/home/orekel/Downloads/
orekel@169.254.112.40's password:
DATA_D-AZIZDB_I-2308340256_TS-DIGODA_FNO-7_01PV8SSG                                                                              100%  128MB  25.6MB/s   00:05
DATA_D-AZIZDB_I-2308340256_TS-DIPUKUL_FNO-8_02PV8SU2                                                                             100%  256MB  12.8MB/s   00:20
                                                                                                                                                                  ✔
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
[2015-02-14 15:23.43]  /media/d
[prastyo.AzizWi] ➤

asem on Oracle Linux 6.5
------------------------
SQL> CREATE DIRECTORY DOWNLOADS AS '/home/orekel/Downloads';

Directory created.

SET LINES 200 PAGES 5000;
COL DIRECTORY_PATH FORMAT A75;
SQL> SELECT * FROM DBA_DIRECTORIES;

OWNER                          DIRECTORY_NAME                 DIRECTORY_PATH
------------------------------ ------------------------------ ---------------------------------------------------------------------------
SYS                            SUBDIR                         /oraengine/app/orekel/product/11.2.0/db_home1/demo/schema/order_entry//2002
                                                              /Sep

SYS                            SS_OE_XMLDIR                   /oraengine/app/orekel/product/11.2.0/db_home1/demo/schema/order_entry/
SYS                            DESKTOP                        /home/orekel/Desktop/
SYS                            DOWNLOADS                      /home/orekel/Downloads
SYS                            LOG_FILE_DIR                   /oraengine/app/orekel/product/11.2.0/db_home1/demo/schema/log/
SYS                            MEDIA_DIR                      /oraengine/app/orekel/product/11.2.0/db_home1/demo/schema/product_media/
SYS                            DATA_FILE_DIR                  /oraengine/app/orekel/product/11.2.0/db_home1/demo/schema/sales_history/
SYS                            XMLDIR                         /oraengine/app/orekel/product/11.2.0/db_home1/rdbms/xml
SYS                            ORACLE_OCM_CONFIG_DIR          /oraengine/app/orekel/product/11.2.0/db_home1/ccr/hosts/asem/state
SYS                            DATA_PUMP_DIR                  /oraengine/app/orekel/admin/asem/dpdump/
SYS                            ORACLE_OCM_CONFIG_DIR2         /oraengine/app/orekel/product/11.2.0/db_home1/ccr/state

11 rows selected.

SQL> !ls -lh /home/orekel/Downloads
total 385M
-rwxr-x---. 1 orekel oinstall 129M Feb 14 15:23 DATA_D-AZIZDB_I-2308340256_TS-DIGODA_FNO-7_01PV8SSG
-rwxr-x---. 1 orekel oinstall 257M Feb 14 15:23 DATA_D-AZIZDB_I-2308340256_TS-DIPUKUL_FNO-8_02PV8SU2
-rwxr-x---. 1 orekel oinstall  84K Feb 14 15:23 TTSLINUX.DMP
-rwxr-x---. 1 orekel oinstall 1.3K Feb 14 15:23 TTSLINUX_IMPDP.LOG

SQL>

Import datapump on asem (linux)
---
[orekel@asem Downloads]$ ls -lh
total 385M
-rwxr-x---. 1 orekel oinstall 129M Feb 14 15:23 DATA_D-AZIZDB_I-2308340256_TS-DIGODA_FNO-7_01PV8SSG
-rwxr-x---. 1 orekel oinstall 257M Feb 14 15:23 DATA_D-AZIZDB_I-2308340256_TS-DIPUKUL_FNO-8_02PV8SU2
-rwxr-x---. 1 orekel oinstall  84K Feb 14 15:23 TTSLINUX.DMP
-rwxr-x---. 1 orekel oinstall 1.3K Feb 14 15:23 TTSLINUX_IMPDP.LOG
[orekel@asem Downloads]$ pwd
/home/orekel/Downloads
[orekel@asem Downloads]$ impdp DUMPFILE=TTSLINUX.DMP DIRECTORY=DOWNLOADS TRANSPORT_DATAFILES='/home/orekel/Downloads/DATA_D-AZIZDB_I-2308340256_TS-DIGODA_FNO-7_01PV8SSG','/home/orekel/Downloads/DATA_D-AZIZDB_I-2308340256_TS-DIPUKUL_FNO-8_02PV8SU2'

Import: Release 11.2.0.4.0 - Production on Sat Feb 14 15:33:05 2015

Copyright (c) 1982, 2011, Oracle and/or its affiliates.  All rights reserved.

Username: sys as sysdba
Password:

Connected to: Oracle Database 11g Enterprise Edition Release 11.2.0.4.0 - 64bit Production
With the Partitioning, Automatic Storage Management, OLAP, Data Mining
and Real Application Testing options
Master table "SYS"."SYS_IMPORT_TRANSPORTABLE_01" successfully loaded/unloaded
Source time zone version is 11 and target time zone version is 14.
Starting "SYS"."SYS_IMPORT_TRANSPORTABLE_01":  sys/******** AS SYSDBA DUMPFILE=TTSLINUX.DMP DIRECTORY=DOWNLOADS TRANSPORT_DATAFILES=/home/orekel/Downloads/DATA_D-AZIZDB_I-2308340256_TS-DIGODA_FNO-7_01PV8SSG,/home/orekel/Downloads/DATA_D-AZIZDB_I-2308340256_TS-DIPUKUL_FNO-8_02PV8SU2
Processing object type TRANSPORTABLE_EXPORT/PLUGTS_BLK
Processing object type TRANSPORTABLE_EXPORT/TABLE
Processing object type TRANSPORTABLE_EXPORT/POST_INSTANCE/PLUGTS_BLK
Job "SYS"."SYS_IMPORT_TRANSPORTABLE_01" successfully completed at Sat Feb 14 15:33:33 2015 elapsed 0 00:00:11
*/
[orekel@asem Downloads]$

Muncul di alert log:
Sat Feb 14 15:33:25 2015
DW00 started with pid=37, OS id=4725, wid=1, job SYS.SYS_IMPORT_TRANSPORTABLE_01
Advanced SCN by 60257 minutes worth to 0x000d.cacddc61, by Tablespace plug-in.
 Client info: DB logon user SYS, machine asem, program oracle@asem (DW00), and OS user orekel
Plug in tablespace DIGODA with datafile
  '/home/orekel/Downloads/DATA_D-AZIZDB_I-2308340256_TS-DIGODA_FNO-7_01PV8SSG'
Plug in tablespace DIPUKUL with datafile
  '/home/orekel/Downloads/DATA_D-AZIZDB_I-2308340256_TS-DIPUKUL_FNO-8_02PV8SU2'

WARNING:
Harusnya, hasil dari rman convert di-copy dulu ke ASM setelah itu baru diimport!!

SQL> SET LINES 200 PAGES 5000;
SQL> COL NAME FORMAT A70;
SQL> SELECT NAME, STATUS, ENABLED FROM V$DATAFILE ORDER BY 1;

NAME                                                                   STATUS  ENABLED
---------------------------------------------------------------------- ------- ----------
+DATA/asem/datafile/aziztbs.278.863361385                              ONLINE  READ WRITE
+DATA/asem/datafile/example.269.858525397                              ONLINE  READ WRITE
+DATA/asem/datafile/sysaux.257.858525141                               ONLINE  READ WRITE
+DATA/asem/datafile/system.256.858525141                               SYSTEM  READ WRITE
+DATA/asem/datafile/undotbs1.258.858525141                             ONLINE  READ WRITE
+DATA/asem/datafile/users.259.858525143                                ONLINE  READ WRITE
/home/orekel/Downloads/DATA_D-AZIZDB_I-2308340256_TS-DIGODA_FNO-7_01PV ONLINE  READ ONLY
8SSG

/home/orekel/Downloads/DATA_D-AZIZDB_I-2308340256_TS-DIPUKUL_FNO-8_02P ONLINE  READ ONLY
V8SU2


8 rows selected.

SET LINES 200 PAGES 5000;
COL FILE_NAME FORMAT A60;
COL TBS FORMAT A20;
SELECT /*+PARALLEL(8)*/X.TABLESPACE_NAME TBS, X.FILE_NAME, ROUND((X.BYTES/1024/1024/1024), 2)SIZE_GB, Y.FREE_GB, ROUND((MAXBYTES/1024/1024/1024), 2)MAX_GB,
X.STATUS, X.AUTOEXTENSIBLE AUEXT, INCREMENT_BY INCR, ONLINE_STATUS OL
FROM DBA_DATA_FILES X JOIN (SELECT FILE_ID, ROUND((SUM(BYTES))/1024/1024/1024, 2) FREE_GB FROM DBA_FREE_SPACE Y GROUP BY FILE_ID) Y
  4  ON X.FILE_ID=Y.FILE_ID ORDER BY 1, 2;

TBS                  FILE_NAME                                                       SIZE_GB    FREE_GB     MAX_GB STATUS    AUE       INCR OL
-------------------- ------------------------------------------------------------ ---------- ---------- ---------- --------- --- ---------- -------
AZIZTBS              +DATA/asem/datafile/aziztbs.278.863361385                             0          0          0 AVAILABLE NO           0 ONLINE
DIGODA               /home/orekel/Downloads/DATA_D-AZIZDB_I-2308340256_TS-DIGODA_        .13        .12          0 AVAILABLE NO           0 ONLINE
                     FNO-7_01PV8SSG

DIPUKUL              /home/orekel/Downloads/DATA_D-AZIZDB_I-2308340256_TS-DIPUKUL        .25        .25          0 AVAILABLE NO           0 ONLINE
                     _FNO-8_02PV8SU2

EXAMPLE              +DATA/asem/datafile/example.269.858525397                           .34        .03         32 AVAILABLE YES         80 ONLINE
SYSAUX               +DATA/asem/datafile/sysaux.257.858525141                            .54        .03         32 AVAILABLE YES       1280 ONLINE
SYSTEM               +DATA/asem/datafile/system.256.858525141                            .74        .01         32 AVAILABLE YES       1280 SYSTEM
UNDOTBS1             +DATA/asem/datafile/undotbs1.258.858525141                          .23        .08         32 AVAILABLE YES        640 ONLINE
USERS                +DATA/asem/datafile/users.259.858525143                               0          0         32 AVAILABLE YES        160 ONLINE

8 rows selected.

SQL> ALTER TABLESPACE DIGODA READ WRITE;

Tablespace altered.

SQL> ALTER TABLESPACE DIPUKUL READ WRITE;

Tablespace altered.

SET LINES 200 PAGES 5000;
COL NAME FORMAT A70;
SQL> SELECT NAME, STATUS, ENABLED FROM V$DATAFILE ORDER BY 1;

NAME                                                                   STATUS  ENABLED
---------------------------------------------------------------------- ------- ----------
+DATA/asem/datafile/aziztbs.278.863361385                              ONLINE  READ WRITE
+DATA/asem/datafile/example.269.858525397                              ONLINE  READ WRITE
+DATA/asem/datafile/sysaux.257.858525141                               ONLINE  READ WRITE
+DATA/asem/datafile/system.256.858525141                               SYSTEM  READ WRITE
+DATA/asem/datafile/undotbs1.258.858525141                             ONLINE  READ WRITE
+DATA/asem/datafile/users.259.858525143                                ONLINE  READ WRITE
/home/orekel/Downloads/DATA_D-AZIZDB_I-2308340256_TS-DIGODA_FNO-7_01PV ONLINE  READ WRITE
8SSG

/home/orekel/Downloads/DATA_D-AZIZDB_I-2308340256_TS-DIPUKUL_FNO-8_02P ONLINE  READ WRITE
V8SU2


8 rows selected.

SQL> SELECT TABLE_NAME FROM DBA_TABLES WHERE OWNER='AZIZPW';

TABLE_NAME
------------------------------
GODA
MOBIL
GSXRFLASHBACK_ASLI
GSXR_2
GSXR_3
TESDATE

6 rows selected.

SQL> SELECT * FROM AZIZPW.GODA;

     NOMOR KET
---------- --------------------------------------------------
       101 TERKUTUK

SQL> SELECT * FROM AZIZPW.MOBIL;

NOPOL     MOBIL
--------- --------------------------------------------------
B1221KOX  BMW M4

SQL>