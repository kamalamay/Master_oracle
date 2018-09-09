##!/bin/bash
# set environtment
SCRIPTDIR=/home/oracle/mii/$3
REPORTDIR=/home/oracle/mii/$3/addmrpt
SCRIPTFILE=genreports.sql
export SCRIPTDIR REPORTDIR SCRIPTFILE

# set range for report snap id
echo "Nilai range awal  = $1"
echo "Nilai range akhir = $2"
 
cd $SCRIPTDIR
mkdir -p $REPORTDIR
rm $SCRIPTFILE

echo "Generating reports in $REPORTDIR.."

sqlplus -S > /dev/null <<!
connect / as sysdba

set serveroutput on size 1000000
set feed off term off trims on linesize 300

spool $SCRIPTFILE

DECLARE
   
   v_rangeawal   NUMBER := $1 ; 
   v_rangeakhir  NUMBER := $2 ;
   v_nextsnid    NUMBER ;
   v_btime       VARCHAR2(20) ;  -- snap time
   v_nbtime      VARCHAR2(20) ;  -- next snap time
   v_reportname  VARCHAR2(200) ;
   v_reporttype  CONSTANT VARCHAR2(5) := 'text' ;
   v_numdays     CONSTANT NUMBER := 7 ;
   v_addm_bsnid  NUMBER ;

   CURSOR c_snid IS
      SELECT snap_id, 
             to_char(begin_interval_time,'ddmmyy_hh24mi') snap_time
      FROM dba_hist_snapshot 
      WHERE snap_id BETWEEN v_rangeawal AND v_rangeakhir
      AND instance_number = 1				  -- node 2 (RAC)
      ORDER BY snap_id ;

   c_recsnid c_snid%ROWTYPE ;

BEGIN

   OPEN c_snid ;
   FETCH c_snid INTO v_addm_bsnid, v_btime ;
   CLOSE c_snid ;
   
   FOR c_recsnid IN c_snid LOOP

      SELECT to_char(begin_interval_time, 'ddmmyy_hh24mi')
      INTO v_btime
      FROM dba_hist_snapshot
      WHERE snap_id = c_recsnid.snap_id 
      AND instance_number = 1 ;

      SELECT min(snap_id)
      INTO v_nextsnid
      FROM dba_hist_snapshot
      WHERE snap_id > c_recsnid.snap_id 
      AND instance_number = 1 ;

      SELECT to_char(begin_interval_time,'hh24mi') 
      INTO v_nbtime 
      FROM dba_hist_snapshot 
      WHERE snap_id = v_nextsnid 
      AND instance_number = 1 ;

      
      v_reportname := '$REPORTDIR/'||'addm'||c_recsnid.snap_id|| 
                      '_'||v_nextsnid||'_'||v_btime||'_'|| 
                       v_nbtime||'.txt' ;

      -- next, generate reports..

      dbms_output.put_line('define report_type='||v_reporttype);
      dbms_output.put_line('define report_name='||v_reportname);
      dbms_output.put_line('define num_days='||v_numdays);
      dbms_output.put_line('define begin_snap='||c_recsnid.snap_id);
      dbms_output.put_line('define end_snap='||v_nextsnid);
      dbms_output.put_line('@$ORACLE_HOME/rdbms/admin/addmrpt');
 
   END LOOP ; 
      
EXCEPTION
   WHEN no_data_found THEN
      dbms_output.put_line('Only one snap exist');
      null ;
   WHEN others THEN
      dbms_output.put_line(sqlerrm) ;
END ;
/
spool off
!

cd $SCRIPTDIR

sqlplus -S > /dev/null <<!
connect / as sysdba
@$SCRIPTFILE
exit
!
