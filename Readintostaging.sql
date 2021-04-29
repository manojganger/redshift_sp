--/
CREATE or replace PROCEDURE readintostaging (thread_Id integer, start_id integer, end_id integer) 
AS $$
DECLARE
  out_var varchar(5000);
  rec RECORD;
  integer_var integer;
  integer_var1 integer;
  
BEGIN
  
  for rec in SELECT sqlid, fullsql from sqlstmts where threadId = thread_id and sqlid >= start_id and sqlid <= end_id order by sqlid asc
  loop
  RAISE NOTICE 'Executing sqlstep %', rec.sqlid;
  EXECUTE rec.fullsql;
  
  GET DIAGNOSTICS integer_var := ROW_COUNT;
  RAISE NOTICE 'rows affected is %', integer_var;
  end loop;
  
  

END;
$$
 LANGUAGE plpgsql
/
