·         Checking CRS Status
·         Viewing Name Of the Cluster
·         Viewing Nodes Configuration
·         Checking Votedisk Information
·         Checking OCR Disk information
·         Timeout Settings in Cluster
·         ADD/Remove OCR files
·         ADD/Remove Votedisk
·         Backing Up OCR
·         Backing Up Votedisk
·         Restoring OCR Devices
·         Restoring Voting Disk Devices
·         Changing Public IPs as well as Virtual IPs
 
 
Checking CRS Status:
 
The below two commands are generally used to check the status of CRS. The first command lists the status of CRS on the local node where as the other command shows the CRS status across all the nodes in Cluster.
 
crsctl check crs <<-- for the local node
crsctl check cluster <<-- for remote nodes in the cluster
 
[root@node1-pub ~]# crsctl check crs
Cluster Synchronization Services appears healthy
Cluster Ready Services appears healthy
Event Manager appears healthy
[root@node1-pub ~]#
 
For the below command to run, CSS needs to be running on the local node. The "ONLINE" status for remote node says that CSS is running on that node. When CSS is down on the remote node, the status of "OFFLINE" is displayed for that node.
 
[root@node1-pub ~]# crsctl check cluster
node1-pub    ONLINE
node2-pub    ONLINE
 
Viewing Cluster name:
 
I use below command to get the name of Cluster. The similar information can be retrieved from the dump file.
 
ocrdump -stdout -keyname SYSTEM | grep -A 1 clustername | grep ORATEXT | awk '{print $3}'
 
OR
 
ocrconfig -export /tmp/ocr_exp.dat -s online
for i in `strings /tmp/ocr_exp.dat | grep -A 1 clustername` ; do if [ $i != 'SYSTEM.css.clustername' ]; then echo $i; fi; done
 
OR
 
Oracle creates a directory with the same name as Cluster under the $ORA_CRS_HOME/cdata.
 
No. Of Nodes configured in Cluster:
 
The below command can be used to find out the number of nodes registered into the cluster. It also displays the node's Public name, Private name and Virtual name along with their numbers.
 
olsnodes -n -p -i
 
[root@node1-pub ~]# olsnodes -n -p -i
node1-pub       1       node1-prv       node1-vip
node2-pub       2       node2-prv       node2-vip
 
Viewing Votedisk Information:
 
The below command is used to view the no. of Voting disks configured in the Cluster.
 
crsctl query css votedisk
 
Viewing OCR Information:
 
The ocrcheck command displays the no. of OCR files configured in the Cluster. It is primarily used to chck the integrity of the OCR files. It also displays the version of OCR as well as storage space information. You can only have 2 OCR files at max.
 
[root@node1-pub ~]# ocrcheck
Status of Oracle Cluster Registry is as follows :
         Version                  :          2
         Total space (kbytes)     :     262120
         Used space (kbytes)      :       3848
         Available space (kbytes) :     258272
         ID                       :  744414276
         Device/File Name         : /u02/ocfs2/ocr/OCRfile_0
                                    Device/File integrity check succeeded
         Device/File Name         : /u02/ocfs2/ocr/OCRfile_1
                                    Device/File integrity check succeeded
 
         Cluster registry integrity check succeeded
 
Various Timeout Settings in Cluster:
 
Disktimeout: Disk Latencies in seconds from node-to-Votedisk. Default Value is 200. (Disk IO)
Misscount:     Network Latencies in second from node-to-node (Interconnect). Default Value is 60 Sec (Linux) and 30 Sec in Unix platform. (Network IO) Misscount < Disktimeout
 
IF
  (Disk IO Time > Disktimeout) OR (Network IO time > Misscount)
THEN
   REBOOT NODE
ELSE
   DO NOT REBOOT
END IF;
 
crsctl get css disktimeout
crsctl get css misscount
crsctl get css  reboottime
 
[root@node1-pub ~]# crsctl get css disktimeout
200
[root@node1-pub ~]# crsctl get css misscount
Configuration parameter misscount is not defined.
 
The above message indicates that the Misscount is not set manually and it is set to its default Value which is 60 seconds on Linux. It can be changed as below.
 
[root@node1-pub ~]# crsctl set css misscount 100
Configuration parameter misscount is now set to 100.
[root@node1-pub ~]# crsctl get css misscount
100
 
The below command sets the value of misscount back to its default value.
 
crsctl unset css misscount
[root@node1-pub ~]# crsctl unset css misscount
[root@node1-pub ~]# crsctl get css  reboottime
 
Add/Remove OCR file in Cluster:
 
Removing OCR File
 
(1) Get the Existing OCR file information by running ocrcheck utility.
 
[root@node1-pub ~]# ocrcheck
Status of Oracle Cluster Registry is as follows :
         Version                  :          2
         Total space (kbytes)     :     262120
         Used space (kbytes)      :       3852
         Available space (kbytes) :     258268
         ID                       :  744414276
         Device/File Name         : /u02/ocfs2/ocr/OCRfile_0 <-- OCR
                                    Device/File integrity check succeeded
         Device/File Name         : /u02/ocfs2/ocr/OCRfile_1 <-- OCR Mirror
                                    Device/File integrity check succeeded
 
         Cluster registry integrity check succeeded
 
(2) The First command removes the OCR mirror (/u02/ocfs2/ocr/OCRfile_1). If you want to remove the OCR file (/u02/ocfs2/ocr/OCRfile_1) run the next command.
 
ocrconfig -replace ocrmirror
ocrconfig -replace ocr
 
[root@node1-pub ~]# ocrconfig -replace ocrmirror
[root@node1-pub ~]# ocrcheck
Status of Oracle Cluster Registry is as follows :
         Version                  :          2
         Total space (kbytes)     :     262120
         Used space (kbytes)      :       3852
         Available space (kbytes) :     258268
         ID                       :  744414276
         Device/File Name         : /u02/ocfs2/ocr/OCRfile_0 <<-- OCR File
                                    Device/File integrity check succeeded
 
                                    Device/File not configured  <-- OCR Mirror not existed any more
 
         Cluster registry integrity check succeeded
 
Adding OCR
 
You need to add OCR or OCR mirror file in a case where you want to move the existing OCR file location to the different devices. The below command add the OCR mirror file if OCR file already exists.
 
(1) Get the Current status of OCR:
 
[root@node1-pub ~]# ocrconfig -replace ocrmirror
[root@node1-pub ~]# ocrcheck
Status of Oracle Cluster Registry is as follows :
         Version                  :          2
         Total space (kbytes)     :     262120
         Used space (kbytes)      :       3852
         Available space (kbytes) :     258268
         ID                       :  744414276
         Device/File Name         : /u02/ocfs2/ocr/OCRfile_0 <<-- OCR File
                                    Device/File integrity check succeeded
 
                                    Device/File not configured  <-- OCR Mirror does not exist
 
         Cluster registry integrity check succeeded
 
As it can be seen, there is only one OCR file but not the second file (OCR Mirror). Below command adds the second OCR file.
 
ocrconfig -replace ocrmirror <File name>
 
[root@node1-pub ~]# ocrconfig -replace ocrmirror /u02/ocfs2/ocr/OCRfile_1
[root@node1-pub ~]# ocrcheck
Status of Oracle Cluster Registry is as follows :
         Version                  :          2
         Total space (kbytes)     :     262120
         Used space (kbytes)      :       3852
         Available space (kbytes) :     258268
         ID                       :  744414276
         Device/File Name         : /u02/ocfs2/ocr/OCRfile_0
                                    Device/File integrity check succeeded
         Device/File Name         : /u02/ocfs2/ocr/OCRfile_1
                                    Device/File integrity check succeeded
 
         Cluster registry integrity check succeeded
 
You can have at most 2 OCR devices (OCR itself and its single Mirror) in a cluster. Adding extra Mirror gives you below error message
 
[root@node1-pub ~]# ocrconfig -replace ocrmirror /u02/ocfs2/ocr/OCRfile_2
PROT-21: Invalid parameter
[root@node1-pub ~]#
Add/Remove Votedisk file in Cluster:
 
Add/Remove Voting Disk in Cluster:
 
Adding Votedisk:
 
Get the existing Vote Disks associated into the cluster. To be safe, Bring crs cluster stack down on all the nodes but one on which you are going to add votedisk from.
 
(1)    Stop CRS on all the nodes in cluster but one.
 
[root@node2-pub ~]# crsctl stop crs
 
(2)    Get the list of Existing Vote Disks
 
crsctl query css votedisk
 
[root@node1-pub ~]# crsctl query css votedisk
 0.     0    /u02/ocfs2/vote/VDFile_0
 1.     0    /u02/ocfs2/vote/VDFile_1
 2.     0    /u02/ocfs2/vote/VDFile_2
Located 3 voting disk(s).
 
(3)    Backup the Votedisk file
 
Backup the existing votedisks as below as oracle:
 
dd if=/u02/ocfs2/vote/VDFile_0 of=$ORACLE_BASE/bkp/vd/VDFile_0
 
[root@node1-pub ~]# su - oracle
[oracle@node1-pub ~]$ dd if=/u02/ocfs2/vote/VDFile_0 of=$ORACLE_BASE/bkp/vd/VDFile_0
41024+0 records in
41024+0 records out
[oracle@node1-pub ~]$
 
(4)     Add an Extra Votedisk into the Cluster:
 
  If it is a OCFS, then touch the file as oracle. On raw devices, initialize the raw devices using "dd" command
 
touch /u02/ocfs2/vote/VDFile_3 <<-- as oracle
crsctl add css votedisk /u02/ocfs2/vote/VDFile_3 <<-- as oracle
crsctl query css votedisks
 
[root@node1-pub ~]# su - oracle
[oracle@node1-pub ~]$ touch /u02/ocfs2/vote/VDFile_3
[oracle@node1-pub ~]$ crsctl add css votedisk /u02/ocfs2/vote/VDFile_3
Now formatting voting disk: /u02/ocfs2/vote/VDFile_3.
Successful addition of voting disk /u02/ocfs2/vote/VDFile_3.
 
(5)     Confirm that the file has been added successfully:
 
[root@node1-pub ~]# ls -l /u02/ocfs2/vote/VDFile_3
-rw-r-----  1 oracle oinstall 21004288 Oct  6 16:31 /u02/ocfs2/vote/VDFile_3
[root@node1-pub ~]# crsctl query css votedisks
Unknown parameter: votedisks
[root@node1-pub ~]# crsctl query css votedisk
 0.     0    /u02/ocfs2/vote/VDFile_0
 1.     0    /u02/ocfs2/vote/VDFile_1
 2.     0    /u02/ocfs2/vote/VDFile_2
 3.     0    /u02/ocfs2/vote/VDFile_3
Located 4 voting disk(s).
 
Removing Votedisk:
 
Removing Votedisk from the cluster is very simple. The below command removes the given votedisk from cluster configuration.
 
crsctl delete css votedisk /u02/ocfs2/vote/VDFile_3
 
[root@node1-pub ~]# crsctl delete css votedisk /u02/ocfs2/vote/VDFile_3
Successful deletion of voting disk /u02/ocfs2/vote/VDFile_3.
[root@node1-pub ~]#
 
[root@node1-pub ~]# crsctl query css votedisk
 0.     0    /u02/ocfs2/vote/VDFile_0
 1.     0    /u02/ocfs2/vote/VDFile_1
 2.     0    /u02/ocfs2/vote/VDFile_2
Located 3 voting disk(s).
[root@node1-pub ~]#
 
Backing up OCR:
 
Oracle performs physical backup of OCR devices every 4 hours under the default backup directory $ORA_CRS_HOME/cdata/<CLUSTER_NAME>  and then it rolls that forward to Daily, weekly and monthly backup. You can get the backup information by executing below command.
 
ocrconfig -showbackup
 
[root@node1-pub ~]# ocrconfig -showbackup
node2-pub     2007/09/03 17:46:47     /u01/app/crs/cdata/test-crs/backup00.ocr
node2-pub     2007/09/03 13:46:45     /u01/app/crs/cdata/test-crs/backup01.ocr
node2-pub     2007/09/03 09:46:44     /u01/app/crs/cdata/test-crs/backup02.ocr
node2-pub     2007/09/03 01:46:39     /u01/app/crs/cdata/test-crs/day.ocr
node2-pub     2007/09/03 01:46:39     /u01/app/crs/cdata/test-crs/week.ocr
[root@node1-pub ~]#
 
Manually backing up the OCR
 
ocrconfig -manualbackup <<--Physical Backup of OCR
 
The above command backs up OCR under the default Backup directory. You can export the contents of the OCR using below command (Logical backup).
 
ocrconfig -export /tmp/ocr_exp.dat -s online <<-- Logical Backup of OCR
 
Restoring OCR:
 
The below command is used to restore the OCR from the physical backup. Shutdown CRS on all nodes.
 
ocrconfig -restore <file name>
 
Locate the available Backups
 
[root@node1-pub ~]# ocrconfig -showbackup
node2-pub     2007/09/03 17:46:47     /u01/app/crs/cdata/test-crs/backup00.ocr
node2-pub     2007/09/03 13:46:45     /u01/app/crs/cdata/test-crs/backup01.ocr
node2-pub     2007/09/03 09:46:44     /u01/app/crs/cdata/test-crs/backup02.ocr
node2-pub     2007/09/03 01:46:39     /u01/app/crs/cdata/test-crs/day.ocr
node2-pub     2007/09/03 01:46:39     /u01/app/crs/cdata/test-crs/week.ocr
node1-pub     2007/10/07 13:50:41     /u01/app/crs/cdata/test-crs/backup_20071007_135041.ocr
 
Perform Restore from previous Backup
 
[root@node2-pub ~]# ocrconfig -restore /u01/app/crs/cdata/test-crs/week.ocr
 
The logical backup of OCR (taken using export option) can be imported using the below command.
 
ocrconfig -import /tmp/ocr_exp.dat
 
Restoring Votedisks:
 
·         Shutdown CRS on all the nodes in Cluster.
·         Locate the current location of the Votedisks
·         Restore each of the votedisks using "dd" command from the previous good backup of Votedisk taken using the same "dd" command.
·         Start CRS on all the nodes.
 
crsctl stop crs
crsctl query css votedisk
dd if=<backup of Votedisk> of=<Votedisk file> <<-- do this for all the votedisks
crsctl start crs
 
Changing Public and Virtual IP Address:
 
 
 
 
Current Config                                               Changed to
 
Node 1:
 
Public IP:       216.160.37.154                              192.168.10.11
VIP:             216.160.37.153                              192.168.10.111
subnet:          216.160.37.159                              192.168.10.0
Netmask:         255.255.255.248                             255.255.255.0
Interface used:  eth0                                        eth0
Hostname:        node1-pub.hingu.net                         node1-pub.hingu.net
 
Node 2:
 
Public IP:       216.160.37.156                              192.168.10.22
VIP:             216.160.37.157                              192.168.10.222
subnet:          216.160.37.159                              192.168.10.0
Netmask:         255.255.255.248                             255.255.255.0
Interface used:  eth0                                        eth0
Hostname:        node1-pub.hingu.net                         node2-pub.hingu.net
 
 
(A)   Take the Services, Database, ASM Instances and nodeapps down on both the Nodes in Cluster. Also disable the nodeapps, asm and database instances to prevent them from restarting in case if this node gets rebooted during this process.
 
srvctl stop service -d test
srvctl stop database -d test
srvctl stop asm -n node1-pub
srvctl stop asm -n node2-pub
srvctl stop nodeapps -n node1-pub,node1-pub2
srvctl disable instance -d test -i test1,test2
srvctl disable asm -n node1-pub
srvctl disable asm -n node2-pub
srvctl disable nodeapps -n node1-pub
srvctl disable nodeapps -n node2-pub
 
 
(B)   Modify the /etc/hosts and/or DNS, ifcfg-eth0 (local node) with the new IP values on All the Nodes
 
(C)   Restart the specific network interface in order to use the new IP.
 
ifconfig eth0 down
ifconfig eth0 up
 
Or, you can restart the network. CAUTION: on NAS, restarting entire network may cause the node to be rebooted.
 
(D)   Update the OCR with the New Public IP information. 
        In case of public IP, you have to delete the interface first and then add it back with the new IP address. As oracle user, Issue the below command:
 
oifcfg delif -global eth0
oifcfg setif -global eth0/192.168.10.0:public
 
(E)    Update the OCR with the New Virtual IP.
 
        Virtual IP is part of the nodeapps and so you can modify the nodeapps to update the Virtual IP information. As privileged user (root), Issue the below commands:
 
srvctl modify nodeapps -n node1-pub -A 192.168.10.111/255.255.255.0/eth0 <-- for Node 1
srvctl modify nodeapps -n node1-pub -A 192.168.10.222/255.255.255.0/eth0 <-- for Node 2
 
(F)    Enable the nodeapps, ASM, database Instances for all the Nodes.
 
srvctl enable instance -d test -i test1,test2
srvctl enable asm -n node1-pub
srvctl enable asm -n node2-pub
srvctl enable nodeapps -n node1-pub
srvctl enable nodeapps -n node2-pub
 
(G)  Update the listener.ora file on each nodes with the correct IP addresses in case if it uses the IP address instead of the hostname.
 
(H)    Restart the Nodeapps, ASM and Database instance
 
srvctl start nodeapps -n node1-pub
srvctl start nodeapps -n node2-pub
srvctl start asm -n node1-pub
srvctl start asm -n node2-pub
srvctl start database -d test