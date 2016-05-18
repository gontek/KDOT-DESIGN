CREATE OR REPLACE TRIGGER pontis.taidr_elemdefs_warn
   after insert or delete
   on pontis.elemdefs
   for each row
-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taidr_elemdefs_warn
-- After INSERT trigger to notify KDOT staff that a new element was added
-- After DELETE trigger to notify KDOT staff that an element was removed
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

-- 2002.01.10  - Hoyt Nelson, CS -- Initial adaptation from the generated update triggers
-- 2002.03.07  - Allen Marshall, CS -- used as based for a post trigger to notify staff of a new element def

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
   ls_email_list          ksbms_robot.ds_config_options.optionvalue%TYPE;
   lex_email_failed       EXCEPTION;
   lex_unsupported_case   EXCEPTION;   
begin
     -- Get alert list from KSBMS_ROBOT.DS_CONFIG_OPTIONS
     
     ls_email_list := nvl( ksbms_util.f_get_coption_value('EMAIL_ALERT_LIST'),'deb@ksdot.org');
   -- What we e-mail depends on 
   -- whether we are INSERTing or DELETing
   if inserting
   then
       
     -- send new elemkey as mail message
     
       if ksbms_util.f_email( ls_email_list, 'Element ' ||:new.elemkey||' was added to the database by user '|| USER || ' at ' || to_char(sysdate), 'ATTENTION: ELEMDEFS INSERT - NEW ELEMENT # '|| :new.elemkey ) then 
            raise lex_email_failed;
       end if;
         
      
   elsif deleting
   then
         -- send deleted elemkey in mail message
      if ksbms_util.f_email( ls_email_list,'Element '||:old.elemkey|| ' was removed from the database by user '|| USER || ' at ' || to_char(sysdate), 'ATTENTION: ELEMDEFS DELETE - DELETED ELEMENT # '|| :old.elemkey) then
         raise lex_email_failed;
      end if;
      
     else -- Unhandled case
        -- This will raise as an unhandled user error
        raise lex_unsupported_case; -- Does this work?
     end if;

   exception
     WHEN lex_email_failed THEN
          dbms_output.put_line ('ksbms_util.f_email(l,m,s) function call failed processing Trigger taidr_elemdefs_warn failed');
     WHEN lex_unsupported_case THEN
          dbms_output.put_line ('Unsupported case encountered processing Trigger taidr_elemdefs_warn failed');
     
     WHEN OTHERS THEN
        dbms_output.put_line ('Trigger taidr_elemdefs_warn failed');

end taidr_elemdefs_warn;
/