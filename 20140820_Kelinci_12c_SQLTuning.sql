EXPLAIN PLAN FOR SELECT CITY FROM LOCATIONS UNION SELECT COUNTRY_NAME FROM COUNTRIES

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 3898370564
 
---------------------------------------------------------------------------------
| Id  | Operation           | Name      | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------
|   0 | SELECT STATEMENT    |           |    48 |   432 |     6  (50)| 00:00:01 |
|   1 |  SORT UNIQUE        |           |    48 |   432 |     6  (50)| 00:00:01 |
|   2 |   UNION-ALL         |           |       |       |            |          |
|   3 |    TABLE ACCESS FULL| LOCATIONS |    23 |   207 |     3   (0)| 00:00:01 |
|   4 |    TABLE ACCESS FULL| COUNTRIES |    25 |   225 |     3   (0)| 00:00:01 |
---------------------------------------------------------------------------------

EXPLAIN PLAN FOR SELECT CITY FROM LOCATIONS UNION ALL SELECT COUNTRY_NAME FROM COUNTRIES

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 660862635
 
--------------------------------------------------------------------------------
| Id  | Operation          | Name      | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |           |    48 |   432 |     6  (50)| 00:00:01 |
|   1 |  UNION-ALL         |           |       |       |            |          |
|   2 |   TABLE ACCESS FULL| LOCATIONS |    23 |   207 |     3   (0)| 00:00:01 |
|   3 |   TABLE ACCESS FULL| COUNTRIES |    25 |   225 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------------

EXPLAIN PLAN FOR
SELECT COUNT(CASE WHEN SALARY>=10000 AND SALARY<=14000 THEN 1 ELSE NULL END)JML FROM EMPLOYEES

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 1756381138
 
--------------------------------------------------------------------------------
| Id  | Operation          | Name      | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |           |     1 |     4 |     3   (0)| 00:00:01 |
|   1 |  SORT AGGREGATE    |           |     1 |     4 |            |          |
|   2 |   TABLE ACCESS FULL| EMPLOYEES |   107 |   428 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------------

EXPLAIN PLAN FOR
SELECT COUNT(1)JML FROM EMPLOYEES WHERE SALARY>=10000 AND SALARY<=14000

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 1756381138
 
--------------------------------------------------------------------------------
| Id  | Operation          | Name      | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |           |     1 |     4 |     3   (0)| 00:00:01 |
|   1 |  SORT AGGREGATE    |           |     1 |     4 |            |          |
|*  2 |   TABLE ACCESS FULL| EMPLOYEES |    23 |    92 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - filter("SALARY"<=14000 AND "SALARY">=10000)

EXPLAIN PLAN FOR
SELECT * FROM EMPLOYEES WHERE SALARY=(SELECT MAX(SALARY) FROM EMPLOYEES) AND DEPARTMENT_ID=(SELECT MAX(DEPARTMENT_ID) FROM EMPLOYEES)

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 1656627191
 
---------------------------------------------------------------------------------
| Id  | Operation           | Name      | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------
|   0 | SELECT STATEMENT    |           |     1 |    69 |     9   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL  | EMPLOYEES |     1 |    69 |     3   (0)| 00:00:01 |
|   2 |   SORT AGGREGATE    |           |     1 |     4 |            |          |
|   3 |    TABLE ACCESS FULL| EMPLOYEES |   107 |   428 |     3   (0)| 00:00:01 |
|   4 |   SORT AGGREGATE    |           |     1 |     3 |            |          |
|   5 |    TABLE ACCESS FULL| EMPLOYEES |   107 |   321 |     3   (0)| 00:00:01 |
---------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("SALARY"= (SELECT MAX("SALARY") FROM "EMPLOYEES" 
              "EMPLOYEES") AND "DEPARTMENT_ID"= (SELECT MAX("DEPARTMENT_ID") FROM 
              "EMPLOYEES" "EMPLOYEES"))

EXPLAIN PLAN FOR
SELECT * FROM EMPLOYEES WHERE (SALARY, DEPARTMENT_ID)=(SELECT MAX(SALARY), MAX(DEPARTMENT_ID) FROM EMPLOYEES)

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 1945967906
 
---------------------------------------------------------------------------------
| Id  | Operation           | Name      | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------
|   0 | SELECT STATEMENT    |           |     1 |    69 |     9   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL  | EMPLOYEES |     1 |    69 |     3   (0)| 00:00:01 |
|   2 |   SORT AGGREGATE    |           |     1 |     7 |            |          |
|   3 |    TABLE ACCESS FULL| EMPLOYEES |   107 |   749 |     3   (0)| 00:00:01 |
---------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter(("SALARY","DEPARTMENT_ID")= (SELECT 
              MAX("SALARY"),MAX("DEPARTMENT_ID") FROM "EMPLOYEES" "EMPLOYEES"))

EXPLAIN PLAN FOR
SELECT * FROM JOBS WHERE JOB_TITLE='Purchasing Clerk' OR JOB_TITLE='Programmer' OR JOB_TITLE='Public Relations Representative'

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 944056911
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     3 |    99 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| JOBS |     3 |    99 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("JOB_TITLE"='Programmer' OR "JOB_TITLE"='Public Relations 
              Representative' OR "JOB_TITLE"='Purchasing Clerk')

EXPLAIN PLAN FOR
SELECT * FROM JOBS WHERE JOB_TITLE IN('Purchasing Clerk', 'Programmer', 'Public Relations Representative')

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 944056911
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     3 |    99 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| JOBS |     3 |    99 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("JOB_TITLE"='Programmer' OR "JOB_TITLE"='Public Relations 
              Representative' OR "JOB_TITLE"='Purchasing Clerk')