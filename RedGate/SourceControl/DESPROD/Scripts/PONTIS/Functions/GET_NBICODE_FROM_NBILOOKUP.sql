CREATE OR REPLACE function pontis.get_nbicode_from_NBIlookup( p_table_name in varchar2, p_field_name in varchar2 , p_kdot_code in varchar2)
-- Summary: Used by triggers to return the equivalent NBI code from agency select lists.<BR>
  -- <BR>
  -- %revision-history
  -- created: existing as of 2015-07-14<BR>
  -- revised:  2015-07-14 added documentation <BR>
  -- <p id="doc_save_date" style="margin: 0;">documentation revised: 2015-07-10</p><p id="doc_mod_date" style="margin: 0;"></p>
  -- %copyright-notice Kansas Department of Transportation, 2015 - all rights reserved
  -- %kdot-contact Ms. Deb Kossler, Bureau of Structures and Geotechnical Services<BR>
  -- <a href="mailto:deb@ksdot.org?Subject="Documentation%20Question%20re:%20get_nbicode_from_NBIlookup">Email questions about get_nbicode_from_NBIlookup</a><BR>
  -- %developer-info Allen R. Marshall, ARM LLC
  -- <BR>ph: 617-335-6934
  -- <BR><a href="http://allenrmarshall-consulting-llc.com" alt="Link to developer website">Visit developer website</a>
  -- <BR><a href="mailto:armarshall@allenrmarshall-consulting-llc.com?Subject="Documentation%20Question%20re:%20get_nbicode_from_NBIlookup">Email questions about get_nbicode_from_NBIlookup</a><BR>
  -- %development-environment
  -- Oracle Database 11g Release 11.2.0.4.0<BR>
  -- OCI: version 11.1
  -- %param p_table_name in varchar2 
-- %param p_field_name in varchar2 
-- %param p_kdot_code in varchar2 

  -- %usage get_nbicode_from_NBILookup( 'USERINSP', 'OPPOSTCL_KDOT', :new.OPPOSTCL_KDOT ); will return the NBI equivalent for userinsp.oppostcl_kdot
  --  mostly used in PL/SQL triggers
  -- %raises NO_DATA_FOUND if a match cannot be determined and returns null result
  -- %return
  -- %see

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