--
-- Show SQL Workarea Memory Usage Statistics.
--

SET PAUSE ON
SET PAUSE 'Press Return to Continue'
SET PAGESIZE 60
SET LINESIZE 300

COLUMN sql FORMAT A10
COLUMN operation FORMAT A15
COLUMN op_id FORMAT 99
COLUMN policy FORMAT A7
COLUMN estd_opt_size FORMAT 9999
COLUMN estd_one_size FORMAT 9999
COLUMN last_mem_usd FORMAT 9999
COLUMN last_exec FORMAT A9
COLUMN tot_exec FORMAT 9
COLUMN opt_exec FORMAT 9
COLUMN one_exec FORMAT 9
COLUMN multi_exec FORMAT 10
COLUMN sec FORMAT 999
COLUMN max_tmp_sz FORMAT 999
COLUMN last_tmp_sz FORMAT 999

SELECT sql_text as sql, 
         operation_type as operation, 
         operation_id as op_id, 
         policy,
         round(estimated_optimal_size/1024/1024,2) as estd_opt_size, 
         round(estimated_onepass_size/1024/1024,2) as estd_one_size,
         round(last_memory_used/1024/1024,2) as last_mem_usd, 
         last_execution as last_exec,
         total_executions as tot_exec, 
         optimal_executions as opt_exec, 
         onepass_executions as one_exec, 
         multipasses_executions as multi_exec,
         round(active_time/1000000,2) as sec, 
         round(max_tempseg_size/1024/1024,2) as max_tmp_sz, 
         round(last_tempseg_size/1024/1024,2) as last_tmp_sz 
from   v$sql_workarea swa, 
         v$sql sq
where swa.address = sq.address 
and    swa.hash_value = sq.hash_value
and    sql_text like '&part_of_sql_statement%' order by sql;
