CREATE OR REPLACE function pontis.f_check_nbi_28a_undr(v_brkey bridge.brkey%type)

return number is
 
retval number ;
v_orientation userbrdg.orientation%type;
v_function_type userbrdg.function_type%type;

begin
  
select orientation, function_type
into v_orientation, v_function_type
from userbrdg u
where u.brkey = v_brkey;


IF
   v_function_type  not in ('4','90','98','99') then -- pedestrian, railroad, or other should be '0'.

select totlanes
into retval
from userrway u
where u.brkey = v_brkey and
 u.on_under = '1'
;

ELSE

retval := 0;



end if;
return retval;

END f_check_nbi_28a_undr;

 
/