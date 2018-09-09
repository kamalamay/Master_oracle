/*
Source:
http://faruqueahmed.wordpress.com/2010/02/21/how-to-add-asm-disk-to-asm-diskgroup/
How to add ASM disk to ASM Diskgroup
*/

Login to the ASM instance

prodrac1:/u01>> ps -ef|grep pmon
oracle 98424 1 0 Nov 10 - 58:56 ora_pmon_prod11
oracle 131176 1 0 Nov 10 - 21:23 asm_pmon_+ASM1
oracle 516392 525076 0 16:03:59 pts/1 0:00 grep pmon
prodrac1:/u01>> export ORACLE_SID=+ASM1
prodrac1:/u01>> sqlplus "/as sysdba"

SQL*Plus: Release 10.2.0.4.0 - Production on Sun Feb 21 16:04:29 2010

Copyright (c) 1982, 2007, Oracle. All Rights Reserved.

Connected to:
Oracle Database 10g Enterprise Edition Release 10.2.0.4.0 - 64bit Production
With the Partitioning, Real Application Clusters, OLAP, Data Mining
and Real Application Testing options

SQL>

Identify the candidate Disks

SQL> SELECT MOUNT_STATUS,HEADER_STATUS,MODE_STATUS,STATE,TOTAL_MB,FREE_MB,NAME,PATH,LABEL FROM V$ASM_DISK;

MOUNT_S HEADER_STATU MODE_ST STATE TOTAL_MB FREE_MB NAME PATH LABEL
------- ------------ ------- -------- ---------- ---------- ------------------------------ ------------------------------ -------------------------------
CLOSED CANDIDATE ONLINE NORMAL 207157 0 /dev/ASMDISK53
CLOSED CANDIDATE ONLINE NORMAL 207157 0 /dev/ASMDISK57
CLOSED CANDIDATE ONLINE NORMAL 207157 0 /dev/ASMDISK58
CLOSED CANDIDATE ONLINE NORMAL 207157 0 /dev/ASMDISK56
CLOSED CANDIDATE ONLINE NORMAL 207157 0 /dev/ASMDISK55
CLOSED CANDIDATE ONLINE NORMAL 207157 0 /dev/ASMDISK54
CACHED MEMBER ONLINE NORMAL 207157 16284 DATASLAVE_0020 /dev/ASMDISK50
CACHED MEMBER ONLINE NORMAL 207157 16251 DATASLAVE_0016 /dev/ASMDISK46
CACHED MEMBER ONLINE NORMAL 207157 16290 DATASLAVE_0019 /dev/ASMDISK49
CACHED MEMBER ONLINE NORMAL 207157 16195 DATASLAVE_0015 /dev/ASMDISK45
CACHED MEMBER ONLINE NORMAL 207157 16294 DATASLAVE_0021 /dev/ASMDISK51

.....................................................
.....................................................
58 rows selected.
SQL>

Identify the Diskgroup to add disks
SQL> SELECT GROUP_NUMBER NAME,SECTOR_SIZE,BLOCK_SIZE,ALLOCATION_UNIT_SIZE,STATE,TYPE TOTAL_MB,FREE_MB FROM V$ASM_DISKGROUP;

Add the disks to the ASM diskgroup

SQL> ALTER DISKGROUP DATASLAVE ADD DISK '/dev/ASMDISK53' NAME DATASLAVE_0023 SIZE 207157 M REBALANCE POWER 11;

Diskgroup altered.

SQL> ALTER DISKGROUP DATASLAVE ADD DISK '/dev/ASMDISK54' NAME DATASLAVE_0024 SIZE 207157 M REBALANCE POWER 11;

Diskgroup altered.

SQL> ALTER DISKGROUP DATASLAVE ADD DISK '/dev/ASMDISK55' NAME DATASLAVE_0025 SIZE 207157 M REBALANCE POWER 11;

Diskgroup altered.

SQL> ALTER DISKGROUP DATASLAVE ADD DISK '/dev/ASMDISK56' NAME DATASLAVE_0026 SIZE 207157 M REBALANCE POWER 11;

Diskgroup altered.

SQL>

Disk rebalance time

SQL> select * from v$asm_operation;
GROUP_NUMBER OPERA STAT POWER ACTUAL SOFAR EST_WORK EST_RATE EST_MINUTES
------------ ----- ---- ---------- ---------- ---------- ---------- ---------- -----------
2 REBAL RUN 11 11 20575 586114 4572 123

SQL>

===========================================================================================
/*
Source:
http://www.idevelopment.info/data/Oracle/DBA_tips/Automatic_Storage_Management/ASM_12.shtml
*/

-- This short article provides the steps necessary to add a candidate disk to an already existing disk group on the Linux platform. It also documents the steps necessary to remove disks from a running disk group.
--For the purpose of this document, I already have an existing disk group named TESTDB_DATA1. I am not using the ASMLib libraries.
/*
1. Identify Candidate Disks
The current disk group configuration, (TESTDB_DATA1 and candidate disks not assigned to any disk group) has the following configuration:
*/
$ ORACLE_SID=+ASM; export ORACLE_SID
$ sqlplus "/ as sysdba"

SELECT NVL(a.name, '[CANDIDATE]') disk_group_name, b.path disk_file_path, b.name disk_file_name, b.failgroup disk_file_fail_group FROM v$asm_diskgroup a RIGHT OUTER JOIN v$asm_disk b USING (group_number) ORDER BY a.name;

Disk Group Name Path            File Name            Fail Group     
--------------- --------------- -------------------- ---------------
TESTDB_DATA1    /dev/raw/raw1   TESTDB_DATA1_0000    CONTROLLER1
                /dev/raw/raw2   TESTDB_DATA1_0001    CONTROLLER1
                /dev/raw/raw3   TESTDB_DATA1_0002    CONTROLLER2
                /dev/raw/raw4   TESTDB_DATA1_0003    CONTROLLER2

[CANDIDATE]     /dev/raw/raw5
                /dev/raw/raw6
                /dev/raw/raw7
/*
2. Add Disks to a Disk Group
Finally, let's add the two new disks to the disk group. This needs to be done within the ASM instance and connected as a user with SYSDBA privileges:
*/
$ ORACLE_SID=+ASM; export ORACLE_SID
$ sqlplus "/ as sysdba"

SQL> ALTER DISKGROUP testdb_data1 ADD
  2  FAILGROUP controller1 DISK '/dev/raw/raw5'
  3  FAILGROUP controller2 DISK '/dev/raw/raw6' REBALANCE POWER 11;

Diskgroup altered.
--After submitting the SQL to add the new disks to the disk group, query the dynamic performance view V$ASM_OPERATION in the ASM instance to check the status of the rebalance operation. The V$ASM_OPERATION view will return one row for every active Automatic Storage Management long running operation executing in the Automatic Storage Management instance.
SQL> SELECT group_number, operation, state, power, est_minutes FROM v$asm_operation;

GROUP_NUMBER OPERATION STATE   POWER EST_MINUTES
------------ --------- ------ ------ -----------
           1 REBAL     RUN        11           9
--Continue to query this view to monitor the rebalance operation. When this row is gone, the ASM rebalance operation will be complete.
--After adding the new disks, this is a new view of the disk group configuration:
Disk Group Name Path            File Name            Fail Group     
--------------- --------------- -------------------- ---------------
TESTDB_DATA1    /dev/raw/raw1   TESTDB_DATA1_0000    CONTROLLER1
                /dev/raw/raw2   TESTDB_DATA1_0001    CONTROLLER1
                /dev/raw/raw3   TESTDB_DATA1_0002    CONTROLLER2
                /dev/raw/raw4   TESTDB_DATA1_0003    CONTROLLER2
                /dev/raw/raw5   TESTDB_DATA1_0004    CONTROLLER1
                /dev/raw/raw6   TESTDB_DATA1_0005    CONTROLLER2

[CANDIDATE]     /dev/raw/raw7
/*
3. Drop Disks from a Disk Group
Now, let's drop the same two new disks from the disk group. This needs to be done within the ASM instance and connected as a user with SYSDBA privileges:
*/
$ ORACLE_SID=+ASM; export ORACLE_SID
$ sqlplus "/ as sysdba"

SQL> ALTER DISKGROUP testdb_data1 DROP DISK testdb_data1_0004, testdb_data1_0005  REBALANCE POWER 11;

Diskgroup altered.
--The current disk group configuration, (TESTDB_DATA1 and candidate disks not assigned to any disk group) now has the following configuration: 
Disk Group Name Path            File Name            Fail Group     
--------------- --------------- -------------------- ---------------
TESTDB_DATA1    /dev/raw/raw1   TESTDB_DATA1_0000    CONTROLLER1
                /dev/raw/raw2   TESTDB_DATA1_0001    CONTROLLER1
                /dev/raw/raw3   TESTDB_DATA1_0002    CONTROLLER2
                /dev/raw/raw4   TESTDB_DATA1_0003    CONTROLLER2

                                                  
[CANDIDATE]     /dev/raw/raw5
                /dev/raw/raw6
                /dev/raw/raw7
===========================================================================================
/*
Source:
http://docs.oracle.com/cd/B28359_01/server.111/b31107/asmdiskgrps.htm#OSTMG94105
*/

/*
Example: Creating a Disk Group

The following examples assume that the ASM_DISKSTRING initialization parameter is set to '/devices/*' and ASM disk discovery identifies the following disks in the /devices directory.

Controller 1:

/devices/diska1
/devices/diska2
/devices/diska3
/devices/diska4

Controller 2:
/devices/diskb1
/devices/diskb2
/devices/diskb3
/devices/diskb4

The SQL statement in Example 4-1 creates a disk group named dgroup1 with normal redundancy consisting of two failure groups controller1 or controller2 with four disks in each failure group.

Example 4-1 Creating a Disk Group
*/
% SQLPLUS /NOLOG
SQL> CONNECT / AS SYSASM
Connected to an idle instance.
SQL> STARTUP NOMOUNT

CREATE DISKGROUP dgroup1 NORMAL REDUNDANCY
FAILGROUP controller1 DISK
'/devices/diska1' NAME diska1,
'/devices/diska2' NAME diska2,
'/devices/diska3' NAME diska3,
'/devices/diska4' NAME diska4
FAILGROUP controller2 DISK
'/devices/diskb1' NAME diskb1,
'/devices/diskb2' NAME diskb2,
'/devices/diskb3' NAME diskb3,
'/devices/diskb4' NAME diskb4
ATTRIBUTE 'au_size'='4M',
          'compatible.asm' = '11.1', 
          'compatible.rdbms' = '11.1';
/*
In Example 4-1, the NAME clauses enable you to explicitly assign names to the disks rather than the default system-generated names. The system-generated names are in the form diskgroupname_nnnn, where nnnn is the disk number for the disk in the disk group. For ASMLIB disks, the disk name defaults to the ASMLIB name that is the user label of the disk; for example, mydisk is the default ASM disk name for ORCL:mydisk.

When creating the disk group, the values of following disk group attributes were explicitly set:

    AU_SIZE specifies the size of the allocation unit for the disk group. For information about allocation unit size and extents, see "Extents".

    COMPATIBLE.ASM determines the minimum software version for any ASM instance that uses a disk group. For information about the COMPATIBLE.ASM attribute, see "COMPATIBLE.ASM".

    COMPATIBLE.RDBMS determines the minimum software version for any database instance that uses a disk group. For information about the COMPATIBLE.RDBMS attribute, see "COMPATIBLE.RDBMS".
*/
/*
Altering Disk Groups

You can use the ALTER DISKGROUP statement to alter a disk group configuration. You can add, resize, or drop disks while the database remains online. Whenever possible, multiple operations in a single ALTER DISKGROUP statement are recommended.

ASM automatically rebalances when the configuration of a disk group changes. By default, the ALTER DISKGROUP statement does not wait until the operation is complete before returning. Query the V$ASM_OPERATION view to monitor the status of this operation.

You can use the REBALANCE WAIT clause if you want the ALTER DISKGROUP statement processing to wait until the rebalance operation is complete before returning. This is especially useful in scripts. The statement also accepts a REBALANCE NOWAIT clause that invokes the default behavior of conducting the rebalance operation asynchronously in the background.

You can interrupt a rebalance running in wait mode by typing CTRL-C on most platforms. This causes the statement to return immediately with the message ORA-01013: user requested cancel of current operation, and then to continue the operation asynchronously. Typing CTRL-C does not cancel the rebalance operation or any disk add, drop, or resize operations.

To control the speed and resource consumption of the rebalance operation, you can include the REBALANCE POWER clause in statements that add, drop, or resize disks. Refer to "Manually Rebalancing Disk Groups" for more information about this clause.

This section contains the following topics:

    Adding Disks to a Disk Group

    Dropping Disks from Disk Groups

    Resizing Disks in Disk Groups

    Undropping Disks in Disk Groups

    Manually Rebalancing Disk Groups

    Tuning Rebalance Operations

See Also:
The ALTER DISKGROUP SQL statement in the Oracle Database SQL Language Reference
Adding Disks to a Disk Group

You can use the ADD clause of the ALTER DISKGROUP statement to add a disk or a failure group to a disk group. The same syntax that you use to add a disk or failure group with the CREATE DISKGROUP statement can be used with the ALTER DISKGROUP statement. For an example of the CREATE DISKGROUP SQL statement, refer to Example 4-1. After you add new disks, the new disks gradually begin to accommodate their share of the workload as rebalancing progresses.

ASM behavior when adding disks to a disk group is best illustrated through"Example: Adding Disks to a Disk Group". You can also add disks to a disk group with Oracle Enterprise Manager, described in "Adding Disks to Disk Groups".
Example: Adding Disks to a Disk Group

The statements presented in this example demonstrate the interactions of disk discovery with the ADD DISK operation.

Assume that disk discovery identifies the following disks in directory /devices:

/devices/diska1 -- member of dgroup1
/devices/diska2 -- member of dgroup1
/devices/diska3 -- member of dgroup1
/devices/diska4 -- member of dgroup1
/devices/diska5 -- candidate disk
/devices/diska6 -- candidate disk
/devices/diska7 -- candidate disk
/devices/diska8 -- candidate disk

/devices/diskb1 -- member of dgroup1
/devices/diskb2 -- member of dgroup1
/devices/diskb3 -- member of dgroup1
/devices/diskb4 -- member of dgroup2

/devices/diskc1 -- member of dgroup2
/devices/diskc2 -- member of dgroup2
/devices/diskc3 -- member of dgroup3
/devices/diskc4 -- candidate disk

/devices/diskd1 -- candidate disk
/devices/diskd2 -- candidate disk
/devices/diskd3 -- candidate disk
/devices/diskd4 -- candidate disk
/devices/diskd5 -- candidate disk
/devices/diskd6 -- candidate disk
/devices/diskd7 -- candidate disk
/devices/diskd8 -- candidate disk

You can query the V$ASM_DISK view to display the status of ASM disks. See "Using Views to Obtain ASM Information".

The following statement would fail because /devices/diska1 - /devices/diska4 already belong to dgroup1.
*/
ALTER DISKGROUP dgroup1 ADD DISK
     '/devices/diska*';

--The following statement would successfully add disks /devices/diska5 through /devices/diska8 to dgroup1. Because no FAILGROUP clauses are included in the ALTER DISKGROUP statement, each disk is assigned to its own failure group. The NAME clauses assign names to the disks, otherwise they would have been assigned system-generated names.

ALTER DISKGROUP dgroup1 ADD DISK
     '/devices/diska5' NAME diska5,
     '/devices/diska6' NAME diska6,
     '/devices/diska7' NAME diska7,
     '/devices/diska8' NAME diska8,

--The following statement would fail because the search string matches disks that are contained in other disk groups. Specifically, /devices/diska4 belongs to disk group dgroup1 and /devices/diskb4 belongs to disk group dgroup2.

ALTER DISKGROUP dgroup1 ADD DISK
     '/devices/disk*4';

--The following statement would successfully add /devices/diskd1 through /devices/diskd8 to disk group dgroup1. This statement runs with a rebalance power of 5, and does not return until the rebalance operation is complete.

ALTER DISKGROUP dgroup1 ADD DISK
      '/devices/diskd*'
       REBALANCE POWER 5 WAIT;

--If /devices/diskc3 was previously a member of a disk group that no longer exists, then you could use the FORCE option to add them as members of another disk group. For example, the following use of the FORCE clause enables /devices/diskc3 to be added to dgroup2, even though it is a current member of dgroup3. For this statement to succeed, dgroup3 cannot be mounted.

ALTER DISKGROUP dgroup2 ADD DISK
     '/devices/diskc3' FORCE;
/*
Dropping Disks from Disk Groups

To drop disks from a disk group, use the DROP DISK clause of the ALTER DISKGROUP statement. You can also drop all of the disks in specified failure groups using the DROP DISKS IN FAILGROUP clause.

When a disk is dropped, the disk group is rebalanced by moving all of the file extents from the dropped disk to other disks in the disk group. A drop disk operation might fail if not enough space is available on the other disks. The best approach is to perform both the add and drop operation with the same ALTER DISKGROUP statement. This has the benefit of rebalancing data extents once and ensuring that there is enough space for the rebalance operation to succeed.

Caution:
The ALTER DISKGROUP...DROP DISK statement returns before the drop and rebalance operations are complete. Do not reuse, remove, or disconnect the dropped disk until the HEADER_STATUS column for this disk in the V$ASM_DISK view changes to FORMER. You can query the V$ASM_OPERATION view to determine the amount of time remaining for the drop/rebalance operation to complete. For more information, refer to the Oracle Database SQL Language Reference and the Oracle Database Reference.

If you specify the FORCE clause for the drop operation, the disk is dropped even if ASM cannot read or write to the disk. You cannot use the FORCE flag when dropping a disk from an external redundancy disk group.

Caution:
A DROP FORCE operation leaves data at reduced redundancy for as long as it takes for the subsequent rebalance operation to complete. This increases your exposure to data loss if there is a subsequent disk failure during rebalancing. DROP FORCE should be used only with great care.

You can also drop disks from a disk group with Oracle Enterprise Manager. See "Dropping Disks from Disk Groups".
Example: Dropping Disks from Disk Groups

The statements in this example demonstrate how to drop disks from the disk group dgroup1 described in "Example: Adding Disks to a Disk Group".

The following example drops diska5 from disk group dgroup1.
*/
ALTER DISKGROUP dgroup1 DROP DISK diska5;

--The following example drops diska5 from disk group dgroup1, and also illustrates how multiple actions are possible with one ALTER DISKGROUP statement.

ALTER DISKGROUP dgroup1 DROP DISK diska5
     ADD FAILGROUP failgrp1 DISK '/devices/diska9' NAME diska9;
/*
Resizing Disks in Disk Groups

The RESIZE clause of ALTER DISKGROUP enables you to perform the following operations:

    Resize all disks in the disk group

    Resize specific disks

    Resize all of the disks in a specified failure group

If you do not specify a new size in the SIZE clause then ASM uses the size of the disk as returned by the operating system. The new size is written to the ASM disk header and if the size of the disk is increasing, then the new space is immediately available for allocation. If the size is decreasing, rebalancing must relocate file extents beyond the new size limit to available space below the limit. If the rebalance operation can successfully relocate all extents, then the new size is made permanent, otherwise the rebalance fails.
Example: Resizing Disks in Disk Groups

The following example resizes all of the disks in failure group failgrp1 of disk group dgroup1. If the new size is greater than disk capacity, the statement will fail.
*/
ALTER DISKGROUP dgroup1 
     RESIZE DISKS IN FAILGROUP failgrp1 SIZE 100G;
/*
Undropping Disks in Disk Groups

The UNDROP DISKS clause of the ALTER DISKGROUP statement enables you to cancel all pending drops of disks within disk groups. If a drop disk operation has already completed, then this statement cannot be used to restore it. This statement cannot be used to restore disks that are being dropped as the result of a DROP DISKGROUP statement, or for disks that are being dropped using the FORCE clause.
Example: Undropping Disks in Disk Groups

The following example cancels the dropping of disks from disk group dgroup1:
*/
ALTER DISKGROUP dgroup1 UNDROP DISKS;
/*
Manually Rebalancing Disk Groups

You can manually rebalance the files in a disk group using the REBALANCE clause of the ALTER DISKGROUP statement. This would normally not be required, because ASM automatically rebalances disk groups when their configuration changes. You might want to do a manual rebalance operation if you want to control the speed of what would otherwise be an automatic rebalance operation.

The POWER clause of the ALTER DISKGROUP...REBALANCE statement specifies the degree of parallelism, and thus the speed of the rebalance operation. It can be set to a value from 0 to 11. A value of 0 halts a rebalancing operation until the statement is either implicitly or explicitly re-run. The default rebalance power is set by the ASM_POWER_LIMIT initialization parameter. See "Tuning Rebalance Operations" for more information.

The power level of an ongoing rebalance operation can be changed by entering the rebalance statement with a new level.

The ALTER DISKGROUP...REBALANCE command by default returns immediately so that you can issue other commands while the rebalance operation takes place asynchronously in the background. You can query the V$ASM_OPERATION view for the status of the rebalance operation.

If you want the ALTER DISKGROUP...REBALANCE command to wait until the rebalance operation is complete before returning, you can add the WAIT keyword to the REBALANCE clause. This is especially useful in scripts. The command also accepts a NOWAIT keyword, which invokes the default behavior of conducting the rebalance operation asynchronously. You can interrupt a rebalance running in wait mode by typing CTRL-C on most platforms. This causes the command to return immediately with the message ORA-01013: user requested cancel of current operation, and then to continue the rebalance operation asynchronously.

Additional rules for the rebalance operation include the following:

    An ongoing rebalance command will be restarted if the storage configuration changes either when you alter the configuration, or if the configuration changes due to a failure or an outage. Furthermore, if the new rebalance fails because of a user error, then a manual rebalance may be required.

    The ALTER DISKGROUP...REBALANCE statement runs on a single node even if you are using Oracle Real Application Clusters (Oracle RAC).

    ASM can perform one disk group rebalance at a time on a given instance. Therefore, if you have initiated multiple rebalances on different disk groups, then Oracle processes this operation serially. However, you can initiate rebalances on different disk groups on different nodes in parallel.

    Rebalancing continues across a failure of the ASM instance performing the rebalance.

    The REBALANCE clause (with its associated POWER and WAIT/NOWAIT keywords) can also be used in ALTER DISKGROUP commands that add, drop, or resize disks.

    Note:
    Oracle will restart the processing of an ongoing rebalance operation if the storage configuration changes. Furthermore, if the next rebalance operation fails because of a user error, then you may need to perform a manual rebalance.

Example: Manually Rebalancing a Disk Group

The following example manually rebalances the disk group dgroup2. The command does not return until the rebalance operation is complete.
*/
ALTER DISKGROUP dgroup2 REBALANCE POWER 5 WAIT;

--For more information about rebalancing operations, refer to "Tuning Rebalance Operations".
/*
Tuning Rebalance Operations

If the POWER clause is not specified in an ALTER DISKGROUP statement, or when rebalance is implicitly run by adding or dropping a disk, then the rebalance power defaults to the value of the ASM_POWER_LIMIT initialization parameter. You can adjust the value of this parameter dynamically.

The higher the power limit, the more quickly a rebalance operation can complete. Rebalancing takes longer with lower power values, but consumes fewer processing and I/O resources which are shared by other applications, such as the database.

The default value of 1 minimizes disruption to other applications. The appropriate value is dependent on your hardware configuration, performance requirements, and availability requirements

If a rebalance is in progress because a disk is manually or automatically dropped, then increasing the power of the rebalance shortens the time frame during which redundant copies of that data on the dropped disk are reconstructed on other disks.

The V$ASM_OPERATION view provides information for adjusting ASM_POWER_LIMIT and the resulting power of rebalance operations. The V$ASM_OPERATION view also gives an estimate in the EST_MINUTES column of the amount of time remaining for the rebalance operation to complete. You can see the effect of changing the rebalance power by observing the change in the time estimate.
*/