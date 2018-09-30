vi stopDB.sh; chmod +x stopDB.sh;
#################################
#!/bin/bash
source /home/oraprod/PROD/12.1.0/PROD_ebsexa.env; $ORACLE_HOME/bin/lsnrctl stop PROD
$ORACLE_HOME/bin/sqlplus / as sysdba << EOF
SHU IMMEDIATE;
EXIT;
EOF

vi startDB.sh; chmod +x startDB.sh;
###################################
#!/bin/bash
source /home/oraprod/PROD/12.1.0/PROD_ebsexa.env; $ORACLE_HOME/bin/lsnrctl start PROD
$ORACLE_HOME/bin/sqlplus / as sysdba << EOF
STARTUP;
EXIT;
EOF

Atau
####
dbstart $ORACLE_HOME
dbshut $ORACLE_HOME