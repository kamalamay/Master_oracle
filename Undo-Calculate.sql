Calculate UNDO_RETENTION for given UNDO Tabespace
-------------------------------------------------
You can choose to allocate a specific size for the UNDO tablespace and then set the UNDO_RETENTION parameter to an optimal value according to the UNDO size and the database activity. If your disk space is limited and you do not want to allocate more space than necessary to the UNDO tablespace, this is the way to proceed. The following query will help you to optimize the UNDO_RETENTION parameter:
Optimal Undo Retention = Actual Undo Size / (DB_BLOCK_SIZE × UNDO_BLOCK_REP_ESC)
Because these following queries use the V$UNDOSTAT statistics, run the queries only after the database has been running with UNDO for a significant and representative time.
Actual Undo Size 
----------------
SELECT ROUND(SUM(A.BYTES)/1024/1024/1024, 2) UNDO_SIZE_GB FROM V$DATAFILE A, V$TABLESPACE B, DBA_TABLESPACES C
WHERE C.CONTENTS='UNDO' AND C.STATUS='ONLINE' AND B.NAME=C.TABLESPACE_NAME AND A.TS#=B.TS#;

Undo Blocks per Second 
----------------------
SELECT MAX(UNDOBLKS/((END_TIME-BEGIN_TIME)*3600*24)) "UNDO_BLOCK_PER_SEC" FROM V$UNDOSTAT;

DB Block Size 
-------------
SELECT TO_NUMBER(VALUE) DB_BLOCK_SIZE_KB FROM V$PARAMETER WHERE UPPER(NAME)='DB_BLOCK_SIZE';

Optimal Undo Retention Calculation 
Formula:
Optimal Undo Retention = Actual Undo Size / (DB_BLOCK_SIZE × UNDO_BLOCK_REP_ESC)
Using Inline Views, you can do all calculation in one query
SQL Code:
SET LINES 200 PAGES 5000;
COL UNDO_RETENTION_SEC FOR A20;
SELECT D.UNDO_SIZE_MB, E.VALUE UNDO_RETENTION_SEC,
ROUND(((D.UNDO_SIZE_MB*1024*1024)/(TO_NUMBER(F.VALUE)*G.UNDO_BLOCK_PER_SEC))) OPTIMAL_UNDO_RETENTION_SEC
FROM
(
  SELECT ROUND(SUM(A.BYTES)/1024/1024, 2) UNDO_SIZE_MB FROM V$DATAFILE A, V$TABLESPACE B, DBA_TABLESPACES C
  WHERE C.CONTENTS='UNDO' AND C.STATUS='ONLINE' AND B.NAME=C.TABLESPACE_NAME AND A.TS#=B.TS#
) D,
V$PARAMETER E,
V$PARAMETER F,
(SELECT MAX(UNDOBLKS/((END_TIME-BEGIN_TIME)*3600*24)) UNDO_BLOCK_PER_SEC FROM V$UNDOSTAT) G
WHERE UPPER(E.NAME)='UNDO_RETENTION' AND UPPER(F.NAME)='DB_BLOCK_SIZE';

SELECT d.undo_size/(1024*1024) "ACTUAL UNDO SIZE [MByte]",
    SUBSTR(e.value,1,25)    "UNDO RETENTION [Sec]",
    ROUND((d.undo_size / (to_number(f.value) *
    g.undo_block_per_sec)))"OPTIMAL UNDO RETENTION [Sec]"
  FROM (
       SELECT SUM(a.bytes) undo_size
          FROM v$datafile a,
               v$tablespace b,
               dba_tablespaces c
         WHERE c.contents = 'UNDO'
           AND c.status = 'ONLINE'
           AND b.name = c.tablespace_name
           AND a.ts# = b.ts#
       ) d,
       v$parameter e,
       v$parameter f,
       (
       SELECT MAX(undoblks/((end_time-begin_time)*3600*24))undo_block_per_sec
       FROM v$undostat
       ) g
WHERE e.name = 'undo_retention'
  AND f.name = 'db_block_size';


Calculate Needed UNDO Size for given Database Activity
If you are not limited by disk space, then it would be better to choose the UNDO_RETENTION time that is best for you (for FLASHBACK, etc.). Allocate the appropriate size to the UNDO tablespace according to the database activity:
Formula:
Undo Size = Optimal Undo Retention × DB_BLOCK_SIZE × UNDO_BLOCK_REP_ESC
Using Inline Views, you can do all calculation in one query
SQL Code:
SELECT d.undo_size/(1024*1024) "ACTUAL UNDO SIZE [MByte]",
       SUBSTR(e.value,1,25) "UNDO RETENTION [Sec]",
       (TO_NUMBER(e.value) * TO_NUMBER(f.value) *
       g.undo_block_per_sec) / (1024*1024)
      "NEEDED UNDO SIZE [MByte]"
  FROM (
       SELECT SUM(a.bytes) undo_size
         FROM v$datafile a,
              v$tablespace b,
              dba_tablespaces c
        WHERE c.contents = 'UNDO'
          AND c.status = 'ONLINE'
          AND b.name = c.tablespace_name
          AND a.ts# = b.ts#
       ) d,
      v$parameter e,
      v$parameter f,
       (
       SELECT MAX(undoblks/((end_time-begin_time)*3600*24))
         undo_block_per_sec
         FROM v$undostat
       ) g
 WHERE e.name = 'undo_retention'
  AND f.name = 'db_block_size'
