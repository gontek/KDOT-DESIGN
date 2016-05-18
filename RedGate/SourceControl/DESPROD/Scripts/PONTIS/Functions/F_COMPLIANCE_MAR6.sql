CREATE OR REPLACE FUNCTION pontis.f_Compliance_Mar6(p_Brkey IN Bridge.Brkey%TYPE)
-- determine FHWA MAR6 indicator compliance for a given bridge<BR>
  -- PL/SQL function f_Compliance_Mar6 compares database <B>actual</B> routine inspection date versus <B>expected/scheduled date</B> by stated frequency<BR>
  -- Every NBI bridge must be inspected on or before the date of its next inspection based on the 
  -- prior inspection plus the inspection frequency in months.<BR>
  -- This function will show whether the bridge was in fact inspected on time or not. A grace period of 1 month is assumed.<BR><BR>
  -- <a href="http://www.fhwa.dot.gov/bridge/nbip/metrics.pdf" alt="Link to FHWA metrics PDF file">Click to view the FHWA metrics PDF</a><BR>
  -- <BR>
  -- %revision-history
  -- created: 2015-06-17 - ARMarshall w/ DKossler - to implement MAR6 compliance tracking<BR>
  -- revised: 2015-07-09 - ARMarshall - Added documentation header
  -- %copyright-notice Kansas Department of Transportation, 2015 - all rights reserved
  -- %developer-info Allen R. Marshall, ARM LLC
  -- <BR>ph: 617-335-6934
  -- <BR><a href="http://allenrmarshall-consulting-llc.com" alt="Link to developer website">Visit developer website</a>
  -- <BR><a href="mailto:armarshall@allenrmarshall-consulting-llc.com?Subject="Documentation%20Question%20re:%20f_compliance_mar6">Email questions about f_compliance_mar6</a><BR>
  --%development-environment 
  -- Oracle Database 11g Release 11.2.0.4.0<BR>
  -- OCI: version 11.1 
  -- %usage This function can be called from SQL or used within a PL/SQL program unit or a view, as shown in the following examples:<BR>
  -- <CODE class="USAGE_CODE"><I>
  -- ...<BR>
  -- ... 1) directly in a SQL window by passing a known good BRKEY<BR>
  -- ...<BR>
  -- </I>select <B>f_compliance_mar6(<the_brkey>)</B> from DUAL;<BR> 
  -- <I>...<BR>
  -- ... 2) or as part of a set of columns ...<BR>
  -- ...<BR>
  --  <B> f_compliance_mar6(b.brkey) </B>
  --   AS Mar6_NBI_Insp_Compliance,<BR>
  -- ...<BR> 
  -- <I>... 3) or in a PL/SQL program unit...</I><BR>
  -- ...<BR>
  -- ...<BR>
  -- RESULT = f_compliance_mar6(p_brkey);
  -- RETURN RESULT;
  -- ...<BR>
  -- </CODE>
  -- %param p_Brkey IN Bridge.Brkey%TYPE -- the brkey to check based on the latest inspection
  -- %raises NO_DATA_FOUND if the bridge has no inspections in MV_LATEST_INSPECTION and returns NULL to the calling program,<BR>
  -- a generic OTHER exception otherwise
  -- %return 
  -- # of months overdue if the bridge was NOT inspected on-schedule <BR>
  -- 0 (false) otherwise or <BR>
  -- NULL on a NO_DATA_FOUND exception<BR>
  -- -20999 if the bridge does not existbased on BRKEY<BR>
  -- %see similar function f_compliance_mar6
  -- %see dynamic view V_MAR_COMPLIANCE_INDICATORS that uses this function in its column set
  -- %see materialized view MV_LATEST_INSPECTION that returns the latest inspection in the database for a given BRKEY value
 RETURN PLS_INTEGER IS
  RESULT PLS_INTEGER := 0;
BEGIN

  -- if slowpoke - see if the bridge exists.
  IF Ksbms_Pontis_Util.f_Get_Bridge_Id_From_Brkey(p_Brkey) IS NULL THEN
    Raise_Application_Error(-20999,
                            q'[Bridge ]' || p_Brkey || q'[ not found!]');
  END IF;

  SELECT Trunc(Months_Between(SYSDATE, Mv.Nextrinsp_Calc)) AS Overdue
    INTO RESULT
    FROM Mv_Latest_Inspection Mv
   WHERE Mv.Brkey = p_Brkey
     AND Trunc(Months_Between(SYSDATE, Mv.Nextrinsp_Calc)) > 1;

  RETURN(RESULT);

EXCEPTION

  WHEN No_Data_Found THEN
    RETURN NULL;
  WHEN OTHERS THEN
    RAISE;
  
END f_Compliance_Mar6;
/