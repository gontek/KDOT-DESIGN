CREATE OR REPLACE TRIGGER pontis.TAUR_CRIBBING_NOTATION_WARN
	AFTER UPDATE OF CRIT_NOTE_SUP_1,CRIT_NOTE_SUP_2,CRIT_NOTE_SUP_3,CRIT_NOTE_SUP_4,CRIT_NOTE_SUP_5
   ON pontis.USERSTRUNIT
	FOR EACH ROW
	




DISABLE DECLARE   ls_email_list       ksbms_robot.ds_config_options.optionvalue%TYPE;
	        lex_email_failed    EXCEPTION;
          lex_unsupported_case EXCEPTION;
          ls_user paramtrs.longdesc%type;
          
BEGIN

-- Get alert list from KSBMS_ROBOT.DS_CONFIG_OPTIONS

    ls_email_list:= nvl(ksbms_util.f_get_coption_value('EMAIL_IT_ONLY_LIST'),'deb@ksdot.org');
    ls_user:= pontis.f_get_username;
    IF (( :NEW.CRIT_NOTE_SUP_1 = '8') or
       (:old.crit_note_sup_1 = '8' and :NEW.CRIT_NOTE_SUP_1 <> '8') OR
       ( :NEW.CRIT_NOTE_SUP_2 = '8') or
       (:old.crit_note_sup_2 = '8' and :NEW.CRIT_NOTE_SUP_2 <> '8') OR
       ( :NEW.CRIT_NOTE_SUP_3 = '8') or
       (:old.crit_note_sup_3 = '8' and :NEW.CRIT_NOTE_SUP_3 <> '8') OR
       ( :NEW.CRIT_NOTE_SUP_4 = '8') or
       (:old.crit_note_sup_4 = '8' and :NEW.CRIT_NOTE_SUP_4 <> '8') OR
       ( :NEW.CRIT_NOTE_SUP_5 = '8') or
       (:old.crit_note_sup_5 = '8' and :NEW.CRIT_NOTE_SUP_5 <> '8')) 
        then
      IF KSBMS_UTIL.F_EMAIL(ls_email_list,'A critical notation of temporary cribbing has been CHANGED for Bridge '||:old.brkey||', Unit '||:old.strunitkey||', by user '|| ls_user || ' on ' || to_char(sysdate)||'.  NBI 41 (openpostclosed) may need to be updated.', 'ATTENTION: A Critical Notation for temporary cribbing has been changed for Bridge '||:old.brkey ) then
        raise lex_email_failed;
      end if;
      
      else -- Unhandled case
           -- This will raise as an unhandled user error
         raise lex_unsupported_case; 
      end if;
      
 EXCEPTION
     WHEN lex_email_failed THEN
          dbms_output.put_line ('ksbms_util.f_email(l,m,s) function call failed processing Trigger TAUR_CRIBBING_NOTATION_WARN failed');
     WHEN lex_unsupported_case THEN
          dbms_output.put_line ('Unsupported case encountered processing Trigger TAUR_CRIBBING_NOTATION_WARN failed');
     
     WHEN OTHERS THEN
        dbms_output.put_line ('TAUR_CRIBBING_NOTATION_WARN failed');



END TAUR_CRIBBING_NOTATION_WARN;
/