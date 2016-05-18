CREATE OR REPLACE TRIGGER pontis.TAUR_TOLL_KDOT_UPD_WARN
  after update of toll_kdot on pontis.userrway  
  for each row 
 
-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_berm_prot_upd__warn
-- After update trigger to alert Design staff that a toll_kdot field record
-- had been changed for the wrong roadway/userrway record (under-record instead of on_record.
-- These updates should only be made for the on_record row.
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

--  2009-09-16 Added to the project by Deb to ensure toll_kdot integrity 
-----------------------------------------------------------------------------------------------------------------------------------------
  WHEN (nvl( new.toll_kdot, '_' ) <>  nvl( old.toll_kdot, '_' )) declare
   ls_email_list          ksbms_robot.ds_config_options.optionvalue%TYPE;
   lex_email_failed       EXCEPTION;
   lex_unsupported_case   EXCEPTION; 
   ls_toll_kdot userrway.berm_prot%type;
        
begin
     -- Get alert list from KSBMS_ROBOT.DS_CONFIG_OPTIONS
     
     ls_email_list := nvl( ksbms_util.f_get_coption_value('EMAIL_DATA_ENTRY_LIST'),'deb@ksdot.org, mitch@ksdot.org');
   
   if (:new.on_under <> 1)
   then
       
     -- send warning statement as mail message
     
    if ksbms_util.f_email( ls_email_list, 'Oops! An incorrect change to an underrecord was made to "toll facility" on bridge '||:old.brkey||' by user '|| USER || ' on ' || to_char(sysdate)||'.  These updates should only be made to the ONRECORD of a structure!!', 'Please double check and fix Bridge '||:old.brkey ) 
    then 
            raise lex_email_failed;
       end if;
       
     
     else -- Unhandled case
        -- This will raise as an unhandled user error
        raise lex_unsupported_case; -- Does this work?
     end if;

   exception
     WHEN lex_email_failed THEN
          dbms_output.put_line ('ksbms_util.f_email(l,m,s) function call failed processing Trigger TAUR_TOLL_KDOT_UPD_WARN failed');
     WHEN lex_unsupported_case THEN
          dbms_output.put_line ('Unsupported case encountered processing Trigger TAUR_TOLL_KDOT_UPD_WARN failed');
     
     WHEN OTHERS THEN
        dbms_output.put_line ('Trigger taur_berm_prot_upd_warn failed');


  
end TAUR_TOLL_KDOT_UPD_WARN;
/