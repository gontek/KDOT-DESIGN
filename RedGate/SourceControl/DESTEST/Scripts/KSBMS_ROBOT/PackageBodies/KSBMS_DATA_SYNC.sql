CREATE OR REPLACE PACKAGE BODY ksbms_robot."KSBMS_DATA_SYNC" IS
     -- Last mod: Hoyt 03/03/2002 on Hoyt
     -- Moved to Emperor on 3/3/2002

     /* Revision history:

     Hoyt 06/26/2002 f_munge_on_highways_tables() : Handle the previously-unhandled MSG case

        Also:

          -- Hoyt 06/26/2002 Execute the EXOR pre_broker procedure
          pontis_stub.pre_broker;

        and later:

          -- Hoyt 06/26/2002 Execute the EXOR populate_from_pontis procedure
          pontis.populate_from_pontis;

     Hoyt 09/09/2002 Commented out code that was errantly registering an error
     when there were no ds_change_log_c UPD records (per Deb Kossler 9/9/2002 e-mail.

     */
     gs_ds_email   ksbms_util.gs_email_msg%TYPE;

     gd_package_release_date DATE := SYSDATE;
     gs_package_cvs_archive_id VARCHAR2(120) := '$Id: ksbms_data_sync.pck,v 1.21 2003/04/13 13:31:42 arm Exp $ '; -- generated automatically by cvs

     -- Default(s) from ds_config_coptions are initialized in the package body
     gi_default_stale_days                   PLS_INTEGER;
     -- This holds the exchange_rule_id that corresponds to strunitlabel
     gs_strunitlabel_exc_rule_id             ds_transfer_map.exchange_rule_id%TYPE;
     -- This turns OFF (when FALSE) any archiving in this function
     -- As of 03/18/2002, all archiving is done by "apply changes",
     -- esp. ksbms_apply_changes.f_update_pontis_records(). This Boolean
     -- is used here so the archived code is preserved "neatly" here
     -- against future need.
     gb_archiving_locally           CONSTANT BOOLEAN                 := FALSE; -- Set TRUE to archive in this package

-------------------------------------------------------------------
 -- These must be kept in synch across the packages!
 -- <ENHANCEMENT>: Put in dedicated package
 -------------------------------------------------------------------
 -- The schema is either Pontis or CANSYS
     ls_pontis_schema               CONSTANT ds_change_log_temp.SCHEMA%TYPE
                                                                       := 'P';
     ls_cansys_schema               CONSTANT ds_change_log_temp.SCHEMA%TYPE
                                                                       := 'C';
     -- ds_change_log.Exchange_Status values
     ls_in_process                  CONSTANT ds_change_log.exchange_status%TYPE
                                                              := 'IN-PROCESS';
     ls_update_type                 CONSTANT ds_change_log.exchange_status%TYPE
                                                                     := 'UPD';
     ls_still_missing               CONSTANT ds_change_log.exchange_status%TYPE
                                                              := '<STILMSNG>';
     ls_rec_deleted                 CONSTANT ds_change_log.exchange_status%TYPE
                                                              := '<RECDELTD>';
     -- Hoyt 01/14/2002 Changes 'NEWUPD' to 'UPD' per other routines
     -- Hoyt 03/20/2002 Eliminated ls_new_update (same as ls_update_type)
     -- ls_new_update              constant ds_change_log.exchange_status%type      := 'UPD';
     ls_merge_ready                 CONSTANT ds_change_log.exchange_status%TYPE
                                                              := 'MERGEREADY';
     -- 2002.07.10 -- Allen Marshall, CS -- added three new types to indicate they are ready to go
     -- Hoyt 08/08/2002 These three new types are not used as far as I can tell
     ls_delete_ready                CONSTANT ds_change_log.exchange_status%TYPE
                                                                := 'DELREADY'; -- built from arguments in f_change_lookup_records.
     ls_insert_ready                CONSTANT ds_change_log.exchange_status%TYPE
                                                                := 'INSREADY';
     ls_message_ready               CONSTANT ds_change_log.exchange_status%TYPE
                                                                := 'MSGREADY';
     ls_failed      CONSTANT ds_change_log.exchange_status%TYPE
                                                                  := 'FAILED';
     ls_applied      CONSTANT ds_change_log.exchange_status%TYPE
                                                                  := 'APPLIED';
     ls_merged                      CONSTANT ds_change_log.exchange_status%TYPE
                                                                  := 'MERGED';
     ls_stale                       CONSTANT ds_change_log.exchange_status%TYPE
                                                                   := 'STALE';
     ls_superseded                  CONSTANT ds_change_log.exchange_status%TYPE
                                                              := 'SUPERSEDED';
     -- ds_config_options.OptionName values
     ls_stale_number_option         CONSTANT ds_config_options.optionname%TYPE
                                                    := 'STALE_NUMBER_OF_DAYS';
     ls_halt_on_merge_option        CONSTANT ds_config_options.optionname%TYPE
                                             := 'HALT_IF_MERGE_READY_IN_TEMP';
     ls_raise_merge_error_option    CONSTANT ds_config_options.optionname%TYPE
                                                       := 'RAISE_MERGE_ERROR';
     -- This is used to represent missing values in ksbms_pontis.f_pass_update_trigger_params()
     ls_missing                     CONSTANT VARCHAR2 (9)      := '<MISSING>';
     -- 'Merge Changes' ds_jobruns_history.job_status values
     ls_job_not_started             CONSTANT ds_jobruns_history.job_status%TYPE
                                                                      := 'NS'; -- Not Started
     ls_job_starting_merge          CONSTANT ds_jobruns_history.job_status%TYPE
                                                                      := 'SM'; -- Starting Merge
     ls_job_in_process              CONSTANT ds_jobruns_history.job_status%TYPE
                                                                      := 'IP'; -- In Process
     ls_job_all_done                CONSTANT ds_jobruns_history.job_status%TYPE
                                                                      := 'AD'; -- All Done
     ls_job_merge_failed            CONSTANT ds_jobruns_history.job_status%TYPE
                                                                      := 'MF';                                                                                         -- Merge Failed
                                                                               -- 'Apply Changes' ds_jobruns_history.job_status values
                                                                               -- This ds_jobruns_history.job_id magic string inhibits updates
     ls_job_applying_change         CONSTANT ds_jobruns_history.job_id%TYPE
                                                                      := 'AC';                                                                                         -- Applying Changes
                                                                               -- This ds_jobruns_history.job_id magic string signifies that this process is DONE
     ls_job_changes_done            CONSTANT ds_jobruns_history.job_id%TYPE
                                                                      := 'CD';                                                                                         -- Changes Done
                                                                               -- This ds_jobruns_history.job_id magic string signifies that the job FAILED
     ls_job_changes_failed          CONSTANT ds_jobruns_history.job_id%TYPE
                                                                      := 'CF';                                                                                         -- Changes Failed
                                                                               -- Test for this to catch 'Failure' for functions that return a string
     ls_failure_return              CONSTANT VARCHAR2 (9)      := '<FAILURE>';
     -- Global utility strings
     gs_crlf                        CONSTANT VARCHAR2 (2)
                                                       := CHR (13)
                                                          || CHR (10);
     -- Local magic string
     ls_initial_where               CONSTANT VARCHAR2 (6)          := 'WHERE';
     -- Allen Marshall, CS - 2002.12.16
     -- Local magic string that indicates a record has not had its match key values set yet - only allows 1 update of these for really really new records
     cs_magic_newrecord_indicator   CONSTANT VARCHAR2 (40)
                                                    := 'NEWUNINITIALIZEDKEYS';
     -- So we can invoke the exception handler for general purposes
     generic_exception                       EXCEPTION;
     PRAGMA EXCEPTION_INIT (generic_exception, -20300);
     -- This exception is raised when an INSERT, DELETE or UPDATE doesn't "find" any rows
     no_data_affected                        EXCEPTION;
     PRAGMA EXCEPTION_INIT (no_data_affected, -20301);

----------------------------------------------------------------
-- Wrappers for functions in the ksbms_util and ksbms_fw package
----------------------------------------------------------------
     FUNCTION f_ns (
          psi_string   IN   VARCHAR2
     )
          RETURN BOOLEAN
     IS
     BEGIN
          RETURN ksbms_util.f_ns (psi_string);
     END f_ns;

     FUNCTION sq (
          psi_string   IN   VARCHAR2
     )
          RETURN VARCHAR2
     IS
     BEGIN
          RETURN ksbms_util.sq (psi_string);
     END sq;

     PROCEDURE p_bug (
          psi_msg   IN   VARCHAR2
     )
     IS
     BEGIN
          ksbms_util.p_bug (psi_msg);
     END p_bug;

     PROCEDURE p_add_msg (
          psi_msg   IN   VARCHAR2
     )
     IS
     BEGIN
          ksbms_util.p_add_msg (psi_msg);
     END p_add_msg;

     -- wrapper
     PROCEDURE p_log (
          psi_msg   IN   VARCHAR2
     )
     IS
     BEGIN
          ksbms_util.p_log (psi_msg);
     END p_log;-- variant 1

     PROCEDURE p_log (

          psi_job_id IN VARCHAR2,
          psi_msg   IN   VARCHAR2
     )
     IS
     BEGIN
          ksbms_util.p_log (psi_job_id, psi_msg);
     END p_log; -- variant 2

     PROCEDURE p_clean_up_after_raise_error (
          psi_context   IN   VARCHAR2
     )
     IS
     BEGIN
          ksbms_util.p_clean_up_after_raise_error (psi_context);
     END p_clean_up_after_raise_error;

     PROCEDURE p_sql_error (
          psi_msg   IN   VARCHAR2
     )
     IS
     BEGIN
          ksbms_util.p_sql_error (psi_msg);
     END p_sql_error;

     PROCEDURE p_sql_error2 (
          psi_msg   IN   VARCHAR2
     )
     IS
     BEGIN
          ksbms_util.p_sql_error2 (psi_msg);
     END p_sql_error2;

     PROCEDURE pl (
          psi_msg   IN   VARCHAR2
     )
     IS
     BEGIN
          -- NB: In ksbms_fw
          ksbms_fw.pl (psi_msg);
     END pl; -- END: Wrappers


----------------------------------------
-- Supporting functions
----------------------------------------

     FUNCTION f_bridge_id_to_brkey (
          p_bridge_id   IN   VARCHAR2
     )
          -- This takes '0001-B0008' and returns '001008',
          -- which is the apparent algorithm that KDOT uses to go between
          -- bridge_id (the first string) and brkey and struct_num (the
          -- second string -- brkey and struct_num are everywhere the same
          -- in the KDOT database).
     RETURN VARCHAR2
     IS
          ls_brkey                     VARCHAR2 (6);
          bridge_id_is_null            EXCEPTION;
          bridge_id_is_not_ten_chars   EXCEPTION;
     BEGIN
          -- It cannot be NULL
          IF p_bridge_id IS NULL
          THEN
               RAISE bridge_id_is_null;
          END IF;

          -- It has to be 10 characters (or our algorithm is suspect)
          IF LENGTH (p_bridge_id) <> 10
          THEN
               RAISE bridge_id_is_not_ten_chars;
          END IF;

          -- Extract the brkey (and struct_num, which is the same)
          --             1234567890
          -- This takes '0001-B0008' and returns '001008',
          --              123   123
          ls_brkey := SUBSTR (p_bridge_id, 2, 3) || SUBSTR (p_bridge_id, 8, 3);
          -- Done!
          RETURN ls_brkey;
     EXCEPTION
          WHEN bridge_id_is_null
          THEN
               p_sql_error ('NULL bridge ID passed to f_bridge_id_to_brkey()');
          WHEN bridge_id_is_not_ten_chars
          THEN
               p_sql_error (   'Bridge ID passed to f_bridge_id_to_brkey() doesn''t have 10 characters!'
                            || gs_crlf
                            || gs_crlf
                            || 'The bridge_id is '''
                            || p_bridge_id
                            || ''' AND it''s length is '
                            || TO_CHAR (LENGTH (p_bridge_id))
                           );
     END;

     FUNCTION f_merge_database_changes (
          psi_job_id            IN   ds_jobruns_history.job_id%TYPE,
          pli_ora_dbms_job_id   IN   ds_jobruns_history.ora_dbms_job_id%TYPE,
          psio_email_msg        in   ksbms_util.gs_email_msg%TYPE
     )
          RETURN BOOLEAN
     IS
          lb_failed                        BOOLEAN                    := TRUE; -- Until we actually succeed
          lb_any_records_found             BOOLEAN;
          lb_changes_made                  BOOLEAN                   := FALSE; -- Until we insert something
          lb_in_development                BOOLEAN                   := FALSE; -- Make FALSE in production!
          lb_no_pontis_data_to_merge       BOOLEAN                   := FALSE; -- Tested in the "success" block at the end of the do-once loop
          lb_no_cansys_data_to_merge       BOOLEAN                   := FALSE; -- Tested in the "success" block at the end of the do-once loop
          lb_no_merge_ready_in_temp        BOOLEAN; -- Tested if the option specifies 'Halt if merge-ready in temp'
          lb_missing_data_found            BOOLEAN;
          li_error_code                    PLS_INTEGER                   := 0; -- Default is no error!
          li_sqlcode                       PLS_INTEGER                   := 0; -- For preserving SQLCODE
          li_num_pontis_change_log_recs    PLS_INTEGER                   := 0;
          li_num_cansys_change_log_recs    PLS_INTEGER                   := 0;
          li_num_leftovr_mergeready_recs   PLS_INTEGER                   := 0;
          li_stale_number_of_days          PLS_INTEGER                   := 0;
          li_stale_record_count            PLS_INTEGER                   := 0;
          li_num_pontis_superseded_recs    PLS_INTEGER                   := 0;
          li_num_cansys_superseded_recs    PLS_INTEGER                   := 0;
          li_num_records_set_merge_ready   PLS_INTEGER                   := 0;
          li_num_records_moved_to_pontis   PLS_INTEGER                   := 0;
          li_num_records_moved_to_cansys   PLS_INTEGER                   := 0;
          ls_merge_job_id                  ds_jobruns_history.job_id%TYPE
                                                        := ls_job_not_started;
          ls_result                        VARCHAR2 (2000); -- Generic result variable
          ls_context                       ksbms_util.context_string_type
                                              := 'f_merge_database_changes()';
          li_num_pontis_moved              PLS_INTEGER;
          li_num_cansys_moved              PLS_INTEGER;
          ll_nrows                         PLS_INTEGER; -- generic SQL%ROWCOUNT result holder;
          lb_something_to_do               BOOLEAN                   := FALSE; -- turns true if moving INS, DEL, or MSG records to and fro
          PRAGMA AUTONOMOUS_TRANSACTION;
     BEGIN

          -- This anonymous block is for the sole purpose of providing
          -- a catch-all exception block... so raising an exception anywhere
          -- in the do-once loop below will be "handled" by this block's
          -- exception handler. This is required by p_sql_error() etc.
          <<outer_exception_block>>
          BEGIN
               ksbms_util.p_push (ls_context);

               -- The do-once loop offers a means of exiting the function
               -- logic without raising a SQL-related error.

               <<do_once>>
               LOOP
                    -- Start the logging
                    -- Moved the next line to the calling routine
                    --ls_merge_job_id := ksbms_util.f_get_entry_id; -- So we can re-use it to update the row when we're done
                    ls_merge_job_id := psi_job_id;                                --- initialized in ds_sync_exec
        /*                                           -- Allen Marshall, CS - 01/31/2003 - enrich logging
                                                   -- reenabled this to ensure a startup message is in the log and that the jobid variable goes to KSBMS_UTIL
                                                   -- wher e it is used...

                   ksbms_util.p_log (psi_job_id,
                                          'Starting logging for job ID '
                                       || psi_job_id
                                       || ' in '
                                       || ls_context
                                     );
                    -- Note the time that we started
                    p_add_msg (   ls_context
                               || ' for Job ID '
                               || psi_job_id
                               || ' is starting at '
                               || ksbms_util.f_now
                              );
*/
                    -- Insert job_status = 'SM' (Starting Merge) so update triggers fail
                    -- The magic string 'SM' is looked for by ksbms_pontis.f_is_merge_underway()
                    /*
                    BEGIN
                         -- NB: Job_ProcessingID is NOT inserted
                         INSERT INTO ds_jobruns_history
                                     (job_id, ora_dbms_job_id,
                                      job_start_time, job_end_time,
                                      job_status, job_userid,
                                      remarks
                                     )
                              VALUES (psi_job_id, pli_ora_dbms_job_id,
                                      SYSDATE, SYSDATE,
                                      ls_job_starting_merge, USER,
                                      'STARTING ROBOT MERGE'
                                     );

                         COMMIT; -- so the triggers see it immediately
                         p_log (psi_job_id,  'Inserted Job ID '
                                           || psi_job_id
                                           || ' into Job Runs History');

                    EXCEPTION
                         WHEN OTHERS
                         THEN
                             BEGIN
                             ROLLBACK;
                              p_sql_error (   'Updating Job ID '
                                           || psi_job_id
                                           || ' into Job Runs History'
                                          );
                               END;
                    END;

                    -- Commit, so the triggers see the 'SM'
                    */
                    BEGIN

                         ksbms_util.p_update_jobruns_history( psi_job_id, ls_job_starting_merge,'STARTING ROBOT MERGE PROCESS');
                         -- commit; -- so the triggers see it immediately

                         p_log (  psi_job_id,  'Inserted DS Job ID '''
                                    || psi_job_id
                                    || ''' with job status '''
                                    || ls_job_starting_merge
                                    || ''' into Job Runs History at '
                                    || ksbms_util.f_now
                                    || '. The Oracle DBMS_JOB Job ID is '''
                                    || pli_ora_dbms_job_id
                                    || '''.'
                                   );
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error (   'Committing after inserting Job ID '
                                           || psi_job_id
                                           || ' into Job Runs History'
                                          );
                    END;

                    ksbms_util.p_log (psi_job_id,
                                          'Starting activity logging in '
                                       || ls_context
                                     );
                    /*p_log ( psi_job_id,  ls_context
                               || ' for DS_JOBRUNS_HISTORY.');*/
                    p_add_msg( 'KSBMS_DATA_SYNC.DS_SYNC_EXEC: Job ID = [ '
                               || psi_job_id
                               || ' ] starting: '
                               || ksbms_util.f_now
                              );
                    --IF LENGTH (psio_email_msg) > 0
                    --THEN
                    p_log (psi_job_id,   'E-mail message body passed in was: '
                               || ksbms_util.crlf
                               || NVL (psio_email_msg, ' - ')
                              );

                    --END IF;

                    -- Uncommment out to test exception handling routines
                    -- p_test_exception_handling;
                    -- exit;

                    -- Just during development -- so we get data!
                    IF lb_in_development
                    THEN
                         -- Better notify that we're in development
                         p_log (psi_job_id,  'Running in development mode in '
                                    || ls_context
                                   );

                         UPDATE ds_change_log
                            SET exchange_status = ls_update_type;

                         COMMIT;

                         UPDATE ds_change_log_c
                            SET exchange_status = ls_update_type;

                         COMMIT;

                         -- Hoyt 03/18/2002 Do NOT archive if the Boolean if false
                         IF gb_archiving_locally
                         THEN
                              DELETE FROM ds_change_log_archive;
                              COMMIT;
                         END IF;

                         -- Clear out job runs so I don't need to keep changing it in the test script
                         DELETE FROM ds_jobruns_history;
                         COMMIT;
                    END IF;

                    -- Fix up the change log and keyvals data
                    -- 1) Replace instances were STRUNITLABEL was initially missing
                    IF f_fix_bogus_strunitkeys ()
                    THEN
                         p_bug (   ls_context
                                || ': f_fix_bogus_strunitkeys() failed'
                               );
                         EXIT; -- Failed
                    END IF;

                    -- 2) Remove any INSPEVNT records NOT related to the most recent INSPEVNT
                    IF f_remove_old_inspdate_records ()
                    THEN
                         p_bug (   ls_context
                                || ': f_remove_old_inspdate_records() failed'
                               );
                         EXIT; -- Failed
                    END IF;

                    -- 3) Fill in any missing USERRWAY rows
                    IF f_fill_in_userrway_keys ()
                    THEN
                         p_bug (   ls_context
                                || ': f_fill_in_userrway_keys() failed'
                               );
                         EXIT; -- Failed
                    END IF;

                    -- 4) Handle delete of most recent INSPEVNT by sending next-most-recent INSPEVNT's data as updates
                    -- (This MUST be done before moving 'DEL' records out, step 5 below!)
                    IF f_replace_deleted_inspevnt ()
                    THEN
                         p_bug (   ls_context
                                || ': f_replace_deleted_inspevnt_data() failed'
                               );
                         EXIT; -- Failed
                    END IF;

                    -- 5) Move any 'INS', 'DEL' or 'MSG' records between Pontis and CANSYS
                    -- (no complicated processing is needed... only UPDates can have ties)
                    -- Hoyt 06/26/2002 If any other exchange_types (like 'MSG') are added,
                    -- be sure to add a corresponding block to f_munge_on_highways_tables().

                    IF f_move_change_lookup_records ('INS',
                                                     psi_job_id,
                                                     li_num_pontis_moved,
                                                     li_num_cansys_moved
                                                    )
                    THEN
                         p_bug (   ls_context
                                || ': f_move_change_lookup_records() failed to move INS (insert) records'
                               );
                         EXIT; -- Failed
                    END IF;

                    lb_something_to_do :=
                             (   li_num_pontis_moved > 0
                              OR li_num_cansys_moved > 0
                             )
                          OR lb_something_to_do;

                    IF f_move_change_lookup_records ('DEL',
                                                     psi_job_id,
                                                     li_num_pontis_moved,
                                                     li_num_cansys_moved
                                                    )
                    THEN
                         p_bug (   ls_context
                                || ': f_move_change_lookup_records() failed to move DEL (delete) records'
                               );
                         EXIT; -- Failed
                    END IF;

                    lb_something_to_do :=
                             (   li_num_pontis_moved > 0
                              OR li_num_cansys_moved > 0
                             )
                          OR lb_something_to_do;

                    -- Hoyt 03/20/2002 Added this to move 'MSG' records
                    IF f_move_change_lookup_records ('MSG',
                                                     psi_job_id,
                                                     li_num_pontis_moved,
                                                     li_num_cansys_moved
                                                    )
                    THEN
                         p_bug (   ls_context
                                || ': f_move_change_lookup_records() failed to move MSG (message) records'
                               );
                         EXIT; -- Failed
                    END IF;

                    lb_something_to_do :=
                             (   li_num_pontis_moved > 0
                              OR li_num_cansys_moved > 0
                             )
                          OR lb_something_to_do;
                    -- 6_ Hoyt 06/26/2002 Execute the EXOR pre_broker procedure
                    p_log ( psi_job_id,'Firing conditioning routine PRE_BROKER... ');
                    pontis.pre_broker@newcant.world;
                    -- pontis.pre_broker@atlastest.world;
                    COMMIT; -- CLEAR PIPES
                    p_log (psi_job_id,'Completed data conditioning routine PRE_BROKER... '
                              );
                    p_log ('Completed routine PRE_BROKER... ');

---------------------------------------------------------------------------
-- Is there any MERGE work to do? Is there at least one record from PONTIS,
-- or at least one record from CANSYS, with exchange_type 'UPD' (update)?
---------------------------------------------------------------------------

                    -- Are there PONTIS records to merge?
                    DECLARE
                         -- Is there at least one 'UPD' record from PONTIS?
                         CURSOR pontis_new_update_cur (
                              ls_update_type   IN   ds_change_log.exchange_type%TYPE
                         )
                         IS
                              SELECT entry_id
                                FROM ds_change_log
                               WHERE exchange_type = ls_update_type
                                 AND (    exchange_status <> ls_applied
                                      AND exchange_status <> ls_failed
                                      AND exchange_status <> ls_merged -- this allows old work to be put back in as MERGED without requiring new UPD work here.
                                     );

                         -- Allen Marshall, CS - 2003-02-04 - ignore failed or APPLIED records - they have been dealt with already in prior runs

                         -- 2002.07.09 Allen R. Marshall - EXCHANGE_TYPE, not EXCHANGE_STATUS is the discriminating field
                         pontis_new_update_cur_rec   pontis_new_update_cur%ROWTYPE;
                    BEGIN
                         -- Is there at least one record?
                         IF pontis_new_update_cur%ISOPEN
                         THEN
                              CLOSE pontis_new_update_cur;
                         END IF;

                         OPEN pontis_new_update_cur (ls_update_type);
                         FETCH pontis_new_update_cur INTO pontis_new_update_cur_rec;
                         lb_no_pontis_data_to_merge :=
                                              pontis_new_update_cur%NOTFOUND;
                         CLOSE pontis_new_update_cur;

                         -- Notify if no Pontis data
                         IF lb_no_pontis_data_to_merge
                         THEN
                             -- Allen Marshall, CS - 2003.04.11 - add this to the E-mail.... logs too.
                              ksbms_util.p_add_msg ('No Pontis data was found that needs to be merged.'
                                               );

                              --ksbms_util.p_log ('No Pontis data was found that needs to be merged.'                                               );

                              -- Allen R. Marshall, CS - 02-04-2003 - tag email when we find any FAILED or pre-APPLIED entries in DS_CHANGE_LOG
                              IF ksbms_util.f_any_rows_exist ('DS_CHANGE_LOG',
                                                                  ' exchange_status = '
                                                               || sq ( 'FAILED'
                                                                     )
                                                             )
                              THEN
                                   ksbms_util.p_add_msg ('FAILED rows are lurking in DS_CHANGE_LOG - PLEASE REVIEW THESE LOG ENTRIES!'
                                                        );
                              END IF;

                              IF ksbms_util.f_any_rows_exist ('DS_CHANGE_LOG',
                                                                  ' exchange_status = '
                                                               || sq ( 'APPLIED'
                                                                     )
                                                             )
                              THEN
                                   ksbms_util.p_add_msg ('Already APPLIED rows are lurking in DS_CHANGE_LOG - PLEASE REVIEW THESE LOG ENTRIES!'
                                                        );
                              END IF;
                         ELSE
                              ksbms_util.p_log ('Pontis data needs to be merged.'
                                               );
                         END IF;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error ('Determining whether Pontis has changed records'
                                          );
                    END;

                    -- Are there any CANSYS records to merge?
                    DECLARE
                         -- Is there at least one 'NEWUPD' record from CANSYS?
                         CURSOR cansys_new_update_cur (
                              ls_update_type   IN   ds_change_log_c.exchange_type%TYPE
                         )
                         IS
                              SELECT entry_id
                                FROM ds_change_log_c
                               WHERE exchange_type = ls_update_type
                                 AND (    exchange_status <> 'APPLIED'
                                      AND exchange_status <> 'FAILED'
                                     );

--2002.07.09 Allen R. Marshall - EXCHANGE_TYPE, not EXCHANGE_STATUS is the discriminating field
                         cansys_new_update_cur_rec   cansys_new_update_cur%ROWTYPE;
                    BEGIN
                         COMMIT; -- CLEAR PIPES
                         -- Is there at least one record?
                         IF cansys_new_update_cur%ISOPEN
                         THEN
                              CLOSE cansys_new_update_cur;
                         END IF;

                         OPEN cansys_new_update_cur (ls_update_type);
                         FETCH cansys_new_update_cur INTO cansys_new_update_cur_rec;
                         lb_no_cansys_data_to_merge :=
                                              cansys_new_update_cur%NOTFOUND;
                         CLOSE cansys_new_update_cur;
                         COMMIT; -- CLEAR PIPES


                         -- Notify if no data
                         IF lb_no_cansys_data_to_merge
                         THEN
                             -- Allen Marshall, CS - 2003.04.11 - add this to the e-mail, logs it too..
                              ksbms_util.p_add_msg ('No CANSYS data was found that needs to be merged.'
                                               );

                              --ksbms_util.p_log ('No CANSYS data was found that needs to be merged.'                                               );

-- Allen R. Marshall, CS - 02-04-2003 - tag email when we find any FAILED or pre-APPLIED entries in  DS_CHANGE _LOG_C
-- DISTRIBUTED TRANSACTION
                              IF ksbms_util.f_any_rows_exist ('DS_CHANGE_LOG_C',
                                                                  ' exchange_status = '
                                                               || sq ( 'FAILED'
                                                                     )
                                                             )
                              THEN
                                   COMMIT; -- release CURSOR IN DISTRIBUTED TRANSACTION
                                   ksbms_util.p_add_msg ('FAILED rows are lurking in DS_CHANGE_LOG_C - PLEASE REVIEW THESE LOG ENTRIES!'
                                                        );
                              END IF;

                              IF ksbms_util.f_any_rows_exist ('DS_CHANGE_LOG_C',
                                                                  ' exchange_status = '
                                                               || sq ( 'APPLIED'
                                                                     )
                                                             )
                              THEN
                                   COMMIT; -- release CURSOR IN DISTRIBUTED TRANSACTION
                                   ksbms_util.p_add_msg ('Already APPLIED rows are lurking in DS_CHANGE_LOG_C - PLEASE REVIEW THESE LOG ENTRIES!'
                                                        );
                              END IF;
                         ELSE
                              Commit;
                              ksbms_util.p_log ('CANSYS data needs to be merged.'
                                               );
                         END IF;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                             begin
                              COMMIT; -- release CURSOR IN DISTRIBUTED TRANSACTION
                              p_sql_error ('Determining whether CANSYS has changed records'
                                          );
                             end;
                    END;

                    -- To test exit-on-nothing-to-merge behavior
                    -- lb_no_pontis_data_to_merge := true;
                    -- lb_no_cansys_data_to_merge := true;

                    -- We're done, if there's nothing to do!
                    -- Allen Marshall, CS - 2003.01.02 - fixup for problem where a single DEL in the log made nothing happen.
                    -- NOTHING tO DO MEANS NOTHING TO MERGE AND NOTHING MOVED DIRECTLY TO TARGET SCHEMA
                    IF     lb_no_pontis_data_to_merge
                       AND lb_no_cansys_data_to_merge
                       -- Allen Marshall, CS - 2003.01.02 added this clause
                       AND NOT lb_something_to_do
                    THEN
                         commit;
                         p_add_msg ('No Pontis AND no CANSYS data was found that needs to be merged. NOTHING TO DO!'
                                   );
                         lb_failed := FALSE;
                         EXIT do_once; -- Done!
                    END IF;

--------------------------------------------------------------------
-- Identify the set of ds_change_log records we're going to merge
--------------------------------------------------------------------

                    /* Break out the set of records we're going to process, preventing
                       triggers from firing in the interim, by INSERTing a job runs
                       history record with the magic job status 'SM', which the trigger-
                       handling procedure ksbms_PONTIS.f_pass_update_trigger_params()
                       checks (by calling ksbms_PONTIS.f_is_merge_underway()). While
                       there is any row inserted TODAY with job_status = 'SM', the
                       update triggers will fail. 'SM' is "Starting Merge", btw.

                       This is (we hope) kept to a minimum, by immediately thereafter
                       updating ds_change_log so all new records ( exchange_status =
                       'NEWUPD' are set to 'IN-PROCESS', then updating the just-inserted
                       ds_jobruns_history record to change 'SM' to 'IP' (In Process).
                       That way, the triggers should fail ONLY so long as it takes to
                       update the ds_change_log records, then reset the jobruns history.

                       f_pass_update_trigger_params() calls f_is_merge_underway()
                       every time a trigger fires. The latter does a SELECT against
                       ds_jobruns_history, to see if there are any 'SM' status rows
                       that were entered today.

                       When the triggers are re-enabled, then more 'NEWUPD' records
                       will be inserted into ds_change_log. These will be ignored until
                       the next merge.
                   */

                    -- Update all the _PONTIS_ exchange_status = 'UPD' rows
                    -- to 'IN-PROCESS' to identify the set we're after.
                    IF NOT lb_no_pontis_data_to_merge
                    THEN
                         BEGIN
                              UPDATE ds_change_log
                                 SET exchange_status = ls_in_process
                               WHERE exchange_status = ls_update_type;
                              li_num_pontis_change_log_recs := SQL%ROWCOUNT;

                              -- We should have found at least one record
                              IF li_num_pontis_change_log_recs = 0
                              THEN
                                   RAISE no_data_affected;
                              END IF;

                              COMMIT; -- Allen Marshall, CS - 2003.03.31 - added

                         EXCEPTION
                              WHEN no_data_affected
                              THEN
                                  BEGIN
                                  COMMIT;
                                   -- No records to update? We already checked to make sure there were!
                                   p_sql_error2 ('No Pontis change log records reset to in-process records, but supposed to be at least 1!'
                                               );
                                   END;
                              WHEN OTHERS
                              THEN
                                   p_sql_error ('Updating Pontis change log entries from UPD to In-Process.'
                                               );
                         END;
                    END IF;

                    COMMIT;

                    ksbms_util.p_log (   TO_CHAR (li_num_pontis_change_log_recs
                                                 )
                                      || ' Pontis change log records to be processed.'
                                     );

                    -- Need to commit, so the following transaction (in f_update_change_log_c())
                    -- is separate;
                    BEGIN
                         COMMIT;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error ('Failed to COMMIT before f_update_change_log_c() call!'
                                          );
                    END;

                    -- Update all the _CANSYS_ exchange_status = 'UPD' rows (also DEL and INS -- Allen Marshall, CS - 2003.01.02 )
                    IF f_update_change_log_c (lb_no_cansys_data_to_merge,
                                              li_num_cansys_change_log_recs
                                             )
                    THEN
                         EXIT do_once; -- Failed
                    END IF;

                    ksbms_util.p_log (   TO_CHAR (li_num_cansys_change_log_recs
                                                 )
                                      || ' CANSYS change log records to be processed.'
                                     );

                    -- Reset the job_status so triggers work again
                    -- Instead of 'SM' (Starting Merge) it is 'IP' (In Process)
                    BEGIN
                         -- The WHERE ignores the job ID because we want to override any
                         -- left-over 'SM' at this point, so the triggers work as usual.
                         -- This "cleans up" for any failed job that left a 'SM' in jobruns.
                         UPDATE ds_jobruns_history
                            SET job_status = ls_job_in_process -- In Process
                          WHERE job_status = ls_job_starting_merge; -- Starting Merge

--                               COMMIT; --commented out this commit for 9i

                         ksbms_util.p_log (   'Reset all ''SM'' (Starting Merge) job runs history records to ''IP'' (In Process) at '
                                           || ksbms_util.f_now
                                          );

                         -- Sanity check
                         IF SQL%ROWCOUNT <> 1
                         THEN
                              -- Not fatal, just curious
                              ksbms_util.p_log (   'Expected to update exactly ONE ds_jobruns_history rows, but instead got '
                                                || TO_CHAR (SQL%ROWCOUNT)
                                               );
                         END IF;
                         COMMIT;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error ('Updating Job Runs from IP to DM');
                    END;

                    -- Commit changes, so PONTIS update triggers work again after minimal down-time
                    BEGIN
                         COMMIT;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error ('Committing changes after taking snapshot of change logs'
                                          );
                    END;

----------------------------------------------------------------------------------------------
-- Save the temporary change log records into the archive, if they were
-- processed successfully, then clear out ds_change_log_temp. Do the same
-- with the temporary lookup keyvals table.
----------------------------------------------------------------------------------------------

                    -- Does the option specify 'Halt if there are merge-ready records in change_log_temp'?
                    IF ksbms_util.f_is_yes (ksbms_util.f_get_config_option2 (ls_halt_on_merge_option
                                                                            )
                                           )
                    THEN   -- Yes, it does
                         -- Are there merge-ready records in change log TEMP?
                         DECLARE
                              CURSOR temp_merge_ready_cur
                              IS
                                   SELECT entry_id
                                     FROM ds_change_log_temp
                                    WHERE exchange_status = ls_merge_ready;

                              temp_merge_ready_cur_rec   temp_merge_ready_cur%ROWTYPE;
                         BEGIN
                              -- Close if it is already open (this should never happen)
                              IF temp_merge_ready_cur%ISOPEN
                              THEN
                                   CLOSE temp_merge_ready_cur;
                              END IF;

                              OPEN temp_merge_ready_cur;
                              FETCH temp_merge_ready_cur INTO temp_merge_ready_cur_rec;
                              lb_no_merge_ready_in_temp :=
                                               temp_merge_ready_cur%NOTFOUND;
                              CLOSE temp_merge_ready_cur;

                              -- In this case, we fail if there IS any data
                              IF NOT lb_no_merge_ready_in_temp
                              THEN
                                   -- So we hit the exception handler below
                                   RAISE generic_exception;
                              END IF;
                         EXCEPTION
                              WHEN generic_exception
                              THEN
                                   p_sql_error ('HALTING: There is at least one merge-ready record in change log TEMP!'
                                               );
                              WHEN OTHERS
                              THEN
                                   p_sql_error ('Determining whether change log TEMP has merge-ready records'
                                               );
                         END;
                    END IF;

                    -- Move the merge-ready records into their respective databases
                    -- (this should have been done already... by the normal execution of this process)
                    IF f_move_merge_ready_records (li_num_records_moved_to_pontis,
                                                   li_num_records_moved_to_cansys
                                                  )
                    THEN
                         p_sql_error ('f_move_merge_ready_records() failed at the OUTSET of f_merge_database_changes.'
                                     );
                    END IF;

                    -- Don't log this unless there were some records moved
                    IF   li_num_records_moved_to_pontis
                       + li_num_records_moved_to_cansys > 0
                    THEN
                         p_add_msg (   TO_CHAR (li_num_records_moved_to_pontis)
                                    || ' merge-ready records were moved to Pontis, and '
                                    || TO_CHAR (li_num_records_moved_to_cansys)
                                    || ' merge-ready records were moved to CANSYS,'
                                    || ' BEFORE the merge process'
                                   );
                    ELSE
                         ksbms_util.p_log ('WARNING: There were no merge-ready records BEFORE loading data into change log TEMP.'
                                          );
                    END IF;

                    -- Hoyt 03/18/2002 Allen wants the archive to be "loaded"
                    -- at the end of the "apply changes" process
                    /* Move all the records from ds_change_log_temp into the CHANGE LOG archive,
                    begin
                       -- Save all the LOG_TEMP records
                       insert into ds_change_log_archive
                          (select *
                             from ds_change_log_temp);

                       -- So we avoid the keyvals insert if needless
                       lb_any_records_found := sql%found;
                       ll_nrows := sql%rowcount;
                       commit;
                       ksbms_util.p_log (   'Moved '
                                         || to_char (ll_nrows)
                                         || ' rows from change log TEMP into ARCHIVE');
                    exception
                       when others
                       then
                          p_sql_error ('Moving change log TEMP records into the ARCHIVE');
                    end;
                    -- Insert the corresponding ds_lookup_keyvals_temp records into the KEYVALS archive
                    <<any_change_log_temp_moved>>
                    if lb_any_records_found
                    then
                       begin
                          -- Save all the KEYVALS records
                          insert into ds_lookup_keyvals_archive
                             (select *
                                from ds_lookup_keyvals_temp);

                          ll_nrows := sql%rowcount;

                          -- We should definitely have found some keyvals records
                          if ll_nrows = 0
                          then
                             raise no_data_affected;
                          end if;

                          p_add_msg (   'Moved '
                                     || to_char (sql%rowcount)
                                     || ' rows from keyvals TEMP into ARCHIVE');
                       exception
                          when no_data_affected
                          then
                             p_sql_error ('Failed to FIND corresponding keyvals records in lookup keyvals TEMP');
                          when others
                          then
                             p_sql_error ('Inserting lookup keyvals TEMP into ARCHIVE');
                       end;

                       -- Delete everything in ds_lookup_keyvals_temp FIRST,
                       -- else the ds_change_log_temp delete will fail due to an integrity constraint
                       -- Allen 3/7/2002 RI now enforced to CASCADE DELETES of DS_CHANGE_LOG_TEMP
                       -- so next child-delete section not required

                       begin
                          -- Delete all the records that we just moved into the archive
                          delete from ds_lookup_keyvals_temp;
                          ll_NRows := SQL%ROWCOUNT;

                          -- We should definitely have deleted some keyvals records
                          if ll_NRows = 0 --Allen 3/8/2002
                          then
                             raise no_data_affected;
                          end if;

                          p_add_msg (   'Deleted '
                                     || to_char (ll_NRows)
                                     || ' rows from lookup keyvals TEMP');
                       exception
                          when no_data_affected
                          then
                             p_sql_error ('Failed to DELETE corresponding keyvals records in lookup keyvals TEMP');
                          when others
                          then
                             p_sql_error ('Deleting records from key values TEMP');
                       end;
                       -- Allen 3/7/2002 end change

                       -- Delete everything in ds_change_log_temp
                       begin
                          delete from ds_change_log_temp;

                          ll_nrows := sql%rowcount; -- Allen 3/7/2002 change
                          commit;
                          ksbms_util.p_log (   'Deleted '
                                     || to_char (ll_nrows) -- Allen 3/7/2002 change
                                     || ' rows from change log TEMP');
                       exception
                          when others
                          then
                             p_sql_error ('Deleting records from change log TEMP');
                       end;
                    end if; -- any_change_log_temp_moved
                    */ -- End - Hoyt 03/18/2002 change HOYTFIX Remove dead block

--------------------------------------------------------------------------------------
-- Insert the 'IN-PROCESS' records from ds_change_log into ds_change_log_temp,
-- and insert the corresponding rows from ds_lookup_keyvals into ds_lookup_keyvals_temp
--------------------------------------------------------------------------------------

                    -- Insert all the 'IN-PROCESS' ds_change_log records into ds_change_log_temp

                    -- From PONTIS
                    BEGIN
                         INSERT INTO ds_change_log_temp
                              (SELECT entry_id, sequence_num, psi_job_id,
                                      ls_pontis_schema, -- Different from below: 'P'
                                                        exchange_rule_id,
                                      exchange_type, old_value, new_value,
                                      exchange_status, createdatetime,
                                      createuserid, remarks
                                 FROM ds_change_log
                                WHERE exchange_status = ls_in_process);


                         ll_nrows := SQL%ROWCOUNT; -- Allen 3/7/2002 change

                         COMMIT; -- Allen Marshall, CS - 2003.03.31 - added, moved

                                                   -- Sanity check

                         IF ll_nrows <> li_num_pontis_change_log_recs
                         THEN
                              p_sql_error (   'Expected to insert '
                                           || TO_CHAR (li_num_pontis_change_log_recs
                                                      )
                                           || ' records, but instead inserted '
                                           || TO_CHAR (ll_nrows)
                                           || ' rows.'
                                          );
                         END IF;

                         -- COMMIT; --Allen 1/22/2003 change
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error ('Moving Pontis change log data into the change log TEMP table'
                                          );
                    END;

                    -- From CANSYS
                    BEGIN
                         INSERT INTO ds_change_log_temp
                              (SELECT entry_id, sequence_num, psi_job_id,
                                      ls_cansys_schema, -- Different from above: 'C'
                                                        exchange_rule_id,
                                      exchange_type, old_value, new_value,
                                      exchange_status, createdatetime,
                                      createuserid, remarks
                                 FROM ds_change_log_c
                                WHERE exchange_status = ls_in_process);


                         ll_nrows := SQL%ROWCOUNT; -- Allen 3/7/2002 change
                         COMMIT; -- Allen Marshall, CS - 2003.03.31 - added
                                                   -- Sanity check

                         IF ll_nrows <> li_num_cansys_change_log_recs
                         THEN
                              p_sql_error (   'Expected to insert '
                                           || TO_CHAR (li_num_cansys_change_log_recs
                                                      )
                                           || ' records, but instead inserted '
                                           || TO_CHAR (ll_nrows)
                                           || ' rows.'
                                          );
                         END IF;

                         COMMIT; --Allen 1/22/2003 change
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error ('Moving CANSYS change log data into the change log TEMP table'
                                          );
                    END;

                    -- Insert the corresponding records from lookup_keyvals
                    IF li_num_pontis_change_log_recs > 0
                    THEN
                         BEGIN
                              -- Insert the KEYVALS that correspond to the records we just inserted into ds_change_log_temp
                              INSERT INTO ds_lookup_keyvals_temp
                                   (SELECT a.entry_id, a.keyvalue,
                                           a.key_sequence_num,
                                           a.createdatetime, a.createuserid
                                      FROM ds_lookup_keyvals a
                                     WHERE EXISTS (
                                                SELECT b.entry_id
                                                  FROM ds_change_log_temp b
                                                 WHERE b.entry_id =
                                                                   a.entry_id
                                                   AND b.SCHEMA =
                                                              ls_pontis_schema));

                              ll_nrows := SQL%ROWCOUNT; --Allen 3/7/2002 change
                              COMMIT; --Allen 1/22/2003 changed

                                                        -- There MUST be keyvals records

                              IF ll_nrows = 0 --Allen 3/7/2002 change
                              THEN
                                   RAISE no_data_affected;
                              END IF;


                         EXCEPTION
                              WHEN no_data_affected
                              THEN
                                   -- This is NOT an expected result, because we confirmed there are change log recs
                                   p_sql_error ('No data found, inserting key values from Pontis into TEMP'
                                               );
                              WHEN OTHERS
                              THEN
                                   p_sql_error ('Inserting key values from Pontis into TEMP'
                                               );
                         END;
                    END IF;

                    -- Insert the corresponding records from lookup_keyvals
                    IF li_num_cansys_change_log_recs > 0
                    THEN
                         BEGIN    -- So we have an exception-handler for the INSERT
                               -- Insert the KEYVALS that correspond to the records we just inserted into ds_change_log_temp
                              INSERT INTO ds_lookup_keyvals_temp
                                   (SELECT a.entry_id, a.keyvalue,
                                           a.key_sequence_num,
                                           a.createdatetime, a.createuserid
                                      FROM ds_lookup_keyvals_c a
                                     WHERE EXISTS (
                                                SELECT b.entry_id
                                                  FROM ds_change_log_temp b
                                                 WHERE b.entry_id =
                                                                   a.entry_id
                                                   AND b.SCHEMA =
                                                              ls_cansys_schema));

                              ll_nrows := SQL%ROWCOUNT; --Allen 3/7/2002 change
                              COMMIT; --Allen 1/22/2003 change
                              IF ll_nrows = 0 --Allen 3/7/2002 change
                              THEN
                                   RAISE no_data_affected;
                              END IF;


                         EXCEPTION
                              WHEN no_data_affected
                              THEN
                                   -- This is NOT an expected condition, because we confirmed there are change log recs
                                   p_sql_error ('No data found, inserting key values from CANSYS into TEMP'
                                               );
                              WHEN OTHERS
                              THEN
                                   p_sql_error ('Inserting key values from CANSYS into TEMP'
                                               );
                         END;
                    END IF;

                    -- May as well commit -- we're done getting the data into the working tables
                    BEGIN
                         COMMIT;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error ('Committing after inserting change log and key values into TEMP'
                                          );
                    END;

                    -- How old is 'stale'?
                    ls_result :=
                         ksbms_util.f_get_config_option2 (ls_stale_number_option
                                                         );

                    IF ls_result = ls_failure_return
                    THEN
                         -- Note the problem
                         p_log (psi_job_id,   'The ''Stale days'' option '
                                    || ls_stale_number_option
                                    || ' is not defined in ds_config_options.'
                                    || gs_crlf
                                    || 'It is defaulting to '
                                    || TO_CHAR (gi_default_stale_days)
                                    || ' days.'
                                   );
                         -- f_get_config_option() failed, so take the default
                         li_stale_number_of_days := gi_default_stale_days;
                    ELSE
                         li_stale_number_of_days := TO_NUMBER (ls_result);
                    END IF;

----------------------------------------------------------------------------
-- Pass through all the ds_change_log_temp values, concatenating the keys
-- into the remarks column. This is needed so we can sort by the key values,
-- to identify "ties" where we need to apply the tie-breaking precedence. A
-- "tie" means the same record.table.column was changed by both systems.
----------------------------------------------------------------------------

                    DECLARE
                         -- Loop through all the ds_change_log_temp records
                         CURSOR all_change_log_temp_cursor
                         IS
                              SELECT entry_id, exchange_rule_id, SCHEMA
                                FROM ds_change_log_temp;

                         all_change_log_temp_rec      all_change_log_temp_cursor%ROWTYPE;

                         -- Loop through all the CORRESPONDING ds_lookup_keyvals_temp records
                         CURSOR corresponding_keyvals_cursor (
                              p_entry_id   ds_change_log_temp.entry_id%TYPE
                         )
                         IS
                              SELECT   NVL (keyvalue, ls_missing) this_key,
                                       key_sequence_num
                                  FROM ds_lookup_keyvals_temp
                                 WHERE ds_lookup_keyvals_temp.entry_id =
                                                                   p_entry_id
                              ORDER BY key_sequence_num;

                         corresponding_keyvals_rec    corresponding_keyvals_cursor%ROWTYPE;
                         -- This is the string we're building
                         ls_key_values_concatenated   ds_change_log_temp.remarks%TYPE;
                    BEGIN

                         -- Loop through all the change log records
                         <<change_log_temp_loop>>
                         FOR all_change_log_temp_rec IN
                              all_change_log_temp_cursor
                         LOOP
                              -- Open the keyvalues cursor
                              IF corresponding_keyvals_cursor%ISOPEN
                              THEN
                                   CLOSE corresponding_keyvals_cursor;
                              END IF;

                              OPEN corresponding_keyvals_cursor (all_change_log_temp_rec.entry_id
                                                                );
                              -- Clear out the string we're going to accumulate
                              ls_key_values_concatenated := '|';                                    -- | keeps A + BC from equaling AB + C: |A|BC| <> |AB|C|
                                                                 -- Loop through all the keyvalues for this change log record

                              <<keyval_loop>>
                              lb_missing_data_found := FALSE;

                              LOOP
                                   -- Get then next keyvalue
                                   FETCH corresponding_keyvals_cursor INTO corresponding_keyvals_rec;
                                   EXIT WHEN corresponding_keyvals_cursor%NOTFOUND;

                                   -- Don't proceed if any of the keys is missing
                                   IF    INSTR (corresponding_keyvals_rec.this_key,
                                                ls_missing
                                               ) <> 0
                                      OR corresponding_keyvals_rec.this_key IS NULL
                                   THEN
                                        p_add_msg (   'Key missing: '
                                                   || '  Entry_id is '
                                                   || all_change_log_temp_rec.entry_id
                                                   || ', exchange_rule_id is '
                                                   || all_change_log_temp_rec.exchange_rule_id
                                                   || ', schema is '
                                                   || all_change_log_temp_rec.SCHEMA
                                                   || ', and key sequence number is '
                                                   || TO_CHAR (corresponding_keyvals_rec.key_sequence_num
                                                              )
                                                  );
                                        lb_missing_data_found := TRUE;
                                        ls_key_values_concatenated :=
                                                                    ls_missing; -- So we know to avoid using these remarks
                                        EXIT; -- Give up
                                   ELSE
                                        -- Accumulate the keyvalue (the vertical bar is used to separate values, for ease of debugging)
                                        ls_key_values_concatenated :=
                                                 ls_key_values_concatenated
                                              || corresponding_keyvals_rec.this_key
                                              || '|';
                                   END IF;
                              END LOOP keyval_loop;

                              -- CLOSE the cursor looping through the KEYVALs for this change_log_temp record
                              CLOSE corresponding_keyvals_cursor;

                              -- Save the accumulated keys (or <MISSING> if any were missing)
                              BEGIN
                                   UPDATE ds_change_log_temp
                                      SET remarks = ls_key_values_concatenated
                                    WHERE entry_id =
                                               all_change_log_temp_rec.entry_id;

                                   -- We should have updated exactly one record
                                   IF SQL%ROWCOUNT <> 1
                                   THEN
                                        RAISE no_data_affected;
                                   END IF;

                                   COMMIT; -- ALlen MArshall, CS -2003.04.10

                              EXCEPTION
                                   WHEN no_data_affected
                                   THEN
                                        p_sql_error (   'Failed to update remarks with the accumulated key: '
                                                     || ls_key_values_concatenated
                                                    );
                                   WHEN OTHERS
                                   THEN
                                        p_sql_error ('UPDATE failed while stashing keys in remarks column'
                                                    );
                              END;
                         END LOOP change_log_temp_loop;

                         -- CLOSE the cursor looping through change_log_temp;
                         IF all_change_log_temp_cursor%ISOPEN
                         THEN
                              CLOSE all_change_log_temp_cursor;
                         END IF;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error ('Concatenating the keys');
                    END;

                    -- May as well commit to save the remarks information
                    BEGIN
                         COMMIT;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error ('COMMITing changes after putting keys in TEMP remarks'
                                          );
                    END;

--------------------------------------------------------------------------------
-- Remove any stale records, i.e. records that are duplicates, but one of the pair
-- is older than the number of day identified as "stale" in ds_config_options.
--------------------------------------------------------------------------------

                    -- How many records are we going to mark as stale?
                    DECLARE
                         -- Loop through all the ds_change_log_temp records AGAIN (reusing the cursor name!),
                         -- except those that had a missing key during the concatenation process above.
                         CURSOR all_change_log_temp_cursor
                         IS
                              SELECT     exchange_rule_id, SCHEMA, remarks,
                                         createdatetime
                                    FROM ds_change_log_temp
                                   WHERE remarks <> ls_missing
                                ORDER BY exchange_rule_id,
                                         remarks,
                                         createdatetime DESC
                              FOR UPDATE;

                         all_change_log_temp_rec    all_change_log_temp_cursor%ROWTYPE;
                         prev_change_log_temp_rec   all_change_log_temp_cursor%ROWTYPE;
                         lb_first_rec               BOOLEAN            := TRUE; -- So we don't attempt a comparison on the first fetch
                         ldt_current_date           ds_change_log_temp.createdatetime%TYPE;
                         ldt_previous_date          ds_change_log_temp.createdatetime%TYPE;
                         li_days_difference         PLS_INTEGER;
                         ls_current_schema          ds_change_log_temp.SCHEMA%TYPE;
                         ls_previous_schema         ds_change_log_temp.SCHEMA%TYPE;
                    BEGIN
                         -- Loop through all the change log records
                         li_stale_record_count := 0;

                         <<change_log_temp_loop_number_2>>
                         FOR all_change_log_temp_rec IN
                              all_change_log_temp_cursor
                         LOOP
                              -- On the first fetch, just reset the Boolean, catch the "previous" record, and continue
                              IF lb_first_rec
                              THEN
                                   lb_first_rec := FALSE; -- So we don't do this again
                              ELSE
                                   -- Changing the same table.column applying the same keys (in remarks)
                                   IF     all_change_log_temp_rec.exchange_rule_id =
                                               prev_change_log_temp_rec.exchange_rule_id
                                      AND all_change_log_temp_rec.remarks =
                                               prev_change_log_temp_rec.remarks
                                   THEN
                                        -- How much older than the previous record is THIS record?
                                        li_days_difference :=
                                                prev_change_log_temp_rec.createdatetime
                                              - all_change_log_temp_rec.createdatetime;

                                        -- If it is older than 'STALE' days then mark it as stale
                                        IF li_days_difference >
                                                       li_stale_number_of_days
                                        THEN
                                             BEGIN
                                                  -- Mark the current record as stale
                                                  UPDATE ds_change_log_temp
                                                     SET exchange_status =
                                                              ls_stale -- 'STALE'
                                                   WHERE CURRENT OF all_change_log_temp_cursor;

                                                  ll_nrows := SQL%ROWCOUNT;                           --Allen 3/7/2002 change
                                                                            -- Count the number of stales (the above could have gotten several)
                                                  li_stale_record_count :=
                                                          li_stale_record_count
                                                        + ll_nrows; --Allen 3/7/2002 change
                                             EXCEPTION
                                                  WHEN OTHERS
                                                  THEN
                                                       p_sql_error ('UPDATE failed to mark TEMP row as STALE'
                                                                   );
                                             END;
                                        END IF;
                                   END IF;
                              END IF;

                              -- Capture the record, so we can compare the next one with the previous one
                              prev_change_log_temp_rec :=
                                                       all_change_log_temp_rec;
                         END LOOP change_log_temp_loop_number_2;
                         COMMIT;
                         -- CLOSE the cursor looping through change_log_temp;
                         IF all_change_log_temp_cursor%ISOPEN
                         THEN
                              CLOSE all_change_log_temp_cursor;
                         END IF;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                             BEGIN
                             ROLLBACK;
                              IF all_change_log_temp_cursor%ISOPEN THEN
                                 CLOSE all_change_log_temp_cursor;
                              END IF;
                              p_sql_error ('Removing stale records');
                              END;
                    END;

                    ksbms_util.p_log (   'Just updated '
                                      || TO_CHAR (li_stale_record_count)
                                      || ' STALE records'
                                     );

--------------------------------------------------------------------------------
-- Mark as 'SUPERSEDED' all conflicting changes according to the table.column's
-- precedence, e.g. changes by PONTIS are superseded if CANSYS has precedence.
--------------------------------------------------------------------------------

                    -- Remove any PONTIS-generated records which are have been superseded by CANSYS changes
                    BEGIN
                         UPDATE ds_change_log_temp
                            SET exchange_status = ls_superseded
                          WHERE SCHEMA = ls_pontis_schema
                            AND exchange_status = ls_in_process
                            AND entry_id IN ( -- select all the records that represent duplicate changes with CANSYS having precedence
                                     SELECT pontis_cl.entry_id
                                       FROM ds_change_log_temp pontis_cl,
                                            ds_change_log_temp cansys_cl,
                                            ds_transfer_map
                                      WHERE pontis_cl.SCHEMA =
                                                              ls_pontis_schema
                                        AND cansys_cl.SCHEMA =
                                                              ls_cansys_schema
                                        -- Same table.column
                                        AND pontis_cl.exchange_rule_id =
                                                    cansys_cl.exchange_rule_id
                                        -- Same key
                                        AND pontis_cl.remarks =
                                                             cansys_cl.remarks
                                        -- Both Pontis and CANSYS records are in-process
                                        AND pontis_cl.exchange_status =
                                                                 ls_in_process
                                        AND cansys_cl.exchange_status =
                                                                 ls_in_process
                                        -- And CANSYS has precedence
                                        AND pontis_cl.exchange_rule_id =
                                                 ds_transfer_map.exchange_rule_id
                                        AND ds_transfer_map.precedence =
                                                              ls_cansys_schema);
--                                        COMMIT;  --commented out this commit for 9i
                         li_num_pontis_superseded_recs := SQL%ROWCOUNT;
                         COMMIT;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error ('Marking Pontis records as SUPERSEDED where CANSYS has precedence.'
                                          );
                    END;

                    --Allen 3/7/2002
                    -- Need a COMMIT
                    BEGIN
                         COMMIT;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error (   'COMMITing after updating status of CANSYS records in ds_change_log_temp to '
                                           || ls_superseded
                                          );
                    END;

                    ksbms_util.p_log (   'Just updated '
                                      || TO_CHAR (li_num_pontis_superseded_recs
                                                 )
                                      || ' superseded PONTIS records'
                                     );

                    -- Remove any CANSYS-generated records which are have been superseded by PONTIS changes
                    BEGIN
                         UPDATE ds_change_log_temp
                            SET exchange_status = ls_superseded
                          WHERE SCHEMA = ls_cansys_schema
                            AND entry_id IN ( -- select all the records that represent duplicate changes with CANSYS having precedence
                                     SELECT cansys_cl.entry_id
                                       FROM ds_change_log_temp pontis_cl,
                                            ds_change_log_temp cansys_cl,
                                            ds_transfer_map
                                      WHERE pontis_cl.SCHEMA =
                                                              ls_pontis_schema
                                        AND cansys_cl.SCHEMA =
                                                              ls_cansys_schema
                                        -- Same table.column
                                        AND pontis_cl.exchange_rule_id =
                                                    cansys_cl.exchange_rule_id
                                        -- Same key
                                        AND pontis_cl.remarks =
                                                             cansys_cl.remarks
                                        -- Both Pontis and CANSYS records are in-process
                                        AND pontis_cl.exchange_status =
                                                                 ls_in_process
                                        AND cansys_cl.exchange_status =
                                                                 ls_in_process
                                        -- And Pontis has precedence
                                        AND pontis_cl.exchange_rule_id =
                                                 ds_transfer_map.exchange_rule_id
                                        AND ds_transfer_map.precedence =
                                                              ls_pontis_schema);

                         li_num_cansys_superseded_recs := SQL%ROWCOUNT;
                          COMMIT;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error ('Marking CANSYS records as SUPERSEDED where Pontis has precedence.'
                                          );
                    END;

                    --Allen 3/7/2002
                     -- Need a COMMIT
                    BEGIN
                         COMMIT;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error (   'COMMITing after updating status of CANSYS records in ds_change_log_temp to '
                                           || ls_superseded
                                          );
                    END;

                    ksbms_util.p_log (   'Just updated '
                                      || TO_CHAR (li_num_cansys_superseded_recs
                                                 )
                                      || ' superseded CANSYS records'
                                     );

                    -- Mark any remaining 'IN-PROCESS' records (which are neither stale or superseded)
                    -- as 'MERGEREADY', meaning that a separate process can be run to propagate
                    -- the changes to the target database
                    BEGIN
                         UPDATE ds_change_log_temp
                            SET exchange_status = ls_merge_ready
                          WHERE exchange_status = ls_in_process;

                         li_num_records_set_merge_ready := SQL%ROWCOUNT;
                         COMMIT;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error ('Marking records as MERGE-READY.');
                    END;

                    -- Need a COMMIT so f_move_merge_ready_records() "sees" the MERGEREADY records
                    BEGIN
                         COMMIT;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error (   'COMMITing after updating ds_change_log_temp to '
                                           || ls_merge_ready
                                          );
                    END;

                    ksbms_util.p_log (   'Just updated '
                                      || TO_CHAR (li_num_records_set_merge_ready
                                                 )
                                      || ' records to MERGEREADY'
                                     );

                    -- Move the merge-ready records into their respective databases
                    IF f_move_merge_ready_records (li_num_records_moved_to_pontis,
                                                   li_num_records_moved_to_cansys
                                                  )
                    THEN
                         p_sql_error ('f_move_merge_ready_records() failed at the CONCLUSION of f_merge_database_changes.'
                                     );
                    END IF;

                    -- Don't log this unless there were some records moved
                    IF   li_num_records_moved_to_pontis
                       + li_num_records_moved_to_cansys > 0
                    THEN
                         p_add_msg (   TO_CHAR (li_num_records_moved_to_pontis)
                                    || ' merge-ready records were moved to Pontis, and '
                                    || TO_CHAR (li_num_records_moved_to_cansys)
                                    || ' merge-ready records were moved to CANSYS,'
                                    || ' AFTER the merge process!'
                                   );
                    ELSE
                         p_add_msg ('There were no merge-ready records AFTER loading data into change log TEMP.'
                                   );
                    END IF;

                    -- Sanity check
                    IF li_num_records_set_merge_ready <>
                               li_num_records_moved_to_pontis
                             + li_num_records_moved_to_cansys
                    THEN
                         -- This is non-fatal, because TEMP may have been left in a weird state,
                         -- but it's worth bringing to someone's attention.
                         ksbms_util.p_log (   'Sanity check failed (non-fatal): merge-ready count ('
                                           || TO_CHAR (li_num_records_set_merge_ready
                                                      )
                                           || ') does not equal the sum of the number of Pontis records moved ('
                                           || TO_CHAR (li_num_records_moved_to_pontis
                                                      )
                                           || ') plus the number of CANSYS records moved ('
                                           || TO_CHAR (li_num_records_moved_to_cansys
                                                      )
                                           || ') - the latter add up to '
                                           || TO_CHAR (  li_num_records_moved_to_pontis
                                                       + li_num_records_moved_to_cansys
                                                      )
                                           || '.'
                                          );
                    END IF;

                    -- DELETE the records from the source change logs to signify that they've been "handled"
                    BEGIN
                         DELETE FROM ds_change_log
                               WHERE exchange_status = ls_in_process;

                         COMMIT;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error ('Deleting IN-PROCESS records from Pontis'
                                          );
                    END;

                    -- DELETE the records from the source change logs to signify that they've been "handled"
                    BEGIN
                         DELETE FROM ds_change_log_c
                               WHERE exchange_status = ls_in_process;
                         COMMIT;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error ('Deleting IN-PROCESS records from CANSYS'
                                          );
                    END;

                    --2002.07.11 - FIXFIXFIX - ADD a log message before and after call, check SQLCODE for  success (wrap
                    -- Hoyt 06/26/2002 Execute the EXOR populate_from_pontis procedure
                    ksbms_util.p_log ('Firing CANSYS updating routine POPULATE_FROM_PONTIS...'
                                     );
                    /* =========================================================== CHANGE CHANGE CHANGE =============================== */
                    /* USE @atlastst or DATABASE LINK NAME HERE IN PRODUCTION */
                    -- pontis.populate_from_pontis@atlastest.world;
                    pontis.populate_from_pontis@newcant.world;
                   --   pontis.populate_from_pontis@cant.world; -- new test cansys test database
                    /* Allen Marshall, CS - 200
                    /* TAKE OUT NEXT TWO LINES IN PRODUCTION!!!! */










                    /* This simulates the work that EXOR is doing - archiving then clears out C log. */
                    --UPDATE ds_change_log_c
                    --   SET exchange_status = 'APPLIED'
                    -- WHERE ds_change_log_c.exchange_status = 'MERGED';

                    --COMMIT;
                     /* END OF SECTION TO COMMENT OUT.....*/
                    /* =========================================================== CHANGE CHANGE CHANGE =============================== */
                    p_log (psi_job_id,'Completed CANSYS updating routine POPULATE_FROM_PONTIS'
                              );
                    p_log ('Completed CANSYS updating routine POPULATE_FROM_PONTIS'
                          );
-------------------
-- Success exit
-------------------

                    lb_failed := FALSE;
                    EXIT do_once; -- Done!
               END LOOP do_once;

               -- If we inserted anything into job runs history,
               -- then mark it 'AD' (All Done)
               IF ls_merge_job_id <> ls_job_not_started
               THEN
                    -- Update the job runs history to signify that these "jobs" are done
                    BEGIN
                         UPDATE ds_jobruns_history
                            SET remarks = 'DONE',
                                job_status = ls_job_all_done, -- 'AD'
                                job_end_time = SYSDATE,
                                job_processid = USER
                          WHERE job_id = psi_job_id;

                         -- We better have updated exactly one record
                         IF SQL%ROWCOUNT <> 1
                         THEN
                              p_log (psi_job_id,   'Expected to set ONE job runs record to ''AD'', but instead set '
                                         || TO_CHAR (SQL%ROWCOUNT)
                                        );
                              RAISE no_data_affected;
                         END IF;
                         COMMIT;
                    EXCEPTION
                         WHEN no_data_affected
                         THEN
                              -- This HAS to be there!
                              lb_failed := TRUE; -- It didn't work!
                              p_sql_error ('No data found while updating job runs to All Done'
                                          );
                         WHEN OTHERS
                         THEN
                              lb_failed := TRUE; -- It didn't work!
                              p_sql_error ('Updating job runs to All Done');
                    END;
               END IF;
-----------------------------------------------------------------
-- This exception handler surrounds ALL the code in this function
-----------------------------------------------------------------
          EXCEPTION
               WHEN OTHERS
               THEN
/*            -- If we failed, then clear the flag so Pontis can run!
            -- <ENHANCEMENT> How to handle this?
            if ls_merge_job_id <> ls_job_not_started
            then
               -- Update the job runs history to signify that these "jobs" are done
               begin
                  update ds_jobruns_history
                     set remarks = 'FAILED',
                         job_status = ls_job_merge_failed, -- 'MF'
                         job_end_time = sysdate,
                         job_processid = user
                   where job_id = ls_merge_job_id;

                  -- We better have updated exactly one record
                  if sql%rowcount <> 1
                  then
                     p_add_msg (
                           'In failure block at bottom, expected to set ONE job runs record to ''AD'', but instead set '
                        || to_char (sql%rowcount)
                     );
                     raise no_data_affected;
                  end if;

                  commit; -- So the change is "seen" by Pontis
               exception
                  when no_data_affected
                  then
                     -- This HAS to be there!
                     p_sql_error2 ('No data found while updating job runs to All Done in failure block');
                  when others
                  then
                     p_sql_error2 ('Updating job runs to All Done in failure block');
               end;
            end if;
*/
                    p_clean_up_after_raise_error (ls_context);
          END outer_exception_block; -- This ends the anonymous block created just to have the error handler

                                     -- Save the changes (or not)

          lb_failed := ksbms_util.f_commit_or_rollback (lb_failed, ls_context);
          -- Done-done!
          p_add_msg (   ls_context
                     || ' for Job ID '
                     || psi_job_id
                     || ' completed running at '
                     || ksbms_util.f_now
                    );

          -- If there was any SQL error, return that
          IF LENGTH (ksbms_util.f_get_sql_error) > 0
          THEN
               p_add_msg (gs_crlf || gs_crlf || ksbms_util.f_get_sql_error);
          END IF;

          ksbms_util.p_pop (ls_context);
          -- Log the e-mail message (in case something goes wrong in the next step!)
          ksbms_util.p_log (ksbms_util.gs_email_msg);
          -- Return the result (TRUE means the function failed)
          RETURN (lb_failed);
     EXCEPTION -- GLOBAL EXCEPTION FOR THE FUNCTION
          WHEN OTHERS
          THEN
               BEGIN
                    ksbms_util.p_pop (ls_context);
                    RETURN lb_failed;
               END;
     END f_merge_database_changes;

     FUNCTION f_move_merge_ready_records (
          pio_inserted_into_pontis_count   OUT   PLS_INTEGER,
          pio_inserted_into_cansys_count   OUT   PLS_INTEGER
     )
          RETURN BOOLEAN
     IS
          lb_failed                      BOOLEAN                      := TRUE; -- Until we succeed
          ls_context                     ksbms_util.context_string_type
                                            := 'f_move_merge_ready_records()';
          li_total_keyvals_deleted       PLS_INTEGER;
          li_pontis_keyvals_deleted      PLS_INTEGER;
          li_cansys_keyvals_deleted      PLS_INTEGER;
          li_pontis_change_log_deleted   PLS_INTEGER;
          li_total_deleted               PLS_INTEGER;
     BEGIN
          ksbms_util.p_push (ls_context);

          <<outer_exception_block>>
          BEGIN

               <<do_once>>
               LOOP
                    -- The Pontis and CANSYS moves are broken out because they have
                    -- to be separate transactions (kinda like two-phase commit).
                    --
                    -- Move Pontis
                    IF f_move_merge_ready_to_pontis (pio_inserted_into_pontis_count
                                                    )
                    THEN
                         EXIT do_once; -- Failed
                    END IF;

/*            ksbms_util.p_log (
                  'Inserted '
               || to_char (pio_inserted_into_pontis_count)
               || ' CANSYS records into the Pontis change log'
            );
*/
            -- Move CANSYS
                    IF f_move_merge_ready_to_cansys (pio_inserted_into_cansys_count
                                                    )
                    THEN
                         EXIT do_once; -- Failed
                    END IF;

/*            ksbms_util.p_log (
                  'Inserted '
               || to_char (pio_inserted_into_cansys_count)
               || ' Pontis records into the CANSYS change log'
            );
*/
            -- ds_lookup_keyvals_temp
                    BEGIN
                         -- Remove the TEMP KEYVALS that were just INSERTed into PONTIS's KEYVALS
                         DELETE FROM ds_lookup_keyvals_temp
                               WHERE entry_id IN -- This SELECT is one we just used to select these records into the CANSYS keyvals
                                                 (
                                          SELECT entry_id
                                            FROM ds_change_log_temp
                                           WHERE exchange_status =
                                                               ls_merge_ready
                                             AND (   SCHEMA = ls_cansys_schema
                                                  OR SCHEMA = ls_pontis_schema
                                                 ));

                         li_total_keyvals_deleted := SQL%ROWCOUNT;
                         COMMIT;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error ('Deleting key values from change log TEMP'
                                          );
                    END;

                    -- Sanity check
                    IF li_total_keyvals_deleted <>
                               li_pontis_keyvals_deleted
                             + li_cansys_keyvals_deleted
                    THEN
                         -- This is non-fatal, because TEMP may have been left in a weird state,
                         -- but it's worth bringing to someone's attention.
                         ksbms_util.p_log (   'Sanity check failed (non-fatal): key values deleted count ('
                                           || TO_CHAR (li_total_keyvals_deleted
                                                      )
                                           || ') does not equal the sum of the number of Pontis key value records deleted ('
                                           || TO_CHAR (li_pontis_keyvals_deleted
                                                      )
                                           || ') plus the number of CANSYS key value records deleted ('
                                           || TO_CHAR (li_cansys_keyvals_deleted
                                                      )
                                           || ') - the latter add up to '
                                           || TO_CHAR (  li_pontis_keyvals_deleted
                                                       + li_cansys_keyvals_deleted
                                                      )
                                           || '.'
                                          );
                    END IF;

-----------------------
-- Deleting change logs
-----------------------

                    -- ds_lookup_keyvals
                    BEGIN
                         -- Remove the PONTIS KEYVALS that were just INSERTed into CANSYS's KEYVALS
                         DELETE FROM ds_lookup_keyvals
                               WHERE entry_id IN -- This SELECT is one we just used to select these records into the CANSYS keyvals
                                                 (
                                          SELECT entry_id
                                            FROM ds_change_log_temp
                                           WHERE exchange_status =
                                                               ls_merge_ready
                                             AND SCHEMA = ls_pontis_schema);
                         li_pontis_keyvals_deleted := SQL%ROWCOUNT;
                         COMMIT;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error ('Deleting moved key values records from Pontis'
                                          );
                    END;

                    -- ds_change_log
                    BEGIN
                         DELETE FROM ds_change_log
                               WHERE entry_id IN -- This SELECT is one we just used to select these records into the CANSYS keyvals
                                                 (
                                          SELECT entry_id
                                            FROM ds_change_log_temp
                                           WHERE exchange_status =
                                                               ls_merge_ready
                                             AND SCHEMA = ls_pontis_schema);
                         li_pontis_change_log_deleted := SQL%ROWCOUNT;
                         COMMIT;

                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error ('Deleting merged change log records from Pontis'
                                          );
                    END;

            -- ds_change_log_c is NOW in f_move_merge_ready_to_cansys()
/*            begin
               delete from ds_change_log_c
                     where entry_id in -- This SELECT is one we just used to select these records into the PONTIS keyvals
                                      (select entry_id
                                         from ds_change_log_temp
                                        where exchange_status = ls_merge_ready and schema = ls_cansys_schema);

               li_cansys_change_log_deleted := sql%rowcount;
            exception
               when others
               then
                  p_sql_error ('Deleting merged change log records from CANSYS');
            end;
*/
            -- ds_change_log_temp
                    BEGIN
                         -- We can delete both schema's records in one swell foop
                         DELETE FROM ds_change_log_temp
                               WHERE exchange_status = ls_merge_ready
                                 AND (   SCHEMA = ls_cansys_schema
                                      OR SCHEMA = ls_pontis_schema
                                     );
                         li_total_deleted := SQL%ROWCOUNT;
                         COMMIT;

                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error ('Deleting merged change log records from change log TEMP'
                                          );
                    END;

/*            -- NOW we can do the CANSYS INSERTs and DELETEs as a separate transaction
            if f_move_merge_ready_to_cansys ( pio_inserted_into_cansys_count )
            then
                exit do_once; -- Failed
            end if;
            p_add_msg (   'Inserted '
                        || to_char (pio_inserted_into_cansys_count)
                        || ' Pontis records into the CANSYS change log');

                -- Sanity check
            if li_total_deleted <>   pio_inserted_into_pontis_count
                                   + pio_inserted_into_cansys_count
            then
               -- This is non-fatal, because TEMP may have been left in a weird state,
               -- but it's worth bringing to someone's attention.
               ksbms_util.p_log (
                     'Sanity check failed (non-fatal): change log TEMP deleted count ('
                  || to_char (li_total_deleted)
                  || ') does not equal the sum of the number of CANSYS change log records inserted into Pontis ('
                  || to_char (pio_inserted_into_pontis_count)
                  || ') plus the number of Pontis change log records inserted into CANSYS ('
                  || to_char (pio_inserted_into_cansys_count)
                  || ') - the latter add up to '
                  || to_char (  pio_inserted_into_pontis_count
                              + pio_inserted_into_cansys_count)
                  || '.'
               );
            end if;
*/
            -- <ENHANCEMENT>: Have to return li_cansys_change_log_deleted for this to work
/*          -- Sanity check #2
            if li_total_deleted <>   li_pontis_change_log_deleted
                                   + li_cansys_change_log_deleted
            then
               -- This is non-fatal, because TEMP may have been left in a weird state,
               -- but it's worth bringing to someone's attention.
               ksbms_util.p_log (
                     'Sanity check failed (non-fatal): change log deleted count ('
                  || to_char (li_total_deleted)
                  || ') does not equal the sum of the number of change log records DELETED FROM Pontis ('
                  || to_char (li_pontis_change_log_deleted)
                  || ') plus the number of change log records DELETED FROM CANSYS ('
                  || to_char (li_cansys_change_log_deleted)
                  || ') - the latter add up to '
                  || to_char (  li_pontis_change_log_deleted
                              + li_cansys_change_log_deleted)
                  || '.'
               );
            end if;
*/

-------------------
-- Success exit
-------------------

                    lb_failed := FALSE;
                    EXIT do_once; -- Done!
               END LOOP do_once;
-----------------------------------------------------------------
-- This exception handler surrounds ALL the code in this function
-----------------------------------------------------------------
          EXCEPTION
               WHEN OTHERS
               THEN
                    lb_failed := TRUE; -- Just to be sure
                    ksbms_util.p_clean_up_after_raise_error (ls_context);
          END outer_exception_block; -- This ends the anonymous block created just to have the error handler


-----------------------------------------------------------------
-- Put any clean-up code that munges on the database here
-----------------------------------------------------------------

          ksbms_util.p_pop (ls_context);
          -- Save the changes (or not)
          RETURN ksbms_util.f_commit_or_rollback (lb_failed, ls_context);
     END f_move_merge_ready_records;

     FUNCTION f_move_merge_ready_to_pontis (
          pio_inserted_into_pontis_count   OUT   PLS_INTEGER
     )
          RETURN BOOLEAN
     IS
          PRAGMA AUTONOMOUS_TRANSACTION;                                -- So we can commit JUST THIS db operation
                                         -- Move merge-ready into their target change log tables
                                         -- First insert the merge-ready records into the target
                                         -- tables, then delete them from ds_change_log_temp.
                                         -- NB: This function does NOT do a commit.
          lb_failed                      BOOLEAN                      := TRUE;
          li_total_deleted               PLS_INTEGER;
          -- KEYVALS DELETEs
          li_total_keyvals_deleted       PLS_INTEGER;
          li_pontis_keyvals_deleted      PLS_INTEGER;
          li_cansys_keyvals_deleted      PLS_INTEGER;
          -- Change Log DELETEs
          li_total_change_log_deleted    PLS_INTEGER;
          li_pontis_change_log_deleted   PLS_INTEGER;
          li_cansys_change_log_deleted   PLS_INTEGER;
          -- Used to capture SQLCODE before it's reset
          li_sqlcode                     PLS_INTEGER;
          -- Context
          ls_context                     ksbms_util.context_string_type
                                          := 'f_move_merge_ready_to_pontis()';
     BEGIN

          <<outer_exception_block>>
          BEGIN

               <<do_once>>
               LOOP
---------------------------------------------------------
-- INSERT the merge-ready records from ds_change_log_temp
--    1) Move CANSYS merge-ready records to PONTIS
--    2) Move PONTIS merge-ready records to CANSYS
---------------------------------------------------------

                    -- Move CANSYS records to PONTIS
                    BEGIN
                         -- Move the records that originated from CANSYS and are merge-ready
                         INSERT INTO ds_change_log
                              -- Take the records directly from CANSYS's ds_change_log
                              (SELECT a.entry_id, a.sequence_num,
                                      a.exchange_rule_id, a.exchange_type,
                                      a.old_value, a.new_value, ls_merged, -- 'MERGED'
                                      'FC', -- From CANSYS
                                            a.createdatetime, a.createuserid,
                                      a.remarks
                                 FROM ds_change_log_c a
                                WHERE EXISTS -- If the row is marked as merge-ready in change log TEMP
                                             (
                                           SELECT b.entry_id
                                             FROM ds_change_log_temp b
                                            WHERE b.entry_id = a.entry_id
                                              AND b.exchange_status =
                                                                ls_merge_ready
                                              AND b.SCHEMA = ls_cansys_schema));



                         pio_inserted_into_pontis_count := SQL%ROWCOUNT;
                         COMMIT; -- Allen Marshall, CS - 2003.03.31 - added

                                        -- STAMP LOG TOO
                                             p_log (  ' *****'
                                                        || ksbms_util.crlf
                                                        || ' Data synchronization moved ' || to_char(NVL( pio_inserted_into_pontis_count,0) ) || ' individual change entries  from CANSYS to Pontis.'
                                                        || ksbms_util.crlf
                                                        || ' *****'
                                                   );
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error ('Inserting CANSYS Merge-Ready records into Pontis change log'
                                          );
                    END;

                    -- Commit here to avoid ORA-02079: no new sessions may join a committing distributed transaction???
                    BEGIN
                         COMMIT;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error ('COMMITing in ' || ls_context);
                    END;

                    -- Move the corresponding CANSYS KEYVALS records to PONTIS
                    IF pio_inserted_into_pontis_count > 0
                    THEN
                         BEGIN
                              INSERT INTO ds_lookup_keyvals
                                   (SELECT *
                                      FROM ds_lookup_keyvals_c a
                                     WHERE EXISTS (
                                                SELECT b.entry_id
                                                  FROM ds_change_log_temp b
                                                 WHERE b.entry_id =
                                                                   a.entry_id
                                                   AND b.exchange_status =
                                                                ls_merge_ready
                                                   AND b.SCHEMA =
                                                              ls_cansys_schema))
                                                              ;


                              IF SQL%ROWCOUNT = 0
                              THEN
                                   RAISE no_data_affected;
                              END IF;
                              COMMIT; -- Allen Marshall, CS - 2003.03.31 - added
                         EXCEPTION
                              WHEN no_data_affected
                              THEN
                                   p_sql_error ('No CANSYS key values records inserted into Pontis!'
                                               );
                              WHEN OTHERS
                              THEN
                                   p_sql_error ('Inserting CANSYS key value records into Pontis key values table'
                                               );
                         END;
                    END IF;

                    -- Commit here, separate from the CANSYS transaction in f_move_merge_ready_to_cansys()
                    BEGIN
                         COMMIT;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error ('COMMITing in ' || ls_context);
                    END;

                    -- If we get here, we succeeded!
                    lb_failed := FALSE;
                    EXIT do_once; -- Done!
               END LOOP do_once;
-----------------------------------------------------------------
-- This exception handler surrounds ALL the code in this function
-----------------------------------------------------------------
          EXCEPTION
               WHEN OTHERS
               THEN
                    p_clean_up_after_raise_error (ls_context);
          END outer_exception_block; -- This ends the anonymous block created just to have the error handler

          RETURN (lb_failed);
     END f_move_merge_ready_to_pontis;

     FUNCTION f_move_merge_ready_to_cansys (
          pio_inserted_into_cansys_count   OUT   PLS_INTEGER
     )
          RETURN BOOLEAN
     IS
          PRAGMA AUTONOMOUS_TRANSACTION;                                -- So we can commit JUST THIS db operation
                                         -- Move merge-ready into their target change log tables
                                         -- First insert the merge-ready records into the target
                                         -- tables, then delete them from ds_change_log_temp.
                                         -- NB: This function does NOT do a commit.  -- As of 1/22/2003, it does. ARM
          lb_failed    BOOLEAN                        := TRUE;
          -- Used to capture SQLCODE before it's reset
          li_sqlcode   PLS_INTEGER;
          -- Context
          ls_context   ksbms_util.context_string_type
                                          := 'f_move_merge_ready_to_cansys()';
     BEGIN

          <<outer_exception_block>>
          BEGIN

               <<do_once>>
               LOOP
                    -- Move PONTIS records to CANSYS
                    BEGIN
                         -- Move the records that originated from PONTIS and are merge-ready
                         -- ALlen Marshall, CS - 01/22/2003
                         -- USE EXISTS instead of IN for optimized joins.
                         INSERT INTO ds_change_log_c
                              -- Take the records directly from Pontis's ds_change_log
                              (SELECT a.entry_id, a.sequence_num,
                                      a.exchange_rule_id, a.exchange_type,
                                      a.old_value, a.new_value, 'MERGED',
                                      'FP', -- From PONTIS
                                            a.createdatetime, a.createuserid,
                                      a.remarks
                                 FROM ds_change_log a
                                WHERE EXISTS -- If the row is marked as merge-ready in change log TEMP
                                             (
                                           SELECT b.entry_id
                                             FROM ds_change_log_temp b
                                            WHERE b.entry_id = a.entry_id
                                              AND b.exchange_status =
                                                                  'MERGEREADY'
                                              AND SCHEMA = 'P'));


                         pio_inserted_into_cansys_count := SQL%ROWCOUNT;
                         COMMIT; -- Allen Marshall, CS - 2003.03.31 - added


                                             -- STAMP LOG TOO
                                             p_log ( ' *****'
                                                        || ksbms_util.crlf
                                                        || '  PRE-MERGE - Data synchronization moved ' || to_char(NVL( pio_inserted_into_cansys_count,0) ) || ' individual change entries  from Pontis to CANSYS.'
                                                        || ksbms_util.crlf
                                                        || ' *****'
                                                   );

                         COMMIT; -- Commit locally! Early and often!!
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error ('Inserting Pontis Merge-Ready records into CANSYS change log'
                                          );
                    END;

                    -- Move the corresponding PONTIS KEYVALS records
                    IF pio_inserted_into_cansys_count > 0
                    THEN
                         BEGIN
                                   -- HARD-CODING the 'MERGEREADY' and 'P' eliminate the error: ORA-01008: not all variables bound
                                                            -- ALlen Marshall, CS - 01/22/2003
                              -- USE EXISTS instead of IN for optimized joins.

                              INSERT INTO ds_lookup_keyvals_c
                                   (SELECT *
                                      FROM ds_lookup_keyvals a
                                     WHERE EXISTS (
                                                SELECT b.entry_id
                                                  FROM ds_change_log_temp b
                                                 WHERE b.entry_id =
                                                                   a.entry_id
                                                   AND b.exchange_status =
                                                                  'MERGEREADY'
                                                   AND SCHEMA = 'P'));



                              IF SQL%ROWCOUNT = 0
                              THEN
                                   RAISE no_data_affected;
                              END IF;

                              COMMIT; -- Commit locally! Early and often!!

                         EXCEPTION
                              WHEN no_data_affected
                              THEN
                                   p_sql_error ('No Pontis key values records inserted into CANSYS!'
                                               );
                              WHEN OTHERS
                              THEN
                                   p_sql_error ('Inserting Pontis key value records into CANSYS key values table'
                                               );
                         END;
                    END IF;

--------------------------------------------------------------------
-- DELETE the just-inserted records from the three change log tables
-- ds_change_log, ds_change_log_c, and ds_change_log_temp...
-- but first we have to delete them from the three keyvals tables
-- ds_lookup_keyvals, ds_lookup_keyvals_c, and ds_lookup_keyvals_temp.
--------------------------------------------------------------------

-------------------
-- Deleting KEYVALS
-------------------

                    -- ds_lookup_keyvals_c
                    BEGIN
                         -- Remove the CANSYS KEYVALS that were just INSERTed into PONTIS's KEYVALS
                         -- ALlen Marshall, CS - 01/22/2003
                         -- USE EXISTS instead of IN for optimized joins.

                         DELETE FROM ds_lookup_keyvals_c a
                               WHERE EXISTS -- This SELECT is one we just used to select these records into the CANSYS keyvals
                                            (
                                          SELECT b.entry_id
                                            FROM ds_change_log_temp b
                                           WHERE b.entry_id = a.entry_id
                                             AND b.exchange_status =
                                                                  'MERGEREADY'
                                             AND b.SCHEMA = 'C');

                         COMMIT; -- Commit locally! Early and often!!
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error ('Deleting moved key values records from CANSYS'
                                          );
                    END;

-----------------------
-- Deleting change logs
-----------------------

                    -- ds_change_log_c
                        -- ALlen Marshall, CS - 01/22/2003
                         -- USE EXISTS instead of IN for optimized joins.

                    BEGIN
                         DELETE FROM ds_change_log_c a
                               WHERE EXISTS -- This SELECT is one we just used to select these records into the PONTIS keyvals
                                            (
                                          SELECT b.entry_id
                                            FROM ds_change_log_temp b
                                           WHERE b.entry_id = a.entry_id
                                             AND b.exchange_status =
                                                                  'MERGEREADY'
                                             AND b.SCHEMA = 'C');

                         COMMIT; -- Commit locally! Early and often!!
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error ('Deleting merged change log records from CANSYS'
                                          );
                    END;

                    -- Commit here, independent of the "Pontis transaction"
                    BEGIN
                         COMMIT;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error ('COMMITing in ' || ls_context);
                    END;

                    -- If we get here, we succeeded!
                    lb_failed := FALSE;
                    EXIT do_once; -- Done!
               END LOOP do_once;
-----------------------------------------------------------------
-- This exception handler surrounds ALL the code in this function
-----------------------------------------------------------------
          EXCEPTION
               WHEN OTHERS
               THEN
                    p_clean_up_after_raise_error (ls_context);
          END outer_exception_block; -- This ends the anonymous block created just to have the error handler

          RETURN (lb_failed);
     END f_move_merge_ready_to_cansys;

--2002.07.10 ALlen Marshall, CS - will now force all INS,DEL, MSG records that have been moved around
-- to status MERGEREADY.  These records bypass the merge logic but need to 'seem' merged.
     FUNCTION f_move_change_lookup_records (
          psi_exchange_status           IN       ds_change_log.exchange_status%TYPE,
          psi_job_id                    IN       ds_jobruns_history.job_id%TYPE,
          pio_moved_into_pontis_count   OUT      PLS_INTEGER,
          pio_moved_into_cansys_count   OUT      PLS_INTEGER
     )
          RETURN BOOLEAN
     IS
          PRAGMA AUTONOMOUS_TRANSACTION;                                -- So we can commit JUST THIS db operation
                                         -- Move ds_change_log and ds_lookup_keyvals records of
                                         -- of the specificed exchange_status, e.g. DEL, INS.
                                         -- Unlike f_move_merge_ready_records(), f_move_change_lookup_records()
                                         -- moves records from ds_change_log to ds_change_log_c and vice-versa...
                                         -- ds_change_log_temp is not involved (it is only used for MERGING data).
          lb_failed                      BOOLEAN                      := TRUE;
          li_total_deleted               PLS_INTEGER;
          -- KEYVALS DELETEs
          li_total_keyvals_deleted       PLS_INTEGER;
          li_pontis_keyvals_deleted      PLS_INTEGER;
          li_cansys_keyvals_deleted      PLS_INTEGER;
          -- Change Log DELETEs
          li_total_change_log_deleted    PLS_INTEGER;
          li_pontis_change_log_deleted   PLS_INTEGER;
          li_cansys_change_log_deleted   PLS_INTEGER;
          -- Counters
          li_number_rows_moved           PLS_INTEGER;
          li_number_moved_to_log_c       PLS_INTEGER;
          li_number_moved_to_lookup_c    PLS_INTEGER;
          -- Used to capture SQLCODE before it's reset
          li_sqlcode                     PLS_INTEGER;
          -- Context
          ls_context                     ksbms_util.context_string_type
                                          := 'f_move_change_lookup_records()';
          ls_exchange_status             VARCHAR2 (10)
                                            := psi_exchange_status || 'READY';
     BEGIN

          <<outer_exception_block>>
          BEGIN

               <<do_once>>
               LOOP
---------------------------------------------------------
-- INSERT the records of the specified type into the archive
--    1) Move CANSYS records of the specified type into the archive
--    2) Move PONTIS records of the specified type into the archive
---------------------------------------------------------

                    -- Move CANSYS records to the archive
                    -- Hoyt 03/18/2002 But ONLY if gb_archiving_locally is TRUE
                    IF gb_archiving_locally
                    THEN
                         BEGIN
                              -- Move the records that originated from CANSYS that have the specified exchange_status
                              INSERT INTO ds_change_log_archive
                                   -- Take the records directly from CANSYS's ds_change_log
                                   (SELECT entry_id, sequence_num,
                                           psi_job_id, ls_cansys_schema,
                                           NVL (exchange_rule_id, -1),
                                           NVL (exchange_type, '*'),
                                           NVL (old_value, '*'),

--2002.07.10 ALlen Marshall, CS - will now force all INS,DEL, MSG records that have been moved around to xxxREADY
                                           NVL (new_value, '*'),
                                           ls_exchange_status, --NVL (exchange_status, '*'),
                                           createdatetime, createuserid,
                                           remarks
                                      FROM ds_change_log_c
                                     WHERE exchange_status =
                                                          psi_exchange_status
                                       AND precedence <> 'FP'); -- Exclude records moved there from Pontis


                              li_number_rows_moved := SQL%ROWCOUNT;
                              COMMIT; -- Commit locally! Early and often!!

                              ksbms_util.p_log (   'Inserted '
                                                || TO_CHAR (li_number_rows_moved
                                                           )
                                                || ' CANSYS change log records with exchange_status '
                                                || ls_exchange_status
                                                || ' into the change log archive'
                                               );
                         EXCEPTION
                              WHEN OTHERS
                              THEN
                                  BEGIN
                                  ROLLBACK;
                                   p_sql_error (   'Inserting CANSYS change log records with exchange_status '
                                                || ls_exchange_status
                                                || ' into the change log archive'
                                               );
                                  END;
                         END;

                         -- Move the corresponding CANSYS KEYVALS records into the archive
                         IF li_number_rows_moved > 0
                         THEN
                              BEGIN
                                   INSERT INTO ds_lookup_keyvals_archive
                                        (SELECT entry_id, keyvalue,
                                                key_sequence_num,
                                                createdatetime, createuserid
                                           FROM ds_lookup_keyvals_c
                                          WHERE entry_id IN (
                                                     SELECT entry_id
                                                       FROM ds_change_log_c
                                                      WHERE exchange_status =
                                                                 psi_exchange_status
                                                        AND precedence <> 'FP'));



                                   IF SQL%ROWCOUNT = 0
                                   THEN
                                        RAISE no_data_affected;
                                   END IF;
                                   COMMIT; -- Commit locally! Early and often!!
                                   ksbms_util.p_log (   'Inserted '
                                                     || TO_CHAR (SQL%ROWCOUNT
                                                                )
                                                     || ' CANSYS records with exchange_status '
                                                     || ls_exchange_status
                                                     || ' into the key values archive'
                                                    );
                              EXCEPTION
                                   WHEN no_data_affected
                                   THEN
                                        p_sql_error ('No CANSYS key values records inserted into the archive!'
                                                    );
                                   WHEN OTHERS
                                   THEN
                                        p_sql_error ('Inserting CANSYS key value records into the archive'
                                                    );
                              END;
                         END IF; -- li_number_rows_moved > 0
                    END IF; -- gb_archiving_locally is true

                            -- Do the same as above, only this time move the records into the Pontis tables

                    BEGIN
                         -- Move the CANSYS records of the specified exchange_status into the Pontis change log

                         INSERT INTO ds_change_log
                              -- Take the records directly from CANSYS's ds_change_log
                              (SELECT entry_id, sequence_num,
                                      exchange_rule_id, exchange_type,

--2002.07.10 ALlen Marshall, CS - will now force all INS,DEL, MSG records that have been moved around to xxxREADY
-- used in f_insert_pontis_records() in KSBMS_APPLY_CHANGES package
                                      old_value, new_value,
                                      ls_exchange_status, 'FC', -- From CANSYS
                                      createdatetime, createuserid, remarks
                                 FROM ds_change_log_c
                                WHERE exchange_status = psi_exchange_status
                                  AND precedence <> 'FP'); -- Exclude records moved there from Pontis

                         pio_moved_into_pontis_count := SQL%ROWCOUNT;
                         COMMIT;
                         ksbms_util.p_log (   'Inserted '
                                           || TO_CHAR (pio_moved_into_pontis_count
                                                      )
                                           || ' CANSYS change log records with exchange_status '
                                           || ls_exchange_status
                                           || ' into the Pontis change log'
                                          );
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                             BEGIN
                                  ROLLBACK;
                              p_sql_error (   'Inserting CANSYS change log records with exchange_status '
                                           || ls_exchange_status
                                           || ' into the Pontis change log'
                                          );
                              END;
                    END;

                    -- Move the corresponding CANSYS KEYVALS records into the Pontis keyvals
                    -- 2002.07.09 -- Allen Marshall, CS -- count of rows is in pio_moved_into_pontis_count, not li_number_rows_moved
                    --if li_number_rows_moved > 0
                    IF pio_moved_into_pontis_count > 0
                    THEN
                         DECLARE
                              i_rows_moved   PLS_INTEGER := 0;
                         BEGIN
                              FOR irow IN
                                   (SELECT a.entry_id, c.keyname, c.keyvalue,
                                           c.key_sequence_num,
                                           c.createdatetime,
                                           c.createuserid -- The table AND VIEW have the identical structure
                                      FROM ds_change_log_c a,
                                           ds_lookup_keyvals_c c
                                     WHERE (    a.entry_id = c.entry_id
                                            AND a.exchange_status =
                                                           psi_exchange_status
                                            AND a.precedence <> 'FP'
                                           ))
                              LOOP
                                   INSERT INTO ds_lookup_keyvals
                                               (entry_id, keyname,
                                                keyvalue,
                                                key_sequence_num,
                                                createdatetime,
                                                createuserid
                                               )
                                        VALUES (irow.entry_id, irow.keyname,
                                                irow.keyvalue,
                                                irow.key_sequence_num,
                                                irow.createdatetime,
                                                irow.createuserid
                                               );

                                   IF SQL%ROWCOUNT = 0
                                   THEN
                                        RAISE no_data_affected;
                                   END IF;
                                   i_rows_moved := i_rows_moved + 1;
                              END LOOP;
                              -- at end of loop only - not inside
                              COMMIT; -- Commit locally! Early and often!!

                              ksbms_util.p_log (   'Inserted '
                                                || TO_CHAR (i_rows_moved)
                                                || ' CANSYS records with exchange_status '
                                                || psi_exchange_status
                                                || ' into the Pontis key values'
                                               );
                         EXCEPTION
                              WHEN no_data_affected
                              THEN
                                  BEGIN
                                  ROLLBACK;
                                   p_sql_error ('No CANSYS key values records inserted into the Pontis key values!'
                                               );
                                   END;
                              WHEN OTHERS
                              THEN
                                  BEGIN
                                  ROLLBACK;
                                   p_sql_error ('Inserting CANSYS key value records into the Pontis key values'
                                               );
                                   END;
                         END;
                    END IF;

----------------------------------------------------------------
-- Now do the same as the above (all four INSERTs),
-- only this time the information is from Pontis, not CANSYS
----------------------------------------------------------------
-- Move Pontis records to the archive
-- Hoyt 03/18/2002 But only if gb_archiving_locally is TRUE
                    IF gb_archiving_locally
                    THEN
                         BEGIN
                              -- Move the records that originated from Pontis that have the specified exchange_status
                              INSERT INTO ds_change_log_archive
                                   -- Take the records directly from Pontis's ds_change_log
                                   (SELECT entry_id, sequence_num,
                                           psi_job_id, ls_pontis_schema,
                                           NVL (exchange_rule_id, -1),
                                           NVL (exchange_type, '*'),
                                           NVL (old_value, '*'),

--2002.07.10 ALlen Marshall, CS - will now force all INS,DEL, MSG records that have been moved around to xxxREADY
                                           NVL (new_value, '*'),
                                           psi_exchange_status || 'READY', --NVL (exchange_status, '*'),
                                           createdatetime, createuserid,
                                           remarks
                                      FROM ds_change_log -- Not _c
                                     WHERE exchange_status =
                                                          psi_exchange_status
                                       AND precedence <> 'FC'); -- Exclude records moved there from CANSYS


                              li_number_rows_moved := SQL%ROWCOUNT;
                              COMMIT; -- Commit locally! Early and often!!
                              ksbms_util.p_log (   'Inserted '
                                                || TO_CHAR (li_number_rows_moved
                                                           )
                                                || ' Pontis change log records with exchange_status '
                                                || psi_exchange_status
                                                || ' into the change log archive'
                                               );
                         EXCEPTION
                              WHEN OTHERS
                              THEN
                                  BEGIN
                                  ROLLBACK;
                                   p_sql_error (   'Inserting Pontis change log records with exchange_status '
                                                || psi_exchange_status
                                                || ' into the change log archive'
                                               );
                                    END;

                         END;

                         -- Move the corresponding Pontis KEYVALS records into the archive
                         IF li_number_rows_moved > 0
                         THEN
                              BEGIN
                                   INSERT INTO ds_lookup_keyvals_archive
                                        (SELECT entry_id, keyvalue,
                                                key_sequence_num,
                                                createdatetime, createuserid
                                           FROM ds_lookup_keyvals -- Not _c
                                          WHERE entry_id IN (
                                                     SELECT entry_id
                                                       FROM ds_change_log -- Not _c
                                                      WHERE exchange_status =
                                                                 psi_exchange_status
                                                        AND precedence <> 'FC')); -- Exclude records moved there from CANSYS



                                   IF SQL%ROWCOUNT = 0
                                   THEN
                                        RAISE no_data_affected;
                                   END IF;
                                   COMMIT; -- Commit locally! Early and often!!
                                   ksbms_util.p_log (   'Inserted '
                                                     || TO_CHAR (SQL%ROWCOUNT
                                                                )
                                                     || ' Pontis records with exchange_status '
                                                     || psi_exchange_status
                                                     || ' into the key values archive'
                                                    );
                              EXCEPTION
                                   WHEN no_data_affected
                                   THEN
                                       BEGIN
                                       ROLLBACK;
                                        p_sql_error (   'No Pontis key values records with exchange_status '
                                                     || psi_exchange_status
                                                     || ' were moved into the archive'
                                                    );
                                        END;
                                   WHEN OTHERS
                                   THEN
                                      BEGIN
                                       ROLLBACK;
                                        p_sql_error (   'Moving Pontis key value records with exchange_status '
                                                     || psi_exchange_status
                                                     || ' into the archive'
                                                    );
                                        END;
                              END;
                         END IF; -- li_number_rows_moved > 0
                    END IF; -- gb_archiving_locally is true

                            -- Commit so this transaction is done before starting the f_munge_on_highways_tables() on CANSYS

                    BEGIN
                         COMMIT;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                             BEGIN
                             ROLLBACK;
                              p_sql_error (   'COMMITing before f_munge_on_highways_tables() call in '
                                           || ls_context
                                          );
                              END;
                    END;

                    -- And one more pair, this time moving the records into the CANSYS tables
                    IF f_munge_on_highways_tables (psi_exchange_status,
                                                   pio_moved_into_cansys_count,
                                                   li_number_moved_to_lookup_c
                                                  )
                    THEN
                         EXIT do_once; -- Failed
                    END IF;

                    COMMIT;         -- Commit locally! Early and often!!
                            -- This is important enough for the e-mail message
                    ksbms_util.p_log (   'Inserted '
                                      || TO_CHAR (pio_moved_into_cansys_count)
                                      || ' Pontis change log records with exchange_status '
                                      || psi_exchange_status
                                      || ' into the CANSYS change log'
                                     );
                    ksbms_util.p_log (   'Inserted '
                                      || TO_CHAR (li_number_moved_to_lookup_c)
                                      || ' Pontis records with exchange_status '
                                      || psi_exchange_status
                                      || ' into the CANSYS key values'
                                     );

------------------------------------------------------------------
-- Delete the change logs and keyvals records that were just moved
------------------------------------------------------------------

                    -- Pontis
                    -- Keyvals
                    BEGIN
                         DELETE FROM ds_lookup_keyvals
                               WHERE entry_id IN (
                                          SELECT entry_id
                                            FROM ds_change_log
                                           WHERE exchange_status =
                                                          psi_exchange_status
                                             AND precedence <> 'FC');
                        COMMIT;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                             BEGIN
                                  ROLLBACK;
                              p_sql_error (   'Deleting lookup keyvals records from Pontis with exchange_status '
                                           || psi_exchange_status
                                          );
                              END;
                    END;

                    -- Change Log
                    BEGIN
                         DELETE FROM ds_change_log
                               WHERE exchange_status = psi_exchange_status
                                 AND precedence <> 'FC';

                         COMMIT;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                             BEGIN
                              ROLLBACK;
                              p_sql_error (   'Deleting change log  records from Pontis with exchange_status '
                                           || psi_exchange_status
                                          );
                              END;
                    END;

                    -- Commit changes!
                    BEGIN
                         COMMIT;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error ('COMMITing in ' || ls_context);
                    END;

                    -- If we get here, we succeeded!
                    lb_failed := FALSE;
                    EXIT do_once; -- Done!
               END LOOP do_once;
-----------------------------------------------------------------
-- This exception handler surrounds ALL the code in this function
-----------------------------------------------------------------
          EXCEPTION
               WHEN OTHERS
               THEN
                   BEGIN
                   ROLLBACK;
                    p_clean_up_after_raise_error (ls_context);
                    END;
          END outer_exception_block; -- This ends the anonymous block created just to have the error handler

          RETURN lb_failed;
     END f_move_change_lookup_records;

     PROCEDURE p_test_exception_handling
     IS
          CURSOR test_cur
          IS
               SELECT entry_id
                 FROM ds_change_log;

          ls_error   VARCHAR2 (2000);
     BEGIN
          OPEN test_cur;
          OPEN test_cur;
     EXCEPTION
          WHEN OTHERS
          THEN
               p_sql_error ('Opening test_cur');
     END p_test_exception_handling;

     FUNCTION f_munge_on_highways_tables (
          psi_exchange_status        IN       ds_change_log.exchange_status%TYPE,
          pso_into_log_c_count       OUT      PLS_INTEGER,
          pso_into_keyvals_c_count   OUT      PLS_INTEGER
     )
          RETURN BOOLEAN
     IS
          --PRAGMA AUTONOMOUS_TRANSACTION; -- So we can commit JUST THIS db operation
          lb_failed    BOOLEAN                        := TRUE; -- Until we succeed
          ls_context   ksbms_util.context_string_type
                                            := 'f_munge_on_highways_tables()';
     BEGIN
          ksbms_util.p_push (ls_context);

          <<outer_exception_block>>
          BEGIN

               <<do_once>>
               LOOP
                    BEGIN
                         -- Just in case there is something uncommitted
                         COMMIT;

                         -- For reasons that remain unknown, an "ORA-01008: not all variables bound" error
                         -- arises if a variable (e.g. psi_exchange_status) is used in the WHERE clause,
                         -- when inserting rows into the "remote" system. Therefore, this if-then logic...
                         IF psi_exchange_status = 'INS'
                         THEN
                              -- Move the Pontis records of the specified exchange_status into the CANSYS change log
                              INSERT INTO ds_change_log_c                          -- NB: _c
                                                          -- Take the records directly from Pontis's ds_change_log
                                   (SELECT entry_id, sequence_num,
                                           exchange_rule_id, exchange_type,
                                           old_value, new_value,
                                           exchange_status, 'FP', -- From Pontis
                                           createdatetime, createuserid,
                                           remarks
                                      FROM ds_change_log -- Not _c
                                     WHERE exchange_status = 'INS'
                                       AND precedence <> 'FC'); -- Exclude records moved there from CANSYS
                         ELSIF psi_exchange_status = 'DEL'
                         THEN
                              INSERT INTO ds_change_log_c                          -- NB: _c
                                                          -- Take the records directly from Pontis's ds_change_log
                                   (SELECT entry_id, sequence_num,
                                           exchange_rule_id, exchange_type,
                                           old_value, new_value,
                                           exchange_status, 'FP', -- From Pontis
                                           createdatetime, createuserid,
                                           remarks
                                      FROM ds_change_log -- Not _c
                                     WHERE exchange_status = 'DEL'
                                       AND precedence <> 'FC');                                                                -- Exclude records moved there from CANSYS
                                                                -- Hoyt 06/26/2002 Handle the previously-unhandled MSG case
                         ELSIF psi_exchange_status = 'MSG'
                         THEN
                              INSERT INTO ds_change_log_c                          -- NB: _c
                                                          -- Take the records directly from Pontis's ds_change_log
                                   (SELECT entry_id, sequence_num,
                                           exchange_rule_id, exchange_type,
                                           old_value, new_value,
                                           exchange_status, 'FP', -- From Pontis
                                           createdatetime, createuserid,
                                           remarks
                                      FROM ds_change_log -- Not _c
                                     WHERE exchange_status = 'MSG'
                                       AND precedence <> 'FC'); -- Exclude records moved there from CANSYS
                         ELSE
                              p_bug (   'Unexpected value for exchange_status: '
                                     || psi_exchange_status
                                    );
                              EXIT do_once; -- Failed
                         END IF;
                       -- Return to the calling routine
                         pso_into_log_c_count := SQL%ROWCOUNT;
                         COMMIT; -- Commit locally! Early and often!!

                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error (   'Inserting Pontis change log records with exchange_status '
                                           || psi_exchange_status
                                           || ' into the CANSYS change log'
                                          );
                    END;

                    -- Move the corresponding Pontis KEYVALS records into CANSYS keyvals
                    pso_into_keyvals_c_count := 0;

                    IF pso_into_log_c_count > 0
                    THEN
                         BEGIN
                              IF psi_exchange_status = 'INS'
                              THEN
                                   INSERT INTO ds_lookup_keyvals_c
                                        (SELECT * -- The tables have the identical structure
                                           FROM ds_lookup_keyvals -- Not _c
                                          WHERE entry_id IN (
                                                     SELECT entry_id
                                                       FROM ds_change_log -- Not _c
                                                      WHERE exchange_status =
                                                                         'INS'
                                                        AND precedence <> 'FC')); -- Exclude records moved there from CANSYS
                              ELSE
                                   INSERT INTO ds_lookup_keyvals_c
                                        (SELECT * -- The tables have the identical structure
                                           FROM ds_lookup_keyvals -- Not _c
                                          WHERE entry_id IN (
                                                     SELECT entry_id
                                                       FROM ds_change_log -- Not _c
                                                      WHERE exchange_status =
                                                                         'DEL'
                                                        AND precedence <> 'FC')); -- Exclude records moved there from CANSYS
                              END IF;
--                              COMMIT; --commented out this commit for 9i
                              pso_into_keyvals_c_count := SQL%ROWCOUNT;


                              IF pso_into_keyvals_c_count = 0
                              THEN
                                   RAISE no_data_affected;
                              END IF;

                              COMMIT;
                         EXCEPTION
                              WHEN no_data_affected
                              THEN
                                   p_sql_error ('No Pontis key values records inserted into the CANSYS key values!'
                                               );
                              WHEN OTHERS
                              THEN
                                   p_sql_error ('Inserting Pontis key value records into the CANSYS key values'
                                               );
                         END;
                    END IF;

                    -- CANSYS has to be deleted in this autonomous transaction too
                    -- Keyvals
                    BEGIN
                         IF psi_exchange_status = 'INS'
                         THEN
                              DELETE FROM ds_lookup_keyvals_c
                                    WHERE entry_id IN (
                                               SELECT entry_id
                                                 FROM ds_change_log_c
                                                WHERE exchange_status = 'INS'
                                                  AND precedence <> 'FP');
                         ELSE
                              DELETE FROM ds_lookup_keyvals_c
                                    WHERE entry_id IN (
                                               SELECT entry_id
                                                 FROM ds_change_log_c
                                                WHERE exchange_status = 'DEL'
                                                  AND precedence <> 'FP');
                         END IF;

                         COMMIT; -- Commit locally! Early and often!!
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error (   'Deleting lookup keyvals records from CANSYS with exchange_status '
                                           || psi_exchange_status
                                          );
                    END;

                    -- Change Log
                    BEGIN
                         IF psi_exchange_status = 'INS'
                         THEN
                              DELETE FROM ds_change_log_c
                                    WHERE exchange_status = 'INS'
                                      AND precedence <> 'FP';
                         ELSE
                              DELETE FROM ds_change_log_c
                                    WHERE exchange_status = 'DEL'
                                      AND precedence <> 'FP';
                         END IF;

                         COMMIT; -- Commit locally! Early and often!!
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error (   'Deleting change log  records from CANSYS with exchange_status '
                                           || psi_exchange_status
                                          );
                    END;

-------------------
-- Success exit
-------------------

                    -- Commit here, independent of the "Pontis transaction"
                    BEGIN
                         COMMIT;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error ('COMMITing in ' || ls_context);
                    END;

                    lb_failed := FALSE;
                    EXIT do_once; -- Done!
               END LOOP do_once;
-----------------------------------------------------------------
-- This exception handler surrounds ALL the code in this function
-----------------------------------------------------------------
          EXCEPTION
               WHEN OTHERS
               THEN
                    lb_failed := TRUE; -- Just to be sure
                    ksbms_util.p_clean_up_after_raise_error (ls_context);
          END outer_exception_block; -- This ends the anonymous block created just to have the error handler


-----------------------------------------------------------------
-- Put any clean-up code that munges on the database here
-----------------------------------------------------------------

          ksbms_util.p_pop (ls_context);
          RETURN lb_failed;
     END f_munge_on_highways_tables;

     -- When a Pontis user deletes the most recent inspection, and a previous inspection
     -- exists, then f_replace_deleted_inspevnt() inserts change log update records so
     -- CANSYS receives the data associated with the inspection that is (newly) most recent.
     FUNCTION f_replace_deleted_inspevnt
          RETURN BOOLEAN
     IS
--    123456789012345678901234567890 For checking identifier length
          lb_failed                        BOOLEAN                    := TRUE; -- Until we succeed

------------------------------------------------------------------------------------------------------
-- Booleans that control run-time behavior during development
------------------------------------------------------------------------------------------------------
-- If TRUE, then starts new entry_id in message log; if false, sets Booleans below to production values
          lb_in_development                BOOLEAN                   := FALSE;                                                                                 -- FALSE in production
                                                                               -- If TRUE, then the generated INSERTs are logged for inspection
          lb_logging_generated_sql         BOOLEAN                   := FALSE;                                                                                 -- FALSE in production
                                                                               -- If TRUE, then INSPEVNT 'DEL' records are deleted from the change log and keyvals
          lb_deleting_processed_deletes    BOOLEAN                   := FALSE; -- TRUE in production

------------------------------------------------------------------------------------------------------
-- Misc. program variables
          lb_userinsp_record_exists        BOOLEAN;
          ls_context                       ksbms_util.context_string_type
                                            := 'f_replace_deleted_inspevnt()';
          ls_entry_id                      ds_change_log.entry_id%TYPE;
          ls_brkey                         inspevnt.brkey%TYPE;
          ls_inspkey                       inspevnt.inspkey%TYPE;
          ldt_deleted_inspdate             inspevnt.inspdate%TYPE;
          ldt_most_recent_inspdate         inspevnt.inspdate%TYPE;
          li_num_deleted_inspevnts_fixed   PLS_INTEGER                   := 0;
          li_num_change_logs_inserted      PLS_INTEGER                   := 0;
          ls_insert_change_log_sql         VARCHAR (4000);
          ls_insert_keyvals_sql            VARCHAR (4000);
          ls_insert_change_log_sql_part    VARCHAR (4000);
          ls_insert_keyvals_sql_part       VARCHAR (4000);
          ls_columns_clause                VARCHAR (4000);
          ls_values_clause                 VARCHAR (4000);
          ls_most_recent_inspkey           inspevnt.inspkey%TYPE;
          li_next_sequence_num             PLS_INTEGER;
          ls_bridge_id                     bridge.bridge_id%TYPE;
          ls_inspevnt_column_value         inspevnt.notes%TYPE; -- A long as any INSPEVNT value
          ldt_test                         DATE;
          ls_last_brkey                    inspevnt.brkey%TYPE      := 'NONE';
          ls_last_inspkey                  inspevnt.inspkey%TYPE    := 'NONE';
          -- Change this to 'ls_in_process' if the function call is made after
          -- the exchange_status is set to 'IN-PROCESS' (the so-called snapshot).
          ls_target_exchange_status        ds_change_log.exchange_status%TYPE
                                                                     := 'DEL';
     BEGIN
          ksbms_util.p_push (ls_context);

          <<outer_exception_block>>
          BEGIN
               -- Are we in production or development?
               IF lb_in_development
               THEN
                    -- So we have a defined set of messages in ds_message_log
                    ls_entry_id := f_get_entry_id;
                    ksbms_util.p_log (ls_entry_id,
                                          ls_context
                                       || ' is running in DEVELOPMENT MODE!'
                                     );
               ELSE   -- Make sure the Booleans are set propertly for production
                    -- If TRUE, then the generated INSERTs are logged for inspection
                    lb_logging_generated_sql := FALSE;                                    -- FALSE in production
                                                       -- If TRUE, then INSPEVNT 'DEL' records are deleted from the change log and keyvals
                    lb_deleting_processed_deletes := TRUE; -- TRUE in production
               END IF;

               -- How long does this take?
               ksbms_util.p_log (   ls_context
                                 || ' started replacing deleted most-recent-INSPEVNT records at '
                                 || ksbms_util.f_now
                                );

               <<do_once>>
               LOOP
                    -- Loop through all the ds_lookup_keyvals that have any INSPKEY record
                    DECLARE
                         -- All the DS_CHANGE_LOG records representing DELETEd INSPEVNTs
                         CURSOR inspevnt_cursor
                         IS
                              -- This returns the entry_id, BRKEY, and INSPDATE of each deleted INSPEVNT record
                              SELECT   entry_id, old_value, -- BRKEY
                                                            new_value, -- INSPDATE
                                       createdatetime, createuserid,
                                       exchange_rule_id, remarks
                                  FROM ds_change_log
                                 WHERE exchange_type =
                                                      'DEL'                           -- DELETEd
                                                            -- Not merged yet
                                   AND (precedence = 'C' OR precedence = 'F')
                                   AND exchange_rule_id = -- Minimum INSPEVNT exchange_rule_id
                                              (SELECT MIN (exchange_rule_id)
                                                 FROM ds_transfer_map
                                                WHERE table_name = 'INSPEVNT')
                                   AND exchange_status =
                                                     ls_target_exchange_status
                              ORDER BY old_value, new_value ASC; -- ASC so older INSPEVNTs are processed first

                         /* The above 'select min(...' corresponds to the one in ksbms_pontis.f_pass_update_trigger_params()

                            KEEP THEM IN SYNCH! This code breaks if the sub-select is different!!!!

                            From ksbms_pontis.f_pass_update_trigger_params():

                                 -- Hoyt 1/10/2002 Handle the INS (INSERT) and DEL (DELETE) cases
                                 -- (which are not presently represented in ds_transfer_map).
                                 if    p_column_name = ls_insert
                                    or p_column_name = ls_delete
                                 then
                                    begin
                                       -- Select the minimum exchange rule id corresponding to the INSERTed table
                                       select exchange_rule_id,
                                              transfer_key_map_id,
                                              precedence
                                         into li_exchange_rule_id,
                                              li_transfer_key_map_id,
                                              ls_precedence
                                         from ksbms_robot.ds_transfer_map
                                        -- Same as above only MIN() is applied and column_name is omitted
                                        where exchange_rule_id in (select min (exchange_rule_id)
                                                                     from ksbms_robot.ds_transfer_map
                                                                    where table_name = p_table_name and sit_id <> '-1'); -- Hoyt 01/15/2002 Added '-1' clause
                         */
                         inspevnt_rec       inspevnt_cursor%ROWTYPE;

                         -- All the DS_TRANSFER_MAP records with table_name = 'INSPEVNT'
                         -- (and with non-minus-1 exchange_rule_id, i.e. the VALID ones)
                         CURSOR transfer_map_cursor
                         IS
                              -- This returns the entry_id, BRKEY, and INSPKEY of each deleted INSPEVNT record
                              -- At this writing (2/22/2002 -- ah, a certain symetry there!) the SQL below
                              -- retrieves 27 records from ds_transfer_map... so this function should insert
                              -- 27 records into DS_CHANGE_LOG (and DS_LOOKUP_KEYVALS) for each INSPEVNT 'DEL'
                              -- record it finds in DS_CHANGE_LOG.
                              SELECT table_name, column_name,
                                     exchange_rule_id, precedence
                                FROM ds_transfer_map
                               WHERE (   UPPER (table_name) = 'INSPEVNT'
                                      OR UPPER (table_name) = 'USERINSP'
                                     )
                                 AND transfer_key_map_id > 0; -- Invalid rows are represented by -1 (minus 1)

                         transfer_map_rec   transfer_map_cursor%ROWTYPE;
                    BEGIN
                         -- Let's not have an already-open failure
                         IF inspevnt_cursor%ISOPEN
                         THEN
                              CLOSE inspevnt_cursor;
                         END IF;

                         OPEN inspevnt_cursor;

                         <<inspevnt_cur_loop>>
                         LOOP

                              -- Exiting this loop stays WITHIN the loop in the inspevnt_cursor cursor.
                              -- Therefore, 'exit to_bottom_of_inspevnt_cur_loop' is logically equivalent
                              -- to "continue" in other languages.
                              <<to_bottom_of_inspevnt_cur_loop>>
                              LOOP
                                   -- Get the next deleted INSPEVNT record from ds_change_log
                                   FETCH inspevnt_cursor INTO inspevnt_rec;
                                   EXIT inspevnt_cur_loop WHEN inspevnt_cursor%NOTFOUND;
                                   -- For code clarity
                                   ls_entry_id := inspevnt_rec.entry_id;
                                   ls_brkey := inspevnt_rec.old_value;
                                   ldt_deleted_inspdate :=
                                        TO_DATE (inspevnt_rec.new_value,
                                                 'YYYY-MM-DD HH24:MI:SS'
                                                );

                                   -- Get the most recent INSPDATE
                                   BEGIN
                                        SELECT MAX (inspdate)
                                          INTO ldt_most_recent_inspdate
                                          FROM inspevnt
                                         WHERE brkey = ls_brkey;
                                   EXCEPTION
                                        WHEN NO_DATA_FOUND
                                        THEN
                                             -- Nothing to do! There's no OLDER data to replace the just-deleted INSPEVNT with
                                             EXIT to_bottom_of_inspevnt_cur_loop; -- "continue"
                                        WHEN OTHERS
                                        THEN
                                             p_bug (   'Failed SELECTing the max( INSPDATE ) for BRKEY '
                                                    || ls_brkey
                                                   );
                                             EXIT to_bottom_of_inspevnt_cur_loop; -- "continue"
                                   END;

                                   -- If the most recent INSPDATE is less than the DELETEd INSPDATE,
                                   -- then there is nothing to fix... We are done with this INSPEVNT.
                                   IF ldt_most_recent_inspdate >
                                                          ldt_deleted_inspdate
                                   THEN
                                        -- Nothing to do!
                                        EXIT to_bottom_of_inspevnt_cur_loop;
                                   END IF;

                                   -- If this is the same BRKEY as last time, then we already inserted
                                   -- the replacement data, so there's nothing to do. This will happen
                                   -- if the user deletes more than one INSPEVNT, e.g. deletes a 1999
                                   -- inspection and also a 1997 inspection, leaving a 1993 inspection.
                                   -- In that case, the sort sequence of the inspevnt_cursor will
                                   -- cause us to process the 1997 event first. If THAT (oldest of the
                                   -- two) INSPEVNT is newer that the last one in the database (for
                                   -- this structure), then we will get this far in the code. So we
                                   -- generate all the DS_CHANGE_LOG records accordingly. NEXT we hit
                                   -- the 1999 INSPEVNT record. We do NOT want to send more change log
                                   -- records -- they are redundant. This catches and prevents that.
                                   IF ls_last_brkey = ls_brkey
                                   THEN
                                        -- We already fixed the INSPEVNT data for this bridge - nothing to do!
                                        EXIT to_bottom_of_inspevnt_cur_loop; -- continue
                                   END IF;

                                   -- Remember so we avoid inserting DS_CHANGE_LOG records redundantly
                                   ls_last_brkey := ls_brkey;

                                   -- Get the INSPKEY corresponding to the NEXT most recent INSPDATE
                                   -- This allows retrieving a single specific record... while it's possible to
                                   -- have more than one INSPEVNT record with the same INSPDATE.
                                   BEGIN
                                        SELECT MIN (inspkey) -- min() is needed in case there are two (or more) inspections on same day
                                          INTO ls_most_recent_inspkey
                                          FROM inspevnt
                                         WHERE brkey = ls_brkey
                                           AND inspdate =
                                                      ldt_most_recent_inspdate;
                                   EXCEPTION
                                        WHEN NO_DATA_FOUND
                                        THEN
                                             p_bug (   'Failed to find the INSPKEY corresponding to the most recent INSPEVNT for BRKEY '
                                                    || ls_brkey
                                                    || ' using the INSPDATE '
                                                    || TO_CHAR (ldt_most_recent_inspdate,
                                                                ksbms_util.f_display_datetime_format
                                                               )
                                                   );
                                             EXIT to_bottom_of_inspevnt_cur_loop;
                                        WHEN OTHERS
                                        THEN
                                             p_bug (   'Failed SELECTing the INSPKEY corresponding to the most recent INSPEVNT for BRKEY '
                                                    || ls_brkey
                                                    || ' using the INSPDATE '
                                                    || TO_CHAR (ldt_most_recent_inspdate,
                                                                ksbms_util.f_display_datetime_format
                                                               )
                                                   );
                                             EXIT to_bottom_of_inspevnt_cur_loop;
                                   END;

                                   -- Another DELETEd INSPEVNT needs fixing
                                   li_num_deleted_inspevnts_fixed :=
                                             li_num_deleted_inspevnts_fixed
                                             + 1;
                                   -- Get the BRIDGE_ID for this BRKEY
                                   ls_bridge_id :=
                                        ksbms_apply_changes.f_kdot_brkey_to_bridge_id (ls_brkey
                                                                                      );

                                   -- Loop through the various data in the next-most-recent INSPEVNT,
                                   -- INSERTing ds_change_log and ds_lookup_keyvals records.

                                   -- Let's not have an already-open failure HERE EITHER
                                   IF transfer_map_cursor%ISOPEN
                                   THEN
                                        CLOSE transfer_map_cursor;
                                   END IF;

                                   -- Open the cursor through the INSPEVNT / USERINSP columns
                                   OPEN transfer_map_cursor;
                                   -- Initialize the UPDATE SQL components
                                   ls_insert_change_log_sql :=
                                                 'INSERT INTO DS_CHANGE_LOG (';
                                   -- This part of the DS_CHANGE_LOG INSERT SQL is constant across all the columns
                                   -- for _this_ INSPEVNT / USERINSP record.
                                   -- Items in angle brackets <LIKE THIS> will be replaced for each column,
                                   -- e.g. ENTRY_ID has to change to avoid a duplicate key error,
                                   -- and EXCHANGE_RULE_ID is a function of the column.
                                   ls_insert_change_log_sql_part :=
                                            'INSERT INTO DS_CHANGE_LOG ('
                                         || ' ENTRY_ID,SEQUENCE_NUM, EXCHANGE_RULE_ID, EXCHANGE_TYPE,  OLD_VALUE,  NEW_VALUE, EXCHANGE_STATUS,'
                                         || ' PRECEDENCE, CREATEDATETIME, CREATEUSERID, REMARKS )'
                                         || ' VALUES ('
                                         || ' ''<ENTRY_ID>'', <EXCHANGE_RULE_ID>'
                                         || ', ''UPD'', NULL, ''<NEW_VALUE>'', ''UPD'', ''<PRECEDENCE>'', '
                                         || ksbms_util.f_to_datetime_string (inspevnt_rec.createdatetime
                                                                            )
                                         || ', '''
                                         || inspevnt_rec.createuserid
                                         || ''', '''
                                         || 'INSERTed by '
                                         || ls_context
                                         || ' to replace a DELETEd most-recent-INSPEVNT'
                                         || ''' )';
                                   -- This part of the DS_LOOKUP_KEYVALS SQL is constant across DS_CHANGE_LOG entries.
                                   -- The parts in angle brackets <LIKE THIS> are replaced before the SQL is applied.
                                   ls_insert_keyvals_sql_part :=
                                            'INSERT INTO DS_LOOKUP_KEYVALS '
                                         || '( ENTRY_ID, KEYNAME, KEYVALUE, KEY_SEQUENCE_NUM, CREATEDATETIME, CREATEUSERID ) '
                                         || 'VALUES '
                                         || '( ''<ENTRY_ID>'', ''BRIDGE_ID'', '''
                                         || ls_bridge_id
                                         || ''', 1, '
                                         || ksbms_util.f_to_datetime_string (inspevnt_rec.createdatetime
                                                                            )
                                         || ', '''
                                         || inspevnt_rec.createuserid
                                         || ''' )';

                                   <<transfer_map_cur_loop>>
                                   LOOP

                                        -- Exiting this loop stays WITHIN the loop in the transfer_map_cursor cursor
                                        <<to_bottom_of_transfer_cur_loop>>
                                        LOOP
                                             -- Get the next INSPEVNT column_name from ds_transfer_map
                                             FETCH transfer_map_cursor INTO transfer_map_rec;
                                             EXIT transfer_map_cur_loop WHEN transfer_map_cursor%NOTFOUND;
                                             -- Build the SQL for INSERTing the ds_change_log record
                                             ls_columns_clause :=
                                                      ls_columns_clause
                                                   || transfer_map_rec.column_name
                                                   || ', ';

                                             -- Get the value of this column for the subject INSPEVNT (or USERINSP) record
                                             DECLARE
                                                  ls_sqlstring   VARCHAR2 (4000);
                                                  ll_cur         PLS_INTEGER
                                                       := DBMS_SQL.open_cursor;
                                                  ll_ret         PLS_INTEGER
                                                                         := 0;
                                             BEGIN
                                                  ls_sqlstring :=
                                                           'select '
                                                        || transfer_map_rec.column_name
                                                        || ' from '
                                                        || transfer_map_rec.table_name
                                                        || ' where BRKEY = '''
                                                        || ls_brkey
                                                        || ''' and INSPKEY = '''
                                                        || ls_most_recent_inspkey
                                                        || '''';
                                                  -- Evaluate the SQL
                                                  DBMS_SQL.parse (ll_cur,
                                                                  ls_sqlstring,
                                                                  DBMS_SQL.native
                                                                 );
                                                  -- Associate the first column to the variable receiving the value
                                                  DBMS_SQL.define_column (ll_cur,
                                                                          1,
                                                                          ls_inspevnt_column_value,
                                                                          2000
                                                                         );
                                                  -- Execute the SQL
                                                  ll_ret :=
                                                       DBMS_SQL.execute_and_fetch (ll_cur
                                                                                  );
                                                  -- Assign the returned vaoue to the
                                                  DBMS_SQL.column_value (ll_cur,
                                                                         1,
                                                                         ls_inspevnt_column_value
                                                                        );
                                                  -- Tidy up
                                                  DBMS_SQL.close_cursor (ll_cur
                                                                        );
                                             EXCEPTION
                                                  WHEN OTHERS
                                                  THEN
                                                       DBMS_SQL.close_cursor (ll_cur
                                                                             );
                                                       p_sql_error (   'SELECTing the '
                                                                    || transfer_map_rec.table_name
                                                                    || '.'
                                                                    || transfer_map_rec.column_name
                                                                    || ' value for BRKEY '
                                                                    || ls_brkey
                                                                    || ''' and INSPKEY = '''
                                                                    || ls_most_recent_inspkey
                                                                    || ''''
                                                                   );
                                             END;

                                             -- For setting breakpoints
                                             IF transfer_map_rec.column_name =
                                                                    'INSPDATE'
                                             THEN
                                                  transfer_map_rec.column_name :=
                                                       transfer_map_rec.column_name;
                                             END IF;

                                             -- Did we get a value?
                                             -- If not, then it must be NULL
                                             IF f_ns (ls_inspevnt_column_value)
                                             THEN
                                                  ls_inspevnt_column_value :=
                                                                         NULL; -- Probably redundant
                                             ELSIF ksbms_util.f_get_column_data_type (transfer_map_rec.table_name,
                                                                                      transfer_map_rec.column_name
                                                                                     ) =
                                                                        'DATE'
                                             THEN
                                                  -- This is needed to convert the native '07-JAN-02'
                                                  -- to the expected '2002-01-07 00:00:00 format'
                                                  ls_inspevnt_column_value :=
                                                       TO_CHAR (TO_DATE (ls_inspevnt_column_value
                                                                        ),
                                                                ksbms_util.f_display_datetime_format
                                                               );
                                             END IF;

                                             -- Initialize this copy of the INSERT templates
                                             ls_insert_change_log_sql :=
                                                  ls_insert_change_log_sql_part;
                                             ls_insert_keyvals_sql :=
                                                    ls_insert_keyvals_sql_part;
                                             --
                                             -- Replace the various <PARAMETERS> in the templace SQL
                                             --
                                             -- <ENTRY_ID> is replaced identically in both INSERTs
                                             ls_entry_id := f_get_entry_id;
                                             ls_insert_change_log_sql :=
                                                  ksbms_util.f_substr (ls_insert_change_log_sql,
                                                                       '<ENTRY_ID>',
                                                                       ls_entry_id
                                                                      );
                                             ls_insert_keyvals_sql :=
                                                  ksbms_util.f_substr (ls_insert_keyvals_sql,
                                                                       '<ENTRY_ID>',
                                                                       ls_entry_id
                                                                      );
                                             -- <EXCHANGE_RULE_ID>
                                             ls_insert_change_log_sql :=
                                                  ksbms_util.f_substr (ls_insert_change_log_sql,
                                                                       '<EXCHANGE_RULE_ID>',
                                                                       TO_CHAR (transfer_map_rec.exchange_rule_id
                                                                               )
                                                                      );
                                             -- <NEW_VALUE>
                                             ls_insert_change_log_sql :=
                                                  ksbms_util.f_substr (ls_insert_change_log_sql,
                                                                       '<NEW_VALUE>',
                                                                       ls_inspevnt_column_value
                                                                      );
                                             -- <PRECEDENCE>
                                             ls_insert_change_log_sql :=
                                                  ksbms_util.f_substr (ls_insert_change_log_sql,
                                                                       '<PRECEDENCE>',
                                                                       transfer_map_rec.precedence
                                                                      );

                                             -- For debugging the SQL during development
                                             IF lb_logging_generated_sql
                                             THEN
                                                  ksbms_util.p_log (ls_insert_change_log_sql
                                                                   );
                                                  ksbms_util.p_log (ls_insert_keyvals_sql
                                                                   );
                                             END IF;

                                             -- Execute the SQL to do the INSERTs into the CHANGE log
                                             BEGIN
                                                  EXECUTE IMMEDIATE ls_insert_change_log_sql;
                                             EXCEPTION
                                                  WHEN OTHERS
                                                  THEN
                                                       p_sql_error (   'Executing '
                                                                    || transfer_map_rec.column_name
                                                                    || ' SQL: '
                                                                    || ls_insert_change_log_sql
                                                                   );
                                             END;

                                             BEGIN
                                                  EXECUTE IMMEDIATE ls_insert_keyvals_sql;
                                             EXCEPTION
                                                  WHEN OTHERS
                                                  THEN
                                                       p_sql_error (   'Executing '
                                                                    || transfer_map_rec.column_name
                                                                    || ' SQL: '
                                                                    || ls_insert_keyvals_sql
                                                                   );
                                             END;

                                             -- How many DS_CHANGE_LOG records were inserted?
                                             li_num_change_logs_inserted :=
                                                     li_num_change_logs_inserted
                                                   + 1;
                                        END LOOP; -- <<to_bottom_of_transfer_cur_loop>>
                                   END LOOP; -- transfer_map_cursor
                              END LOOP; -- <<to_bottom_of_inspevnt_cur_loop>>
                         END LOOP; -- inspevnt_cursor

                         CLOSE inspevnt_cursor;
                    END;

--------------------------------------------------------------------------------------------
-- DELETE all the ds_change_log and ds_lookup_keyvals records related to INSPEVNT INSERTs
--------------------------------------------------------------------------------------------

                    IF lb_deleting_processed_deletes
                    THEN
                         -- First, the keyvalues that correspond to ds_change_log records representing INSPEVNT INSERTs
                         BEGIN
                              DELETE FROM ds_lookup_keyvals
                                    WHERE entry_id IN (
                                               SELECT entry_id
                                                 FROM ds_change_log
                                                WHERE ds_change_log.exchange_type =
                                                           'DEL'                                         -- DELETEd
                                                                 -- Not merged yet
                                                  AND (   ds_change_log.precedence =
                                                                           'C'
                                                       OR ds_change_log.precedence =
                                                                           'F'
                                                      )
                                                  AND ds_change_log.exchange_rule_id = -- Minimum INSPEVNT exchange_rule_id
                                                           (SELECT MIN (exchange_rule_id
                                                                       )
                                                              FROM ds_transfer_map
                                                             WHERE table_name =
                                                                        'INSPEVNT')
                                                  AND ds_change_log.exchange_status =
                                                           ls_target_exchange_status);
                                    COMMIT;
                         EXCEPTION
                              WHEN OTHERS
                              THEN
                                   p_sql_error ('DELETING INSPEVNT ''DEL'' records from the KEYVALS'
                                               );
                         END;

                         -- Second, the ds_change_log records representing INSPEVNT INSERTs
                         BEGIN
                              DELETE FROM ds_change_log
                                    WHERE ds_change_log.exchange_type =
                                                      'DEL'                                         -- DELETEd
                                                            -- Not merged yet
                                      AND (   ds_change_log.precedence = 'C'
                                           OR ds_change_log.precedence = 'F'
                                          )
                                      AND ds_change_log.exchange_rule_id = -- Minimum INSPEVNT exchange_rule_id
                                               (SELECT MIN (exchange_rule_id)
                                                  FROM ds_transfer_map
                                                 WHERE table_name = 'INSPEVNT')
                                      AND ds_change_log.exchange_status =
                                                     ls_target_exchange_status;

                              COMMIT;
                         EXCEPTION
                              WHEN OTHERS
                              THEN
                                   p_sql_error ('DELETING INSPEVNT ''DEL'' records from the CHANGE LOG'
                                               );
                         END;
                    ELSE
                         -- Notify the developer that the Boolean is in development mode
                         ksbms_util.p_log (   'In development in '
                                           || ls_context
                                           || ': NOT deleting processed DELETEs!'
                                          );
                    END IF;

-------------------
-- Success exit
-------------------
                    ksbms_util.p_log (   TO_CHAR (li_num_deleted_inspevnts_fixed
                                                 )
                                      || ' most-recent-and-then-deleted INSPEVNT records were ''replaced'' by the NEXT-most-recent INSPEVNT data'
                                     );
                    ksbms_util.p_log (   TO_CHAR (li_num_change_logs_inserted)
                                      || ' DS_CHANGE_LOG records were inserted to convey the ''replacement'' INSPEVNT data to CANSYS'
                                     );
                    lb_failed := FALSE;
                    EXIT do_once; -- Done!
               END LOOP do_once;
-----------------------------------------------------------------
-- This exception handler surrounds ALL the code in this function
-----------------------------------------------------------------
          EXCEPTION
               WHEN OTHERS
               THEN
                    lb_failed := TRUE; -- Just to be sure
                    ksbms_util.p_clean_up_after_raise_error (ls_context);
          END outer_exception_block; -- This ends the anonymous block created just to have the error handler


-----------------------------------------------------------------
-- Put any clean-up code that munges on the database here
-----------------------------------------------------------------
   -- How long did this take?

          ksbms_util.p_log (ls_context || ' finished at ' || ksbms_util.f_now);
          ksbms_util.p_pop (ls_context);
          -- Save the changes (or not)
          RETURN ksbms_util.f_commit_or_rollback (lb_failed, ls_context);
     END f_replace_deleted_inspevnt;

     /* Extracts a token from a string

     Usage:

          -- Sets ls_strunitkey to '5'
          IF f_extract_delimited_token(
             'STRUNITKEY={5}',
             '{',
             '}',
             ls_strunitkey )
     */
     FUNCTION f_extract_delimited_token (
          psi_string            IN       VARCHAR2,
          psi_left_delimiter    IN       VARCHAR2,
          psi_right_delimiter   IN       VARCHAR2,
          pso_token             OUT      VARCHAR2
     )
          RETURN BOOLEAN
     IS
          lb_failed    BOOLEAN                        := TRUE; -- Until we succeed
          ls_context   ksbms_util.context_string_type
                                             := 'f_extract_delimited_token()';
          li_start     PLS_INTEGER;
          li_stop      PLS_INTEGER;
     BEGIN

          <<outer_exception_block>>
          BEGIN

               <<do_once>>
               LOOP
                    -- Make sure the arguments are valid
                    IF f_ns (psi_string)
                    THEN
                         p_bug (   'NULL or empty string passed as the "string" to '
                                || ls_context
                               );
                         EXIT; -- Failed
                    END IF;

                    IF f_ns (psi_left_delimiter)
                    THEN
                         p_bug (   'NULL or empty string passed as the "psi_left_delimiter" to '
                                || ls_context
                               );
                         EXIT; -- Failed
                    END IF;

                    IF f_ns (psi_right_delimiter)
                    THEN
                         p_bug (   'NULL or empty string passed as the "psi_right_delimiter" to '
                                || ls_context
                               );
                         EXIT; -- Failed
                    END IF;

                    -- Find where the delimiters start and stop
                    li_start :=
                         INSTR (LOWER (psi_string),
                                LOWER (psi_left_delimiter));

                    IF li_start <= 0
                    THEN
                         p_bug (   'Failed to find the left delimiter '
                                || psi_left_delimiter
                                || ' in the string '
                                || psi_string
                                || ' in '
                                || ls_context
                               );
                         EXIT; -- Failed
                    END IF;

                    li_stop :=
                         INSTR (LOWER (psi_string),
                                LOWER (psi_right_delimiter)
                               );

                    IF li_stop <= 0
                    THEN
                         p_bug (   'Failed to find the right delimiter '
                                || psi_right_delimiter
                                || ' in the string '
                                || psi_string
                                || ' in '
                                || ls_context
                               );
                         EXIT; -- Failed
                    END IF;

                    -- Extract the string between the delimiters
                    pso_token :=
                         SUBSTR (psi_string,
                                  li_start + 1,
                                  li_stop - li_start - 1
                                );

                    -- Make sure we got something
                    IF f_ns (pso_token)
                    THEN
                         p_bug ('Extracted the empty string in ' || ls_context
                               );
                         EXIT; -- Failed
                    END IF;

-------------------
-- Success exit
-------------------

                    lb_failed := FALSE;
                    EXIT do_once; -- Done!
               END LOOP do_once;
-----------------------------------------------------------------
-- This exception handler surrounds ALL the code in this function
-----------------------------------------------------------------
          EXCEPTION
               WHEN OTHERS
               THEN
                    lb_failed := TRUE; -- Just to be sure
                    ksbms_util.p_clean_up_after_raise_error (ls_context);
          END outer_exception_block; -- This ends the anonymous block created just to have the error handler

          RETURN lb_failed;
     END f_extract_delimited_token;

     -- The STRUCTURE_UNIT and USERSTRUNIT triggers pass the magic string
     -- 'STRUNITKEY={?}' when the strunitkey is not valid (e.g. NULL).
     -- This function finds such instances and puts in the "real" strunitkey,
     -- if one exists. If not, then f_fix_bogus_strunitkeys() marks the
     -- records as '<STILMSNG>', meaning there are still records missing.
     FUNCTION f_fix_bogus_strunitkeys
          RETURN BOOLEAN
     IS
          lb_failed                  BOOLEAN                          := TRUE; -- Until we succeed
          ls_context                 ksbms_util.context_string_type
                                               := 'f_fix_bogus_strunitkeys()';
          ls_strunitkey              structure_unit.strunitkey%TYPE;
          ls_strunitlabel            ds_lookup_keyvals.keyvalue%TYPE;
          ls_bridge_id               ds_lookup_keyvals.keyvalue%TYPE;
          ls_last_bridge_id          ds_lookup_keyvals.keyvalue%TYPE;
          ls_brkey                   bridge.brkey%TYPE;
          ls_last_strunitkey         structure_unit.strunitkey%TYPE    := -1; -- New one?
          li_num_strunitkeys_fixed   PLS_INTEGER                       := 0;
     BEGIN
          ksbms_util.p_push (ls_context);

          <<outer_exception_block>>
          BEGIN

               <<do_once>>
               LOOP
                    ksbms_util.p_log (   'Started fixing STRUNITKEYs at '
                                      || ksbms_util.f_now
                                     );

                    -- The first time this is called,
                    -- get the exchange_rule_id for strunitlabel (it's constant).
                    IF gs_strunitlabel_exc_rule_id =
                                   -1 -- So set in the package body (at bottom)
                    THEN -- It hasn't been initialized yet
                         BEGIN
                              SELECT MAX (exchange_rule_id) -- In case there are two someday
                                INTO gs_strunitlabel_exc_rule_id
                                FROM ds_transfer_map
                               WHERE table_name = 'STRUCTURE_UNIT'
                                 AND column_name = 'STRUNITKEY'; -- changed from strunitlabel to strunitkey dk 2/7/06
                         EXCEPTION
                              WHEN NO_DATA_FOUND
                              THEN
                                   p_sql_error (   'Did not find the strunitkey exchange rule ID in '
                                                || ls_context
                                               );
                              WHEN OTHERS
                              THEN
                                   p_sql_error (   'Selecting the strunitkey exchange rule ID in '
                                                || ls_context
                                               );
                         END;
                    END IF;

                    -- This is needed because FUNCTION_TYPE and SCOURCRIT get keyname BRKEY instead of BRIDGE_ID
                    BEGIN
                         UPDATE ds_lookup_keyvals
                            SET keyname = 'BRIDGE_ID'
                          WHERE keyname = 'BRKEY';
                          COMMIT;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error ('Setting BRKEY keyname to BRIDGE_ID'
                                          );
                    END;

                    -- Loop through all the ds_lookup_keyvals that have the STRUNITKEY embedded
                    DECLARE
                         CURSOR embedded_strunitkeys_cursor
                         IS
                              SELECT entry_id, keyvalue
                                FROM ds_lookup_keyvals
                               WHERE keyvalue LIKE 'STRUNITKEY={%}';

                         embedded_strunitkeys_rec   embedded_strunitkeys_cursor%ROWTYPE;
                    BEGIN
                         -- Let's not have an already-open failure
                         IF embedded_strunitkeys_cursor%ISOPEN
                         THEN
                              CLOSE embedded_strunitkeys_cursor;
                         END IF;

                         OPEN embedded_strunitkeys_cursor;

                         <<main_cursor_loop>>
                         LOOP

                              -- This loop lets us exit the logic sequence while staying within the cursor,
                              -- e.g. if we can't fix this one, exit the in-cursor loop and try to fix the next one.
                              <<in_cursor_loop>>
                              LOOP
                                   -- Get the next embedded keyvalue
                                   FETCH embedded_strunitkeys_cursor INTO embedded_strunitkeys_rec;
                                   EXIT main_cursor_loop WHEN embedded_strunitkeys_cursor%NOTFOUND;

                                   IF embedded_strunitkeys_rec.entry_id =
                                           'E0E508149F524859A71E4D2EF5764860'
                                   THEN
                                        embedded_strunitkeys_rec :=
                                                     embedded_strunitkeys_rec;
                                   END IF;

                                   -- Extract the strunitkey from the keyvalue
                                   IF f_extract_delimited_token (embedded_strunitkeys_rec.keyvalue,
                                                                 '{',
                                                                 '}',
                                                                 ls_strunitkey
                                                                )
                                   THEN
                                        p_bug (   'Failed to extract the strunitkey in '
                                               || ls_context
                                              );
                                        EXIT in_cursor_loop; -- Failed, so try the next one!
                                   END IF;

                                   -- Get the bridge_id that corresponds to this strunitkey from keyvals
                                   BEGIN
                                        SELECT keyvalue
                                          INTO ls_bridge_id
                                          FROM ds_lookup_keyvals
                                         WHERE keyname = 'BRIDGE_ID'
                                           AND entry_id =
                                                    embedded_strunitkeys_rec.entry_id;
                                   EXCEPTION
                                        WHEN NO_DATA_FOUND
                                        THEN
                                             p_sql_error (   'Finding the BRIDGE_ID for a bogus strunitkey '
                                                          || ls_strunitkey
                                                         );
                                        WHEN OTHERS
                                        THEN
                                             p_sql_error (   'SELECTing the BRIDGE_ID for a bogus strunitkey '
                                                          || ls_strunitkey
                                                         );
                                   END;

                                   -- If this is the same bridge_id and strunitkey as last time,
                                   -- then we have already fixed it, so continuing is a waste of time
                                   -- (also generates a no_data_affected error).
                                   IF     ls_strunitkey = ls_last_strunitkey
                                      AND ls_bridge_id = ls_last_bridge_id
                                   THEN
                                        NULL; -- Nothing to do!
                                   ELSE   -- We have work to do
                                        -- Remember these so we catch them next time
                                        ls_last_strunitkey := ls_strunitkey;
                                        ls_last_bridge_id := ls_bridge_id;
                                        -- Convert the bridge_id to the brkey used in structure_unit
                                        ls_brkey :=
                                             ksbms_apply_changes.f_kdot_bridge_id_to_brkey (ls_bridge_id
                                                                                           );

                                        IF f_ns (ls_brkey)
                                        THEN
                                             p_bug (   'Failed to convert bridge_id '
                                                    || ls_bridge_id
                                                    || ' to brkey in '
                                                    || ls_context
                                                   );
                                             EXIT; -- Failed
                                        END IF;

                                        -- Get the applicable strunitlabel out of Pontis
                                        BEGIN
                                             SELECT strunitlabel
                                               INTO ls_strunitlabel
                                               FROM structure_unit
                                              WHERE brkey = ls_brkey
                                                AND strunitkey = ls_strunitkey;
                                        EXCEPTION
                                             WHEN NO_DATA_FOUND
                                             THEN
                                                  -- Try the BRIDGE_ID instead of the BRKEY
                                                  -- The BRKEY will not be the expected KDOT format if it was added within Pontis.
                                                  BEGIN
                                                       SELECT strunitlabel
                                                         INTO ls_strunitlabel
                                                         FROM structure_unit
                                                        WHERE brkey =
                                                                   ls_bridge_id
                                                          AND strunitkey =
                                                                   ls_strunitkey;
                                                  EXCEPTION
                                                       WHEN NO_DATA_FOUND
                                                       THEN
                                                            -- Make this non-fatal...
                                                            -- It will happen when data have been modified,
                                                            -- and then the corresponding record is deleted.
                                                            p_bug (   'Finding the STRUNITLABEL for Bridge ID '
                                                                   || ls_bridge_id
                                                                   || ' and STRUNITKEY '
                                                                   || ls_strunitkey
                                                                  );
                                                            EXIT in_cursor_loop; -- Failed, so try the next one!
                                                       WHEN OTHERS
                                                       THEN
                                                            p_sql_error (   'SELECTing the STRUNITLABEL for Bridge ID '
                                                                         || ls_bridge_id
                                                                         || ' and STRUNITKEY '
                                                                         || ls_strunitkey
                                                                        );
                                                  END;
                                        END;

                                        -- Is the strunitlabel VALID?
                                        IF    f_ns (ls_strunitlabel)
                                           OR ls_strunitlabel = ls_missing
                                           OR LOWER (TRIM (ls_strunitlabel)) =
                                                    '<please enter a unit id>'
                                        THEN
                                             -- We don't have any way to fix it, so mark the change log record
                                             BEGIN
                                                  UPDATE ds_change_log
                                                     SET exchange_status =
                                                              ls_still_missing,
                                                         remarks =
                                                                  'STRUNITLABEL is missing for BRIDGE_ID '
                                                               || ls_bridge_id
                                                               || ' and STRUNITKEY '
                                                               || ls_strunitkey
                                                   WHERE entry_id =
                                                              embedded_strunitkeys_rec.entry_id;

                                                  IF SQL%ROWCOUNT = 0
                                                  THEN
                                                       RAISE no_data_affected;
                                                  END IF;

--                                                  COMMIT;  --commented out this commit for 9i

                                                  p_log (    TO_CHAR (SQL%ROWCOUNT
                                                                  )
                                                       || ' rows were marked as still missing!!'
                                                     );
                                                  COMMIT;
                                             EXCEPTION
                                                  WHEN no_data_affected
                                                  THEN
                                                       p_sql_error (   'No row was affected when UPDATING the CHANGE LOG to <KEYMISNG> for Bridge ID '
                                                                    || ls_bridge_id
                                                                    || ' and STRUNITKEY '
                                                                    || ls_strunitkey
                                                                   );
                                                  WHEN OTHERS
                                                  THEN
                                                       p_sql_error (   'UPDATING the CHANGE LOG to <KEYMISNG> for Bridge ID '
                                                                    || ls_bridge_id
                                                                    || ' and STRUNITKEY '
                                                                    || ls_strunitkey
                                                                   );
                                             END;
                                        ELSE   -- We have a valid STRUNITLABEL, so apply it!
                                             -- Mark the change log record as fixed (in case it was previously
                                             -- marked as <KEYMISNG>). Actually, just set the exchange status
                                             -- to the same thing as the exchange_type, which is how it is set
                                             -- when no keys are missing...
                                             --
                                             -- This has to be done before we actually do the fix,
                                             -- so we can determine which rows are ABOUT to be fixed
                                             -- (after fixing keyvals, there's no way to get back to the change log).
                                             BEGIN
                                                  UPDATE ds_change_log
                                                     SET exchange_status =
                                                                 exchange_type,
                                                         remarks =
                                                                  'f_fix_bogus_strunitkeys() fixed missing STRUNITLABEL ( '
                                                               || ls_strunitlabel
                                                               || ' ) for BRIDGE_ID '
                                                               || ls_bridge_id
                                                               || ' and STRUNITKEY '
                                                               || ls_strunitkey
                                                   -- Hoyt 03/02/2002 Restored the SQL commented out on 2/27/2002
                                                   -- where entry_id = embedded_strunitkeys_rec.entry_id;

                                                   --/* Hoyt 02/27/2002 This is ambiguous and not needed and clobbers too many rows!
                                                  WHERE  entry_id IN (
                                                              SELECT entry_id
                                                                FROM ds_lookup_keyvals
                                                               WHERE keyname =
                                                                          'STRUNITKEY' -- Deb 2/7/2006 corrected from strunitlabel to strunitkey
                                                                 AND keyvalue =
                                                                              'STRUNITKEY={'
                                                                           || ls_strunitkey
                                                                           || '}'
                                                                 AND entry_id IN (
                                                                          SELECT entry_id
                                                                            FROM ds_lookup_keyvals
                                                                           WHERE keyname =
                                                                                      'BRIDGE_ID'
                                                                             AND keyvalue =
                                                                                      ls_bridge_id));


                                                  -- */ Restored 03/02/2002
                                                  IF SQL%ROWCOUNT = 0
                                                  THEN
                                                       RAISE no_data_affected;
                                                  END IF;

--                                                  COMMIT;  --commented out this commit for 9i

                                                  pl (    TO_CHAR (SQL%ROWCOUNT
                                                                  )
                                                       || ' DS_CHANGE_LOG rows were fixed!'
                                                     );
                                                  COMMIT;
                                             EXCEPTION
                                                  WHEN no_data_affected
                                                  THEN
                                                       p_sql_error (   'No row was affected when UPDATING the CHANGE LOG to NOT <keymisng> for Bridge ID '
                                                                    || ls_bridge_id
                                                                    || ' and STRUNITKEY '
                                                                    || ls_strunitkey
                                                                   );
                                                  WHEN OTHERS
                                                  THEN
                                                       p_sql_error (   'UPDATING the CHANGE LOG to NOT <keymisng> for Bridge ID '
                                                                    || ls_bridge_id
                                                                    || ' and STRUNITKEY '
                                                                    || ls_strunitkey
                                                                   );
                                             END;

                                             -- Update the missing strunitlabel rows for this bridge_id
                                             BEGIN
                                                  UPDATE ds_lookup_keyvals
                                                     SET keyvalue =
                                                               ls_strunitlabel
                                                   WHERE keyname =
                                                                'STRUNITLABEL'
                                                     AND keyvalue =
                                                                  'STRUNITKEY={'
                                                               || ls_strunitkey
                                                               || '}'
                                                     AND entry_id IN (
                                                              SELECT entry_id
                                                                FROM ds_lookup_keyvals
                                                               WHERE keyname =
                                                                          'BRIDGE_ID'
                                                                 AND keyvalue =
                                                                          ls_bridge_id);
--                                                     COMMIT;  --commented out this commit for 9i
                                                  IF SQL%ROWCOUNT = 0
                                                  THEN
                                                       RAISE no_data_affected;
                                                  END IF;

--                                                  COMMIT;

                                                  -- Fixed another one!
                                                  li_num_strunitkeys_fixed :=
                                                          li_num_strunitkeys_fixed
                                                        + SQL%ROWCOUNT;
                                                  pl (    TO_CHAR (SQL%ROWCOUNT
                                                                  )
                                                       || ' DS_LOOKUP_KEYVALS rows with were fixed!'
                                                     );
                                                  COMMIT;
                                             EXCEPTION
                                                  WHEN no_data_affected
                                                  THEN
                                                       p_sql_error (   'No data affected when UPDATING the STRUNITLABEL for Bridge ID '
                                                                    || ls_bridge_id
                                                                   );
                                                  WHEN OTHERS
                                                  THEN
                                                       p_sql_error (   'UPDATING the STRUNITLABEL for Bridge ID '
                                                                    || ls_bridge_id
                                                                   );
                                             END;
                                        END IF;
                                   END IF; -- This is the same bridge and strunitkey as last time

                                           -- Get out of this cursor loop!

                                   EXIT in_cursor_loop;
                              END LOOP in_cursor_loop;
                         END LOOP main_cursor_loop;

                         CLOSE embedded_strunitkeys_cursor;
                    END;

                    -- When a structure_unit is first added, it is saved with the STRUNITLABEL
                    -- <Please enter a unit ID>. This is supposed to be replaced by a real
                    -- STRUNITLABEL. The problem arises when it IS replaced: since STRUNITLABEL
                    -- is a key, it appears that there are TWO records, one with the original
                    -- STRUNITLABEL ( <Please...> ) and another with the "real" STRUNITLABEL.
                    -- The follow removes the first instance, _assuming_ that the "real" one
                    -- has been applied.
                    --
                    -- First the keyvals
                    BEGIN
                         DELETE FROM ds_lookup_keyvals
                               WHERE entry_id IN (
                                          SELECT entry_id
                                            FROM ds_change_log
                                           WHERE LOWER (TRIM (new_value)) =
                                                      '<please enter a unit id>'); -- Original bogus value
                            COMMIT;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error ('DELETing KEYVALS for bogus <Please enter a unit ID> STRUNITLABELs'
                                          );
                    END;

                    -- Second the change log
                    BEGIN
                         DELETE FROM ds_change_log
                               WHERE LOWER (TRIM (new_value)) =
                                                   '<please enter a unit id>'; -- Original bogus value

                         COMMIT;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error ('DELETing CHANGE LOG for bogus <Please enter a unit ID> STRUNITLABELs'
                                          );
                    END;

-------------------
-- Success exit
-------------------

                    ksbms_util.p_log (   TO_CHAR (li_num_strunitkeys_fixed)
                                      || ' STRUNITKEYS were ''fixed'' by '
                                      || ls_context
                                     );
                    lb_failed := FALSE;
                    EXIT do_once; -- Done!
               END LOOP do_once;
-----------------------------------------------------------------
-- This exception handler surrounds ALL the code in this function
-----------------------------------------------------------------
          EXCEPTION
               WHEN OTHERS
               THEN
                    lb_failed := TRUE; -- Just to be sure
                    ksbms_util.p_clean_up_after_raise_error (ls_context);
          END outer_exception_block; -- This ends the anonymous block created just to have the error handler

          ksbms_util.p_pop (ls_context);
          ksbms_util.p_log (   'Finished fixing STRUNITKEYs at '
                            || ksbms_util.f_now
                           );
          -- Save the changes (or not)
          RETURN ksbms_util.f_commit_or_rollback (lb_failed, ls_context);
     END f_fix_bogus_strunitkeys;

     -- We do NOT forward any records related to INSPEVNTs other than the most recent.
     -- However, it proved to difficult to apply that business rule in the triggers.
     -- Therefore we now examine any keyvals records related to INSPEVNTs or USERINSPs,
     -- and remove them (and the associated change log records) if they do NOT pertain
     -- to the most recent inspection. This involves the INSPKEY being added to the
     -- keyvals entries, even though it is not specified in ds_transfer_key_map. The
     -- otherwise-unspecified INSPKEY records are removed by this function (even if
     -- the keyvals record pertains to the most recent INSPEVNT) so CANSYS doesn't get
     -- unexpected data.
     FUNCTION f_remove_old_inspdate_records
          RETURN BOOLEAN
     IS
          lb_failed                      BOOLEAN                      := TRUE; -- Until we succeed
          ls_context                     ksbms_util.context_string_type
                                         := 'f_remove_old_inspdate_records()';
          ls_inspkey                     inspevnt.inspkey%TYPE;
          ls_bridge_id                   ds_lookup_keyvals.keyvalue%TYPE;
          ls_brkey                       bridge.brkey%TYPE;
          ldt_this_inspdate              inspevnt.inspdate%TYPE;
          ldt_max_inspdate               inspevnt.inspdate%TYPE;
          li_num_old_inspevnts_deleted   PLS_INTEGER;
          ls_remark                      ds_change_log.remarks%TYPE;
          -- Allen Marshall, CS - 2003.03.06 - keep track of the bridge being processed inside loop iN_cursor_loop below
          ls_last_bridge_id              BRIDGE.BRIDGE_ID%TYPE :='X'; -- initially set to bogus id X, used to keep track of the n-1 bridge that was being checked for bogus inspevnt changes to suppress

     BEGIN

          <<outer_exception_block>>
          BEGIN

               <<do_once>>
               LOOP
                    ksbms_util.p_log (   'Started removing old INSPEVNT records at '
                                      || ksbms_util.f_now
                                     );

                    -- Loop through all the ds_lookup_keyvals that have any INSPKEY record
                    DECLARE
                         CURSOR inspevnt_cursor
                         IS
                              SELECT entry_id, keyvalue
                                FROM ds_lookup_keyvals
                               WHERE keyname = 'INSPKEY';

                         inspevnt_rec   inspevnt_cursor%ROWTYPE;
                    BEGIN
                         -- Let's not have an already-open failure
                         IF inspevnt_cursor%ISOPEN
                         THEN
                              CLOSE inspevnt_cursor;
                         END IF;

                         OPEN inspevnt_cursor;

                         <<main_cursor_loop>>
                         LOOP

                              -- See comments above re in_cursor_loop's function
                              <<in_cursor_loop>>
                              LOOP
                                   -- Get the next INSPEVNT record from keyvals
                                   FETCH inspevnt_cursor INTO inspevnt_rec;
                                   EXIT main_cursor_loop WHEN inspevnt_cursor%NOTFOUND;
                                   -- For code clarity
                                   ls_inspkey := inspevnt_rec.keyvalue;

                                   -- Get the corresponding Bridge ID
                                   BEGIN
                                        SELECT keyvalue
                                          INTO ls_bridge_id
                                          FROM ds_lookup_keyvals
                                         WHERE UPPER (TRIM (keyname)) =
                                                                   'BRIDGE_ID'
                                           AND entry_id =
                                                         inspevnt_rec.entry_id;
                                   EXCEPTION
                                        WHEN NO_DATA_FOUND
                                        THEN
                                             p_sql_error (   'Finding the BRIDGE_ID for the INSPKEY '
                                                          || ls_inspkey
                                                          || '; the entry_id is '''
                                                          || inspevnt_rec.entry_id
                                                          || ''''
                                                         );
                                        WHEN OTHERS
                                        THEN
                                             p_sql_error (   'SELECTing the BRIDGE_ID for INSPKEY '
                                                          || ls_inspkey
                                                          || '; the entry_id is '''
                                                          || inspevnt_rec.entry_id
                                                          || ''''
                                                         );
                                   END;

                                   -- Convert the bridge_id to the brkey used in structure_unit
                                   ls_brkey :=
                                        ksbms_apply_changes.f_kdot_bridge_id_to_brkey (ls_bridge_id
                                                                                      );

                                   IF f_ns (ls_brkey)
                                   THEN
                                        p_bug (   'Failed to convert bridge_id '
                                               || ls_bridge_id
                                               || ' to brkey in '
                                               || ls_context
                                              );
                                        EXIT; -- Failed
                                   END IF;

                                   -- Get the inspdate that corresponds to this inspkey and brkey
                                   BEGIN
                                        SELECT inspdate
                                          INTO ldt_this_inspdate
                                          FROM inspevnt
                                         WHERE brkey = ls_brkey
                                           AND inspkey = ls_inspkey;
                                   EXCEPTION
                                        WHEN NO_DATA_FOUND
                                        THEN
                                             BEGIN
                                                  -- Try again using the BRIDGE_ID -- the expected KDOT brkey won't be there
                                                  -- when the INSPEVNT was added via pontis
                                                  SELECT inspdate
                                                    INTO ldt_this_inspdate
                                                    FROM inspevnt
                                                   WHERE brkey = ls_bridge_id
                                                     AND inspkey = ls_inspkey;
                                             EXCEPTION
                                                  WHEN NO_DATA_FOUND
                                                  THEN
                                                       -- Apparently the INSPEVNT was deleted after being updated
                                                       ls_remark :=
                                                                'Setting status to <RECDELTD> because could not find the INSPDATE for Bridge ID '
                                                             || ls_bridge_id
                                                             || ' and INSPKEY '
                                                             || ls_inspkey;

                                                       IF f_set_exchange_status (inspevnt_rec.entry_id,
                                                                                 ls_rec_deleted,
                                                                                 ls_remark
                                                                                )
                                                       THEN
                                                            pl (    'f_set_exchange_status() failed in '
                                                                 || ls_context
                                                               );
                                                       END IF;

                                                       -- Make this none-fatal -- it means the record was probably deleted
                                                       EXIT in_cursor_loop; -- Failed for this one, try the next
                                                  WHEN OTHERS
                                                  THEN
                                                       p_sql_error (   'SELECTing the INSPDATE for Bridge ID '
                                                                    || ls_bridge_id
                                                                    || ' and INSPKEY '
                                                                    || ls_inspkey
                                                                   );
                                             END;
                                   END;

                                   -- Get the MOST RECENT inspdate that corresponds to this brkey
                                   BEGIN
                                        SELECT MAX (inspdate)
                                          INTO ldt_max_inspdate
                                          FROM inspevnt
                                         WHERE brkey = ls_brkey;
                                   EXCEPTION
                                        WHEN NO_DATA_FOUND
                                        THEN
                                             p_sql_error (   'Finding the MAX INSPDATE for Bridge ID '
                                                          || ls_bridge_id
                                                         );
                                        WHEN OTHERS
                                        THEN
                                             p_sql_error (   'SELECTing the MAX INSPDATE for Bridge ID '
                                                          || ls_bridge_id
                                                         );
                                   END;

                                   -- Is this inspdate the most recent? If not, we have work to do
                                   IF TRUNC (ldt_this_inspdate) <
                                                      TRUNC (ldt_max_inspdate)
                                   THEN
                                        -- Delete all the keyvals records related to this brkey-inspkey combo.
                                        -- We have to allow for the fact that the same INSPKEY can
                                        -- appear on different bridges, hence the self-join to apply both
                                        -- the INSPKEY and BRKEY.

                                        -- Mark the change log to <DELETE> later.
                                        -- If we delete the record and the corresponding ds_lookup_keyvals record(s),
                                        -- then we fail above when trying to find the bridge_id for a given entry_id.
                                        DECLARE
                                               ls_numrecs_processed PLS_INTEGER := 0;
                                        BEGIN
                                             UPDATE ds_change_log
                                                SET exchange_status =
                                                                    '<DELETE>'
                                              WHERE entry_id =
                                                         inspevnt_rec.entry_id;
                                             ls_numrecs_processed := SQL%ROWCOUNT;
                                             IF  ls_numrecs_processed = 0
                                             THEN
                                                  RAISE no_data_affected;
                                             END IF;

                                             -- Sanity check
                                             IF ls_numrecs_processed <> 1
                                             THEN
                                                  p_bug (   'Expected to update only one change log record, but updated '
                                                         || TO_CHAR (SQL%ROWCOUNT
                                                                    )
                                                         || ' instead!'
                                                        );
                                             END IF;

                                             COMMIT;


                                             -- Allen Marshall, CS - 2003.01.07  BEGIN CHANGE TO STAMP LOG WHEN OLD INSPEVNT UPDATES ARE REMOVED
                                             -- Tell e-mail monitor about  deleted record
                                              -- Allen Marshall, CS - 2003.03.06
                                             -- only if new bridge is being processed (or same bridge, but later on

                                             IF ls_bridge_id <> ls_last_bridge_id THEN

                                            -- ARM - 2003.03.12 removed line, moveed after this evaluation
                                            -- ls_last_bridge_id := ls_bridge_id; -- so we skip the next one for the same bridge

                                             p_add_msg (   ksbms_util.crlf
                                                        || ' *****'
                                                        || ksbms_util.crlf
                                                        || ' Data synchronization removed old (not latest)  inspevnt changes  from log for bridge_id  = '
                                                        || ls_bridge_id
                                                        || ' and INSPDATE = '
                                                        || TO_CHAR (ldt_this_inspdate,
                                                                    'YYYY-MM-DD'
                                                                   )
                                                        || ' / INSPKEY = '
                                                        || ls_inspkey
                                                        || ksbms_util.crlf
                                                        || ' *****'
                                                       );
                                             -- STAMP LOG TOO
                                             p_log (   ksbms_util.crlf
                                                    || ' *****'
                                                    || ksbms_util.crlf
                                                    || ' Data synchronization removed old (not latest)  inspevnt changes  from log for bridge_id  = '
                                                    || ls_bridge_id
                                                    || ' and INSPDATE = '
                                                    || TO_CHAR (ldt_this_inspdate,
                                                                'YYYY-MM-DD'
                                                               )
                                                    || ' / INSPKEY = '
                                                    || ls_inspkey
                                                    || ksbms_util.crlf
                                                    || ' *****'
                                                   );
                                        END IF;
                                        -- ls_bridge_id <> ls_last_bridge_id;
                                        -- Allen Marshall, CS - 2003.03.12 - this next statement belongs here....
                                         ls_last_bridge_id := ls_bridge_id; -- so we skip the next one for the same bridge
                                        -- Allen Marshall, CS - 2003.01.07  END CHANGE TO STAMP LOG WHEN OLD INSPEVNT UPDATES ARE REMOVED
                                        EXCEPTION
                                             WHEN no_data_affected
                                             THEN
                                                  p_sql_error (   'Trying to update the CHANGE LOG exchange status to <DELETE> found no records for Bridge ID '
                                                               || ls_bridge_id
                                                               || ' and inspkey '
                                                               || ls_inspkey
                                                              );
                                             WHEN OTHERS
                                             THEN
                                                  p_sql_error (   'UPDATing the CHANGE LOG exchange status to <DELETE> for Bridge ID '
                                                               || ls_bridge_id
                                                               || ' and inspkey '
                                                               || ls_inspkey
                                                              );
                                        END;
                                   END IF;

                                   -- Get out of the in_cursor_loop!
                                   EXIT in_cursor_loop;
                              END LOOP in_cursor_loop;
                         END LOOP main_cursor_loop;

                         CLOSE inspevnt_cursor;
                    END;

                    -- First, the keyvalues that correspond to ds_change_log records marked <DELETE>
                    BEGIN
                         DELETE FROM ds_lookup_keyvals
                               WHERE entry_id IN (
                                           SELECT entry_id
                                             FROM ds_change_log
                                            WHERE exchange_status =
                                                                   '<DELETE>');
                       COMMIT;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error ('DELETING <DELETE> records from the KEYVALS'
                                          );
                    END;

                    -- Second, the ds_change_log records marked <DELETE>
                    BEGIN
                         DELETE FROM ds_change_log
                               WHERE exchange_status = '<DELETE>';
--                               COMMIT;  --commented out this commit for 9i
                         li_num_old_inspevnts_deleted := SQL%ROWCOUNT;

                         COMMIT;

                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error ('DELETING <DELETE> records from the CHANGE LOG'
                                          );
                    END;

                    -- Third, delete ALL the remaining INSPKEY records from keyvals.
                    -- There will be some remaining if any INSPEVNT record DID apply
                    -- to the most recent INSPEVNT... but CANSYS is not expecting them.
                    BEGIN
                         DELETE FROM ds_lookup_keyvals
                               WHERE keyname = 'INSPKEY';
                               COMMIT;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error ('DELETING all INSPKEY records from the KEYVALS table'
                                          );
                    END;

-------------------
-- Success exit
-------------------

                    ksbms_util.p_log (   TO_CHAR (li_num_old_inspevnts_deleted)
                                      || ' not-most-recent INSPEVNT change log records were deleted by '
                                      || ls_context
                                     );
                    lb_failed := FALSE;
                    EXIT do_once; -- Done!
               END LOOP do_once;
-----------------------------------------------------------------
-- This exception handler surrounds ALL the code in this function
-----------------------------------------------------------------
          EXCEPTION
               WHEN OTHERS
               THEN
                    lb_failed := TRUE; -- Just to be sure
                    ksbms_util.p_clean_up_after_raise_error (ls_context);
          END outer_exception_block; -- This ends the anonymous block created just to have the error handler

          ksbms_util.p_log (   'Finished removing old INSPEVNT records at '
                            || ksbms_util.f_now
                           );
          -- Save the changes (or not)
          RETURN ksbms_util.f_commit_or_rollback (lb_failed, ls_context);
     END f_remove_old_inspdate_records;

     -- The USERRWAY triggers pass the magic string 'ON_UNDER={?}' as the ROUTE_PREFIX
     -- when the ROUTE_PREFIX is missing, because the USERRWAY record has just been added
     -- and the ROUTE_PREFIX (and related keys) have not yet been filled in.
     -- This function finds such instances and fills in the various key values,
     -- if they exist. If not, then f_fill_in_userrway_keys() marks the
     -- change log record as '<STILMSNG>', meaning there are still records missing.
     FUNCTION f_fill_in_userrway_keys
          RETURN BOOLEAN
     IS
          lb_failed                   BOOLEAN                         := TRUE; -- Until we succeed
          lb_userrway_record_exists   BOOLEAN;
          lb_result                   BOOLEAN;
          ls_context                  ksbms_util.context_string_type
                                               := 'f_fill_in_userrway_keys()';
          ls_on_under                 userrway.on_under%TYPE;
          ls_bridge_id                ds_lookup_keyvals.keyvalue%TYPE;
          ls_brkey                    bridge.brkey%TYPE;
          ls_tmp_brkey                bridge.brkey%TYPE;
          --ls_array_of_userrway_key_names        key_vals;
          ls_keyvalue                 ds_lookup_keyvals.keyvalue%TYPE;
          ls_keyname                  ds_lookup_keyvals.keyname%TYPE;
          ls_list_of_keynames         VARCHAR2 (2000);
          -- Bogus - remove below
          ls_strunitlabel             ds_lookup_keyvals.keyvalue%TYPE;
          li_num_keys_filled_in       PLS_INTEGER                       := 0;
          li_num_keys_missing         PLS_INTEGER                       := 0;
          ls_remark                   ds_change_log.remarks%TYPE;
     BEGIN

          <<outer_exception_block>>
          BEGIN

               <<do_once>>
               LOOP
                    ksbms_util.p_log (   'Started filling in USERRWAY keys at '
                                      || ksbms_util.f_now
                                     );

                    -- Loop through all the ds_lookup_keyvals that have the ON_UNDER embedded;
                    -- The ON_UNDER string is inserted by f_route_prefix_or_on_under() when
                    -- the ROUTE_PREFIX is missing, in USERRWAY-related triggers.
                    DECLARE
                         CURSOR embedded_on_under_keys_cursor
                         IS
                              SELECT entry_id, keyvalue
                                FROM ds_lookup_keyvals
                               WHERE keyvalue LIKE 'ON_UNDER={%}';

                         embedded_on_under_keys_rec   embedded_on_under_keys_cursor%ROWTYPE;
                    BEGIN
                         -- Let's not have an already-open failure
                         IF embedded_on_under_keys_cursor%ISOPEN
                         THEN
                              CLOSE embedded_on_under_keys_cursor;
                         END IF;

                         OPEN embedded_on_under_keys_cursor;

                         LOOP
                              -- Get the next embedded keyvalue
                              FETCH embedded_on_under_keys_cursor INTO embedded_on_under_keys_rec;
                              EXIT WHEN embedded_on_under_keys_cursor%NOTFOUND;

                              -- Mark the change log as no longer missing (exchange_status = exchange_type).
                              -- The exchange_status will be RESET to <STILMSNG> if any keys are not found
                              DECLARE
                                     ls_numrecs_processed PLS_INTEGER := 0;
                              BEGIN
                                   UPDATE ds_change_log
                                      SET exchange_status = exchange_type
                                    WHERE entry_id =
                                               embedded_on_under_keys_rec.entry_id;
                                   ls_numrecs_processed := SQL%ROWCOUNT;
                                   IF  ls_numrecs_processed = 0
                                   THEN
                                        RAISE no_data_affected;
                                   END IF;
                                   COMMIT;

                              EXCEPTION
                                   WHEN no_data_affected
                                   THEN
                                        p_sql_error (   'No data affected when UPDATING the CHANGE LOG exchange status to NOT missing for entry ID '
                                                     || embedded_on_under_keys_rec.entry_id
                                                    );
                                   WHEN OTHERS
                                   THEN
                                        p_sql_error (   'UPDATING the CHANGE LOG exchange status to NOT missing for entry ID '
                                                     || embedded_on_under_keys_rec.entry_id
                                                    );
                              END;

                              -- Extract the on_under from the keyvalue
                              IF f_extract_delimited_token (embedded_on_under_keys_rec.keyvalue,
                                                            '{',
                                                            '}',
                                                            ls_on_under
                                                           )
                              THEN
                                   p_bug (   'Failed to extract the on_under in '
                                          || ls_context
                                         );
                                   EXIT; -- Failed
                              END IF;

                              -- Get the bridge_id that corresponds to this on_under from keyvals
                              BEGIN
                                   SELECT keyvalue
                                     INTO ls_bridge_id
                                     FROM ds_lookup_keyvals
                                    WHERE keyname = 'BRIDGE_ID'
                                      AND entry_id =
                                               embedded_on_under_keys_rec.entry_id;
                              EXCEPTION
                                   WHEN NO_DATA_FOUND
                                   THEN
                                        p_sql_error (   'Finding the BRIDGE_ID for a bogus on_under '
                                                     || ls_on_under
                                                    );
                                   WHEN OTHERS
                                   THEN
                                        p_sql_error (   'SELECTing the BRIDGE_ID for a bogus on_under '
                                                     || ls_on_under
                                                    );
                              END;

                              -- Convert the bridge_id to the brkey used in structure_unit
                              ls_brkey :=
                                   ksbms_apply_changes.f_kdot_bridge_id_to_brkey (ls_bridge_id
                                                                                 );

                              IF f_ns (ls_brkey)
                              THEN
                                   p_bug (   'Failed to convert bridge_id '
                                          || ls_bridge_id
                                          || ' to brkey in '
                                          || ls_context
                                         );
                                   EXIT; -- Failed
                              END IF;

                              -- Is there a USERRWAY record for this brkey || on_under?
                              BEGIN
                                   SELECT brkey
                                     INTO ls_tmp_brkey
                                     FROM userrway
                                    WHERE brkey = ls_brkey
                                      AND on_under = ls_on_under;
                              EXCEPTION
                                   WHEN NO_DATA_FOUND
                                   THEN
                                        -- Try the Bridge_ID instead -- BRKEY will not conform to KDOT standard if entered on Pontis side
                                        BEGIN
                                             SELECT brkey
                                               INTO ls_tmp_brkey
                                               FROM userrway
                                              WHERE brkey = ls_bridge_id
                                                AND on_under = ls_on_under;
                                        EXCEPTION
                                             WHEN NO_DATA_FOUND
                                             THEN
                                                  -- Mark the parent record as STILL MISSING!
                                                  BEGIN
                                                       UPDATE ds_change_log
                                                          SET exchange_status =
                                                                   ls_still_missing
                                                        WHERE entry_id =
                                                                   embedded_on_under_keys_rec.entry_id;
--                                                        COMMIT;  --commented out this commit for 9i
                                                       IF SQL%ROWCOUNT = 0
                                                       THEN
                                                            RAISE no_data_affected;
                                                       END IF;
                                                       COMMIT;

                                                       -- Save the change to ds_change_log (false means COMMIT)
                                                       -- Hoyt 03/02/2002
                                                       -- lb_result := ksbms_util.f_commit_or_rollback (false, ls_context);
                                                       -- There's nothing more we can do here
                                                       GOTO end_of_loop_through_on_unders;
                                                  EXCEPTION
                                                       WHEN no_data_affected
                                                       THEN
                                                            p_sql_error (   'No data affected when UPDATING the exchange status to STILL MISSING for Bridge ID '
                                                                         || ls_bridge_id
                                                                         || ' and bogus on_under '
                                                                         || ls_on_under
                                                                        );
                                                       WHEN OTHERS
                                                       THEN
                                                            p_sql_error (   'UPDATING the exchange status to STILL MISSING for Bridge ID '
                                                                         || ls_bridge_id
                                                                         || ' and bogus on_under '
                                                                         || ls_on_under
                                                                        );
                                                  END;
                                        END;
                                   WHEN OTHERS
                                   THEN
                                        p_sql_error (   'SELECTing to detect a USERRWAY record for Bridge ID '
                                                     || ls_bridge_id
                                                     || ' and bogus on_under '
                                                     || ls_on_under
                                                    );
                              END;

                              pl (    'Doing brkey '''
                                   || ls_brkey
                                   || ''' and on_under '''
                                   || ls_on_under
                                   || ''''
                                 );               -- Temporary
                                    -- Clear this out (we accumulate it)
                              ls_remark := ls_missing;                          -- Easy to see if it is not yet set
                                                       -- Loop through the various key names, filling them in (if possible)

                              FOR key_name_rec IN
                                   (SELECT DISTINCT column_name
                                               FROM ds_transfer_key_map
                                              WHERE transfer_key_map_id > 2
                                                AND transfer_key_map_id < 9
                                                AND key_sequence_num > 1)
                              LOOP   -- Through all the USERRWAY-related key names
                                   -- Is this keyvalue SUPPOSED to be there, per ds_transfer_key_map?
                                   -- FEAT_CROSS_TYPE often is NOT,
                                   -- and if CLR_ROUTE are expected, then none of the others is valid
                                   BEGIN
                                        SELECT keyvalue
                                          INTO ls_keyvalue
                                          FROM ds_lookup_keyvals
                                         WHERE keyname =
                                                      key_name_rec.column_name
                                           AND entry_id =
                                                    embedded_on_under_keys_rec.entry_id;

                                          -- Allen Marshall, CS - 2003.04.02 - fix for problem with missing CLR_ROUTE
                                          -- We have to recode DIRECTION - it is not a USERRWAY field - use CLR_ROUTE
                                          -- This will return NULL, which is benign....
                                         IF key_name_rec.column_name = 'DIRECTION' THEN
                                                     ls_keyname :='CLR_ROUTE';
                                          ELSE
                                                     ls_keyname := key_name_rec.column_name;
                                         END IF;

                                   EXCEPTION
                                        WHEN NO_DATA_FOUND
                                        THEN
                                             -- Avoiding use of confusingly-extended if-then blocks...
                                             GOTO end_of_loop_through_keynames; -- No work to do;
                                        WHEN OTHERS
                                        THEN
                                             p_sql_error (   'Look to see if '''
                                                          || key_name_rec.column_name
                                                          || ''' is a valid key for this entry'
                                                         );
                                   END;

                                   -- Get the ith keyname's value out of USERRWAY
                                   DECLARE
                                        ls_sqlstring   VARCHAR2 (255);
                                        ll_cur         PLS_INTEGER
                                                      := DBMS_SQL.open_cursor;
                                        ll_ret         PLS_INTEGER    := 0;
                                   BEGIN
                                        ls_sqlstring :=
                                                 'select '
                                   --           || key_name_rec.column_name
                                               || ls_keyname -- we use a local value so we can record
                                              || ' from userrway where brkey = '''
                                              || ls_brkey
                                              || ''' and on_under = '''
                                              || ls_on_under
                                              || '''';
                                        -- For testing SQL outside this procedure
                                        -- ksbms_util.p_log( ls_sqlstring );
                                        -- Evaluate the SQL
                                        DBMS_SQL.parse (ll_cur,
                                                        ls_sqlstring,
                                                        DBMS_SQL.native
                                                       );
                                        -- Associate the first column to the variable receiving the value
                                        DBMS_SQL.define_column (ll_cur,
                                                                1,
                                                                ls_keyvalue,
                                                                30
                                                               );
                                        -- Execute the SQL
                                        ll_ret :=
                                             DBMS_SQL.execute_and_fetch (ll_cur
                                                                        );
                                        -- Assign the returned vaoue to the
                                        DBMS_SQL.column_value (ll_cur,
                                                               1,
                                                               ls_keyvalue
                                                              );
                                        -- Tidy up
                                        DBMS_SQL.close_cursor (ll_cur);
                                   EXCEPTION
                                        WHEN OTHERS
                                        THEN
                                             DBMS_SQL.close_cursor (ll_cur); -- <ENHANCEMENT> Overrides SQLCODE?
                                             p_sql_error (   'SELECTing the '
                                                          || key_name_rec.column_name
                                                          || ' value for Bridge ID '
                                                          || ls_bridge_id
                                                          || ' and on_under '
                                                          || ls_on_under
                                                         );
                                   END;

                                   -- Did we get a keyvalue?
                                   -- The above does NOT return no_data_found, so we examine the value
                                   IF f_ns (ls_keyvalue)
                                   THEN
                                        -- This happens whenever any of the required key columns was never set.
                                        -- Simply mark the exchange_status and skip the update.
                                        IF ls_remark = ls_missing
                                        THEN
                                             -- This is the first time, so do the full message
                                             ls_remark :=
                                                      'Column '
                                                   || key_name_rec.column_name
                                                   || ' is NULL (or empty) for BRKEY '
                                                   || ls_brkey
                                                   || ' and ON_UNDER '
                                                   || ls_on_under;
                                             -- Keep track of the number missing
                                             li_num_keys_missing :=
                                                        li_num_keys_missing
                                                        + 1;
                                        ELSE -- Append this column too
                                             IF INSTR (ls_remark, 'also') = 0
                                             THEN
                                                  ls_remark :=
                                                           ls_remark
                                                        || '; also missing: ';
                                             END IF;

                                             ls_remark :=
                                                      ls_remark
                                                   || key_name_rec.column_name
                                                   || ' ';
                                        END IF;

                                        IF f_set_exchange_status (embedded_on_under_keys_rec.entry_id,
                                                                  ls_still_missing,
                                                                  ls_remark
                                                                 )
                                        THEN
                                             ksbms_util.pl (   'f_set_exchange_status() failed in '
                                                            || ls_context
                                                           );
                                        END IF;

                                        GOTO end_of_loop_through_keynames; -- Fill in what we can
                                   END IF;

                                   -- We have a key value; stash it in the appropriate keyvals rec
                                   BEGIN
                                        UPDATE ds_lookup_keyvals
                                           SET keyvalue = ls_keyvalue
                                         WHERE entry_id =
                                                    embedded_on_under_keys_rec.entry_id
                                           AND keyname =
                                                      key_name_rec.column_name;

                                        IF SQL%ROWCOUNT = 0
                                        THEN
                                             RAISE no_data_affected;
                                        END IF;
                                        COMMIT;
                                   EXCEPTION
                                        WHEN no_data_affected
                                        THEN
                                             p_sql_error (   'No data affected when UPDATING the '
                                                          || key_name_rec.column_name
                                                          || ' keyvalue to '
                                                          || ls_keyvalue
                                                          || ' for Bridge ID '
                                                          || ls_bridge_id
                                                          || ' and bogus on_under '
                                                          || ls_on_under
                                                         );
                                        WHEN OTHERS
                                        THEN
                                             p_sql_error (   'UPDATING the '
                                                          || key_name_rec.column_name
                                                          || ' keyvalue to '
                                                          || ls_keyvalue
                                                          || ' for Bridge ID '
                                                          || ls_bridge_id
                                                          || ' and bogus on_under '
                                                          || ls_on_under
                                                         );
                                   END;

                                   <<end_of_loop_through_keynames>>
                                   ls_brkey := ls_brkey; -- Need an executable statement
                              END LOOP;

                              -- Count how many we fixed
                              li_num_keys_filled_in :=
                                                      li_num_keys_filled_in
                                                      + 1;

                              <<end_of_loop_through_on_unders>>
                              ls_brkey := ls_brkey; -- An executable statement is needed
                         END LOOP;

                         CLOSE embedded_on_under_keys_cursor;
                    END;

-------------------
-- Success exit
-------------------

                    -- The count in li_num_keys_filled_in does NOT take into consideration
                    -- the "failures" which are <STLMISNG> because key value(s) were missing...
                    -- so subtract the number of change log records with keys missing.
                    li_num_keys_filled_in :=
                                    li_num_keys_filled_in
                                    - li_num_keys_missing;
                    ksbms_util.p_log (   TO_CHAR (li_num_keys_filled_in)
                                      || ' change log records had their USERRWAY lookup keys filled in by '
                                      || ls_context
                                     );

                    -- This is the number of ds_change_log records with key values not found (missing or empty)
                    IF li_num_keys_missing > 0
                    THEN
                         p_add_msg (   TO_CHAR (li_num_keys_missing)
                                    || ' Pontis change log records had missing key values, in '
                                    || ls_context
                                   );
                    END IF;

                    lb_failed := FALSE;
                    EXIT do_once; -- Done!
               END LOOP do_once;
-----------------------------------------------------------------
-- This exception handler surrounds ALL the code in this function
-----------------------------------------------------------------
          EXCEPTION
               WHEN OTHERS
               THEN
                    lb_failed := TRUE; -- Just to be sure
                    ksbms_util.p_clean_up_after_raise_error (ls_context);
          END outer_exception_block; -- This ends the anonymous block created just to have the error handler

          ksbms_util.p_log (   'Finished filling in USERRWAY keys at '
                            || ksbms_util.f_now
                           );
          -- Save the changes (or not)
          RETURN ksbms_util.f_commit_or_rollback (lb_failed, ls_context);
     END f_fill_in_userrway_keys;

     -- No argument "wrapper" calls the "real one"
     PROCEDURE ds_sync_exec
     IS
     BEGIN
          ds_sync_exec (gl_job_id);
     END ds_sync_exec;

     -- This is the real one, to be called by the Oracle scheduler
     PROCEDURE ds_sync_exec (
          pli_ora_dbms_job_id   IN   ds_jobruns_history.ora_dbms_job_id%TYPE
     )
     IS
          lb_failed           BOOLEAN                          := TRUE; -- Until we succeed
          lb_in_development   BOOLEAN                          := FALSE; -- FALSE in production
          ls_context          ksbms_util.context_string_type
               :=    'exec ds_sync_exec( '
                  || TO_CHAR (pli_ora_dbms_job_id)
                  || ' )'; --ARM 3/6/2002 use the passed job #
          ll_nrows            PLS_INTEGER; -- Generic SQL%ROWCOUNT result holder
          psi_job_id          ds_jobruns_history.job_id%TYPE;
     BEGIN
          ksbms_util.p_push (ls_context);

          -- Hoyt 03/18/2002 Moved this inside the exception handling block
          -- psi_job_id := f_get_entry_id ();

          <<outer_exception_block>>
          BEGIN

               <<do_once>>
               LOOP
                    -- Initialize the email message
                    ksbms_util.gs_email_msg :=
                             'Starting KSBMS synchronization batch process at '
                          || ksbms_util.f_now
                          || ksbms_util.crlf;
                    -- Do the CANSYS "preprocessing"
                    -- A function to be named later, of EXOR creation

                    -- Start the logging

                    --ls_merge_job_id := ksbms_util.f_get_entry_id; -- So we can re-use it to update the row when we're done
                    -- ARM 3/6/2002 pass a generated entry id fouse elsewhere

                    -- Hoyt 03/18/2002 Allen added this call; I moved it to within the exception handling block
                    psi_job_id := f_get_entry_id ();


                     -- insert master row in ds_jobruns_history;
                     -- send run #, oracle schedule jobs job #, status key, remarks...
                     ksbms_util.p_init_jobruns_history(psi_job_id, pli_ora_dbms_job_id,'IN','INITIALIZING JOBRUNS');
                     -- applying changes
                     ksbms_util.p_update_jobruns_history(psi_job_id,'AC','SYNCH STARTED AT '||to_char(sysdate,'YYYY-MM-DD HH:MI:SS')); --- ALL DONE

                     p_add_msg('SYNCH RUN ['||psi_job_id ||'] STARTED AT '||to_char(sysdate,'YYYY-MM-DD HH:MI:SS') );
                     -- Stamp run with package compile timestamp
                     p_add_msg('KSBMS_DATA_SYNC: LAST_DDL_TIME: ' || TO_CHAR(gd_package_release_date,'YYYY-MM-DD HH:MI:SS'));
                     -- Stamp run with package id:
                     p_add_msg('KSBMS_DATA_SYNC: ID: ' || TRIM(gs_package_cvs_archive_id ) );

                    -- Merge the changes
                    IF f_merge_database_changes (psi_job_id,
                                                 pli_ora_dbms_job_id,
                                                     ls_context
                                                  || ' running f_merge_database_changes()'
                                                )
                    THEN
                         p_bug ('f_merge_database_changes() failed');
                         EXIT do_once; -- f_merge_database_changes() failed
                    END IF;

                    -- In development, move the data back to DS_CHANGE_LOG (etc) to apply to Pontis
                    IF lb_in_development
                    THEN
                         ksbms_util.p_log (psi_job_id,   'In development in '
                                               || ls_context
                                              );

                         -- Otherwise, we get duplicate entry_id's, I think

                         -- ARM 3/6/2002
                         -- Wrong order, delete children first
                         -- HOYTFIX Does the RI fix this?
                         DELETE FROM ds_lookup_keyvals_temp;

                         COMMIT;

                         DELETE FROM ds_change_log_temp;

                         COMMIT;

                         INSERT INTO ds_change_log
                              SELECT *
                                FROM ds_change_log_c;

                         /* ARM 3/6/2002 no bogus SQL tests after the Cursor is expired*/

                         ll_nrows := SQL%ROWCOUNT;

                         COMMIT;

                         /* ARM 3/6/2002  Pass MERGE JOB ID, not ORA JOB ID to p_log */
                         ksbms_util.p_log (psi_job_id,
                                               TO_CHAR (ll_nrows)
                                            || ' records moved from ds_change_log_c'
                                          );

                         INSERT INTO ksbms_robot.ds_lookup_keyvals
                              SELECT *
                                FROM ds_lookup_keyvals_c;

                         COMMIT;

                         -- Leave the missing ones still missing
                         UPDATE ds_change_log
                            SET precedence = 'FC'
                          WHERE exchange_type = 'INS'
                             OR exchange_type = 'DEL'
                             OR exchange_type = 'UPD';

                         COMMIT;

                         UPDATE ds_change_log
                            SET new_value = '3'
                          WHERE (   exchange_type = 'INS'
                                 OR exchange_type = 'DEL'
                                 OR exchange_type = 'UPD'
                                )
                            AND (new_value = '1' OR new_value = '2');

                         COMMIT;

                         UPDATE ds_change_log
                            SET new_value = '2222-03-02'
                          WHERE (   exchange_type = 'INS'
                                 OR exchange_type = 'DEL'
                                 OR exchange_type = 'UPD'
                                )
                            AND (new_value LIKE '2002%');

                         COMMIT;

                         UPDATE ds_change_log
                            SET new_value = 'HOZT ADDED'
                          WHERE (   exchange_type = 'INS'
                                 OR exchange_type = 'DEL'
                                 OR exchange_type = 'UPD'
                                )
                            AND (new_value = 'HOYT ADDED');

                         COMMIT;

                         UPDATE ds_change_log
                            SET new_value = 'OZTDED'
                          WHERE (   exchange_type = 'INS'
                                 OR exchange_type = 'DEL'
                                 OR exchange_type = 'UPD'
                                )
                            AND (new_value = 'OYTDED');

                         COMMIT;

                         UPDATE ds_lookup_keyvals
                            SET keyvalue = 'HOZT ADDED'
                          WHERE keyvalue = 'HOYT ADDED';

                         COMMIT;
                    END IF;

                    -- Apply the changes
                    p_add_msg('APPLY CHANGES STARTED AT '||to_char(sysdate,'YYYY-MM-DD HH:MI:SS') );
                    p_log(psi_job_id,'In '||ls_context|| ', now invoking ksbms_apply_changes.f_update_pontis()' );
                    -- store email prior to call.
                    gs_ds_email := ksbms_util.gs_email_msg;

                    IF ksbms_apply_changes.f_update_pontis (psi_job_id,
                                                            pli_ora_dbms_job_id,
                                                            ksbms_util.gs_email_msg )

                    THEN
                         p_bug ('f_update_pontis() failed');
                         EXIT do_once;
                    END IF;
                    --gs_ds_email := gs_ds_email || ksbms_util.cr||ksbms_util.gs_email_msg;
                    --ksbms_util.gs_email_msg := '';
                    --p_add_msg( gs_ds_email );
                    -- Allen Marshall, CS - 2002.12.16 - get rid of magic strings if the whole process went through
                    -- Clear magic string NEWUNINITIALIZEDKEYS from newly inserted records
                    -- As long as the keys are sent once per session, this will work, but it will get really weird if someone screws up and tries to send values again when the logical target record ON_UNDER is now different for example
                    --
                    p_log(psi_job_id,'In ' || ls_context || ', cleaning up ' );

                    UPDATE bridge
                       SET notes =
                                 REPLACE (notes, cs_magic_newrecord_indicator)
                     WHERE INSTR (notes, cs_magic_newrecord_indicator, 1) > 0;

                    UPDATE userbrdg
                       SET notes =
                                 REPLACE (notes, cs_magic_newrecord_indicator)
                     WHERE INSTR (notes, cs_magic_newrecord_indicator, 1) > 0;

                    UPDATE roadway
                       SET notes =
                                 REPLACE (notes, cs_magic_newrecord_indicator)
                     WHERE INSTR (notes, cs_magic_newrecord_indicator, 1) > 0;

                    UPDATE userrway
                       SET notes =
                                 REPLACE (notes, cs_magic_newrecord_indicator)
                     WHERE INSTR (notes, cs_magic_newrecord_indicator, 1) > 0;

                    UPDATE inspevnt
                       SET notes =
                                 REPLACE (notes, cs_magic_newrecord_indicator)
                     WHERE INSTR (notes, cs_magic_newrecord_indicator, 1) > 0;

                    UPDATE userinsp
                       SET notes =
                                 REPLACE (notes, cs_magic_newrecord_indicator)
                     WHERE INSTR (notes, cs_magic_newrecord_indicator, 1) > 0;

                    UPDATE structure_unit
                       SET notes =
                                 REPLACE (notes, cs_magic_newrecord_indicator)
                     WHERE INSTR (notes, cs_magic_newrecord_indicator, 1) > 0;

                    UPDATE userstrunit
                       SET notes =
                                 REPLACE (notes, cs_magic_newrecord_indicator)
                     WHERE INSTR (notes, cs_magic_newrecord_indicator, 1) > 0;

-------------------
-- Success exit
-------------------

                    lb_failed := FALSE;
                    EXIT do_once; -- Done!
               END LOOP do_once;
-----------------------------------------------------------------
-- This exception handler surrounds ALL the code in this function
-----------------------------------------------------------------
          EXCEPTION
               WHEN OTHERS
               THEN
                    BEGIN
                         lb_failed := TRUE;                    -- Just to be sure
                                            -- ksbms_util.p_clean_up_after_raise_error (ls_context);
                    END;
          END outer_exception_block; -- This ends the anonymous block created just to have the error handler

                                     -- Send notification about the results
          p_add_msg('SYNCH RUN ['|| psi_job_id ||'] COMPLETE AT '||to_char(sysdate,'YYYY-MM-DD HH:MI:SS'));

          IF ksbms_util.f_send_notification (psi_job_id, pli_ora_dbms_job_id)
          THEN
               p_bug ('f_send_notification() failed');
          END IF;
          -- close out.
          ksbms_util.p_update_jobruns_history(psi_job_id,'AD','ALL DONE AT'||to_char(sysdate,'YYYY-MM-DD HH:MI:SS')); --- ALL DONE
          ksbms_util.p_pop (ls_context);
     -- Allen Marshall, CS- 01/31/2003 - added final exception block for entire procedure - to cure problem with stack overflows
     EXCEPTION
          WHEN OTHERS
          THEN
               BEGIN
                    ksbms_util.p_clean_up_after_raise_error (ls_context);
               END;
     END ds_sync_exec;

     FUNCTION f_update_change_log_c (
          pbi_no_cansys_data_to_merge      IN       BOOLEAN,
          pio_num_cansys_change_log_recs   OUT      PLS_INTEGER
     )
          RETURN BOOLEAN
     IS
          -- Allen Marshall, CS - 2003.01.02
          -- BACKED OUT CHANGE - LEFT AS IS -- SEE F_MERGE_DATABASE_CHANGES for substantive fix
          -- routine to tag all cansys log entries to indicate that they are 'IN-PROCESS'.  Shouldn't matter what exchange_status
          PRAGMA AUTONOMOUS_TRANSACTION; -- So we can commit JUST THIS db operation
          lb_failed    BOOLEAN                        := TRUE; -- Until we succeed
          ls_context   ksbms_util.context_string_type
                                                 := 'f_update_change_log_c()';
     BEGIN
          ksbms_util.p_push (ls_context);

          <<outer_exception_block>>
          BEGIN

               <<do_once>>
               LOOP
                    -- Initialize it
                    pio_num_cansys_change_log_recs := 0;

                    -- Update all the _CANSYS_ exchange_status = 'UPD' rows
                    -- to 'IN-PROCESS' to identify the set we're after.
                    IF NOT pbi_no_cansys_data_to_merge
                    THEN
                         BEGIN
                              UPDATE ds_change_log_c
                                 SET exchange_status = 'IN-PROCESS'
                               WHERE exchange_status = 'UPD'; -- Allen Marshall, CS - 2003.01.02 - all types of status probably should be considered, investigate for future
--                               COMMIT;  --commented out this commit for 9i

                                                              -- Reset this, in case a record was inserted since the SELECT COUNT(*)

                              pio_num_cansys_change_log_recs := SQL%ROWCOUNT;
                              -- We should have found at least one record
                              -- Hoyt 09/09/2002 NO, we should NOT assume that there MUST be records
                              /*
                              if pio_num_cansys_change_log_recs = 0
                              then
                                 raise no_data_affected;
                              end if;
                              */ -- End: Hoyt 09/09/2002

                              COMMIT;
                         EXCEPTION
                              WHEN no_data_affected
                              THEN
                                   -- No records to update? We already checked to make sure there were!
                                   p_sql_error ('No CANSYS in-process records found!'
                                               );
                              WHEN OTHERS
                              THEN
                                   p_sql_error ('Updating CANSYS change log to In-Process.'
                                               );
                         END;
                    END IF;

-------------------
-- Success exit
-------------------

                    lb_failed := FALSE;
                    EXIT do_once; -- Done!
               END LOOP do_once;
-----------------------------------------------------------------
-- This exception handler surrounds ALL the code in this function
-----------------------------------------------------------------
          EXCEPTION
               WHEN OTHERS
               THEN
                    lb_failed := TRUE; -- Just to be sure
                    ksbms_util.p_clean_up_after_raise_error (ls_context);
          END outer_exception_block; -- This ends the anonymous block created just to have the error handler


-----------------------------------------------------------------
-- Put any clean-up code that munges on the database here
-----------------------------------------------------------------

          ksbms_util.p_pop (ls_context);
          -- Save the changes (or not)
          RETURN ksbms_util.f_commit_or_rollback (lb_failed, ls_context);
     END f_update_change_log_c;

     -- Set the ds_change_log status to the passed value
     FUNCTION f_set_exchange_status (
          psi_entry_id   IN   ds_change_log.entry_id%TYPE,
          psi_status     IN   ds_change_log.exchange_status%TYPE,
          psi_remark     IN   ds_change_log.remarks%TYPE
     )
          RETURN BOOLEAN
     IS
          lb_failed    BOOLEAN                        := TRUE; -- Until we succeed
          ls_context   ksbms_util.context_string_type
                                                 := 'f_set_exchange_status()';
     BEGIN
          ksbms_util.p_push (ls_context);

          <<outer_exception_block>>
          BEGIN

               <<do_once>>
               LOOP
                    -- Update the Pontis change log's exchange status
                    BEGIN
                         UPDATE ds_change_log
                            SET exchange_status = psi_status,
                                remarks = psi_remark
                          WHERE entry_id = psi_entry_id;

                         IF SQL%ROWCOUNT = 0
                         THEN
                              RAISE no_data_affected;
                         END IF;
                         COMMIT;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              p_sql_error (   'Setting exchange status to '
                                           || psi_status
                                           || ' for entry_id '
                                           || psi_entry_id
                                           || ' with remark '
                                           || psi_remark
                                          );
                    END;

-------------------
-- Success exit
-------------------

                    lb_failed := FALSE;
                    EXIT do_once; -- Done!
               END LOOP do_once;
-----------------------------------------------------------------
-- This exception handler surrounds ALL the code in this function
-----------------------------------------------------------------
          EXCEPTION
               WHEN OTHERS
               THEN
                    lb_failed := TRUE; -- Just to be sure
                    ksbms_util.p_clean_up_after_raise_error (ls_context);
          END outer_exception_block; -- This ends the anonymous block created just to have the error handler


-----------------------------------------------------------------
-- Put any clean-up code that munges on the database here
-----------------------------------------------------------------

          ksbms_util.p_pop (ls_context);
          -- Do NOT commit
          RETURN lb_failed;
     END f_set_exchange_status;

     FUNCTION f_template
          RETURN BOOLEAN
     IS
          lb_failed    BOOLEAN                        := TRUE; -- Until we succeed
          ls_context   ksbms_util.context_string_type := 'f_template()';
     BEGIN
          ksbms_util.p_push (ls_context);

          <<outer_exception_block>>
          BEGIN

               <<do_once>>
               LOOP
-------------------
-- Success exit
-------------------

                    lb_failed := FALSE;
                    EXIT do_once; -- Done!
               END LOOP do_once;
-----------------------------------------------------------------
-- This exception handler surrounds ALL the code in this function
-----------------------------------------------------------------
          EXCEPTION
               WHEN OTHERS
               THEN
                    lb_failed := TRUE; -- Just to be sure
                    ksbms_util.p_clean_up_after_raise_error (ls_context);
          END outer_exception_block; -- This ends the anonymous block created just to have the error handler


-----------------------------------------------------------------
-- Put any clean-up code that munges on the database here
-----------------------------------------------------------------

          ksbms_util.p_pop (ls_context);
          -- Save the changes (or not)
          RETURN ksbms_util.f_commit_or_rollback (lb_failed, ls_context);
     END f_template;
/*
--CVS LOG
-- $Log: ksbms_data_sync.pck,v $
-- Revision 1.21  2003/04/13 13:31:42  arm
-- Allen Marshall, CS - 2003.04.13 - lots of changes to enhance and clean up email message body.
--
-- Revision 1.20  2003/04/12 23:43:43  arm
-- Allen Marshall, CS - 2003.04.12 - fixed status message email body contents - was ignoring messages driven from KSBMS_DATA_SYNC
--
-- Revision 1.19  2003/04/12 18:06:57  arm
-- Allen Marshall, CS - 2003.04.12 - trimmed length of ID string to fit message line limit.
--
-- Revision 1.18  2003/04/12 17:41:30  arm
-- Allen Marshall, CS - 2003.04.12 - added log to documentation area, finalized cvs stamping in code. From now on, to release, commit changes, then update files with get clean copy, load and compile and deliver - this ensures the CVS ID gets into the source code for the package.
--
*/


     PROCEDURE documentation
     IS
     BEGIN
          pl ( 'PACKAGE KSBMS_DATA_SYNC - Various Data synchronization routines, including main broker'
             );
          pl('CVS ID: $Id: ksbms_data_sync.pck,v 1.21 2003/04/13 13:31:42 arm Exp $ '); -- cvs KEYWORDS - DO NOT UPDATE

          pl ( 'Revision History:');
          pl('ARM, CS - 4/12/2003 - added calls to procedure ksbms_util.p_update_jobruns_history and ksbms_util.p_init_jobruns_history');
          pl('ARM, CS - 4/12/2003 - added timestamp and cvs archive ID for package to the e-mail');
          pl('ARM, CS - 4/11/2003 - made numerous changes to the commit and rollback stuff here to eliminate autonomous transactions within distributed transactions');
          pl('ARM, CS - 4/11/2003 - added no data to process to email message for either Pontis or CANSYS');
          pl('ARM, CS - 4/02/2003 - changed f_fill_in_userrway_keys to change DIRECTION pseudo-column to CLR_ROUTE to avoid a SQL error - leaves records with missing USERRWAY keys as STILMSNG but continues');
          pl( 'ARM, CS - 3/31/2003 - changes to f_move_merge_ready_to_cansys and f_move_merge_ready_to_pontis to log integer count of records moved.');
          pl( 'ARM, CS - 3/12/2003 - changes to f_remove_old_inspdate_records to log less messages');
          pl ( ' ARM, CS - 02/04/2003 - changed f_merge_database_changes  to ignore APPLIED and FAILED records when determining that something has to be done.... '
             );
          pl ( ' ARM, CS - 02/04/2003 - changed PONTIS.POPULATE_FROM_PONTIS to UPDATE RECORDS TO APPLIED IN DS_CHANGE_LOG_C after PONTIS.POPULATE FROM PONTIS fires - TESTING ONLY'
             );
          pl ( 'ARM, CS - 01/22/2003 added several commits in f_merge_database_changes'
             );
          pl ( 'ARM, CS - 01/17/2003 - ALl Stack Trace calls (passing ls_context or argument psi_context) now use the anchored context_string_type from ksbms_util.  Prevent too small buffer problem'
             );
          pl ( 'ARM, CS - 01/07/2003 -Added log stamp for situation where updates to '
             );
          pl ( 'old INSPEVNT records are whacked from the log by KSBMS_DATA_SYNC.f_remove_old_inspdate_records()'
             );
          pl (    'ARM, CS - 01/02/2003 - changed f_merge_database_changes to use a boolean to note if any work needs to be done including only a DEL type exchange '
               || ' This should force a single DEL directive to be processed without a UPD - UPD was the previous sole criteria for determining if send-to-CANSYS records existed to process'
             );
          pl ( 'ARM, CS - 01/02/2003 - Added wrapper routine p_log for ksbms_util.p_log'
             );
          pl ( 'ARM, CS - 12/16/2002 - revised structure unit insert routine to allow insert of multiple units, format strunitlabel col consistently'
             );
          pl (    'ARM, CS - 12/16/2002 - revised to clean out magic string '
               || cs_magic_newrecord_indicator
               || ' from newly inserted records e.g. userrway after SUCCESS'
             );
          pl ( 'The magic string is added by KSBMS_APPLY_CHANGES.f_set_xxxxx_value routines...'
             );
     END;
BEGIN
-- ARM 3/7/2002 because there may be mass deletes, inserts, and updates
-- make sure to run this package with the following preamble...
--  SET TRANSACTION
--  USE ROLLBACK SEGMENT rbs_large;

     -- Initialization

     --<Statement>;
     -- ALlen Marshall, CS - 2003.04.12 - tag runs with compile date of application
      -- Initialize the global that corresponds to compile time for the package body - date variable
  select NVL(  LAST_DDL_TIME, SYSDATE ) INTO gd_package_release_date from all_objects
  where object_name='KSBMS_APPLY_CHANGES' and object_type = 'PACKAGE BODY';
     --gs_package_cvs_archive_id := '1.15'; -- TAKE FROM CVS WINDOW AFTER COMMIT;
     -- Defaults to be set from ds_config_options
     gi_default_stale_days := 5;
     -- This means 'reset it' in f_fix_bogus_strunitkeys;
     gs_strunitlabel_exc_rule_id := -1;
     -- Clear these out every time the package runs, else it accumulates!
     ksbms_util.p_clear_email_msg;
     ksbms_util.p_clear_sql_error;
END ksbms_data_sync;
/