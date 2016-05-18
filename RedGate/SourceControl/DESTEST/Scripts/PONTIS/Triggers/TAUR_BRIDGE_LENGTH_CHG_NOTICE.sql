CREATE OR REPLACE TRIGGER pontis.TAUR_BRIDGE_LENGTH_CHG_NOTICE
   after update of length on pontis.bridge
   for each row
-----------------------------------------------------------------------------------------------------------------------------------------
-- After INSERT trigger to notify KDOT staff that length of bridge has changed and deck area needs to be updated.
-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

-- 2009.12.31 - Deb, KDOT -- added to project
-----------------------------------------------------------------------------------------------------------------------------------------
  DISABLE WHEN (nvl( new.length, -9 ) <>  nvl( old.length, -9 )) declare
   ls_email_list          ksbms_robot.ds_config_options.optionvalue%TYPE;
   lex_email_failed       EXCEPTION;
   lex_unsupported_case   EXCEPTION; 
   ls_user paramtrs.longdesc%type;
     
begin
     -- Get mailing list from KSBMS_ROBOT.DS_CONFIG_OPTIONS
     
     ls_email_list := nvl( ksbms_util.f_get_coption_value('EMAIL_DEB_ONLY'),'deb@ksdot.org');
     ls_user := pontis.f_get_username;
     
     -- send notification IT staff
   
      if ksbms_util.f_email( 
     ls_email_list,
     'Bridge length has been changed from '
     ||:old.length
     ||' to ' 
     ||:new.length
     ||' for structure '
     ||:old.brkey
     ||' by user '
     || ls_user
     || ' on ' 
     ||to_char(sysdate)
     ||'.  Please be sure to update deck area also.', 
     'ATTENTION: A change in bridge length has occurred to '
     ||:old.brkey
 )    
THEN 
   RAISE lex_email_failed;
     
else -- Unhandled case
     -- This will raise as an unhandled user error
     raise lex_unsupported_case;  -- does this work?
end if;
     

   exception
     WHEN lex_email_failed THEN
          dbms_output.put_line ('ksbms_util.f_email(l,m,s) function call processing Trigger TAUR_BRIDGE_LENGTH_CHG_NOTICE failed');
     WHEN lex_unsupported_case THEN
          dbms_output.put_line ('Unsupported case encountered processing Trigger TAUR_BRIDGE_LENGTH_CHG_NOTICE');
     
     WHEN OTHERS THEN
        dbms_output.put_line ('Trigger TAUR_BRIDGE_LENGTH_CHG_NOTICE failed');

end TAUR_BRIDGE_LENGTH_CHG_NOTICE;
/