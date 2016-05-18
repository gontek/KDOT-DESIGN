CREATE OR REPLACE Trigger pontis.TAUR_USBRG_RATING_ADJ_WARN
   after update of rating_adj on pontis.userbrdg
   for each row
-----------------------------------------------------------------------------------------------------------------------------------------
-- After INSERT trigger to notify KDOT staff that rating_adj field changed
-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

-- 2008.06.17 - Deb, KDOT -- added to project
-----------------------------------------------------------------------------------------------------------------------------------------


 
when (nvl(new.rating_adj,'<MISSING>')<> nvl(old.rating_adj, '<MISSING>'))
declare
   ls_email_list          ksbms_robot.ds_config_options.optionvalue%TYPE;
   lex_email_failed       EXCEPTION;
   lex_unsupported_case   EXCEPTION; 
   ls_user               paramtrs.longdesc%type;  
begin
     -- Get alert list from KSBMS_ROBOT.DS_CONFIG_OPTIONS
     
     ls_email_list := nvl( ksbms_util.f_get_coption_value('EMAIL_RATING_ADJ_CHNG_LIST'),'deb@ksdot.org');
     ls_user := pontis.f_get_username;
     
  if (:old.rating_adj is not null) or 
  (:old.rating_adj is null and :new.rating_adj = 'Y')

 THEN
 
     -- send notification to load rater staff
     
      if ksbms_util.f_email( 
     ls_email_list,
     'A load rating adjustment was changed from '
     ||:old.rating_adj
     ||' to ' 
     ||:new.rating_adj
     ||' for structure '
     ||:old.brkey
     ||' by user '
     || ls_user
     || ' on ' 
     ||to_char(sysdate)
     ||'.  The load rating personnel wanted to know whenever this occurred.', 
     'ATTENTION: A load rating adjustment change has occurred for structure '
     ||:old.brkey
 )    
THEN 
raise lex_email_failed;
end if;

else -- Unhandled case
        -- This will raise as an unhandled user error
        raise lex_unsupported_case; -- Does this work?
     end if;
     
exception
     WHEN lex_email_failed THEN
          dbms_output.put_line ('ksbms_util.f_email(l,m,s) function call failed processing Trigger TAUR_USBRG_RATING_ADJ_WARN failed');
     WHEN lex_unsupported_case THEN
          dbms_output.put_line ('Successful processing of Trigger TAUR_USBRG_RATING_ADJ_WARN');
     
     WHEN OTHERS THEN
        dbms_output.put_line ('Trigger TAUR_USBRG_RATING_ADJ_WARN failed');
           
end TAUR_USBRG_RATING_ADJ_WARN;
/