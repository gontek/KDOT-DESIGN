CREATE OR REPLACE function pontis.f_latest_major_constr(v_brkey bridge.brkey%type)

return number is
 retval number;
begin
 
select
       max(extract(year from actvtydate))
       into retval
from v_bif_capital_prj v
where v.brkey = v_brkey and
v.actvtyid in ('13','15','40') ;

return retval; 

end f_latest_major_constr;

 
/