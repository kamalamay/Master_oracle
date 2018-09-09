[orekel@pitik bin]$ ./emca -config dbcontrol db -repos create

STARTED EMCA at Oct 10, 2015 3:10:35 PM
EM Configuration Assistant, Version 11.2.0.3.0 Production
Copyright (c) 2003, 2011, Oracle.  All rights reserved.

Enter the following information:
Database SID: ayam
Listener port number: 1521
Listener ORACLE_HOME [ /u01/app/orekel/product/11.2.0.4/db_1 ]:
Password for SYS user:
Password for DBSNMP user:
Password for SYSMAN user:
Email address for notifications (optional):
Outgoing Mail (SMTP) server for notifications (optional):
-----------------------------------------------------------------

You have specified the following settings

Database ORACLE_HOME ................ /u01/app/orekel/product/11.2.0.4/db_1

Local hostname ................ pitik.localdomain
Listener ORACLE_HOME ................ /u01/app/orekel/product/11.2.0.4/db_1
Listener port number ................ 1521
Database SID ................ ayam
Email address for notifications ...............
Outgoing Mail (SMTP) server for notifications ...............

-----------------------------------------------------------------
Do you wish to continue? [yes(Y)/no(N)]: Y
Oct 10, 2015 3:11:02 PM oracle.sysman.emcp.EMConfig perform
INFO: This operation is being logged at /u01/app/orekel/cfgtoollogs/emca/ayam/emca_2015_10_10_15_10_34.log.
Oct 10, 2015 3:11:04 PM oracle.sysman.emcp.EMReposConfig createRepository
INFO: Creating the EM repository (this may take a while) ...
Oct 10, 2015 3:16:48 PM oracle.sysman.emcp.EMReposConfig invoke
INFO: Repository successfully created
Oct 10, 2015 3:16:59 PM oracle.sysman.emcp.EMReposConfig uploadConfigDataToRepository
INFO: Uploading configuration data to EM repository (this may take a while) ...
Oct 10, 2015 3:18:31 PM oracle.sysman.emcp.EMReposConfig invoke
INFO: Uploaded configuration data successfully
Oct 10, 2015 3:18:37 PM oracle.sysman.emcp.util.DBControlUtil secureDBConsole
INFO: Securing Database Control (this may take a while) ...
Oct 10, 2015 3:18:49 PM oracle.sysman.emcp.util.PlatformInterface executeCommand
WARNING: Error executing /u01/app/orekel/product/11.2.0.4/db_1/bin/emctl secure dbconsole -host pitik.localdomain -sid ayam
Oct 10, 2015 3:18:49 PM oracle.sysman.emcp.EMDBPostConfig performConfiguration
WARNING: Error securing Database control.
Oct 10, 2015 3:18:49 PM oracle.sysman.emcp.EMDBPostConfig setWarnMsg
INFO: Error securing Database Control. Database Control has been brought-up in non-secure mode. To secure the Database Control execute the following command(s):

 1) Set the environment variable ORACLE_UNQNAME to Database unique name
 2) /u01/app/orekel/product/11.2.0.4/db_1/bin/emctl stop dbconsole
 3) /u01/app/orekel/product/11.2.0.4/db_1/bin/emctl config emkey -repos -sysman_pwd < Password for SYSMAN user >
 4) /u01/app/orekel/product/11.2.0.4/db_1/bin/emctl secure dbconsole -sysman_pwd < Password for SYSMAN user >
 5) /u01/app/orekel/product/11.2.0.4/db_1/bin/emctl start dbconsole

 To secure Em Key, run /u01/app/orekel/product/11.2.0.4/db_1/bin/emctl config emkey -remove_from_repos -sysman_pwd < Password for SYSMAN user >
Oct 10, 2015 3:18:49 PM oracle.sysman.emcp.util.DBControlUtil startOMS
INFO: Starting Database Control (this may take a while) ...
Oct 10, 2015 3:18:56 PM oracle.sysman.emcp.EMDBPostConfig performConfiguration
INFO: Database Control started successfully
Oct 10, 2015 3:18:56 PM oracle.sysman.emcp.EMDBPostConfig performConfiguration
INFO: >>>>>>>>>>> The Database Control URL is http://pitik.localdomain:1158/em <<<<<<<<<<<


Error securing Database Control. Database Control has been brought-up in non-secure mode. To secure the Database Control execute the following command(s):

 1) Set the environment variable ORACLE_UNQNAME to Database unique name
 2) /u01/app/orekel/product/11.2.0.4/db_1/bin/emctl stop dbconsole
 3) /u01/app/orekel/product/11.2.0.4/db_1/bin/emctl config emkey -repos -sysman_pwd < Password for SYSMAN user >
 4) /u01/app/orekel/product/11.2.0.4/db_1/bin/emctl secure dbconsole -sysman_pwd < Password for SYSMAN user >
 5) /u01/app/orekel/product/11.2.0.4/db_1/bin/emctl start dbconsole

 To secure Em Key, run /u01/app/orekel/product/11.2.0.4/db_1/bin/emctl config emkey -remove_from_repos -sysman_pwd < Password for SYSMAN user >
[orekel@pitik bin]$ 