CREATE OR REPLACE TRIGGER pontis.taidr_pon_elem_insp_warn
   after insert
   on pontis.pon_elem_insp
   for each row
-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taidr_pon_elem_insp_warn
-- After INSERT trigger to notify KDOT staff that an outdated scour or deck cracking defect was entered
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

-- 3.16.2016 Balsters: Create date
-----------------------------------------------------------------------------------------------------------------------------------------


declare
   ls_email_list          ksbms_robot.ds_config_options.optionvalue%TYPE;
   lex_email_failed       EXCEPTION;
   lex_unsupported_case   EXCEPTION;  
   ls_user                paramtrs.longdesc%type;  
   ls_elem_key            pon_elem_insp.elem_key%TYPE;
begin
     -- Get alert list from KSBMS_ROBOT.DS_CONFIG_OPTIONS
     
     ls_email_list := nvl( ksbms_util.f_get_coption_value('EMAIL_IT_ONLY_LIST'),'brookeb@ksdot.org');
     ls_user := pontis.f_get_username;
     ls_elem_key := :new.elem_key;
   -- What we e-mail depends on bad elem_key
  
   if ls_elem_key in('6000','1130')
   then
       
     -- send new BRIDGE_ID  as mail message
    
       if ksbms_util.f_email( ls_email_list, 'Attention: Element ' ||:new.elem_key||' was entered for Bridge '||:new.brkey||'  by user '|| ls_user || ' on ' || sysdate ||
       '. Please remind user that those elements are replaced by 858 for Deck Cracking and 861 for Scour. '
       , 'ATTENTION: BAD ELEMENT DATA FOR BRIDGE '|| :new.brkey ) then 
            raise lex_email_failed;
      end if;
         
  
     else -- Unhandled case
        -- This will raise as an unhandled user error
        raise lex_unsupported_case; -- Does this work?
     end if;

   exception
     WHEN lex_email_failed THEN
          dbms_output.put_line ('ksbms_util.f_email(l,m,s) function call failed processing Trigger  taidr_pon_elem_insp_warn failed');
     WHEN lex_unsupported_case THEN
          dbms_output.put_line ('Unsupported case encountered processing Trigger  taidr_pon_elem_insp_warn failed');
     
     WHEN OTHERS THEN
        dbms_output.put_line ('Trigger  taidr_pon_elem_insp_warn failed');

end  taidr_pon_elem_insp_warn;
/