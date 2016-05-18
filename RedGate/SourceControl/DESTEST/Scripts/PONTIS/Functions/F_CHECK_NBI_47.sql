CREATE OR REPLACE function pontis.f_check_nbi_47(v_brkey userrway.brkey%type,v_on_under userrway.on_under%type)
--this is a function that returns/updates NBI field 47 for on records
--used to audit roadway.hclrinv

return varchar2 is
retval varchar2(15);


l_rd52 varchar2(15);

l_item47_on varchar2(15);
l_item47_un varchar2(15);
      -- NBI 47 horizontal clearance

BEGIN

if (v_on_under = '1') then

  select to_char(round(decode(r.roadwidth,-1,0,'',0,r.roadwidth),3))
  into l_rd52
  from roadway r
  where r.brkey = v_brkey and
      r.on_under = v_on_under ;

If to_number(l_rd52)>30.45 THEN
   l_item47_on:=to_char(99.9);
   ELSE
   l_item47_on:=l_rd52;
 
   retval:=l_item47_on||'-'||v_on_under;


end if;

ELSiF (v_on_under <> '1') then

select to_char(round(least(nvl(u.hclr_n,99.9),nvl(u.hclr_s,99.9),nvl(u.hclr_e,99.9),nvl(u.hclr_w,99.9)) ,3))
into l_item47_un-- min horizontal clearance
from userrway u
where u.brkey = v_brkey and
      u.on_under = v_on_under and
      feat_cross_type in ('10','30','50','51') ;

If l_item47_un = '99.9' THEN
   l_item47_un := '0'; 
else
 retval:= l_item47_un||'-'||v_on_under;
  
END IF;

END IF;

return retval;


EXCEPTION WHEN NO_DATA_FOUND THEN
   retval := '0';
 RETURN retval;
END f_check_nbi_47;

 
/