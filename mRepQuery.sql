SELECT a.THREAD#, MAX(a.SEQUENCE#)+1, max(b.RESETLOGS_ID) FROM v$LOG_HISTORY a, v$database_incarnation b WHERE a.RESETLOGS_CHANGE# = b.RESETLOGS_CHANGE# GROUP BY a.THREAD#

select maxSCN AS PRIMARY from (select  max(sequence#) almax from v$archived_log
where resetlogs_change#=(select resetlogs_change# from v$database where THREAD#=1)) al,(select max(sequence#) maxSCN from v$log_history
where first_time=(select max(first_time) from v$log_history where THREAD#=1)) lh;

ALTER SYSTEM SWITCH LOGFILE;