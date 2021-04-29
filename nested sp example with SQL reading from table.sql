--this procedure calls a nested procedure test1 with the variable as argument (not constant as test variable is defined as INOUT

--note thevarchar(256)
--the $$ is replace by '
-- the inner ' is escaped with \ (a pain but there seems to be no other way.
-- $$ is stored internally by redshift so when scripted out, it becomes $$

CREATE OR REPLACE PROCEDURE test_sp5(f1 IN int, f2 INOUT varchar(256), out_var OUT varchar(256))
AS '
DECLARE
  loop_var int;
  x int := 3;
  y int := 4;
BEGIN
  IF f1 is null OR f2 is null THEN
    RAISE EXCEPTION \'input cannot be null\';
  END IF;
  DROP TABLE if exists my_etl;
  CREATE TEMP TABLE my_etl(a int, b varchar);
    FOR loop_var IN 1..f1 LOOP
        insert into my_etl values (loop_var, f2);
        f2 := f2 || \'+\' || f2;
    END LOOP;
  SELECT INTO out_var count(*) from my_etl;
  EXECUTE \'SELECT count(*) from my_etl\';
  call test1(x);
  RAISE NOTICE \'Value here is %\', x;
  RAISE NOTICE \'cnt is here is %\', out_var;
END;
' LANGUAGE plpgsql;

call test_sp5(2,'2019')