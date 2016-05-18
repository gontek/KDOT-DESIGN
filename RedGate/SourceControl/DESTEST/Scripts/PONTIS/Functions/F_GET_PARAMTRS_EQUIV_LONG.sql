CREATE OR REPLACE function pontis.f_get_paramtrs_equiv_long(p_table_name in varchar2,p_field_name in varchar2 , p_parmvalue in varchar2)

 return varchar2 as
  Result varchar2(50);

begin

select longdesc into result
from paramtrs p
where upper(p.TABLE_NAME) = upper(p_table_name)
    and upper(p.FIELD_NAME)  = upper(p_field_name) and
        upper(p.PARMVALUE )   = upper(p_parmvalue) ;
return result;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    result := ' ';
 return result;

end f_get_paramtrs_equiv_long;

 
/