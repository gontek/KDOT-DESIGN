CREATE OR REPLACE TRIGGER pontis.TAUR_UINSP_DEL_FC_INTVL_WARN
  after update of fcinspfreq_kdot on pontis.userinsp  
  for each row
-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: TAUR_UINSP_DEL_FC_INTVL_WARN
-- An after update trigger to remind users that updates of this field to
-- null cannot be done from Pontis...need to be done on the Cansys side
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

--  2010-05-27 Added to the project by Deb, KDOT
--  
-----------------------------------------------------------------------------------------------------------------------------------------
 
  WHEN ( nvl(new.fcinspfreq_kdot,-1 ) <>  nvl( old.fcinspfreq_kdot, -1 )) declare
   ls_email_list          ksbms_robot.ds_config_options.optionvalue%TYPE;
   lex_email_failed       EXCEPTION;
   lex_unsupported_case   EXCEPTION;
   
       
begin
     -- Get email_data_entry_list from KSBMS_ROBOT.DS_CONFIG_OPTIONS
     
     ls_email_list := nvl( ksbms_util.f_get_coption_value('EMAIL_DATA_ENTRY_LIST'),'deb@ksdot.org');
 

 if ( :old.fcinspfreq_kdot is not null) and
    (:new.fcinspfreq_kdot is null) and
       user not in ('KSBMS_ROBOT') 
 
   
   then
  
      -- send warning statement as mail message
     
       if ksbms_util.f_email( ls_email_list, 'The fracture critical inspection interval has been changed from '||:old.fcinspfreq_kdot||' to null for structure '||:old.brkey||' by user '|| USER || ' on ' || to_char(sysdate)||'.  Deletion of ANY inspection interval ALWAYS has to be made from Cansys!!  PLEASE FIX!  PLEASE FIX!', 'ATTENTION: An fracture critical inspection interval has been DELETED for '||:old.brkey||' from Pontis instead of Cansys!') then 
            raise lex_email_failed;
       end if;
     
    else -- Unhandled case
        -- This will raise as an unhandled user error
        raise lex_unsupported_case; -- Does this work?
     end if;

   exception
     WHEN lex_email_failed THEN
          dbms_output.put_line ('ksbms_util.f_email(l,m,s) function call failed processing Trigger TAUR_UINSP_DEL_FC_INTVL_WARN failed');
     WHEN lex_unsupported_case THEN
          dbms_output.put_line ('Unsupported case encountered processing Trigger TAUR_UINSP_DEL_FC_INTVL_WARN');
     
     WHEN OTHERS THEN
        dbms_output.put_line ('Trigger TAUR_UINSP_DEL_FC_INTVL_WARN failed');

end TAUR_UINSP_DEL_FC_INTVL_WARN;
/