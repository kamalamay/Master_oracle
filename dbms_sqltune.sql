SET LINES 150 PAGES 5000 TIMING ON;
COL SQL_TEXT FOR A100;
SELECT SQL_TEXT, SQL_ID, PLAN_HASH_VALUE FROM V$SQL WHERE SQL_ID IN ('g75tpgfrdkzbg','23s0zuwrxzg2p');

SQL_TEXT                                                                                             SQL_ID        PLAN_HASH_VALUE
---------------------------------------------------------------------------------------------------- ------------- ---------------
insert /*+APPEND*/ into stg.ams_usage_smy select /*+ parallel(16) */    to_date(dt_id,'YYYYMMDD') ev g75tpgfrdkzbg      3193863538
ent_date,    to_char(count(distinct ar_id),'999,999,999,999,999') SWE,    to_char(sum(case when svc_
usg_tp_id=53 then usg_hits else 0 end),'999,999,999,999,999') VOICE_HITS,    to_char(sum(case when s
vc_usg_tp_id=53 then drtn_of_usg else 0 end),'999,999,999,999,999') VOICE_DUR,    to_char(sum(voice_
rev),'999,999,999,999,999.99') voice_rev,    to_char(sum(case when svc_usg_tp_id=54 then usg_hits el
se 0 end),'999,999,999,999,999') DATA_HITS,    to_char(sum(case when svc_usg_tp_id=54 then drtn_of_u
sg else 0 end),'999,999,999,999,999') DATA_DUR,    to_char(sum(case when svc_usg_tp_id=54 then vol_o
f_usg else 0 end)/(1024*1024*1024),'999,999,999,999,999') DATA_VOL,    to_char(sum(DATA_rev),'999,99
9,999,999,999.99') DATA_rev,    to_char(sum(case when svc_usg_tp_id=61 then usg_hits else 0 end),'99
9,999,999,999,999') SMS_HITS,    to_char(sum(SMS_rev),'999,999,999,999,999.99') SMS_rev,    to_char(

CASE EXAPRD
===============

1.  create a tuning task based on the sql_id on "HOURLY" user
DECLARE
  stmt_task VARCHAR2(64);
BEGIN
  stmt_task:=dbms_sqltune.create_tuning_task(sql_id => 'g75tpgfrdkzbg', plan_hash_value => '3193863538', time_limit => 3600, task_name => 'Tune_sqlid', description => 'Task to tune qlid sql_id');
END;
/


2. created we ask Oracle to effectively execute it
EXECUTE dbms_sqltune.execute_tuning_task('Tune_sqlid');

3. check its completion
ALTER SESSION SET nls_date_format='dd-mon-yyyy hh24:mi:ss';

col description FOR a40
SELECT task_name, description, advisor_name, execution_start, execution_end, status
FROM dba_advisor_tasks ORDER BY task_id DESC;

4. generate report
SET linesize 200
SET LONG 999999999
SET pages 1000
SET longchunksize 20000
SELECT dbms_sqltune.report_tuning_task('Tune_sqlid', 'TEXT', 'ALL') FROM dual;

5. apply the suggested optimization
SELECT dbms_sqltune.script_tuning_task('Tune_sqlid', 'ALL') FROM dual;

