CREATE OR REPLACE function pontis.f_check_nbi_47_undr(v_brkey userrway.brkey%type)

--this is a function that returns/updates NBI fields 47 for under records
--use query checks to audit Pontis fields

return number is
retval number(5,3):=0;

l_item47_undr number(5,3);      -- NBI 47 horizontal clearance
v_hclr_n userrway.hclr_n%type;
v_hclr_s userrway.hclr_n%type;
v_hclr_e userrway.hclr_n%type;
v_hclr_w userrway.hclr_n%type;


BEGIN

select trunc(min(nvl(u.hclr_n,99.9)),3)
into v_hclr_n-- min horizontal clearance
from userrway u
where u.brkey = v_brkey and
      feat_cross_type in ('10','30','50','51')
     ;
 
select trunc(min(nvl(u.hclr_s,99.9)),3)
into v_hclr_s-- min horizontal clearance
from userrway u
where u.brkey = v_brkey and
      feat_cross_type in ('10','30','50','51')
     ;
select trunc(min(nvl(u.hclr_e,99.9)),3)
into v_hclr_e-- min horizontal clearance
from userrway u
where u.brkey = v_brkey and
      feat_cross_type in ('10','30','50','51')
     ;
select trunc(min(nvl(u.hclr_w,99.9)),3)
into v_hclr_w-- min horizontal clearance
from userrway u
where u.brkey = v_brkey and
      feat_cross_type in ('10','30','50','51')
     ;
l_item47_undr := least(v_hclr_n,v_hclr_s,v_hclr_e,v_hclr_w);

If l_item47_undr = 99.9 THEN
   retval:= 0;
 ELSE

  retval:= round(l_item47_undr,3);
END IF;


RETURN retval;


EXCEPTION WHEN NO_DATA_FOUND THEN
   retval := 0;
 RETURN retval;
END f_check_nbi_47_undr;

 
/