aria
----
CREATE UNDO TABLESPACE APPS_UNDOTS1 DATAFILE '/data04/PROD/apps_undots01.dbf' size 2147483648, '/data04/PROD/apps_undots02.dbf' size 2147483648, '/data04/PROD/apps_undots03.dbf' size 2147483648, '/data04/PROD/apps_undots04.dbf' size 2147483648, '/data04/PROD/apps_undots05.dbf' size 2147483648 BLOCKSIZE 8192 EXTENT MANAGEMENT LOCAL AUTOALLOCATE;
Shutdown Database
Change Parameter pfile pfile in $ORACLE_HOME/dbs (DB Tier) Edit pfile ‘initPROD.ora’ by change undo_tablespace = ‘APPS_UNDOTS1’ vi initPROD.ora
Startup Database
Drop unused undo tablespace DROP TABLESPACE APPS_UNDOTS1 INCLUDING CONTENTS AND DATAFILES;
----
Recreate UNDO
SQL> SELECT TABLESPACE_NAME FROM DBA_TABLESPACES WHERE CONTENTS='UNDO';

TABLESPACE_NAME
------------------------------
UNDOTBS1

Elapsed: 00:00:00.00
SQL> COL FILE_NAME FOR A50;
SQL> SELECT FILE_NAME,ROUND(BYTES/1024/1024,2)SIZE_MB FROM DBA_DATA_FILES WHERE TABLESPACE_NAME='UNDOTBS1';

FILE_NAME                                             SIZE_MB
-------------------------------------------------- ----------
/oradata/ayam/undotbs01.dbf                               275

Elapsed: 00:00:00.00
SQL> SHO PARAMETER UNDO

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
undo_management                      string      AUTO
undo_retention                       integer     900
undo_tablespace                      string      UNDOTBS1
SQL> CREATE UNDO TABLESPACE APPS_UNDOTS1 DATAFILE
'/oradata/ayam/APPS_UNDOTBS01.dbf' SIZE 64M,
'/oradata/ayam/APPS_UNDOTBS02.dbf' SIZE 64M
EXTENT MANAGEMENT LOCAL AUTOALLOCATE;

Tablespace created.

Elapsed: 00:00:06.08
SQL> ALTER SYSTEM SET undo_tablespace='APPS_UNDOTS1' SCOPE=BOTH;

System altered.

Elapsed: 00:00:00.08
SQL> SHUT IMMEDIATE;
Database closed.
Database dismounted.
ORACLE instance shut down.
SQL> STARTUP;
ORACLE instance started.

Total System Global Area  613855232 bytes
Fixed Size                  2255592 bytes
Variable Size             230688024 bytes
Database Buffers          373293056 bytes
Redo Buffers                7618560 bytes
Database mounted.
Database opened.
SQL> SHO PARAMETER UNDO;

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
undo_management                      string      AUTO
undo_retention                       integer     900
undo_tablespace                      string      APPS_UNDOTS1
SQL> DROP TABLESPACE UNDOTBS1 INCLUDING CONTENTS AND DATAFILES;

Tablespace dropped.

Elapsed: 00:00:00.45
SQL>