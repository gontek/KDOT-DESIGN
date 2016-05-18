CREATE OR REPLACE TRIGGER pontis.TAUR_INSPEVNT_UW_INSP_REQ_WARN
  after update of UWINSPREQ on pontis.INSPEVNT
   for each row
-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: TAUR_INSPEVNT_UW_INSP_REQ_WARN
-- An after update trigger to remind let specials staff know that an underwater type inspection has been changed.
-- so they can ensure data integrity.
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

--  2014-02-03 Added to the project by Deb, KDOT
-----------------------------------------------------------------------------------------------------------------------------------------

  WHEN ( nvl(new.uwinspreq, '<MISSING>' ) <>  nvl( old.uwinspreq, '<MISSING>' )) declare
   ls_email_list          ksbms_robot.ds_config_options.optionvalue%TYPE;
   lex_email_failed       EXCEPTION;
   lex_unsupported_case   EXCEPTION;
   ls_uwater_insp_typ    varchar2(2);

begin
     -- Get email_uwater_insp_typ list from KSBMS_ROBOT.DS_CONFIG_OPTIONS

     ls_email_list := nvl( ksbms_util.f_get_coption_value('EMAIL_DEB_ONLY'),'deb@ksdot.org');
     ls_uwater_insp_typ := pontis.BIF.f_get_bif_inspecdata(:NEW.brkey,'USERINSP','UWATER_INSP_TYP');

 if ( ls_uwater_insp_typ not in ('3','4')) AND
      (:NEW.UWINSPREQ = 'Y') 



 THEN

      -- send warning statement as mail message

       if ksbms_util.f_email( ls_email_list, 'The underwater inspection required field has been changed from '||:old.uwinspreq||' to ' ||:new.uwinspreq||' for structure '||:old.brkey||' by user '|| USER || ' on ' || to_char(sysdate)||' for
         an underwater inspection that is not a commercial or in-house dive.  Waders and Visuals are not federally required!', 'ATTENTION: An underwater inspection required field has been INCORRECTLY changed on '||:old.brkey||'!! Needs to be fixed!!!') then
            raise lex_email_failed;
       end if;

    else -- Unhandled case
        -- This will raise as an unhandled user error
        raise lex_unsupported_case; -- Does this work?
     end if;

   exception
     WHEN lex_email_failed THEN
          dbms_output.put_line ('ksbms_util.f_email(l,m,s) function call failed processing Trigger TAUR_INSPEVNT_UW_INSP_REQ_WARN failed');
     WHEN lex_unsupported_case THEN
          dbms_output.put_line ('Unsupported case encountered processing Trigger TAUR_INSPEVNT_UW_INSP_REQ_WARN');

     WHEN OTHERS THEN
        dbms_output.put_line ('Trigger TAUR_INSPEVNT_UW_INSP_REQ_WARN failed');

end TAUR_INSPEVNT_UW_INSP_REQ_WARN;
/