CREATE OR REPLACE function pontis.f_get_totalgirders(v_brkey userstrunit.brkey%type) return number is
  retval number;


begin


select sum(nvl(num_girders,0))
into retval
from userstrunit u
where u.brkey = v_brkey;

return retval;




end f_get_totalgirders;

 
/