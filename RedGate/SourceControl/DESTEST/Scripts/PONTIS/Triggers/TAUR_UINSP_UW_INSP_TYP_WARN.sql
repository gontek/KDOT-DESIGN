CREATE OR REPLACE TRIGGER pontis.TAUR_UINSP_UW_INSP_TYP_WARN
  after update of UWATER_INSP_TYP on pontis.userinsp
   for each row
-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: TAUR_UINSP_UW_INSP_TYP_WARN
-- An after update trigger to remind let specials staff know that an underwater type inspection has been changed.
-- so they can ensure data integrity.
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

--  2005-05-11 Added to the project by Deb, KDOT
--  2010-05-27 Added additional text to remind Bob to delete interval under
--             specific circumstances...
-----------------------------------------------------------------------------------------------------------------------------------------


 DISABLE WHEN ( nvl(new.uwater_insp_typ, '<MISSING>' ) <>  nvl( old.uwater_insp_typ, '<MISSING>' )) declare
   ls_email_list          ksbms_robot.ds_config_options.optionvalue%TYPE;
   lex_email_failed       EXCEPTION;
   lex_unsupported_case   EXCEPTION;


begin
     -- Get email_uwater_insp_typ list from KSBMS_ROBOT.DS_CONFIG_OPTIONS

     ls_email_list := nvl( ksbms_util.f_get_coption_value('EMAIL_IT_ONLY_LIST'),'deb@ksdot.org');


 if ( :old.uwater_insp_typ in ('3','4') and ( :new.uwater_insp_typ not in ('3','4'))or
   (:old.uwater_insp_typ not in ('3','4') and (:new.uwater_insp_typ in ('3','4'))))



   then

      -- send warning statement as mail message

       if ksbms_util.f_email( ls_email_list, 'The underwater inspection type has been changed from '||f_get_paramtrs_equiv('userinsp','uwater_insp_typ',:old.uwater_insp_typ)||' to ' ||f_get_paramtrs_equiv('userinsp','uwater_insp_typ',:new.uwater_insp_typ)||' for structure '||:old.brkey||' by user '|| USER || ' on ' || to_char(sysdate)||'.  Make sure this is correct for this structure. BOB...PLEASE NOTE...IF THE TYPE HAS CHANGED TO "9" then DELETE INTERVAL FROM CANSYS...!!', 'ATTENTION: An underwater inspection type has been changed on '||:old.brkey||'!! Make sure this is correct.') then
            raise lex_email_failed;
       end if;

    else -- Unhandled case
        -- This will raise as an unhandled user error
        raise lex_unsupported_case; -- Does this work?
     end if;

   exception
     WHEN lex_email_failed THEN
          dbms_output.put_line ('ksbms_util.f_email(l,m,s) function call failed processing Trigger TAUR_UINSP_UW_INSP_TYP_WARN failed');
     WHEN lex_unsupported_case THEN
          dbms_output.put_line ('Unsupported case encountered processing Trigger TAUR_UINSP_UW_INSP_TYP_WARN');

     WHEN OTHERS THEN
        dbms_output.put_line ('Trigger TAUR_UINSP_UW_INSP_TYP_WARN failed');

end TAUR_UINSP_UW_INSP_TYP_WARN;
/