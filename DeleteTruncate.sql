CREATE TABLE scott.TI2 (X VARCHAR2(5), Y VARCHAR2(5), Z VARCHAR2(5));

CREATE INDEX IX_TI2_X ON TI2(X);

BEGIN
  FOR I IN 1..99999 LOOP
    INSERT INTO scott.TI2 VALUES(I,I,I);
  END LOOP;
  COMMIT;
END;
/

ANALYZE TABLE scott.TI2 COMPUTE STATISTICS FOR ALL INDEXES FOR ALL INDEXED COLUMNS;

SQL> select count(1)jml from scott.TI2;

       JML
----------
    519995

1 row selected.

Elapsed: 00:00:00.03
SQL> SELECT ROUND(BYTES/1024/1024,2)MB, OWNER, SEGMENT_NAME FROM DBA_SEGMENTS WHERE OWNER='SCOTT' AND SEGMENT_NAME='TI2';

        MB OWNER                          SEGMENT_NAME
---------- ------------------------------ ---------------------------------------------------------------------------------
        13 SCOTT                          TI2

1 row selected.

Elapsed: 00:00:00.02
SQL> DELETE FROM SCOTT.TI2;

519995 rows deleted.

Elapsed: 00:00:07.05
SQL> TRUNCATE TABLE SCOTT.TI2;

Table truncated.

Elapsed: 00:00:00.55
SQL> SELECT ROUND(BYTES/1024/1024,2)MB, OWNER, SEGMENT_NAME FROM DBA_SEGMENTS WHERE OWNER='SCOTT' AND SEGMENT_NAME='TI2';

        MB OWNER                          SEGMENT_NAME
---------- ------------------------------ ---------------------------------------------------------------------------------
       .06 SCOTT                          TI2

1 row selected.

Elapsed: 00:00:00.04
SQL>

---

SQL> select count(1)jml from scott.TI2;

       JML
----------
    799992

1 row selected.

Elapsed: 00:00:00.05
SQL> SELECT ROUND(BYTES/1024/1024,2)MB, OWNER, SEGMENT_NAME FROM DBA_SEGMENTS WHERE OWNER='SCOTT' AND SEGMENT_NAME='TI2';

        MB OWNER                          SEGMENT_NAME
---------- ------------------------------ ---------------------------------------------------------------------------------
        20 SCOTT                          TI2

1 row selected.

Elapsed: 00:00:00.02
SQL> DELETE FROM SCOTT.TI2;

799992 rows deleted.

Elapsed: 00:00:13.49
SQL> COMMIT;

Commit complete.

Elapsed: 00:00:00.07
SQL> ANALYZE TABLE scott.TI2 COMPUTE STATISTICS FOR ALL INDEXES FOR ALL INDEXED COLUMNS;

Table analyzed.

Elapsed: 00:00:00.05
SQL> select count(1)jml from scott.TI2;

       JML
----------
         0

1 row selected.

Elapsed: 00:00:00.04
SQL> SELECT ROUND(BYTES/1024/1024,2)MB, OWNER, SEGMENT_NAME FROM DBA_SEGMENTS WHERE OWNER='SCOTT' AND SEGMENT_NAME='TI2';

        MB OWNER                          SEGMENT_NAME
---------- ------------------------------ ---------------------------------------------------------------------------------
        20 SCOTT                          TI2

1 row selected.

Elapsed: 00:00:00.02
SQL>