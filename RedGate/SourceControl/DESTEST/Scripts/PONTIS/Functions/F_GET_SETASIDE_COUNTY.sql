CREATE OR REPLACE function pontis.f_get_setaside_county(p_table_name in varchar2,p_field_name in varchar2 , p_countyno in varchar2)

 return varchar2 as
  Result varchar2(20);

begin

select longdesc||'-'||shortdesc into result
from paramtrs p
where upper(p.TABLE_NAME) = upper(p_table_name)
    and upper(p.FIELD_NAME)  = upper (p_field_name) and
        p_countyno   = ltrim(p.longdesc,'0') ;
return result;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    result := '_';
 return result;

end f_get_setaside_county;

 
/