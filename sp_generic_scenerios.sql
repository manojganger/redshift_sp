--/
CREATE or replace PROCEDURE generic_scenerios (filterclause varchar(1000), nbr integer, exactormore varchar (1)) 
AS $$
DECLARE
  out_var varchar(5000);
  rec RECORD;
  integer_var integer;
  rps_rec RECORD;
  
BEGIN
       
        
        select into rps_rec revised_product_series from scenerio where nbr = nbr and product_series = 'COMMON-ACCESS';
        RAISE NOTICE 'revised product series will be : %', rps_rec.revised_product_series;
        

        select 'DROP TABLE if exists TM001_ess;' into out_var;
        RAISE NOTICE 'sqlstmt %', out_var;
        EXECUTE out_var;


        select 'CREATE TEMP TABLE TM001_ess as select distinct created_from from booking_target_enh3 b where '||filterclause||';' into out_var;
        RAISE NOTICE 'sqlstmt %', out_var;
        EXECUTE out_var;
        
        select 'drop table if exists tm100;' into out_var;
        RAISE NOTICE 'sqlstmt %', out_var;
        EXECUTE out_var;
        
        select 'create table TM100 as
                        select created_from, b.product_series, count(1) over (partition by created_from)
                        from booking_target_enh3 b 
                        group by created_from, b.product_series;' into out_var;
        RAISE NOTICE 'sqlstmt %', out_var;
        EXECUTE out_var;
        
        select 'drop table if exists tm100_02;' into out_var;
        RAISE NOTICE 'sqlstmt %', out_var;
        EXECUTE out_var;
        
        select 'create table tm100_02 as 
                        select distinct created_from from (
                                select t.created_from, t.product_series, revised_product_series, t.count tmcnt, count(1) over (partition by t.created_from) scnt 
                                        from tm100 t join scenerio s on t.product_series = s.product_series 
                                        join TM001_ess ess on ess.created_from = t.created_from
                                                where nbr = '|| cast(nbr as varchar) ||
                                                ' group by t.created_from, t.product_series,revised_product_series, t.count) as f     
                                where f.scnt '|| decode(exactormore, 'T', '=', '<=')||' f.tmcnt  --for any other value in product series for exact remove the < sign
                                and f.scnt = (select count(1) from scenerio where nbr = '||cast(nbr as varchar)||');'   into out_var;
        RAISE NOTICE 'sqlstmt %', out_var;
        EXECUTE out_var;
        
        select 'update booking_target_enh3 set revised_product_series = '||quote_literal(rps_rec.revised_product_series)||'
                from booking_target_enh3  b
                join tm100_02 c
                        on b.created_from = c.created_from 
                where b.product_series = ''COMMON-ACCESS''
                        and b.revised_product_series = ''XXXXXXXXXXXXXXXXXXXX'';'  into out_var;
                                 
        RAISE NOTICE 'sqlstmt %', out_var;
        EXECUTE out_var;
        
        
/*


update booking_target_enh3 set revised_product_series = 'TOUCHED'
from booking_target_enh3  b
join tm100_02 c
on b.created_from = c.created_from and b.product_series = c.product_series;
where b.product_series = 'COMMON-ACCESS'
and c.revised_product_series = 'XXXXXXXXXXXXXXXXXXXX'


  
  for rec in SELECT sqlid, fullsql from sqlstmts where threadId = thread_id and sqlid >= start_id and sqlid <= end_id order by sqlid asc
  loop
  RAISE NOTICE 'Executing sqlstep %', rec.sqlid;
  EXECUTE rec.fullsql;
  
  GET DIAGNOSTICS integer_var := ROW_COUNT;
  RAISE NOTICE 'rows affected is %', integer_var;
  end loop;
*/  
  

END;
$$
 LANGUAGE plpgsql
/
