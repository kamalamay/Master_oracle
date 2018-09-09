SQL> rlwrap sqlplus sys as sysdba
SQL> show parameter memory;

NAME				     TYPE	 VALUE
------------------------------------ ----------- ------------------------------
hi_shared_memory_address	     integer	 0
memory_max_target		     big integer 652M
memory_target			     big integer 652M
shared_memory_address		     integer	 0
SQL> create pfile='/home/prastyo/app/prastyo/product/11.2.0/dbhome_1/dbs/initAzizPW.ora' from spfile;

File created.

SQL> alter system set memory_max_target=700M scope=spfile;

System altered.

SQL> alter system set memory_target=700M scope=spfile;

System altered.

SQL> show parameter memory;

NAME				     TYPE	 VALUE
------------------------------------ ----------- ------------------------------
hi_shared_memory_address	     integer	 0
memory_max_target		     big integer 652M
memory_target			     big integer 652M
shared_memory_address		     integer	 0
SQL> shutdown immediate;
Database closed.
Database dismounted.
ORACLE instance shut down.
SQL> startup;
ORACLE instance started.

Total System Global Area  730714112 bytes
Fixed Size		    2216944 bytes
Variable Size		  457182224 bytes
Database Buffers	  264241152 bytes
Redo Buffers		    7073792 bytes
Database mounted.
Database opened.
SQL> show parameter memory;

NAME				     TYPE	 VALUE
------------------------------------ ----------- ------------------------------
hi_shared_memory_address	     integer	 0
memory_max_target		     big integer 700M
memory_target			     big integer 700M
shared_memory_address		     integer	 0
SQL>


KONDISI ERROR
-------------
SQL> startup;
ORA-00845: MEMORY_TARGET not supported on this system
SQL> startup pfile='/home/prastyo/app/prastyo/product/11.2.0/dbhome_1/dbs/initAzizPW.ora';
ORACLE instance started.

Total System Global Area  680607744 bytes
Fixed Size		    2216464 bytes
Variable Size		  406851056 bytes
Database Buffers	  264241152 bytes
Redo Buffers		    7299072 bytes
Database mounted.
Database opened.
SQL> create spfile from pfile='/home/prastyo/app/prastyo/product/11.2.0/dbhome_1/dbs/initAzizPW.ora';

File created.

SQL> shutdown immediate;
Database closed.
Database dismounted.
ORACLE instance shut down.
SQL> startup;
ORACLE instance started.

Total System Global Area  680607744 bytes
Fixed Size		    2216464 bytes
Variable Size		  406851056 bytes
Database Buffers	  264241152 bytes
Redo Buffers		    7299072 bytes
Database mounted.
Database opened.
SQL>
