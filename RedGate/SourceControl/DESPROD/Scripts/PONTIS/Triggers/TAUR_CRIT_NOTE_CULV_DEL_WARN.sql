CREATE OR REPLACE TRIGGER pontis.TAUR_CRIT_NOTE_CULV_DEL_WARN
  after update of crit_note_cul_1, crit_note_cul_2 on pontis.userstrunit
   for each row
-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: TAUR_CRIT_NOTE_CULV_DEL_WARN
-- After update trigger to Planning staff that a critical notation for the culvert
-- was removed so they can archive the critical notation in CANSYSII
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

--  2004-03-11 Added to the project by Deb & Mitch, KDOT
----------------------------------------------------------------------------------------------------------------------------------------



  WHEN ((nvl( new.crit_note_cul_1, '<MISSING>' ) <>  nvl( old.crit_note_cul_1, '<MISSING>' )) or
     (nvl( new.crit_note_cul_2, '<MISSING>' ) <>  nvl( old.crit_note_cul_2, '<MISSING>' )  )) declare
   ls_email_list          ksbms_robot.ds_config_options.optionvalue%TYPE;
   lex_email_failed       EXCEPTION;
   lex_unsupported_case   EXCEPTION;
   ls_crit_desc_culv_1           paramtrs.longdesc%TYPE;
   ls_crit_desc_culv_2           paramtrs.longdesc%TYPE;

begin
     -- Get alert list from KSBMS_ROBOT.DS_CONFIG_OPTIONS

     ls_email_list := nvl( ksbms_util.f_get_coption_value('EMAIL_ALERT_LIST'),'deb@ksdot.org, mitch@ksdot.org');
     ls_crit_desc_culv_1 := nvl(pontis.f_get_paramtrs_equiv_long('userstrunit','crit_note_culv',:old.crit_note_cul_1),'-1');
     ls_crit_desc_culv_2 := nvl(pontis.f_get_paramtrs_equiv_long('userstrunit','crit_note_culv',:old.crit_note_cul_2),'-1');
     
 IF  (:new.crit_note_cul_1 = '_')
   
 THEN

     -- send deleted critical notation statement as mail message

       if ksbms_util.f_email( ls_email_list, 'A '||ls_crit_desc_culv_1|| ' critical notation for Culvert 1 for Bridge '||:old.brkey||' Unit '||:old.strunitkey||' was deleted from the database by user '|| USER || ' on ' || to_char(sysdate)||'.  PLEASE NOTE: This crit notation needs to be end-dated in CANSYS.', 'ATTENTION: A Critical Notation was deleted for Bridge '||:old.brkey ) then
            raise lex_email_failed;
       end if;
       
 ELSIF (:new.crit_note_cul_2 = '_')
   
 THEN

     -- send deleted critical notation statement as mail message

       if ksbms_util.f_email( ls_email_list, 'A '||ls_crit_desc_culv_2|| ' critical notation for Culvert 2 for Bridge '||:old.brkey||' Unit '||:old.strunitkey||' was deleted from the database by user '|| USER || ' on ' || to_char(sysdate)||'.  PLEASE NOTE: This crit notation needs to be end-dated in CANSYS.', 'ATTENTION: A Critical Notation was deleted for Bridge '||:old.brkey ) then
            raise lex_email_failed;
       end if;       


     else -- Unhandled case
        -- This will raise as an unhandled user error
        raise lex_unsupported_case; -- Does this work?
     end if;

   exception
     WHEN lex_email_failed THEN
          dbms_output.put_line ('ksbms_util.f_email(l,m,s) function call failed processing Trigger TAUR_CRIT_NOTE_CULV_DEL_WARN failed');
     WHEN lex_unsupported_case THEN
          dbms_output.put_line ('Unsupported case encountered processing Trigger TAUR_CRIT_NOTE_CULV_DEL_WARN failed');

     WHEN OTHERS THEN
        dbms_output.put_line ('TAUR_CRIT_NOTE_CULV_DEL_WARN failed');

end TAUR_CRIT_NOTE_CULV_DEL_WARN;
/