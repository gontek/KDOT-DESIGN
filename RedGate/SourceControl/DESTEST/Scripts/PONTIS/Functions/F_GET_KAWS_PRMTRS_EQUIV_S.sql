CREATE OR REPLACE function pontis.f_get_kaws_prmtrs_equiv_s(p_table_name in varchar2,p_field_name in varchar2 , p_parmvalue in varchar2)

 return varchar2 as
  Result varchar2(50);

begin

select ltrim(shortdesc,' 1234567890') into result
from KAWS_paramtrs p
where upper(p.TABLE_NAME) = upper(p_table_name)
    and upper(p.FIELD_NAME)  = upper (p_field_name) and
        upper(p.PARMVALUE )   = upper(p_parmvalue) ;
return result;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    result := '_';
 return result;

end f_get_kaws_prmtrs_equiv_s;

 
/