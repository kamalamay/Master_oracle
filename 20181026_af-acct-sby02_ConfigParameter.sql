### Move spfile to ASM +DATA
### because of spfile Production is inside ASM +DATA
### spfile=+DATA/spfileacction.ora
####################################################
oracle@af-acct-sby02:~$ sqlplus "/ as sysdba"
SQL> create pfile='/export/home/oracle/initacction_20181026.ora' from spfile;
SQL> RECOVER MANAGED STANDBY DATABASE CANCEL;
SQL> EXIT;
oracle@af-acct-sby02:~$ srvctl stop database -db acctsbym12
oracle@af-acct-sby02:~$ sqlplus "/ as sysdba"
SQL> create spfile='+DATA' from pfile='/export/home/oracle/initacction_20181026.ora';
SQL> EXIT;
oracle@af-acct-sby02:~$ su - grid
grid@af-acct-sby02:~$ asmcmd
ASMCMD> cd +DATA/ACCTSBYM12/PARAMETERFILE
ASMCMD> ls -l
ASMCMD> EXIT
grid@af-acct-sby02:~$ exit
oracle@af-acct-sby02:~$ srvctl modify database -db acctsbym12 -spfile +DATA/ACCTSBYM12/PARAMETERFILE/spfileBLABLABLA
oracle@af-acct-sby02:~$ srvctl config database -db acctsbym12

### Config max-shm-memory to 150GB
### because of SGA is 150GB
##################################
oracle@af-acct-sby02:~$ su -
root@af-acct-sby02 # projmod -sK "project.max-shm-memory=(priv,150gb,deny)" group.dba
root@af-acct-sby02 # projmod -sK "project.max-shm-memory=(priv,150gb,deny)" user.oracle
root@af-acct-sby02 # su - grid
grid@af-acct-sby02:~$ crsctl stop has
grid@af-acct-sby02:~$ exit
root@af-acct-sby02 # reboot

### Config parameters to be same of Production
##############################################
oracle@af-acct-sby02:~$ srvctl start database -db acctsbym12 -o mount
oracle@af-acct-sby02:~$ sqlplus "/ as sysdba"
SQL> SHO PARAMETER PFILE;
SQL> create pfile='/export/home/oracle/initacction_20181026_2.ora' from spfile;
SQL> alter system set AUDIT_TRAIL=db, extended scope=spfile;
SQL> alter system set control_file_record_keep_time=16 SCOPE=SPFILE;
SQL> alter system set db_domain='' SCOPE=SPFILE;
SQL> alter system set db_files=400 SCOPE=SPFILE;
SQL> alter system set db_flashback_retention_target=21600 SCOPE=SPFILE;
SQL> alter system set db_recovery_file_dest_size=200G SCOPE=SPFILE;
SQL> alter system set dml_locks=39704 SCOPE=SPFILE;
SQL> alter system set log_archive_dest_state_2='enable' SCOPE=SPFILE;
SQL> alter system set log_archive_max_processes=8 SCOPE=SPFILE;
SQL> alter system set log_buffer=501064K SCOPE=SPFILE;
SQL> alter system set nls_date_format='dd-mon-rrrr' SCOPE=SPFILE;
SQL> alter system set open_cursors=7000 SCOPE=SPFILE;
SQL> alter system set pga_aggregate_limit=5G SCOPE=SPFILE;
SQL> alter system set processes=6000 SCOPE=SPFILE;
SQL> alter system set remote_dependencies_mode=SIGNATURE SCOPE=SPFILE;
SQL> alter system set result_cache_max_size=512M SCOPE=SPFILE;
SQL> alter system set sec_case_sensitive_logon='FALSE' SCOPE=SPFILE;
SQL> alter system set service_names=acction SCOPE=SPFILE;
SQL> alter system set sga_max_size=150G SCOPE=SPFILE;
SQL> alter system set sga_target=100G SCOPE=SPFILE;
SQL> alter system set shared_servers=0 SCOPE=SPFILE;
SQL> alter system set standby_archive_dest='LOCATION=/archive/archive' SCOPE=SPFILE;
SQL> EXIT;
oracle@af-acct-sby02:~$ srvctl stop database -db acctsbym12
oracle@af-acct-sby02:~$ srvctl start database -db acctsbym12 -o mount
oracle@af-acct-sby02:~$ sqlplus "/ as sysdba"
SQL> ALTER DATABASE OPEN READ ONLY;
SQL> RECOVER MANAGED STANDBY DATABASE DISCONNECT FROM SESSION;
SQL> SHOW PARAMETER;