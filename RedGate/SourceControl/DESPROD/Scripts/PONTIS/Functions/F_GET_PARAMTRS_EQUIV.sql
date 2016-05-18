CREATE OR REPLACE FUNCTION pontis.f_Get_Paramtrs_Equiv(p_Table_Name IN VARCHAR2,
                                                p_Field_Name IN VARCHAR2,
                                                p_Parmvalue  IN VARCHAR2)

  -- Summary: Get the short description for a given table, field and parameter value combination. Will return a 
  -- default underscore if no label can be found<BR>
  -- <BR>
  -- %revision-history
  -- created: existing as of 2015-07-10<BR>
  -- revised: 2015-07-10 added documentation<BR>
  -- <p id="doc_save_date" style="margin: 0;">documentation revised: 2015-07-10</p><p id="doc_mod_date" style="margin: 0;"></p>
  -- %copyright-notice Kansas Department of Transportation, 2015 - all rights reserved
  -- %kdot-contact Ms. Deb Kossler, Bureau of Design<BR>
  -- <a href="mailto:deb@ksdot.org?Subject="Documentation%20Question%20re:%20f_Compliance_Mar10">Email questions about f_Compliance_Mar10</a><BR>
  -- %developer-info Allen R. Marshall, ARM LLC
  -- <BR>ph: 617-335-6934
  -- <BR><a href="http://allenrmarshall-consulting-llc.com" alt="Link to developer website">Visit developer website</a>
  -- <BR><a href="mailto:armarshall@allenrmarshall-consulting-llc.com?Subject="Documentation%20Question%20re:%20f_Compliance_Mar10">Email questions about f_Compliance_Mar10</a><BR>
  -- %development-environment
  -- Oracle Database 11g Release 11.2.0.4.0<BR>
  -- OCI: version 11.1
  -- %param p_Table_Name IN VARCHAR2 
  -- %param p_Field_Name IN VARCHAR2 
  -- %param p_Parmvalue IN VARCHAR2 

  -- %usage SELECT F_GET_PARAMTRS_EQUIV('bridge', 'district', '02') FROM DUAL;  will return the district name for district 02
  -- can be used in PL/SQL code <br>
  -- ...<br>
  -- ...<br>
  -- result = F_GET_PARAMTRS_EQUIV('bridge', 'district', '02');
  -- ...<br>
  -- ...<br>
  -- use in reports to get the label (if any) for a database column with entries in the PARAMTRS table
  -- %raises NO_DATA_FOUND if a match cannot be determined, and returns a generic UNDERSCORE '_' result
  -- or raises a generic exception on OTHER
  -- %return
  -- the label for the table, field and value, up to 35 characters.
  -- %see

 RETURN VARCHAR2 IS
  RESULT VARCHAR2(35);

BEGIN

  SELECT Ltrim(Shortdesc, '1234567890')
    INTO RESULT
    FROM Paramtrs p
   WHERE Upper(p.Table_Name) = Upper(p_Table_Name)
     AND Upper(p.Field_Name) = Upper(p_Field_Name)
     AND Upper(p.Parmvalue) = Upper(p_Parmvalue);
  RETURN RESULT;

EXCEPTION
  WHEN No_Data_Found THEN
    RESULT := '_';
    RETURN RESULT;
  WHEN OTHERS THEN
    RAISE;
  
END f_Get_Paramtrs_Equiv;
/