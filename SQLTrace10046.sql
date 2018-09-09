alter session set tracefile_identifier='10046';
alter session set timed_statistics = true;
alter session set statistics_level=all;
alter session set max_dump_file_size = unlimited;
alter session set events '10046 trace name context forever,level 12';
-- Execute the queries or operations to be traced here --
CONN MANDIRIMAIN
SHO USER
SELECT CS_CASE_INFO_ID FROM CS_CASE_INFO WHERE DPD>210 AND CHARGE_OFF_FLAG='N' AND (GROUP_ACCOUNT_RISK_CAT IN ('LOW','MED') OR GROUP_ACCOUNT_RISK_CAT is NULL);

select * from dual;
exit;
If the session is not exited then the trace can be disabled using:
alter session set events '10046 trace name context off';

--- By SQL_ID ---
alter system set events 'sql_trace[sql: 12xjx29qc7trj] level 12';

alter system set events 'sql_trace[sql: sql_id=12xjx29qc7trj] level 12';

alter system set events 'sql_trace[sql: sql_id=12xjx29qc7trj] OFF';

alter session set events 'sql_trace [sql: sql_id=g3yc1js3g2689 | sql_id=7ujay4u33g337]bind=true, wait=true';