CREATE TABLE HR.TOO_LITTLE_INFORMATION (
MY_TASK             VARCHAR2(100)
);

BEGIN
  FOR V_LP IN 1..1000000 LOOP
    INSERT INTO HR.TOO_LITTLE_INFORMATION
    VALUES ('I will provide more information when asking questions in the future.');
  END LOOP;
  COMMIT;
END;
