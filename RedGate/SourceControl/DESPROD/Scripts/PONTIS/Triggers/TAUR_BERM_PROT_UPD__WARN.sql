CREATE OR REPLACE Trigger pontis.TAUR_BERM_PROT_UPD__WARN
  after update of berm_prot on pontis.userrway  
  for each row 
 
-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_berm_prot_upd__warn
-- After update trigger to alert Design staff that a berm protection field record
-- that wasn't the on_record was updated inadvertently.  This change would not migrate
-- to the ds_change_log and ultimately CANSYSII, but if they wanted a berm protection notation
-- for the structure, the update should only be made for the on_record row.
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

--  2003-02-20 Added to the project by Deb to ensure berm_prot integrity, KDOT

-----------------------------------------------------------------------------------------------------------------------------------------

when (nvl( new.berm_prot, '_' ) <>  nvl( old.berm_prot, '_' ) )
declare
   ls_email_list          ksbms_robot.ds_config_options.optionvalue%TYPE;
   lex_email_failed       EXCEPTION;
   lex_unsupported_case   EXCEPTION;
   ls_user                paramtrs.longdesc%type;
 
        
begin
     -- Get alert list from KSBMS_ROBOT.DS_CONFIG_OPTIONS
     
     ls_email_list := nvl( ksbms_util.f_get_coption_value('EMAIL_DATA_ENTRY_LIST'),'deb@ksdot.org, mitch@ksdot.org');
     ls_user := pontis.f_get_username;
     
   if (:new.on_under <> 1)
   then
       
     -- send warning statement as mail message
     
    if ksbms_util.f_email( ls_email_list, 'Caution! Berm Protection update was inadvertently made to an underrecord for bridge '||:old.brkey||' by user '|| ls_user || ' on ' || to_char(sysdate)||'.  These updates should be to the onrecord or the change will not get to Cansys!!', 'Please double check and fix Bridge '||:old.brkey ) 
    then 
            raise lex_email_failed;
       end if;
       
     
     else -- Unhandled case
        -- This will raise as an unhandled user error
        raise lex_unsupported_case; -- Does this work?
     end if;

   exception
     WHEN lex_email_failed THEN
          dbms_output.put_line ('ksbms_util.f_email(l,m,s) function call failed processing Trigger TAUR_BERM_PROT_UPD_WARN failed');
     WHEN lex_unsupported_case THEN
          dbms_output.put_line ('Unsupported case encountered processing Trigger taur_berm_prot_upd_warn failed');
     
     WHEN OTHERS THEN
        dbms_output.put_line ('Trigger taur_berm_prot_upd_warn failed');


  
end TAUR_BERM_PROT_UPD_WARN;
/