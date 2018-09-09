Enterprise Manager Express 12c
------------------------------
exec dbms_xdb_config.sethttpsport (5500);
select dbms_xdb_config.gethttpsport () from dual;
