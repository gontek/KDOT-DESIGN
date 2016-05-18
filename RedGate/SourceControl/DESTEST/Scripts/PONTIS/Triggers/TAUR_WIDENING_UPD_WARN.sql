CREATE OR REPLACE TRIGGER pontis.TAUR_WIDENING_UPD_WARN
  after update of wide_material, wide_type,wide_design_ty,wide_num_girders on pontis.userstrunit  
  for each row
-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: TAUR_WIDENING_UPD_WARN
-- An after update trigger to remind our staff that widening updates from the Pontis side
-- don't populate to CANSYSII.  They need to update CANSYSII to match POntis
-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

--  2010-8-5 revised to create one trigger instead of four, to handle notification of updates
--           to any widening field-- Deb, KDOT
-----------------------------------------------------------------------------------------------------------------------------------------   

  DISABLE WHEN ((nvl( new.wide_material, '<MISSING>' ) <>  nvl( old.wide_material, '<MISSING>' ))or
     (nvl( new.wide_type,'<MISSING>') <> nvl( old.wide_type, '<MISSING>' )) or
     (nvl( new.wide_design_ty,'<MISSING>') <> nvl( old.wide_design_ty, '<MISSING>' ))or
     (nvl( new.wide_num_girders,-1) <> nvl( old.wide_num_girders, -1 ))) DECLARE
   ls_email_list          ksbms_robot.ds_config_options.optionvalue%TYPE;
   lex_email_failed       EXCEPTION;
   lex_unsupported_case   EXCEPTION;
   ls_user                 paramtrs.longdesc%type;
BEGIN
   -- Get alert list from KSBMS_ROBOT.DS_CONFIG_OPTIONS

       ls_email_list := nvl( ksbms_util.f_get_coption_value('EMAIL_WIDEN_WARN_LIST'),'deb@ksdot.org');
       ls_user := pontis.f_get_username;
       
-- but only if the update didn't come from CansysII (the robot)

if (user <> 'KSBMS_ROBOT')
then
           
     
IF ksbms_util.f_email (
            ls_email_list,
               'A widening has been made added or changed on bridge '
            || :old.brkey
            || ', Unit '
            || :old.strunitkey
            || ' by user '
            || ls_user
            || ' on '
            || TO_CHAR (SYSDATE)
            ||'.  Do not forget to add this widening project to CansysII!!',
               'ATTENTION:'
            || ls_user
            || ' added or changed the widening data for bridge '
            || :old.brkey
            || ' Unit '
            || :old.strunitkey
            || '. Widenings from Pontis do not automatically migrate to CansysII.'
         )
      THEN
         RAISE lex_email_failed;
 END IF;
  
     
   ELSE -- Unhandled case
      -- This will raise as an unhandled user error
      RAISE lex_unsupported_case; -- Does this work?
 END IF; 
EXCEPTION
   WHEN lex_email_failed
   THEN
      DBMS_OUTPUT.put_line (
         'ksbms_util.f_email(l,m,s) function call failed processing Trigger taur_widening_upd_warn'
      );
   WHEN lex_unsupported_case
   THEN
      DBMS_OUTPUT.put_line (
         'Unsupported case encountered processing Trigger taur_widening_upd_warn'
      );
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('Trigger taur_widening_upd_warn');
END taur_widening_upd_warn;
/