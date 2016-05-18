CREATE OR REPLACE TRIGGER ksbms_robot.TAIR_DS_CHANGE_LOG_VALID
after insert on ksbms_robot.ds_change_log
for each row



-- 08.27.2009 DK  After update check to make sure valid users are making updates 

declare
   ls_email_list         ksbms_robot.ds_config_options.optionvalue%TYPE;
   lex_email_failed      EXCEPTION;
   lex_unsupported_case  EXCEPTION;
   
   
begin
   -- Get email_it_only_list from ksbms_robot.ds_config_options
   
   ls_email_list := nvl(ksbms_util.f_get_coption_value('EMAIL_IT_ONLY_LIST'),'deb@ksdot.org');

   IF UPPER(:new.createuserid) not in ('RWHOWARD','KSBMS_ROBOT','PONTIS','BROOKEB','DEB','KDOT','DANIELC') THEN
   
   --send warning statement email 
   
  IF  ksbms_util.f_email( ls_email_list, 'An unexpected userdoof made changes to Pontis using entry '||:new.entry_id||' by user '|| :new.createuserid || ' ON ' || TO_CHAR(SYSDATE)||'. Somebody needs to check this out before the next sync!!',  'ATTENTION:  An unauthorized change was made to Pontis data.  Please check ASAP!!')  then
   raise lex_email_failed;
   end if;
   
   else -- Unhandled case
     -- this will raise as an unhandled user error
     raise lex_unsupported_case;
   END IF;
   
   EXCEPTION
   WHEN lex_email_failed THEN
        dbms_output.put_line ('ksbms_util.f_email(l,m,s) function call failed processing Trigger TAIR_DS_CHANGE_LOG_VALID');
   WHEN lex_unsupported_case THEN
        dbms_output.put_line ('Successfully processed Trigger TAIR_DS_CHANGE_LOG_VALID');
        
   WHEN OTHERS THEN
     dbms_output.put_line ('Trigger TAIR_DS_CHANGE_LOG_VALID failed');
     
          
END TAIR_DS_CHANGE_LOG_VALID;
/