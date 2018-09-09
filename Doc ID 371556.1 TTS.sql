http://www.dbspecialists.com/files/presentations/changing_platforms.html
---
Doc ID 371556.1
How to Migrate to different Endian Platform Using Transportable Tablespaces With RMAN
---
Applies to:
Oracle Database - Enterprise Edition - Version 10.1.0.2 to 12.1.0.1 [Release 10.1 to 12.1]
Information in this document applies to any platform.
******************* WARNING *************

Document 1334152.1 Corrupt IOT when using Transportable Tablespace to HP from different OS
Document 13001379.8 Bug 13001379 - Datapump transport_tablespaces produces wrong dictionary metadata for some tables
Goal

Starting with Oracle Database 10g, you can transport tablespaces across platforms. In this note there is a step by step guide about how to do it  with ASM datafiles and with OS filesystem datafiles.

If your goal is to migrate a database to different endian platform, the following high-level steps describe how to migrate a database to a new platform using transportable tablespace:

1.- Create a new, empty database on the destination platform.
2.- Import objects required for transport operations from the source database into the destination database.
3.- Export transportable metadata for all user tablespaces from the source database.
4.- Transfer data files for user tablespaces to the destination system.
5.- Use RMAN to convert the data files to the endian format of the destination system.
6.- Import transportable metadata for all user tablespaces into the destination database.
7.- Import the remaining database objects and metadata (that were not moved by the transport operation)
    from the source database into the destination database.        


You could also convert the datafiles at source platform and once converted transfer them to destination platform.

The MAA white paper "Platform Migration Using Transportable Tablespace" is available at

http://www.oracle.com/technetwork/database/features/availability/maa-wp-11g-platformmigrationtts-129269.pdf

 

From 11.2.0.4, 12C and further, if converting to Linux x86-64 consider to follow this doc:

   Reduce Transportable Tablespace Downtime using Cross Platform Incremental Backup [1389592.1]

 
Solution
Supported platforms

You can query the V$TRANSPORTABLE_PLATFORM view to see the platforms that are supported and to determine each platform's endian format (byte ordering).
SQL> COLUMN PLATFORM_NAME FORMAT A32
SQL> SELECT * FROM V$TRANSPORTABLE_PLATFORM ORDER BY 1;

PLATFORM_ID PLATFORM_NAME                    ENDIAN_FORMAT
----------- -------------------------------- --------------
          1 Solaris[tm] OE (32-bit)          Big
          2 Solaris[tm] OE (64-bit)          Big
          7 Microsoft Windows IA (32-bit)    Little
         10 Linux IA (32-bit)                Little
          6 AIX-Based Systems (64-bit)       Big
          3 HP-UX (64-bit)                   Big
          5 HP Tru64 UNIX                    Little
          4 HP-UX IA (64-bit)                Big
         11 Linux IA (64-bit)                Little
         15 HP Open VMS                      Little
          8 Microsoft Windows IA (64-bit)    Little
          9 IBM zSeries Based Linux          Big
         13 Linux 64-bit for AMD             Little
         16 Apple Mac OS                     Big
         12 Microsoft Windows 64-bit for AMD Little
         17 Solaris Operating System (x86)   Little


If the source platform and the target platform are of different endianness, then an additional step must be done on either the source or target platform to convert the tablespace being transported to the target format. If they are of the same endianness, then no conversion is necessary and tablespaces can be transported as if they were on the same platform.
Transporting the tablespace

    Prepare for export of the tablespace.
        Check that the tablespace will be self contained:
        SQL> execute sys.dbms_tts.transport_set_check('TBS1,TBS2', true);
        SQL> select * from sys.transport_set_violations;

        Note: these violations must be resolved before the tablespaces can be transported.
        The tablespaces need to be in READ ONLY mode in order to successfully run a transport tablespace export:
        SQL> ALTER TABLESPACE TBS1 READ ONLY;
        SQL> ALTER TABLESPACE TBS2 READ ONLY;
    Export the metadata.
        Using the original export utility:
        exp userid=\'sys/sys as sysdba\' file=tbs_exp.dmp log=tba_exp.log transport_tablespace=y tablespaces=TBS1,TBS2
        Using Datapump export:
        First create the directory object to be used for Datapump, like in:
        CREATE OR REPLACE DIRECTORY dpump_dir AS '/tmp/subdir' ;
        GRANT READ,WRITE ON DIRECTORY dpump_dir TO system;

        Then initiate Datapump Export:
        expdp system/password DUMPFILE=expdat.dmp DIRECTORY=dpump_dir TRANSPORT_TABLESPACES = TBS1,TBS2

        If you want to perform a transport tablespace operation with a strict containment check, use the TRANSPORT_FULL_CHECK parameter:
        expdp system/password DUMPFILE=expdat.dmp DIRECTORY = dpump_dir TRANSPORT_TABLESPACES= TBS1,TBS2 TRANSPORT_FULL_CHECK=Y

        If the tablespace set being transported is not self-contained then the export will fail.
    Use V$TRANSPORTABLE_PLATFORM to determine the endianness of each platform. You can execute the following query on each platform instance:
    SELECT tp.platform_id,substr(d.PLATFORM_NAME,1,30), ENDIAN_FORMAT
    FROM V$TRANSPORTABLE_PLATFORM tp, V$DATABASE d
    WHERE tp.PLATFORM_NAME = d.PLATFORM_NAME;

    If you see that the endian formats are different and then a conversion is necessary for transporting the tablespace set:
    RMAN> convert tablespace TBS1 to platform="Linux IA (32-bit)" FORMAT '/tmp/%U';

    RMAN> convert tablespace TBS2 to platform="Linux IA (32-bit)" FORMAT '/tmp/%U';

    Then copy the datafiles as well as the export dump file to the target environment.
    Import the transportable tablespace.
        Using the original import utility:
        imp userid=\'sys/sys as sysdba\' file=tbs_exp.dmp log=tba_imp.log transport_tablespace=y datafiles='/tmp/....','/tmp/...'
        Using Datapump:
        CREATE OR REPLACE DIRECTORY dpump_dir AS '/tmp/subdir';
        GRANT READ,WRITE ON DIRECTORY dpump_dir TO system;

        Followed by:
        impdp system/password DUMPFILE=expdat.dmp DIRECTORY=dpump_dir TRANSPORT_DATAFILES='/tmp/....','/tmp/...' REMAP_SCHEMA=(source:target) REMAP_SCHEMA=(source_sch2:target_schema_sch2)

        You can use REMAP_SCHEMA if you want to change the ownership of the transported database objects.
    Put the tablespaces in read/write mode:
    SQL> ALTER TABLESPACE TBS1 READ WRITE;
    SQL> ALTER TABLESPACE TBS2 READ WRITE;