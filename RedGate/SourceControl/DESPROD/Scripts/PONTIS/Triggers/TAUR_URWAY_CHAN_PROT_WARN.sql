CREATE OR REPLACE TRIGGER pontis.TAUR_URWAY_CHAN_PROT_WARN
  after update of chan_prot_left, chan_prot_right on pontis.userrway  
  for each row 
 
-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: tTAUR_URWAY_CHAN_PROT_WARN
-- After update trigger to alert Design staff that a channel protection field 
-- that wasn't a stream underrecord was updated erroneously.  This update would not migrate
-- to the ds_change_log and ultimately CANSYSII, but if they want a channel protection left update 
-- for the structure, the update should only be made on a stream underrecord.
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

--  2003-02-20 Added to the project by Deb to ensure channel protection update integrity, KDOT

-----------------------------------------------------------------------------------------------------------------------------------------

  WHEN ( (nvl( new.chan_prot_left, '_' ) <>  nvl( old.chan_prot_left, '_' ) and new.on_under = '1') or
  (nvl( new.chan_prot_right, '_' ) <>  nvl( old.chan_prot_right, '_' ) and new.on_under = '1')) declare
   ls_email_list          ksbms_robot.ds_config_options.optionvalue%TYPE;
   lex_email_failed       EXCEPTION;
   lex_unsupported_case   EXCEPTION;
   ls_user                paramtrs.longdesc%type;
        
begin
     -- Get alert list from KSBMS_ROBOT.DS_CONFIG_OPTIONS
     
     ls_email_list := nvl( ksbms_util.f_get_coption_value('EMAIL_ALERT_LIST'),'deb@ksdot.org');
     ls_user := pontis.f_get_username;
     
   if (:new.on_under = '1')
   then
       
     -- send warning statement as mail message
     
    if ksbms_util.f_email( ls_email_list, 'Caution! A channel protection update has occurred to the wrong roadway(userrway) record for brkey '||:old.brkey||' by user '|| ls_user || ' on ' || to_char(sysdate)||'.  Only stream record changes to channel protection populate to CANSYSII.', 'Please double check Bridge '||:old.brkey ) 
    then 
            raise lex_email_failed;
       end if;
       
     
     else -- Unhandled case
        -- This will raise as an unhandled user error
        raise lex_unsupported_case; -- Does this work?
     end if;

   exception
     WHEN lex_email_failed THEN
          dbms_output.put_line ('ksbms_util.f_email(l,m,s) function call failed processing Trigger TAUR_URWAY_CHAN_PROT_WARN failed');
     WHEN lex_unsupported_case THEN
          dbms_output.put_line ('Unsupported case encountered processing Trigger TAUR_URWAY_CHAN_PROT_WARN failed');
     
     WHEN OTHERS THEN
        dbms_output.put_line ('Trigger taur_chan_prot_left_upd_warn failed');


  
end TAUR_URWAY_CHAN_PROT_WARN;
/