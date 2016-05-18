CREATE OR REPLACE TRIGGER pontis.TAUR_UINSP_OPEN_NOTICE
  after update of oppostcl_kdot on pontis.userinsp
  for each row
-----------------------------------------------------------------------------------------------------------------------------------------
  -- Trigger: TAUR_UINSP_OPEN_NOTICE
  -- An after update trigger to remind our staff that oppostcl_kdot was set to 1 (OPEN)
  --  and yearbuilt field needs to be updated.
  -----------------------------------------------------------------------------------------------------------------------------------------

  ------------------------------------------------------------------------------------------------------------------------------------------
  -- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
  -----------------------------------------------------------------------------------------------------------------------------------------

  -----------------------------------------------------------------------------------------------------------------------------------------
  -- Revision History:

  --  2004-08-12 Added to the project by Deb, KDOT
  -----------------------------------------------------------------------------------------------------------------------------------------

  WHEN (nvl (new.oppostcl_kdot, '<MISSING>') <> nvl
  (old.oppostcl_kdot, '<MISSING>'))
declare
  ls_email_list ksbms_robot.ds_config_options.optionvalue%TYPE;
  lex_email_failed     EXCEPTION;
  lex_unsupported_case EXCEPTION;
  ls_oppostcl_kdot userinsp.oppostcl_kdot%type;
  v_descrip_old    paramtrs.shortdesc%type;
  v_descrip_new    paramtrs.shortdesc%type;
  ls_user          paramtrs.longdesc%type;
begin
  -- Get alert list from KSBMS_ROBOT.DS_CONFIG_OPTIONS

  ls_email_list := nvl(ksbms_util.f_get_coption_value('EMAIL_BRIDGE_OPEN_LIST'),
                       'deb@ksdot.org');
  v_descrip_old := f_get_paramtrs_equiv_long('USERINSP',
                                             'OPPOSTCL_KDOT',
                                             :old.OPPOSTCL_KDOT);
  v_descrip_new := f_get_paramtrs_equiv_long('USERINSP',
                                             'oppostcl_kdot',
                                             :new.oppostcl_kdot);
  ls_user := pontis.f_get_username;

  if (:new.oppostcl_kdot = '1') and user = 'KSBMS_ROBOT'
  
   then
  
    -- send warning statement as mail message
  
    if ksbms_util.f_email(ls_email_list,
                          'Bridge status changed from ' || '"' ||
                          v_descrip_old || '"' || ' to ' || '"' ||
                          v_descrip_new || '"' || ' for brkey ' ||
                          :old.brkey || ' by user ' || ls_user || ' on ' ||
                          to_char(sysdate) || '. ',
                          'ATTENTION: Bridge ' || :old.brkey ||
                          ' has been updated to ' || '"' || v_descrip_new || '"' ||
                          ' status!!') then
      raise lex_email_failed;
    end if;
  
  else
    -- Unhandled case
    -- This will raise as an unhandled user error
    raise lex_unsupported_case; -- Does this work?
  end if;

exception
  WHEN lex_email_failed THEN
    dbms_output.put_line('ksbms_util.f_email(l,m,s) function call failed processing Trigger TAUR_OPPOSTCL_OPEN_NOTICE failed');
  WHEN lex_unsupported_case THEN
    dbms_output.put_line('Unsupported case encountered processing Trigger TAUR_OPPOSTCL_OPEN_NOTICE');
  
  WHEN OTHERS THEN
    dbms_output.put_line('Trigger TAUR_OPPOSTCL_OPEN_NOTICE failed');
  
end TAUR_UINSP_OPEN_NOTICE;
/