--Procedure Kill Session
CREATE OR REPLACE PROCEDURE PROC_KILL_INACTIVE_SESSION is
STMT VARCHAR2(1000);
BEGIN
  FOR X IN
  (
    SELECT SID, SERIAL#, last_call_et
    FROM V$SESSION
    WHERE STATUS='INACTIVE' AND USERNAME<>'SYS' AND (last_call_et / 60) > 30
  )
  LOOP
    --generate the script for killing in active sessions
    STMT := 'ALTER SYSTEM KILL SESSION ''' ||X.SID ||',' ||X.SERIAL# ||'''' ;
    DBMS_OUTPUT.PUT_LINE( STMT );
    EXECUTE IMMEDIATE STMT;
  END LOOP;
END;

Description :
LAST_CALL_ET Type NUMBER ==> in seconds
LAST_CALL_ET: If the session STATUS is currently INACTIVE, then the value represents the elapsed time in seconds since the session has become inactive.