[oracle@exaxdb03 ~]$ crsctl stat res -t
--------------------------------------------------------------------------------
NAME           TARGET  STATE        SERVER                   STATE_DETAILS
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.LISTENER.lsnr
               ONLINE  ONLINE       exaxdb01
               ONLINE  ONLINE       exaxdb02
               ONLINE  ONLINE       exaxdb03
               ONLINE  ONLINE       exaxdb04
               ONLINE  ONLINE       exaxdb05
               ONLINE  INTERMEDIATE exaxdb06                 CHECK TIMED OUT
               ONLINE  ONLINE       exaxdb07
               ONLINE  ONLINE       exaxdb08
               ONLINE  ONLINE       exaxdb09
               ONLINE  ONLINE       exaxdb10
[oracle@exaxdb03 ~]$ crsctl check resource ora.LISTENER.lsnr
[oracle@exaxdb03 ~]$ crsctl stat res ora.LISTENER.lsnr -t