OEM Reconfigure
---------------
http://blog.mclaughlinsoftware.com/oracle-architecture-configuration/changing-windows-hostname-and-oracle-enterprise-manager/

One mistake can lead to a lot of work. When you’ve installed Oracle Database 11g, you can’t change the Windows Hostname without reinstalling Oracle Enterprise Manager. If you’re trying to resolve an ORACLE_UNQNAME problem, check another post of mine for that answer.

These are the steps:

1. Change the %ORACLE_HOME%\network\admin\listener.ora file from an IP number to machine name.

2. Change the %ORACLE_HOME%\network\admin\tnsnames.ora file from an IP number to a machine name.

3. Change the C:\WINDOWS\System32\drivers\etc\hosts file by adding this line beneath the default localhost line (for the new Hostname value):

127.0.0.1       localhost
172.16.113.128  mclaughlin11g mclaughlin11g.techtinker.com

4. Change the Windows hostname by navigating: Start > Control Panel > System (classic view) from the random assignment of VMWare Fusion.

5. Reboot the machine to set the networking. Unlock the SYSMAN account because it ensures that emca can drop it and all dependencies. Then, drop the em configuration with the following commands.

C:\Data> set ORACLE_SID=orcl
C:\Data> emca -deconfig dbcontrol db -repos drop

6. You’ll receive the following prompts, enter the Oracle SID and Port number without double quotes but you must enter all passwords with double quotes (at least in Oracle Database 11g):

Oracle Database 11gR1
---------------------
STARTED EMCA at Jul 13, 2008 8:26:42 AM
EM Configuration Assistant, Version 11.1.0.5.0 Production
Copyright (c) 2003, 2005, Oracle.  All rights reserved.
 
Enter the following information:
Database SID: orcl
Listener port number: 1521
Password for SYS user:
Password for SYSMAN user:
Password for SYSMAN user:
Do you wish to continue? [yes(Y)/no(N)]: y

Oracle Database 11gR2
---------------------
STARTED EMCA at Sep 3, 2012 7:40:07 PM
EM Configuration Assistant, Version 11.2.0.0.2 Production
Copyright (c) 2003, 2005, Oracle.  All rights reserved.
 
Enter the following information:
Database SID: orcl
Listener port number: 1521
Password for SYS user:
Password for SYSMAN user:
 
Do you wish to continue? [yes(Y)/no(N)]: y

7. If you failed to unlock the SYSMAN account in step #5, you should drop the SYSMAN user manually. If you don’t drop the SYSMAN schema, you’ll raise an error when you try to recreate it:

CONFIG: ORA-20001: SYSMAN already EXISTS..
ORA-06512: at line 17
 
oracle.sysman.assistants.util.sqlEngine.SQLFatalErrorException: ORA-20001: SYSMAN already EXISTS..
ORA-06512: at line 17

The Java stack trace will look like this, more or less based on version and release:

at oracle.sysman.assistants.util.sqlEngine.SQLEngine.executeImpl(SQLEngine.java:1530)
at oracle.sysman.assistants.util.sqlEngine.SQLEngine.executeScript(SQLEngine.java:880)
at oracle.sysman.assistants.util.sqlEngine.SQLPlusEngine.executeScript(SQLPlusEngine.java
at oracle.sysman.assistants.util.sqlEngine.SQLPlusEngine.executeScript(SQLPlusEngine.java
at oracle.sysman.emcp.EMReposConfig.createRepository(EMReposConfig.java:492)
at oracle.sysman.emcp.EMReposConfig.invoke(EMReposConfig.java:218)
at oracle.sysman.emcp.EMReposConfig.invoke(EMReposConfig.java:147)
at oracle.sysman.emcp.EMConfig.perform(EMConfig.java:222)
at oracle.sysman.emcp.EMConfigAssistant.invokeEMCA(EMConfigAssistant.java:535)
at oracle.sysman.emcp.EMConfigAssistant.performConfiguration(EMConfigAssistant.java:1215)
at oracle.sysman.emcp.EMConfigAssistant.statusMain(EMConfigAssistant.java:519)
at oracle.sysman.emcp.EMConfigAssistant.main(EMConfigAssistant.java:468)

Drop the user and dependent on version a few other objects, like:

DROP USER sysman CASCADE;
DROP PUBLIC SYNONYM setemviewusercontext;
DROP ROLE mgmt_user;
DROP PUBLIC SYNONYM mgmt_target_blackouts;
DROP USER mgmt_view;

8. You can then create the em environment with the following syntax:

C:\Data> emca -config dbcontrol db -repos create

9. Again, you’ll receive the following prompts, enter the Oracle SID and Port number without double quotes but you must enter all passwords with double quotes (at least in Oracle Database 11g):

STARTED EMCA at Jul 13, 2008 8:28:48 AM
EM Configuration Assistant, Version 11.1.0.5.0 Production
Copyright (c) 2003, 2005, Oracle.  ALL rights reserved.
 
Enter the following information:
DATABASE SID: orcl
Listener port NUMBER: 1521
Password FOR SYS USER:
Password FOR DBSNMP USER:
Password FOR SYSMAN USER:
Password FOR SYSMAN USER: Email address FOR notifications (optional):
Outgoing Mail (SMTP) server FOR notifications (optional):
-----------------------------------------------------------------
 
You have specified the following settings
 
DATABASE ORACLE_HOME ................ C:\app\Administrator\product\11.1.0\db_1
 
LOCAL hostname ................ mclaughlin11g
Listener port NUMBER ................ 1521
DATABASE SID ................ orcl
Email address FOR notifications ...............
Outgoing Mail (SMTP) server FOR notifications ...............
 
-----------------------------------------------------------------
 
Do you wish TO continue? [yes(Y)/no(N)]: y

A note to me, remember haste makes waste. I’m just glad that rebuilding the MarkLogic server was easy.