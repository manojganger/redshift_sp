--/
CREATE or replace PROCEDURE sp_forEachRecordExecuteThisSQL () 
AS $$
DECLARE
  out_var varchar(5000);
  rec2 RECORD;
   rec1 RECORD;
  outrec RECORD;
  integer_var integer;
  exesql varchar(255);
  
  
BEGIN
  
        for rec1 in EXECUTE 'select tags,array_of_keys,expected,testsql,actual,assert from testcases where srl>=5'  loop
                RAISE NOTICE 'Executing srl %', rec1.testsql;
        
           EXECUTE rec1.testsql into rec2 ; 
                        RAISE NOTICE 'And Got....%', rec2.revised_product_series;
                --compare the output with the json expected results
                --get the count and amt.
               -- end loop;
        
        end loop;
        
        
                
  
         
        
        
  
        --GET DIAGNOSTICS integer_var := ROW_COUNT;
    --    RAISE NOTICE 'rows affected is %', integer_var;
  --end loop;
  
END;
$$
 LANGUAGE plpgsql
/
