CREATE OR REPLACE function pontis.f_structuretype_main(v_brkey pontis.userstrunit.brkey%type)
return varchar2 is
  retval varchar2(4);
begin


select  f_structuretype(us.brkey, us.strunitkey)
into retval
from userstrunit us, structure_unit s
WHERE  us.brkey = v_brkey and
        s.brkey = v_brkey and
       us.strunitkey = s.strunitkey and
        s.strunittype = '1';




return retval;
end f_structuretype_main;

 
/