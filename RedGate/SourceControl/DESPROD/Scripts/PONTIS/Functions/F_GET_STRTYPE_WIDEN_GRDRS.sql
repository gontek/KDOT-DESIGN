CREATE OR REPLACE function pontis.f_get_strtype_widen_grdrs(v_brkey pontis.userstrunit.brkey%type,v_strunitkey pontis.userstrunit.strunitkey%type)
return varchar2 is
  retval varchar2(20);
begin


select  f_get_paramtrs_equiv_long('userstrunit','unit_material',us.wide_material)||
        f_get_paramtrs_equiv_long('userstrunit','unit_type',us.wide_type)||
        f_get_paramtrs_equiv_long('userstrunit','super_design_ty',us.wide_design_ty)||
        decode(wide_num_girders,'NULL',' ',' - '||to_char(wide_num_girders))
into retval
from userstrunit us
WHERE  us.brkey = v_brkey and
       us.strunitkey = v_strunitkey;




return retval;
end f_get_strtype_widen_grdrs;

 
/