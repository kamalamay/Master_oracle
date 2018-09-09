SPOOL Orasnap.txt

SHO USER;
ALTER SESSION SET NLS_DATE_FORMAT='DD-Mon-RR HH24:MI:SS';
--Buffer hit ratio
SET LINES 150 PAGES 5000 TIMING ON;
col "Consistent Gets" for 999,999,999,999,999
col "DB Blk Gets" for 999,999,999,999,999
col "Physical Reads" for 999,999,999,999,999
select
  sum(decode(NAME, 'consistent gets',VALUE, 0)) "Consistent Gets",sum(decode(NAME, 'db block gets',VALUE, 0)) "DB Blk Gets",
  sum(decode(NAME, 'physical reads',VALUE, 0)) "Physical Reads",
  round
  (
    (sum(decode(name, 'consistent gets',value, 0)) + sum(decode(name, 'db block gets',value, 0)) - sum(decode(name, 'physical reads',value, 0)))
    / (sum(decode(name, 'consistent gets',value, 0)) + sum(decode(name, 'db block gets',value, 0))) * 100,2
  ) "Hit Ratio"
from sys.v_$sysstat;

--Library cache hit ratio
SET LINES 150 PAGES 5000 TIMING ON;
col "Executions" for 999,999,999,999,999
col "Execution Hits" for 999,999,999,999,999
col "Misses" for 999,999,999,999,999
select
  sum(PINS) "Executions",sum(PINHITS) "Execution Hits",round((sum(PINHITS) / sum(PINS)) * 100,3) "Hit Ratio",sum(RELOADS) "Misses",
  round((sum(PINS) / (sum(PINS) + sum(RELOADS))) * 100,3) "Hit Ratio"
from sys.v_$librarycache;

--Data dictionary hit ratio
SET LINES 150 PAGES 5000 TIMING ON;
col "Gets" for 999,999,999,999,999
col "Get Misses" for 999,999,999,999,999
select sum(GETS) "Gets",sum(GETMISSES) "Get Misses",round((1 - (sum(GETMISSES) / sum(GETS))) * 100,2) "Hit Ratio" from sys.v_$rowcache;

--Sort statistic
SET LINES 150 PAGES 5000 TIMING ON;
select NAME "Sort Parameter", to_char(VALUE) "Value" from sys.v_$sysstat where NAME like 'sort%'
union all
select '% of disk sorts' "Sort Parameter",'.0' "Value" from sys.v_$sysstat where rownum=1; 

--Analyzed tables
SET LINES 150 PAGES 5000 TIMING ON;
select   OWNER "Owner",
         sum(decode(nvl(NUM_ROWS,9999), 9999,0,1)) "Analyzed",
         sum(decode(nvl(NUM_ROWS,9999), 9999,1,0)) "Not Analyzed",
         count(TABLE_NAME) "Total"
from     dba_tables
where    OWNER not in ('SYS', 'SYSTEM')
group by OWNER;

--Tablespace usage
SET LINES 150 PAGES 5000 TIMING ON;
select   ddf.TABLESPACE_NAME "Tablespace Name",
         ddf.BYTES "Bytes Allocated",
         ddf.BYTES-DFS.BYTES "Bytes Used",
         round(((ddf.BYTES-dfs.BYTES)/ddf.BYTES)*100,2) "Percent Used",
         dfs.BYTES "Bytes Free",
         round((1-((ddf.BYTES-dfs.BYTES)/ddf.BYTES))*100,2) "Percent Free"
from    (select TABLESPACE_NAME,
                sum(BYTES) bytes 
         from   dba_data_files 
         group  by TABLESPACE_NAME) ddf,
        (select TABLESPACE_NAME,
                sum(BYTES) bytes 
         from   dba_free_space 
         group  by TABLESPACE_NAME) dfs
where    ddf.TABLESPACE_NAME=dfs.TABLESPACE_NAME
order by ((ddf.BYTES-dfs.BYTES)/ddf.BYTES) desc;

--Invalid objects
SET LINES 150 PAGES 5000 TIMING ON;
COL OBJECT_NAME FOR A60;
select OWNER,OBJECT_TYPE,OBJECT_NAME,STATUS from dba_objects where STATUS='INVALID' order by OWNER, OBJECT_TYPE, OBJECT_NAME;

--SGA information
SET LINES 150 PAGES 5000 TIMING ON;
col VALUE for 999,999,999,999,999
select NAME,VALUE from sys.v_$sga
union all
select 'TOTAL SGA' "NAME", sum(VALUE) "VALUE" from sys.v_$sga group by 'TOTAL SGA';

--Database information
SET LINES 150 PAGES 5000 TIMING ON;
col CHECKPOINT_CHANGE# for 999,999,999,999,999
col ARCHIVE_CHANGE# for 999,999,999,999,999
select NAME "Database Name", CREATED "Created", LOG_MODE "Log Mode", CHECKPOINT_CHANGE#, ARCHIVE_CHANGE# from sys.v_$database;

COL UPTIME FOR A70;
select
  STARTUP_TIME "Started",trunc(SYSDATE-(STARTUP_TIME) ) || ' day(s), ' ||
  trunc(24*((SYSDATE-STARTUP_TIME) - trunc(SYSDATE-STARTUP_TIME)))||' hour(s), ' ||
  mod(trunc(1440*((SYSDATE-STARTUP_TIME) - trunc(SYSDATE-STARTUP_TIME))), 60) ||' minute(s), ' ||
  mod(trunc(86400*((SYSDATE-STARTUP_TIME) - trunc(SYSDATE-STARTUP_TIME))), 60) ||' seconds' "Uptime"
from sys.v_$instance;

--RMAN backup jobs
SET LINES 150 PAGES 5000 TIMING ON;
COL "Backup Name" FOR A19;
COL "Start Time" FOR A19;
COL "Elapsed Time" FOR A8;
COL input_type FOR A12;
COL STATUS FOR A23;
COL "Input Size" FOR A10;
COL "Output Size" FOR A10;
COL "Output Rate Per Sec" FOR A10;
SELECT
  r.command_id "Backup Name", TO_CHAR(r.start_time, 'mm/dd/yyyy HH24:MI:SS') "Start Time", r.time_taken_display "Elapsed Time",r.input_type, r.status status,
  r.output_device_type "output_device_type",r.input_bytes_display "Input Size",r.output_bytes_display "Output Size",r.output_bytes_per_sec_display "Output Rate Per Sec"
FROM
(
  select command_id, start_time, time_taken_display, status, input_type, output_device_type, input_bytes_display, output_bytes_display, output_bytes_per_sec_display
  from v$rman_backup_job_details order by start_time DESC
) r WHERE rownum < 11;

--Redo log switches
SET LINES 150 PAGES 5000 TIMING ON;
column "DATETIME" format a20
column 00 format a4
column 01 format a4
column 02 format a4
column 03 format a4
column 04 format a4
column 05 format a4
column 06 format a4
column 07 format a4
column 08 format a4
column 09 format a4
column 10 format a4
column 11 format a4
column 12 format a4
column 13 format a4
column 14 format a4
column 15 format a4
column 16 format a4
column 17 format a4
column 18 format a4
column 19 format a4
column 20 format a4
column 21 format a4
column 22 format a4
column 23 format a4
select   to_date(substr(to_char(FIRST_TIME,'DY, YYYY/MM/DD'),1,15),'DY, YYYY/MM/DD') "DATETIME",
         decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'00',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'00',1,0))) "00",
         decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'01',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'01',1,0))) "01",
         decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'02',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'02',1,0))) "02",
         decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'03',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'03',1,0))) "03",
         decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'04',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'04',1,0))) "04",
         decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'05',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'05',1,0))) "05",
         decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'06',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'06',1,0))) "06",
         decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'07',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'07',1,0))) "07",
         decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'08',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'08',1,0))) "08",
         decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'09',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'09',1,0))) "09",
         decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'10',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'10',1,0))) "10",
         decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'11',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'11',1,0))) "11",
         decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'12',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'12',1,0))) "12",
         decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'13',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'13',1,0))) "13",
         decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'14',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'14',1,0))) "14",
         decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'15',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'15',1,0))) "15",
         decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'16',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'16',1,0))) "16",
         decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'17',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'17',1,0))) "17",
         decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'18',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'18',1,0))) "18",
         decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'19',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'19',1,0))) "19",
         decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'20',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'20',1,0))) "20",
         decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'21',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'21',1,0))) "21",
         decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'22',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'22',1,0))) "22",
         decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'23',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'23',1,0))) "23"
from sys.v_$log_history
group by substr(to_char(FIRST_TIME,'DY, YYYY/MM/DD'),1,15)
order by to_date(substr(to_char(FIRST_TIME,'DY, YYYY/MM/DD'),1,15),'DY, YYYY/MM/DD') desc;
SPOOL OFF;
