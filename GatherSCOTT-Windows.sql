SET LINES 150 PAGES 5000 TIMING ON ECHO ON;
SELECT
'EXEC DBMS_STATS.GATHER_TABLE_STATS('''||OWNER||''', '''||TABLE_NAME||''', ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE, CASCADE => TRUE);'
GATH_TABLE FROM DBA_TABLES WHERE OWNER='&SKEMA' ORDER BY 1;

SELECT OWNER||'.'||TABLE_NAME TBL,BLOCKS,LAST_ANALYZED FROM DBA_TABLES WHERE OWNER='&USER' ORDER BY 3 NULLS FIRST;

[orekel@pitik ~]$ cat D:\GatherSCOTT.sql
SET LINES 150 PAGES 5000 TIMING ON ECHO ON
SPOOL D:\GatherSCOTT.log
SELECT TO_CHAR(SYSDATE,'DD-Mon-RR HH24:MI:SS')MULAI FROM DUAL;
EXEC DBMS_STATS.GATHER_TABLE_STATS('SCOTT', 'BONUS', ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE, CASCADE => TRUE);
EXEC DBMS_STATS.GATHER_TABLE_STATS('SCOTT', 'DEPT', ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE, CASCADE => TRUE);
EXEC DBMS_STATS.GATHER_TABLE_STATS('SCOTT', 'EMP', ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE, CASCADE => TRUE);
EXEC DBMS_STATS.GATHER_TABLE_STATS('SCOTT', 'SALGRADE', ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE, CASCADE => TRUE);
SELECT TO_CHAR(SYSDATE,'DD-Mon-RR HH24:MI:SS')SELESAI FROM DUAL;
SPOOL OFF;
EXIT;

[orekel@pitik ~]$ cat D:\GatherSCOTT.sh
D:
dir
db
sqlplus system/orekel789 @D:\GatherSCOTT.sql
[orekel@pitik ~]$

--Bikin program
BEGIN
  DBMS_SCHEDULER.create_program
  (
    program_name        => 'PROG_GatherSCOTT',
    program_type        => 'EXECUTABLE',
    program_action      => 'C:\Windows\System32\cmd.exe /c D:\GatherSCOTT.bat',
    number_of_arguments => 0,
    enabled             => TRUE,
    comments            => 'Program to gather SCOTT''s statistics us a shell script.'
  );
END;
/

-- Display the program details.
SET LINES 150 PAGES 5000 TIMING ON;
COL OWNER FOR A20;
COL PROGRAM_NAME FOR A35;
COL COMMENTS FOR A80;
SELECT OWNER, PROGRAM_NAME, ENABLED, COMMENTS FROM DBA_SCHEDULER_PROGRAMS ORDER BY 1,2;

--Bikin job
BEGIN
  -- Job defined by an existing program and schedule.
  DBMS_SCHEDULER.create_job
  (
    job_name      	=> 'JOB_GatherSCOTT',
    program_name 	=> 'PROG_GatherSCOTT',
    start_date		=> SYSTIMESTAMP,
    repeat_interval	=> 'freq=daily; byhour=13; byminute=21',
    end_date        => NULL,
    enabled       	=> TRUE,
    comments      	=> 'Job defined by an existing program PROG_GatherSCOTT.'
  );
END;
/

SELECT OWNER||'.'||JOB_NAME JOB_NAME,JOB_CREATOR,STATE,JOB_TYPE,REPEAT_INTERVAL,ENABLED,JOB_ACTION,COMMENTS FROM DBA_SCHEDULER_JOBS WHERE OWNER='SYS' AND JOB_NAME='JOB_GATHERSCOTT';

--Edit waktu run
BEGIN
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
  (
  	name      => 'SYS.JOB_GATHERSCOTT',
  	attribute => 'REPEAT_INTERVAL',
  	value     => 'freq=daily; byhour=13; byminute=26; bysecond=00'
  );
END;
/

--Edit Job_action
BEGIN
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE(
  	name 		=> 'SYS.PROG_GATHERSCOTT',
  	attribute 	=> 'PROGRAM_ACTION',
  	value 		=> 'D:\GatherSCOTT.sh'
  );
END;
/

SET LINES 150 PAGES 5000 TIMING ON ECHO ON;
COL JOBNAME FOR A30;
COL STATUS FOR A10;
COL ACTUAL_START_DATE FOR A35;
COL RUN_DURATION FOR A15;
COL ADDITIONAL_INFO FOR A100;
SELECT OWNER||'.'||JOB_NAME JOBNAME, STATUS, ERROR#, ACTUAL_START_DATE, RUN_DURATION, ADDITIONAL_INFO
FROM DBA_SCHEDULER_JOB_RUN_DETAILS WHERE OWNER='SYS' AND JOB_NAME='JOB_GATHERSCOTT' ORDER BY ACTUAL_START_DATE DESC;
