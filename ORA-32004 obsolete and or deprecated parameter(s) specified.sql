Symptoms
--------
SQL> STARTUP;
ORA-32004: obsolete and/or deprecated parameter(s) specified
ORACLE instance started.

Changes
-------
The parameter REMOTE_OS_AUTHENT has been set.

Cause
-----
SQL> ALTER SYSTEM SET REMOTE_OS_AUTHENT = TRUE SCOPE=SPFILE;

System altered.

SQL> STARTUP FORCE;
ORA-32004: obsolete and/or deprecated parameter(s) specified
ORACLE instance started.

Solution
--------
To remove the deprecated parameter from the spfile issue:
ALTER SYSTEM RESET REMOTE_OS_AUTHENT SCOPE=SPFILE;

/*
REMOTE_OS_AUTHENT specifies whether remote clients will be authenticated over insecure connections, this parameter is now deprecated. It is retained for backward compatibility only. This means the parameter will still work, but the ORA-32004 should be a strong incentive to phase out any functionality relying on it. Stepping up 'out-of-the-box' security Oracle has decided to deprecate this potentially dangerous parameter in the 11g releases. 
*/