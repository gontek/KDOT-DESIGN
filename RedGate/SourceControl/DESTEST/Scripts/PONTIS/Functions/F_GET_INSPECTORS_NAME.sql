CREATE OR REPLACE function pontis.f_get_inspectors_name(v_userkey users.userkey%type)

 return varchar2 is
  Result varchar2(35);

begin

select substr(first_name,1,1)||'. '||last_name into result
from users u
where u.userkey = v_userkey;
return result;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    result := '_';
 return result;

end f_get_inspectors_name;

 
/