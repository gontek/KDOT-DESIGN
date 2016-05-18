CREATE OR REPLACE Trigger pontis.TAUR_UBRDG_UTILITY_DEL_WARN
  after update of attach_type_1,attach_type_2,attach_type_3 on pontis.userbrdg
   for each row
-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: TAUR_UBRDG_UTILITY_DEL_WARN
-- After update trigger to notify staff that an attachment(utility)
-- was removed and needs to be archived in CANSYS
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

--  2003-02-20 Added to the project by Deb & Mitch, KDOT
-----------------------------------------------------------------------------------------------------------------------------------------

 
when ((nvl( new.ATTACH_TYPE_1, '<MISSING>' ) <>  nvl( old.ATTACH_TYPE_1, '<MISSING>' )) or
       (nvl( new.ATTACH_TYPE_2, '<MISSING>' ) <>  nvl( old.ATTACH_TYPE_2, '<MISSING>' )) or
       (nvl( new.ATTACH_TYPE_3, '<MISSING>' ) <>  nvl( old.ATTACH_TYPE_3, '<MISSING>' )))
declare
   ls_email_list          ksbms_robot.ds_config_options.optionvalue%TYPE;
   lex_email_failed       EXCEPTION;
   lex_unsupported_case   EXCEPTION;
   ls_user                paramtrs.longdesc%type;     
begin
     -- Get alert list from KSBMS_ROBOT.DS_CONFIG_OPTIONS
     
     ls_email_list := nvl( ksbms_util.f_get_coption_value('EMAIL_ALERT_LIST'),'deb@ksdot.org');
     ls_user := pontis.f_get_username;
     
   if (:new.ATTACH_type_1 in ('0', '_' ))
   then
       
     -- send deleted attachment statement as mail message
     
       if ksbms_util.f_email( ls_email_list, 'Utility with ID = 1 for brkey '||:old.brkey||' was set as No Utilities Present by user '|| ls_user || ' on ' || to_char(sysdate)||'.  This utility needs to be enddated in CANSYS.', 'ATTENTION: Utility 1 was set to No Utilities Present for Bridge '||:old.brkey ) then 
            raise lex_email_failed;
       end if;
  
   ELSIF (:new.ATTACH_type_2 in ('0', '_' ))
   then
       
     -- send deleted attachment statement as mail message
     
       if ksbms_util.f_email( ls_email_list, 'Utility with ID = 2 for brkey '||:old.brkey||' was set as No Utilities Present by user '|| ls_user || ' on ' || to_char(sysdate)||'.  This utility needs to be enddated in CANSYS.', 'ATTENTION: Utility 2 was set to No Utilities Present for Bridge '||:old.brkey ) then 
            raise lex_email_failed;
       end if;
       
  ELSIF (:new.ATTACH_type_3 in ('0', '_' ))
   then
       
     -- send deleted attachment statement as mail message
     
       if ksbms_util.f_email( ls_email_list, 'Utility with ID = 3 for brkey '||:old.brkey||' was set as No Utilities Present by user '|| ls_user || ' on ' || to_char(sysdate)||'.  This utility needs to be enddated in CANSYS.', 'ATTENTION: Utility 3 was set to No Utilities Present for Bridge '||:old.brkey ) then 
            raise lex_email_failed;
       end if;     
             
     
     else -- Unhandled case
        -- This will raise as an unhandled user error
        raise lex_unsupported_case; -- Does this work?
     end if;

   exception
     WHEN lex_email_failed THEN
          dbms_output.put_line ('ksbms_util.f_email(l,m,s) function call failed processing Trigger TAUR_UBRDG_UTILITY_DEL_WARN failed');
     WHEN lex_unsupported_case THEN
          dbms_output.put_line ('Unsupported case encountered processing Trigger TAUR_UBRDG_UTILITY_DEL_WARN failed');
     
     WHEN OTHERS THEN
        dbms_output.put_line ('Trigger TAUR_UBRDG_UTILITY_DEL_WARN failed');

end TAUR_UBRDG_UTILITY_DEL_WARN;
/