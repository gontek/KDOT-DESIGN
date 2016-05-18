CREATE OR REPLACE TRIGGER pontis.taidr_bridge_ins_warn
   after insert
   on pontis.bridge
   for each row
-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taidr_bridge_ins_warn
-- After INSERT trigger to notify KDOT staff that a new bridge was added to the system
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

-- 2002.12.13 - Allen Marshall, CS - fixed timestamp in e-mail message, updated comments
-- 2002.01.10  - Hoyt Nelson, CS -- Initial adaptation from the generated update triggers
-- 2002.07.08  - Allen Marshall, CS -- created from TAIDR_ELEMDEFS_WARN to notify staff of new structure in database
-- 2006.03.24 -  Deb Kossler,KDOT -- revised to change email list
-- 2011.09.20 -  DK, KDOT -- revised to notify only on inserts
-----------------------------------------------------------------------------------------------------------------------------------------

-- ?2002 Copyright: Cambridge Systematics, Inc, Asset Management Group: All Rights Reserved


DISABLE declare
   ls_email_list          ksbms_robot.ds_config_options.optionvalue%TYPE;
   lex_email_failed       EXCEPTION;
   lex_unsupported_case   EXCEPTION;   
begin
     -- Get alert list from KSBMS_ROBOT.DS_CONFIG_OPTIONS
     
     ls_email_list := nvl( ksbms_util.f_get_coption_value('EMAIL_BRIDGE_CREATDEL_LIST'),'deb@ksdot.org');
   -- What we e-mail depends on 
   -- whether we are INSERTing or DELETing
   if inserting
   then
       
     -- send new BRIDGE_ID  as mail message
     -- Allen R. Marshall, CS 2002.12.13 - fixed timestamp to show time and date, not just date
       if ksbms_util.f_email( ls_email_list, 'Bridge ' ||:new.bridge_id||' in Dist/Area '||:new.adminarea||' was added to the database by user '|| USER || ' at ' || to_char(sysdate,'YYYY-MM-DD HH:MI:SS') ||
       ksbms_util.crlf||'Design folks: Remember to ASAP visit this structure to fill in blank fields and create element level structure items as noted in instructions for this bridge.'
       , 'ATTENTION: BRIDGE INSERTED/CREATED - NEW BRIDGE_ID  # '|| :new.bridge_id ) then 
            raise lex_email_failed;
       end if;
         
  /*    
   elsif deleting
   then
      -- send deleted BRIDGE_ID in mail message
      -- Allen R. Marshall, CS 2002.12.13 - fixed timestamp to show time and date, not just date
      if ksbms_util.f_email( ls_email_list,'Bridge '||:old.bridge_id||' in Dist/Area '||:old.adminarea|| ' was removed from the database by user '|| USER || ' at ' || to_char(sysdate,'YYYY-MM-DD HH:MI:SS')||
        ksbms_util.crlf||'Design folks: Remember to check whether the road intersection was end-dated.', 'ATTENTION: BRIDGE/CULVERT DELETED - BRIDGE ID # '|| :old.bridge_id) then
         raise lex_email_failed;
      end if;
  */    
     else -- Unhandled case
        -- This will raise as an unhandled user error
        raise lex_unsupported_case; -- Does this work?
     end if;

   exception
     WHEN lex_email_failed THEN
          dbms_output.put_line ('ksbms_util.f_email(l,m,s) function call failed processing Trigger taidr_bridge_ins_warn failed');
     WHEN lex_unsupported_case THEN
          dbms_output.put_line ('Unsupported case encountered processing Trigger taidr_bridge_ins_warn failed');
     
     WHEN OTHERS THEN
        dbms_output.put_line ('Trigger taidr_bridge_ins_warn failed');

end taidr_bridge_ins_warn;
/