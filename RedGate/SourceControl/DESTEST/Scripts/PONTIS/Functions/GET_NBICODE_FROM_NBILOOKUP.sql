CREATE OR REPLACE function pontis.get_nbicode_from_NBIlookup( p_table_name in varchar2, p_field_name in varchar2 , p_kdot_code in varchar2)
return varchar2 as
	v_nbi_code nbilookup.nbi_code%type;
begin
	select TRIM(upper(NBI_CODE) )
	into v_nbi_code
	from NBILOOKUP
	where upper(TABLE_NAME) = upper(p_table_name)
		and upper(FIELD_NAME) = upper(p_field_name)
		and upper(KDOT_CODE) = upper(p_kdot_code);
	return v_nbi_code;
EXCEPTION
	when no_data_found then 
	return null;
end;

 
/