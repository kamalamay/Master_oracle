Finding a locking session
Posted on April 8, 2010	by Carlos Acosta

How to identify lockers

This article will explain about locks on rows and on objects in ORACLE.

Locks on rows can cause performance problems or even impede a transaction from finishing, when there are processes running for long time we need to validate that they are not waiting on a row(s).

When there is a lock on a row there is also a lock on the dependent objects, if we want to perform a DDL on a locked object we will get an ORA-00054 error.

Scenario 1:

Terminal A is locking a row and Terminal B is waiting on it:

–TERMINAL A
SQL> UPDATE MAP1 SET COL2='MYLOCK' WHERE COL1=300;
 
1 row updated.
 
SQL>
(..no commit here..)

–TERMINAL B
SQL> UPDATE MAP1 SET COL2='NEWVAL2' WHERE COL1=300;
(..waiting..)

Now, lets create a session as a DBA User to monitor the system, this query will tell the locking and waiting SIDs.

SELECT vh.sid locking_sid, vs.status status, vs.program program_holding, vw.sid waiter_sid, vsw.program program_waiting
FROM v$lock vh, v$lock vw, v$session vs, v$session vsw
WHERE (vh.id1, vh.id2) IN (SELECT id1, id2 FROM v$lock WHERE request = 0 INTERSECT SELECT id1, id2 FROM v$lock WHERE lmode = 0) AND vh.id1 = vw.id1 AND vh.id2 = vw.id2 AND vh.request = 0 AND vw.lmode = 0 AND vh.sid = vs.sid AND vw.sid = vsw.sid;

 LOCKING_SID STATUS   PROGRAM_HOLDING                WAITER_SID PROGRAM_WAITING
----------- -------- ------------------------------ ---------- ------------------------------
 144        ACTIVE   sqlplus@rh4_node1.fadeserver.n        131 sqlplus@rh4_node1.fadeserver.n
                     et (TNS V1-V3)                            et (TNS V1-V3)

Here is an expanded version of the same query, it also includes jobs information.

SELECT vs.username, vs.osuser, vh.sid locking_sid, vs.status status, vs.module module, vs.program program_holding, jrh.job_name, vsw.username, vsw.osuser, vw.sid waiter_sid, vsw.program program_waiting, jrw.job_name, 'alter system kill session ' || ''''|| vh.sid || ',' || vs.serial# || ''';'  "Kill_Command"
FROM v$lock vh, v$lock vw, v$session vs, v$session vsw, dba_scheduler_running_jobs jrh, dba_scheduler_running_jobs jrw
WHERE (vh.id1, vh.id2) IN (SELECT id1, id2 FROM v$lock WHERE request = 0 INTERSECT SELECT id1, id2 FROM v$lock WHERE lmode = 0) AND vh.id1 = vw.id1 AND vh.id2 = vw.id2 AND vh.request = 0 AND vw.lmode = 0 AND vh.sid = vs.sid AND vw.sid = vsw.sid AND vh.sid = jrh.session_id(+) AND vw.sid = jrw.session_id(+);

 USERNAME OSUSER  LOCKING_SID STATUS   MODULE  PROGRAM_HO JOB_N USERNAME OSUSER  WAITER_SID PROGRAM_WA JOB_N Kill_
-------- ------- ----------- -------- ------- ---------- ----- -------- ------- ---------- ---------- ----- -----
CACOSTA  oracle          144 ACTIVE   SQL*Plu sqlplus@rh       CACOSTA  oracle         131 sqlplus@rh       alter
                                      s       4_node1.fa                                   4_node1.fa        syst
                                              deserver.n                                   deserver.n       em ki
                                              et (TNS V1                                   et (TNS V1       ll se
                                              -V3)                                         -V3)             ssion
                                                                                                            '144
                                                                                                            ,3897

'
We can see that the user CACOSTA, sid 144 is locking the session 131.

Scenario 2:
We are performing a DDL (alter somehow the object) and we get an ORA-00054 error.

I have canceled the waiting session in the example above and now I’m creating an index on the table:
SQL> CREATE INDEX IND2 ON MAP1(COL2);
create index ind2 on map1(col2)
 *
ERROR at line 1:
ORA-00054: resource busy and acquire with NOWAIT specified

If I re-run the query fromt he previous scenario it won’t return any rows, because there are no waiting sessions (I canceled the waiting update).

First we need to find out the object ID:

SQL> SELECT OBJECT_ID FROM DBA_OBJECTS WHERE OWNER='CACOSTA' AND OBJECT_NAME='MAP1';
 
 OBJECT_ID
----------
 52255

Now lets see who is blocking the object 52255

SELECT C.OWNER, C.OBJECT_NAME, C.OBJECT_TYPE, B.SID, B.SERIAL#,
B.STATUS, B.OSUSER, B.MACHINE FROM V$LOCKED_OBJECT A, V$SESSION B, DBA_OBJECTS C WHERE B.SID = A.SESSION_ID AND A.OBJECT_ID = C.OBJECT_ID AND A.OBJECT_ID=52255;

OWNER    OBJECT_NAME   OBJECT_TYPE                SID    SERIAL# STATUS   OSUSER  MACHINE
-------- ------------- ------------------- ---------- ---------- -------- ------- ---------------
CACOSTA  MAP1          TABLE                      144      38973 ACTIVE   oracle  rh4_node1.fades

Good luck!