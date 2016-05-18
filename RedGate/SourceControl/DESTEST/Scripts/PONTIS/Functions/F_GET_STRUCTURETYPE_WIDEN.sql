CREATE OR REPLACE function pontis.f_get_structuretype_widen(v_brkey pontis.userstrunit.brkey%type,v_strunitkey pontis.userstrunit.strunitkey%type)
return varchar2 is
  retval varchar2(4);
begin


select  f_get_paramtrs_equiv_long('userstrunit','unit_material',us.wide_material)||
        f_get_paramtrs_equiv_long('userstrunit','unit_type',us.wide_type)||
        f_get_paramtrs_equiv_long('userstrunit','super_design_ty',us.wide_design_ty)
into retval
from userstrunit us
WHERE  us.brkey = v_brkey and
       us.strunitkey = v_strunitkey;




return retval;
end f_get_structuretype_widen;

 
/