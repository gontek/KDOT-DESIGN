CREATE OR REPLACE trigger pontis.taur_ubrdg_longitude_warn
  after update of kdot_longitude on pontis.userbrdg
   for each row
-- Summary: A trigger on the Pontis exchange table to warn us when kdot_longitude is unexpectedly set to null
--          by BrM<BR>
  -- %revision-history <BR>
  -- created:  Created by dk 2015-07-28<BR>
  -- revised:  <BR>
  -- <p id="doc_save_date" style="margin: 0;">documentation revised: 2015-07-10</p><p id="doc_mod_date" style="margin: 0;"></p>
  -- %copyright-notice Kansas Department of Transportation, 2015 - all rights reserved
  -- %kdot-contact Ms. Deb Kossler, Bureau of Structures and Geotechnical Services, Bridge Management<BR>
  -- <a href="mailto:deb@ksdot.org?Subject="Documentation%20Question%20re:%20taur_ubrdg_longitude_warn">Email questions about tair_ds_change_log_valid</a><BR>
  -- %developer-info Allen R. Marshall, ARM LLC
  -- <BR>ph: 617-335-6934
  -- <BR><a href="http://allenrmarshall-consulting-llc.com" alt="Link to developer website">Visit developer website</a>
  -- <BR><a href="mailto:armarshall@allenrmarshall-consulting-llc.com?Subject="Documentation%20Question%20re:%20taur_ubrdg_longitude_warn">Email questions about tair_ds_change_log_valid</a><BR>
  -- %development-environment
  -- Oracle Database 11g Release 11.2.0.4.0<BR>
  -- OCI: version 11.1
  -- %param
  -- %usage Created to notify us when kdot_longitude is set to null by the BrM product...should not be happening...hopefully this is temporary
  -- %raises message if the trigger is invalid
  -- %return a successful email we're correctly notified when longitude is set to null
  -- %see   
    
declare
  ls_email_list ksbms_robot.ds_config_options.optionvalue%TYPE;
  lex_email_failed     EXCEPTION;
  lex_unsupported_case EXCEPTION;
  ls_user paramtrs.longdesc%type;
begin
  -- Get alert list from KSBMS_ROBOT.DS_CONFIG_OPTIONS

  ls_email_list := nvl(ksbms_util.f_get_coption_value('EMAIL_DATA_ENTRY_LIST'),
                       'deb@ksdot.org');
  ls_user       := pontis.f_get_username;

  if (:new.kdot_longitude is null)
  
   then
  
    -- send deleted attachment statement as mail message
  
    if ksbms_util.f_email(ls_email_list,
                          'An unauthorized change of kdot_longitude from '||
                          :old.kdot_longitude || ' to ' || :new.kdot_longitude ||
                          ' for Bridge ' || :old.brkey || ' was made because of BrM ' ||' by user ' || ls_user ||
                          ' on ' || to_char(sysdate) ||
                          '.  kdot_longitude needs to be put back in.  No you cannot just fix it from the BrM screen...have to fix it in the data table...how stupid is that?!!!',
                          'ATTENTION: A stupid BrM unauthorized longitude change occurred for Bridge ' ||
                          :old.brkey) then
      raise lex_email_failed;
    end if;
  
  else
    -- Unhandled case
    -- This will raise as an unhandled user error
    raise lex_unsupported_case; -- Does this work?
  end if;

exception
  WHEN lex_email_failed THEN
    dbms_output.put_line('ksbms_util.f_email(l,m,s) function call failed processing Trigger taur_ubrdg_longitude_warn failed');
  WHEN lex_unsupported_case THEN
    dbms_output.put_line('Unsupported case encountered processing Trigger taur_ubrdg_longitude_warn failed');
  
  WHEN OTHERS THEN
    dbms_output.put_line('Trigger taur_ubrdg_longitude_warn failed');
  
end TAUR_UBRDG_FUNCTION_TYPE_WARN;
/