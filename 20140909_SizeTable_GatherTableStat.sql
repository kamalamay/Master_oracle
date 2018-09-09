SELECT ROUND((SUM(BYTES))/1024/1024/1024,2)SIZE_GB FROM DBA_DATA_FILES;

SELECT OWNER||'.'||TABLE_NAME TABEL FROM DBA_TABLES WHERE OWNER LIKE 'C##%' ORDER BY OWNER;

EXPLAIN PLAN FOR SELECT COUNT(*)JML FROM C##AZIZPW.VASSADWANKR

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

SELECT ROUND(X.BYTES/1024/1024/1024, 2) SIZE_GB, X.* FROM DBA_SEGMENTS X WHERE SEGMENT_TYPE='TABLE' AND OWNER||'.'||SEGMENT_NAME='C##AZIZPW.VASSADWANKR';

Plan hash value: 3254385395
 
--------------------------------------------------------------------------
| Id  | Operation          | Name        | Rows  | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |             |     1 | 15308   (1)| 00:00:01 |
|   1 |  SORT AGGREGATE    |             |     1 |            |          |
|   2 |   TABLE ACCESS FULL| VASSADWANKR |    11M| 15308   (1)| 00:00:01 |
--------------------------------------------------------------------------

CREATE TABLESPACE IDX DATAFILE '/oradata/kelinci/IDX_01.dbf' SIZE 512M REUSE AUTOEXTEND OFF;

CREATE INDEX C##AZIZPW.VASSADWANKR_MSISDNIDX ON C##AZIZPW.VASSADWANKR(MSISDN) TABLESPACE IDX

SELECT OWNER||'.'||INDEX_NAME AS IDXNAME, TABLE_NAME, TABLESPACE_NAME FROM DBA_INDEXES WHERE TABLE_NAME='VASSADWANKR';

Plan hash value: 3254385395
 
--------------------------------------------------------------------------
| Id  | Operation          | Name        | Rows  | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |             |     1 | 15308   (1)| 00:00:01 |
|   1 |  SORT AGGREGATE    |             |     1 |            |          |
|   2 |   TABLE ACCESS FULL| VASSADWANKR |    11M| 15308   (1)| 00:00:01 |
--------------------------------------------------------------------------

SELECT * FROM DICT WHERE TABLE_NAME LIKE '%SQL%' ORDER BY 1;

SELECT * FROM V$SQLTEXT WHERE SQL_TEXT LIKE 'SELECT COUNT(%';

0000000074918968    1244362500    6usmxfx52qxs4    3    0    SELECT COUNT(1)JML FROM C##AZIZPW.VASSADWANKR    1

exeCUTE DBMS_STATS.GATHER_TABLE_STATS('C##AZIZPW','VASSADWANKR')