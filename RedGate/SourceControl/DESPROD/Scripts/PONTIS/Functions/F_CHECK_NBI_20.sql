CREATE OR REPLACE function pontis.f_check_nbi_20(v_brkey userrway.brkey%type)
return varchar2 is
  retval varchar2(1);
  
begin
  
select DECODE(u.toll_kdot,'0','3','1','2','2','1','3','4','4','5','3')
into retval
from userrway u
where brkey = v_brkey and
      u.on_under = '1';
  
        
  return retval;
end f_check_nbi_20;

 
/