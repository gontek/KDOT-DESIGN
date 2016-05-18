CREATE OR REPLACE TRIGGER pontis.TAUR_UINSP_INSPFREQ_KDOT_WARN
  after update of BRINSPFREQ_KDOT on pontis.USERINSP
   for each row
-----------------------------------------------------------------------------------------------------------------------------------------
-- After update trigger to IT staff that a routine inspection frequency has been deleted
-------------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

--  2010.10.26  Added to the project by Deb  KDOT
--  to warn when brinspfreq_kdot has been accidently nulled out...
-----------------------------------------------------------------------------------------------------------------------------------------

DISABLE declare
   ls_email_list          ksbms_robot.ds_config_options.optionvalue%TYPE;
   lex_email_failed       EXCEPTION;
   lex_unsupported_case   EXCEPTION;

begin
     -- Get alert list from KSBMS_ROBOT.DS_CONFIG_OPTIONS

     ls_email_list := nvl( ksbms_util.f_get_coption_value('EMAIL_DATA_ENTRY_LIST'),'deb@ksdot.org');

   if (:new.brinspfreq_kdot is null)

   then

     -- send deleted inspfreq_kdot statement as mail message

       if ksbms_util.f_email( ls_email_list, 'A routine inspection frequency for '||:old.brkey||' was deleted by user '|| USER || ' on ' || to_char(sysdate)||'.  Is this correct?  Data needs to be verified.', 'ATTENTION: A routine inspection frequency has been deleted for Bridge '||:old.brkey ) then
            raise lex_email_failed;
       end if;


     else -- Unhandled case
        -- This will raise as an unhandled user error
        raise lex_unsupported_case; -- Does this work?
     end if;

   exception
     WHEN lex_email_failed THEN
          dbms_output.put_line ('ksbms_util.f_email(l,m,s) function call failed processing Trigger TAUR_UINSP_INSPFREQ_KDOT_WARN failed');
     WHEN lex_unsupported_case THEN
          dbms_output.put_line ('Unsupported case encountered processing Trigger TAUR_UINSP_INSPFREQ_KDOT_WARN failed');

     WHEN OTHERS THEN
        dbms_output.put_line ('Trigger TAUR_UINSP_BRINSPFREQ_KDOT_WARN failed');

end TAUR_UINSP_INSPFREQ_KDOT_WARN;
/