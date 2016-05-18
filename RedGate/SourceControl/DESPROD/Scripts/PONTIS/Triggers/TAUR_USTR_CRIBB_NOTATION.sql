CREATE OR REPLACE TRIGGER pontis.TAUR_USTR_CRIBB_NOTATION
  AFTER UPDATE OF CRIT_NOTE_SUP_1,CRIT_NOTE_SUP_2,CRIT_NOTE_SUP_3,CRIT_NOTE_SUP_4,CRIT_NOTE_SUP_5 ON pontis.USERSTRUNIT
  FOR EACH ROW

-- Summary: An after update trigger that updates NBI 103 to 'T' if a cribbing notation (8) has been noted.<BR>
  --   <BR>
  -- revision--<BR>
  -- created: New...2016-04-13<BR>
  -- revised: <BR>
  -- <p id="doc_save_date" style="margin: 0;">documentation revised: 2016-04-13</p><p id="doc_mod_date" style="margin: 0;"></p>
  -- %copyright-notice Kansas Department of Transportation, 2015 - all rights reserved
  -- %kdot-contact Ms. Deb Kossler, Bureau of Structures and Geotechnical Services, Bridge Management<BR>
  -- <a href="mailto:deb@ksdot.org?Subject="Documentation%20Question%20re:%20taur_ustr_cribb_notation">Email questions about taur_ustr_cribb_notation</a><BR>
  -- %developer-info Allen R. Marshall, ARM LLC
  -- <BR>ph: 617-335-6934
  -- <BR><a href="http://allenrmarshall-consulting-llc.com" alt="Link to developer website">Visit developer website</a>
  -- <BR><a href="mailto:armarshall@allenrmarshall-consulting-llc.com?Subject="Documentation%20Question%20re:%20taur_ustr_cribb_notation">Email questions about taidr_bridge_ins_warn</a><BR>
  -- %development-environment
  -- Oracle Database 11g Release 11.2.0.4.0<BR>
  -- OCI: version 11.1
  -- %param
  -- %usage Uses the updates from crit_note sup fields to assess a cribbing notation of '8' and sets bridge.tempstruc = 'T'
  -- if the assessment is true.<BR>
  -- %raises 
  -- %return  
  -- %see 

DECLARE  V_103 bridge.tempstruc%type;
         retval bridge.tempstruc%type;

BEGIN

v_103 := null; -- result is null unless it meets the criteria below...

IF((:NEW.CRIT_NOTE_SUP_1 = '8') OR
  (:NEW.CRIT_NOTE_SUP_2 = '8') OR
(:NEW.CRIT_NOTE_SUP_3 = '8') OR
(:NEW.CRIT_NOTE_SUP_4 = '8') OR
(:NEW.CRIT_NOTE_SUP_5 = '8') )
THEN
  v_103 := 'T';
end if; 

retval := v_103;

-- Now, Put This answer into the bridge.tempstruct;
UPDATE bridge
  SET tempstruc = retval
  WHERE
  BRIDGE.BRKEY = :OLD.BRKEY;


END TAUR_USTR_CRIBB_NOTATION;
/