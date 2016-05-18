CREATE OR REPLACE TRIGGER pontis.TAUR_BRIDGE_DISTRICT_WARN
   after update of district on pontis.bridge
   for each row
-----------------------------------------------------------------------------------------------------------------------------------------
-- After INSERT trigger to notify KDOT staff someone else made a district field changed
-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

-- 2008.11.13 - Deb, KDOT -- added to project
-- 2011.09.20 - DK, KDOT -- modified to specify users
-----------------------------------------------------------------------------------------------------------------------------------------


  WHEN (nvl(new.district,'<MISSING>')<> nvl(old.district, '<MISSING>')and
          new.district <> '9' and
          new.yearbuilt <> '1000') declare
   ls_email_list          ksbms_robot.ds_config_options.optionvalue%TYPE;
   lex_email_failed       EXCEPTION;
   lex_unsupported_case   EXCEPTION; 
   ls_user                paramtrs.longdesc%type;
     
begin
     -- Get alert list from KSBMS_ROBOT.DS_CONFIG_OPTIONS
     
     ls_email_list := nvl( ksbms_util.f_get_coption_value('EMAIL_IT_ONLY_LIST'),'deb@ksdot.org');
      ls_user := pontis.f_get_username;
      
 if (ls_user not in ('RWHOWARD', 'PONTIS','KATHY','BROOKEB'))
  
     -- send notification to IT staff

THEN     
      if ksbms_util.f_email( 
     ls_email_list,
     'A district has been changed from '
     ||:old.district
     ||' to ' 
     ||:new.district
     ||' for structure '
     ||:old.brkey
     ||' by user '
     || ls_user 
     || ' on ' 
     ||to_char(sysdate)
     ||'. This should be checked and possibly corrected?', 
     'ATTENTION: An update to district has occurred to '
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
          dbms_output.put_line ('ksbms_util.f_email(l,m,s) function call failed processing Trigger  failed');
     WHEN lex_unsupported_case THEN
          dbms_output.put_line ('Unsupported case encountered processing Trigger TAUR_BRIDGE_DISTRICT_WARN');
     
     WHEN OTHERS THEN
        dbms_output.put_line ('Trigger TAUR_BRIDGE_DISTRICT_WARN failed');

end TAUR_BRIDGE_DISTRICT_WARN;
/