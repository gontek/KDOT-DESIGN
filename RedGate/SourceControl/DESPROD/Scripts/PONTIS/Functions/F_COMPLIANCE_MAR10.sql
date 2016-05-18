CREATE OR REPLACE FUNCTION pontis.f_Compliance_Mar10(p_Brkey IN Bridge.Brkey%TYPE)
  RETURN PLS_INTEGER IS
  -- determine FHWA MAR10 indicator compliance for a given bridge<BR>
  -- PL/SQL function f_Compliance_Mar10 compares database <B>actual</B> Fracture Critical inspection date versus <B>expected date</B> by stated frequency<BR>
  -- Uses default frequency in local variable <B>Freq_Months</B> if no value is available for INSPEVNT.FCINSPFREQ<BR>
  -- Every NBI bridge requiring a fracture critical inspection must be inspected on or before the date of its next inspection based on the 
  -- prior FC inspection plus the FC inspection frequency in months.<BR>
  -- This function will show whether the bridge was in fact inspected on time or not.<BR><BR>
  -- <a href="http://www.fhwa.dot.gov/bridge/nbip/metrics.pdf" alt="Link to FHWA metrics PDF file">Click to view the FHWA metrics PDF</a><BR>
  -- <BR>
  -- %revision-history
  -- created: 2015-06-17 - ARMarshall w/ DKossler - to implement MAR compliance tracking<BR>
  -- revised: 2015-07-09 - ARMarshall - Added documentation<BR>
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
  -- %usage This function can be called from SQL or used within a PL/SQL program unit or a view, as shown in the following examples:<BR>
  -- <CODE class="USAGE_CODE"><I>
  -- ...<BR>
  -- ... 1) directly in a SQL window by passing a known good BRKEY<BR>
  -- ...<BR>
  -- </I>select <B>f_compliance_mar10(<the_brkey>)</B> from DUAL;<BR> 
  -- <I>...<BR>
  -- ... 2) or as part of a set of columns ...<BR>
  -- ...<BR></I>CASE WHEN ( f_Is_FC_Structure(b.brkey)> 0 ) THEN
  --  <B> f_compliance_mar10(b.brkey) </B>
  -- ELSE<BR>
  --   NULL  -- apparently <B>not</B> an fc bridge<BR>
  --   END<BR>
  --   AS Mar10_Fc_Insp_Compliance,<BR>
  -- ...<BR> 
  -- <I>... 3) or in a PL/SQL program unit...</I><BR>
  -- ...<BR>
  -- ...<BR>
  -- RESULT = f_compliance_mar10(p_brkey);
  -- RETURN RESULT;
  -- ...<BR>
  -- </CODE>
  -- %param p_Brkey IN Bridge.Brkey%TYPE -- the brkey to check based on the latest inspection
  -- %raises NO_DATA_FOUND if the bridge has no inspections in MV_LATEST_INSPECTION and returns NULL to the calling program,<BR>
  -- -20999 if the bridge does not exist based on BRKEY<BR>
  -- a generic OTHER exception otherwise
  -- %return 
  -- 1 (true) if the bridge was inspected on-schedule <BR>
  -- 0 (false) otherwise or <BR>
  -- NULL on a NO_DATA_FOUND exception<BR>
  -- %see similar function f_compliance_mar6
  -- %see dynamic view V_MAR_COMPLIANCE_INDICATORS that uses this function in its column set
  -- %see materialized view MV_LATEST_INSPECTION that returns the latest inspection in the database for a given BRKEY value
  RESULT      PLS_INTEGER;
  Freq_Months Inspevnt.Fcinspfreq%TYPE := 12; -- default to use in the absence of any other information
BEGIN

  -- if slowpoke - see if the bridge exists.
  IF Ksbms_Pontis_Util.f_Get_Bridge_Id_From_Brkey(p_Brkey) IS NULL THEN
    Raise_Application_Error(-20999,
                            q'[Bridge ]' || p_Brkey || q'[ not found!]');
  END IF;

  -- Was this bridge inspected within the expected interval based on i.fcinspfreq
  -- or failing that, the default value in variable Freq_Months?
  SELECT CASE
           WHEN Months_Between(SYSDATE, i.Fclastinsp) <= CASE
                  WHEN i.Fcinspfreq IS NOT NULL AND i.Fcinspfreq > 0 THEN
                   i.Fcinspfreq
                  ELSE
                   Freq_Months
                END
           
            THEN
            1
           ELSE
            0
         END
    INTO RESULT
    FROM Bridge b
   INNER JOIN Inspevnt i
      ON b.Brkey = i.Brkey
   INNER JOIN Mv_Latest_Inspection Mv
      ON Mv.Brkey = b.Brkey
     AND i.Inspkey = Mv.Inspkey
   WHERE b.Brkey = p_Brkey;

  RETURN(RESULT);
EXCEPTION
  WHEN No_Data_Found THEN
    RETURN NULL; 
  WHEN OTHERS THEN
    RAISE;
END f_Compliance_Mar10;
/