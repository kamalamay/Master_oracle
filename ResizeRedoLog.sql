--Redo log information
COL MEMBER FOR A80;
SELECT * FROM V$LOGFILE ORDER BY 1;
COL STATUS FOR A10;
SELECT GROUP#, THREAD#, SEQUENCE#, ROUND((BYTES/1024/1024),2)REDO_MB, MEMBERS, ARCHIVED, STATUS, FIRST_CHANGE# FROM V$LOG ORDER BY 1;

--1 INFO
SELECT * FROM V$LOGFILE ORDER BY 1;

    GROUP# STATUS  TYPE    MEMBER                                                                           IS_
---------- ------- ------- -------------------------------------------------------------------------------- ---
         1         ONLINE  /mp01/onlinelog-duck/o1_mf_1_cymx6xnd_.log                                       NO
         1         ONLINE  /u01/app/orekel/fast_recovery_area/DUCK/onlinelog/o1_mf_1_cymx6xot_.log          YES
         2         ONLINE  /mp01/onlinelog-duck/o1_mf_2_cymx6zml_.log                                       NO
         2         ONLINE  /u01/app/orekel/fast_recovery_area/DUCK/onlinelog/o1_mf_2_cymx6zo8_.log          YES
         3         ONLINE  /mp01/onlinelog-duck/o1_mf_3_cymx71kj_.log                                       NO
         3         ONLINE  /u01/app/orekel/fast_recovery_area/DUCK/onlinelog/o1_mf_3_cymx71lx_.log          YES

6 rows selected.

Elapsed: 00:00:00.02
COL STATUS FOR A10;
SQL> SELECT GROUP#, THREAD#, SEQUENCE#, ROUND((BYTES/1024/1024),2)REDO_MB, MEMBERS, ARCHIVED, STATUS, FIRST_CHANGE# FROM V$LOG ORDER BY 1;

    GROUP#    THREAD#  SEQUENCE#    REDO_MB    MEMBERS ARC STATUS     FIRST_CHANGE#
---------- ---------- ---------- ---------- ---------- --- ---------- -------------
         1          1        214         50          2 YES INACTIVE         1588515
         2          1        215         50          2 NO  CURRENT          1588730
         3          1        213         50          2 YES INACTIVE         1588426

Elapsed: 00:00:00.01
SQL>

--2 CHECKPOINT
SQL> ALTER SYSTEM CHECKPOINT GLOBAL;

System altered.

Elapsed: 00:00:00.14
SQL> SELECT GROUP#, THREAD#, SEQUENCE#, ROUND((BYTES/1024/1024),2)REDO_MB, MEMBERS, ARCHIVED, STATUS, FIRST_CHANGE# FROM V$LOG ORDER BY 1;

    GROUP#    THREAD#  SEQUENCE#    REDO_MB    MEMBERS ARC STATUS     FIRST_CHANGE#
---------- ---------- ---------- ---------- ---------- --- ---------- -------------
         1          1        214         50          2 YES INACTIVE         1588515
         2          1        215         50          2 NO  CURRENT          1588730
         3          1        213         50          2 YES INACTIVE         1588426

Elapsed: 00:00:00.00
SQL>

--3 DROP INACTIVE
SQL> ALTER DATABASE DROP LOGFILE GROUP 1;

Database altered.

Elapsed: 00:00:00.18
SQL> SELECT GROUP#, THREAD#, SEQUENCE#, ROUND((BYTES/1024/1024),2)REDO_MB, MEMBERS, ARCHIVED, STATUS, FIRST_CHANGE# FROM V$LOG ORDER BY 1;

    GROUP#    THREAD#  SEQUENCE#    REDO_MB    MEMBERS ARC STATUS     FIRST_CHANGE#
---------- ---------- ---------- ---------- ---------- --- ---------- -------------
         2          1        215         50          2 NO  CURRENT          1588730
         3          1        213         50          2 YES INACTIVE         1588426

Elapsed: 00:00:00.01
SQL>

--4 ADD REDO
SQL> SELECT * FROM V$LOGFILE ORDER BY 1;

    GROUP# STATUS     TYPE    MEMBER                                                                           IS_
---------- ---------- ------- -------------------------------------------------------------------------------- ---
         2            ONLINE  /mp01/onlinelog-duck/o1_mf_2_cymx6zml_.log                                       NO
         2            ONLINE  /u01/app/orekel/fast_recovery_area/DUCK/onlinelog/o1_mf_2_cymx6zo8_.log          YES
         3            ONLINE  /mp01/onlinelog-duck/o1_mf_3_cymx71kj_.log                                       NO
         3            ONLINE  /u01/app/orekel/fast_recovery_area/DUCK/onlinelog/o1_mf_3_cymx71lx_.log          YES

Elapsed: 00:00:00.00
SQL> ALTER DATABASE ADD LOGFILE GROUP 1 SIZE 150M;

Database altered.

Elapsed: 00:00:05.65
SQL> SELECT * FROM V$LOGFILE ORDER BY 1;

    GROUP# STATUS     TYPE    MEMBER                                                                           IS_
---------- ---------- ------- -------------------------------------------------------------------------------- ---
         1            ONLINE  /mp01/DUCK/onlinelog/o1_mf_1_d1bpqxn0_.log                                       NO
         1            ONLINE  /u01/app/orekel/fast_recovery_area/DUCK/onlinelog/o1_mf_1_d1bpqzlf_.log          YES
         2            ONLINE  /mp01/onlinelog-duck/o1_mf_2_cymx6zml_.log                                       NO
         2            ONLINE  /u01/app/orekel/fast_recovery_area/DUCK/onlinelog/o1_mf_2_cymx6zo8_.log          YES
         3            ONLINE  /mp01/onlinelog-duck/o1_mf_3_cymx71kj_.log                                       NO
         3            ONLINE  /u01/app/orekel/fast_recovery_area/DUCK/onlinelog/o1_mf_3_cymx71lx_.log          YES

6 rows selected.

Elapsed: 00:00:00.00
SQL> SELECT GROUP#, THREAD#, SEQUENCE#, ROUND((BYTES/1024/1024),2)REDO_MB, MEMBERS, ARCHIVED, STATUS, FIRST_CHANGE# FROM V$LOG ORDER BY 1;

    GROUP#    THREAD#  SEQUENCE#    REDO_MB    MEMBERS ARC STATUS     FIRST_CHANGE#
---------- ---------- ---------- ---------- ---------- --- ---------- -------------
         1          1          0        150          2 YES UNUSED                 0
         2          1        215         50          2 NO  CURRENT          1588730
         3          1        213         50          2 YES INACTIVE         1588426

Elapsed: 00:00:00.00
SQL>

-- REPEAT UNTIL ALL REDO RESIZED, REMEMBER DROP INACTIVE!!