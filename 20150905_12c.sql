SELECT NAME,OPEN_MODE FROM V$PDBS;
ALTER PLUGGABLE DATABASE ALL OPEN;
ALTER PLUGGABLE DATABASE PDBSATU UNPLUG INTO '/home/orekel/mii/20150904_Plug/PDBSATU.xml';
ALTER PLUGGABLE DATABASE PDBSATU CLOSE IMMEDIATE;
SELECT PDB_NAME,STATUS FROM CDB_PDBS;
DROP PLUGGABLE DATABASE PDBSATU KEEP DATAFILES;

set serveroutput on
DECLARE
   compatible BOOLEAN := FALSE;
BEGIN   
   compatible := DBMS_PDB.CHECK_PLUG_COMPATIBILITY(
        pdb_descr_file => '/home/orekel/mii/20150904_Plug/PDBSATU.xml');
   if compatible then
      DBMS_OUTPUT.PUT_LINE('Is pluggable PDB1 compatible? YES');
   else DBMS_OUTPUT.PUT_LINE('Is pluggable PDB1 compatible? NO');
   end if;
END;
/

CREATE PLUGGABLE DATABASE PDBSATUCOPY USING '/home/orekel/mii/20150904_Plug/PDBSATU.xml' NOCOPY TEMPFILE REUSE;
ALTER PLUGGABLE DATABASE PDBSATUCOPY OPEN READ WRITE;
CONNECT SYS/oracle@localhost:1521/pdb_plug_nocopy AS SYSDBA
SHOW CON_NAME
EXEC DBMS_XDB_CONFIG.SETHTTPSPORT (5502);
SELECT DBMS_XDB_CONFIG.GETHTTPSPORT () FROM DUAL;

run{
    allocate channel C1 type disk;
    allocate channel C2 type disk;
    backup as compressed backupset tag 'FULLDB' format '/home/orekel/mii/20150905_rman/FULLBKP_%d_%s_%p_%t' (database);
    backup tag CTRL current controlfile format '/home/orekel/mii/20150905_rman/CTRL_%d_%s_%p_%t';
    sql 'alter system archive log current';
    backup tag ARC format '/home/orekel/mii/20150905_rman/ARCH_%d_%s_%p_%t' archivelog all delete all input;
    release channel C1;
    release channel C2;
}
STARTUP NOMOUNT;
RESTORE CONTROLFILE FROM '/home/orekel/mii/20150905_rman_backup/CTRL_BAKPIA_10_1_889575774';
ALTER DATABASE MOUNT;
CATALOG START WITH '/home/orekel/mii/20150905_rman_backup';
RUN{
	ALLOCATE CHANNEL C1 TYPE DISK;
	ALLOCATE CHANNEL C2 TYPE DISK;
	RESTORE DATABASE;
	RECOVER DATABASE;
	RELEASE CHANNEL C1;
	RELEASE CHANNEL C2;
}
ALTER DATABASE OPEN RESETLOGS;

recover database until time "to_date('05-sep-2015 00:50:00','dd-mon-rrrr hh24:mi:ss')";

SELECT USERNAME FROM DBA_USERS ORDER BY 1;