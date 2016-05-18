CREATE OR REPLACE function pontis.f_get_totalspanslength(v_brkey userstrunit.brkey%type) return number is
  retval number;


begin


select sum(length)
into retval
from userstrunit u
where u.brkey = v_brkey;

return retval;




end f_get_totalspanslength;

 
/