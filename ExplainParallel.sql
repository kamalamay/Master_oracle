[oracle@exaxdb09 ~]$ . .profileDB_prd && sqlplus / as sysdba

SQL*Plus: Release 11.2.0.4.0 Production on Fri May 15 14:55:01 2015

Copyright (c) 1982, 2013, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.4.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> SET LINES 200 PAGES 5000 TIMING ON;
SQL> SHO PARAMETER CPU;

NAME				     TYPE	 VALUE
------------------------------------ ----------- ------------------------------
cpu_count			     integer	 32
parallel_threads_per_cpu	     integer	 1
resource_manager_cpu_allocation      integer	 32
SQL> SET AUTOTRACE ON EXPLAIN;
SQL> SELECT /*+PARALLEL(32)*/ COUNT(1)JML FROM SOR.R_PR_NON_ISAT;

       JML
----------
 191570246

Elapsed: 00:00:02.75

Execution Plan
----------------------------------------------------------
Plan hash value: 3098147980

-------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation		       | Name	       | Rows  | Cost (%CPU)| Time     | Pstart| Pstop |    TQ	|IN-OUT| PQ Distrib |
-------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT	       |	       |     1 |  4702	 (2)| 00:00:10 |       |       |	|      |	    |
|   1 |  SORT AGGREGATE 	       |	       |     1 |	    |	       |       |       |	|      |	    |
|   2 |   PX COORDINATOR	       |	       |       |	    |	       |       |       |	|      |	    |
|   3 |    PX SEND QC (RANDOM)	       | :TQ10000      |     1 |	    |	       |       |       |  Q1,00 | P->S | QC (RAND)  |
|   4 |     SORT AGGREGATE	       |	       |     1 |	    |	       |       |       |  Q1,00 | PCWP |	    |
|   5 |      PX BLOCK ITERATOR	       |	       |   526M|  4702	 (2)| 00:00:10 |     1 |     2 |  Q1,00 | PCWC |	    |
|   6 |       TABLE ACCESS STORAGE FULL| R_PR_NON_ISAT |   526M|  4702	 (2)| 00:00:10 |     1 |   244 |  Q1,00 | PCWP |	    |
-------------------------------------------------------------------------------------------------------------------------------------

Note
-----
   - dynamic sampling used for this statement (level=2)
   - Degree of Parallelism is 32 because of hint

SQL> SELECT /*+PARALLEL(64)*/ COUNT(1)JML FROM SOR.R_PR_NON_ISAT;

       JML
----------
 191570246

Elapsed: 00:00:01.38

Execution Plan
----------------------------------------------------------
Plan hash value: 3098147980

-------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation		       | Name	       | Rows  | Cost (%CPU)| Time     | Pstart| Pstop |    TQ	|IN-OUT| PQ Distrib |
-------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT	       |	       |     1 |  2351	 (2)| 00:00:05 |       |       |	|      |	    |
|   1 |  SORT AGGREGATE 	       |	       |     1 |	    |	       |       |       |	|      |	    |
|   2 |   PX COORDINATOR	       |	       |       |	    |	       |       |       |	|      |	    |
|   3 |    PX SEND QC (RANDOM)	       | :TQ10000      |     1 |	    |	       |       |       |  Q1,00 | P->S | QC (RAND)  |
|   4 |     SORT AGGREGATE	       |	       |     1 |	    |	       |       |       |  Q1,00 | PCWP |	    |
|   5 |      PX BLOCK ITERATOR	       |	       |   526M|  2351	 (2)| 00:00:05 |     1 |     2 |  Q1,00 | PCWC |	    |
|   6 |       TABLE ACCESS STORAGE FULL| R_PR_NON_ISAT |   526M|  2351	 (2)| 00:00:05 |     1 |   244 |  Q1,00 | PCWP |	    |
-------------------------------------------------------------------------------------------------------------------------------------

Note
-----
   - dynamic sampling used for this statement (level=2)
   - Degree of Parallelism is 64 because of hint

SQL> SELECT COUNT(1)JML FROM SOR.R_PR_NON_ISAT;

       JML
----------
 191570246

Elapsed: 00:00:01.35

Execution Plan
----------------------------------------------------------
Plan hash value: 3098147980

-------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation		       | Name	       | Rows  | Cost (%CPU)| Time     | Pstart| Pstop |    TQ	|IN-OUT| PQ Distrib |
-------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT	       |	       |     1 | 18808	 (2)| 00:03:46 |       |       |	|      |	    |
|   1 |  SORT AGGREGATE 	       |	       |     1 |	    |	       |       |       |	|      |	    |
|   2 |   PX COORDINATOR	       |	       |       |	    |	       |       |       |	|      |	    |
|   3 |    PX SEND QC (RANDOM)	       | :TQ10000      |     1 |	    |	       |       |       |  Q1,00 | P->S | QC (RAND)  |
|   4 |     SORT AGGREGATE	       |	       |     1 |	    |	       |       |       |  Q1,00 | PCWP |	    |
|   5 |      PX BLOCK ITERATOR	       |	       |   526M| 18808	 (2)| 00:03:46 |     1 |     2 |  Q1,00 | PCWC |	    |
|   6 |       TABLE ACCESS STORAGE FULL| R_PR_NON_ISAT |   526M| 18808	 (2)| 00:03:46 |     1 |   244 |  Q1,00 | PCWP |	    |
-------------------------------------------------------------------------------------------------------------------------------------

Note
-----
   - dynamic sampling used for this statement (level=2)

SQL> SET AUTOTRACE OFF;
SQL>
