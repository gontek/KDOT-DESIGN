CREATE OR REPLACE TRIGGER pontis.TAUR_URWY_VCLR_CHANGE_EMAIL
  after update of vclr_n, vclr_s, vclr_e, vclr_w on pontis.userrway  
  for each row 
 
-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: TAUR_URWY_VCLR_CHANGE_EMAIL
-- After update trigger to alert John C that a vertical underclearance field record was updated.
-----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

--  4/27/2016 (BLB) Added to the project by Brooke to update John C. of any vertical underclearance changes, KDOT

-----------------------------------------------------------------------------------------------------------------------------------------
 WHEN ((nvl( new.vclr_n, -1 ) <>  nvl( old.vclr_n, -1 ) and new.on_under <> '1') or
    ( nvl( new.vclr_s, -1) <> nvl(old.vclr_s,-1) and new.on_under <> '1') or
    ( nvl(new.vclr_e, -1) <> nvl(old.vclr_e,-1) and new.on_under <> '1') or
    ( nvl(new.vclr_w,-1) <> nvl(old.vclr_w,-1) and new.on_under <> '1')) declare
   ls_email_list          ksbms_robot.ds_config_options.optionvalue%TYPE;
   lex_email_failed       EXCEPTION;
   lex_unsupported_case   EXCEPTION; 
  
        
begin
     -- Get alert list from KSBMS_ROBOT.DS_CONFIG_OPTIONS
     
     ls_email_list := nvl( ksbms_util.f_get_coption_value('EMAIL_DEB_ONLY_LIST'),'brookeb@ksdot.org,johnc@ksdot.org');
   
      -- send warning statement as mail message
     
    if ksbms_util.f_email( ls_email_list, 'A vertical underclearance value has been changed for bridge '||:old.brkey||' by user '|| USER || ' on ' || to_char(sysdate)||'. Please make sure to update K-TRIPS. ','New underclearance value for Bridge '||:old.brkey)
    then 
            raise lex_email_failed;
     
           
     else -- Unhandled case
        -- This will raise as an unhandled user error
        raise lex_unsupported_case; -- Does this work?
     end if;

   exception
     WHEN lex_email_failed THEN
          dbms_output.put_line ('ksbms_util.f_email(l,m,s) function call failed processing Trigger TAUR_URWY_VCLR_CHANGE_EMAIL failed');
     WHEN lex_unsupported_case THEN
          dbms_output.put_line ('Unsupported case encountered processing Trigger TAUR_URWY_VCLR_CHANGE_EMAIL failed');
     
     WHEN OTHERS THEN
        dbms_output.put_line ('Trigger TAUR_URWY_VCLR_CHANGE_EMAIL');


  
 
end TAUR_USWY_VCLR_CHANGE_EMAIL;
/