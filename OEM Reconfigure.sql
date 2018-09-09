OEM Reconfigure
---------------
http://gerardnico.com/wiki/database/oracle/oracledb_emca_how_to_reconfigure

Automatic mode
--------------
When the database host name (including the domain name) or the IP address changes, deconfigure and then reconfigure the Database Console with the repository create command. Run the following command:

emca -deconfig dbcontrol db
emca -config dbcontrol db -repos recreate

or

emca -deconfig dbcontrol db -repos drop
emca -config dbcontrol db -repos create

Manual reconfiguration
----------------------
If you have some problem during the reconfiguration problem. Here are a manual fashion.

emca -deconfig dbcontrol db -repos drop

And then as sys as sysdba :

DROP USER sysman cascade;
DROP PUBLIC SYNONYM SETEMVIEWUSERCONTEXT;
DROP role MGMT_USER;
DROP PUBLIC SYNONYM MGMT_TARGET_BLACKOUTS;
DROP USER MGMT_VIEW;
Restart the computer because/if the service is marked to delete.

And to finish :

emca -config dbcontrol db -repos create

The result

The result that you must obtain :

INFO: Starting Database Control (this may take a while) ...
13-jul-2009 14:20:28 oracle.sysman.emcp.EMDBPostConfig performConfiguration
INFO: Database Control started successfully
13-jul-2009 14:20:28 oracle.sysman.emcp.EMDBPostConfig performConfiguration
INFO: >>>>>>>>>>> The Database Control URL is https://gerardnico.com:1
158/em <<<<<<<<<<<
Enterprise Manager configuration completed successfully
FINISHED EMCA at 13-jul-2009 14:20:28