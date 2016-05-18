CREATE OR REPLACE function pontis.f_get_broms_meaning(p_rv_domain in varchar2, p_value in varchar2)

 return varchar2 as
  Result varchar2(1000);

begin

select trim(rv_meaning) into result
from broms_codes_list p
where upper(p.rv_domain) = upper(p_rv_domain)
    and p.rv_low_value  = p_value  ;
return result;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    result := '_';
 return result;

end f_get_broms_meaning;

 
/