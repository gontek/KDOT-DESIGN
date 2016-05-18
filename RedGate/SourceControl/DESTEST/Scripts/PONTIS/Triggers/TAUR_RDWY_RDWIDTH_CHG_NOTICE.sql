CREATE OR REPLACE TRIGGER pontis.TAUR_RDWY_RDWIDTH_CHG_NOTICE
  after update of roadwidth on pontis.roadway  
  for each row
 -----------------------------------------------------------------------------------------------------------------------------------------
-- After INSERT trigger to notify KDOT staff that roadwidth of bridge has changed and deck area needs to be updated.
-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

-- 2009.12.31 - Deb, KDOT -- added to project
-----------------------------------------------------------------------------------------------------------------------------------------


  DISABLE WHEN (nvl(new.roadwidth,-9)<> nvl(old.roadwidth, -9)) declare
   ls_email_list          ksbms_robot.ds_config_options.optionvalue%TYPE;
   lex_email_failed       EXCEPTION;
   lex_unsupported_case   EXCEPTION; 
   ls_user                PARAMTRS.LONGDESC%TYPE;

     
begin
     -- Get mailing list from KSBMS_ROBOT.DS_CONFIG_OPTIONS
     
     ls_email_list := nvl( ksbms_util.f_get_coption_value('EMAIL_DEB_ONLY'),'deb@ksdot.org');
     ls_user  := pontis.f_get_username;
     
if ( :old.on_under = '1')

then 
     -- send notification IT staff
   
      if ksbms_util.f_email( 
     ls_email_list,
     'Roadway roadwidth has been changed from '
     ||:old.roadwidth
     ||' to ' 
     ||:new.roadwidth
     ||' for structure '
     ||:old.brkey
     ||' by user '
     || ls_user
     || ' on ' 
     ||to_char(sysdate)
     ||'.  Please be sure to update deck area and NBI_47 and run validation for project data DEB!!!.', 
     'ATTENTION: A change in roadway roadwidth has occurred to '
     ||:old.brkey
 )    
THEN
  RAISE lex_email_failed; 
END if;

else -- Unhandled case
     -- This will raise as an unhandled user error
     raise lex_unsupported_case;  -- does this work?
  end if;
     

   exception
     WHEN lex_email_failed THEN
          dbms_output.put_line ('ksbms_util.f_email(l,m,s) function call processing Trigger TAUR_RDWY_RDWIDTH_CHG_NOTICE failed');
     WHEN lex_unsupported_case THEN
          dbms_output.put_line ('Unsupported case encountered processing Trigger TAUR_RDWY_RDWIDTH_CHG_NOTICE');
     
     WHEN OTHERS THEN
        dbms_output.put_line ('Trigger TAUR_RDWY_RDWIDTH_CHG_NOTICE failed');

  
end TAUR_RDWY_RDWIDTH_CHG_NOTICE;
/