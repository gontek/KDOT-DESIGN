CREATE OR REPLACE function pontis.f_num_girders_main(v_brkey userstrunit.brkey%type)
return varchar2 is
  retval number;
  
begin
  
select (nvl(num_girders,0))+ (nvl(wide_num_girders,0))into retval
from userstrunit us, structure_unit s
WHERE  us.brkey = v_brkey and
        s.brkey = v_brkey and
       us.strunitkey = s.strunitkey and
        s.strunittype = '1';


  
        
return retval;
end f_num_girders_main;

 
/