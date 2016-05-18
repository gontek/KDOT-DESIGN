CREATE OR REPLACE TRIGGER pontis.tbidr_bridge
       BEFORE  INSERT OR DELETE
     ON pontis.bridge
     FOR EACH ROW
-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: tbidr_bridge
-- BEFORE INSERT OR DELETE trigger to record bridge identifiers for new or about to be deleted records.
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:
-- 2003.01.03       - NEW Records BRKEY and BRIDGE_ID  about to be inserted or deleted in the SCOREBOARD collection variable in KSBMS_SCOREBOARD
--                             which lets us then troll through those brkeys after the delete concludes and clean up the
--                              change log accordingly. See triggers TBID_SL_BRIDGE and TAID_SL_BRIDGE


-----------------------------------------------------------------------------------------------------------------------------------------

-- ?2002,2003  Copyright: Cambridge Systematics, Inc, Asset Management Group: All Rights Reserved
-- No distribution without express written permission of Cambridge Systematics, Inc., Cambridge MA

--    Cambridge Systematics
--    150 CambridgePark Drive, Suite 4000
--    Cambridge MA 02140
--    Phone: 617-354-0167
--    Fax:   616-354-1542
--    http://www.camsys.com







DISABLE DECLARE
     ls_bridge_id           bridge.bridge_id%TYPE;
     ls_brkey               bridge.brkey%TYPE;
     lex_unsupported_case   EXCEPTION;
BEGIN
     -- Which brkey and bridge_id we capture depends on 
     -- whether we are INSERTing or DELETing
     IF INSERTING
     THEN
          -- So the BRKEY conforms to KDOT standards - GEN IT BY DECODING
          ls_brkey := ksbms_pontis.f_kdot_bridge_id_to_brkey (:NEW.bridge_id);
          ls_bridge_id := :NEW.bridge_id;
          
          -- Allen Marshall, CS - 2003.01.07
          -- lock in right now as CREATEDATETIME (See taib_inspevnt_validation  where referenced)
          -- overrides the input values from Pontis screens
          :new.createdatetime := SYSDATE;
          :new.modtime := SYSDATE;
          
     ELSIF DELETING
     THEN
          ls_brkey := :OLD.brkey; -- Because we know the old one when DELETing
          ls_bridge_id := :OLD.bridge_id;
        /*   DELETE FROM eleminsp  WHERE brkey = ls_bridge_id;
          DELETE FROM userinsp WHERE brkey = ls_bridge_id;
          DELETE FROM inspevnt WHERE brkey = ls_bridge_id;
          DELETE FROM userrway WHERE brkey = ls_bridge_id;
          DELETE FROM roadway WHERE brkey = ls_bridge_id;
          DELETE FROM userstrunit WHERE brkey = ls_bridge_id;
          DELETE FROM structure_unit WHERE brkey = ls_bridge_id;
          DELETE FROM insp_wcand WHERE brkey = ls_bridge_id;
          */
     ELSE   -- Unhandled case
          -- This will raise as an unhandled user error
          RAISE lex_unsupported_case; -- Does this work?
     END IF;

     -- Allen Marshall, CS - 2002-12-12
     -- Always keep track of the bridges we are working with - both BRKEY and BRIDGE_ID
     ksbms_scoreboard.p_add_br_keyvals_to_scoreboard (ls_brkey, ls_bridge_id);
     DBMS_OUTPUT.put_line ('Trigger tbidr_bridge succeeded for BRKEY = '  || ls_brkey ||' and BRIDGE_ID='  || ls_bridge_id );
      
EXCEPTION
     WHEN OTHERS
     THEN
          DBMS_OUTPUT.put_line ('Trigger tbidr_bridge failed');
END tbidr_bridge;
/