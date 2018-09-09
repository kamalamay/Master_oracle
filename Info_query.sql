/*
INFO SCRIPT yang telah dibuat oleh Eko Nofendi dan telah dimodifikasi oleh AzizPW
*/
/*
exp \'/ as sysdba\'  file=ASH_8Days.dmp log=ASH_8Days.log tables=WRH$\_ACTIVE\_SESSION\_HISTORY query=\"where SAMPLE_TIME\> \(sysdate -8\)\"
imp userid=\'/ as sysdba\' fromuser=sys touser=sys file=ASH_8Days.dmp log=imp_ASH_8Days.log ignore=y
OTA3: sqlplus ntmsidb/ntmsidb
*/
SET LINESIZE 200 PAGESIZE 5000;
SELECT USERNAME FROM DBA_USERS ORDER BY 1;
CREATE USER MII IDENTIFIED BY mii789 DEFAULT TABLESPACE USERS TEMPORARY TABLESPACE TEMP;
GRANT DBA, RESOURCE, CONNECT TO MII;

hostname && uname -a && lsb_release -a && more /etc/redhat-release && df -h && ps -ef|grep pmon && ps -ef|grep tns && env|grep ORACLE && lsnrctl status && vmstat 2 10 && top

sqlplus / as SYSDBA
SET LINESIZE 200 PAGESIZE 5000 TIMING ON;
COL SERVER FORMAT A25;
COL OS FORMAT A25;
COL DBSTAT FORMAT A20;
COL DBVER FORMAT A20;
SELECT /*+ PARALLEL(8)*/INS.INSTANCE_NAME INSNAME, DB.NAME DBNAME, INS.HOST_NAME SERVER, DB.PLATFORM_NAME OS, INS.DATABASE_STATUS DBSTAT, VERSION DBVER
FROM GV$INSTANCE INS JOIN GV$DATABASE DB USING (INST_ID) /*Database info*/ORDER BY 1;
SELECT /*+ PARALLEL(8)*/ DDF.TABLESPACE_NAME NAME, ROUND(((DDF.BYTES/1024)/1024), 2) TOTAL_MB, ROUND((((DDF.BYTES-DFS.BYTES)/1024)/1024), 2) USED_MB,
ROUND((((DDF.BYTES-DFS.BYTES)/DDF.BYTES)*100), 2) "USED(%)", ROUND(((DFS.BYTES/1024)/1024), 2) FREE_MB, ROUND((1-((DDF.BYTES-DFS.BYTES)/DDF.BYTES))*100,2) "FREE(%)"
FROM (SELECT TABLESPACE_NAME, SUM(BYTES) BYTES FROM DBA_DATA_FILES GROUP BY TABLESPACE_NAME) DDF
JOIN (SELECT TABLESPACE_NAME, SUM(BYTES) BYTES FROM DBA_FREE_SPACE GROUP BY TABLESPACE_NAME) DFS
ON DDF.TABLESPACE_NAME=DFS.TABLESPACE_NAME ORDER BY 4 DESC/*Checking the tablespaces, version 1.6*/;

SELECT /*Checking the next extend of tablespace, next extend only*/ ROUND((INCREMENT_BY*8192/1024/1024), 2) "Next Extend(MB)" FROM DBA_DATA_FILES ORDER BY SUBSTR(FILE_NAME,1,50);

SET LINESIZE 200 PAGESIZE 5000;
COL BEGIN_INTERVAL_TIME FORMAT A30;
COL END_INTERVAL_TIME FORMAT A30;
SELECT /*+ PARALLEL(8)*/* FROM
(
  SELECT A.SNAP_ID ASNAPID, C.SNAP_ID CSNAPID, BEGIN_INTERVAL_TIME, END_INTERVAL_TIME, ROUND(TO_NUMBER((C.VALUE-A.VALUE)/1000000/60), 2) DBTIME
  FROM DBA_HIST_SYS_TIME_MODEL A, DBA_HIST_SNAPSHOT B, DBA_HIST_SYS_TIME_MODEL C
  WHERE A.SNAP_ID=B.SNAP_ID AND C.SNAP_ID=A.SNAP_ID+1 AND A.STAT_NAME=C.STAT_NAME AND UPPER(A.STAT_NAME) LIKE '%DB TIME%'
  AND TO_CHAR(B.BEGIN_INTERVAL_TIME,'DD-MM-YYYY')>'&dari' AND TO_CHAR(B.END_INTERVAL_TIME,'DD-MM-YYYY')<='&sampai'
  ORDER BY TO_NUMBER((C.VALUE-A.VALUE)/1000000/60) DESC
) WHERE ROWNUM=1/*CHECK THE BIGGEST DBTIME, version 1.1*/;

set numwidth 40;
select /*+ PARALLEL(4)*/ /*Mencari datafile*/ FILE_NAME, d.TABLESPACE_NAME, d.BYTES, sum(nvl(e.BYTES,0)), round(sum(nvl(e.BYTES,0)) / (d.BYTES), 4) * 100, d.BYTES - nvl(sum(e.BYTES),0) from DBA_EXTENTS e, DBA_DATA_FILES d where d.FILE_ID = e.FILE_ID (+) group by FILE_NAME, d.TABLESPACE_NAME, d.FILE_ID, d.BYTES, STATUS order by d.TABLESPACE_NAME, d.FILE_ID;

SET LINE 200 PAGES 200
COL FILE_NAME FORMAT A80
SELECT /*+ PARALLEL(2)*//*Checking the tablespaces*/
X.TABLESPACE_NAME, X.FILE_NAME, X.BYTES ALLOCATED_BYTES, Y.FREE_BYTES
FROM DBA_DATA_FILES X
JOIN (SELECT FILE_ID, SUM(BYTES) FREE_BYTES FROM DBA_FREE_SPACE Y GROUP BY FILE_ID) Y ON X.FILE_ID=Y.FILE_ID ORDER BY 1;

SELECT /*Checking the next extend of tablespace*/ SUBSTR(FILE_NAME,1,50) DATAFILES, AUTOEXTENSIBLE, INCREMENT_BY*8192/1024/1024||' MB' "Next Extend"
FROM DBA_DATA_FILES ORDER BY 1;

SET LINESIZE 200 PAGESIZE 5000;
select * from (select a.snap_id as "asnapid",c.snap_id as "csnapid",begin_interval_time,end_interval_time,a.value as "avalue",c.value as "cvalue", to_number((c.value-a.value)/1000000/60) as "dbtime" from dba_hist_sys_time_model a,dba_hist_snapshot b, dba_hist_sys_time_model c where a.snap_id=b.snap_id and c.snap_id=a.snap_id+1 and a.stat_name=c.stat_name and a.stat_name like 'DB time' and to_char(b.begin_interval_time,'DD-MM-YYYY')>'01-04-2014' and to_char(b.end_interval_time,'DD-MM-YYYY')<='22-04-2014' order by to_number((c.value-a.value)/1000000/60) desc) where rownum = 1;
SELECT * FROM V$RESOURCE_LIMIT;

Set pages 1000
Set lines 75
Select a.execution_end, b.type, b.impact, d.rank, d.type, 
'Message           : '||b.message MESSAGE,
'Command To correct: '||c.command COMMAND,
'Action Message    : '||c.message ACTION_MESSAGE
From dba_advisor_tasks a, dba_advisor_findings b,
Dba_advisor_actions c, dba_advisor_recommendations d
Where a.owner=b.owner and a.task_id=b.task_id
And b.task_id=d.task_id and b.finding_id=d.finding_id
And a.task_id=c.task_id and d.rec_id=c.rec_Id
And a.task_name like 'ADDM%' and a.status='COMPLETED'
Order by b.impact, d.rank;

SQL> select file_name,bytes/1024/1024 mb
from dba_data_files
where tablespace_name = 'APP_DATA'
order by file_name;

FILE_NAME																											MB
------------------------------------------------------------ -------
+DATA/SID/datafile/app_data.259.669898683											20000
+DATA/SID/datafile/app_data.267.636216519											28100

alter database datafile '+PORTALDATA/portal/datafile/portal_idx17.dbf' resize 4G;

alter tablespace APP_DATA add datafile '+DATA' size 20000m;

/*
EMail:
ronny.n_wibowo@nsn.com
taufiqur.rahman@nsn.com
nadif.fabiansyah@nsn.com
*/

select count(*) from NTMSIDB.chain_queue;

==================ADDM HANGING TASK=====================
select owner, task_name, last_execution, execution_start, status
from dba_advisor_tasks
where execution_end is null
order by execution_start desc;
 
SQL> select 'exec dbms_advisor.delete_task(''' || TASK_NAME || ''' )' from dba_advisor_tasks where execution_end is null order by execution_start desc;

'EXECDBMS_ADVISOR.DELETE_TASK('''||TASK_NAME||''')'
----------------------------------------------------------------
exec dbms_advisor.delete_task('SYS_AUTO_SPCADV_1300592007' )
exec dbms_advisor.delete_task('SYS_AUTO_SPCADV_2700592007' )
exec dbms_advisor.delete_task('SYS_AUTO_SPCADV_2220592007' )
exec dbms_advisor.delete_task('ADDM:1488676071_1_33108' )
exec dbms_advisor.delete_task('ADDM:1488676071_1_33113' )


exec dbms_workload_repository.create_snapshot('TYPICAL');

select owner, task_name, last_execution, execution_start, status
from dba_advisor_tasks
where execution_end is null
order by execution_start desc; 

=======NUMBER OF SUBSCRIBERS========
PERFORMANCE
==========================================================================
SQL> select sum(USERS) from vassadw.gdm_report_3gcount; (update tiap hari rabu)

SQL> select count(*) from vassadw.gdm_imei_sadm; (detailnya disini)

  COUNT(*)
----------
  54018266

TIP
=====================================================
SQL> select count(SUBSCRIBER_ID) from NTMSUDB.SUBSCRIBERS;

COUNT(SUBSCRIBER_ID)
--------------------
            54207856
            
CREATE USER "FERRY" IDENTIFIED BY ferry
DEFAULT TABLESPACE "CMSPROD_DATA"
TEMPORARY TABLESPACE "TEMP";

GRANT "CONNECT" TO "FERRY";
GRANT "RESOURCE" TO "FERRY";

GRANT CREATE ANY JOB TO "FERRY"
GRANT CREATE JOB TO "FERRY"
GRANT UNDER ANY TABLE TO "FERRY"
GRANT ALTER ANY INDEXTYPE TO "FERRY"
GRANT CREATE ANY INDEXTYPE TO "FERRY"
GRANT ALTER ANY TRIGGER TO "FERRY"
GRANT CREATE ANY TRIGGER TO "FERRY"
GRANT ALTER ANY PROCEDURE TO "FERRY"
GRANT CREATE ANY VIEW TO "FERRY"
GRANT CREATE ANY SYNONYM TO "FERRY"
GRANT CREATE SYNONYM TO "FERRY"
GRANT ALTER ANY INDEX TO "FERRY"
GRANT CREATE ANY INDEX TO "FERRY"
GRANT UPDATE ANY TABLE TO "FERRY"
GRANT INSERT ANY TABLE TO "FERRY"
GRANT SELECT ANY TABLE TO "FERRY"
GRANT ALTER ANY TABLE TO "FERRY"
GRANT CREATE ANY TABLE TO "FERRY"
GRANT CREATE TABLE TO "FERRY"

Remove older than 4 days :
==========================
find *.trm -mtime +4 -exec rm {} \;
find *.trc -mtime +4 -exec rm {} \;

List file older than 4 days :
==========================
find *.trc -mtime +4 -exec ls -ltrh {} \;

find *.xml -mtime +2 -exec rm {} \;

files=($(find /oracle/app/oracle/diag/rdbms/cms/cms2/trace -mtime -4))
find cms2_m*.trc -mtime +4 -exec ls -ltrh {} \;

REMOVE LISTENER LOG ONLINE :
============================
1. stop logging (lsnrctl set log_status off)
2. del/mv file
3. start logging (lsnrctl set log_status on)