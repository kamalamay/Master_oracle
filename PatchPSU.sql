--Sebelum Patch
ACTION_TIME                    ACTION     NAMESPACE  VERSION     ID COMMENTS                                                                    BUNDLE_SERIES
------------------------------ ---------- ---------- ---------- --- --------------------------------------------------------------------------- ---------------
24-AUG-13 12.03.45.119862 PM   APPLY      SERVER     11.2.0.4     0 Patchset 11.2.0.2.0                                                         PSU
23-FEB-15 08.32.47.035270 PM   APPLY      SERVER     11.2.0.4     0 Patchset 11.2.0.2.0                                                         PSU

Elapsed: 00:00:00.01
SQL> SELECT BANNER FROM V$VERSION;

BANNER
--------------------------------------------------------------------------------
Oracle Database 11g Enterprise Edition Release 11.2.0.4.0 - 64bit Production
PL/SQL Release 11.2.0.4.0 - Production
CORE    11.2.0.4.0      Production
TNS for Linux: Version 11.2.0.4.0 - Production
NLSRTL Version 11.2.0.4.0 - Production

Elapsed: 00:00:00.00
SQL>

--Versi opatch
[orekel@pitik OPatch]$ ./opatch version
OPatch Version: 11.2.0.3.4

OPatch succeeded.
[orekel@pitik OPatch]$ pwd
/u01/app/orekel/product/11.2.0.4/db_1/OPatch
[orekel@pitik OPatch]$

--Ganti/upgrade OPatch
[orekel@pitik OPatch]$ ./opatch version
OPatch Version: 11.2.0.3.12

OPatch succeeded.
[orekel@pitik OPatch]$

--Prereq
[orekel@pitik 21352635]$ /u01/app/orekel/product/11.2.0.4/db_1/OPatch/opatch prereq CheckConflictAgainstOHWithDetail -ph ./
Oracle Interim Patch Installer version 11.2.0.3.12
Copyright (c) 2015, Oracle Corporation.  All rights reserved.

PREREQ session

Oracle Home       : /u01/app/orekel/product/11.2.0.4/db_1
Central Inventory : /u01/app/oraInventory
   from           : /u01/app/orekel/product/11.2.0.4/db_1/oraInst.loc
OPatch version    : 11.2.0.3.12
OUI version       : 11.2.0.4.0
Log file location : /u01/app/orekel/product/11.2.0.4/db_1/cfgtoollogs/opatch/opatch2015-12-03_20-06-17PM_1.log

Invoking prereq "checkconflictagainstohwithdetail"

Prereq "checkConflictAgainstOHWithDetail" passed.

OPatch succeeded.
[orekel@pitik 21352635]$

--Shutdown instance and listener
[orekel@pitik 21352635]$ rlwrap sqlplus SYS AS SYSDBA

SQL*Plus: Release 11.2.0.4.0 Production on Thu Dec 3 20:09:25 2015

Copyright (c) 1982, 2013, Oracle.  All rights reserved.

Enter password:

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.4.0 - 64bit Production
With the Partitioning, OLAP, Data Mining and Real Application Testing options

SQL> !lsnrctl stop

LSNRCTL for Linux: Version 11.2.0.4.0 - Production on 03-DEC-2015 20:09:34

Copyright (c) 1991, 2013, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=pitik)(PORT=1521)))
TNS-12541: TNS:no listener
 TNS-12560: TNS:protocol adapter error
  TNS-00511: No listener
   Linux Error: 111: Connection refused
Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=EXTPROC1521)))
TNS-12541: TNS:no listener
 TNS-12560: TNS:protocol adapter error
  TNS-00511: No listener
   Linux Error: 111: Connection refused

SQL> SHUT IMMEDIATE;
Database closed.
Database dismounted.
ORACLE instance shut down.
SQL>

--Apply patch
[orekel@pitik 21352635]$ pwd
/u01/app/orekel/21352635
[orekel@pitik 21352635]$ /u01/app/orekel/product/11.2.0.4/db_1/OPatch/opatch apply
Oracle Interim Patch Installer version 11.2.0.3.12
Copyright (c) 2015, Oracle Corporation.  All rights reserved.


Oracle Home       : /u01/app/orekel/product/11.2.0.4/db_1
Central Inventory : /u01/app/oraInventory
   from           : /u01/app/orekel/product/11.2.0.4/db_1/oraInst.loc
OPatch version    : 11.2.0.3.12
OUI version       : 11.2.0.4.0
Log file location : /u01/app/orekel/product/11.2.0.4/db_1/cfgtoollogs/opatch/opatch2015-12-03_20-10-46PM_1.log

Verifying environment and performing prerequisite checks...
OPatch continues with these patches:   17478514  18031668  18522509  19121551  19769489  20299013  20760982  21352635

Do you want to proceed? [y|n]
y
User Responded with: Y
All checks passed.
Provide your email address to be informed of security issues, install and
initiate Oracle Configuration Manager. Easier for you if you use your My
Oracle Support Email address/User Name.
Visit http://www.oracle.com/support/policies.html for details.
Email address/User Name:

You have not provided an email address for notification of security issues.
Do you wish to remain uninformed of security issues ([Y]es, [N]o) [N]:  Y



Please shutdown Oracle instances running out of this ORACLE_HOME on the local system.
(Oracle Home = '/u01/app/orekel/product/11.2.0.4/db_1')


Is the local system ready for patching? [y|n]
y
User Responded with: Y
Backing up files...
Applying sub-patch '17478514' to OH '/u01/app/orekel/product/11.2.0.4/db_1'

Patching component oracle.rdbms, 11.2.0.4.0...

Patching component oracle.rdbms.rsf, 11.2.0.4.0...

Patching component oracle.sdo, 11.2.0.4.0...

Patching component oracle.sysman.agent, 10.2.0.4.5...

Patching component oracle.xdk, 11.2.0.4.0...

Patching component oracle.rdbms.dbscripts, 11.2.0.4.0...

Patching component oracle.sdo.locator, 11.2.0.4.0...

Patching component oracle.nlsrtl.rsf, 11.2.0.4.0...

Patching component oracle.xdk.rsf, 11.2.0.4.0...

Patching component oracle.rdbms.rman, 11.2.0.4.0...
Applying sub-patch '18031668' to OH '/u01/app/orekel/product/11.2.0.4/db_1'

Patching component oracle.rdbms, 11.2.0.4.0...

Patching component oracle.rdbms.rsf, 11.2.0.4.0...

Patching component oracle.ldap.rsf, 11.2.0.4.0...

Patching component oracle.rdbms.crs, 11.2.0.4.0...

Patching component oracle.precomp.common, 11.2.0.4.0...

Patching component oracle.ldap.rsf.ic, 11.2.0.4.0...

Patching component oracle.rdbms.deconfig, 11.2.0.4.0...

Patching component oracle.rdbms.dbscripts, 11.2.0.4.0...

Patching component oracle.rdbms.rman, 11.2.0.4.0...
Applying sub-patch '18522509' to OH '/u01/app/orekel/product/11.2.0.4/db_1'

Patching component oracle.rdbms.rsf, 11.2.0.4.0...

Patching component oracle.rdbms, 11.2.0.4.0...

Patching component oracle.precomp.common, 11.2.0.4.0...

Patching component oracle.rdbms.rman, 11.2.0.4.0...

Patching component oracle.rdbms.dbscripts, 11.2.0.4.0...

Patching component oracle.rdbms.deconfig, 11.2.0.4.0...
Applying sub-patch '19121551' to OH '/u01/app/orekel/product/11.2.0.4/db_1'

Patching component oracle.precomp.common, 11.2.0.4.0...

Patching component oracle.sysman.console.db, 11.2.0.4.0...

Patching component oracle.rdbms.rsf, 11.2.0.4.0...

Patching component oracle.rdbms.rman, 11.2.0.4.0...

Patching component oracle.rdbms, 11.2.0.4.0...

Patching component oracle.rdbms.dbscripts, 11.2.0.4.0...

Patching component oracle.ordim.client, 11.2.0.4.0...

Patching component oracle.ordim.jai, 11.2.0.4.0...
Applying sub-patch '19769489' to OH '/u01/app/orekel/product/11.2.0.4/db_1'
ApplySession: Optional component(s) [ oracle.sysman.agent, 11.2.0.4.0 ]  not present in the Oracle Home or a higher version is found.

Patching component oracle.precomp.common, 11.2.0.4.0...

Patching component oracle.ovm, 11.2.0.4.0...

Patching component oracle.xdk, 11.2.0.4.0...

Patching component oracle.rdbms.util, 11.2.0.4.0...

Patching component oracle.rdbms, 11.2.0.4.0...

Patching component oracle.rdbms.dbscripts, 11.2.0.4.0...

Patching component oracle.xdk.parser.java, 11.2.0.4.0...

Patching component oracle.oraolap, 11.2.0.4.0...

Patching component oracle.rdbms.rsf, 11.2.0.4.0...

Patching component oracle.xdk.rsf, 11.2.0.4.0...

Patching component oracle.rdbms.rman, 11.2.0.4.0...

Patching component oracle.rdbms.deconfig, 11.2.0.4.0...
Applying sub-patch '20299013' to OH '/u01/app/orekel/product/11.2.0.4/db_1'

Patching component oracle.rdbms.dv, 11.2.0.4.0...

Patching component oracle.rdbms.oci, 11.2.0.4.0...

Patching component oracle.precomp.common, 11.2.0.4.0...

Patching component oracle.sysman.agent, 10.2.0.4.5...

Patching component oracle.xdk, 11.2.0.4.0...

Patching component oracle.sysman.common, 10.2.0.4.5...

Patching component oracle.rdbms, 11.2.0.4.0...

Patching component oracle.rdbms.dbscripts, 11.2.0.4.0...

Patching component oracle.xdk.parser.java, 11.2.0.4.0...

Patching component oracle.sysman.console.db, 11.2.0.4.0...

Patching component oracle.xdk.rsf, 11.2.0.4.0...

Patching component oracle.rdbms.rsf, 11.2.0.4.0...

Patching component oracle.sysman.common.core, 10.2.0.4.5...

Patching component oracle.rdbms.rman, 11.2.0.4.0...

Patching component oracle.rdbms.deconfig, 11.2.0.4.0...
Applying sub-patch '20760982' to OH '/u01/app/orekel/product/11.2.0.4/db_1'

Patching component oracle.sysman.console.db, 11.2.0.4.0...

Patching component oracle.rdbms, 11.2.0.4.0...

Patching component oracle.rdbms.dbscripts, 11.2.0.4.0...
Applying sub-patch '21352635' to OH '/u01/app/orekel/product/11.2.0.4/db_1'

Patching component oracle.sysman.agent, 10.2.0.4.5...

Patching component oracle.rdbms.rsf, 11.2.0.4.0...

Patching component oracle.rdbms.rman, 11.2.0.4.0...

Patching component oracle.rdbms, 11.2.0.4.0...

OPatch found the word "warning" in the stderr of the make command.
Please look at this stderr. You can re-run this make command.
Stderr output:
/usr/bin/ld: warning: -z lazyload ignored.
/usr/bin/ld: warning: -z nolazyload ignored.


Composite patch 21352635 successfully applied.
OPatch Session completed with warnings.
Log file location: /u01/app/orekel/product/11.2.0.4/db_1/cfgtoollogs/opatch/opatch2015-12-03_20-10-46PM_1.log

OPatch completed with warnings.
[orekel@pitik 21352635]$

--Post installation patch
SQL> STARTUP;
SQL> @?/rdbms/admin/catbundle.sql psu apply

--Cek invalid objek
SELECT COUNT(1)INV_OBJ FROM DBA_OBJECTS WHERE STATUS = 'INVALID';
SELECT /*+PARALLEL(8)*/OWNER||'.'||OBJECT_NAME OBJNAME, OBJECT_TYPE OBJTYPE FROM DBA_OBJECTS WHERE STATUS='INVALID' ORDER BY 1;

   INV_OBJ
----------
         1

1 row selected.

SQL>
OBJNAME                                                      OBJTYPE
------------------------------------------------------------ -------------------
PUBLIC.TOAD_PLAN_TABLE                                       SYNONYM

1 row selected.

SQL> @?/rdbms/admin/utlrp
   INV_OBJ
----------
         0

1 row selected.

SQL>

--Cek registry history setelah patch
ACTION_TIME                    ACTION     NAMESPACE  VERSION     ID COMMENTS                                                                    BUNDLE_SERIES
------------------------------ ---------- ---------- ---------- --- --------------------------------------------------------------------------- ---------------
24-AUG-13 12.03.45.119862 PM   APPLY      SERVER     11.2.0.4     0 Patchset 11.2.0.2.0                                                         PSU
23-FEB-15 08.32.47.035270 PM   APPLY      SERVER     11.2.0.4     0 Patchset 11.2.0.2.0                                                         PSU
03-DEC-15 08.20.56.161115 PM   APPLY      SERVER     11.2.0.4     8 PSU 11.2.0.4.8                                                              PSU

3 rows selected.

Elapsed: 00:00:00.01
SQL> SELECT BANNER FROM V$VERSION;

BANNER
--------------------------------------------------------------------------------
Oracle Database 11g Enterprise Edition Release 11.2.0.4.0 - 64bit Production
PL/SQL Release 11.2.0.4.0 - Production
CORE    11.2.0.4.0      Production
TNS for Linux: Version 11.2.0.4.0 - Production
NLSRTL Version 11.2.0.4.0 - Production

5 rows selected.

Elapsed: 00:00:00.00
SQL>
/u01/app/orekel/product/11.2.0.4/db_1/OPatch/opatch version