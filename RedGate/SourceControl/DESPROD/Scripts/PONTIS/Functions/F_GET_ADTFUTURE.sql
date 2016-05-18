CREATE OR REPLACE function pontis.f_get_adtfuture(v_brkey roadway.brkey%TYPE,v_adtyear roadway.adtyear%type) 
  RETURN number IS
   retval roadway.adtfuture%type;
  
begin
  
select round(adttotal*(NVL(POWER(adt_expan_fctr,20),0)))
into retval
from userrway u, roadway r
where r.brkey = v_brkey and
      u.brkey = r.brkey and
r.on_under = u.on_under and
      u.on_under = '1' and
      r.adtyear = v_adtyear;
  
        
  return retval;
end f_get_adtfuture;
 

 
/