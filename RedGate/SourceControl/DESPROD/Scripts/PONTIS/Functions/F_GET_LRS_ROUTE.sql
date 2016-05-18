CREATE OR REPLACE function pontis.f_get_lrs_route(v_brkey roadway.brkey%type)

return varchar2 is
retval_lrs varchar2(12) := '0';
type tab_varchar4 IS TABLE OF varchar2(4)     INDEX BY binary_integer;
l_tab_type tab_varchar4;
v_orient char(1);

BEGIN

select orientation into
v_orient
from userbrdg u
where u.brkey = v_brkey;

if v_orient = '1' then
  
select  lrsinvrt||subrtnum
 into retval_lrs
 from roadway r
 where r.brkey = v_brkey and
 r.on_under = '1';
 
elsif v_orient = '2' then
select  distinct lrsinvrt||subrtnum
 into retval_lrs
 from roadway r
 where r.brkey = v_brkey and
 r.on_under <> '1' and
 lrsinvrt is not null;
 
End IF;
 
 
return retval_lrs;
exception when others then
retval_lrs:= -1;
return retval_lrs;

END f_get_lrs_route;

 
/