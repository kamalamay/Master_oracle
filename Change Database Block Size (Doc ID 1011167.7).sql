How to Change Database Block Size (Doc ID 1011167.7)	To BottomTo Bottom	


***Checked for relevance on 16-Jan-2012***

PURPOSE  
  This bulletin describes how to change the blocksize of an Oracle database.

SCOPE & APPLICATION
  For users requiring to change the database default blocksize.



How to Change Database Block Size
=================================

Often, to improve performance, the database needs to be recreated with a larger
block size.  In addition prior to 7.3, an objects maximum number of extents was
determined by the blocksize. Thus with a blocksize of 2048 the maximum number 
of extents was 121. From 7.3, this restriction was lifted and objects could 
have an unlimited number of extents.

In order to increase blocksize, the database must be recreated.

The database default block size is set when a database is created and cannot be 
changed throughout the life of the database.  It follows, therefore, that you must 
recreate a database if you wish to change the default block size.   
 
The block size used at database creation is taken from the initialization 
parameter DB_BLOCK_SIZE.  You should check your Operating System Specific 
Documentation for the valid settings of this parameter for you machine. 

NOTE:
Starting with Oracle Database 10g Release 1 (10.1), the default value of 
DB_BLOCK_SIZE is operating system specific, but is typically 8 KB (8192 bytes). 
In previous Oracle Database releases, the default value was 2 KB (2048 bytes).

 
BACKUP FIRST 
------------
 
Before attempting to change the block size it is essential that you have a 
full and up-to-date backup of your existing database so that you can recover 
if necessary.   
 
 
DATA TRANSFER METHOD 
--------------------
 
Before you start, you must also decide on a strategy for transferring your 
existing data into the new database.  Here are some possible options: 
 
1. Perform a full export of your existing database and then a full import into 
   the new database.  This is probably the simplest option. 
 
2. Dump your data to flat files using SQL*Plus and then use SQL*Loader to 
   restore the data into your new database.  (This may be used in conjunction 
   with option 1). 
 
3. Retain the existing database and use database links to transfer the data.  
   This will require that you create a new instance as well as a new database. 
 
4. Develop PRO*C, PRO*Cobol, etc. applications to unload and reload you data. 
 
Note, it is not possible to introduce your existing database files into the 
new database.  Data has to be extracted at the logical level and reloaded into 
the new database. 

NOTE:
With 9iR, variable cache size has been added which are implemented using the
db_nk_cache size parameters (Note 151056.1).
This can be used to transport tablespaces with a different blocksize between 
databases (Note 1166564.1). As of 10gR1, tablespaces can also be 
transported between platforms (Note 243304.1).
 
 
PROCEDURE 
---------
 
Once you have decided upon your transfer method and taken your database 
backup, the process of changing your block size should proceed as follows: 
 
1. Perform data extraction from existing database as per data transfer method. 
 
2. If you do not intend to keep it, shutdown and delete existing database. 
 
3. Change DB_BLOCK_SIZE in initialization parameter file.  This will be a new 
   file if the existing database is to be kept. 
 
4. Create new database. 
 
5. Reload data into new database as per transfer method.


To recreate the database with a different block size using export/import
transfer method, use the following example:

1. Take a full cold backup of your database.   This is your guarantee
   that you can come back to your original setting in case you need to.

2. Take a full export of your database.

3. Delete your database files excluding init<sid>.ora at the OS level.

4. In the INIT<SID>.ORA change the parameter db_block_size to your 
   required size. 

db_block_size = 8192 
# size in bytes.   The value you specify is OS specific and must be 
# a multiple of Operating System's block size.   Please check your 
# operating system specific Installation and Configuration Guide.   
# Also look at Note:34020.1 for guidelines on sizing db_block_size

5. Ensure all operating system environment variables are correct. 
   Especially the ORACLE_HOME, ORACLE_SID. Ensure the init<SID>.ora 
   file can be found.   Refer to your OS specific Installation and 
   Configuration Guide for details.

6. Recreate the database.  

7. Import the database using the Export file generated in step 2;
 
Using the above steps you will be able to increase the block size of the 
database. This helps improve db performance with OLTP (in collaboration with 
other tuning measures).  There is no other alternate method of changing the 
block size without rebuilding the database.


RELATED DOCUMENTS
-----------------

Note:30709.1  Parameter: Init.ora: DB_BLOCK_SIZE
Note:61949.1  Overview of Export/Import in Oracle7
Note:34020.1  Guidelines for DB_BLOCK_SIZE


ADDITIONAL SEARCH WORDS
-----------------------

db_block_size recreate export import create tuning performance
