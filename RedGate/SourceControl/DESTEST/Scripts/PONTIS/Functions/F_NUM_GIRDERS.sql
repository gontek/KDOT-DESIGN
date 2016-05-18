CREATE OR REPLACE function pontis.f_num_girders(v_brkey userstrunit.brkey%type)
return varchar2 is
  retval number;
  
begin
  
select sum((nvl(num_girders,0))+ (nvl(wide_num_girders,0)))into retval
from userstrunit
where brkey = v_brkey
group by brkey;

  
        
return retval;
end f_num_girders;

 
/