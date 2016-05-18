CREATE OR REPLACE TRIGGER pontis.TAUR_UINSP_OPPOSTCL_KDOT_WARN
  after update of oppostcl_kdot on pontis.userinsp
  for each row
-----------------------------------------------------------------------------------------------------------------------------------------
  -- Trigger: TAUR_UINSP_OPPOSTCL_KDOT_WARN
  -- An after update trigger to warn our staff that oppostcl_kdot was set to a value other than 5 (New Structure)
  --  Only Planning opens a structure.  The value will NOT go to the exchange table and the databases won't match.
  --  Notification of Opening the Structure goes to Planning by memo only.
  -----------------------------------------------------------------------------------------------------------------------------------------

  ------------------------------------------------------------------------------------------------------------------------------------------
  -- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
  -----------------------------------------------------------------------------------------------------------------------------------------

  -----------------------------------------------------------------------------------------------------------------------------------------
  -- Revision History:

  --  2004-03-12 Added to the project by Deb, KDOT
  -----------------------------------------------------------------------------------------------------------------------------------------
  WHEN (nvl (new.oppostcl_kdot, '<MISSING>') <> nvl
  (old.oppostcl_kdot, '<MISSING>'))
declare
  ls_email_list ksbms_robot.ds_config_options.optionvalue%TYPE;
  lex_email_failed     EXCEPTION;
  lex_unsupported_case EXCEPTION;
  ls_oppostcl_kdot userinsp.oppostcl_kdot%type;
   ls_user             paramtrs.longdesc%type;

begin
  -- Get email_open/posted/closed list from KSBMS_ROBOT.DS_CONFIG_OPTIONS

  ls_email_list := nvl(ksbms_util.f_get_coption_value('EMAIL_OPPOSTCL_WARN_LIST'),
                       'deb@ksdot.org');
  ls_user := pontis.f_get_username;

  if (:new.oppostcl_kdot = '1') and user not in ('KSBMS_ROBOT') and
     substr(:old.brkey, 4, 1) <> '5'
  
   then
  
    -- send warning statement as mail message
  
    if ksbms_util.f_email(ls_email_list,
                          'Unexpected change made to Open_Posted_Closed for brkey ' ||
                          :old.brkey || ' by user ' || ls_user || ' on ' ||
                          to_char(sysdate) ||
                          '.  If OPENING do not forget additional fields to fix in CANSYS!!',
                          'ATTENTION: An unexpected change to Open/Posted/Closed Status in Pontis has occurred!!!!  See Brooke about bridge ' ||
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
    dbms_output.put_line('ksbms_util.f_email(l,m,s) function call failed processing Trigger TAUR_UINSP_OPPOSTCL_KDOT_WARN failed');
  WHEN lex_unsupported_case THEN
    dbms_output.put_line('Unsupported case encountered processing Trigger TAUR_UINSP_OPPOSTCL_KDOT_WARN');
  
  WHEN OTHERS THEN
    dbms_output.put_line('Trigger TAUR_UINSP_OPPOSTCL_KDOT_WARN failed');
  
end TAUR_UINSP_OPPOSTCL_KDOT_WARN;
/