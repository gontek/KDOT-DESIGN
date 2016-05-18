CREATE OR REPLACE function pontis.f_check_nbi_28a_on_test(v_brkey bridge.brkey%type)

return number is
 
retval number;
v_function userbrdg.function_type%type;

begin
  
select function_type
into v_function
from userbrdg u
where u.brkey = v_brkey;

if v_function in ('4','90','98','99') then -- inventory route is under the structure
 retval := 0;

ELSE

select totlanes
into retval
from userrway u
where u.brkey = v_brkey and
      u.on_under = '1';

end if;
return retval;

END f_check_nbi_28a_on_test;

 
/