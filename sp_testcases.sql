--/
CREATE or replace PROCEDURE sp_testcase (isrl integer) 
AS $$
DECLARE
  out_var varchar(5000);
  rec RECORD;
   rec1 RECORD;
  outrec RECORD;
  integer_var integer;
  exesql varchar(255);
  
  
BEGIN
  /*
        get all the rows for that and get the sql to test. store the results in actual
        compare with the expected results
        if same assert as T else F
  */
  
        select into rec tags,array_of_keys,expected,testsql,actual,assert from testcases 
                where srl>=isrl;
  RAISE NOTICE 'Executing srl %', isrl;
        RAISE NOTICE 'Executing sqlstep %', rec.testsql;
        RAISE NOTICE 'Executing sqlstep %', rec.tags;
        exesql = rec.testsql;
        RAISE NOTICE 'Expecting....%', rec.expected;
         
        for rec1 in EXECUTE exesql loop
        RAISE NOTICE 'And Got....%', rec1.revised_product_series;
                --compare the output with the json expected results
                --get the count and amt.
        end loop;
        
  
        --GET DIAGNOSTICS integer_var := ROW_COUNT;
    --    RAISE NOTICE 'rows affected is %', integer_var;
  --end loop;
  
END;
$$
 LANGUAGE plpgsql
/
