CREATE OR REPLACE TRIGGER pontis.taidr_bridge_bridge_id
   after insert
   on pontis.bridge
   for each row
-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taidr_bridge_brkey
-- After INSERT  trigger to pass essential parameters via ksbms_pontis_util.f_pass_update_trigger_params()
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:
-- 2002.12.12        - Records BRKEY about to be deleted in the SCOREBOARD collection variable in KSBMS_SCOREBOARD
--                             which lets us then troll through those brkeys after the delete concludes and clean up the
--                              change log accordingly. See triggers TBID_SL_BRIDGE and TAID_SL_BRIDGE
-- 2002.07.08       - Allen Marshall - Pass BRIDGE_ID to CANSYS for new or deleted records, not BRKEY
--                                       renamed trigger to taidr_bridge_bridge_id

-- 2002.01.10  - Hoyt Nelson, CS -- Initial adaptation from the generated update triggers

-- 2011.09.20  - DK changed to reflect a policy decision not to delete structures
--                  out of POntis, but to set them to a bogus "District 9" for history purposes...
-----------------------------------------------------------------------------------------------------------------------------------------


DISABLE declare
   lb_result              boolean;
   ls_bridge_id           bridge.bridge_id%type;
   ls_brkey               bridge.brkey%type;
   ls_exchange_type       ksbms_robot.ds_change_log.exchange_type%type;
   lex_unsupported_case   exception;

begin  
  -- capture bridge_id
  -- for insert only
   
if inserting 
   then
      -- So the BRKEY conforms to KDOT standards
      ls_brkey := ksbms_pontis.f_kdot_bridge_id_to_brkey( :new.bridge_id );
      ls_bridge_id := :new.bridge_id;
      ls_exchange_type := 'INS';
 /*   
   elsif deleting
   then
      ls_brkey := :old.brkey; -- Because we know the old one when DELETing
      ls_bridge_id := :old.bridge_id;
      ls_exchange_type := 'DEL';
 */
   else -- Unhandled case
      -- This will raise as an unhandled user error
      raise lex_unsupported_case; -- Does this work?
   end if;
  -- Allen Marshall, CS - 2002-12-12
  -- Always keep track of the bridges we are working with
  -- ksbms_scoreboard.p_add_br_keyvals_to_scoreboard( ls_brkey,ls_bridge_id );  --NOW KEEPING TRACK OF THIS IN TBIDR_BRIDGE_BRIDGE_ID
    
   -- Since the column (argument 4) is relevant ONLY for updates,
   -- we can overload that argument by passing in the exchange type,
   -- i.e. either INS (INSERT) or DEL (DELETE)
   lb_result := ksbms_pontis.f_pass_update_trigger_params (
                   nvl (ls_brkey, '<MISSING>'),
                   'BRIDGE_ID',
                   'BRIDGE',
                   ls_exchange_type,
                   :old.bridge_id,
                   :new.bridge_id,
                   1,
                   nvl (ls_bridge_id, '<MISSING>'),
                   'taidr_bridge_bridge_id'
                );

   if lb_result
   then
      dbms_output.put_line ('Trigger taidr_bridge_bridge_id failed');
   end if;
end taidr_bridge_bridge_id;
/