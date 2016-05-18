CREATE OR REPLACE function pontis.f_get_kta_no(v_brkey userbrdg.brkey%type)
return varchar2 is
  retval varchar2(30);

begin

select 'KTA No:  '||NVL(kta_no,'0')||'  '||kta_id
into retval
from userbrdg
where brkey = v_brkey;



return retval;
end f_get_kta_no;

 
/