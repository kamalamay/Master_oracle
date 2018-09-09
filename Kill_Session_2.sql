SET LINESIZE 100
COLUMN spid FORMAT A10
COLUMN username FORMAT A10
COLUMN program FORMAT A45

SET LINES 200 PAGES 5000;
COL SIDSERIAL FOR A20;
SELECT s.inst_id,s.sid||','||s.serial# sidserial,p.spid,s.username,s.program
FROM   gv$session s JOIN gv$process p ON p.addr = s.paddr AND p.inst_id = s.inst_id
WHERE  UPPER(s.type) != 'BACKGROUND' AND UPPER(S.STATUS)='ACTIVE' ORDER BY PROGRAM;

SELECT 'ALTER SYSTEM KILL SESSION '''||s.sid||','||s.serial#||''' IMMEDIATE;'PERINTAH
FROM gv$session s JOIN gv$process p ON p.addr = s.paddr AND p.inst_id = s.inst_id
WHERE  UPPER(s.type) != 'BACKGROUND' AND UPPER(S.STATUS)='ACTIVE' AND UPPER(S.program)!='SQLPLUS.EXE';

SELECT * FROM V$SESSION WHERE STATUS='ACTIVE';

SELECT 'ALTER SYSTEM KILL SESSION '''||S.sid||','||s.serial#||''' IMMEDIATE;' SYNTAX, s.inst_id, s.sid||','||s.serial# SID_SERIAL, p.spid, s.username, s.program
FROM gv$session s JOIN gv$process p ON p.addr = s.paddr AND p.inst_id = s.inst_id WHERE  s.type != 'BACKGROUND' AND S.STATUS='ACTIVE';