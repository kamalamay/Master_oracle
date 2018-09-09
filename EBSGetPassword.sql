DECLARE
      l_func_name          VARCHAR2(4000) := 'IDXX_DECRYPT_'||USERENV('sessionid');
      funcSQLCreate       VARCHAR2(4000) := 
                   'CREATE OR REPLACE FUNCTION '||l_func_name||' (KEY IN VARCHAR2, VALUE IN VARCHAR2) return varchar2 '||
                '    AS LANGUAGE JAVA NAME ''oracle.apps.fnd.security.WebSessionManagerProc.decrypt(java.lang.String,java.lang.String) return java.lang.String''; ';
      strSQL              VARCHAR2(4000);
      v_password              VARCHAR2(4000);
      userID               NUMBER;          
      encFndPwd               VARCHAR2(4000);
      encUserPwd           VARCHAR2(4000);  
      v_key                   VARCHAR2(4000);
      guestUserPwd          VARCHAR2(4000);
      delim                  NUMBER;
      guestUserName          VARCHAR2(4000);
      guestEncFndPwd      VARCHAR2(4000);
      guestFndPwd          VARCHAR2(4000);
BEGIN
     --
     guestUserPwd := 'GUEST/ORACLE';--UPPER(fnd_profile.VALUE('GUEST_USER_PWD'));
     delim           := INSTR(guestUserPwd,'/');
     guestUserName := UPPER(SUBSTR(guestUserPwd,1,delim-1));
     --
     SELECT encrypted_foundation_password 
     INTO guestEncFndPwd 
     FROM fnd_user
     WHERE user_name = guestUserName;
     --
     EXECUTE IMMEDIATE funcSQLCreate;
     --
     strSQL := 'SELECT '||l_func_name||'(:key,:EncFndPwd) FROM dual';
     EXECUTE IMMEDIATE strSQL 
              INTO guestFndPwd
     USING guestUserPwd,guestEncFndPwd;
     --
     dbms_output.put_line('guestUserPwd : '||guestUserPwd||' , guestEncFndPwd : '||guestEncFndPwd);
     --
     BEGIN
         SELECT  user_id, encrypted_foundation_password, encrypted_user_password
         INTO    userID, encFndPwd, encUserPwd
         FROM    fnd_user
         WHERE   UPPER(user_name) = UPPER(:p_username)
         AND     (start_date <= SYSDATE)
         AND     (end_date IS NULL OR end_date > SYSDATE);
     EXCEPTION
         WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR(Hr_Utility.hr_error_number,'Invalid User name => '||SQLERRM);
     END;
     --
     SELECT encrypted_foundation_password 
     INTO guestEncFndPwd 
     FROM fnd_user
     WHERE user_name = guestUserName;
     --
     strSQL := 'SELECT '||l_func_name||'(:key,:EncFndPwd) FROM dual';
     EXECUTE IMMEDIATE strSQL
             INTO v_password
     USING guestFndPwd, encUserPwd;
     --
     strSQL := 'SELECT '||l_func_name||'(:key,:EncFndPwd) FROM dual';
/*     EXECUTE IMMEDIATE strSQL 
              INTO guestFndPwd
     USING guestUserPwd,:p_APPL_SERVER_ID;--guestEncFndPwd;
     DBMS_OUTPUT.PUT_LINE('Custom Database password from DBC File : '||guestFndPwd); */
     --     
     EXECUTE IMMEDIATE 'drop function '||l_func_name;
     --
     DBMS_OUTPUT.PUT_LINE('Database password : '||guestFndPwd);
     DBMS_OUTPUT.PUT_LINE('User '||:p_username||', password : '||v_password);
     --
END;