CREATE OR REPLACE function pontis.f_field_check_projs(v_brkey bridge.brkey%type)

-- Summary: Function to create a string of completed project data for the field "history" in view v_field_check_form<BR>
  -- <BR>
  -- %revision-history
  -- created: 2015-11-13<BR>
  -- revised: 2015-11-13 added documentation<BR>
  -- <p id="doc_save_date" style="margin: 0;">documentation revised: 2015-07-10</p><p id="doc_mod_date" style="margin: 0;"></p>
  -- %copyright-notice Kansas Department of Transportation, 2015 - all rights reserved
  -- %kdot-contact Ms. Deb Kossler, Bureau of Design<BR>
  -- <a href="mailto:deb@ksdot.org?Subject="Documentation%20Question%20re:%f_field_check_projs">Email questions</a><BR>
  -- %developer-info Deb Kossler, KDOT
    -- %development-environment
  -- Oracle Database 11g Release 11.2.0.4.0<BR>
  -- OCI: version 11.1
  -- %param v_brkey IN VARCHAR2 

  -- %usage SELECT f_field_check_projs(b.brkey) from bridge b will return a string of project descriptions and years of completion
  --  separated by commas<br>
  -- ...<br>
  -- ...<br>
  -- result = i.e., yearbuilt 2003, widening, 2013
  -- ...<br>
  -- ...<br>
  -- used in Calvin's Field Check Form to give designers initial bridge information about a bridge they're going to replace
  -- %raises NO_DATA_FOUND if a match cannot be determined, and returns a NULL result
  -- or raises a generic exception on OTHER<BR>
 return varchar2 is
  retval varchar2(2000);


begin
  
select  listagg(actvtydscr||', '||actvtyyear,', ') within group (order by actvtydate)
 into retval
 from V_BIF_CAPITAL_PRJ t
where actvtyid in ('40','13','14','15','17','18','19','37')
and t.brkey = v_brkey
group by t.brkey;

return(retval);

EXCEPTION
  WHEN No_Data_Found THEN
    RETURN NULL; 
  WHEN OTHERS THEN
    RAISE;

end f_field_check_projs;
/