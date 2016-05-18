CREATE OR REPLACE function pontis.f_check_nbi_28a_on(v_brkey bridge.brkey%type)

return number is
 
retval number;
v_orientation userbrdg.orientation%type;
v_function_type userbrdg.function_type%type;
begin
  
select function_type
into v_function_type
from userbrdg u
where u.brkey = v_brkey;

if -- v_orientation in ('2','3') and
   v_function_type not in ('10','30','50','51','70' )then -- inventory route is under the structure
 retval := 0;

ELSE

select totlanes
into retval
from userrway u
where u.brkey = v_brkey and
      u.on_under = '1';

end if;
RETURN RETVAL;


END f_check_nbi_28a_on;

 
/