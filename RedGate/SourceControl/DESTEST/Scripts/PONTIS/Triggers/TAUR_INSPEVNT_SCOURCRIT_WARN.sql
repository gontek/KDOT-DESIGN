CREATE OR REPLACE TRIGGER pontis.TAUR_INSPEVNT_SCOURCRIT_WARN
  after update of scourcrit on pontis.inspevnt
   for each row
-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: TAUR_INSPEVNT_SCOURCRIT_WARN
-- An after update trigger to let FOLKS WHO CARE know that a scour critical value has been changed (and they might not like it!).
-- so they can ensure data integrity.
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

--  2006-9-15 Added to the project by Deb, KDOT
-----------------------------------------------------------------------------------------------------------------------------------------
 
  DISABLE WHEN ( nvl(new.scourcrit, '<MISSING>' ) <>  nvl( old.scourcrit, '<MISSING>' )) declare
   ls_email_list          ksbms_robot.ds_config_options.optionvalue%TYPE;
   lex_email_failed       EXCEPTION;
   lex_unsupported_case   EXCEPTION;
   
       
begin
     -- Get email_scourcrit_change_warning list from KSBMS_ROBOT.DS_CONFIG_OPTIONS
     
     ls_email_list := nvl( ksbms_util.f_get_coption_value('EMAIL_SCOURCRIT_CHANGE_WARNING'),'deb@ksdot.org');
 
     -- specify conditions for email to be sent
 if ( :old.scourcrit in ('2','3','6'))  or
   ( :new.scourcrit in ('2','3','6'))
   
THEN
  
      -- send warning statement as mail message
     
if ksbms_util.f_email( 
     ls_email_list,
     'A scour critical rating has been changed from '
     ||:old.scourcrit
     ||' to ' 
     ||:new.scourcrit
     ||' for structure '
     ||:old.brkey
     ||' by user '
     || USER 
     || ' on ' 
     ||to_char(sysdate)
     ||'.  Make sure this is correct for this structure.', 
     'ATTENTION: A scour critical rating has been changed on '
     ||:old.brkey
     
     )
THEN 
    RAISE lex_email_failed;
END IF;
     
    else -- Unhandled case
        -- This will raise as an unhandled user error
        raise lex_unsupported_case; -- Does this work?
     end if;

   exception
     WHEN lex_email_failed THEN
          dbms_output.put_line ('ksbms_util.f_email(l,m,s) function call failed processing Trigger TAUR_INSPEVNT_SCOURCRIT_WARN failed');
     WHEN lex_unsupported_case THEN
          dbms_output.put_line ('Unsupported case encountered processing Trigger TAUR_INSPEVNT_SCOURCRIT_WARN');
     
     WHEN OTHERS THEN
        dbms_output.put_line ('Trigger TAUR_INSPEVNT_SCOURCRIT_WARN failed');

end TAUR_INSPEVNT_SCOURCRIT_WARN;
/