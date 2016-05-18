CREATE OR REPLACE function pontis.f_structuretype(v_brkey      pontis.userstrunit.brkey%type,
                                           v_strunitkey pontis.userstrunit.strunitkey%type)
-- Summary: Decodes the three agency fields that comprise structure type to their alpha designation per individual structure unit<BR>
  -- used in myriad reports and data outputs<BR>
  -- %revision-history
  -- created: existing as of 2015-07-14<BR>
  -- revised: 2015-07-14 added documentation details<BR>
  -- <p id="doc_save_date" style="margin: 0;">documentation revised: 2015-07-10</p><p id="doc_mod_date" style="margin: 0;"></p>
  -- %copyright-notice Kansas Department of Transportation, 2015 - all rights reserved
  -- %kdot-contact Ms. Deb Kossler, Bureau of Structures and Geotechnical Services, Bridge Management<BR>
  -- <a href="mailto:deb@ksdot.org?Subject="Documentation%20Question%20re:%20f_structuretype">Email questions about f_structuretype</a><BR>
  -- %developer-info Allen R. Marshall, ARM LLC
  -- <BR>ph: 617-335-6934
  -- <BR><a href="http://allenrmarshall-consulting-llc.com" alt="Link to developer website">Visit developer website</a>
  -- <BR><a href="mailto:armarshall@allenrmarshall-consulting-llc.com?Subject="Documentation%20Question%20re:%20f_structuretype">Email questions about f_structuretype</a><BR>
  -- %development-environment
  -- Oracle Database 11g Release 11.2.0.4.0<BR>
  -- OCI: version 11.1
  -- %param v_brkey pontis.userstrunit.brkey%type 
  -- %param v_strunitkey pontis.userstrunit.strunitkey%type 

  -- %usage select f_structuretype(b.brkey,b.strunitkey) from bridge; will return the alpha representation of structure type for each unit of a structure
  -- %raises NO_DATA_FOUND if a match cannot be determined, and returns a generic UNDERSCORE '_' result
  -- or raises a generic exception on OTHER
  -- %return
  -- %see

 return varchar2 is
  retval varchar2(4);
begin

  select f_get_paramtrs_equiv_long('userstrunit',
                                   'unit_material',
                                   us.unit_material) ||
         f_get_paramtrs_equiv_long('userstrunit', 'unit_type', us.unit_type) ||
         f_get_paramtrs_equiv_long('userstrunit',
                                   'super_design_ty',
                                   us.super_design_ty)
    into retval
    from userstrunit us
   WHERE us.brkey = v_brkey
     and us.strunitkey = v_strunitkey;

  return retval;

EXCEPTION
  WHEN No_Data_Found then
    retval := '_';
    Return retval;
  when others then
    raise;
  
end f_structuretype;
/