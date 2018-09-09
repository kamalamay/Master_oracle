[oracle@exaxdb18 ~]$ crsctl stat res ora.exaxdb08.vip -t
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.exaxdb08.vip
      1        ONLINE  INTERMEDIATE exaxdb05                 FAILED OVER
[oracle@exaxdb18 ~]$ crsctl check resource ora.exaxdb08.vip
[oracle@exaxdb18 ~]$ crsctl stat res ora.exaxdb08.vip -t
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.exaxdb08.vip
      1        ONLINE  INTERMEDIATE exaxdb05                 FAILED OVER
[oracle@exaxdb18 ~]$ ssh oracle@exaxdb08
ssh: connect to host exaxdb08 port 22: No route to host
[oracle@exaxdb18 ~]$ ping exaxdb08
PING exaxdb08.office.corp.indosat.com (10.128.57.67) 56(84) bytes of data.
From exaxdb18.office.corp.indosat.com (10.128.57.114) icmp_seq=2 Destination Host Unreachable
From exaxdb18.office.corp.indosat.com (10.128.57.114) icmp_seq=3 Destination Host Unreachable
From exaxdb18.office.corp.indosat.com (10.128.57.114) icmp_seq=4 Destination Host Unreachable
From exaxdb18.office.corp.indosat.com (10.128.57.114) icmp_seq=6 Destination Host Unreachable
From exaxdb18.office.corp.indosat.com (10.128.57.114) icmp_seq=7 Destination Host Unreachable
From exaxdb18.office.corp.indosat.com (10.128.57.114) icmp_seq=8 Destination Host Unreachable
^C
--- exaxdb08.office.corp.indosat.com ping statistics ---
9 packets transmitted, 0 received, +6 errors, 100% packet loss, time 8066ms
pipe 3
[oracle@exaxdb18 ~]$ 

[oracle@exaxdb05 ~]$ crsctl relocate resource ora.exaxdb08.vip -n exaxdb08 -f
CRS-2546: Server 'exaxdb08' is not online
CRS-4000: Command Relocate failed, or completed with errors.
[oracle@exaxdb05 ~]$

-bash-3.2$ crsctl relocate resource ora.scan2.vip -n lasrac02 -f

https://mewithoracle.wordpress.com/2012/07/17/managing-oracle-clusterware-11g-release-2-service-and-resources/
CRS-2673: Attempting to stop 'ora.LISTENER_SCAN2.lsnr' on 'lasrac01'
CRS-2677: Stop of 'ora.LISTENER_SCAN2.lsnr' on 'lasrac01' succeeded
CRS-2673: Attempting to stop 'ora.scan2.vip' on 'lasrac01'
CRS-2677: Stop of 'ora.scan2.vip' on 'lasrac01' succeeded
CRS-2672: Attempting to start 'ora.scan2.vip' on 'lasrac02'
CRS-2676: Start of 'ora.scan2.vip' on 'lasrac02' succeeded
CRS-2672: Attempting to start 'ora.LISTENER_SCAN2.lsnr' on 'lasrac02'
CRS-2676: Start of 'ora.LISTENER_SCAN2.lsnr' on 'lasrac02' succeeded