CREATE OR REPLACE TRIGGER pontis.taidr_roadway_brkey
   after insert or delete
   on pontis.roadway
   for each row
-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: hua_ROADWAY_BRKEY
-- After update trigger to pass essential parameters via ksbms_pontis_util.f_pass_update_trigger_params()
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

--    2002.01.10  - Hoyt Nelson, CS -- Initial adaptation from the generated update triggers

-----------------------------------------------------------------------------------------------------------------------------------------

-- ?2002 Copyright: Cambridge Systematics, Inc, Asset Management Group: All Rights Reserved
-- No distribution without express written permission of Cambridge Systematics, Inc., Cambridge MA

--    Cambridge Systematics
--    150 CambridgePark Drive, Suite 4000
--    Cambridge MA 02140
--    Phone: 617-354-0167
--    Fax:   616-354-1542
--    http://www.camsys.com







DISABLE declare
   lb_result              boolean;
   ls_bridge_id           bridge.bridge_id%type;
   ls_brkey               roadway.brkey%type;
   ls_on_under            roadway.on_under%TYPE; -- Allen Marshall, CS - 2003.01.04 - added
   ls_exchange_type       ksbms_robot.ds_change_log.exchange_type%type;
   lex_unsupported_case   exception;
begin
   -- Which brkey and bridge_id we capture depends on 
   -- whether we are INSERTing or DELETing
   if inserting
   then
      ls_brkey := :new.brkey; -- Because we know the new one when INSERTing
      ls_on_under := :new.on_under; --we know this too.
      ls_exchange_type := 'INS';
      
   elsif deleting
   then
      ls_brkey := :old.brkey; -- Because we know the old one when DELETing
      ls_on_under := :old.on_under; --we know this too.
      ls_exchange_type := 'DEL';
   
   else -- Unhandled case
      -- This will raise as an unhandled user error
      raise lex_unsupported_case; -- Does this work?
   end if;
   
   
     ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey (ls_brkey);

   -- bridge is being deleted, so the BRIDGE_ID may be indeterminate SQL-WISE- find in COLLECTION vARIABLE if available
   IF ksbms_scoreboard.v_bool_br_insert_underway OR
   ksbms_scoreboard.v_bool_br_delete_underway THEN

          IF ls_bridge_id IS NULL
          THEN
               ls_bridge_id :=
                      ksbms_scoreboard.f_find_bridge_id_for_bridge (ls_brkey);
          END IF;
     -- Allen Marshall, CS - 2002-12-12
     -- Always keep track of the bridges (INSPECTIONS)  we are working with - both BRKEY and BRIDGE_ID, and INSPKEY
     ksbms_scoreboard.p_add_rw_keyvals_to_scoreboard (ls_brkey,
                                                      ls_on_under,
                                                      ls_bridge_id
                                                     );
   --- END CHANGE 2003.01.04
   END IF; -- find bridge_id in collection variabl ein KSBMS_SCOREBOARD
   -- Since the column (argument 4) is relevant ONLY for updates,
   -- we can overload that argument by passing in the exchange type,
   -- i.e. either INS (INSERT) or DEL (DELETE)
   lb_result := ksbms_pontis.f_pass_update_trigger_params (
                   nvl (ls_brkey, '<MISSING>'),
                   'BRIDGE_ID',
                   'ROADWAY',
                   ls_exchange_type,
                   :old.brkey,
                   :new.brkey,
                   1,
                   nvl (ls_bridge_id, '<MISSING>'),
                   'taidr_ROADWAY_BRKEY'
                );
                
   if lb_result
   then
      dbms_output.put_line ('hua_ROADWAY_BRKEY_ON_UNDER failed');
   end if;
end taidr_roadway_brkey;
/