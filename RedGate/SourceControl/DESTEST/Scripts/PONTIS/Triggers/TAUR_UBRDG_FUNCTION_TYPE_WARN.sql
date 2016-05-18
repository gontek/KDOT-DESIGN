CREATE OR REPLACE Trigger pontis.taur_ubrdg_function_type_warn

-- Summary: After update trigger to IT staff that an unauthorized change to function type has occurred
--          <BR>
  -- %revision-history <BR>
  -- created: 2008-05-13  Added to the project by Deb  KDOT<BR>
  -- revised:  <BR>
  -- <p id="doc_save_date" style="margin: 0;">documentation revised: 2015-07-10</p><p id="doc_mod_date" style="margin: 0;"></p>
  -- %copyright-notice Kansas Department of Transportation, 2015 - all rights reserved
  -- %kdot-contact Ms. Deb Kossler, Bureau of Structures and Geotechnical Services, Bridge Management<BR>
  -- <a href="mailto:deb@ksdot.org?Subject="Documentation%20Question%20re:%20taur_ubrdg_function_type_warn">Email questions about taur_ubrdg_function_type_warn</a><BR>
  -- %developer-info Allen R. Marshall, ARM LLC
  -- <BR>ph: 617-335-6934
  -- <BR><a href="http://allenrmarshall-consulting-llc.com" alt="Link to developer website">Visit developer website</a>
  -- <BR><a href="mailto:armarshall@allenrmarshall-consulting-llc.com?Subject="Documentation%20Question%20re:%20taur_ubrdg_function_type_warn">Email questions about taur_ubrdg_function_type_warn</a><BR>
  -- %development-environment
  -- Oracle Database 11g Release 11.2.0.4.0<BR>
  -- OCI: version 11.1
  -- %param
  -- %usage Created to notify us when function_type is set to null 
  -- %raises message if the trigger is invalid
  -- %return a successful email when data change occurs
  -- %see   
  after update of function_type on pontis.userbrdg
   for each row

declare
   ls_email_list          ksbms_robot.ds_config_options.optionvalue%TYPE;
   lex_email_failed       EXCEPTION;
   lex_unsupported_case   EXCEPTION;
   ls_user               paramtrs.longdesc%type; 
           
begin
     -- Get alert list from KSBMS_ROBOT.DS_CONFIG_OPTIONS
     
     ls_email_list := nvl( ksbms_util.f_get_coption_value('EMAIL_DATA_ENTRY_LIST'),'deb@ksdot.org');
     ls_user := pontis.f_get_username;
   
   if (:new.function_type is null)
   
   then
       
     -- send deleted attachment statement as mail message
     
       if ksbms_util.f_email( ls_email_list, 'An unauthorized change of function type for '||:old.brkey||' was made by user '|| ls_user || ' on ' || to_char(sysdate)||'.  System needs to be checked.', 'ATTENTION: An unauthorized function type change occurred for Bridge '||:old.brkey ) then 
            raise lex_email_failed;
       end if;
       
     
     else -- Unhandled case
        -- This will raise as an unhandled user error
        raise lex_unsupported_case; -- Does this work?
     end if;

   exception
     WHEN lex_email_failed THEN
          dbms_output.put_line ('ksbms_util.f_email(l,m,s) function call failed processing Trigger taur_ubrdg_function_type_warn failed');
     WHEN lex_unsupported_case THEN
          dbms_output.put_line ('Unsupported case encountered processing Trigger taur_ubrdg_function_type_warn failed');
     
     WHEN OTHERS THEN
        dbms_output.put_line ('Trigger taur_ubrdg_function_type_warn failed');

end TAUR_UBRDG_FUNCTION_TYPE_WARN;
/