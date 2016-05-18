CREATE OR REPLACE TRIGGER pontis.TAUR_INSPEVNT_SUPRATING_WARN
  after update of suprating on pontis.inspevnt
   for each row
-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: TAUR_INSPEVNT_SUPRATING_WARN
-- An after update trigger to let DEWEY know that a superstructure rating has either dropped below 6 or was below a 6 and was raised.
-- so he can make sure this action was correct.
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

--  2006-9-15 Added to the project by Deb, KDOT
-----------------------------------------------------------------------------------------------------------------------------------------
 
  DISABLE WHEN ( nvl(new.suprating, '<MISSING>' ) <>  nvl( old.suprating, '<MISSING>' )) declare
   ls_email_list          ksbms_robot.ds_config_options.optionvalue%TYPE;
   lex_email_failed       EXCEPTION;
   lex_unsupported_case   EXCEPTION;
   
       
begin
     -- Get email_ratings_change_warn_list from KSBMS_ROBOT.DS_CONFIG_OPTIONS
     
     ls_email_list := nvl( ksbms_util.f_get_coption_value('EMAIL_RATINGS_CHANGE_WARN_LIST'),'deb@ksdot.org');
 
     -- specify conditions for email to be sent
 if ( :old.suprating in ('2','3','4','5')) and   ( :new.suprating in ('5','6','7','8','9')) or
   ( :old.suprating in ('5','6','7','8','9')) and   ( :new.suprating in ('2','3','4','5'))
  
 
   
   then
  
      -- send warning statement as mail message
     
       if ksbms_util.f_email( ls_email_list, 'A superstructure rating has been changed from '||:old.suprating||' to ' ||:new.suprating||' for structure '||:old.brkey||' by user '|| USER || ' on ' || to_char(sysdate)||'.  This might affect the structural deficiency rating for this structure!', 'ATTENTION: A superstructure rating has been changed on '||:old.brkey||'!! Make sure this is correct.') then 
            raise lex_email_failed;
       end if;
     
    else -- Unhandled case
        -- This will raise as an unhandled user error
        raise lex_unsupported_case; -- Does this work?
     end if;

   exception
     WHEN lex_email_failed THEN
          dbms_output.put_line ('ksbms_util.f_email(l,m,s) function call failed processing Trigger TAUR_INSPEVNT_SUPRATING_WARN failed');
     WHEN lex_unsupported_case THEN
          dbms_output.put_line ('Unsupported case encountered processing Trigger TAUR_INSPEVNT_SUPRATING_WARN');
     
     WHEN OTHERS THEN
        dbms_output.put_line ('Trigger TAUR_INSPEVNT_SUPRATING_WARN failed');

end TAUR_INSPEVNT_SUPRATING_WARN;
/