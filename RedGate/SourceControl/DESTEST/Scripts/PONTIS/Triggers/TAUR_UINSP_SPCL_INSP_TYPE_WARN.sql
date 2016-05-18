CREATE OR REPLACE TRIGGER pontis.TAUR_UINSP_SPCL_INSP_TYPE_WARN
  after update of SPCL_INSP_TYPE on pontis.userinsp
   for each row
-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: TAUR_UINSP_SPCL_INSP_TYPE_WARN
-- An after update trigger to remind data entry person to add additional "Other" special type inspections to bridge notes.
-- so inspectors can see if, for example, a bridge has had bridge impact damage more than once.
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

--  2006-10-25 Added to the project by Deb, KDOT
-----------------------------------------------------------------------------------------------------------------------------------------
 
  DISABLE WHEN ( nvl(new.spcl_insp_type, '<MISSING>' ) <>  nvl( old.spcl_insp_type, '<MISSING>' )) declare
   ls_email_list          ksbms_robot.ds_config_options.optionvalue%TYPE;
   lex_email_failed       EXCEPTION;
   lex_unsupported_case   EXCEPTION;
   ls_spcl_insp_type userinsp.spcl_insp_type%type;
   
       
begin
     -- Get email_uwater_insp_typ list from KSBMS_ROBOT.DS_CONFIG_OPTIONS
     
     ls_email_list := nvl( ksbms_util.f_get_coption_value('EMAIL_DATA_ENTRY_LIST'),'deb@ksdot.org');
 
   
   
      -- send warning statement as mail message
     
       if ksbms_util.f_email( ls_email_list, 'An "Other SpeciaL" inspection type has been added to structure '||:old.brkey||' by user '|| USER || ' on ' || to_char(sysdate)||'.  Do not forget to add this info to bridge-level notes.', 'ATTENTION: An "Other Special" inspection type has been added to '||:old.brkey||'!! Add this info to bridge-level notes.') then 
            raise lex_email_failed;
       end if;
   
   exception
     WHEN lex_email_failed THEN
          dbms_output.put_line ('ksbms_util.f_email(l,m,s) function call failed processing Trigger TAUR_UINSP_SPCL_INSP_TYPE_WARN failed');
     WHEN lex_unsupported_case THEN
          dbms_output.put_line ('Unsupported case encountered processing Trigger TAUR_UINSP_SPCL_INSP_TYPE_WARN');
     
     WHEN OTHERS THEN
        dbms_output.put_line ('Trigger TAUR_UINSP_SPCL_INSP_TYPE_WARN failed');

end TAUR_UINSP_SPCL_INSP_TYPE_WARN;
/