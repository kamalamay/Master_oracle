Error ORA-01078 and ORA-29701 when startup ASM
----------------------------------------------
[grid@asem ~]$ sqlplus / as sysasm

SQL*Plus: Release 11.2.0.4.0 Production on Wed Sep 17 14:08:26 2014

Copyright (c) 1982, 2013, Oracle.  All rights reserved.

Connected to an idle instance.

SQL> startup;
ORA-01078: failure in processing system parameters
ORA-29701: unable to connect to Cluster Synchronization Service
SQL>

[grid@asem ~]$ crs_stat -t
Name           Type           Target    State     Host
------------------------------------------------------------
ora.DATA.dg    ora....up.type OFFLINE   OFFLINE
ora....ER.lsnr ora....er.type ONLINE    ONLINE    asem
ora.asm        ora.asm.type   OFFLINE   OFFLINE
ora.cssd       ora.cssd.type  ONLINE    OFFLINE				--> Nah ini dia, resource ora.cssd belum naik.
ora.diskmon    ora....on.type OFFLINE   OFFLINE
ora.evmd       ora.evm.type   ONLINE    ONLINE    asem
ora.ons        ora.ons.type   OFFLINE   OFFLINE

Nyalakan ora.cssd
-----------------
[grid@asem ~]$ crsctl start resource ora.cssd
CRS-2672: Attempting to start 'ora.cssd' on 'asem'
CRS-2672: Attempting to start 'ora.diskmon' on 'asem'
CRS-2676: Start of 'ora.diskmon' on 'asem' succeeded
CRS-2676: Start of 'ora.cssd' on 'asem' succeeded

Nyalakan ASM lagi
-----------------
[grid@asem ~]$ sqlplus sys as sysasm

SQL*Plus: Release 11.2.0.4.0 Production on Wed Sep 17 14:13:14 2014

Copyright (c) 1982, 2013, Oracle.  All rights reserved.

Enter password:
Connected to an idle instance.

SQL> startup;
ASM instance started

Total System Global Area 1135747072 bytes
Fixed Size                  2260728 bytes
Variable Size            1108320520 bytes
ASM Cache                  25165824 bytes
ASM diskgroups mounted
SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.4.0 - 64bit Production
With the Automatic Storage Management option
[grid@asem ~]$ crs_stat -t
Name           Type           Target    State     Host
------------------------------------------------------------
ora.DATA.dg    ora....up.type ONLINE    ONLINE    asem
ora....ER.lsnr ora....er.type ONLINE    ONLINE    asem
ora.asm        ora.asm.type   ONLINE    ONLINE    asem
ora.cssd       ora.cssd.type  ONLINE    ONLINE    asem
ora.diskmon    ora....on.type OFFLINE   OFFLINE
ora.evmd       ora.evm.type   ONLINE    ONLINE    asem
ora.ons        ora.ons.type   OFFLINE   OFFLINE
[grid@asem ~]$