CREATE OR REPLACE TRIGGER pontis.TAUR_UINSP_SNOOP_INTVL_WARN
  after update of snoop_insp_req on pontis.userinsp  
  for each row
-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: TAUR_UINSP_SNOOP_INTVL_WARN
-- An after update trigger to capture unintended changes to this field.
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

--  2013-11-15 Added to the project by Deb, KDOT
--  
-----------------------------------------------------------------------------------------------------------------------------------------
 
  DISABLE WHEN ( nvl(new.snoop_insp_req,'_' ) <>  nvl( old.snoop_insp_req, '_' )) declare
   ls_email_list          ksbms_robot.ds_config_options.optionvalue%TYPE;
   lex_email_failed       EXCEPTION;
   lex_unsupported_case   EXCEPTION;
   
       
begin
     -- Get email_data_entry_list from KSBMS_ROBOT.DS_CONFIG_OPTIONS
     
     ls_email_list := nvl( ksbms_util.f_get_coption_value('EMAIL_IT_ONLY_LIST'),'deb@ksdot.org');
 

 if ( :old.snoop_insp_req is not null) and
    (:new.snoop_insp_req is null) 
 
   
   then
  
      -- send warning statement as mail message
     
       if ksbms_util.f_email( ls_email_list, 'The routine snooper required field has been changed from '||:old.snoop_insp_req||' to '||:new.snoop_insp_req|| ' for structure '||:old.brkey||' by user '|| USER || ' on ' || to_char(sysdate)||'.  Check with special inspection personnel to make sure this was supposed to happen!', 'ATTENTION: A routine snooper inspection required field has been changed for '||:old.brkey||'!') then 
            raise lex_email_failed;
       end if;
     
    else -- Unhandled case
        -- This will raise as an unhandled user error
        raise lex_unsupported_case; -- Does this work?
     end if;

   exception
     WHEN lex_email_failed THEN
          dbms_output.put_line ('ksbms_util.f_email(l,m,s) function call failed processing Trigger TAUR_UINSP_SNOOP_INTVL_WARN failed');
     WHEN lex_unsupported_case THEN
          dbms_output.put_line ('Unsupported case encountered processing Trigger TAUR_UINSP_SNOOP_INTVL_WARN');
     
     WHEN OTHERS THEN
        dbms_output.put_line ('Trigger TAUR_UINSP_SNOOP_INTVL_WARN failed');

end TAUR_UINSP_SNOOP_INTVL_WARN;
/