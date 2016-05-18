CREATE OR REPLACE function pontis.f_get_inspectors_counts(v_year varchar2, v_userkey users.userkey%type,
                                                   datetablename_in varchar2,
                                                   datefieldname_in varchar2,
                                                 columnname_in varchar2)
  -- Summary: Used in Don Whislers Inspection Counts Report to retrieve counts of inspections per type
  -- per inspector<BR>
  -- <BR>
  -- %revision-history
  -- created: existing as of 2014 inspection cycle<BR>
  -- revised: 2015-1-12 updated to current year and added documentation<BR>
  -- <p id="doc_save_date" style="margin: 0;">documentation revised: 2015-07-10</p><p id="doc_mod_date" style="margin: 0;"></p>
  -- %copyright-notice Kansas Department of Transportation, 2015 - all rights reserved
  -- %kdot-contact Ms. Deb Kossler, Bureau of Design<BR>
  -- <a href="mailto:deb@ksdot.org?Subject="Documentation%20Question%20re:%20f_get_inspectors_counts">Email questions about f_get_inspectors_counts</a><BR>
  -- %developer-info Deb Kossler
  -- <BR>ph: 785-368-8158
  -- <BR><a href="http://allenrmarshall-consulting-llc.com" alt="Link to developer website">Visit developer website</a>
  -- <BR><a href="mailto:armarshall@allenrmarshall-consulting-llc.com?Subject="Documentation%20Question%20re:%20f_get_inspectors_counts">Email questions about f_get_inspectors_counts</a><BR>
  -- %development-environment
  -- Oracle Database 11g Release 11.2.0.4.0<BR>
  -- OCI: version 11.1
  -- %param v_year varchar2 
  -- %param v_userkey users.userkey%type
  -- %param datetablename_in varchar2
  -- %param datefieldname_in varchar2
  -- %param columname_in varchar2
  -- %usage f_get_inspectors_counts('2015', userkey,'inspevnt','inspdate','r_inspname_1') FROM DUAL;  will return a count of routine inspections per inspector for given year 2015
  -- can be used in PL/SQL code <br>
  -- ...<br>
  -- ...<br>
  -- result = count of inspections per inspector;
  -- ...<br>
  -- ...<br>
  -- use in Don's "Inspection Counts" report
  -- %raises NO_DATA_FOUND if a match cannot be determined, and returns a null result
  -- or raises a generic exception on OTHER
  -- %return
  -- a numerical expression for counts
  -- %see                                                
                                                 
   return varchar2 is
  retval    number;
  sqlString varchar2(8000);
 quote     char(1) := chr(39); -- use the ASCII code for sinqle quote which is CHR(39)


  begin
  
    -- create a big sql string which will dynamically include the tablename and column name you have passed.
  
    sqlString := 'select count('||quote || '*' || quote || ')'||
               ' from userinsp, inspevnt , mv_latest_inspection, bridge '||
              ' where userinsp'||'.'||'brkey = '|| 'bridge'||'.'||'brkey'||
              ' and inspevnt'||'.'||'brkey = '|| 'bridge'||'.'||'brkey'||
              ' and mv_latest_inspection'||'.'||'brkey = '||'bridge'||'.'||'brkey '||
  --            ' and bridge'||'.'||'district <> '|| quote || '5' || quote || -- used to specifically eliminate a district
              ' and userinsp'||'.'||'inspkey = '||'mv_latest_inspection'||'.'||'inspkey ' ||
              ' and inspevnt'||'.'||'inspkey = '||'mv_latest_inspection'||'.'||'inspkey ' ||
              ' and extract'||' (year from '||datetablename_in||'.'||datefieldname_in||') =  :yr '||
              ' and userinsp'||'.'||columnname_in||' = :us';

  
    -- execute the dynamic SQL string - supply v_brkey as bind variable :br 
    -- return result into retval
  
    execute immediate sqlString
      into retval
      using v_year,v_userkey; --see :br above
  
    return retval;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      --- sql did not find any data, so return a NULL
      return NULL;
    
    WHEN OTHERS THEN
      RAISE; -- something bad happened, report it.
  
  end f_get_inspectors_counts;

 
/