SQL> !pwd
/home/orekel/sqlt/install

SQL> SELECT SYSDATE FROM DUAL;

SYSDATE
---------
05-DEC-15

SQL> start sqcreate.sql
  adding: 151205094401_01_sqcreate.log (deflated 79%)
  adding: 151205094507_00_sqdrop.log (deflated 90%)
        zip warning: name not matched: *_ta*.log

zip error: Nothing to do! (SQLT_installation_logs_archive.zip)

PL/SQL procedure successfully completed.


Specify optional Connect Identifier (as per Oracle Net)
Include "@" symbol, ie. @PROD
If not applicable, enter nothing and hit the "Enter" key.
You *MUST* provide a connect identifier when installing
SQLT in a Pluggable Database in 12c
This connect identifier is only used while exporting SQLT
repository everytime you execute one of the main methods.

Optional Connect Identifier (ie: @PROD): @AYAM


PL/SQL procedure successfully completed.


PL/SQL procedure successfully completed.


Define SQLTXPLAIN password (hidden and case sensitive).




Password for user SQLTXPLAIN:
Re-enter password:


PL/SQL procedure successfully completed.

... please wait

TABLESPACE                     FREE_SPACE_MB
------------------------------ -------------
USERS_IX                                7160
USERS                                  29694
EXAMPLE                                32458


Specify PERMANENT tablespace to be used by SQLTXPLAIN.

Tablespace name is case sensitive.

Default tablespace [UNKNOWN]: USERS

PL/SQL procedure successfully completed.

... please wait

TABLESPACE
------------------------------
TEMP


Specify TEMPORARY tablespace to be used by SQLTXPLAIN.

Tablespace name is case sensitive.

Temporary tablespace [UNKNOWN]: TEMP

PL/SQL procedure successfully completed.


The main application user of SQLT is the schema
owner that issued the SQL to be analyzed.
For example, on an EBS application you would
enter APPS.
You will not be asked to enter its password.
To add more SQLT users after this installation
is completed simply grant them the SQLT_USER_ROLE
role.

Main application user of SQLT:

PL/SQL procedure successfully completed.


SQLT can make extensive use of licensed features
provided by the Oracle Diagnostic and the Oracle
Tuning Packs, including SQL Tuning Advisor (STA),
SQL Monitoring and Automatic Workload Repository
(AWR).
To enable or disable access to these features
from the SQLT tool enter one of the following
values when asked:

"T" if you have license for Diagnostic and Tuning
"D" if you have license only for Oracle Diagnostic
"N" if you do not have these two licenses

Oracle Pack license [T]: T

PL/SQL procedure successfully completed.


PL/SQL procedure successfully completed.


PL/SQL procedure successfully completed.


PL/SQL procedure successfully completed.


PL/SQL procedure successfully completed.


PL/SQL procedure successfully completed.


PL/SQL procedure successfully completed.


PL/SQL procedure successfully completed.

TADOBJ completed.

PL/SQL procedure successfully completed.


SQDOLD completed. Ignore errors from this script
  adding: 151205094522_01_sqcreate.log (deflated 89%)






SQCUSR completed. Some errors are expected.

Procedure created.

No errors.
  adding: 151205094619_02_sqcusr.log (deflated 85%)

TAUTLTEST completed.
  adding: 151205094623_09_tautltest.log (deflated 60%)






SQUTLTEST completed.
  adding: 151205094623_10_squtltest.log (deflated 61%)






no rows selected

TACOBJ completed.
  adding: 151205094623_03_tacobj.log (deflated 86%)

SQL> PRO Dropping Libraries for TRCA
Dropping Libraries for TRCA
SQL> SET TERM OFF;
tool_repository_schema: "SQLTXPLAIN"
tool_administer_schema: "SQLTXADMIN"
role_name: "SQLT_USER_ROLE"
Creating Procedures
Creating Package Specs TRCA$G
No errors.
Creating Package Specs TRCA$P
No errors.
Creating Package Specs TRCA$T
No errors.
Creating Package Specs TRCA$I
No errors.
Creating Package Specs TRCA$E
No errors.
Creating Package Specs TRCA$R
No errors.
Creating Package Specs TRCA$X
No errors.
Creating Views
Creating Package Body TRCA$G
No errors.
Creating Package Body TRCA$P
No errors.
Creating Package Body TRCA$T
No errors.
Creating Package Body TRCA$I
No errors.
Creating Package Body TRCA$E
No errors.
Creating Package Body TRCA$R
No errors.
Creating Package Body TRCA$X
No errors.
Creating Grants on Libraries

Tool Version
----------------
12.1.12.1

Install Date
----------------
20151205

Directories
--------------------------------------------------------------------------------------------------------------------------------
TRCA$INPUT1(VALID)      /u01/app/orekel/diag/rdbms/ayam/ayam/trace
TRCA$INPUT2(VALID)      /u01/app/orekel/diag/rdbms/ayam/ayam/trace
TRCA$STAGE(VALID)       /u01/app/orekel/diag/rdbms/ayam/ayam/trace
user_dump_dest
background_dump_dest

Libraries
--------------------------------------------------------------------------------------------------------------------------------
VALID PACKAGE TRCA$I /* $Header: 224270.1 tacpkgi.pks 11.4.5.0 2012/11/21 carlos.sierra $ */
VALID PACKAGE TRCA$E /* $Header: 224270.1 tacpkge.pks 11.4.5.0 2012/11/21 carlos.sierra $ */
VALID PACKAGE TRCA$G /* $Header: 224270.1 tacpkgg.pks 11.4.5.0 2012/11/21 carlos.sierra $ */
VALID PACKAGE TRCA$P /* $Header: 224270.1 tacpkgp.pks 11.4.5.0 2012/11/21 carlos.sierra $ */
VALID PACKAGE TRCA$R /* $Header: 224270.1 tacpkgr.pks 11.4.5.0 2012/11/21 carlos.sierra $ */
VALID PACKAGE TRCA$T /* $Header: 224270.1 tacpkgt.pks 11.4.5.0 2012/11/21 carlos.sierra $ */
VALID PACKAGE TRCA$X /* $Header: 224270.1 tacpkgx.pks 11.4.5.0 2012/11/21 carlos.sierra $ */
VALID PACKAGE BODY TRCA$I /* $Header: 224270.1 tacpkgi.pkb 11.4.5.1 2012/11/27 carlos.sierra $ */
VALID PACKAGE BODY TRCA$E /* $Header: 224270.1 tacpkge.pkb 11.4.5.0 2012/11/21 carlos.sierra $ */
VALID PACKAGE BODY TRCA$G /* $Header: 224270.1 tacpkgg.pkb 12.1.12 2015/09/11 carlos.sierra abel.macias@oracle.com $ */
VALID PACKAGE BODY TRCA$P /* $Header: 224270.1 tacpkgp.pkb 11.4.5.8 2013/05/10 carlos.sierra $ */
VALID PACKAGE BODY TRCA$R /* $Header: 224270.1 tacpkgr.pkb 11.4.5.0 2012/11/21 carlos.sierra $ */
VALID PACKAGE BODY TRCA$T /* $Header: 224270.1 tacpkgt.pkb 11.4.5.7 2013/04/05 carlos.sierra $ */
VALID PACKAGE BODY TRCA$X /* $Header: 224270.1 tacpkgx.pkb 11.4.5.0 2012/11/21 carlos.sierra $ */
TACPKG completed.

PL/SQL procedure successfully completed.

  adding: 151205094632_04_tacpkg.log (deflated 80%)






PL/SQL procedure successfully completed.


SQCOBJ completed. Some errors are expected.
  adding: 151205094700_05_sqcobj.log (deflated 93%)


PL/SQL procedure successfully completed.


SQLT can make extensive use of licensed features
provided by the Oracle Diagnostic and the Oracle
Tuning Packs, including SQL Tuning Advisor (STA),
SQL Monitoring, Automatic Workload Repository
(AWR) and SQL Tuning Sets (STS).
To enable or disable access to these features
from the SQLT tool enter one of the following
values when asked:

"T" if you have license for Diagnostic and Tuning
"D" if you have license only for Oracle Diagnostic
"N" if you do not have these two licenses

pack_license: "T"
enable_tuning_pack_access

PL/SQL procedure successfully completed.


Specify optional Connect Identifier (as per Oracle Net)
Include "@" symbol, ie. @PROD
If not applicable, enter nothing and hit the "Enter" key

connect_identifier: "@AYAM"

PL/SQL procedure successfully completed.


Table truncated.


PL/SQL procedure successfully completed.


PL/SQL procedure successfully completed.


PL/SQL procedure successfully completed.


PL/SQL procedure successfully completed.


PL/SQL procedure successfully completed.


PL/SQL procedure successfully completed.


PL/SQL procedure successfully completed.


Procedure created.

No errors.

Table truncated.


PL/SQL procedure successfully completed.


Procedure dropped.


Commit complete.


SQSEED completed.
  adding: 151205094843_07_sqseed.log (deflated 79%)


PL/SQL procedure successfully completed.

... dropping packages for SQLT
... creating package specs for SQLT$A
SQL> SHOW ERRORS PACKAGE &&tool_administer_schema..sqlt$a;
No errors.
SQL> --
SQL> SET TERM ON ECHO OFF;
... creating package specs for SQLT$C
SQL> SHOW ERRORS PACKAGE &&tool_administer_schema..sqlt$c;
No errors.
SQL> --
SQL> SET TERM ON ECHO OFF;
... creating package specs for SQLT$D
SQL> SHOW ERRORS PACKAGE &&tool_administer_schema..sqlt$d;
No errors.
SQL> --
SQL> SET TERM ON ECHO OFF;
... creating package specs for SQLT$E
SQL> SHOW ERRORS PACKAGE &&tool_administer_schema..sqlt$e;
No errors.
SQL> --
SQL> SET TERM ON ECHO OFF;
... creating package specs for SQLT$H
SQL> SHOW ERRORS PACKAGE &&tool_administer_schema..sqlt$h;
No errors.
SQL> --
SQL> SET TERM ON ECHO OFF;
... creating package specs for SQLT$I
SQL> SHOW ERRORS PACKAGE &&tool_administer_schema..sqlt$i;
No errors.
SQL> --
SQL> SET TERM ON ECHO OFF;
... creating package specs for SQLT$M
SQL> SHOW ERRORS PACKAGE &&tool_administer_schema..sqlt$m;
No errors.
SQL> --
SQL> SET TERM ON ECHO OFF;
... creating package specs for SQLT$R
SQL> SHOW ERRORS PACKAGE &&tool_administer_schema..sqlt$r;
No errors.
SQL> --
SQL> SET TERM ON ECHO OFF;
... creating package specs for SQLT$S
SQL> SHOW ERRORS PACKAGE &&tool_administer_schema..sqlt$s;
No errors.
SQL> --
SQL> SET TERM ON ECHO OFF;
... creating package specs for SQLT$T
SQL> SHOW ERRORS PACKAGE &&tool_administer_schema..sqlt$t;
No errors.
SQL> --
SQL> SET TERM ON ECHO OFF;
... creating views

PL/SQL procedure successfully completed.

... creating package body for SQLT$A
SQL> SHOW ERRORS PACKAGE BODY &&tool_administer_schema..sqlt$a;
No errors.
SQL> --
SQL> SET TERM ON ECHO OFF;
... creating package body for SQLT$C
SQL> SHOW ERRORS PACKAGE BODY &&tool_administer_schema..sqlt$c;
No errors.
SQL> --
SQL> SET TERM ON ECHO OFF;
... creating package body for SQLT$D
SQL> SHOW ERRORS PACKAGE BODY &&tool_administer_schema..sqlt$d;
No errors.
SQL> --
SQL> SET TERM ON ECHO OFF;
... creating package body for SQLT$E
SQL> SHOW ERRORS PACKAGE BODY &&tool_administer_schema..sqlt$e;
No errors.
SQL> --
SQL> SET TERM ON ECHO OFF;
... creating package body for SQLT$H
SQL> SHOW ERRORS PACKAGE BODY &&tool_administer_schema..sqlt$h;
No errors.
SQL> --
SQL> SET TERM ON ECHO OFF;
... creating package body for SQLT$I
SQL> SHOW ERRORS PACKAGE BODY &&tool_administer_schema..sqlt$i;
No errors.
SQL> --
SQL> SET TERM ON ECHO OFF;
... creating package body for SQLT$M
SQL> SHOW ERRORS PACKAGE BODY &&tool_administer_schema..sqlt$m;
No errors.
SQL> --
SQL> SET TERM ON ECHO OFF;
... creating package body for SQLT$R
SQL> SHOW ERRORS PACKAGE BODY &&tool_administer_schema..sqlt$r;
No errors.
SQL> --
SQL> SET TERM ON ECHO OFF;
... creating package body for SQLT$S
SQL> SHOW ERRORS PACKAGE BODY &&tool_administer_schema..sqlt$s;
No errors.
SQL> --
SQL> SET TERM ON ECHO OFF;
... creating package body for SQLT$T
SQL> SHOW ERRORS PACKAGE BODY &&tool_administer_schema..sqlt$t;
No errors.
SQL> --
SQL> SET TERM ON ECHO OFF;

Creating Grants on Packages ...


LIBRARIES
----------------------------------------------------------------
VALID   PACKAGE      12.1.12  SQLT$A
VALID   PACKAGE      12.1.10  SQLT$C
VALID   PACKAGE      12.1.11  SQLT$D
VALID   PACKAGE      12.1.10  SQLT$E
VALID   PACKAGE      12.1.10  SQLT$H
VALID   PACKAGE      12.1.10  SQLT$I
VALID   PACKAGE      12.1.10  SQLT$M
VALID   PACKAGE      12.1.10  SQLT$R
VALID   PACKAGE      12.1.10  SQLT$S
VALID   PACKAGE      12.1.10  SQLT$T
VALID   PACKAGE      11.4.5.0 TRCA$E
VALID   PACKAGE      11.4.5.0 TRCA$G
VALID   PACKAGE      11.4.5.0 TRCA$I
VALID   PACKAGE      11.4.5.0 TRCA$P
VALID   PACKAGE      11.4.5.0 TRCA$R
VALID   PACKAGE      11.4.5.0 TRCA$T
VALID   PACKAGE      11.4.5.0 TRCA$X
VALID   PACKAGE BODY 12.1.12  SQLT$A
VALID   PACKAGE BODY 12.1.10  SQLT$C
VALID   PACKAGE BODY 12.1.12.1SQLT$D
VALID   PACKAGE BODY 12.1.10  SQLT$E

LIBRARIES
----------------------------------------------------------------
VALID   PACKAGE BODY 12.1.12  SQLT$H
VALID   PACKAGE BODY 12.1.11  SQLT$I
VALID   PACKAGE BODY 12.1.12.1SQLT$M
VALID   PACKAGE BODY 12.1.12  SQLT$R
VALID   PACKAGE BODY 12.1.10  SQLT$S
VALID   PACKAGE BODY 12.1.12  SQLT$T
VALID   PACKAGE BODY 11.4.5.0 TRCA$E
VALID   PACKAGE BODY 12.1.12  TRCA$G
VALID   PACKAGE BODY 11.4.5.1 TRCA$I
VALID   PACKAGE BODY 11.4.5.8 TRCA$P
VALID   PACKAGE BODY 11.4.5.0 TRCA$R
VALID   PACKAGE BODY 11.4.5.7 TRCA$T
VALID   PACKAGE BODY 11.4.5.0 TRCA$X

Deleting CBO statistics for SQLTXPLAIN objects ...

09:50:03    0 sqlt$a: -> delete_sqltxplain_stats
09:50:10    7 sqlt$a: <- delete_sqltxplain_stats

PL/SQL procedure successfully completed.


SQCPKG completed.
  adding: 151205094844_08_sqcpkg.log (deflated 79%)






TAUTLTEST completed.
  adding: 151205095010_09_tautltest.log (deflated 59%)






SQUTLTEST completed.
  adding: 151205095010_10_squtltest.log (deflated 59%)


SQLT users must be granted SQLT_USER_ROLE before using this tool.

SQCREATE completed. Installation completed successfully.
SQL>