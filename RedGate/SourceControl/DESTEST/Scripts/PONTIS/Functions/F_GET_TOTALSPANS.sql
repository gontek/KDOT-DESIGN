CREATE OR REPLACE function pontis.f_get_totalspans(v_brkey userstrunit.brkey%type) return number is
  retval number;


begin


select sum(tot_num_spans)
into retval
from userstrunit u
where u.brkey = v_brkey;

return retval;




end f_get_totalspans;

 
/