ALTER TABLESPACE cust_ts OFFLINE;
mv 'OLDFILE.DBF ' 'NEWFILE.DBF'
ALTER TABLESPACE cust_ts RENAME datafile '/u01/app/oracle/mysid/oldname.dbf' TO '/u01/app/oracle/mysid/newname.dbf';
ALTER TABLESPACE cust_ts ONLINE;

Database data file rename

We can also use the alter database rename datafile command, but the data file must be renamed in the OS (using the mv linux command) while the database is down and the rename data file must be done while the database is un-opened (in the mount stage):

shutdown IMMEDIATE;
mv 'OLDFILE.DBF ' 'NEWFILE.DBF'
startup mount;
ALTER DATABASE RENAME file '/u01/app/oracle/mysid/oldname.dbf' TO '/u01/app/oracle/mysid/newname.dbf';
---
Redo log
---
SQL> SHUTDOWN IMMEDIATE
Database closed.
Database dismounted.
ORACLE instance shut down.
SQL> HOST MOVE C:\ORACLE\PRODUCT\10.1.0\ORADATA\DB10G\REDO01.LOG C:\ORACLE\PRODUCT\10.1.0\ORADATA\DB10G\RENAME_REDO01.LOG

SQL> STARTUP MOUNT
ORACLE instance started.

Total System Global Area  167772160 bytes
Fixed Size                   787968 bytes
Variable Size              61864448 bytes
Database Buffers          104857600 bytes
Redo Buffers                 262144 bytes
Database mounted.
SQL> ALTER DATABASE RENAME FILE 'C:\ORACLE\PRODUCT\10.1.0\ORADATA\DB10G\REDO01.LOG' -
>  TO 'C:\ORACLE\PRODUCT\10.1.0\ORADATA\DB10G\RENAME_REDO01.LOG';

Database altered.

SQL> ALTER DATABASE OPEN;

Database altered.

SQL>

---

STARTUP MOUNT;

ALTER DATABASE RENAME FILE '/oradata/ayam/ayam/example01.dbf' TO '/mp01/oradata-ayam/example01.dbf';

--ALTER DATABASE RENAME FILE '/oradata/ayam/ayam/sysaux01.dbf' TO '/mp01/oradata-ayam/sysaux01.dbf';

ALTER DATABASE RENAME FILE '/oradata/ayam/ayam/system01.dbf' TO '/mp01/oradata-ayam/system01.dbf';

ALTER DATABASE RENAME FILE '/oradata/ayam/ayam/undotbs01.dbf' TO '/mp01/oradata-ayam/undotbs01.dbf';

ALTER DATABASE RENAME FILE '/oradata/ayam/ayam/users01.dbf' TO '/mp01/oradata-ayam/users01.dbf';

ALTER DATABASE RENAME FILE '/oradata/ayam/ayam/users02.dbf' TO '/mp01/oradata-ayam/users02.dbf';

ALTER DATABASE RENAME FILE '/oradata/ayam/ayam/users03.dbf' TO '/mp01/oradata-ayam/users03.dbf';

ALTER DATABASE RENAME FILE '/oradata/ayam/ayam/users04.dbf' TO '/mp01/oradata-ayam/users04.dbf';