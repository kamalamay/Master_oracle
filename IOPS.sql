--IOPS ASM
SET LINES 160 PAGES 5000 TIMING ON;
COL NAME FORMAT A9
COL PATH FOR A30;
COL DISKGROUP FOR A20;
COL DISKNAME FOR A20;
SELECT
  T3.NAME DISKGROUP, T2.NAME DISKNAME, T2.PATH, T2.READS, T2.READ_TIME, ROUND(T2.READ_TIME/T2.READS*1000,3) RD_RSPD_MS, T2.WRITES,ROUND(T2.WRITE_TIME/T2.WRITES*1000,3) WR_RSPD_MS,
  ROUND((T2.READ_TIME+T2.WRITE_TIME)/(T2.READS+T2.WRITES)*1000,3) DSK_RSPD_MS, ROUND((T2.BYTES_READ+T2.BYTES_WRITTEN)/1024/1024/(T2.READ_TIME+T2.WRITE_TIME)) MB_PER_SEC
FROM V$ASM_DISK T2, V$ASM_DISKGROUP T3 WHERE T3.GROUP_NUMBER=T2.GROUP_NUMBER ORDER BY 1,2;

--IOPS DB
SET LINES 160 PAGES 5000 TIMING ON;
COL METRIC_NAME FOR A40;
COL MIN FOR A20;
COL MAX FOR A20;
COL AVG FOR A20;
SELECT
  METRIC_NAME,
  (CASE WHEN metric_name LIKE '%Bytes%' THEN TO_CHAR(ROUND(MIN(minval / 1024),1)) || ' KB' ELSE TO_CHAR(ROUND(MIN(minval),1)) END) min,
  (CASE WHEN metric_name LIKE '%Bytes%' THEN TO_CHAR(ROUND(MAX(maxval / 1024),1)) || ' KB' ELSE TO_CHAR(ROUND(MAX(maxval),1)) END) max,
  (CASE WHEN metric_name LIKE '%Bytes%' THEN TO_CHAR(ROUND(AVG(average / 1024),1)) || ' KB' ELSE TO_CHAR(ROUND(AVG(average),1)) END) avg
FROM DBA_HIST_SYSMETRIC_SUMMARY WHERE metric_name IN (
  'Physical Read Total IO Requests Per Sec',
  'Physical Write Total IO Requests Per Sec',
  'Physical Read Total Bytes Per Sec',
  'Physical Write Total Bytes Per Sec')
GROUP BY metric_name ORDER BY metric_name;

--AWR 12c located in IO Profile ==> Total Requests and Total (MB)
--AWR 11g located in  Instance Activity Stats ==> physical read total IO requests + physical write total IO requests

--IO Calibration
/*
Prerequisites for I/O Calibration
Before running I/O calibration, ensure that the following requirements are met:
The user must be granted the SYSDBA privilege
timed_statistics must be set to TRUE
Asynchronous I/O must be enabled
When using file systems, asynchronous I/O can be enabled by setting the FILESYSTEMIO_OPTIONS initialization parameter to SETALL.
Ensure that asynchronous I/O is enabled for data files by running the following query:
*/
COL NAME FORMAT A50;
SELECT NAME, ASYNCH_IO FROM V$DATAFILE F,V$IOSTAT_FILE I WHERE F.FILE#=I.FILE_NO AND FILETYPE_NAME='Data File';

SET SERVEROUTPUT ON
DECLARE
  lat  INTEGER;
  iops INTEGER;
  mbps INTEGER;
BEGIN
-- DBMS_RESOURCE_MANAGER.CALIBRATE_IO (<DISKS>, <MAX_LATENCY>, iops, mbps, lat);
   DBMS_RESOURCE_MANAGER.CALIBRATE_IO (2, 10, iops, mbps, lat);
 
  DBMS_OUTPUT.PUT_LINE ('max_iops = ' || iops);
  DBMS_OUTPUT.PUT_LINE ('latency  = ' || lat);
  dbms_output.put_line('max_mbps = ' || mbps);
end;
/

/*
At any time during the I/O calibration process, you can query the calibration status in the V$IO_CALIBRATION_STATUS view.
After I/O calibration is successfully completed, you can view the results in the DBA_RSRC_IO_CALIBRATE table.
*/

ALTER SESSION SET NLS_DATE_FORMAT='DD-Mon-RR HH24:MI:SS';
SELECT INSTANCE_NUMBER,BEGIN_TIME,END_TIME,ROUND(MAXVAL) MAXIMUM_IOPS,ROUND(AVERAGE) AVERAGE_IOPS,NUM_INTERVAL FROM DBA_HIST_SYSMETRIC_SUMMARY WHERE BEGIN_TIME BETWEEN 
TO_DATE('19-Jul-18 00:00','DD-Mon-RR HH24:MI') AND TO_DATE('19-Jul-18 13:00','DD-Mon-RR HH24:MI') and METRIC_NAME='I/O Requests per Second' ORDER BY 1,2;

SELECT INSTANCE_NUMBER,BEGIN_TIME,END_TIME,ROUND(MAXVAL) MAXIMUM_IOPS,ROUND(AVERAGE) AVERAGE_IOPS,NUM_INTERVAL FROM DBA_HIST_SYSMETRIC_SUMMARY WHERE BEGIN_TIME BETWEEN
TO_DATE('19-Jul-18 00:00','DD-Mon-RR HH24:MI') AND TO_DATE('19-Jul-18 13:00','DD-Mon-RR HH24:MI') and METRIC_NAME='I/O Megabytes per Second' ORDER BY 1,2;
