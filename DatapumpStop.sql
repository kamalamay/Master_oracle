--Reference: https://docs.oracle.com/cd/E11882_01/server.112/e22490/dp_import.htm#SUTIL953

-- Stop Datapump Job
--------------------
COL DATAPUMP_JOB FOR A30;
COL OPERATION FOR A10;
SELECT OWNER_NAME||'.'||JOB_NAME DATAPUMP_JOB, OPERATION, JOB_MODE, STATE, DEGREE, ATTACHED_SESSIONS, DATAPUMP_SESSIONS FROM DBA_DATAPUMP_JOBS ORDER BY 1;

DATAPUMP_JOB                   OPERATION  JOB_MODE                       STATE                              DEGREE ATTACHED_SESSIONS DATAPUMP_SESSIONS
------------------------------ ---------- ------------------------------ ------------------------------ ---------- ----------------- -----------------
SYS.SYS_IMPORT_FULL_03         IMPORT     FULL                           EXECUTING                              32                 0                 2
SYS.SYS_IMPORT_FULL_04         IMPORT     FULL                           NOT RUNNING                             0                 0                 0

Elapsed: 00:00:00.01
SQL> !impdp \'/ as sysdba\' attach=SYS_IMPORT_FULL_03
'
Import: Release 11.2.0.4.0 - Production on Sun Nov 11 20:32:17 2018

Copyright (c) 1982, 2011, Oracle and/or its affiliates.  All rights reserved.

Connected to: Oracle Database 11g Enterprise Edition Release 11.2.0.4.0 - 64bit Production
With the Partitioning, OLAP, Data Mining and Real Application Testing options

Job: SYS_IMPORT_FULL_03
  Owner: SYS
  Operation: IMPORT
  Creator Privs: TRUE
  GUID: 7A54175E3E865870E0531601A8ACF302
  Start Time: Sunday, 11 November, 2018 15:05:12
  Mode: FULL
  Instance: HDFSDB
  Max Parallelism: 32
  EXPORT Job Parameters:
     CLIENT_COMMAND        stg/********@exaprd tables=TDW_SUMMARY.cst_usg_dly_smy_hdp_exp:P_20180803,TDW_SUMMARY.cst_usg_dly_smy_hdp_exp:P_20180804,TDW_SUMMARY.cst_usg_dly_smy_hdp_exp:P_20180805,TDW_SUMMARY.cst_usg_dly_smy_hdp_exp:P_20180806,TDW_SUMMARY.cst_usg_dly_smy_hdp_exp:P_20180807 directory=DUMP_MII_CST dumpfile=cst_usg_dly_smy_hdp_exp_compress_20180803_07_%U.dmp parallel=24 logfile=EXP_usg_dly_smy_hdp_exp_compress_20180803_07.log compression=all EXCLUDE=STATISTICS
     COMPRESSION           ALL
  IMPORT Job Parameters:
  Parameter Name      Parameter Value:
     CLIENT_COMMAND        "/******** AS SYSDBA" DIRECTORY=CST_USG_DLY DUMPFILE=cst_usg_dly_smy_hdp_exp_compress_20180803_07_%U.dmp LOGFILE=IMPDPcst_usg_dly_smy_hdp_exp_compress_20180803_07.log PARALLEL=14 TABLE_EXISTS_ACTION=APPEND CLUSTER=N TRANSFORM=segment_attributes:n:table
     TABLE_EXISTS_ACTION   APPEND
  State: EXECUTING
  Bytes Processed: 481,848,199,504
  Percent Done: 69
  Current Parallelism: 32
  Job Error Count: 0
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_%u.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_01.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_02.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_03.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_04.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_05.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_06.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_07.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_08.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_09.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_10.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_11.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_12.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_13.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_14.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_15.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_16.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_17.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_18.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_19.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_20.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_21.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_22.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_23.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_24.dmp

Worker 1 Status:
  Process Name: DW00
  State: EXECUTING
  Object Schema: TDW_SUMMARY
  Object Name: CST_USG_DLY_SMY_HDP_EXP
  Object Type: TABLE_EXPORT/TABLE/TABLE_DATA
  Completed Objects: 50
  Total Objects: 82
  Completed Bytes: 2,727,907,256
  Worker Parallelism: 32
*/
Import> stop_job=immediate
Are you sure you wish to stop this job ([yes]/no): yes

SQL> @datapump
SQL> COL DATAPUMP_JOB FOR A30;
SQL> COL OPERATION FOR A10;
SQL> SELECT OWNER_NAME||'.'||JOB_NAME DATAPUMP_JOB, OPERATION, JOB_MODE, STATE, DEGREE, ATTACHED_SESSIONS, DATAPUMP_SESSIONS FROM DBA_DATAPUMP_JOBS ORDER BY 1;

DATAPUMP_JOB                   OPERATION  JOB_MODE                       STATE                              DEGREE ATTACHED_SESSIONS DATAPUMP_SESSIONS
------------------------------ ---------- ------------------------------ ------------------------------ ---------- ----------------- -----------------
SYS.SYS_IMPORT_FULL_03         IMPORT     FULL                           NOT RUNNING                             0                 0                 0
SYS.SYS_IMPORT_FULL_04         IMPORT     FULL                           NOT RUNNING                             0                 0                 0

Elapsed: 00:00:00.01
SQL>

-- Restart/Resume Datapump Job
------------------------------
SQL> @datapump
SQL> COL DATAPUMP_JOB FOR A30;
SQL> COL OPERATION FOR A10;
SQL> SELECT OWNER_NAME||'.'||JOB_NAME DATAPUMP_JOB, OPERATION, JOB_MODE, STATE, DEGREE, ATTACHED_SESSIONS, DATAPUMP_SESSIONS FROM DBA_DATAPUMP_JOBS ORDER BY 1;

DATAPUMP_JOB                   OPERATION  JOB_MODE                       STATE                              DEGREE ATTACHED_SESSIONS DATAPUMP_SESSIONS
------------------------------ ---------- ------------------------------ ------------------------------ ---------- ----------------- -----------------
SYS.SYS_IMPORT_FULL_03         IMPORT     FULL                           NOT RUNNING                             0                 0                 0
SYS.SYS_IMPORT_FULL_04         IMPORT     FULL                           NOT RUNNING                             0                 0                 0

Elapsed: 00:00:00.02
SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.4.0 - 64bit Production
With the Partitioning, OLAP, Data Mining and Real Application Testing options
[oracle@exadata-nfs ~]$ impdp \'/ as sysdba\' attach=SYS_IMPORT_FULL_03
'
Import: Release 11.2.0.4.0 - Production on Sun Nov 11 21:06:50 2018

Copyright (c) 1982, 2011, Oracle and/or its affiliates.  All rights reserved.

Connected to: Oracle Database 11g Enterprise Edition Release 11.2.0.4.0 - 64bit Production
With the Partitioning, OLAP, Data Mining and Real Application Testing options

Job: SYS_IMPORT_FULL_03
  Owner: SYS
  Operation: IMPORT
  Creator Privs: TRUE
  GUID: 7A54175E3E865870E0531601A8ACF302
  Start Time: Sunday, 11 November, 2018 21:06:51
  Mode: FULL
  Instance: HDFSDB
  Max Parallelism: 32
  EXPORT Job Parameters:
     CLIENT_COMMAND        stg/********@exaprd tables=TDW_SUMMARY.cst_usg_dly_smy_hdp_exp:P_20180803,TDW_SUMMARY.cst_usg_dly_smy_hdp_exp:P_20180804,TDW_SUMMARY.cst_usg_dly_smy_hdp_exp:P_20180805,TDW_SUMMARY.cst_usg_dly_smy_hdp_exp:P_20180806,TDW_SUMMARY.cst_usg_dly_smy_hdp_exp:P_20180807 directory=DUMP_MII_CST dumpfile=cst_usg_dly_smy_hdp_exp_compress_20180803_07_%U.dmp parallel=24 logfile=EXP_usg_dly_smy_hdp_exp_compress_20180803_07.log compression=all EXCLUDE=STATISTICS
     COMPRESSION           ALL
  IMPORT Job Parameters:
  Parameter Name      Parameter Value:
     CLIENT_COMMAND        "/******** AS SYSDBA" DIRECTORY=CST_USG_DLY DUMPFILE=cst_usg_dly_smy_hdp_exp_compress_20180803_07_%U.dmp LOGFILE=IMPDPcst_usg_dly_smy_hdp_exp_compress_20180803_07.log PARALLEL=14 TABLE_EXISTS_ACTION=APPEND CLUSTER=N TRANSFORM=segment_attributes:n:table
     TABLE_EXISTS_ACTION   APPEND
  State: IDLING
  Bytes Processed: 481,848,199,504
  Percent Done: 69
  Current Parallelism: 32
  Job Error Count: 0
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_%u.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_01.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_02.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_03.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_04.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_05.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_06.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_07.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_08.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_09.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_10.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_11.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_12.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_13.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_14.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_15.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_16.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_17.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_18.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_19.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_20.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_21.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_22.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_23.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_24.dmp
*/
Worker 1 Status:
  Process Name: DW00
  State: UNDEFINED
  Object Schema: TDW_SUMMARY
  Object Name: CST_USG_DLY_SMY_HDP_EXP
  Object Type: TABLE_EXPORT/TABLE/TABLE_DATA
  Completed Objects: 50
  Total Objects: 82
  Completed Rows: 893,586
  Completed Bytes: 2,727,907,256
  Percent Done: 4
  Worker Parallelism: 32

Import> HELP
------------------------------------------------------------------------------

The following commands are valid while in interactive mode.
Note: abbreviations are allowed.

CONTINUE_CLIENT
Return to logging mode. Job will be restarted if idle.

EXIT_CLIENT
Quit client session and leave job running.

HELP
Summarize interactive commands.

KILL_JOB
Detach and delete job.

PARALLEL
Change the number of active workers for current job.

START_JOB
Start or resume current job.
Valid keywords are: SKIP_CURRENT.

STATUS
Frequency (secs) job status is to be monitored where
the default [0] will show new status when available.

STOP_JOB
Orderly shutdown of job execution and exits the client.
Valid keywords are: IMMEDIATE.


Import> START_JOB

Import> STATUS

Job: SYS_IMPORT_FULL_03
  Operation: IMPORT
  Mode: FULL
  State: EXECUTING
  Bytes Processed: 481,848,199,504
  Percent Done: 69
  Current Parallelism: 32
  Job Error Count: 0
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_%u.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_01.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_02.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_03.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_04.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_05.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_06.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_07.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_08.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_09.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_10.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_11.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_12.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_13.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_14.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_15.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_16.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_17.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_18.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_19.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_20.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_21.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_22.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_23.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_24.dmp

Worker 1 Status:
  Process Name: DW00
  State: EXECUTING
  Object Schema: TDW_SUMMARY
  Object Name: CST_USG_DLY_SMY_HDP_EXP
  Object Type: TABLE_EXPORT/TABLE/TABLE_DATA
  Completed Objects: 1
  Total Objects: 82
  Completed Rows: 893,586
  Completed Bytes: 2,727,907,256
  Percent Done: 4
  Worker Parallelism: 32

Import> EXIT

[oracle@exadata-nfs ~]$ sqlplus / as sysdba @datapump

SQL*Plus: Release 11.2.0.4.0 Production on Sun Nov 11 21:08:29 2018

Copyright (c) 1982, 2013, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.4.0 - 64bit Production
With the Partitioning, OLAP, Data Mining and Real Application Testing options

SQL> COL DATAPUMP_JOB FOR A30;
SQL> COL OPERATION FOR A10;
SQL> SELECT OWNER_NAME||'.'||JOB_NAME DATAPUMP_JOB, OPERATION, JOB_MODE, STATE, DEGREE, ATTACHED_SESSIONS, DATAPUMP_SESSIONS FROM DBA_DATAPUMP_JOBS ORDER BY 1;

DATAPUMP_JOB                   OPERATION  JOB_MODE                       STATE                              DEGREE ATTACHED_SESSIONS DATAPUMP_SESSIONS
------------------------------ ---------- ------------------------------ ------------------------------ ---------- ----------------- -----------------
SYS.SYS_IMPORT_FULL_03         IMPORT     FULL                           EXECUTING                              32                 0                 2
SYS.SYS_IMPORT_FULL_04         IMPORT     FULL                           NOT RUNNING                             0                 0                 0

Elapsed: 00:00:00.01
SQL>

-- Increase Datapump Parallelism
--------------------------------
SQL> @datapump
SQL> COL DATAPUMP_JOB FOR A30;
SQL> COL OPERATION FOR A10;
SQL> SELECT OWNER_NAME||'.'||JOB_NAME DATAPUMP_JOB, OPERATION, JOB_MODE, STATE, DEGREE, ATTACHED_SESSIONS, DATAPUMP_SESSIONS FROM DBA_DATAPUMP_JOBS ORDER BY 1;

DATAPUMP_JOB                   OPERATION  JOB_MODE                       STATE                              DEGREE ATTACHED_SESSIONS DATAPUMP_SESSIONS
------------------------------ ---------- ------------------------------ ------------------------------ ---------- ----------------- -----------------
SYS.SYS_IMPORT_FULL_03         IMPORT     FULL                           EXECUTING                              32                 0                 2
SYS.SYS_IMPORT_FULL_04         IMPORT     FULL                           NOT RUNNING                             0                 0                 0

Elapsed: 00:00:00.01
SQL> !impdp \'/ as sysdba\' attach=SYS_IMPORT_FULL_03
'
Import: Release 11.2.0.4.0 - Production on Sun Nov 11 21:49:49 2018

Copyright (c) 1982, 2011, Oracle and/or its affiliates.  All rights reserved.

Connected to: Oracle Database 11g Enterprise Edition Release 11.2.0.4.0 - 64bit Production
With the Partitioning, OLAP, Data Mining and Real Application Testing options

Job: SYS_IMPORT_FULL_03
  Owner: SYS
  Operation: IMPORT
  Creator Privs: TRUE
  GUID: 7A54175E3E865870E0531601A8ACF302
  Start Time: Sunday, 11 November, 2018 21:06:51
  Mode: FULL
  Instance: HDFSDB
  Max Parallelism: 32
  EXPORT Job Parameters:
     CLIENT_COMMAND        stg/********@exaprd tables=TDW_SUMMARY.cst_usg_dly_smy_hdp_exp:P_20180803,TDW_SUMMARY.cst_usg_dly_smy_hdp_exp:P_20180804,TDW_SUMMARY.cst_usg_dly_smy_hdp_exp:P_20180805,TDW_SUMMARY.cst_usg_dly_smy_hdp_exp:P_20180806,TDW_SUMMARY.cst_usg_dly_smy_hdp_exp:P_20180807 directory=DUMP_MII_CST dumpfile=cst_usg_dly_smy_hdp_exp_compress_20180803_07_%U.dmp parallel=24 logfile=EXP_usg_dly_smy_hdp_exp_compress_20180803_07.log compression=all EXCLUDE=STATISTICS
     COMPRESSION           ALL
  IMPORT Job Parameters:
  Parameter Name      Parameter Value:
     CLIENT_COMMAND        "/******** AS SYSDBA" DIRECTORY=CST_USG_DLY DUMPFILE=cst_usg_dly_smy_hdp_exp_compress_20180803_07_%U.dmp LOGFILE=IMPDPcst_usg_dly_smy_hdp_exp_compress_20180803_07.log PARALLEL=14 TABLE_EXISTS_ACTION=APPEND CLUSTER=N TRANSFORM=segment_attributes:n:table
     TABLE_EXISTS_ACTION   APPEND
  State: EXECUTING
  Bytes Processed: 513,033,844,384
  Percent Done: 74
  Current Parallelism: 32
  Job Error Count: 0
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_%u.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_01.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_02.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_03.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_04.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_05.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_06.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_07.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_08.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_09.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_10.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_11.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_12.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_13.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_14.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_15.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_16.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_17.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_18.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_19.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_20.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_21.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_22.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_23.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_24.dmp
*/
Worker 1 Status:
  Process Name: DW00
  State: EXECUTING
  Object Schema: TDW_SUMMARY
  Object Name: CST_USG_DLY_SMY_HDP_EXP
  Object Type: TABLE_EXPORT/TABLE/TABLE_DATA
  Completed Objects: 13
  Total Objects: 82
  Completed Rows: 8,748,214
  Completed Bytes: 2,472,418,144
  Percent Done: 44
  Worker Parallelism: 32

Import> PARALLEL=38

Import> STATUS

Job: SYS_IMPORT_FULL_03
  Operation: IMPORT
  Mode: FULL
  State: EXECUTING
  Bytes Processed: 513,033,844,384
  Percent Done: 74
  Current Parallelism: 38
  Job Error Count: 0
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_%u.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_01.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_02.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_03.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_04.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_05.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_06.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_07.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_08.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_09.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_10.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_11.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_12.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_13.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_14.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_15.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_16.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_17.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_18.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_19.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_20.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_21.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_22.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_23.dmp
  Dump File: /af650/cst_usg_dly/cst_usg_dly_smy_hdp_exp_compress_20180803_07_24.dmp

Worker 1 Status:
  Process Name: DW00
  State: EXECUTING
  Object Schema: TDW_SUMMARY
  Object Name: CST_USG_DLY_SMY_HDP_EXP
  Object Type: TABLE_EXPORT/TABLE/TABLE_DATA
  Completed Objects: 14
  Total Objects: 82
  Completed Rows: 10,401,858
  Completed Bytes: 2,449,777,080
  Percent Done: 52
  Worker Parallelism: 38

Import> exit


SQL> @datapump
SQL> COL DATAPUMP_JOB FOR A30;
SQL> COL OPERATION FOR A10;
SQL> SELECT OWNER_NAME||'.'||JOB_NAME DATAPUMP_JOB, OPERATION, JOB_MODE, STATE, DEGREE, ATTACHED_SESSIONS, DATAPUMP_SESSIONS FROM DBA_DATAPUMP_JOBS ORDER BY 1;

DATAPUMP_JOB                   OPERATION  JOB_MODE                       STATE                              DEGREE ATTACHED_SESSIONS DATAPUMP_SESSIONS
------------------------------ ---------- ------------------------------ ------------------------------ ---------- ----------------- -----------------
SYS.SYS_IMPORT_FULL_03         IMPORT     FULL                           EXECUTING                              38                 0                 2
SYS.SYS_IMPORT_FULL_04         IMPORT     FULL                           NOT RUNNING                             0                 0                 0

Elapsed: 00:00:00.01
SQL>