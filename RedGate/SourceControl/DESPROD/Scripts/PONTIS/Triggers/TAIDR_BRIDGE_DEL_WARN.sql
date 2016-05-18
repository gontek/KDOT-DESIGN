CREATE OR REPLACE TRIGGER pontis.taidr_bridge_del_warn
   after update of district
   on pontis.bridge
   for each row
-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taidr_bridge_del_warn
-- After DELETE trigger to notify KDOT staff that a bridge was removed by Pontis...
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
-- 2011.09.20  - DK, KDOT -- revised again to continue to let folks know a bridge has been set to
--               "history"
-----------------------------------------------------------------------------------------------------------------------------------------


  WHEN (nvl(new.district,'<MISSING>')<> nvl(old.district, '<MISSING>')) declare
   ls_email_list          ksbms_robot.ds_config_options.optionvalue%TYPE;
   lex_email_failed       EXCEPTION;
   lex_unsupported_case   EXCEPTION;   
begin
     -- Get alert list from KSBMS_ROBOT.DS_CONFIG_OPTIONS
     
     ls_email_list := nvl( ksbms_util.f_get_coption_value('EMAIL_BRIDGE_CREATDEL_LIST'),'deb@ksdot.org');


if (:new.district = '9') then  -- New criteria for sending a delete to Cansys  
 
      -- send deleted BRIDGE_ID in mail message

     if ksbms_util.f_email( ls_email_list,'Bridge '||:old.bridge_id||' in Dist/Area '||:old.adminarea|| ' was removed from the database by user '|| USER || ' at ' || to_char(sysdate,'YYYY-MM-DD HH:MI:SS')||
        ksbms_util.crlf||'Design folks: Remember to check whether the road intersection was end-dated and add the appropriate bridge level note.', 'ATTENTION: BRIDGE/CULVERT DELETED - BRIDGE ID # '|| :old.bridge_id) then
         raise lex_email_failed;
      end if;
      
     else -- Unhandled case
        -- This will raise as an unhandled user error
        raise lex_unsupported_case; -- Does this work?
     end if;

   exception
     WHEN lex_email_failed THEN
          dbms_output.put_line ('ksbms_util.f_email(l,m,s) function call failed processing Trigger taidr_bridge_insdel_warn failed');
     WHEN lex_unsupported_case THEN
          dbms_output.put_line ('Unsupported case encountered processing Trigger taidr_bridge_insdel_warn failed');
     
     WHEN OTHERS THEN
        dbms_output.put_line ('Trigger taidr_elemdefs_warn failed');

end taidr_bridge_del_warn;
/