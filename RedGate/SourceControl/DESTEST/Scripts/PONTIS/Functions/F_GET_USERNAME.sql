CREATE OR REPLACE function pontis.f_get_username
return varchar2 is
  retval varchar2(2000);

begin

select sys_context('userenv','os_user')
into retval
from dual;

  return retval;
end f_get_username;

 
/