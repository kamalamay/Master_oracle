--CHECK OF TRANSACTION SCHEMA "BI_SOSA12"
--NOTE : 	INSTANCES SOSA1 10.163.84.70,SOSA2 10.163.84.71 Username/password sys/Oracle321!
--			OEM Auth User/Password => sysman/Oracle321
--			Script Gather/Rebuild object /home/oracle/mii/script
			

--CHECK INACTIVE SESSOION CPU CONSUME
SELECT s.username, t.sid, s.serial#, SUM(VALUE/100) as "cpu usage (seconds)"
FROM v$session s, v$sesstat t, v$statname n
WHERE t.STATISTIC# = n.STATISTIC# AND NAME like '%CPU used by this session%' AND t.SID = s.SID AND s.status='INACTIVE' AND s.username is not null
GROUP BY username,t.sid,s.serial# order by 4 desc;

--V$SESSION CHECKING
select * from v$session where username <> 'SYS' and username is not null;
select * from v$session where status ='INACTIVE' order by LOGON_TIME;
select * from v$session where sid='1500';
select sql_id from v$session where sid='1500';
select * from v$session where sql_id='bqm2jpbn3kh9r';
select * from v$session where sql_id='35jjxqg8bu4qk';
select SID,SERIAL#,USERNAME,STATUS,MACHINE,SQL_ID,to_char(LOGON_TIME,'MM/DD/YYYY HH24:MM:SS') "LOGON_TIME",
to_char(PREV_EXEC_START,'MM/DD/YYYY HH24:MM:SS') "PREV_EXEC_START",EVENT
from v$session where status='ACTIVE' and username not in ('SYS','SOSA_AQ_ADM') and username is not null;

--CHECK SQL_ID HISTORY PLAN
select to_char(begin_interval_time,'yy-mm-dd hh24:mi')|| ' - ' || to_char(end_interval_time,'hh24:mi') snaptime,sql_id,PLAN_HASH_VALUE PLAN_HASH
from dba_hist_sqlstat a join dba_hist_snapshot b on (a.snap_id=b.snap_id and a.instance_number=b.instance_number)
and begin_interval_time > trunc(sysdate-20) and sql_id like 'bqm2jpbn3kh9r'  order by 1 desc;

--CHECK SQL_ID HISTORY PLAN COMPLETE
select to_char(begin_interval_time,'yy-mm-dd hh24:mi')|| ' - ' || to_char(end_interval_time,'hh24:mi') snaptime,sql_id,PLAN_HASH_VALUE PLAN_HASH,
(CASE EXECUTIONS_DELTA WHEN 0 THEN 1 ELSE EXECUTIONS_DELTA END) EXEC_DELTA,
TRUNC((ELAPSED_TIME_DELTA/1000)) ELAP_DELTA_MSEC,
TRUNC((ELAPSED_TIME_DELTA/1000)/(CASE EXECUTIONS_DELTA WHEN 0 THEN 1 ELSE EXECUTIONS_DELTA END),3) AVG_ELAP_MSEC,
ROWS_PROCESSED_DELTA ROWS_DELTA,
ROUND(ROWS_PROCESSED_DELTA/(CASE EXECUTIONS_DELTA WHEN 0 THEN 1 ELSE EXECUTIONS_DELTA END)) AVG_ROW,ROUND(DISK_READS_DELTA/(CASE EXECUTIONS_DELTA WHEN 0 THEN 1 ELSE EXECUTIONS_DELTA END)) DISK_READS
from dba_hist_sqlstat a join dba_hist_snapshot b on (a.snap_id=b.snap_id and a.instance_number=b.instance_number)
and begin_interval_time > trunc(sysdate-2) and sql_id like '57rjx6awty71g'  order by 1 desc;

--CHECK PLAN HASH VALUE
select distinct SQL_ID,SQL_PROFILE,PLAN_HASH_VALUE from v$sql where SQL_ID='2r9vt2wazdndw';

--CHECK STATISTICS TABLES / CHECK OBJECTS / PRIVILEGES / ROLES / SIZE
select   OWNER,TABLE_NAME,to_char(LAST_ANALYZED,'DD/MM/YYYY HH24:MM:SS') "DATETIME",STATUS
from     dba_tables
where    OWNER ='BI_SOSA12' and to_char(LAST_ANALYZED,'DD/MM/YYYY HH24:MM:SS') is not null order by LAST_ANALYZED DESC;

select * from dba_objects where owner='BI_SOSA12';
select   OWNER,
         sum(decode(nvl(NUM_ROWS,9999), 9999,0,1)),
         sum(decode(nvl(NUM_ROWS,9999), 9999,1,0)),
         count(TABLE_NAME)
from     dba_tables
where    OWNER not in ('SYS', 'SYSTEM')
group by OWNER;

SELECT DS.TABLESPACE_NAME,SEGMENT_NAME,ROUND(SUM(DS.BYTES)/(1024*1024)) AS MB
FROM DBA_SEGMENTS DS WHERE SEGMENT_NAME IN (SELECT TABLE_NAME FROM DBA_TABLES)
GROUP BY DS.TABLESPACE_NAME,SEGMENT_NAME;

SELECT BYTES/1024/1024 MB FROM DBA_SEGMENTS WHERE SEGMENT_NAME='TX_JOURNAL_DETAILS';
SELECT BYTES/1024/1024 MB FROM DBA_SEGMENTS WHERE SEGMENT_NAME='TX_JOURNAL_HEADERS';

select * from dba_objects where owner='BI_SOSA12';

select OWNER,SEGMENT_NAME,SEGMENT_TYPE,round(BYTES/1024/1024,0) MB from dba_segments 
where segment_type='INDEX'
and OWNER='BI_SOSA12'
AND SEGMENT_NAME IN ('IDX$$_1725B0001','IDX_H_JOURNAL_DETAILS_ACC') order by 4 desc;

--CHECK STATUS INDEXES
select distinct status from dba_indexes where owner='BI_SOSA12';

select * from dba_sys_privs where PRIVILEGE =  'DBA';
select * from dba_role_privs where granted_role='DBA';

--CHECK STALE OBJECTS
select OWNER,TABLE_NAME,PARTITION_NAME,STALE_STATS from dba_tab_statistics WHERE OWNER='BI_SOSA12' AND STALE_STATS='YES';

--REVOKE PRIVILEGES
REVOKE ANALYZE ANY TO BIGEB31;
REVOKE ANALYZE ANY DICTIONARY FROM BIGEB31;
REVOKE ANALYZE ANY DICTIONARY FROM BIGEB_310516;

--CHECK SESSION LOCK
SELECT a.session_id, b.serial#, a.oracle_username, c.name,
decode(d.type,
'MR', 'Media Recovery',
'RT', 'Redo Thread',
'UN', 'User Name',
'TX', 'Transaction',
'TM', 'DML',
'UL', 'PL/SQL User Lock',
'DX', 'Distrib Xaction',
'CF', 'Control File',
'IS', 'Instance State',
'FS', 'File Set',
'IR', 'Instance Recovery',
'ST', 'Disk Space Transaction',
'TS', 'Temp Segment',
'IV', 'Library Cache Invalidation',
'LS', 'Log Start or Switch',
'RW', 'Row Wait',
'SQ', 'Sequence Number',
'TE', 'Extend Table',
'TT', 'Temp Table',
d.type) lock_type,
decode(d.lmode,
0, 'None',           /* Mon Lock equivalent */
1, 'Null',           /* N */
2, 'Row-S (SS)',     /* L */
3, 'Row-X (SX)',     /* R */
4, 'Share',          /* S */
5, 'S/Row-X (SSX)',  /* C */
6, 'Exclusive',      /* X */
to_char(d.lmode)) mode_held,
e.event, e.SECONDS_IN_WAIT "Wait(Seconds)"
FROM     sys.obj$ c, v$session b, v$locked_object a,
sys.v_$lock d, v$session_wait e
WHERE     a.session_id=b.sid
AND    b.sid=e.sid
AND    c.obj#=a.object_id
AND    a.object_id=d.id1
AND    b.sid=d.sid
order    by e.SECONDS_IN_WAIT desc;

--CHECK SESSION BLOCKING
select 
  sess.schemaname,
  sess.machine,
   sess.blocking_session, 
   sess.sid, 
   sess.serial#, 
   sess.wait_class,
   sess.seconds_in_wait,
   sql.sql_text
FROM v$session sess,
       v$sql     sql
WHERE sql.sql_id(+) = sess.sql_id
and  sess.blocking_session is not NULL
order by 
   sess.blocking_session;

--CHECK DBA SCHEDULER JOBS
select OWNER,JOB_NAME,JOB_CREATOR,JOB_ACTION,START_DATE,REPEAT_INTERVAL,STATE,LAST_START_DATE,LAST_RUN_DURATION,NEXT_RUN_DATE from dba_scheduler_jobs where owner='BI_SOSA12';