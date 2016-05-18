CREATE OR REPLACE TRIGGER ksbms_robot.taidur_transfer_map_warn
   AFTER INSERT OR DELETE OR UPDATE
   ON ksbms_robot.ds_transfer_map
   FOR EACH ROW
-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taidur_transfer_map_warn
-- After INSERT trigger to notify KDOT staff that a new TRANSFER MAP ENTRY was added to the system
-- After DELETE trigger to notify KDOT staff that a TRANSFER MAP ENTRY e was removed 
-- After UPDATE trigger to notify KDOT staff that an existing TRANSFER MAP ENTRY was changed in the system
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

-- 2002.01.10  - Hoyt Nelson, CS -- Initial adaptation from the generated update triggers
-- 2002.07.08  - Allen Marshall, CS -- created from TAIDR_ELEMDEFS_WARN to notify staff of new structure in database
-----------------------------------------------------------------------------------------------------------------------------------------

-- ?2002 Copyright: Cambridge Systematics, Inc, Asset Management Group: All Rights Reserved
-- No distribution without express written permission of Cambridge Systematics, Inc., Cambridge MA

--    Cambridge Systematics
--    150 CambridgePark Drive, Suite 4000
--    Cambridge MA 02140
--    Phone: 617-354-0167
--    Fax:   616-354-1542
--    http://www.camsys.com






DISABLE DECLARE
   ls_email_list          ksbms_robot.ds_config_options.optionvalue%TYPE;
   lex_email_failed       EXCEPTION;
   lex_unsupported_case   EXCEPTION;
BEGIN
   -- Get alert list from KSBMS_ROBOT.DS_CONFIG_OPTIONS

   ls_email_list := NVL (
                       ksbms_util.f_get_coption_value ('EMAIL_ALERT_LIST'),
                       'deb@ksdot.org'
                    );

   -- What we e-mail depends on 
   -- whether we are INSERTing or DELETing
   IF inserting
   THEN
      -- send exchange_rule_id as mail message

      IF ksbms_util.f_email (
            ls_email_list,
               'TRANSFER MAP ENTRY '
            || :NEW.exchange_rule_id
            || ' Table_name '
            || :New.table_name
            || ' and Column_name '
            || :NEW.column_name
            || ' was added to the production database table by user '
            || USER
            || ' at '
            || TO_CHAR (SYSDATE),
               'ATTENTION: XFER MAP ENTRY INSERTED/CREATED IN PRODUCTION- NEW ID  # '
            || :NEW.exchange_rule_id
         )
      THEN
         RAISE lex_email_failed;
      END IF;
   ELSIF deleting
   THEN
      -- send deleted exchange_rule_id in mail message
      IF ksbms_util.f_email (
            ls_email_list,
               'TRANSFER MAP ENTRY '
            || :OLD.exchange_rule_id
            || ' was deleted from the production database by user '
            || USER
            || ' at '
            || TO_CHAR (SYSDATE),
               'ATTENTION: XFER MAP ENTRY REMOVED - OLD ID  # '
            || :OLD.exchange_rule_id
            || ' IN THE PRODUCTION DATABASE'
         )
      THEN
         RAISE lex_email_failed;
      END IF;
   ELSIF updating
   THEN
      IF ksbms_util.f_email (
            ls_email_list,
               'TRANSFER MAP ENTRY (OLD ID) '
            || :NEW.exchange_rule_id
            || ' Table_name '
            || :New.table_name
            || ' and Column_name '
            || :NEW.column_name
            || ' was CHANGED IN the production database by user '
            || USER
            || ' at '
            || TO_CHAR (SYSDATE),
               'ATTENTION: XFER MAP ENTRY (old id)'
            || :OLD.exchange_rule_id
            || ' UPDATED - CHANGED ID  # (new) '
            || :NEW.exchange_rule_id
            || ' IN THE PRODUCTION DATABASE'
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
         'ksbms_util.f_email(l,m,s) function call failed processing Trigger taidur_transfer_map_warn failed'
      );
   WHEN lex_unsupported_case
   THEN
      DBMS_OUTPUT.put_line (
         'Unsupported case encountered processing Trigger taidur_transfer_map_warn failed'
      );
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('Trigger taidur_transfer_map_warn failed');
END taidur_transfer_map_warn;
/