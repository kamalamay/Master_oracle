[orekel@asem ~]$ env|grep ORA
ORACLE_UNQNAME=asem
ORACLE_SID=asem
ORACLE_BASE=/oraengine/app/orekel
ORACLE_HOSTNAME=asem
ORACLE_HOME=/oraengine/app/orekel/product/11.2.0/db_home1
[orekel@asem ~]$ emca -repos create

STARTED EMCA at Feb 13, 2015 10:43:25 AM
EM Configuration Assistant, Version 11.2.0.3.0 Production
Copyright (c) 2003, 2011, Oracle.  All rights reserved.

Enter the following information:
Database SID: asem
Listener port number: 1521
Password for SYS user:
Password for SYSMAN user:

Do you wish to continue? [yes(Y)/no(N)]: Y
Feb 13, 2015 10:43:44 AM oracle.sysman.emcp.EMConfig perform
INFO: This operation is being logged at /oraengine/app/orekel/cfgtoollogs/emca/asem/emca_2015_02_13_10_43_24.log.
Feb 13, 2015 10:43:45 AM oracle.sysman.emcp.EMReposConfig createRepository
INFO: Creating the EM repository (this may take a while) ...
Feb 13, 2015 10:54:25 AM oracle.sysman.emcp.EMReposConfig invoke
INFO: Repository successfully created
Enterprise Manager configuration completed successfully
FINISHED EMCA at Feb 13, 2015 10:54:25 AM
[orekel@asem ~]$ emca -deconfig dbcontrol db -repos drop

STARTED EMCA at Feb 13, 2015 2:05:28 PM
EM Configuration Assistant, Version 11.2.0.3.0 Production
Copyright (c) 2003, 2011, Oracle.  All rights reserved.

Enter the following information:
Database SID: asem
Listener port number: 1521
Password for SYS user:
Password for SYSMAN user:
Password for SYSMAN user:
----------------------------------------------------------------------
WARNING : While repository is dropped the database will be put in quiesce mode.
----------------------------------------------------------------------
Do you wish to continue? [yes(Y)/no(N)]: Y
Feb 13, 2015 2:05:42 PM oracle.sysman.emcp.EMConfig perform
INFO: This operation is being logged at /oraengine/app/orekel/cfgtoollogs/emca/asem/emca_2015_02_13_14_05_28.log.
Feb 13, 2015 2:05:42 PM oracle.sysman.emcp.util.GeneralUtil initSQLEngineLoacly
WARNING: ORA-28000: the account is locked

Feb 13, 2015 2:05:42 PM oracle.sysman.emcp.ParamsManager checkListenerStatusForDBControl
WARNING: Error initializing SQL connection. SQL operations cannot be performed
Feb 13, 2015 2:05:43 PM oracle.sysman.emcp.EMDBPreConfig performDeconfiguration
WARNING: EM is not configured for this database. No EM-specific actions can be performed. Some of the possible reasons may be:
 1) EM is configured with different hostname then physical host. Set environment variable ORACLE_HOSTNAME=<hostname> and re-run EMCA script
 2) ORACLE_HOSTNAME is set. Unset it and re-run EMCA script
Feb 13, 2015 2:05:43 PM oracle.sysman.emcp.EMReposConfig invoke
INFO: Dropping the EM repository (this may take a while) ...
Feb 13, 2015 2:10:54 PM oracle.sysman.emcp.EMReposConfig invoke
INFO: Repository successfully dropped
Enterprise Manager configuration completed successfully
FINISHED EMCA at Feb 13, 2015 2:10:54 PM
[orekel@asem ~]$ 