REM
REM FILENAME
REM cmclean.sql
REM DESCRIPTION
REM Clean out the concurrent manager tables
REM NOTES
REM Usage: sqlplus @cmclean 
REM 
REM
REM $Id: cmclean.sql,v 1.4 2001/04/07 15:55:07 pferguso Exp $
REM 
REM
REM +======================================================================+


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


WHENEVER SQLERROR EXIT ROLLBACK;

DOCUMENT

WARNING : Do not run this script without explicit instructions
from Oracle Support 


*** Make sure that the managers are shut down *** 
*** before running this script ***

*** If the concurrent managers are NOT shut down, ***
*** exit this script now !! ***

#

accept answer prompt 'If you wish to continue type the word ''dual'': '

set feed off
select null from &answer;
set feed on


REM Update process status codes to TERMINATED

prompt
prompt ------------------------------------------------------------------------

prompt -- Updating invalid process status codes in FND_CONCURRENT_PROCESSES
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

set head off
set feedback on
UPDATE fnd_concurrent_processes
SET process_status_code = 'K'
WHERE process_status_code not in ('K', 'S');



REM Set all managers to 0 processes 

prompt
prompt ------------------------------------------------------------------------

prompt -- Updating running processes in FND_CONCURRENT_QUEUES
prompt -- Setting running_processes = 0 and max_processes = 0 for all managers

UPDATE fnd_concurrent_queues
SET running_processes = 0, max_processes = 0;




REM Reset control codes

prompt
prompt ------------------------------------------------------------------------

prompt -- Updating invalid control_codes in FND_CONCURRENT_QUEUES
set feedback off
set head on
SELECT concurrent_queue_name manager,
control_code ccode
FROM fnd_concurrent_queues
WHERE control_code not in ('E', 'R', 'X')
AND control_code IS NOT NULL;

set feedback on
set head off
UPDATE fnd_concurrent_queues
SET control_code = NULL
WHERE control_code not in ('E', 'R', 'X')
AND control_code IS NOT NULL;

REM Also null out target_node for all managers
UPDATE fnd_concurrent_queues
SET target_node = null;


REM Set all 'Terminating' requests to Completed/Error
REM Also set Running requests to completed, since the managers are down

prompt
prompt ------------------------------------------------------------------------

prompt -- Updating any Running or Terminating requests to Completed/Error canceled by CMCLEAN
set feedback off
set head on
SELECT request_id request,
phase_code pcode,
status_code scode
FROM fnd_concurrent_requests
WHERE status_code = 'T' OR phase_code = 'R'
ORDER BY request_id;

set feedback on
set head off
UPDATE fnd_concurrent_requests
SET phase_code = 'C', status_code = 'E'
WHERE status_code ='T' OR phase_code = 'R';





REM Set all Runalone flags to 'N'
REM This has to be done differently for Release 10

prompt
prompt ------------------------------------------------------------------------

prompt -- Updating any Runalone flags to 'N'
prompt
set serveroutput on
set feedback off
declare
c pls_integer := dbms_sql.open_cursor;
upd_rows pls_integer;
vers varchar2(50);
tbl varchar2(50);
col varchar2(50);
statement varchar2(255);
begin

select substr(release_name, 1, 2)
into vers
from fnd_product_groups;

if vers >= 11 then
tbl := 'fnd_conflicts_domain';
col := 'runalone_flag';
else
tbl := 'fnd_concurrent_conflict_sets';
col := 'run_alone_flag';
end if;


statement := 'update ' || tbl || ' set ' || col || '=''N'' where ' || col || ' = ''Y''';
dbms_sql.parse(c, statement, dbms_sql.native);
upd_rows := dbms_sql.execute(c);
dbms_sql.close_cursor(c);
dbms_output.put_line('Updated ' || upd_rows || ' rows of ' || col || ' in ' || tbl || ' to ''N''');
end;
/



prompt 

prompt ------------------------------------------------------------------------

prompt Updates complete.
prompt Type commit now to commit these updates, or rollback to cancel.
prompt ------------------------------------------------------------------------

prompt

set feedback on

REM <= Last REM statment -----------------------------------------------------