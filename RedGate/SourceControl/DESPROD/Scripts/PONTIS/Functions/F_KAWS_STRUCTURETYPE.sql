CREATE OR REPLACE function pontis.f_kaws_structuretype(v_co_ser kaws_structures.co_ser%type)
return varchar2 is
  retval varchar2(10);
begin


select  f_get_kaws_prmtrs_equiv_l('kaws_structures','matrl_type',ks.matrl_type)||
        f_get_kaws_prmtrs_equiv_l('kaws_structures','supr_type',ks.supr_type)

into retval
from kaws_structures ks
WHERE  ks.co_ser = v_co_ser;




return retval;
end f_kaws_structuretype;

 
/