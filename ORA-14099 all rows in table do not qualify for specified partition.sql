ORA-14099: all rows in table do not qualify for specified partition

CREATE TABLE TMP46
(
   id      INTEGER,
   num     INTEGER,
   name1   VARCHAR (2)
)
PARTITION BY LIST (name1)
   (PARTITION P1
       VALUES ('A', 'B', 'C'),
    PARTITION P2
       VALUES ('D', 'E', 'F'));

SELECT * FROM scott.TMP46;

CREATE TABLE swap46
(
   id      INTEGER,
   num     INTEGER,
   name1   VARCHAR (2)
);

INSERT INTO swap46 (name1) VALUES ('A');
COMMIT;
SELECT * FROM SWAP46;

alter table TMP46 exchange partition P2 with table swap46;

ANALYZE TABLE TMP46 VALIDATE STRUCTURE CASCADE ONLINE;

ANALYZE TABLE SWAP VALIDATE STRUCTURE CASCADE ONLINE;

alter table TMP46 exchange partition P1 with table swap46;