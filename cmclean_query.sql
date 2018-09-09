REM
REM FILENAME
REM cmclean_query.sql
REM DESCRIPTION
REM Selects data on the concurrent manager tables the cmclean script updated.
REM
REM NOTES
REM Usage: sqlplus @cmclean_query.sql
REM
REM
REM $Id: cmclean_query.sql,v 1.0 2014/04/01 15:00:00 bkerr Exp $
REM
REM
REM +======================================================================+

spool cmclean_query.txt
set verify off;
set head off;
set timing off
set pagesize 1000

column manager format a20 heading 'Manager short name'
column pid heading 'Process id'
column pscode format a12 heading 'Status code'
column ccode format a12 heading 'Control code'
column request heading 'Request ID'
column pcode format a6 heading 'Phase'
column scode format a6 heading 'Status'


set feed on


REM Select process status codes that are TERMINATED

prompt
prompt ------------------------------------------------------------------------

prompt -- Select invalid process status codes in FND_CONCURRENT_PROCESSES
set feedback off
set head on
break on manager

SELECT concurrent_queue_name manager,
concurrent_process_id pid,
process_status_code pscode
FROM fnd_concurrent_queues fcq, fnd_concurrent_processes fcp
WHERE process_status_code not in ('K', 'S')
AND fcq.concurrent_queue_id = fcp.concurrent_queue_id
AND fcq.application_id = fcp.queue_application_id;


REM List invalid control codes

prompt
prompt ------------------------------------------------------------------------

prompt -- Listing invalid control_codes in FND_CONCURRENT_QUEUES
set feedback off
set head on
SELECT concurrent_queue_name manager,
control_code ccode
FROM fnd_concurrent_queues
WHERE control_code not in ('E', 'R', 'X')
AND control_code IS NOT NULL;


REM List Target Node for All Managers

prompt
prompt ------------------------------------------------------------------------


REM Identify the target_node for all managers
prompt -- Identify the target_node for all managers
set feedback off
set head on
select target_node from fnd_concurrent_queues;


REM List Running or Terminating requests

prompt
prompt ------------------------------------------------------------------------

prompt -- Select Running or Terminating requests
set feedback off
set head on
SELECT request_id request,
phase_code pcode,
status_code scode
FROM fnd_concurrent_requests
WHERE status_code = 'T' OR phase_code = 'R'
ORDER BY request_id;


prompt
prompt ------------------------------------------------------------------------

prompt Review complete.
prompt ------------------------------------------------------------------------

prompt
spool off
set feedback on