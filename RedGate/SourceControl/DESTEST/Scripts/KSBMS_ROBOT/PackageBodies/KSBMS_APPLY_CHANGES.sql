CREATE OR REPLACE PACKAGE BODY ksbms_robot."KSBMS_APPLY_CHANGES"
-- Author  : Hoyt Nelson
-- Created : 1/5/2002 5:45:41 PM
-- Purpose : Start a new function in a new package from this template
-- Last mod: 03/03/2002 on Hoyt
-- Moved   : 08/09/2002 to Emperor
 IS

  -- Global utility strings
  -- package compile timestamp - more or less the release date, depending if rebuilt...
  gd_package_release_date date; -- initialized in package startup from  sys_all_objects;
  gs_package_cvs_archive_id VARCHAR2(120) := '$Id: ksbms_apply_changes.pck,v 1.24 2003/04/14 18:03:28 arm Exp $ '; -- generated automatically by CVS tag
  gs_crlf CONSTANT VARCHAR2(2) := CHR(13) || CHR(10);
  -- So the job_id passed into f_update_pontis() is universally available
  gs_job_id ds_jobruns_history.job_id%TYPE; -- Initialized in f_update_pontis()
  -- This exception is raised when an INSERT, DELETE or UPDATE doesn't "find" any rows
  no_data_affected EXCEPTION;
  PRAGMA EXCEPTION_INIT(no_data_affected, -20301);
  -- Exchange status values (<ENHANCEMENT>: How to wrap these in a package?)
  ls_in_process CONSTANT ds_change_log.exchange_status%TYPE := 'IN-PROCESS';
  ls_insert_type CONSTANT ds_change_log.exchange_status%TYPE := 'INS';
  ls_update_type CONSTANT ds_change_log.exchange_status%TYPE := 'UPD';
  ls_delete_type CONSTANT ds_change_log.exchange_status%TYPE := 'DEL';
  ls_insert_ready CONSTANT ds_change_log.exchange_status%TYPE := 'INSREADY'; -- Allen Marshall, CS -01/22/2003 - added new status...
  ls_merge_ready CONSTANT ds_change_log.exchange_status%TYPE := 'MERGEREADY';
  ls_merged CONSTANT ds_change_log.exchange_status%TYPE := 'MERGED';
  ls_stale CONSTANT ds_change_log.exchange_status%TYPE := 'STALE';
  ls_superseded CONSTANT ds_change_log.exchange_status%TYPE := 'SUPERSEDED';
  ls_applied CONSTANT ds_change_log.exchange_status%TYPE := 'APPLIED';
  -- Allen Marshall, CS - 2003.01.14
  -- When archiving, we are going to look in this constant for the exchange_status codes that are to be archived - can be extended.....
  -- Allen Marshall, CS - 2003.01.16       changed from anchored type to plain old VARCHAR2 - was blowing up!!!!
  cs_sendtoarchive CONSTANT VARCHAR2(80) := '|APPLIED|INSREADY|DELREADY|'; -- Allen Marshall, CS - 2003.01.14 - now sends applied and INSREADY/DELREADY to the archive
  ls_delete CONSTANT ds_change_log.exchange_status%TYPE := '<DELETE>';
  -- Local magic strings
  ls_missing CONSTANT VARCHAR2(9) := '<MISSING>';
  li_missing CONSTANT VARCHAR2(9) := -1;
  ls_initial_where CONSTANT VARCHAR2(6) := 'WHERE';
  -- This ds_jobruns_history.job_status magic string inhibits updates
  ls_job_applying_change CONSTANT ds_jobruns_history.job_id%TYPE := 'AC'; -- Applying Changes
  -- This ds_jobruns_history.job_status magic string signifies that this process is DONE
  ls_job_done_changing CONSTANT ds_jobruns_history.job_id%TYPE := 'DC'; -- Done Changing
  -- This ds_jobruns_history.job_status magic string signifies that the job FAILED
  ls_job_changes_failed CONSTANT ds_jobruns_history.job_id%TYPE := 'CF'; -- Changes Failed
  -- The ds_transfer_map exchange rule ID for INSPEVNT updates
  li_inspevnt_exchange_rule_id ds_transfer_map.exchange_rule_id%TYPE := li_missing;
  -- The INSPDATE associated with a given INSPEVNT record
  ls_inspdate inspevnt.inspdate%TYPE;
  ls_inspkey  inspevnt.inspkey%TYPE;
  -- TRUE if we have not yet tried to identify the INSPKEY for this structure
  lb_need_inspkey BOOLEAN;
  -- Means that f_add_bridge() was responsible for entering this record
  ls_added_with_new_bridge CONSTANT VARCHAR2(20) := '<ADDED WITH BRIDGE>';
  -- The schema is either Pontis or CANSYS
  ls_pontis_schema CONSTANT ds_change_log_temp.SCHEMA%TYPE := 'P';
  ls_cansys_schema CONSTANT ds_change_log_temp.SCHEMA%TYPE := 'C';
  cl_minimum_strunitkey CONSTANT PLS_INTEGER := 1;
  -- USED IN F_ADD_STRUCTURE_UNIT ARM, CS 2002.12.16 - enforce value >= 1 for unit keys
  cs_uninitializedkeys CONSTANT VARCHAR2(40) := 'NEWUNINITIALIZEDKEYS'; -- magic string Allen MArshall CS 01/23/2003 - used to tag records inserted that need key field fixups

  ----------------------------------------------------
  -- Wrappers for functions in the ksbms_util package
  ----------------------------------------------------

  FUNCTION f_ns(psi_string IN VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    RETURN ksbms_util.f_ns(psi_string);
  END f_ns;

  FUNCTION f_commit_or_rollback(pbi_failed  BOOLEAN,
                                psi_context IN ksbms_util.context_string_type)
    RETURN BOOLEAN IS
  BEGIN
    RETURN ksbms_util.f_commit_or_rollback(pbi_failed, psi_context);
  END f_commit_or_rollback;

  PROCEDURE p_add_msg(psi_msg IN VARCHAR2) IS
  BEGIN
    ksbms_util.p_add_msg(psi_msg);
  END p_add_msg;

  PROCEDURE p_bug(psi_msg IN VARCHAR2) IS
  BEGIN
    ksbms_util.p_bug(psi_msg);
  END p_bug;

  PROCEDURE p_sql_error(psi_msg IN VARCHAR2) IS
  BEGIN
    ksbms_util.p_sql_error(psi_msg);
  END p_sql_error;

  PROCEDURE p_sql_error2(psi_msg IN VARCHAR2) IS
  BEGIN
    ksbms_util.p_sql_error2(psi_msg);
  END p_sql_error2;

  PROCEDURE pl(psi_msg IN VARCHAR2) IS
  BEGIN
    ksbms_fw.pl(psi_msg);
  END pl;

  -- Logging
  PROCEDURE p_log(psi_msg IN ds_message_log.msg_body%TYPE) IS
  BEGIN
    ksbms_util.p_log(psi_msg);
  END p_log;

  PROCEDURE p_log(psi_job_id IN ds_message_log.job_id%TYPE,
                  psi_msg    IN ds_message_log.msg_body%TYPE) IS
  BEGIN
    ksbms_util.p_log(psi_job_id, psi_msg);
  END p_log;

  -- END: Wrappers

  -- Adds whatever kind of record corresponds to the entry ID:
  -- BRIDGE and USERBRDG, STRUCTURE_UNIT and USERSTRUNIT,
  -- ROADWAY and USERRWAY, and/or INSPEVNT and USERINSP.
  FUNCTION f_add_record(psi_entry_id IN ds_change_log.entry_id%TYPE)
  RETURN BOOLEAN IS
  PRAGMA AUTONOMOUS_TRANSACTION;
  lb_failed          BOOLEAN := TRUE; -- Until we succeed
  ls_context         ksbms_util.context_string_type := 'f_add_record()';
  ls_table_name      ds_transfer_map.table_name%TYPE;
  ls_bridge_id       bridge.bridge_id%TYPE;
  ls_brkey           bridge.brkey%TYPE;
  ls_strunitlabel    structure_unit.strunitlabel%TYPE;
  li_strunitkey      structure_unit.strunitkey%TYPE;
  ls_strunittype     structure_unit.strunittype%TYPE;
  ls_on_under        roadway.on_under%TYPE;
  ls_feat_cross_type userrway.feat_cross_type%TYPE;
  ls_inspkey         inspevnt.inspkey%TYPE;
  ldt_createdatetime inspevnt.inspdate%TYPE;
BEGIN
  ksbms_util.p_push(ls_context);

  <<outer_exception_block>>
  BEGIN

  <<do_once>>
  LOOP
  -- What kind of record are we adding?
  BEGIN
    SELECT UPPER(table_name)
      INTO ls_table_name
      FROM ds_transfer_map
     WHERE exchange_rule_id =
           (SELECT exchange_rule_id
              FROM ds_change_log
             WHERE entry_id = psi_entry_id);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      p_sql_error('Failed to find the table name for entry ID ' ||
                  psi_entry_id);
    WHEN OTHERS THEN
      p_sql_error('SELECTing the table name for entry ID ' ||
                  psi_entry_id);
  END;

  -- For all tables, we need the bridge_id (and brkey = func( bridge_id ))
  -- In all cases, BRIDGE_ID has key_sequence_num = 1 in ds_transfer_key_map
  BEGIN
    SELECT keyvalue
      INTO ls_bridge_id
      FROM ds_lookup_keyvals
     WHERE ds_lookup_keyvals.entry_id = psi_entry_id AND
           ds_lookup_keyvals.key_sequence_num = 1;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      p_sql_error('Failed to find the BRIDGE_ID for to entry_id ' ||
                  psi_entry_id);
    WHEN OTHERS THEN
      p_sql_error('SELECTing the BRIDGE_ID for to entry_id ' ||
                  psi_entry_id);
  END;

  -- Generate KDOT's brkey from the KDOT bridge_id
        -- This function raises errors instead of returning NULL on error.
        ls_brkey := f_kdot_bridge_id_to_brkey(ls_bridge_id);

        --------------------------------------------------------------
        -- The remainder depends on what kind of record we're entering
  --------------------------------------------------------------

  -- BRIDGE and USERBRDG
  IF ls_table_name = 'BRIDGE' OR ls_table_name = 'USERBRDG' THEN
  -- We have all we need to insert the BRIDGE record...
  BEGIN
  INSERT INTO bridge
    (brkey, bridge_id, struct_num)
  VALUES
    (ls_brkey, ls_bridge_id, ls_brkey);
  COMMIT;
  p_log('Added BRIDGE record with BRKEY = ''' || ls_brkey ||
        ''' and BRIDGE_ID ''' || ls_bridge_id || '''');
EXCEPTION
  -- Handle 'It is already there!' errors gracefully (raise no exception!)
  WHEN DUP_VAL_ON_INDEX THEN
  p_bug('Attempted to insert Bridge ID ''' || ls_bridge_id ||
        ''' with BRKEY = ''' || ls_brkey ||
        ''' into BRIDGE, but it already exists!'); -- Keep on truckin'
            WHEN OTHERS THEN
              p_sql_error('INSERTing the BRIDGE record with BRIDGE_ID ' ||
                          ls_bridge_id || ' and brkey ' || ls_brkey ||
                          ' for to entry_id ' || psi_entry_id);
          END;

          -- and to insert the corresponding USERBRDG record
          BEGIN
            INSERT INTO userbrdg (brkey) VALUES (ls_brkey);
            COMMIT;
            p_log('Added USERBRDG record with BRKEY = ''' || ls_brkey || '''');
          EXCEPTION
            -- Raise no exceptions if it's already there
  WHEN DUP_VAL_ON_INDEX THEN
  p_bug('Attempted to insert Bridge ID ' || ls_bridge_id ||
        ''' with BRKEY = ''' || ls_brkey ||
        ''' into USERBRDG, but it already exists!');
  -- Keep on truckin'
            WHEN OTHERS THEN
              p_sql_error('INSERTing the USERBRIDGE record with brkey ' ||
                          ls_brkey || ' for to entry_id ' || psi_entry_id);
          END;

          -- This sets various BRIDGE columns per
          -- w_insp_create_structure.uoe_genrequiredcolumns
          IF f_set_new_structure_data(ls_brkey) THEN
            p_bug(ls_context ||
                  ': f_set_new_structure_data() failed for entry_id ' ||
                  psi_entry_id);
            EXIT; -- Failed
          END IF;
          -- STRUCTURE_UNIT and USERSTRUNIT
        ELSIF ls_table_name = 'STRUCTURE_UNIT' OR
              ls_table_name = 'USERSTRUNIT' THEN
          BEGIN
            -- What is the STRUNITLABEL for this entry?
            BEGIN
              SELECT keyvalue
                INTO ls_strunitlabel
                FROM ds_lookup_keyvals
               WHERE entry_id = psi_entry_id AND keyname = 'STRUNITLABEL';
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                p_sql_error('Failed to find the STRUNITLABEL for to entry_id ' ||
                            psi_entry_id);
              WHEN OTHERS THEN
                p_sql_error('SELECTing the STRUNITLABEL for to entry_id ' ||
                            psi_entry_id);
            END;

            -- Get the minimum STRUNITTYPE from PARAMTRS
            BEGIN
              SELECT MIN(parmvalue)
                INTO ls_strunittype
                FROM paramtrs
               WHERE UPPER(table_name) = 'STRUCTURE_UNIT' AND
                     UPPER(field_name) = 'STRUNITTYPE';

              -- Catch possible bogosities
              IF f_ns(ls_strunittype) OR LENGTH(ls_strunittype) > 1 THEN
                ls_strunittype := '_';
              END IF;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                p_sql_error('Failed to find the default STRUNITTYPE in PARAMETRS');
              WHEN OTHERS THEN
                p_sql_error('SELECTing the default STRUNITTYPE in PARAMETRS');
            END;

            -- Get the next STRUNITKEY for this bridge
            BEGIN
              SELECT MAX(strunitkey) + 1 -- So it is unique
                INTO li_strunitkey
                FROM structure_unit
               WHERE brkey = ls_brkey;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                -- Default to 1
                li_strunitkey := 1;
              WHEN OTHERS THEN
                p_sql_error('SELECTing the STRUNITKEY for to entry_id ' ||
                            psi_entry_id);
            END;

            IF li_strunitkey IS NULL THEN
              li_strunitkey := 1;
            END IF;

            -- Insert the new record into the STRUCTURE_UNIT table
            BEGIN
              INSERT INTO structure_unit
                (brkey, strunitkey, strunittype, strunitlabel)
              VALUES
                (ls_brkey, li_strunitkey, ls_strunittype, ls_strunitlabel);
--              COMMIT; -- This commit commented out for 9i
              IF SQL%ROWCOUNT = 0 THEN
                RAISE no_data_affected;
              END IF;

              p_log('Added STRUCTURE_UNIT record with BRKEY = ''' ||
                    ls_brkey || ''', STRUNITKEY = ''' ||
                    TO_CHAR(li_strunitkey) || ''', STRUNITTYPE = ''' ||
                    ls_strunittype || ''', and STRUNITLABEL = ''' ||
                    ls_strunitlabel || '''');
              COMMIT;
            EXCEPTION
              -- Raise no exceptions if it's already there
  WHEN DUP_VAL_ON_INDEX THEN
  p_bug('Attempted to insert STRUCTURE_UNIT record with BRKEY = ''' ||
        ls_brkey || ''', STRUNITKEY = ''' ||
        TO_CHAR(li_strunitkey) || ''', STRUNITTYPE = ''' ||
        ls_strunittype || ''', and STRUNITLABEL = ''' ||
        ls_strunitlabel || '''' ||
        ' into USERSTRUNIT, but it already exists!' -- Allen Marshall, CS 2002.12.17 was ;labeled USERBRDG....
        );
  -- Keep on truckin'
              WHEN no_data_affected THEN
                p_sql_error('No data affected while trying to INSERT the STRUCTURE_UNIT for entry_id ' ||
                            psi_entry_id || ' with BRKEY = ''' || ls_brkey ||
                            ''', STRUNITKEY = ''' ||
                            TO_CHAR(li_strunitkey) ||
                            ''', STRUNITTYPE = ''' || ls_strunittype ||
                            ''', and STRUNITLABEL = ''' || ls_strunitlabel || '''');
              WHEN OTHERS THEN
                p_sql_error('Failed to INSERT the STRUCTURE_UNIT for entry_id ' ||
                            psi_entry_id || ' with BRKEY = ''' || ls_brkey ||
                            ''', STRUNITKEY = ''' ||
                            TO_CHAR(li_strunitkey) ||
                            ''', STRUNITTYPE = ''' || ls_strunittype ||
                            ''' and STRUNITLABEL = ''' || ls_strunitlabel || '''');
            END;

            -- Insert the corresponding USERSTRUNIT record using the same STRUNITKEY
            BEGIN
              INSERT INTO userstrunit
                (brkey, strunitkey)
              VALUES
                (ls_brkey, li_strunitkey);
--              COMMIT;  -- This commit commented out for 9i
              IF SQL%ROWCOUNT = 0 THEN
                RAISE no_data_affected;
              END IF;

              p_log('Added USERSTRUNIT record with BRKEY = ''' || ls_brkey ||
                    ''', STRUNITKEY = ''' || TO_CHAR(li_strunitkey) || '''');
              COMMIT;
            EXCEPTION
              -- Raise no exceptions if it's already there
  WHEN DUP_VAL_ON_INDEX THEN
  p_bug('Attempted to insert record with BRKEY = ''' ||
        ls_brkey || ''' and STRUNITKEY = ''' ||
        TO_CHAR(li_strunitkey) ||
        ''' into USERSTRUNIT, but it already exists!');
  -- Keep on truckin'
              WHEN no_data_affected THEN
                p_sql_error('No data affected while trying to INSERT the USERSTRUNIT for entry_id ' ||
                            psi_entry_id || ' with BRKEY = ''' || ls_brkey ||
                            ''', STRUNITKEY = ''' ||
                            TO_CHAR(li_strunitkey) || '''');
              WHEN OTHERS THEN
                p_sql_error('Failed to INSERT the USERSTRUNIT for entry_id ' ||
                            psi_entry_id || ' with BRKEY = ''' || ls_brkey ||
                            ''', STRUNITKEY = ''' ||
                            TO_CHAR(li_strunitkey) || '''');
            END;
          END;
          -- INSPEVNT and USERINSP
        ELSIF ls_table_name = 'INSPEVNT' OR ls_table_name = 'USERINSP' THEN
          BEGIN
            /* For the next developer...

             -- This SELECT will return the entry_id of INSPEVNT-related records,
             -- so you can pass that entry_id to this function, for testing
             select entry_id, keyname, keyvalue
             from ds_lookup_keyvals
             where entry_id in
              (select entry_id from ds_change_log
               where exchange_rule_id in
                (select exchange_rule_id from ds_transfer_map
                 where table_name = 'INSPEVNT'));
            */
            -- Get a new INSPKEY
            ls_inspkey := ksbms_pontis_util.get_pontis_inspkey(ls_brkey);

            IF ls_inspkey IS NULL THEN
              p_sql_error(ls_context ||
                          ': Failed to generate an INSPKEY for entry_id ' ||
                          psi_entry_id);
            END IF;

            -- What is the INSPDATE? Use the CREATEDATETIME
            BEGIN
              SELECT MAX(createdatetime) -- max() -> Just one row, please
                INTO ldt_createdatetime
                FROM ds_lookup_keyvals
               WHERE entry_id = psi_entry_id;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                p_sql_error('Failed to find the CREATEDATETIME for to entry_id ' ||
                            psi_entry_id);
              WHEN OTHERS THEN
                p_sql_error('SELECTing the CREATEDATETIME for to entry_id ' ||
                            psi_entry_id);
            END;

            -- INSERT the INSPEVNT record
            BEGIN
              INSERT INTO inspevnt
                (brkey, inspkey, inspdate, inspname, inspusrkey, insptype)
              VALUES
                (ls_brkey, ls_inspkey, ldt_createdatetime, '-1', 1, 1);
--              COMMIT;   -- This commit commented out for 9i
              IF SQL%ROWCOUNT = 0 THEN
                RAISE no_data_affected;
              END IF;

              p_log('Added INSPEVNT record with BRKEY = ''' || ls_brkey ||
                    ''', INSPKEY ''' || ls_inspkey ||
                    ''' and INSPDATE = ''' ||
                    TO_CHAR(ldt_createdatetime, 'YYYY-MM-DD') || '''');
              COMMIT;
            EXCEPTION
              -- Raise no exceptions if it's already there
  WHEN DUP_VAL_ON_INDEX THEN
  p_bug('Attempted to insert record with BRKEY = ''' ||
        ls_brkey || ''', INSPKEY ''' || ls_inspkey ||
        ''' and INSPDATE = ''' ||
        TO_CHAR(ldt_createdatetime, 'YYYY-MM-DD') ||
        ''' into INSPEVNT, but it already exists!');
  -- Keep on truckin'
              WHEN no_data_affected THEN
                p_sql_error('No data affected while trying to INSERT the INSPEVNT for entry_id ' ||
                            psi_entry_id || ' with BRKEY = ''' || ls_brkey ||
                            ''', INSPKEY ''' || ls_inspkey ||
                            ''' and INSPDATE = ''' ||
                            TO_CHAR(ldt_createdatetime, 'YYYY-MM-DD') || '''');
              WHEN OTHERS THEN
                p_sql_error('Failed to INSERT the INSPEVNT for entry_id ' ||
                            psi_entry_id || ' with BRKEY = ''' || ls_brkey ||
                            ''', INSPKEY ''' || ls_inspkey ||
                            ''' and INSPDATE = ''' ||
                            TO_CHAR(ldt_createdatetime, 'YYYY-MM-DD') || '''');
            END;

            -- INSERT the corresponding USERINSP record
            BEGIN
              INSERT INTO userinsp
                (brkey, inspkey) -- These are the only NOT NULL columns
              VALUES
                (ls_brkey, ls_inspkey);
--              COMMIT;    -- This commit commented out for 9i
              IF SQL%ROWCOUNT = 0 THEN
                RAISE no_data_affected;
              END IF;

              p_log('Added USERINSP record with BRKEY = ''' || ls_brkey ||
                    ''' and INSPKEY ''' || ls_inspkey || '''');
              COMMIT;
            EXCEPTION
              -- Raise no exceptions if it's already there
  WHEN DUP_VAL_ON_INDEX THEN
  p_bug('Attempted to insert record with BRKEY = ''' ||
        ls_brkey || ''' and INSPKEY ''' || ls_inspkey ||
        ''' into USERINSP, but it already exists!');
  -- Keep on truckin'
              WHEN no_data_affected THEN
                p_sql_error('No data affected while trying to INSERT the USERINSP for entry_id ' ||
                            psi_entry_id || ' with BRKEY = ''' || ls_brkey ||
                            ''' and INSPKEY ''' || ls_inspkey || '''');
              WHEN OTHERS THEN
                p_sql_error('Failed to INSERT the USERINSP for entry_id ' ||
                            psi_entry_id || ' with BRKEY = ''' || ls_brkey ||
                            ''' and INSPKEY ''' || ls_inspkey || '''');
            END;

            -- Set the various INSPEVNT data
            IF f_set_new_inspevnt_data(ls_brkey, ls_inspkey) THEN
              EXIT; -- Failed
            END IF;
          END;
        ELSIF ls_table_name = 'ROADWAY' OR ls_table_name = 'USERRWAY' THEN
          BEGIN
            -- What is the FEAT_CROSS_TYPE for this entry?
            BEGIN
              SELECT keyvalue
                INTO ls_feat_cross_type
                FROM ds_lookup_keyvals
               WHERE entry_id = psi_entry_id AND
                     keyname = 'FEAT_CROSS_TYPE';
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                -- In this case (FEAT_CROSS_TYPE unknown) we default to 1
                ls_on_under := '1';
                p_bug('Failed to find the FEAT_CROSS_TYPE for to entry_id ' ||
                      psi_entry_id || '; assuming ON_UNDER = 1');
              WHEN OTHERS THEN
                p_sql_error('SELECTing the STRUNITLABEL for to entry_id ' ||
                            psi_entry_id);
            END;

            -- What should the ON_UNDER be?
            IF ls_feat_cross_type IS NOT NULL THEN
            -- Hoyt 08/07/2002 Bogosity added to make this compile -- it's no longer valid here
    IF f_feat_cross_type_to_on_under(ls_brkey,
                                     ls_feat_cross_type,
                                     'bogosity',
                                     ls_on_under) THEN
      p_bug(ls_context ||
            ': Failed to get the ON_UNDER for FEAT_CROSS_TYPE ' ||
            ls_feat_cross_type);
      EXIT; -- Failed
    END IF;
  END IF;

  -- INSERT the ROADWAY record
  BEGIN
    INSERT INTO roadway
      (brkey, on_under) -- These are the only NOT NULL columns
    VALUES
      (ls_brkey, ls_on_under);
--    COMMIT;    -- This commit commented out for 9i
    IF SQL%ROWCOUNT = 0 THEN
      RAISE no_data_affected;
    END IF;

    p_log('Added ROADWAY record with BRKEY = ''' || ls_brkey ||
          ''' and ON_UNDER = ''' || ls_on_under || '''');
    COMMIT;
  EXCEPTION
    -- Raise no exceptions if it's already there
            WHEN DUP_VAL_ON_INDEX THEN
            p_bug('Attempted to insert record with BRKEY = ''' ||
                  ls_brkey || ''' and ON_UNDER = ''' || ls_on_under ||
                  ''' into ROADWAY, but it already exists!');
            -- Keep on truckin'
    WHEN no_data_affected THEN
      p_sql_error('No data affected while trying to INSERT the ROADWAY for entry_id ' ||
                  psi_entry_id || ' with BRKEY = ''' || ls_brkey ||
                  ''' and ON_UNDER = ''' || ls_on_under || '''');
    WHEN OTHERS THEN
      p_sql_error('Failed to INSERT the ROADWAY for entry_id ' ||
                  psi_entry_id || ' with BRKEY = ''' || ls_brkey ||
                  ''' and ON_UNDER = ''' || ls_on_under || '''');
  END;

  -- INSERT the corresponding USERRWAY record
  BEGIN
    INSERT INTO userrway
      (brkey, on_under) -- These are the only NOT NULL columns
    VALUES
      (ls_brkey, ls_on_under);
--    COMMIT;    -- This commit commented out for 9i
    IF SQL%ROWCOUNT = 0 THEN
      RAISE no_data_affected;
    END IF;

    p_log('Added USERRWAY record with BRKEY = ''' || ls_brkey ||
          ''' and ON_UNDER = ''' || ls_on_under || '''');
    COMMIT;
  EXCEPTION
    -- Raise no exceptions if it's already there
            WHEN DUP_VAL_ON_INDEX THEN
            p_bug('Attempted to insert record with BRKEY = ''' ||
                  ls_brkey || ''' and ON_UNDER = ''' || ls_on_under ||
                  ''' into USERRWAY, but it already exists!');
            -- Keep on truckin'
    WHEN no_data_affected THEN
      p_sql_error('No data affected while trying to INSERT the USERRWAY for entry_id ' ||
                  psi_entry_id || ' with BRKEY = ''' || ls_brkey ||
                  ''' and ON_UNDER = ''' || ls_on_under || '''');
    WHEN OTHERS THEN
      p_sql_error('Failed to INSERT the USERRWAY for entry_id ' ||
                  psi_entry_id || ' with BRKEY = ''' || ls_brkey ||
                  ''' and ON_UNDER = ''' || ls_on_under || '''');
  END;

  -- This commit prevents a 'locked resource' hang-up in the following call
  COMMIT;
  -- Set the various ROADWAY data per Pontis's practice
            -- <ENHANCEMENT> This is hanging for some reason
            -- if f_set_new_roadway_data (ls_brkey, ls_on_under)
            -- then
            --    exit; -- Failed
            -- end if;
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
      WHEN OTHERS THEN
        lb_failed := TRUE; -- Just to be sure
        ksbms_util.p_clean_up_after_raise_error(ls_context);
    END outer_exception_block; -- This ends the anonymous block created just to have the error handler

    ksbms_util.p_pop(ls_context);

    -----------------------------------------------------------------
    -- Put any clean-up code that munges on the database here
    -----------------------------------------------------------------

    IF lb_failed THEN
      ROLLBACK;
    ELSE
      COMMIT;
    END IF;

    RETURN lb_failed;
  END f_add_record;

  FUNCTION f_feat_cross_type_to_on_under(psi_brkey           IN bridge.brkey%TYPE,
                                         psi_feat_cross_type IN userrway.feat_cross_type%TYPE,
                                         psi_user_where      IN VARCHAR2,
                                         pso_on_under        OUT roadway.on_under%TYPE)
   /* From WER

            The correct value for on_under can be calculated from feat_cross_type as follows:

           - If feat_cross_type is missing, then on_under = 1
           - If feat_cross_type is 2, then on_under = 22
           - If feat_cross_type is 4, then on_under = 24
           - If feat_cross_type is 10, 30, 50, 51 or 70 then take the next available value from
             the following sequence:
              {2, B, C, D, E, F, G, H, I , J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z}
             Note: technically speaking, if there is an on_under of B, then the 2 should be
             switched to A, but this is a nasty detail.
           - If feat_cross_type is anything else, then on_under = feat_cross_type
           -- Allen R. Marshall, CS - 2002-12-19
           -- NEXT AVAILABLE VALUE LOGIC WAS STRENGTHENED.  SHOULD NOW CONVERT ALL 2 RECORDS TO A RECORDS AND GET  RID OF THE 2 RECORDS, THEN INSERT
           -- B, C,D, etc. AS APPROPRIATE
           Allen Marshall, CS - 2002.12.19 - major update
           THIS ROUTINE NOW TRIES TO STAY RIGOROUSLY IN SEQUENCE FOR UNDER RECORDS 1,2, or 1, A-Z
           */
   RETURN BOOLEAN IS
    lb_failed                BOOLEAN := TRUE; -- Until we succeed
    lb_on_under_a_exists     BOOLEAN;
    lb_on_under_b_exists     BOOLEAN;
    ls_context               ksbms_util.context_string_type := 'f_feat_cross_type_to_on_under()';
    ls_on_under              roadway.on_under%TYPE;
    ls_max_on_under          roadway.on_under%TYPE;
    ls_feat_cross_type       userrway.feat_cross_type%TYPE; -- So we can modify it
    ls_brkey                 bridge.brkey%TYPE; -- So we can modify it
    ls_proto_feat_cross_type VARCHAR2(15); -- Big enough to hold <MISSING> ARM 3/6/2002 Changed to VARCHAR2 definition
    ll_on_under_count        PLS_INTEGER;
  BEGIN
    ksbms_util.p_push(ls_context);

    <<do_once>>
    LOOP
      -- Remove any apostrophes (the substr() is so we know it will fit)
      -- ARM 3/6/2002 send null, which will cause the REPLACE function within f_substr to drop all such token strings
      ls_proto_feat_cross_type := SUBSTR(ksbms_util.f_substr(psi_feat_cross_type,
                                                             '''',
                                                             NULL),
                                         1,
                                         15);

      -- If it is <MISSING>, then set it to the null string.
      -- This is needed here to avoid trying to jam '<MISSING>' into a 3-character field
      IF ls_proto_feat_cross_type = ls_missing THEN
        ls_feat_cross_type := NULL;
      ELSE
        -- Trim it so adjacent spaces are irrelevant
        -- The substr() is to avoid jamming something too long into the 3-character feat_cross_type variable
        ls_feat_cross_type := SUBSTR(TRIM(ls_proto_feat_cross_type), 1, 3);
      END IF;

      -- So we can modify it (esp. during testing)
      ls_brkey := psi_brkey; -- NEVER trim brkey; spaces can be significant!

      -- Breakpoint during development (false turns this block OFF)

      IF FALSE AND ls_brkey = '001045' THEN
        ls_brkey := ls_brkey;
        p_log('Feat_Cross_Type SQL: ' || psi_user_where);
      END IF;

      -- Testing
      --ls_brkey := '001035'; -- '001036';
      --ls_feat_cross_type := '10';

      -- If feat_cross_type is missing, then on_under = 1
      IF ksbms_util.f_ns(ls_feat_cross_type) THEN
        ls_on_under := '1';
      ELSIF ls_feat_cross_type = '2' THEN
        ls_on_under := '22';
      ELSIF ls_feat_cross_type = '4' THEN
        ls_on_under := '24';
        -- Hoyt 08/07/2002 Per NAC's email, on_under = feat_cross_type for these values
ELSIF ls_feat_cross_type IN
      ('90', '92', '93', '94', '96', '97', '98', '99') THEN
  ls_on_under := ls_feat_cross_type;
ELSIF ls_feat_cross_type IN ('10', '30', '50', '51', '70') THEN
  -- Hoyt 08/07/2002 Does this record already exist in USERRWAY?
  -- Get the value of this column for the subject INSPEVNT (or USERINSP) record
  DECLARE
    ls_sqlstring VARCHAR2(2000);
    ll_cur       PLS_INTEGER := DBMS_SQL.open_cursor;
    ll_ret       PLS_INTEGER := 0;
  BEGIN
    -- SEE IF THIS RECORD IS IN USERRWAY ALREASDY IF SO,
    ls_sqlstring := 'select on_under from userrway ' ||
                    psi_user_where;
    -- Evaluate the SQL
    DBMS_SQL.parse(ll_cur, ls_sqlstring, DBMS_SQL.native);
    -- Associate the first column to the variable receiving the value
    DBMS_SQL.define_column(ll_cur, 1, ls_on_under, 2);
    -- Execute the SQL
    ll_ret := DBMS_SQL.execute_and_fetch(ll_cur);
    -- Assign the returned vaoue to the
    DBMS_SQL.column_value(ll_cur, 1, ls_on_under);
    -- Tidy up
    DBMS_SQL.close_cursor(ll_cur);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_SQL.close_cursor(ll_cur);
      p_sql_error('SELECTing the on_under using SQL ' ||
                  ls_sqlstring);
  END;

  IF f_ns(ls_on_under) THEN
  -- It does NOT already exist
  -- How many UNDERs are there? UNDERs are roadways with on_under OTHER than 1 (the ON record)
  -- Per NAC e-mail, if this is the only UNDER it should have on_under 2
  BEGIN
    SELECT COUNT(*)
      INTO ll_on_under_count
      FROM roadway
     --                               WHERE brkey = ls_brkey AND on_under <> '1';
     -- any under rows that are in the NBI range is a more correct test.
     WHERE brkey = ls_brkey
           --                           AND on_under = '2';
           AND INSTR('|2|A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|', -- WE ONLY CARE IF THE COUNT > 1 FOR UNDERS IN THIS SET OF ON_UNDER CODES
                     '|' || on_under || '|') > 0;
  EXCEPTION
    WHEN OTHERS THEN
      p_sql_error('in f_Feat_cross_type_to_on_under, when Selecting the count( * ) for brkey ''' ||
                  psi_brkey || '''');
  END;

  -- If there aren't any UNDERs yet, then the new one will be '2'
          IF ll_on_under_count = 0 THEN
          ls_on_under := '2'; -- This will be the first one
          -- If there is ALREADY an UNDER, then change it to 'A' and the new one is 'B'
        ELSIF ll_on_under_count = 1 -- NBI UNDER EXISTS, COPY AND CONVERT FROM 2 to A -- ONLY WHEN THERE IS BUT ONE RECORD.  IF A IS DELETED, THEN WEIRD STUFF WILL HAPPEN
         -- BUSINESS RULE - DELETE FROM Z UPWARDS, DON' T DELETE  A AND LEAVE B-Z....
   THEN
    BEGIN
      -- ANONYMOUS BLOCK - IT IS OKAY IF THE 2 RECORD DOESN'T EXIST
          -- RECODE 2 to A for ON_UNDER BY INSERTING AS COPY, T HEN DELETING - OK TO FAIL IF NO 2 EXISTS.
          INSERT INTO roadway
            SELECT brkey,
                   'A',
                   kind_hwy,
                   levl_srvc,
                   routenum,
                   dirsuffix,
                   roadway_name,
                   crit_feat,
                   kmpost,
                   bypasslen,
                   tollfac,
                   defhwy,
                   trucknet,
                   lanes,
                   funcclass,
                   adttotal,
                   adtyear,
                   trafficdir,
                   truckpct,
                   adtfuture,
                   adtfutyear,
                   road_speed,
                   det_speed,
                   school_bus,
                   transit_rt,
                   crit_trav,
                   num_median,
                   ten_yr_cnt,
                   acc_rate,
                   acc_risk,
                   vclrinv,
                   hclrinv,
                   aroadwidth,
                   roadwidth,
                   rkey,
                   rinspdone,
                   nhs_ind,
                   userrwkey1,
                   userrwkey2,
                   userrwkey3,
                   userrwkey4,
                   userrwkey5,
                   nbi_rw_flag,
                   acc_count,
                   rtrigger,
                   fedlandhwy,
                   adtclass,
                   onbasenet,
                   lrsinvrt,
                   subrtnum,
                   createdatetime,
                   createuserkey,
                   userkey,
                   modtime,
                   docrefkey,
                   notes
              FROM roadway
             WHERE brkey = ls_brkey AND on_under = '2';

          INSERT INTO userrway
            SELECT brkey,
                   'A',
                   clr_route,
                   route_num,
                   route_prefix,
                   route_suffix,
                   route_unique_id,
                   maint_rte_num,
                   maint_rte_prefix,
                   maint_rte_suffix,
                   maint_rte_id,
                   road_cross_name,
                   feat_cross_type,
                   feat_desc_type,
                   aroadwidth_far,
                   aroadwidth_near,
                   trans_lanes,
                   chan_prot_left,
                   chan_prot_right,
                   berm_prot,
                   hclr_n,
                   hclr_e,
                   hclr_s,
                   hclr_w,
                   vclrinv_n,
                   vclrinv_e,
                   vclrinv_s,
                   vclrinv_w,
                   hclrult_n,
                   hclrult_e,
                   hclrult_s,
                   hclrult_w,
                   hclrurt_n,
                   hclrurt_e,
                   hclrurt_s,
                   hclrurt_w,
                   vclr_n,
                   vclr_e,
                   vclr_s,
                   vclr_w,
                   ln1_vclr_n,
                   ln2_vclr_n,
                   ln3_vclr_n,
                   ln4_vclr_n,
                   ln5_vclr_n,
                   ln6_vclr_n,
                   ln7_vclr_n,
                   ln8_vclr_n,
                   ln1_vclr_s,
                   ln2_vclr_s,
                   ln3_vclr_s,
                   ln4_vclr_s,
                   ln5_vclr_s,
                   ln6_vclr_s,
                   ln7_vclr_s,
                   ln8_vclr_s,
                   ln1_vclr_e,
                   ln2_vclr_e,
                   ln3_vclr_e,
                   ln4_vclr_e,
                   ln5_vclr_e,
                   ln6_vclr_e,
                   ln7_vclr_e,
                   ln8_vclr_e,
                   ln1_vclr_w,
                   ln2_vclr_w,
                   ln3_vclr_w,
                   ln4_vclr_w,
                   ln5_vclr_w,
                   ln6_vclr_w,
                   ln7_vclr_w,
                   ln8_vclr_w,
                   totlanes,
                   vclr_n_sign,
                   vclr_s_sign,
                   vclr_e_sign,
                   vclr_w_sign,
                   toll_kdot,
                   adt_expan_fctr,
                   vc_date,
                   createdatetime,
                   createuserkey,
                   modtime,
                   userkey,
                   notes
              FROM userrway
             WHERE brkey = ls_brkey AND on_under = '2';

          -- kill old 2 record, now an A record
          DELETE FROM roadway
           WHERE brkey = ls_brkey AND on_under = '2';

          COMMIT; -- to recode 'em right now
    EXCEPTION
      WHEN OTHERS THEN
        NULL; -- MUST HAVE ALREADY BEEN AN  A RECORD, NOT A 2 RECORD
    END;

    /* Commented out until I can get pasted FK_USERRWAY_72_ROADWAY?!!
    -- Per NAC e-mail, update extant record to 'A'
     -- ROADWAY
     begin
        update roadway
           set on_under = 'A'
         where brkey = ls_brkey and on_under = '2';
     -- ENHANCEMENT Check for no rows affected?!
     exception
        when others
        then
           p_sql_error (   'Updating roadway.on_under to ''A'' for brkey '''
                        || psi_brkey
                        || '''');
     end;
    -- Must do USERRWAY first, due to integrity constraint
     begin
        update userrway
           set on_under = 'A'
         where brkey = ls_brkey and on_under = '2';
     -- ENHANCEMENT Check for no rows affected?!
     exception
        when others
        then
           p_sql_error (   'Updating userrway.on_under to ''A'' for brkey '''
                        || psi_brkey
                        || '''');
     end;
     */

    -- The new on_under is 'B'
    ls_on_under := 'B'; -- this makes count = 2 for unders
    -- If there is already more than one UNDER
  ELSIF ll_on_under_count > 1 THEN
    -- Get the next in the series 'C', 'D', etc.
    -- Note that 'B' is "maxer" than '2' (which is maxer than '1')
    /*  start with B , because we only want the ones that are B-Z
           pick THE MAX OUT OF INSTR ('|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z',
                  '|'
                  || on_under || '|'
                ) > 0
    */
    BEGIN
      SELECT MAX(on_under)
        INTO ls_max_on_under
        FROM roadway
       WHERE brkey = ls_brkey AND
             INSTR('|2|A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|', -- WE WANT THE MAX OF B-Z WHEN >1 UNDER (FORGET A)
                   '|' || on_under || '|') > 0;

      -- AND LENGTH (on_under) < 2; -- Eliminate 22 and 24

      IF SQL%ROWCOUNT = 0 -- There isn't ANY roadway record?!  THIS SHOULD NEVER HAPPEN
         THEN
          ls_on_under := '1'; -- Take the minimum
          lb_failed   := FALSE; -- We have our on_under
          p_bug(ls_context || ': No ROADWAY record for BRKEY ''' ||
                psi_brkey || '''??!');
          EXIT; -- Get out of the do-once - we're done!
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        p_sql_error('Selecting the max( on_under ) for brkey ''' ||
                    psi_brkey || '''');
    END;

    -- The on_under is the next value
    ls_on_under := CHR(ASCII(ls_max_on_under) + 1);

    -- Allen Marshall, CS - 2002.12.19
    -- TRAP TOO BIG - TOO MANY UNDERS.... -- bigger than nbi MAX
    IF ls_on_under > 'Z' THEN
      -- generate a random 2 character one, I guess, assuming we ever get here

      ls_on_under := ksbms_pontis_util.f_get_pontis_on_under(ls_brkey);
    END IF;
  END IF; -- If the current row doesn't already exist
          -- Else the record DOES already exist
          -- So just use the on_under returned by the select
        END IF;
        /* Hoyt 08/07/2002 Obsolete?! Trying to handle this above!

                     -- Note: technically speaking, if there is an on_under of B, then
                     -- the 2 should be switched to A, but this is a nasty detail.
                     if  lb_on_under_b_exists and not lb_on_under_a_exists
                     then
                        ls_on_under := 'A';
                     -- Discontinuity in sequence
                     elsif ls_max_on_under = '2'
                     then
                        ls_on_under := 'B';
                     -- Increment the max
                     else
                        -- Takes '1' and returns '2', takes 'B' and returns 'C'
                        ls_on_under := chr (  ascii (ls_max_on_under)
                                            + 1);

                        -- Bring it to someone's attention (very unlikely event)
     if ls_on_under = 'Z'
     then
        p_log ('Invalid on_under computed -- beyond ''Z''!');
     end if;
  end if;
  */
ELSE
  -- It is none of missing, 1, 2, 4, 10, 30, 50, 51 or 70
  -- this is 90, 92 , 93 etc.
  ls_on_under := SUBSTR(ls_feat_cross_type, 1, 2); -- substr() so it's not too large
        -- NB: No provision for assuring that an extant on_under value
        -- is not contained within feat_cross_type, e.g 'B', which will
        -- cause a unique-index failure when the INSERT is attempted.
      END IF;

      -------------------
      -- Success exit
      -------------------

      -- Not in production!
      -- pl( 'The on_under is ' || ls_on_under );

      -- Return it to the calling routine
      pso_on_under := ls_on_under;
      lb_failed    := FALSE;
      EXIT do_once; -- Done!
    END LOOP do_once;

    ksbms_util.p_pop(ls_context);
    RETURN lb_failed;
  END f_feat_cross_type_to_on_under;

  FUNCTION f_update_pontis_records(pio_entry_id               IN ds_change_log.entry_id%TYPE,
                                 pio_number_updated         IN OUT PLS_INTEGER,
                                 pio_number_inserted        IN OUT PLS_INTEGER,
                                 pio_number_failed          IN OUT PLS_INTEGER,
                                 pio_number_inserted_failed IN OUT PLS_INTEGER,
                                 pio_where_count            IN OUT PLS_INTEGER)
  RETURN BOOLEAN IS
  --------------------------------------------------------
  -- These Booleans control behavior during development
  --------------------------------------------------------
  -- If this is FALSE, then all "development" related values are set to their PRODUCTION values
  lb_in_development BOOLEAN := FALSE; -- VERYURGENT Make this right!
  -- Set to TRUE to have WHERE and INSERT clauses logged to ds_msg_log
  lb_logging_where_and_inserts BOOLEAN := TRUE; -- FALSE in production
  -- Set to TRUE to see the WHEREs
  lb_logging_wheres BOOLEAN := FALSE; -- Only relevant if lb_logging_where_and_inserts is TRUE
  -- Set to TRUE to see the INSERTs
  lb_logging_inserts BOOLEAN := FALSE; -- Only relevant if lb_logging_where_and_inserts is TRUE
  -- Set to TRUE to see the KEYs returned by f_build_where_clause
  lb_logging_keys BOOLEAN := FALSE; -- Only relevant if lb_logging_where_and_inserts is TRUE
  -- Set to TRUE to skip the UPDATEs, e.g. when you're getting the WHEREs right
    lb_working_on_build_where BOOLEAN := TRUE; -- Only relevant if lb_logging_where_and_inserts is TRUE
    -- Set to TRUE to test whether the SQL executes properly
    lb_testing_inserts BOOLEAN := FALSE; -- Only relevant if lb_logging_where_and_inserts is TRUE
    -- Set to TRUE to LOG the INSERT SQL that executes properly
    lb_show_insert_sql_that_works BOOLEAN := TRUE; -- TRUE for more diagnostics in log
    -- Set to TRUE to quit processing after first INSERT failure
    lb_stop_on_1st_insert_failure BOOLEAN := TRUE; -- TRUE to stop executing more quickly
    -- Set to TRUE to LOG the UPDATE SQL that executes properly
    lb_show_update_sql_that_works BOOLEAN := FALSE; -- TRUE for more diagnostics in log
    -- Set to TRUE to DELETE the record, so an UPDATE is necessary
    lb_delete_to_force_insert BOOLEAN := TRUE; -- FALSE in production
    -- Set to FALSE to avoid deleting ds_change_log ds_lookup_keyvals records during development
    lb_deleting_applied_records BOOLEAN := FALSE; -- TRUE in production
    -- Set to FALSE to save time "setting" associated data
    lb_skip_set_data_after_insert BOOLEAN := TRUE; -- FALSE in production
    -- Set to TRUE to skip further processing after checking for row existance
    lb_skip_after_row_exists_test BOOLEAN := FALSE; -- FALSE in production
    -- Set to TRUE to copy APPLIED records from the archive to ds_change_log_c,
    -- to test whether the ds_change_log_c to archive move works properly
    lb_move_applied_2_change_log_c BOOLEAN := FALSE; -- FALSE in production
    -- ARM, CS 2002.12.16 - added this boolean to figure out if we can touch columns like ROUTE_PREFIX which have been set to nothing useful on first insert
    -- look for magic strings in the raw records
    lb_ok_to_touch_keycols BOOLEAN := FALSE; -- when true, match columns can be updated via syncher - only for NEW records on FIRST ATTEMPT - RESETS A NOTES
    -- value "NEWUNINITIALIZEDKEYS" to "NEWINITIALIZEDKEYS"
    -- lb_ok_to_touch_keycols := FALSE; -- assumed, reset after all the obligatory inserts are done below....

    ------------------------------------------------------------------------------
    -- Booleans used programmatically (not to control behavior during development)
    ------------------------------------------------------------------------------
    lb_update_succeeded            BOOLEAN;
    lb_failed                      BOOLEAN := TRUE; -- Until we succeed
    lb_show_skip                   BOOLEAN;
    lb_need_to_add_pontis_record   BOOLEAN;
    lb_need_to_add_user_record     BOOLEAN;
    lb_record_found                BOOLEAN;
    lb_log_unique_contraint_errors BOOLEAN := TRUE; -- <ENHANCEMENT> COPTION?
    lb_skip_key_columns            BOOLEAN := FALSE;
    -- <ENHANCEMENT> What should this be?
    ------------------------------------------------------------------------------
    -- Counters
    ------------------------------------------------------------------------------
    -- Hoyt 08/08/2002 Now this is passed in
    -- li_updated_count                 pls_integer                      := 0;
    li_update_failed_count    PLS_INTEGER := 0;
    li_bridge_inserts         PLS_INTEGER := 0;
    li_inspevnt_inserts       PLS_INTEGER := 0;
    li_structure_unit_inserts PLS_INTEGER := 0;
    li_roadway_inserts        PLS_INTEGER := 0;
    ------------------------------------------------------------------------------
    -- Misc. variables
    ------------------------------------------------------------------------------
    ls_context       ksbms_util.context_string_type := 'f_update_pontis_records()';
    ls_pontis_where  VARCHAR2(4000);
    ls_user_where    VARCHAR2(4000);
    ls_sql           VARCHAR2(4000);
    ls_sql2          VARCHAR2(4000);
    li_strunitkey    structure_unit.strunitkey%TYPE;
    ls_brkey         bridge.brkey%TYPE;
    li_sqlcode       PLS_INTEGER;
    ls_pontis_insert VARCHAR2(4000);
    ls_user_insert   VARCHAR2(4000);
    ls_second_key    VARCHAR2(100);
    ls_third_key     VARCHAR2(100);
    ls_sql_error     VARCHAR2(4000);
    ls_column_name   VARCHAR2(100);
    ll_count         PLS_INTEGER;
    ll_nrows         PLS_INTEGER;
    -- Hoyt 08/08/2002 Pass it, so it actually accumulates!
    -- li_where_count                   pls_integer                      := 0;
    ls_other_table               VARCHAR2(100);
    ls_which_where               VARCHAR2(4000);
    ls_pontis_target_table       VARCHAR2(40);
    ls_user_target_table         VARCHAR2(40);
    ls_user_form_of_pontis_where VARCHAR2(4000);
    ls_scratch_where             VARCHAR2(4000);
    li_number_rows_moved         PLS_INTEGER;
    ls_inspkey                   inspevnt.inspkey%TYPE;
  BEGIN
    ksbms_util.p_push(ls_context);

    <<outer_exception_block>>
    BEGIN
    -- Make sure the various Booleans are set up for production
    -- (if we're not in development)
    -- Keep this updated as Booleans are added!
    IF NOT lb_in_development THEN
      lb_logging_where_and_inserts   := FALSE;
      lb_logging_wheres              := TRUE;
      lb_logging_inserts             := TRUE;
      lb_logging_keys                := TRUE;
      lb_working_on_build_where      := TRUE;
      lb_testing_inserts             := FALSE;
      lb_show_insert_sql_that_works  := FALSE;
      lb_stop_on_1st_insert_failure  := FALSE;
      lb_show_update_sql_that_works  := FALSE;
      lb_delete_to_force_insert      := FALSE;
      lb_deleting_applied_records    := TRUE; -- Really: TRUE in production
      lb_skip_set_data_after_insert  := FALSE;
      lb_skip_after_row_exists_test  := FALSE;
      lb_move_applied_2_change_log_c := FALSE;
    END IF;

    <<do_once>>
    LOOP
      -- Clear the counter
      --pio_number_updated := 0;

      -- Hoyt 08/06/2002 Continue to use a cursor even though we'll only get one record, to minimize changes!
    -- Select all of the UPD (UPDATE) records from CANSYS
    DECLARE
      -- Get all the merge-ready records representing UPDATEs from CANSYS.
      -- These are merge-ready UPD records from CANSYS.
      CURSOR updates_to_process_cursor IS
      SELECT ds_change_log.entry_id                                                              entry_id,
           ds_change_log.exchange_rule_id                                                      exchange_rule_id,
           ds_change_log.exchange_type                                                         exchange_type,
           ds_change_log.new_value                                                             new_value,
           TRUNC(ds_change_log.createdatetime) createdate,
           ds_transfer_map.table_name                                                          target_table_name,
           ds_transfer_map.column_name                                                         target_column_name
      FROM ds_change_log, ds_transfer_map
     WHERE ds_change_log.entry_id = pio_entry_id AND
           ds_change_log.exchange_rule_id =
           ds_transfer_map.exchange_rule_id AND
           ds_change_log.exchange_type = ls_update_type
     -- Hoyt 08/06/2002 Now these two "and's" are applied in f_update_pontis()
         -- and ds_change_log.exchange_status = ls_merged
         -- and ds_change_log.precedence = 'FC'
         --order by ds_transfer_map.table_name;
         ORDER BY ds_change_log.sequence_num;

      -- NB: 'for update' causes autonomous_transaction pragma to fail

      updates_to_process_cursor_rec updates_to_process_cursor%ROWTYPE;
    BEGIN

      -- Loop through all the UPDATE change log records
      <<change_log_loop>>
      FOR updates_to_process_cursor_rec IN updates_to_process_cursor LOOP
      -- Disallow changes to key columns?
      IF lb_skip_key_columns THEN
      BEGIN
      ls_column_name   := updates_to_process_cursor_rec.target_column_name;
      ls_scratch_where := 'column_name = ' ||
                          ksbms_util.sq(updates_to_process_cursor_rec.target_column_name) ||
                          '  and table_name = ' ||
                          ksbms_util.sq(updates_to_process_cursor_rec.target_table_name);
      ll_count         := 0;

      IF ksbms_util.f_any_rows_exist('ds_transfer_key_map',
                                     ls_scratch_where) THEN
        ll_count := 1;
      END IF;

      --ARM 3/6/2002 do not scan to find this fact out - use ksbms_util.f_any_rows_Exist
      /*
      select count (*)
        into ll_count
        from ds_transfer_key_map
       where column_name = updates_to_process_cursor_rec.target_column_name
         and table_name = updates_to_process_cursor_rec.target_table_name;
         */

      -- If we hit this, it is a key column
      IF ll_count > 0 THEN
      -- Mark the column as a KEY COLUMN (<KEYCOL) to show why it wasn't applied
              BEGIN
                UPDATE ds_change_log
                   SET exchange_status = '<KEYCOL>'
                 WHERE entry_id =
                       updates_to_process_cursor_rec.entry_id;
                -- Allen Marshall, CS -2003.04.08
                -- UH OH, COMMIT INSIDE FOR  LOOP - MAY CAUSES FETCH OUT OF SEQUENCE
                --COMMIT;
                IF SQL%ROWCOUNT = 0 THEN
                  NULL; -- raise no_data_affected;
                END IF;
              EXCEPTION
                WHEN no_data_affected THEN
                  p_sql_error('No data affected when marking change log as <KEYCOL>');
                WHEN OTHERS THEN
                  p_sql_error('Failed to mark change log as <KEYCOL>');
              END;

              lb_show_skip := TRUE;
              GOTO the_end_of_the_update_loop;
            END IF;
          EXCEPTION
            WHEN OTHERS THEN
              p_sql_error('SELECTing to see if it is a key column.');
          END;
        END IF;

        -- Breakpoint
        IF updates_to_process_cursor_rec.exchange_rule_id = 2580 THEN
          updates_to_process_cursor_rec.exchange_rule_id := updates_to_process_cursor_rec.exchange_rule_id;
        END IF;

        -- Breakpoint
        IF pio_number_updated = 48 THEN
          pio_number_updated := pio_number_updated;
        END IF;

        -- Build the WHERE clause for the UPDATE statement,
        -- and the INSERT clauses used if the record doesn't already exist.
      IF f_build_where_clause(updates_to_process_cursor_rec.entry_id,
                              updates_to_process_cursor_rec.target_table_name,
                              ls_pontis_where,
                              ls_user_where,
                              ls_pontis_insert,
                              ls_user_insert,
                              ls_pontis_target_table,
                              ls_user_target_table,
                               -- The three keys below are returned so they can be passed to any of
                               -- four f_set_new_XXX_data() functions when a record is INSERTed.
                              ls_brkey,
                              ls_second_key,
                              ls_third_key) THEN
        EXIT do_once; -- Failed
      END IF;

      -- So we can figure out which WHERE is failing
      pio_where_count := pio_where_count + 1;

      -- A convenient way to "break" at WHEREs that are presenting problems during development
      IF pio_where_count = 18 THEN
        pio_where_count := pio_where_count; -- <ENHANCEMENT> Debugbreak
      END IF;

      -- This block is used to log various items returned by f_build_where_clause()
      -- (for development only). In also contains a block for testing the INSERTs
      -- returned by f_build_where_clause().
      IF lb_logging_where_and_inserts THEN
      IF lb_logging_wheres THEN
      p_log(updates_to_process_cursor_rec.target_table_name ||
            ' Pontis: ' || ls_pontis_where);

      -- Don't log it if it is the same
            IF ls_pontis_where <> ls_user_where THEN
              p_log(updates_to_process_cursor_rec.target_table_name ||
                    ' User: ' || ls_user_where);
            END IF;
          END IF;

          -- Logging the inserts
          IF lb_logging_inserts THEN
            -- These include the target table, so they are always different
            p_log(ls_pontis_insert);
            p_log(ls_user_insert);
          END IF;

          -- Logging the keys returned by f_build_where_clause()
          IF lb_logging_keys THEN
            p_log('Keys: ' || ls_brkey || ', ' || ls_second_key || ', ' ||
                  ls_third_key);
          END IF;

          -- Set to TRUE to test whether the SQL executes properly
          IF lb_testing_inserts THEN
            -- Insert the Pontis and user records
            BEGIN
            EXECUTE IMMEDIATE ls_pontis_insert;
          EXCEPTION
            WHEN OTHERS THEN
            ls_sql_error := SQLERRM;

            -- The 'unique constraint' is in SQLERRM if the keys already exist,
            -- i.e. the record is already there... which means the INSERT "worked"
            IF INSTR(ls_sql_error, 'unique constraint') = 0 THEN
            -- It's some other SQL failure
            p_bug('IN WHERE TEST BLOCK: FAILED Pontis: ' ||
                  ls_pontis_insert);
            p_bug('INSERT SQL Error: ' || ls_sql_error);
            p_bug('WHERE COUNT is: ' || TO_CHAR(pio_where_count));

            IF lb_stop_on_1st_insert_failure THEN
              p_log('Stopping because lb_stop_on_1st_insert_failure is TRUE');
              EXIT do_once;
            END IF;
          ELSIF lb_show_insert_sql_that_works THEN
            p_log('SUCCESS: ' || ls_pontis_insert); -- Allen 9/17/2002 typo
          END IF;
      END;

      BEGIN
      EXECUTE IMMEDIATE ls_user_insert;
    EXCEPTION
      WHEN OTHERS THEN
      ls_sql_error := SQLERRM;

      -- The 'unique constraint' is in SQLERRM if the keys already exist,
      -- i.e. the record is already there... which means the INSERT "worked"
      IF INSTR(ls_sql_error, 'unique constraint') = 0 THEN
      -- It's some other SQL failure
                  p_bug('IN WHERE TEST BLOCK: FAILED User: ' ||
                        ls_user_insert);
                  p_bug('INSERT SQL Error: ' || ls_sql_error);
                  p_bug('WHERE COUNT is: ' || TO_CHAR(pio_where_count));

                  IF lb_stop_on_1st_insert_failure THEN
                    p_log('Stopping because lb_stop_on_1st_insert_failure is TRUE');
                    EXIT do_once;
                  END IF;
                ELSIF lb_show_insert_sql_that_works THEN
                  p_log('SUCCCESS: ' || ls_user_insert);
                END IF;
            END;
          END IF;

          IF lb_working_on_build_where THEN
            -- Skip the rest of the process
            lb_show_skip := FALSE;
            GOTO the_end_of_the_update_loop;
          END IF;
        END IF;

        -- If any keys are missing, then skip this one
        -- We check both, on the theory that we don't INSERT one without the other,
        -- e.g. we don't insert ROADWAY if we cannot also insert USERRWAY
        IF INSTR(ls_pontis_where, '<MISSING>') <> 0 OR
           INSTR(ls_user_where, '<MISSING>') <> 0 THEN
          IF INSTR(ls_pontis_where, '<MISSING>') <> 0 THEN
            p_log('MISSING Pontis DATA: ' || ls_pontis_where);
          END IF;

          IF INSTR(ls_user_where, '<MISSING>') <> 0 THEN
            p_log('MISSING User DATA: ' || ls_user_where);
          END IF;

          lb_show_skip := TRUE;
          GOTO the_end_of_the_update_loop;
        END IF;

        -- For testing, delete the record, so it doesn't exist?!
      IF lb_delete_to_force_insert THEN
        -- Which where do we apply? Pontis or USER version?
        IF INSTR(updates_to_process_cursor_rec.target_table_name,
                 'USER') = 0 THEN
          ls_which_where := ls_pontis_where;
        ELSE
          ls_which_where := ls_user_where;
        END IF;

        -- Delete the first record
        ls_sql := 'delete from ' ||
                  updates_to_process_cursor_rec.target_table_name || ' ' ||
                  ls_which_where;

        BEGIN
          EXECUTE IMMEDIATE ls_sql;
        EXCEPTION
          WHEN OTHERS THEN
            ls_sql_error := SQLERRM;
            p_bug('FAILED to DELETE 1st: ' || ls_sql);
            p_bug('DELETE SQL Error: ' || ls_sql_error);
        END;

        -- Delete the second record
        ls_other_table := f_get_the_associated_table(updates_to_process_cursor_rec.target_table_name);

        -- Which where do we apply? Pontis or USER version?
        IF INSTR(ls_other_table, 'USER') = 0 THEN
          ls_which_where := ls_pontis_where;
        ELSE
          ls_which_where := ls_user_where;
        END IF;

        ls_sql := 'delete from ' || ls_other_table || ' ' ||
                  ls_which_where;

        BEGIN
          EXECUTE IMMEDIATE ls_sql;
          -- COMMIT INSIDE FOR LOOP - DISABLING
          --COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            ls_sql_error := SQLERRM;
            p_bug('FAILED to DELETE 2nd: ' || ls_sql);
            p_bug('DELETE SQL Error: ' || ls_sql_error);
        END;
      END IF;

      -- Does the record exist already?
      -- Which where do we apply? Pontis or USER version?
      IF INSTR(updates_to_process_cursor_rec.target_table_name,
               'USER') = 0 THEN
        ls_which_where := ls_pontis_where;
      ELSE
        ls_which_where := ls_user_where;
      END IF;

      -- For testing to confirm that f_any_rows_exist() is working
      -- ls_which_where := ls_which_where || ' and brkey = ''1234'''; -- So the record is NOT found

      -- Do we need to add the Pontis record?
      ls_sql                       := 'select 1 from ' ||
                                      ls_pontis_target_table || ' ' ||
                                      ls_pontis_where;
      lb_need_to_add_pontis_record := NOT
                                       ksbms_util.f_any_rows_exist(ls_sql);

      -- If so, add it
      IF lb_need_to_add_pontis_record THEN
        -- Insert the Pontis and user records
        BEGIN
          p_log('In ' || ls_context ||
                ' - Inserting new record with SQL:' ||
                ksbms_util.crlf || ls_pontis_insert);
          EXECUTE IMMEDIATE ls_pontis_insert;
        EXCEPTION
          WHEN OTHERS THEN
            ls_sql_error := SQLERRM;
            p_bug('FAILED Pontis: ' || ls_pontis_insert);
            p_bug('INSERT SQL Error: ' || ls_sql_error);
            p_bug('Where count is ' || TO_CHAR(pio_where_count));
            p_bug('SQL that failed to find the record: ' || ls_sql);
            -- Hoyt 08/09/2002 Track this
            pio_number_inserted_failed := pio_number_inserted_failed + 1;
        END;
      END IF;

      -- Do we need to add the USER record?
      -- The following f_substr() is necessary to adapt the Pontis where for USERRWAY
      -- ARM 3/6/2002 send null, which will cause the REPLACE function within f_substr to drop all such token strings
      ls_user_form_of_pontis_where := ksbms_util.f_substr(ls_pontis_where,
                                                          'ROADWAY.',
                                                          NULL);
      ls_sql                       := 'select 1 from ' ||
                                      ls_user_target_table || ' ' ||
                                      ls_user_form_of_pontis_where; -- Pontis where on purpose! USER keys correspond to Pontis keys!
      lb_need_to_add_user_record   := NOT
                                       ksbms_util.f_any_rows_exist(ls_sql);

      -- If so, add it
      IF lb_need_to_add_user_record THEN
        -- Insert the Pontis and user records
        p_log('In ' || ls_context ||
              ' - Inserting new record with SQL:' || ksbms_util.crlf ||
              ls_user_insert);

        BEGIN
          EXECUTE IMMEDIATE ls_user_insert;
        EXCEPTION
          WHEN OTHERS THEN
            ls_sql_error := SQLERRM;
            p_bug('FAILED User: ' || ls_user_insert);
            p_bug('INSERT SQL Error: ' || ls_sql_error);
            p_bug('Where count is ' || TO_CHAR(pio_where_count));
            p_bug('SQL that failed to find the record: ' || ls_sql);
            -- Hoyt 08/09/2002 Track this
            pio_number_inserted_failed := pio_number_inserted_failed + 1;
        END;
      END IF;

      -- Apply the f_set_new_xxx_data() functions if a Pontis record was added

      -- BEGIN CHANGE
      -- Allen Marshall, CS - 01/23/2003 - fixup the just inserted USERRWAY record if it has a good CLR_ROUTE value - fix it right away before
      -- anything else happens.

      IF lb_need_to_add_user_record THEN
        IF UPPER(ls_user_target_table) = 'USERRWAY' THEN
          IF NOT f_evaluate_clr_route(ls_third_key) THEN
            -- good, set dependent userrway columns
            p_log('In ' || ls_context ||
                  ' - fixing up newly inserted USERRWAY Data');

            IF f_set_new_userrway_data(ls_brkey,
                                       ls_second_key,
                                       ls_third_key) THEN
              p_bug('f_set_new_userrway_data() failed in ' ||
                    ls_context);
            END IF;
          END IF;
        END IF;
      END IF;

      -- Allen Marshall, CS - 01/23/2003 - fixup new USERRWAY RECORDS like ROADWAY records
      -- END CHANGE OF LOGIC FOR NEW USERRWAY RECORDS

      IF lb_need_to_add_pontis_record THEN
        lb_ok_to_touch_keycols := TRUE;

        -- Call the various functions that populate the records
        IF NOT lb_skip_set_data_after_insert -- Skip to save time -- f_set_new_xxx_data()s are slow!
       THEN
        IF UPPER(ls_pontis_target_table) = 'BRIDGE' THEN
        li_bridge_inserts := li_bridge_inserts + 1; -- Report at end of process

        IF f_set_new_structure_data(ls_brkey) THEN
          p_bug('f_set_new_structure_data() failed in ' ||
                ls_context);
        END IF;

        -- Hoyt 06/08/2002 If we added a bridge, then add the inspevnt/userinsp too.
        -- The INSPKEY is generated by f_add_inspevnt() and is returned via ls_inspkey.
        IF f_add_inspevnt(ls_brkey, SYSDATE, ls_inspkey) THEN
          EXIT;
        END IF;

        -- Hoyt 06/08/2002 We keep track of this count (though it's redundant with bridges added)
            li_inspevnt_inserts := li_inspevnt_inserts + 1; -- Report at end of process
          ELSIF UPPER(ls_pontis_target_table) = 'INSPEVNT' THEN
            li_inspevnt_inserts := li_inspevnt_inserts + 1; -- Report at end of process

            -- Order is on purpose

            IF f_set_new_inspevnt_data(ls_brkey, ls_third_key) -- ls_second_key
             THEN
              p_bug('f_set_new_inspevnt_data() failed in ' ||
                    ls_context);
            END IF;
          ELSIF UPPER(ls_pontis_target_table) = 'ROADWAY' THEN
            li_roadway_inserts := li_roadway_inserts + 1; -- Report at end of process
            p_log('In ' || ls_context ||
                  ' - fixing up newly inserted ROADWAY Data');

            IF f_set_new_roadway_data(ls_brkey, ls_second_key) THEN
              p_bug('f_set_new_roadway_data() failed in ' ||
                    ls_context);
            END IF;
          ELSIF UPPER(ls_pontis_target_table) = 'STRUCTURE_UNIT' THEN
            li_structure_unit_inserts := li_structure_unit_inserts + 1; -- Report at end of process

            IF f_set_new_structure_unit_data(ls_brkey, ls_second_key) THEN
              p_bug('f_set_new_structure_unit_data() failed in ' ||
                    ls_context);
            END IF;
          ELSE
            p_bug('Unhandled target table: ' ||
                  updates_to_process_cursor_rec.target_table_name);
          END IF;
        END IF;
      ELSIF -- don't need to add a record, apparently, but are we trying to update some new one to fill its key columns?

       -- relies on the idea that the NOTES column in the target has the magic string NEWUNINITIALIZEDKEYS in it somewhere (INSR)
       f_uninitialized_keymatch_cols(ls_pontis_target_table,
                                     ls_brkey,
                                     ls_second_key,
                                     ls_third_key) THEN
        lb_ok_to_touch_keycols := TRUE;
      END IF;

      -- At this point, we know that the row exists, so we can now apply the update

      -- Wrap the new value
      IF ksbms_util.f_wrap_data_value(updates_to_process_cursor_rec.target_table_name,
                                      updates_to_process_cursor_rec.target_column_name,
                                      updates_to_process_cursor_rec.new_value) THEN
        p_sql_error('Attempting to f_wrap_data_value in ' ||
                    ls_context); -- f_wrap_data_value() failed
      END IF;

      -- Build the UPDATE clause
      ls_sql := 'UPDATE ' ||
                updates_to_process_cursor_rec.target_table_name ||
                ' set ' ||
                updates_to_process_cursor_rec.target_column_name ||
                ' = ' || updates_to_process_cursor_rec.new_value || ' ' ||
                ls_which_where;
      -- Hoyt 08/09/2002 Prevent updating of key columns
      ls_sql2 := 'select 1 from ds_transfer_key_map where table_name = ''' ||
                 updates_to_process_cursor_rec.target_table_name ||
                 ''' and column_name = ''' ||
                 updates_to_process_cursor_rec.target_column_name || '''';

      -- Allen Marshall, CS- 2002.12.16 - check if allowed, then see if rows exist in the keys for the target column
      IF NOT lb_ok_to_touch_keycols THEN
        -- see if this is NOT one of the newly inserted records with uninitialized keys  like ROUTE PREFIX or whatever
        IF ksbms_util.f_any_rows_exist(ls_sql2) THEN
          -- formatting updated 2003-02-04 ARM
          p_log('Disallowed: Updating already initialized key column > ' ||
                updates_to_process_cursor_rec.target_table_name || '.' ||
                updates_to_process_cursor_rec.target_column_name);
          p_log('Disallowed SQL: --> ' || ls_sql);
          -- Count this as a failed update
          li_update_failed_count := li_update_failed_count + 1;
          -- CHANGE CHANGE CHANGE
          -- Allen Marshall, CS - 2003-02-04
          -- this record failed to be updated..... Mark as such
          --Allen Marshall, CS - 2003-02-04 - trap update failure
          UPDATE ds_change_log
             SET exchange_status = 'FAILED'
           WHERE entry_id = updates_to_process_cursor_rec.entry_id;
          --COMMIT;
          -- for now, leave in place, do not archive, but set to FAILED
          -- CHANGE CHANGE CHANGE
          EXIT;
        END IF;
      END IF;

      -- Execute the update
      BEGIN
      lb_update_succeeded := TRUE; -- Until we fail below
      EXECUTE IMMEDIATE ls_sql;

      -- Did the execute find a record?
      IF SQL%NOTFOUND THEN
      -- Hoyt 08/09/2002 There is no error when no record was found: "Oracle normal completion..."
      -- Old: ls_sql_error := sqlerrm; -- So it's not lost when p_bug() logs its message
            p_bug('UPDATE SQL Error: No record was found');
            -- Hoyt 08/09/2002 Redundant with "Failed-->" comment below
            -- p_bug (   'FAILED: '
            --        || ls_sql);
            lb_update_succeeded := FALSE;
          END IF;

          -- After the sql%notfound so the sql%notfound is still valid
          COMMIT;

          -- Log the update result
          IF lb_update_succeeded THEN
            IF lb_show_update_sql_that_works THEN
              p_log(ls_sql || '   <--- Worked!');
            END IF;

            -- Count how many are updated
            -- Hoyt 08/08/2002 Replace li_updated_count with pio_number_updated
            -- li_updated_count :=   li_updated_count
            pio_number_updated := pio_number_updated + 1;
            -- Log how many were updated
            -- (this log call only inserts the first time, thereafter it updates)
            -- Hoyt 08/08/2002 Replace li_updated_count with pio_number_updated
            -- Allen Marshall, CS - 2003.04.11 - lb_show_update_sql_that_works Turns off annoying log messages during loop processing
            IF lb_show_update_sql_that_works THEN
            ksbms_util.p_log_last('Number updates applied: ',
                                  TO_CHAR(NVL(pio_number_updated, 0)));
            END IF;
            -- We have to "mark" it where current of cursor;
            -- attempting a delete or update OTHER than 'where current of'
            -- causes the next loop through the cursor to fail.
            BEGIN
              UPDATE ds_change_log
                 SET exchange_status = ls_delete
               WHERE entry_id = updates_to_process_cursor_rec.entry_id;
              --COMMIT;
              IF SQL%ROWCOUNT = 0 THEN
                NULL; -- raise no_data_affected;
              END IF;
            EXCEPTION
              WHEN no_data_affected THEN
                p_sql_error('No data affected when marking change log for update');
              WHEN OTHERS THEN
                p_sql_error('Failed to mark change log for update');
            END;

            BEGIN
              UPDATE ds_change_log
                 SET exchange_status = ls_delete
               WHERE entry_id = updates_to_process_cursor_rec.entry_id;
              --COMMIT;
              IF SQL%ROWCOUNT = 0 THEN
                NULL; -- raise no_data_affected;
              END IF;
            EXCEPTION
              WHEN no_data_affected THEN
                p_sql_error('No data affected when marking change log for update');
              WHEN OTHERS THEN
                p_sql_error('Failed to mark change log for update');
            END;
          END IF;
        EXCEPTION
          WHEN OTHERS THEN
            ls_sql_error := SQLERRM;
            p_log('FAILED UPDATing in ' || ls_context || gs_crlf ||
                  gs_crlf || 'Failed SQL: ' || ls_sql);
            p_log('Failed UPDATE SQL error: ' || ls_sql_error);
        END;

        -- Track the failures
        IF NOT lb_update_succeeded THEN
          p_log('Failed --->' || ls_sql);
          -- Count how many are updated
          li_update_failed_count := li_update_failed_count + 1;
          -- CHANGE CHANGE CHANGE
          -- Allen Marshall, CS - 2003-02-04
          -- this record failed to be updated..... Mark as such
          --Allen Marshall, CS - 2003-02-04 - trap update failure
          UPDATE ds_change_log
             SET exchange_status = 'FAILED'
           WHERE entry_id = updates_to_process_cursor_rec.entry_id;
          -- COMMIT;
          -- for now, leave in place, do not archive, but set to FAILED
          -- CHANGE CHANGE CHANGE

        END IF;

        lb_show_skip := FALSE;

        <<the_end_of_the_update_loop>>
        IF lb_show_skip THEN
          p_log('Skipping ' ||
                updates_to_process_cursor_rec.target_column_name);
        END IF;
      END LOOP change_log_loop;
    END;

    /* Hoyt 08/08/2002 All of this belongs in f_update_pontis now

                      -- Hoyt 3/18/2002
                      -- In production, we move the successfully-applied records from the
                      -- change log to the archive, with exchange_status = 'APPLIED'. This
                      -- occurs inside this 'if lb_deleting_applied_records' block because
                      -- sometimes, during development, it's convenient to leave the records
      -- in ds_change_log for subsequent re-application... and the INSERTs
      -- below will fail with duplicate keys if the move-to-archive is done.
      if lb_deleting_applied_records -- In production, always!
      then
         -- Hoyt 03/18/2002 Move all the '<DELETE>' records into the archive
         begin
            -- Move the records that were successfully applied
            -- and so marked <DELETE> in the loop above
            insert into ds_change_log_archive
               -- Take the records from Pontis's ds_change_log
                               (select entry_id,
                                       sequence_num,
                                       gs_job_id, -- Global set in f_update_pontis()
                                       ls_cansys_schema,
                                       -- NVL() because these columns are all NOT NULL
                                       nvl (exchange_rule_id, -1),
                                       nvl (exchange_type, '*'),
                                       nvl (old_value, '*'),
                                       nvl (new_value, '*'),
                                       'APPLIED',
                                       sysdate, -- Per Allen's 3/13/2002 e-mail
                       createuserid,
                       remarks -- Preserve the original remarks?
                  from ds_change_log -- Pontis version!
                 where exchange_status = ls_delete); -- These are the successfully-applied records

            li_number_rows_moved := sql%rowcount;
            ksbms_util.p_log (
                  'Moved ' -- Since we're deleting them shortly
                               || to_char (li_number_rows_moved)
                               || ' CANSYS (originally) change log records from the Pontis change log into the change log archive, with exchange status APPLIED'
                            );
                         exception
                            when others
                            then
                               p_sql_error ('Inserting CANSYS change log records with exchange_status APPLIED into the change log archive');
                         end;

                         -- Move the corresponding CANSYS KEYVALS records into the archive
                         if li_number_rows_moved > 0
                         then
                            begin
                               insert into ds_lookup_keyvals_archive
                                  (select entry_id,
                                          keyvalue,
                                          key_sequence_num,
                                          createdatetime,
                                          createuserid
                                     from ds_lookup_keyvals -- Pontis version!
                                    where entry_id in (select entry_id
                                                         from ds_change_log
                                                        where exchange_status = ls_delete));

                               ll_nrows := sql%rowcount;

                               if ll_nrows = 0
                               then
                                  raise no_data_affected;
                               end if;

                               ksbms_util.p_log (
                                     'Inserted '
                                  || to_char (ll_nrows)
                                  || ' CANSYS records with ds_change_log.exchange_status APPLIED into the key values archive'
                               );
                            exception
                               when no_data_affected
                               then
                                  p_sql_error ('No CANSYS key values records inserted into the archive!');
                               when others
                               then
                                  p_sql_error ('Inserting CANSYS key value records into the archive');
                            end;
                         end if;

                         -- Delete all the <DELETE> records from ds_change_log;
                         -- Referential integrity will take care of the keyvals records
                         begin
                            delete from ds_change_log
                                  where exchange_status = ls_delete;
                         exception
                            when others
                            then
                               p_sql_error ('Failed to DELETE the <DELETE> records from ds_change_log');
                         end;
                      else
                         -- Note it, so we don't accidentally leave lb_deleting_applied_records FALSE
         p_log ('DEVELOPMENT MODE! Applied change log records were not deleted!');
      end if;

      -- Hoyt 03/18/2002
      -- Move the STALE and SUPERSEDED records from the temp table into the archive.
      -- This is the set of records that were Pontis or CANSYS UPDates, but were
      -- not applied because they were either (1) too old (STALE) or (2) created by
      -- one system but the other system changed the same datum and the other system
      -- has precedence (SUPERSEDED). Do it in two steps, so we can differentiate
      -- the STALE count from the SUPERSEDED count.
      --
      -- First STALE
      begin
         -- Move the records that were marked as STALE by the merge process
         insert into ds_change_log_archive
            -- Take all the STALE records from the TEMP table
            (select entry_id,
                    sequence_num,
                    gs_job_id, -- Global set in f_update_pontis()
                    -- NVL() because these columns are all NOT NULL
                    nvl (schema, '*'),
                    nvl (exchange_rule_id, -1),
                    nvl (exchange_type, '*'),
                    nvl (old_value, '*'),
                    nvl (new_value, '*'),
                    nvl (exchange_status, '*'),
                    sysdate, -- Per Allen's 3/13/2002 e-mail
                                    createuserid,
                                    remarks -- Preserve the original remarks?
                               from ds_change_log_temp -- TEMPORARY TABLE!!!
                              where exchange_status = ls_stale); -- STALE

                         li_number_rows_moved := sql%rowcount;
                         ksbms_util.p_log (
                               'Moved ' -- Since we're deleting them shortly
            || to_char (li_number_rows_moved)
            || ' STALE records into the change log archive, with exchange status STALE'
         );
      exception
         when others
         then
            p_sql_error ('Inserting CANSYS change log records with exchange_status STALE into the change log archive');
      end;

      -- Preserve this, so we can determine whether we actually moved any rows, below
      ll_nrows := li_number_rows_moved;

      -- Second SUPERSEDED
      begin
         -- Move the records that were marked as SUPERSEDED by the merge process
         insert into ds_change_log_archive
            -- Take all the SUPERSEDED records from the TEMP table
            (select entry_id,
                    sequence_num,
                    gs_job_id, -- Global set in f_update_pontis()
                    -- NVL() because these columns are all NOT NULL
                    nvl (schema, '*'),
                    nvl (exchange_rule_id, -1),
                    nvl (exchange_type, '*'),
                    nvl (old_value, '*'),
                    nvl (new_value, '*'),
                    nvl (exchange_status, '*'),
                    sysdate, -- Per Allen's 3/13/2002 e-mail
                                    createuserid,
                                    remarks -- Preserve the original remarks?
                               from ds_change_log_temp -- TEMPORARY TABLE!!!
                              where exchange_status = ls_superseded); -- SUPERSEDED

                         li_number_rows_moved := sql%rowcount;
                         ksbms_util.p_log (
                               'Moved ' -- Since we're deleting them shortly
            || to_char (li_number_rows_moved)
            || ' SUPERSEDED records into the change log archive, with exchange status SUPERSEDED'
         );
      exception
         when others
         then
            p_sql_error ('Inserting CANSYS change log records with exchange_status SUPERSEDED into the change log archive');
      end;

      -- Move the corresponding KEYVALS (for both STALE and SUPERSEDED) records into the archive
      li_number_rows_moved :=   li_number_rows_moved
                              + ll_nrows; -- Latter preserved after INSERTing STALE records

      if li_number_rows_moved > 0
      then
         begin
            insert into ds_lookup_keyvals_archive
               (select entry_id,
                       keyvalue,
                       key_sequence_num,
                       createdatetime,
                       createuserid
                  from ds_lookup_keyvals_temp -- TEMP version!
                 where entry_id in (select entry_id
                                      from ds_change_log_temp
                                     where exchange_status = ls_stale
                                        or exchange_status = ls_superseded));

            ll_nrows := sql%rowcount;

            if ll_nrows = 0
            then
               raise no_data_affected;
            end if;

            ksbms_util.p_log (
                  'Inserted '
               || to_char (ll_nrows)
               || ' records with ds_change_log_temp.exchange_status STALE or SUPERSEDED into the key values archive'
            );
         exception
            when no_data_affected
            then
               p_sql_error ('No TEMP key values records inserted into the archive!');
            when others
            then
               p_sql_error ('Inserting TEMP key value records into the archive');
         end;
      end if;

      -- Delete all the STALE and SUPERSEDED records from ds_change_log_temp;
      -- Referential integrity will take care of the keyvals records.
      begin
         delete from ds_change_log_temp
               where exchange_status = ls_stale
                  or exchange_status = ls_superseded;
      exception
         when others
         then
            p_sql_error ('Failed to DELETE the STALE and SUPERSEDED records from TEMP');
      end;

      -- Sanity check: At this point, the temp table should be empty?
      if ksbms_util.f_any_rows_exist ('ds_change_log_temp', '')
      then
         p_bug ('There are still rows in ds_change_log_temp after moving STALE and SUPERSEDED!');
      end if;

      -- The equivalent functions for moving items from the CANSYS
      -- change log have to be in their own function, so they can
      -- be a separate transaction.

      -- Do a COMMIT first!
      begin
         commit;
      exception
         when others
         then
            p_sql_error ('COMMITing before moving CANSYS change log items to the archive');
      end;

      -- This function call puts APPLIED records from ds_change_log_archive
      -- into ds_change_log_c, so we can test the f_archive_cansys_applied()
      -- function that is immediately below. THIS IS DEVELOPMENT ONLY!
      if lb_move_applied_2_change_log_c
      then
         p_log ('In development mode! Calling f_move_applied_from_archive()!');

         if f_move_applied_from_archive ()
         then
            p_bug ('f_move_applied_from_archive() failed');
         end if;
      end if;

      -- Move the CANSYS APPLIED
      if f_archive_cansys_applied ()
      then
         exit; -- Failed
      end if;

      Hoyt 08/08/2002 End of commented-out block */

      -------------------
      -- Success exit
      -------------------
      -- commit now
      --                  COMMIT;
      lb_failed := FALSE; -- Success

      EXIT do_once; -- Done!
    END LOOP do_once;

    -- Allen Marshall, CS - 2003.04.08 use the function ....
    -- pass success or failure depending how we got out of the DO_ONCE LOOP

    -- Save the changes (or not)
    lb_failed := f_commit_or_rollback(lb_failed, ls_context );
    -----------------------------------------------------------------
    -- This exception handler surrounds ALL the code in this function
    -----------------------------------------------------------------
  EXCEPTION
    WHEN OTHERS THEN
      lb_failed := TRUE; -- Just to be sure
      pl('li_where_count is ' || TO_CHAR(pio_where_count));
      ksbms_util.p_clean_up_after_raise_error(ls_context);
  END outer_exception_block; -- This ends the anonymous block created just to have the error handler

  /* Hoyt 08/07/2002 Moved to f_update_pontis()

  -- Note the results in the log
  p_log (   to_char (li_updated_count)
         || ' Pontis records were UPDATEd');
  p_log (   to_char (li_update_failed_count)
         || ' Pontis records had updates FAIL');
  p_log (   to_char (li_bridge_inserts)
         || ' BRIDGE and USERBRDG records were inserted');
  p_log (   to_char (li_inspevnt_inserts)
         || ' INSPEVNT and USERINSP records were inserted');
  p_log (   to_char (li_structure_unit_inserts)
         || ' STRUCTURE_UNIT and USERSTRUNIT records were inserted');
  p_log (   to_char (li_roadway_inserts)
         || ' ROADWAY and USERRWAY records were inserted');
  */
  -- Return the number updated to the calling routine
  -- Hoyt 08/08/2002 This is accumulated "in line" now
  -- pio_number_updated := li_updated_count;
  -- Return the number inserted to the calling routine
  -- Hoyt 08/08/2002 Added "io_number_inserted + " so it accumulates
  pio_number_inserted := pio_number_inserted + li_bridge_inserts +
                         li_inspevnt_inserts + li_structure_unit_inserts +
                         li_roadway_inserts;
  -- Hoyt 08/08/2002 Added "pio_number_failed + " so it accumulates
  pio_number_failed := pio_number_failed + li_update_failed_count;

  -- Clean up
  ksbms_util.p_pop(ls_context);
  -- Save the changes (or not)
  -- Hoyt 08/08/2002 Don't commit here!
    -- return f_commit_or_rollback (lb_failed, ls_context);
    -- Return the result (TRUE means the function failed)
    RETURN(lb_failed); -- Hoyt 08/08/2002
  END f_update_pontis_records;

  FUNCTION f_update_pontis(psi_job_id          IN ds_jobruns_history.job_id%TYPE,
                         pli_ora_dbms_job_id IN ds_jobruns_history.ora_dbms_job_id%TYPE,
                         psio_email_msg      IN ksbms_util.gs_email_msg%type)
                          RETURN BOOLEAN IS
  lb_failed           BOOLEAN := TRUE; -- Until we actually succeed
  lb_insert_succeeded BOOLEAN := FALSE; -- Whether INSERT worked
  lb_running_locally  BOOLEAN := TRUE; -- FALSE in production!
  ls_context          ksbms_util.context_string_type := 'f_update_pontis()';
  -- Local variables
  ls_number_deleted  PLS_INTEGER := 0;
  ls_number_inserted PLS_INTEGER := 0;
  ls_number_failed   PLS_INTEGER := 0;
  ls_number_updated  PLS_INTEGER := 0;
  -- Hoyt 08/09/2002 Track these too
  li_number_deletes_failed PLS_INTEGER := 0;
  li_number_inserts_failed PLS_INTEGER := 0;
  ls_apply_job_id          VARCHAR2(32);
  ls_final_job_status      ds_jobruns_history.job_status%TYPE;
  ls_final_job_status_desc VARCHAR2(20);
  /* ARM 3/6/2002 - trap errors better */
  ll_nrows    PLS_INTEGER;
  lb_sqlerror BOOLEAN;
  -- Hoyt 08/08/2002
  li_where_count PLS_INTEGER := 0;
  -- Hoyt 08/08/2002 Moved here from f_update_pontis_records()
  -- Set to FALSE to avoid deleting ds_change_log ds_lookup_keyvals records during development
  lb_deleting_applied_records BOOLEAN := TRUE; -- TRUE in production
  li_number_rows_moved        PLS_INTEGER;
  -- Set to TRUE to copy APPLIED records from the archive to ds_change_log_c,
  -- to test whether the ds_change_log_c to archive move works properly
  lb_move_applied_2_change_log_c BOOLEAN := FALSE; -- FALSE in production
BEGIN
  ksbms_util.p_push(ls_context);

  -- This anonymous block is for the sole purpose of providing a
  -- catch-all exception block... so raising an exception anywhere
  -- in the do-once loop below will be "handled" by the block's
    -- exception handler.
    <<outer_exception_block>>
    BEGIN
    -- So other functions can apply this without passing it! (bad form)
    gs_job_id := psi_job_id;

    -- Loop allows exit on failure
    <<do_once>>
    LOOP
    -- Insert job_status = 'AC' (Applying Changes) so update triggers fail
    BEGIN
    -- ARM 3/6/2002 this is wrong - we have an ID for the job run record already in the parms
    --ls_apply_job_id := ksbms_util.f_get_entry_id; -- So we can re-use it to update the row when we're done

        -- Hoyt 02/27/2002 First attempt to UPDATE the jobruns, for this psi_job_id

        UPDATE ds_jobruns_history
           SET --job_id = psi_job_id,- ARM 3/6/2002 this is wrong
               job_end_time = SYSDATE, -- Signal as to when THIS phase started!?
               job_status   = ls_job_applying_change,
               job_userid   = USER,
               remarks      = 'STARTING ''Apply Changes'' process'
         WHERE job_id = psi_job_id; -- ARM 3/6/2002 match on JOB_ID!!!!!!

        ll_nrows := SQL%ROWCOUNT;
        COMMIT;

        IF ll_nrows = 0 OR ll_nrows IS NULL THEN
          -- Hoyt 08/09/2002 While testing this package independently,
          -- this package might not be there, so no row is updated. Insert it!
          BEGIN
            INSERT INTO ds_jobruns_history
              (ora_dbms_job_id,
               job_start_time,
               job_end_time,
               job_status,
               job_userid,
               remarks,
               job_id)
            VALUES
              (1,
               SYSDATE,
               SYSDATE,
               ls_job_applying_change,
               USER,
               'STARTING ''Apply Changes'' process',
               psi_job_id);
            COMMIT;
          EXCEPTION
            WHEN OTHERS THEN
              BEGIN
                ROLLBACK;
                p_sql_error('Failed to INSERT  the initial job runs record!');
              END;
          END;
        END IF;

        -- Commit, so the triggers "see" the new job runs history record
        BEGIN
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            BEGIN
              ROLLBACK;
              p_sql_error('Failed to COMMIT after updating the initial job runs record!');
            END;
        END;
      EXCEPTION
        WHEN no_data_affected THEN
          BEGIN
            ROLLBACK;
            p_sql_error('Updating Job ID ' || psi_job_id ||
                        ' into Job Runs');
          END;
        WHEN OTHERS THEN
          BEGIN
            ROLLBACK;
            p_sql_error('Updating Job ID ' || psi_job_id ||
                        ' into Job Runs');
          END;
      END;

      -- Get the logging going
      p_log(psi_job_id, 'Starting logging in KSBMS_APPLY_CHANGES.f_update_pontis()');

      /*-- Add any message passed in to the accumulated email string
      IF LENGTH(psio_email_msg) > 0 THEN
        p_add_msg(psio_email_msg);
      END IF;*/

        -- Stamp run with package compile timestamp
        p_add_msg('KSBMS_APPLY_CHANGES: LAST_DDL_TIME: ' || TO_CHAR(gd_package_release_date,'YYYY-MM-DD HH:MI:SS') );
        -- Stamp run with package id:
        p_add_msg('KSBMS_APPLY_CHANGES: ID: ' || trim(gs_package_cvs_archive_id ));

      -- Helpful to the operator -- how long did it take
      -- (This is here so it gets logged, i.e. is after the p_log() call above).
        p_add_msg(ls_context ||
                ' inserted an ''AC'' (Applying Changes) job runs history record at ' ||
                ksbms_util.f_now);

      -- If we're running locally, copy the local "_c" data to the original
    -- versions, i.e. the test data is in "_c" and this function operates
    -- on ds_change_log and ds_lookup_keyvals (no "_c" extentions). This
    -- gives us a "fresh" copy of the data in the "_c" tables each time.
    /*          if lb_running_locally
              then
                 -- INSERT from the CANSYS "stand-in" tables into the Pontis tables
                 begin
                    delete from ds_change_log;

                    delete from ds_lookup_keyvals;

                    insert into ds_change_log
                       select *
                         from ds_change_log_c;

                    insert into ds_lookup_keyvals
                       select *
                         from ds_lookup_keyvals_c;
                 exception
                    when others
                    then
                       p_sql_error ('Failure inserting data into "_C" tables!');
                 end;

                 -- Update the "CANSYS change log" to look the way we're expecting
                     begin
                        update ds_change_log
                           set precedence = 'FC', -- From CANSYS
                               exchange_status = ls_merge_ready; -- Merge done, really
                     exception
                        when others
                        then
                           p_sql_error ('Failure UPDATING "_C" tables to "FC" (From CANSYS)!');
                     end;
                  end if; -- We are running locally (in test)
      */

      -- Get all the "ready" records From CANSYS (FC)
      FOR irow IN (SELECT *
                   FROM ds_change_log
                  WHERE exchange_status IN
                        ('MERGED', 'INSREADY', 'DELREADY', 'MSGREADY') -- Hoyt 08/06/2002 Moved this up from f_update_pontis_record() cursor SELECT
                        AND precedence = 'FC'
                  ORDER BY sequence_num) -- Hoyt 08/07/2002 Added order by sequence_num
     LOOP
      -- Hoyt 08/08/2002 Re-ordered so UPD is first (it's by far the most common)
      IF irow.exchange_type = 'UPD' THEN
        BEGIN
          -- Third, the UPDATEs
          IF f_update_pontis_records(irow.entry_id,
                                     ls_number_updated,
                                     ls_number_inserted,
                                     ls_number_failed,
                                     li_number_deletes_failed,
                                     li_where_count) THEN

            EXIT; -- Failed
          END IF;
        END;
      ELSIF irow.exchange_type = 'DEL' THEN
        BEGIN
          -- First handle all of the DELETEs, so subsequent INSERTs work
          IF f_delete_pontis_records(irow.entry_id, ls_number_deleted) THEN
            EXIT; -- Failed
          END IF;
        END;

        IF ls_number_deleted = 0 THEN
          -- How many attempted deletes failed?
          li_number_deletes_failed := li_number_deletes_failed + 1;
        END IF;
      ELSIF irow.exchange_type = 'INS' THEN
        BEGIN
          /* Save this in case we want the functionality someday
          -- Second, the INSERTs, so subsequent UPDATEs work
          */
          IF f_insert_pontis_records(irow.entry_id, ls_number_inserted) THEN
            EXIT; -- Failed
          END IF;
          /*   NULL; */
        END;
      ELSIF irow.exchange_type = 'MSG' THEN
        BEGIN
          p_add_msg('Change Log Message: ' || irow.new_value);
        END;
      ELSE
        -- bad bad bad bad - cannot happen
        lb_failed := TRUE;
        EXIT do_once; -- Done!
      END IF;
    END LOOP;

    -- Hoyt 3/18/2002
    -- In production, we move the successfully-applied records from the
    -- change log to the archive, with exchange_status = 'APPLIED'. This
    -- occurs inside this 'if lb_deleting_applied_records' block because
    -- sometimes, during development, it's convenient to leave the records
      -- in ds_change_log for subsequent re-application... and the INSERTs
      -- below will fail with duplicate keys if the move-to-archive is done.
       --

      IF lb_deleting_applied_records -- In production, always!
       THEN
        -- Hoyt 03/18/2002 Move all the '<DELETE>' records into the archive
        BEGIN
        p_log('In '|| ls_context||', now deleting APPLIED records marked as '||ls_delete||' from ds_change_log...');
        -- Move the records that were successfully applied
        -- and so marked <DELETE> in the loop above
        p_log('Moving records to archive...');
        INSERT INTO ds_change_log_archive
         -- Take the records from Pontis's ds_change_log
      (SELECT entry_id,
    sequence_num,
    gs_job_id, -- Global set in f_update_pontis()
    ls_cansys_schema, -- NVL() because these columns are all NOT NULL
    NVL(exchange_rule_id, -1),
    NVL(exchange_type, '*'),
    NVL(old_value, '*'),
    NVL(new_value, '*'),
    NVL(exchange_status, '*'), -- ARM 2003.04.07 updated slightly here to track original EXCHANGE_STATUS better
    SYSDATE, -- Per Allen's 3/13/2002 e-mail
                  createuserid,
                  remarks ||
                  nvl(exchange_status,
                      '  - ARCHIVED RECORD WITH UNKNOWN STATUS') -- Preserve the original remarks?
            -- ARM 2003.04.07 updated slightly here to track original EXCHANGE_STATUS better
             FROM ds_change_log -- Pontis version!
            WHERE exchange_status = ls_delete OR
                  exchange_status = ls_insert_ready); -- These are the successfully-applied records
        -- Allen Marshall, CS  - 2003.04.02 - allowed INSREADY records to goto the archive
--        COMMIT;    -- This commit commented out for 9i
        li_number_rows_moved := SQL%ROWCOUNT;
        ksbms_util.p_log('Moved ' -- Since we're deleting them shortly
                       || TO_CHAR(li_number_rows_moved) ||
                       ' CANSYS (originally) change log records from the Pontis change log into the change log archive, with exchange status APPLIED');
        COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        p_sql_error('Inserting CANSYS change log records with exchange_status APPLIED into the change log archive');
    END;

    -- Move the corresponding CANSYS KEYVALS records into the archive
    IF li_number_rows_moved > 0 THEN
      BEGIN
        INSERT INTO ds_lookup_keyvals_archive
          (SELECT entry_id,
                  keyvalue,
                  key_sequence_num,
                  createdatetime,
                  createuserid
             FROM ds_lookup_keyvals -- Pontis version!
            WHERE entry_id IN
                  (SELECT entry_id
                     FROM ds_change_log
                    WHERE exchange_status = ls_delete));
--        COMMIT;    -- This commit commented out for 9i
        ll_nrows := SQL%ROWCOUNT;

        IF ll_nrows = 0 THEN
          RAISE no_data_affected;
        END IF;

        ksbms_util.p_log('Inserted ' || TO_CHAR(ll_nrows) ||
                         ' CANSYS records with ds_change_log.exchange_status APPLIED into the key values archive');
        COMMIT;
      EXCEPTION
        WHEN no_data_affected THEN
          p_sql_error('No CANSYS key values records inserted into the archive!');
        WHEN OTHERS THEN
          p_sql_error('Inserting CANSYS key value records into the archive');
      END;
    END IF;

    -- Delete all the <DELETE> records from ds_change_log;
    -- Referential integrity will take care of the keyvals records
    BEGIN
        p_log('In '|| ls_context||', deleting DS_CHANGE_LOG entries...');

      DELETE FROM ds_change_log WHERE exchange_status = ls_delete;
    EXCEPTION
      WHEN OTHERS THEN
        p_sql_error('Failed to DELETE the <DELETE> records from ds_change_log');
    END;
  ELSE
    -- Note it, so we don't accidentally leave lb_deleting_applied_records FALSE
        p_log('DEVELOPMENT MODE! Applied change log records were not deleted!');
      END IF;

      -- Hoyt 08/08/2002 Moved all this here from f_update_pontis_record()

      -- Hoyt 03/18/2002
      -- Move the STALE and SUPERSEDED records from the temp table into the archive.
      -- This is the set of records that were Pontis or CANSYS UPDates, but were
      -- not applied because they were either (1) too old (STALE) or (2) created by
      -- one system but the other system changed the same datum and the other system
      -- has precedence (SUPERSEDED). Do it in two steps, so we can differentiate
      -- the STALE count from the SUPERSEDED count.
      --
      -- First STALE
      BEGIN
        -- Move the records that were marked as STALE by the merge process
        INSERT INTO ds_change_log_archive
       -- Take all the STALE records from the TEMP table
        (SELECT entry_id,
      sequence_num,
      gs_job_id, -- Global set in f_update_pontis()
       -- NVL() because these columns are all NOT NULL
      NVL(SCHEMA, '*'),
      NVL(exchange_rule_id, -1),
      NVL(exchange_type, '*'),
      NVL(old_value, '*'),
      NVL(new_value, '*'),
      NVL(exchange_status, '*'),
      SYSDATE, -- Per Allen's 3/13/2002 e-mail
              createuserid,
              remarks -- Preserve the original remarks?
         FROM ds_change_log_temp -- TEMPORARY TABLE!!!
        WHERE exchange_status = ls_stale); -- STALE
--    COMMIT;    -- This commit commented out for 9i
    li_number_rows_moved := SQL%ROWCOUNT;
    ksbms_util.p_log('Moved ' -- Since we're deleting them shortly
                         || TO_CHAR(li_number_rows_moved) ||
                         ' STALE records into the change log archive, with exchange status STALE');
          COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          p_sql_error('Inserting CANSYS change log records with exchange_status STALE into the change log archive');
      END;

      -- Preserve this, so we can determine whether we actually moved any rows, below
      ll_nrows := li_number_rows_moved;

      -- Second SUPERSEDED
      BEGIN
        -- Move the records that were marked as SUPERSEDED by the merge process
        INSERT INTO ds_change_log_archive
       -- Take all the SUPERSEDED records from the TEMP table
        (SELECT entry_id,
      sequence_num,
      gs_job_id, -- Global set in f_update_pontis()
       -- NVL() because these columns are all NOT NULL
      NVL(SCHEMA, '*'),
      NVL(exchange_rule_id, -1),
      NVL(exchange_type, '*'),
      NVL(old_value, '*'),
      NVL(new_value, '*'),
      NVL(exchange_status, '*'),
      SYSDATE, -- Per Allen's 3/13/2002 e-mail
              createuserid,
              remarks -- Preserve the original remarks?
         FROM ds_change_log_temp -- TEMPORARY TABLE!!!
        WHERE exchange_status = ls_superseded); -- SUPERSEDED
--    COMMIT;    -- This commit commented out for 9i
    li_number_rows_moved := SQL%ROWCOUNT;
    ksbms_util.p_log('Moved ' -- Since we're deleting them shortly
                         || TO_CHAR(li_number_rows_moved) ||
                         ' SUPERSEDED records into the change log archive, with exchange status SUPERSEDED');
    COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          p_sql_error('Inserting CANSYS change log records with exchange_status SUPERSEDED into the change log archive');
      END;

      -- Move the corresponding KEYVALS (for both STALE and SUPERSEDED) records into the archive
      li_number_rows_moved := li_number_rows_moved + ll_nrows; -- Latter preserved after INSERTing STALE records

      IF li_number_rows_moved > 0 THEN
        BEGIN
          INSERT INTO ds_lookup_keyvals_archive
            (SELECT entry_id,
                    keyvalue,
                    key_sequence_num,
                    createdatetime,
                    createuserid
               FROM ds_lookup_keyvals_temp -- TEMP version!
              WHERE entry_id IN
                    (SELECT entry_id
                       FROM ds_change_log_temp
                      WHERE exchange_status = ls_stale OR
                            exchange_status = ls_superseded));
--          COMMIT;    -- This commit commented out for 9i
          ll_nrows := SQL%ROWCOUNT;

          IF ll_nrows = 0 THEN
            RAISE no_data_affected;
          END IF;

          ksbms_util.p_log('Inserted ' || TO_CHAR(ll_nrows) ||
                           ' records with ds_change_log_temp.exchange_status STALE or SUPERSEDED into the key values archive');
          COMMIT;
        EXCEPTION
          WHEN no_data_affected THEN
            p_sql_error('No TEMP key values records inserted into the archive!');
          WHEN OTHERS THEN
            p_sql_error('Inserting TEMP key value records into the archive');
        END;
      END IF;

      -- Delete all the STALE and SUPERSEDED records from ds_change_log_temp;
      -- Referential integrity will take care of the keyvals records.
      BEGIN
        DELETE FROM ds_change_log_temp
         WHERE exchange_status = ls_stale OR
               exchange_status = ls_superseded;
      EXCEPTION
        WHEN OTHERS THEN
          p_sql_error('Failed to DELETE the STALE and SUPERSEDED records from TEMP');
      END;

      -- Sanity check: At this point, the temp table should be empty?
      IF ksbms_util.f_any_rows_exist('ds_change_log_temp', '') THEN
        p_bug('There are still rows in ds_change_log_temp after moving STALE and SUPERSEDED!');
      END IF;

      -- The equivalent functions for moving items from the CANSYS
      -- change log have to be in their own function, so they can
      -- be a separate transaction.

      -- Do a COMMIT first!
      BEGIN
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          p_sql_error('COMMITing before moving CANSYS change log items to the archive');
      END;

      -- This function call puts APPLIED records from ds_change_log_archive
      -- into ds_change_log_c, so we can test the f_archive_cansys_applied()
      -- function that is immediately below. THIS IS DEVELOPMENT ONLY!
      IF lb_move_applied_2_change_log_c THEN
        p_log('In development mode! Calling f_move_applied_from_archive()!');

        IF f_move_applied_from_archive() THEN
          p_bug('f_move_applied_from_archive() failed');
        END IF;
      END IF;

      p_log('In '|| ls_context||', now archiving CANSYS APPLIED records...');

      -- Move the CANSYS APPLIED
      IF f_archive_cansys_applied() THEN
        EXIT; -- Failed
      END IF;

      -------------------
      -- Success exit
      -------------------

      p_add_msg(TO_CHAR(ls_number_deleted) || ' records were deleted.');
      p_add_msg(TO_CHAR(ls_number_inserted) || ' records were inserted.');
      p_add_msg(TO_CHAR(ls_number_updated) || ' records were updated.');
      p_add_msg(TO_CHAR(ls_number_failed) || ' updates failed.');
      -- Hoyt 08/09/2002 Track these too
      p_add_msg(TO_CHAR(li_number_deletes_failed) ||
                ' attempts to delete records failed');
      p_add_msg(TO_CHAR(li_number_inserts_failed) ||
                ' attempts to insert records failed');
      lb_failed := FALSE;
      EXIT do_once; -- Done!
    END LOOP do_once;
    -----------------------------------------------------------------
    -- This exception handler surrounds ALL the code in this function
    -----------------------------------------------------------------
  EXCEPTION
    WHEN OTHERS THEN
      -- If we failed, then clear the flag so Pontis can run!
      -- Update the job runs history to signify that these "jobs" are done
      BEGIN
        UPDATE ds_jobruns_history
           SET ds_jobruns_history.remarks       = 'FAILED',
               ds_jobruns_history.job_status    = 'CF', -- Changes failed
               ds_jobruns_history.job_end_time  = SYSDATE,
               ds_jobruns_history.job_processid = USER
         WHERE ds_jobruns_history.job_id = psi_job_id;
--        COMMIT;    -- This commit commented out for 9i
        ll_nrows := SQL%ROWCOUNT;

        /* ARM 3/6/2002  Always test result right after the SQL fires, store in a variable*/

        -- We better have updated exactly one record
        IF ll_nrows <> 1 THEN
          p_add_msg('In failure block at bottom, expected to set ONE job runs record to ''CF'', but instead set ' ||
                    TO_CHAR(ll_nrows));
          RAISE TOO_MANY_ROWS;
        END IF;

        IF ll_nrows = 0 THEN
          p_add_msg('In failure block at bottom, expected to set ONE job runs record to ''CF'', but instead set ' ||
                    TO_CHAR(ll_nrows));
          RAISE no_data_affected;
        END IF;

        COMMIT; -- So the change is "seen" by Pontis
      EXCEPTION
        /* ARM 3/6/2002 */
        WHEN TOO_MANY_ROWS THEN
          BEGIN
            ROLLBACK;
            p_sql_error2('Multiple jobrun history rows found in ds_jobruns_history for job ID = [ ' ||
                         psi_job_id ||
                         ' ] while updating job runs to Change Failed in failure block');
          END;
        WHEN no_data_affected THEN
          BEGIN
            ROLLBACK;

            -- This HAS to be there!
            p_sql_error2('No data found while updating job runs to Change Failed in failure block');
          END;
        WHEN OTHERS THEN
          BEGIN
            ROLLBACK;
            p_sql_error2('Unknown error updating job runs to Change Failed in failure block');
          END;
      END;

      lb_failed := TRUE; -- Just to be sure
      ksbms_util.p_clean_up_after_raise_error(ls_context);
  END outer_exception_block; -- This ends the anonymous block created just to have the error handler

  -- Save the changes (or not)

  lb_failed := f_commit_or_rollback(lb_failed, ls_context);

  -- 1/10/2002
  -- Make sure there's no 'AC' row in the job runs history table,
    -- else triggers will fire without anything being saved!
    -- The WHERE ignores the job ID because we want to override any left-over 'AC's at this point
    IF lb_failed THEN
      ls_final_job_status      := ls_job_changes_failed; -- 'CF'-> 'Changes Failed'
      ls_final_job_status_desc := 'Changes Failed';
    ELSE
      ls_final_job_status      := ls_job_done_changing; -- 'DC' -> 'Done Changing'
      ls_final_job_status_desc := 'Changes Done';
    END IF;

    BEGIN
      UPDATE ds_jobruns_history
       -- 'CF' or 'DC' ('Changes Failed' or 'Done Changing')
         SET job_status = ls_final_job_status
       WHERE job_status = ls_job_applying_change; --  magic string 'AC'

      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        BEGIN
          ROLLBACK;
          -- This will NOT raise an exception
          p_sql_error2('After SUCCESS, could not clear the ''AC'' (Applying Changes) from job runs history!');
        END;
    END;

    -- Done-done!
    p_add_msg(ls_context || ' for Job ID ' || psi_job_id ||
              ' completed running at ' ||
              ksbms_util.f_now );
    p_add_msg( 'Final job status: ''' || ls_final_job_status || ''' (' ||
              ls_final_job_status_desc || ')' );

    -- If there was any SQL error, return that
    IF LENGTH(ksbms_util.f_get_sql_error) > 0 THEN
      p_add_msg(ksbms_util.f_get_sql_error);
    END IF;

    -- Log the final e-mail message
    p_log(ksbms_util.f_get_email_msg);
    ksbms_util.p_pop(ls_context);
    -- Return the result (TRUE means the function failed)
    RETURN(lb_failed);
  END f_update_pontis; -- CHANGETHIS

  ----------------------------------------
  -- Supporting functions
  ----------------------------------------

  -- This returns the STRUNITKEY (as a varchar2)
  -- that corresponds to the passed brkey and strunitlabel.
  -- f_strunitlabel_to_strunitkey() returns NULL if the
  -- brkey || strunitlabel to not correspond to a structure_unit record.

  FUNCTION f_strunitlabel_to_strunitkey(psi_brkey        IN structure_unit.brkey%TYPE,
                                      psi_strunitlabel IN structure_unit.strunitlabel%TYPE)
  RETURN VARCHAR2 IS
  li_strunitkey structure_unit.strunitkey%TYPE;
  brkey_is_null EXCEPTION;
  strunitlabel_is_null EXCEPTION;
  lb_showing_bugs BOOLEAN := FALSE;
BEGIN
  -- The arguments cannot be NULL
  IF psi_brkey IS NULL THEN
    RAISE brkey_is_null;
  END IF;

  IF psi_strunitlabel IS NULL THEN
    RAISE strunitlabel_is_null;
  END IF;

  -- Get the corresponding strunitkey (if any)
  BEGIN
  SELECT strunitkey
    INTO li_strunitkey
    FROM structure_unit
   WHERE brkey = psi_brkey AND strunitlabel = psi_strunitlabel;

  -- Done!
  -- This is returned as a string because that's what the calling routine needs
      RETURN TO_CHAR(li_strunitkey);
    EXCEPTION
      WHEN brkey_is_null THEN
        p_bug('NULL BRKEY passed to f_strunitlabel_to_strunitkey()');
        RETURN NULL;
      WHEN strunitlabel_is_null THEN
        p_bug('NULL STRUNITLABEL passed to f_strunitlabel_to_strunitkey()');
        RETURN NULL;
      WHEN NO_DATA_FOUND THEN
        -- This is mostly turned off, because it happens routinely with new structure_units
        IF lb_showing_bugs THEN
          p_bug('Failed to find a STRUCTURE_UNIT record corresponding to BRKEY ' ||
                psi_brkey || ' and STRUNITLABEL ' || psi_strunitlabel);
        END IF;

        RETURN NULL;
    END;
  END f_strunitlabel_to_strunitkey;

  FUNCTION f_kdot_bridge_id_to_brkey(p_bridge_id IN VARCHAR2)
   -- This takes '0001-B0008' and returns '001008',
   -- which is the apparent algorithm that KDOT uses to go between
   -- bridge_id (the first string) and brkey and struct_num (the
   -- second string -- brkey and struct_num are everywhere the same
   -- in the KDOT database).
   RETURN VARCHAR2 IS
    ls_brkey VARCHAR2(6);
    bridge_id_is_null EXCEPTION;
    bridge_id_is_not_ten_chars EXCEPTION;
  BEGIN
    -- It cannot be NULL
    IF p_bridge_id IS NULL THEN
      RAISE bridge_id_is_null;
    END IF;

    -- It has to be 10 characters (or our algorithm is suspect)
    -- Let length=6 go through, it case it is a valid BRKEY already
    IF LENGTH(p_bridge_id) <> 10 AND LENGTH(p_bridge_id) <> 6 THEN
      RAISE bridge_id_is_not_ten_chars;
    END IF;

    -- NO NO NO Cannot do this! The database is mutating in the triggers when we call f_is_brkey()!
    -- If it is a valid BRKEY
    -- (i.e. BRKEY = BRIDGE_ID, which it WILL be if the structure was added on the Pontis side)
    -- then simply return the BRKEY
    -- if ksbms_util.f_is_brkey( p_bridge_id )
    -- then
    --     return p_bridge_id;
    -- end if;

    -- Extract the brkey (and struct_num, which is the same)
    --             1234567890
    -- This takes '0001-B0008' and returns '001008',
    --              123   123
    ls_brkey := SUBSTR(p_bridge_id, 2, 3) || SUBSTR(p_bridge_id, 8, 3);
    -- Done!
    RETURN ls_brkey;
  EXCEPTION
    WHEN bridge_id_is_null THEN
      p_bug('NULL bridge ID passed to f_kdot_bridge_id_to_brkey()');
      RETURN NULL;
    WHEN bridge_id_is_not_ten_chars THEN
      p_bug('Bridge ID passed to f_kdot_bridge_id_to_brkey() doesn''t have 10 characters!' ||
            gs_crlf || gs_crlf || 'The bridge_id is ''' || p_bridge_id ||
            ''' AND it''s length is ' || TO_CHAR(LENGTH(p_bridge_id)));
      RETURN NULL;
  END f_kdot_bridge_id_to_brkey;

  -- The opposite of f_kdot_bridge_id_to_brkey
  FUNCTION f_kdot_brkey_to_bridge_id(p_brkey IN VARCHAR2)
   -- This takes '001008' and returns'0001-B0008',
   RETURN VARCHAR2 IS
    ls_bridge_id VARCHAR2(10);
    brkey_is_null EXCEPTION;
    brkey_is_not_six_chars EXCEPTION;
  BEGIN
    -- It cannot be NULL
    IF p_brkey IS NULL THEN
      RAISE brkey_is_null;
    END IF;

    -- It has to be 6 characters (or our algorithm is suspect)
    IF LENGTH(p_brkey) <> 6 THEN
      RAISE brkey_is_not_six_chars;
    END IF;

    -- Extract the brkey (and struct_num, which is the same)
    --             1234567890
    -- This takes '0001-B0008' and returns '001008',
    --              123   123
    ls_bridge_id := '0' || SUBSTR(p_brkey, 1, 3) || '-B0' ||
                    SUBSTR(p_brkey, 4, 3);
    -- Done!
    RETURN ls_bridge_id;
  EXCEPTION
    WHEN brkey_is_null THEN
      p_sql_error('NULL BRKEY passed to f_kdot_brkey_to_bridge_id()');
    WHEN brkey_is_not_six_chars THEN
      p_sql_error('BRKEY passed to f_kdot_brkey_to_bridge_id() doesn''t have 6 characters!' ||
                  gs_crlf || gs_crlf || 'The BRKEY is ''' || p_brkey ||
                  ''' AND it''s length is ' || TO_CHAR(LENGTH(p_brkey)));
  END f_kdot_brkey_to_bridge_id;

  -- This function attempts to replicate how Pontis sets new structure data;
  -- the reference script it w_insp_create_structure.uoe_genrequiredcolumns.
  --
  -- f_set_new_structure_data() does a commit!
  FUNCTION f_set_new_structure_data(psi_brkey IN bridge.brkey%TYPE)
    RETURN BOOLEAN IS
    lb_failed   BOOLEAN := TRUE;
    ls_context  ksbms_util.context_string_type := 'f_set_new_structure_data()';
    ls_coption  coptions.optionval%TYPE;
    ls_string   VARCHAR2(2000); -- General-purpose
    ls_on_under roadway.on_under%TYPE;
  BEGIN
    ksbms_util.p_push(ls_context);

    <<outer_exception_block>>
    BEGIN

      -- Loop allows exit on failure
      <<do_once>>
      LOOP
        -- FIPS_STATE
        ls_coption := ksbms_pontis_util.f_get_pontis_coption_value('DEFAULTSTATE');

        IF f_ns(ls_coption) THEN
          RAISE ksbms_util.generic_exception;
        END IF;

        IF ksbms_pontis_util.f_set_bridge_value(psi_brkey,
                                                'fips_state',
                                                ls_coption) THEN
          EXIT;
        END IF;

        -- FHWA_REGN
        ls_coption := ksbms_pontis_util.f_get_pontis_coption_value('DEFAULTREGION');

        -- '-1' appears in COPTIONS but cannot be the default because FHWA_REGN
        -- is only one character wide... so the underscore is used instead.
        IF f_ns(ls_coption) OR ls_coption = '-1' THEN
          ls_coption := '_';
        END IF;

        IF ksbms_pontis_util.f_set_bridge_value(psi_brkey,
                                                'fhwa_regn',
                                                ls_coption) THEN
          EXIT;
        END IF;

        -- MAINSPANS
        IF ksbms_pontis_util.f_set_bridge_value(psi_brkey, 'mainspans', '1') THEN
          EXIT;
        END IF;

        -- APPSPANS
        IF ksbms_pontis_util.f_set_bridge_value(psi_brkey, 'appspans', '0') THEN
          EXIT;
        END IF;

        -- LATITUDE
        IF ksbms_pontis_util.f_set_bridge_value(psi_brkey,
                                                'latitude',
                                                '-910000.00') THEN
          EXIT;
        END IF;

        -- LONGITUDE
        IF ksbms_pontis_util.f_set_bridge_value(psi_brkey,
                                                'longitude',
                                                '-1810000.00') THEN
          EXIT;
        END IF;

        -- NAV VERT CLR -- added by dk 9/17/2009
        IF ksbms_pontis_util.f_set_bridge_value(psi_brkey,
                                                'navvc',
                                                '0.0') THEN
          EXIT;
        END IF;
    
        -- NAV HORIZONTAL CLR -- added  by dk 9/17/2009
        IF ksbms_pontis_util.f_set_bridge_value(psi_brkey,
                                                'navhc',
                                                '0.0') THEN
          EXIT;
        END IF; 
        
        -- NBI 37 historical significance..always a '5' for new bridges -- added by dk 10/30/2009
        IF ksbms_pontis_util.f_set_bridge_value(psi_brkey,
                                                'histsign',
                                                '5') THEN
          EXIT;
        END IF;
        
        -- YEARBUILT
        -- Effectively, set to missing
        -- per Deb Kossler, KDOT - 12.19.2002
        -- FIXUP!!
        --Allen R. Marshall, CS - 2002.12.2002
        IF ksbms_pontis_util.f_set_bridge_value(psi_brkey,
                                                'yearbuilt',
                                                '1000' -- just before William the Conqueror invaded Britain for the Battle of Hastings in 1066
                                                 /*                                                      TO_CHAR (SYSDATE,
                                                                                                                                                                           'YYYY'
                                                                                                                                                                          )*/) THEN
          EXIT;
        END IF;

        -- NOTES
        ls_string := 'Bridge '
                     -- Bridge ID
                     || NVL(ksbms_pontis_util.f_get_bridge_id_from_brkey(psi_brkey),
                            psi_brkey) || ' entered ' || ksbms_util.f_now() ||
                     ' by userid ' || USER;

        -- Allen 12/;16/2002
        -- for really really new records, tag them as NEWUNINITIALIZEDKEYS through the NOTES field,
        -- this allows their match columns like KIND_HWY or ROUTE_PREFIX  on ROADWAY to be updated 1 time to good values, then prohibited forever.  Need for a new recor

        IF ksbms_pontis_util.f_set_bridge_value(psi_brkey,
                                                'notes',
                                                cs_uninitializedkeys ||
                                                ls_string) THEN
          EXIT;
        END IF;

        -- ORLOAD
        IF ksbms_pontis_util.f_set_bridge_value(psi_brkey, 'orload', '0.0') THEN
          EXIT;
        END IF;

        -- IRLOAD
        IF ksbms_pontis_util.f_set_bridge_value(psi_brkey, 'irload', '0.0') THEN
          EXIT;
        END IF;
        
        --TEMPSTRUC
        
        IF ksbms_pontis_util.f_set_bridge_value(psi_brkey,
                                                'tempstruc',
                                                '') THEN
          EXIT;
        END IF;
        
        -- TRUCK1OR
        IF ksbms_pontis_util.f_set_bridge_value(psi_brkey,
                                                'truck1or',
                                                '0.0') THEN
          EXIT;
        END IF;

        -- TRUCK1IR
        IF ksbms_pontis_util.f_set_bridge_value(psi_brkey,
                                                'truck1ir',
                                                '0.0') THEN
          EXIT;
        END IF;

        -- TRUCK2OR
        IF ksbms_pontis_util.f_set_bridge_value(psi_brkey,
                                                'truck2or',
                                                '0.0') THEN
          EXIT;
        END IF;

        -- TRUCK2IR
        IF ksbms_pontis_util.f_set_bridge_value(psi_brkey,
                                                'truck2ir',
                                                '0.0') THEN
          EXIT;
        END IF;

        -- TRUCK3OR
        IF ksbms_pontis_util.f_set_bridge_value(psi_brkey,
                                                'truck3or',
                                                '0.0') THEN
          EXIT;
        END IF;

        -- TRUCK3iR
        IF ksbms_pontis_util.f_set_bridge_value(psi_brkey,
                                                'truck3ir',
                                                '0.0') THEN
          EXIT;
        END IF;

        -- SRSTATUS
        IF ksbms_pontis_util.f_set_bridge_value(psi_brkey, 'srstatus', '1') THEN
          EXIT;
        END IF;

        -- LENGTH
        IF ksbms_pontis_util.f_set_bridge_value(psi_brkey, 'length', '0.0') THEN
          EXIT;
        END IF;

        -- TOT_LENGTH
        IF ksbms_pontis_util.f_set_bridge_value(psi_brkey,
                                                'tot_length',
                                                '0.0') THEN
          EXIT;
        END IF;

        -- MAXSPAN
        IF ksbms_pontis_util.f_set_bridge_value(psi_brkey, 'maxspan', '0.0') THEN
          EXIT;
        END IF;

        -- CREATEUSERKEY
        IF ksbms_pontis_util.f_set_bridge_value(psi_brkey,
                                                'createuserkey',
                                                ksbms_pontis_util.f_get_users_userkey()) THEN
          EXIT;
        END IF;

        -- CREATEDATETIME
        IF ksbms_pontis_util.f_set_bridge_value(psi_brkey,
                                                'createdatetime',
                                                TO_CHAR(SYSDATE,
                                                        'YYYY-MM-DD HH24:MI:SS')) THEN
          EXIT;
        END IF;

        -- MODTIME
        IF ksbms_pontis_util.f_set_bridge_value(psi_brkey,
                                                'modtime',
                                                TO_CHAR(SYSDATE,
                                                        'YYYY-MM-DD HH24:MI:SS')) THEN
          EXIT;
        END IF;

        -- USERKEY
        IF ksbms_pontis_util.f_set_bridge_value(psi_brkey,
                                                'userkey',
                                                ksbms_pontis_util.f_get_users_userkey()) THEN
          EXIT;
        END IF;

        -- NEXTINSPID
        IF ksbms_pontis_util.f_set_bridge_value(psi_brkey,
                                                'nextinspid',
                                                '1') THEN
          EXIT;
        END IF;

        -- BTRIGGER
        IF ksbms_pontis_util.f_set_bridge_value(psi_brkey, 'btrigger', 'N') THEN
          EXIT;
        END IF;
        
        -- placecode (added 2/7/06 by deb
        IF ksbms_pontis_util.f_set_bridge_value(psi_brkey, 'placecode', '00000') THEN
           EXIT;
        END IF;
        
        --nbislength( nbis bridge length) added 10/15/2009 by deb
        IF ksbms_pontis_util.f_set_bridge_value(psi_brkey, 'nbislen', 'Y') THEN
           EXIT;
        END IF;
        
        --lftcurbsw (to set default to zero when a bridge is built)
        IF ksbms_pontis_util.f_set_bridge_value(psi_brkey,'lftcurbsw','0.0') THEN
           EXIT;
        END IF;
        
        --rtcurbsw (to set default to zero when a bridge is built)
        IF ksbms_pontis_util.f_set_bridge_value(psi_brkey,'rtcurbsw','0.0') THEN
           EXIT;
        END IF;
        
         IF ksbms_pontis_util.f_set_bridge_value(psi_brkey,'vclrunder','0.0') THEN
           EXIT;
        END IF;
        
         IF ksbms_pontis_util.f_set_bridge_value(psi_brkey,'hclrurt','0.0') THEN
           EXIT;
        END IF;
        
         IF ksbms_pontis_util.f_set_bridge_value(psi_brkey,'hclrult','0.0') THEN
           EXIT;
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
      WHEN OTHERS THEN
        lb_failed := TRUE; -- Just to be sure
        ksbms_util.p_clean_up_after_raise_error(ls_context);
    END outer_exception_block; -- This ends the anonymous block created just to have the error handler

    ksbms_util.p_pop(ls_context);
    -- Save the changes (or not)
    RETURN f_commit_or_rollback(lb_failed, ls_context);
  END f_set_new_structure_data;

  -- Sets the initial value of INSPEVNT data per Pontis's practice
  FUNCTION f_set_new_inspevnt_data(psi_brkey   IN inspevnt.brkey%TYPE,
                                 psi_inspkey IN inspevnt.inspkey%TYPE)
  RETURN BOOLEAN IS
  lb_failed  BOOLEAN := TRUE;
  ls_context ksbms_util.context_string_type := 'f_set_new_inspevnt_data()';
  ls_coption coptions.optionval%TYPE;
  ls_string  VARCHAR2(2000); -- General-purpose
BEGIN
  ksbms_util.p_push(ls_context);

  <<outer_exception_block>>
  BEGIN

  -- Loop allows exit on failure
  <<do_once>>
  LOOP
  -- Various INSPEVNT data (per Pontis's w_insp_create_structure.uoe_genrequiredcolumns)

        /*  Allen Marshall, CS - 2002.12.19 - disabled this scaffolding stuff - was putting bogus OSLASTINSP into INSPEVNT
        -- HOYTFIX Remove for testing update trigger!
        */
        -- DEFAULTS REVISED 2002.12.19 by ARM in response to DEb Kossler Email
        -- OSLASTINSP
        IF ksbms_pontis_util.f_set_inspevnt_value(psi_brkey,
                                                  psi_inspkey,
                                                  'oslastinsp',
                                                  ksbms_pontis_util.f_return_missing_date_string) THEN
          EXIT;
        END IF;

        -- ELINSPDATE
        IF ksbms_pontis_util.f_set_inspevnt_value(psi_brkey,
                                                  psi_inspkey,
                                                  'elinspdate',
                                                  ksbms_pontis_util.f_return_missing_date_string) THEN
          EXIT;
        END IF;

        -- WILL BE KSBMS_ROBOT
        -- INSPNAME
        IF ksbms_pontis_util.f_set_inspevnt_value(psi_brkey,
                                                  psi_inspkey,
                                                  'inspname',
                                                  USER) THEN
          EXIT;
        END IF;

        -- IETRIGGER
        IF ksbms_pontis_util.f_set_inspevnt_value(psi_brkey,
                                                  psi_inspkey,
                                                  'ietrigger ',
                                                  'N') THEN
          EXIT;
        END IF;

        -- INSPTYPE
        IF ksbms_pontis_util.f_set_inspevnt_value(psi_brkey,
                                                  psi_inspkey,
                                                  'insptype ',
                                                  '1') THEN
          EXIT;
        END IF;

        -- NBINSPDONE
        IF ksbms_pontis_util.f_set_inspevnt_value(psi_brkey,
                                                  psi_inspkey,
                                                  'nbinspdone ',
                                                  '1') THEN
          EXIT;
        END IF;

        -- ELINSPDONE
        IF ksbms_pontis_util.f_set_inspevnt_value(psi_brkey,
                                                  psi_inspkey,
                                                  'elinspdone ',
                                                  '1') THEN
          EXIT;
        END IF;

        -- FCINSPREQ
        IF ksbms_pontis_util.f_set_inspevnt_value(psi_brkey,
                                                  psi_inspkey,
                                                  'fcinspreq ',
                                                  'N') THEN
          EXIT;
        END IF;

        -- UWINSPREQ
        IF ksbms_pontis_util.f_set_inspevnt_value(psi_brkey,
                                                  psi_inspkey,
                                                  'uwinspreq ',
                                                  'N') THEN
          EXIT;
        END IF;

        -- OSINSPREQ
        IF ksbms_pontis_util.f_set_inspevnt_value(psi_brkey,
                                                  psi_inspkey,
                                                  'osinspreq ',
                                                  'N') THEN
          EXIT;
        END IF;

        -- BRINSPFREQ
        ls_coption := ksbms_pontis_util.f_get_pontis_coption_value('DEFBRINSPFREQ');

        IF f_ns(ls_coption) THEN
          ls_coption := '24';
        END IF;

        IF ksbms_pontis_util.f_set_inspevnt_value(psi_brkey,
                                                  psi_inspkey,
                                                  'brinspfreq ',
                                                  ls_coption) THEN
          EXIT;
        END IF;

        -- LASTINSP is set to missing
        IF ksbms_pontis_util.f_set_inspevnt_value(psi_brkey,
                                                  psi_inspkey,
                                                  'lastinsp ',
                                                  ksbms_pontis_util.f_return_missing_date_string) THEN
          EXIT;
        END IF;
        -- NEXTINSP is set to missing
        IF ksbms_pontis_util.f_set_inspevnt_value(psi_brkey,
                                                  psi_inspkey,
                                                  'nextinsp ',
                                                  ksbms_pontis_util.f_return_missing_date_string) THEN
          EXIT;
        END IF;

        -- ELINSPFREQ uses the same coption value as BRINSPFREQ
        IF ksbms_pontis_util.f_set_inspevnt_value(psi_brkey,
                                                  psi_inspkey,
                                                  'elinspfreq ',
                                                  ls_coption) THEN
          EXIT;
        END IF;

        -- ELNEXTDATE is set to missing
        IF ksbms_pontis_util.f_set_inspevnt_value(psi_brkey,
                                                  psi_inspkey,
                                                  'elnextdate ',
                                                  ksbms_pontis_util.f_return_missing_date_string) THEN
          EXIT;
        END IF;

        -- FCINSPFREQ
        ls_coption := ksbms_pontis_util.f_get_pontis_coption_value('DEFFCINSPFREQ');

        IF f_ns(ls_coption) THEN
          ls_coption := '24';
        END IF;

        IF ksbms_pontis_util.f_set_inspevnt_value(psi_brkey,
                                                  psi_inspkey,
                                                  'fcinspfreq ',
                                                  ls_coption) THEN
          EXIT;
        END IF;

        -- UWINSPFREQ
        ls_coption := ksbms_pontis_util.f_get_pontis_coption_value('DEFUWINSPFREQ');

        IF f_ns(ls_coption) THEN
          ls_coption := '24';
        END IF;

        IF ksbms_pontis_util.f_set_inspevnt_value(psi_brkey,
                                                  psi_inspkey,
                                                  'uwinspfreq ',
                                                  ls_coption) THEN
          EXIT;
        END IF;

        -- OSINSPFREQ
        ls_coption := ksbms_pontis_util.f_get_pontis_coption_value('DEFOSINSPFREQ');

        IF f_ns(ls_coption) THEN
          ls_coption := '24';
        END IF;

        IF ksbms_pontis_util.f_set_inspevnt_value(psi_brkey,
                                                  psi_inspkey,
                                                  'osinspfreq ',
                                                  ls_coption) THEN
          EXIT;
        END IF;

        -- INSPECTCONTROLID
        IF ksbms_pontis_util.f_set_inspevnt_value(psi_brkey,
                                                  psi_inspkey,
                                                  'inspectcontrolid ',
                                                  '-1') THEN
          EXIT;
        END IF;

        -- INSPUSRKEY
        IF ksbms_pontis_util.f_set_inspevnt_value(psi_brkey,
                                                  psi_inspkey,
                                                  'inspusrkey ',
                                                  '1') THEN
          EXIT;
        END IF;

        -- CREATEUSERKEY
        IF ksbms_pontis_util.f_set_inspevnt_value(psi_brkey,
                                                  psi_inspkey,
                                                  'createuserkey ',
                                                  ksbms_pontis_util.f_get_users_userkey()) THEN
          EXIT;
        END IF;

        -- CREATEDATETIME
        IF ksbms_pontis_util.f_set_inspevnt_value(psi_brkey,
                                                  psi_inspkey,
                                                  'createdatetime',
                                                  TO_CHAR(SYSDATE,
                                                          'YYYY-MM-DD HH24:MI:SS')) THEN
          EXIT;
        END IF;

        -- MODTIME
        IF ksbms_pontis_util.f_set_inspevnt_value(psi_brkey,
                                                  psi_inspkey,
                                                  'modtime',
                                                  TO_CHAR(SYSDATE,
                                                          'YYYY-MM-DD HH24:MI:SS')) THEN
          EXIT;
        END IF;

        -- USERKEY
        IF ksbms_pontis_util.f_set_inspevnt_value(psi_brkey,
                                                  psi_inspkey,
                                                  'userkey',
                                                  ksbms_pontis_util.f_get_users_userkey()) THEN
          EXIT;
        END IF;

        -- Notes
        ls_string := 'Inspection History For New Bridge [ Bridge ID = ' ||
                     ksbms_pontis_util.f_get_bridge_id_from_brkey(psi_brkey) ||
                     ' / BRKEY = ' || psi_brkey || ' / INSPKEY = ' ||
                     psi_inspkey || ' ] -  Initialized On '
                     -- || to_char (psi_inspdate, 'YYYY-MM-DD HH24:MI:SS') <ENHANCEMENT>
                     || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') ||
                     ' by user ' || USER;

        -- Allen 12/;16/2002
        -- for really really new records, tag them as NEWUNINITIALIZEDKEYS through the NOTES field,
        -- this allows their match columns like KIND_HWY or ROUTE_PREFIX  on ROADWAY to be updated 1 time to good values, then prohibited forever.  Need for a new recor

        IF ksbms_pontis_util.f_set_inspevnt_value(psi_brkey,
                                                  psi_inspkey,
                                                  'notes',
                                                  cs_uninitializedkeys ||
                                                  ls_string) THEN
          EXIT;
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
      WHEN OTHERS THEN
        lb_failed := TRUE; -- Just to be sure
        ksbms_util.p_clean_up_after_raise_error(ls_context);
    END outer_exception_block; -- This ends the anonymous block created just to have the error handler

    ksbms_util.p_pop(ls_context);
    -- Save the changes (or not)
    RETURN f_commit_or_rollback(lb_failed, ls_context);
  END f_set_new_inspevnt_data;

  -- Sets the initial value of INSPEVNT data per Pontis's practice
  FUNCTION f_set_new_roadway_data(psi_brkey    IN roadway.brkey%TYPE,
                                  psi_on_under IN roadway.on_under%TYPE)
    RETURN BOOLEAN IS
    lb_failed     BOOLEAN := TRUE;
    ls_context    ksbms_util.context_string_type := 'f_set_new_roadway_data()';
    ls_coption    coptions.optionval%TYPE;
    ls_sysdefault VARCHAR2(2000); -- General-purpose
  BEGIN
    ksbms_util.p_push(ls_context);

    <<outer_exception_block>>
    BEGIN

      -- Loop allows exit on failure
      <<do_once>>
      LOOP
        -- Various default ROADWAY ata (per Pontis's w_insp_create_structure.uoe_genrequiredcolumns)

  -- CRIT_FEAT
  /* From f_set_roadway_crit_feat()

                    ls_sysdefault = f_get_datadict_sysdefault( "roadway","crit_feat","_", 2 )
                    if f_ns( ls_sysdefault ) or ls_sysdefault = "-1" then
                       // Treat as a missing value (underscore)
                       ls_sysdefault = "_"
                    else
                       // Make sure it's not too large
           ls_sysdefault = left( ls_sysdefault, 1 )
           // We got a valid default, so apply it
           if f_np( the_dw.setitem_with_unit_conversion( the_row, "roadway_crit_feat", ls_sysdefault ) ) then
              g.bug( "Failed to setitem_with_unit_conversion( crit_feat )")
              // Keep on truckin' -- it's STILL not critical!
           end if
        end if
        */
        ls_sysdefault := ksbms_pontis_util.f_get_pontis_datadict_value('roadway',
                                                                       'crit_feat');

        IF f_ns(ls_sysdefault) OR LENGTH(ls_sysdefault) > 1 -- Catches '-1'
         THEN
          ls_sysdefault := '_';
        END IF;

        IF ksbms_pontis_util.f_set_roadway_value(psi_brkey,
                                                 psi_on_under,
                                                 'crit_feat',
                                                 ls_sysdefault) THEN
          EXIT;
        END IF;

        -- CREATEUSERKEY
        IF ksbms_pontis_util.f_set_roadway_value(psi_brkey,
                                                 psi_on_under,
                                                 'createuserkey',
                                                 ksbms_pontis_util.f_get_users_userkey()) THEN
          EXIT;
        END IF;

        -- CREATEDATETIME
        IF ksbms_pontis_util.f_set_roadway_value(psi_brkey,
                                                 psi_on_under,
                                                 'createdatetime',
                                                 TO_CHAR(SYSDATE,
                                                         'YYYY-MM-DD HH24:MI:SS')) THEN
          EXIT;
        END IF;

        -- MODTIME
        IF ksbms_pontis_util.f_set_roadway_value(psi_brkey,
                                                 psi_on_under,
                                                 'modtime',
                                                 TO_CHAR(SYSDATE,
                                                         'YYYY-MM-DD HH24:MI:SS')) THEN
          EXIT;
        END IF;

        -- USERKEY
        IF ksbms_pontis_util.f_set_roadway_value(psi_brkey,
                                                 psi_on_under,
                                                 'userkey',
                                                 ksbms_pontis_util.f_get_users_userkey()) THEN
          EXIT;
        END IF;

        -- Allen 12/;16/2002
        -- for really really new records, tag them as NEWUNINITIALIZEDKEYS through the NOTES field,
        -- this allows their match columns like KIND_HWY or ROUTE_PREFIX  on ROADWAY to be updated 1 time to good values, then prohibited forever.  Need for a new recor
        IF ksbms_pontis_util.f_set_roadway_value(psi_brkey,
                                                 psi_on_under,
                                                 'notes',
                                                 cs_uninitializedkeys) THEN
          EXIT;
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
      WHEN OTHERS THEN
        lb_failed := TRUE; -- Just to be sure
        ksbms_util.p_clean_up_after_raise_error(ls_context);
    END outer_exception_block; -- This ends the anonymous block created just to have the error handler

    ksbms_util.p_pop(ls_context);
    -- Save the changes (or not)
    RETURN f_commit_or_rollback(lb_failed, ls_context);
  END f_set_new_roadway_data;

  -- Sets the initial value of INSPEVNT data per Pontis's practice
  FUNCTION f_set_new_userrway_data(psi_brkey     IN userrway.brkey%TYPE,
                                   psi_on_under  IN userrway.on_under%TYPE,
                                   psi_clr_route IN userrway.clr_route%TYPE)
    RETURN BOOLEAN IS
    lb_failed     BOOLEAN := TRUE;
    ls_context    ksbms_util.context_string_type := 'f_set_new_userrway_data()';
    ls_coption    coptions.optionval%TYPE;
    ls_sysdefault VARCHAR2(2000); -- General-purpose
  BEGIN
    ksbms_util.p_push(ls_context);

    <<outer_exception_block>>
    BEGIN

      -- Loop allows exit on failure
      <<do_once>>
      LOOP
        --
        IF ksbms_pontis_util.f_set_userrway_value(psi_brkey,
                                                  psi_on_under,
                                                  'route_prefix',
                                                  SUBSTR(psi_clr_route, 1, 1)) THEN
          EXIT;
        END IF;

        IF ksbms_pontis_util.f_set_userrway_value(psi_brkey,
                                                  psi_on_under,
                                                  'route_num',
                                                   -- char to num to char to clear leading zeros
                                                  TO_CHAR(TO_NUMBER(NVL(SUBSTR(psi_clr_route,
                                                                               2,
                                                                               5),
                                                                        '0')))) THEN
          EXIT;
        END IF;

        IF ksbms_pontis_util.f_set_userrway_value(psi_brkey,
                                                  psi_on_under,
                                                  'route_suffix',
                                                  SUBSTR(psi_clr_route, 7, 1)) THEN
          EXIT;
        END IF;

        IF ksbms_pontis_util.f_set_userrway_value(psi_brkey,
                                                  psi_on_under,
                                                  'route_unique_id',
                                                  SUBSTR(psi_clr_route, 8, 1)) THEN
          EXIT;
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
      WHEN OTHERS THEN
        lb_failed := TRUE; -- Just to be sure
        ksbms_util.p_clean_up_after_raise_error(ls_context);
    END outer_exception_block; -- This ends the anonymous block created just to have the error handler

    ksbms_util.p_pop(ls_context);
    -- Save the changes (or not)
    RETURN f_commit_or_rollback(lb_failed, ls_context);
  END f_set_new_userrway_data;

  -- Sets the initial value of STRUCTURE UNITdata per Pontis's practice
  FUNCTION f_set_new_structure_unit_data(psi_brkey      IN structure_unit.brkey%TYPE,
                                         psi_strunitkey IN structure_unit.strunitkey%TYPE)
    RETURN BOOLEAN IS
    lb_failed     BOOLEAN := TRUE;
    ls_context    ksbms_util.context_string_type := 'f_set_new_structure_unit_data()';
    ls_coption    coptions.optionval%TYPE;
    ls_sysdefault VARCHAR2(2000); -- General-purpose
  BEGIN
    ksbms_util.p_push(ls_context);

    <<outer_exception_block>>
    BEGIN

      -- Loop allows exit on failure
      <<do_once>>
      LOOP
        -- DEFAULTFLAG
        IF ksbms_pontis_util.f_set_structure_unit_value(psi_brkey,
                                                        psi_strunitkey,
                                                        'defaultflag',
                                                        '1') THEN
          EXIT;
        END IF;

        -- CREATEUSERKEY
        IF ksbms_pontis_util.f_set_structure_unit_value(psi_brkey,
                                                        psi_strunitkey,
                                                        'createuserkey',
                                                        ksbms_pontis_util.f_get_users_userkey()) THEN
          EXIT;
        END IF;

        -- CREATEDATETIME
        IF ksbms_pontis_util.f_set_structure_unit_value(psi_brkey,
                                                        psi_strunitkey,
                                                        'createdatetime',
                                                        TO_CHAR(SYSDATE,
                                                                'YYYY-MM-DD HH24:MI:SS')) THEN
          EXIT;
        END IF;

        -- MODTIME
        IF ksbms_pontis_util.f_set_structure_unit_value(psi_brkey,
                                                        psi_strunitkey,
                                                        'modtime',
                                                        TO_CHAR(SYSDATE,
                                                                'YYYY-MM-DD HH24:MI:SS')) THEN
          EXIT;
        END IF;

        -- USERKEY
        IF ksbms_pontis_util.f_set_structure_unit_value(psi_brkey,
                                                        psi_strunitkey,
                                                        'userkey',
                                                        ksbms_pontis_util.f_get_users_userkey()) THEN
          EXIT;
        END IF;

        -- Allen 12/;16/2002
        -- for really really new records, tag them as NEWUNINITIALIZEDKEYS through the NOTES field,
        -- this allows their match columns like KIND_HWY or ROUTE_PREFIX to be updated 1 time to good values, then prohibited forever.  Need for a new recor
        IF ksbms_pontis_util.f_set_structure_unit_value(psi_brkey,
                                                        psi_strunitkey,
                                                        'notes',
                                                        cs_uninitializedkeys) THEN
          EXIT;
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
      WHEN OTHERS THEN
        lb_failed := TRUE; -- Just to be sure
        ksbms_util.p_clean_up_after_raise_error(ls_context);
    END outer_exception_block; -- This ends the anonymous block created just to have the error handler

    ksbms_util.p_pop(ls_context);
    -- Save the changes (or not)
    RETURN f_commit_or_rollback(lb_failed, ls_context);
  END f_set_new_structure_unit_data;
  
  
 FUNCTION f_set_new_userbrdg_data(psi_brkey     IN userbrdg.brkey%TYPE)
    RETURN BOOLEAN IS
    lb_failed     BOOLEAN := TRUE;
    ls_context    ksbms_util.context_string_type := 'f_set_new_userbrdg_data()';
    ls_coption    coptions.optionval%TYPE;
    ls_sysdefault VARCHAR2(2000); -- General-purpose
  BEGIN
    ksbms_util.p_push(ls_context);

    <<outer_exception_block>>
    BEGIN

      -- Loop allows exit on failure
      <<do_once>>
      LOOP
        --
       
        IF ksbms_pontis_util.f_set_userbrdg_value(psi_brkey,'avg_hi','100.0') THEN
          EXIT;
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
      WHEN OTHERS THEN
        lb_failed := TRUE; -- Just to be sure
        ksbms_util.p_clean_up_after_raise_error(ls_context);
    END outer_exception_block; -- This ends the anonymous block created just to have the error handler

    ksbms_util.p_pop(ls_context);
    -- Save the changes (or not)
    RETURN f_commit_or_rollback(lb_failed, ls_context);
  END f_set_new_userbrdg_data; 
  
  

  FUNCTION f_add_bridge(psi_brkey     IN bridge.brkey%TYPE,
                        psi_bridge_id IN bridge.bridge_id%TYPE)
    RETURN BOOLEAN IS
    lb_failed     BOOLEAN := TRUE;
    li_count      PLS_INTEGER;
    ls_context    ksbms_util.context_string_type := 'f_add_bridge()';
    ls_coption    coptions.optionval%TYPE;
    ls_string     VARCHAR2(2000); -- General-purpose
    ls_inspkey    inspevnt.inspkey%TYPE;
    li_strunitkey structure_unit.strunitkey%TYPE;
    ls_on_under   roadway.on_under%TYPE;
  BEGIN
    ksbms_util.p_push(ls_context);

    <<outer_exception_block>>
    BEGIN

      -- Loop allows exit on failure
      <<do_once>>
      LOOP
        -- Return immediately if the bridge already exists
        IF ksbms_pontis_util.f_bridge_exists(psi_brkey) THEN
          p_add_msg(ls_context || ': Bridge with BRKEY = ''' || psi_brkey ||
                    ''' already exists!');
          lb_failed := FALSE; -- Treat this as success
          EXIT;
        END IF;

        -- Insert the new bride record
        BEGIN
          INSERT INTO bridge
            (brkey, bridge_id, struct_num) -- These three columns are NOT NULL
          VALUES
            (psi_brkey, psi_bridge_id, psi_brkey);
          COMMIT;
          -- 1/10/2002 Removed a colon after Bridge ID
          p_add_msg('New bridge inserted with Bridge ID ' || psi_bridge_id ||
                    ' and brkey ' || psi_brkey);
        EXCEPTION
          WHEN OTHERS THEN
            p_sql_error('Inserting Bridge_ID ' || psi_bridge_id ||
                        ' into the BRIDGE table.');
        END;

        -- This sets various BRIDGE columns per
        -- w_insp_create_structure.uoe_genrequiredcolumns
        IF f_set_new_structure_data(psi_brkey) THEN
          EXIT;
        END IF;

        -- Insert a USERBRDG record
        BEGIN
          INSERT INTO userbrdg
            (brkey) -- This is the only NOT NULL column
          VALUES
            (psi_brkey);
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            p_sql_error('Inserting Bridge_ID ' || psi_bridge_id ||
                        ' into the USERBRDG table.');
        END;

        -- Insert INSPEVNT and USERINSP records
        IF f_add_inspevnt(psi_brkey, SYSDATE, ls_inspkey) THEN
          EXIT;
        END IF;

        -- Set INSPEVNT.DET_UPD _outside_ of f_add_inspevnt()
        --
        -- This serves as a flag, looked for by f_insert_pontis_records()
        -- to find the INSPEVNT record entered by this function.
        IF ksbms_pontis_util.f_set_inspevnt_value(psi_brkey,
                                                  ls_inspkey,
                                                  'inspectcontrolid', -- Allen Marshall, CS -01/23/2003 - det_upd used to be the tag field, too sMALL
                                                  ls_added_with_new_bridge) THEN
          EXIT;
        END IF;

        -- Insert STRUCTURE_UNIT and USERSTRUNIT records
        IF f_add_structure_unit(psi_brkey, li_strunitkey) THEN
          EXIT;
        END IF;

        -- Set STRUCTURE_UNIT.STRUNITDESCRIPTION _outside_ of f_add_structure_unit()
        --
        -- This serves as a flag, looked for by f_insert_pontis_records()
        -- to find the STRUCTURE_UNIT record entered by this function.
        IF ksbms_pontis_util.f_set_structure_unit_value(psi_brkey,
                                                        li_strunitkey,
                                                        'strunitdescription',
                                                        ls_added_with_new_bridge) THEN
          EXIT;
        END IF;

        /*
        -- Allen Marshall, CS - 01/23/2003 - defeated - was not allowing subsequent updates
        -- to fix up roadway and or userrway records

        -- Insert ROADWAY and USERRWAY records
        IF f_add_roadway (psi_brkey, ls_on_under)
        THEN
             EXIT;
        END IF;

        -- Set ROADWAY.ROADWAY_NAME _outside_ of f_add_inspevnt()
        --
        -- This serves as a flag, looked for by f_insert_pontis_records()
        -- to find the ROADWAY record entered by this function.
        IF ksbms_pontis_util.f_set_roadway_value (psi_brkey,
                                                  ls_on_under,
                                                  'roadway_name',
                                                  ls_added_with_new_bridge
                                                 )
        THEN
             EXIT;
        END IF;
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
      WHEN OTHERS THEN
        lb_failed := TRUE; -- Just to be sure
        ksbms_util.p_clean_up_after_raise_error(ls_context);
    END outer_exception_block; -- This ends the anonymous block created just to have the error handler

    ksbms_util.p_pop(ls_context);
    -- Save the changes (or not)
    RETURN f_commit_or_rollback(lb_failed, ls_context);
  END f_add_bridge;

  -- This adds an INSPEVNT record to the passed BRKEY, returning a new INSPKEY
  FUNCTION f_add_inspevnt(psi_brkey    IN bridge.brkey%TYPE,
                          psi_inspdate IN inspevnt.inspdate%TYPE,
                          pso_inspkey  OUT inspevnt.inspkey%TYPE)
    RETURN BOOLEAN IS
    lb_failed  BOOLEAN := TRUE;
    ls_context ksbms_util.context_string_type := 'f_add_inspevnt()';
    ls_coption coptions.optionval%TYPE;
    ls_string  VARCHAR2(2000); -- General-purpose
  BEGIN
    ksbms_util.p_push(ls_context);

    <<outer_exception_block>>
    BEGIN

      -- Loop allows exit on failure
      <<do_once>>
      LOOP
        -- Get the new inspkey (and return it via the 'out' parameter)
        pso_inspkey := ksbms_pontis_util.get_pontis_inspkey(psi_brkey);

        IF pso_inspkey IS NULL THEN
          p_sql_error(ls_context || ': Failed to generated an inspkey!');
        END IF;

        -- Insert the new INSPEVNT record
        BEGIN
          -- <ENHANCEMENT> Defaults OK? There seem to be no restraints on inspuserkey or insptype
          INSERT INTO inspevnt
            (brkey, inspkey, inspdate, inspname, inspusrkey, insptype)
          VALUES
            (psi_brkey,
             pso_inspkey,
             psi_inspdate,
             '-1',
             ksbms_pontis_util.f_get_users_userkey(),
             1);
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            p_sql_error('Inserting INSPEVNT record for BRKEY ' ||
                        psi_brkey || ' and NEW inspkey ' || pso_inspkey || '.');
        END;

        BEGIN
          INSERT INTO userinsp
            (brkey, inspkey) -- These are the only NOT NULL columns
          VALUES
            (psi_brkey, pso_inspkey);
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            p_sql_error('Inserting USERINSP record for BRKEY ' ||
                        psi_brkey || ' and NEW inspkey ' || pso_inspkey || '.');
        END;

        -- Set the various INSPEVNT data
        IF f_set_new_inspevnt_data(psi_brkey, pso_inspkey) THEN
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
      WHEN OTHERS THEN
        lb_failed := TRUE; -- Just to be sure
        ksbms_util.p_clean_up_after_raise_error(ls_context);
    END outer_exception_block; -- This ends the anonymous block created just to have the error handler

    ksbms_util.p_pop(ls_context);
    -- Save the changes (or not)
    RETURN f_commit_or_rollback(lb_failed, ls_context);
  END f_add_inspevnt;

  -- This adds an ROADWAY record using the passed BRKEY, returning a new ON_UNDER
  FUNCTION f_add_roadway(psi_brkey     IN bridge.brkey%TYPE,
                       psio_on_under IN OUT roadway.on_under%TYPE)
  RETURN BOOLEAN IS
  lb_failed     BOOLEAN := TRUE;
  ls_context    ksbms_util.context_string_type := 'f_add_roadway()';
  ls_coption    coptions.optionval%TYPE;
  ls_sysdefault datadict.sysdefault%TYPE;
  ls_string     VARCHAR2(2000); -- General-purpose
  ls_bridge_id  bridge.bridge_id%TYPE;
BEGIN
  ksbms_util.p_push(ls_context);

  <<outer_exception_block>>
  BEGIN

  -- Loop allows exit on failure
  <<do_once>>
  LOOP
  -- Make sure the brkey is valid
  IF NOT ksbms_pontis_util.f_bridge_exists(psi_brkey) THEN
    p_sql_error(ls_context || ': Invalid BRKEY passed - ''' ||
                psi_brkey || '''');
  END IF;

  -- Per Pontis, on_under defaults to '1' (Route On Structure)
  IF f_ns(psio_on_under) -- No on_under was passed in
   THEN
    psio_on_under := '1';
  END IF;

  -- For error messages
  ls_bridge_id := NVL(ksbms_pontis_util.f_get_bridge_id_from_brkey(psi_brkey),
                      psi_brkey);

  -- Insert ROADWAY and USERRWAY records
  BEGIN
    INSERT INTO roadway
      (brkey, on_under) -- These are the only NOT NULL columns
    VALUES
      (psi_brkey, psio_on_under);
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      p_sql_error('Inserting Bridge_ID ' || ls_bridge_id ||
                  ' and on_under ' || psio_on_under ||
                  ' into the ROADWAY table.');
  END;

  -- If we inserted a ROADWAY record, insert a USERRWAY record too
  BEGIN
    INSERT INTO userrway
      (brkey, on_under) -- These are the only NOT NULL columns
    VALUES
      (psi_brkey, psio_on_under);
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      p_sql_error('Inserting Bridge_ID ' || ls_bridge_id ||
                  ' and on_under ' || psio_on_under ||
                  ' into the USERRWAY table.');
  END;

  -- Set the various ROADWAY data per Pontis's practice
        IF f_set_new_roadway_data(psi_brkey, psio_on_under) THEN
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
      WHEN OTHERS THEN
        lb_failed := TRUE; -- Just to be sure
        ksbms_util.p_clean_up_after_raise_error(ls_context);
    END outer_exception_block; -- This ends the anonymous block created just to have the error handler

    ksbms_util.p_pop(ls_context);
    -- Save the changes (or not)
    RETURN f_commit_or_rollback(lb_failed, ls_context);
  END f_add_roadway;

  -- This adds a STRUCTURE_UNIT record using the passed BRKEY, returning a new STRUNITKEY
  -- Allen 2002.12.16 several fixes, including making unitkey an IN OUT, fixing up by selecting MAX if records exist
  -- ALso enforces minimum structure_unit.strunitkey to be greater or equal to a constant - see constant cl_minumum_strunitkey
  FUNCTION f_add_structure_unit(psi_brkey      IN bridge.brkey%TYPE,
                                pso_strunitkey IN OUT structure_unit.strunitkey%TYPE)
    RETURN BOOLEAN IS
    lb_failed     BOOLEAN := TRUE;
    ls_context    ksbms_util.context_string_type := 'f_add_structure_unit()';
    ls_coption    coptions.optionval%TYPE;
    ls_sysdefault datadict.sysdefault%TYPE;
    ls_string     VARCHAR2(2000); -- General-purpose
    ls_bridge_id  bridge.bridge_id%TYPE;
    li_strunitkey structure_unit.strunitkey%TYPE;
  BEGIN
    ksbms_util.p_push(ls_context);

    <<outer_exception_block>>
    BEGIN

      -- Loop allows exit on failure
      <<do_once>>
      LOOP
        -- Make sure the brkey is valid
        IF NOT ksbms_pontis_util.f_bridge_exists(psi_brkey) THEN
          p_sql_error(ls_context || ': Invalid BRKEY passed - ''' ||
                      psi_brkey || '''');
        END IF;

        -- For error messages
        ls_bridge_id := NVL(ksbms_pontis_util.f_get_bridge_id_from_brkey(psi_brkey),
                            psi_brkey);

        -- if we didn't get a unitkey passed to this routine, use default from DEFSTRUNITKEY (1)

  IF (pso_strunitkey IS NULL -- passed NULL
   OR pso_strunitkey < cl_minimum_strunitkey) THEN
  -- Get the default STRUNITKEY (per Pontis's practice)
          --pso_strunitkey := ksbms_pontis_util.f_get_pontis_coption_value ('DEFSTRUNITKEY');
          pso_strunitkey := ksbms_pontis_util.f_get_pontis_coption_value('DEFSTRUNITKEY');

          IF pso_strunitkey IS NULL OR
             pso_strunitkey < cl_minimum_strunitkey -- 1 THIS USED TO BE 0 FOR THE MINIMUM
           THEN
            pso_strunitkey := 1; -- assumed if nothing else is known
          END IF;
        END IF;

        -- Get the minimum STRUNITTYPE from PARAMTRS
        SELECT MIN(parmvalue)
          INTO ls_string
          FROM paramtrs
         WHERE UPPER(table_name) = 'STRUCTURE_UNIT' AND
               UPPER(field_name) = 'STRUNITTYPE';

        IF f_ns(ls_string) THEN
          ls_string := '_';
        END IF;

        -- Insert the STRUCTURE_UNIT
        -- STRUNITLABEL is needed because that's part of the key to CANSYS
  -- CHANGE CHANGE CHANGE
  -- Allen 2002.12.16 - if unit already exists and the next insert fails, attempt insert in the EXCEPTION block.
  BEGIN
    INSERT INTO structure_unit
      (brkey, strunitkey, strunittype, strunitlabel)
    VALUES
      (psi_brkey,
       pso_strunitkey,
       ls_string,
       'Structure Unit ' || TO_CHAR(pso_strunitkey) -- Per Pontis, affix unit number to label e.g. Structure Unit 1 etc.
       );
    COMMIT;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      -- row exists, failover to insert next + 1 for multi-unit bridges
      BEGIN
        -- CHANGE CHANGE CHANGE
        -- Allen 2002.12.16 - if unit already exists, increment and try again
        -- get NEXT+ 1 unit key
        BEGIN
          SELECT MAX(strunitkey) + 1
            INTO pso_strunitkey
            FROM structure_unit
           WHERE brkey = psi_brkey;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            BEGIN
              p_sql_error('Failed finding next+1  structure unit number  when inserting Bridge_ID ' ||
                          ls_bridge_id || ' and strunitkey ' ||
                          NVL(pso_strunitkey, '??') ||
                          ' into the STRUCTURE_UNIT table.');
              RAISE;
            END;
          WHEN OTHERS THEN
            RAISE;
        END;

        -- CHANGE CHANGE CHANGE
        -- Allen 2002.12.16 - if unit already exists, increment and try again
        -- get NEXT+ 1 unit key

        INSERT INTO structure_unit
          (brkey, strunitkey, strunittype, strunitlabel)
        VALUES
          (psi_brkey,
           pso_strunitkey,
           ls_string,
           'Structure Unit ' || TO_CHAR(pso_strunitkey) -- Per Pontis, affix unit number to label e.g. Structure Unit 1 etc.
           );
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          p_sql_error('Inserting Bridge_ID ' || ls_bridge_id ||
                      ' and strunitkey ' || pso_strunitkey ||
                      ' into the STRUCTURE_UNIT table.');
      END;
  END;

  -- Insert the USERSTRUNIT record too - this one is dependent on
  BEGIN
    INSERT INTO userstrunit
      (brkey, strunitkey)
    VALUES
      (psi_brkey, pso_strunitkey);
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      p_sql_error('Inserting Bridge_ID ' || ls_bridge_id ||
                  ' and strunitkey ' || pso_strunitkey ||
                  ' into the USERSTRUNIT table.');
  END;

  -- Update the new STRUCTURE_UNIT record per Pontis's practice
        IF f_set_new_structure_unit_data(psi_brkey, pso_strunitkey) THEN
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
      WHEN OTHERS THEN
        lb_failed := TRUE; -- Just to be sure
        ksbms_util.p_clean_up_after_raise_error(ls_context);
    END outer_exception_block; -- This ends the anonymous block created just to have the error handler

    ksbms_util.p_pop(ls_context);
    -- Save the changes (or not)
    RETURN f_commit_or_rollback(lb_failed, ls_context);
  END f_add_structure_unit;

  FUNCTION f_delete_pontis_records(pio_entry_id       IN ds_change_log.entry_id%TYPE,
                                   pio_number_deleted IN OUT PLS_INTEGER)
    RETURN BOOLEAN IS
    lb_failed              BOOLEAN := TRUE; -- Until we succeed
    ls_context             ksbms_util.context_string_type := 'f_delete_pontis_records()';
    li_deleted_count       PLS_INTEGER := 0;
    ls_pontis_where        VARCHAR2(4000);
    ls_user_where          VARCHAR2(4000);
    ls_sql                 VARCHAR2(4000);
    li_strunitkey          structure_unit.strunitkey%TYPE;
    ls_brkey               bridge.brkey%TYPE;
    ls_pontis_insert       VARCHAR2(4000);
    ls_pontis_target_table VARCHAR2(40);
    ls_user_target_table   VARCHAR2(40);
    ls_user_insert         VARCHAR2(4000);
    ls_second_key          VARCHAR2(100);
    ls_third_key           VARCHAR2(100);
  BEGIN
    ksbms_util.p_push(ls_context);

    <<outer_exception_block>>
    BEGIN

      <<do_once>>
      LOOP
        -- Clear the counter
        -- pio_number_deleted := 0;

        -- Select all of the DEL (DELETE) records from CANSYS
        DECLARE
          -- Get all the merge-ready records representing DELETEs from CANSYS.
          -- These are merge-ready DEL records from CANSYS.
          CURSOR deletes_to_process_cursor IS
            SELECT ds_change_log.entry_id     entry_id,
                   ds_transfer_map.table_name target_table_name
              FROM ds_change_log, ds_transfer_map
             WHERE ds_change_log.entry_id = pio_entry_id AND
                   ds_change_log.exchange_rule_id =
                   ds_transfer_map.exchange_rule_id
                   /* Hoyt 08/08/2002 These were applied in calling routine
                                                       and ds_change_log.exchange_status = ls_merge_ready
                                                       and ds_change_log.precedence = 'FC'
                                                       and ds_change_log.exchange_type = ls_delete_type
                                                       */
                   AND ds_change_log.entry_id = pio_entry_id -- Hoyt 08/08/2002

             --                    order by ds_transfer_map.table_name
             ORDER BY ds_change_log.sequence_num;
               -- FOR UPDATE;

          deletes_to_process_cursor_rec deletes_to_process_cursor%ROWTYPE;


        BEGIN
          --
          p_log('In ' || ls_context ||
                ', looping through DEL records in ds_change_log');

          -- Loop through all the DELETE change log records
          <<change_log_loop>>
          FOR deletes_to_process_cursor_rec IN deletes_to_process_cursor LOOP
            -- Build the WHERE clause
            IF f_build_where_clause(deletes_to_process_cursor_rec.entry_id,
                                    deletes_to_process_cursor_rec.target_table_name,
                                    ls_pontis_where,
                                    ls_user_where,
                                    ls_pontis_insert,
                                    ls_user_insert,
                                    ls_pontis_target_table,
                                    ls_user_target_table,
                                    ls_brkey,
                                    ls_second_key,
                                    ls_third_key) THEN
              EXIT; -- Failed
            END IF;

            -- Hoyt 08/08/2002 Cannot delete bridges! Mutating Bridge problem!
            /*
            if    deletes_to_process_cursor_rec.target_table_name = 'BRIDGE'
               or deletes_to_process_cursor_rec.target_table_name = 'USERBRDG'
            then
               p_log (   'Cannot delete Bridges: '
                      || ls_pontis_where);
               lb_failed := false;
               exit;
            end if;
            */

            -- Build the DELETE clause
            IF INSTR(deletes_to_process_cursor_rec.target_table_name,
                     'USER') = 0 THEN
              ls_sql := 'DELETE from ' ||
                        deletes_to_process_cursor_rec.target_table_name || ' ' ||
                        ls_pontis_where;
            ELSE
              ls_sql := 'DELETE from ' ||
                        deletes_to_process_cursor_rec.target_table_name || ' ' ||
                        ls_user_where;
            END IF;

            -- Execute the delete
            --
            p_log('In ' || ls_context || ', executing delete SQL ' ||
                  ls_delete);
            p_log('SQL: ' || ls_sql);

            BEGIN
              EXECUTE IMMEDIATE ls_sql;
              -- Count how many are updated
              li_deleted_count := li_deleted_count + 1;
            EXCEPTION
              WHEN OTHERS THEN
                p_sql_error('In ' || ls_context ||
                            ', error while DELETing using ' || ls_sql);
            END;

            /* Hoyt 08/09/2002 This breaks the cursor
            -- Delete entries from the change log and keyvals
            if f_delete_from_log_and_keyvals (deletes_to_process_cursor_rec.entry_id)
            then
               exit;
            end if;
            */
            -- Keep track of the count
            pio_number_deleted := pio_number_deleted + 1;
          END LOOP change_log_loop;
          -- now, for these changes, reset exchange_status to <DELETE>
          -- Hoyt 08/09/2002 do this instead
          BEGIN
            --
            p_log('In ' || ls_context ||
                  ', now setting DEL(READY) records in ds_change_log to ' ||
                  ls_delete);

            UPDATE ds_change_log
               SET exchange_status = ls_delete
             WHERE entry_id = pio_entry_id;
            -- Allen Marshall, CS -2003.04.08
            -- UH OH, COMMIT INSIDE FOR UPDATE LOOP - CAUSES FETCH OUT OF SEQUENCE
            -- COMMIT;
            IF SQL%ROWCOUNT = 0 THEN
              NULL; -- raise no_data_affected;
            END IF;

            COMMIT;
            p_log('In ' || ls_context ||
                  ', finished setting DEL(READY) records in ds_change_log to ' ||
                  ls_delete);

          EXCEPTION
            WHEN no_data_affected THEN
              p_sql_error('No data affected when marking change log to DELETE');
            WHEN OTHERS THEN
              p_sql_error('Failed to mark change log for DELETE');
          END;

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
      WHEN OTHERS THEN
        lb_failed := TRUE; -- Just to be sure
        ksbms_util.p_clean_up_after_raise_error(ls_context);

    END outer_exception_block; -- This ends the anonymous block created just to have the error handler

    -- Hoyt 08/09/2002 Return the number deleted

    pio_number_deleted := li_deleted_count;
    -- Note our effect (if any)
    p_log(TO_CHAR(li_deleted_count) || ' records were deleted from Pontis');

    -- clean up context Allen Marshall, CS - 2003.04.14
    ksbms_util.p_pop( ls_context );
    -- Save the changes (or not)
    RETURN f_commit_or_rollback(lb_failed, ls_context);
  END f_delete_pontis_records;

  -- This traverses the key names and values in ds_lookup_keyvals,
  -- "wrapping" the values appropriately depending on their data type,
  -- returning the key-value pairs as a well-formed WHERE clause.
  -- Used to try updates and inserts if no match found.  Special handling for CLR_ROUTE, and several STRUCTURE_UNIT tunings
  FUNCTION f_Build_Where_Clause 
     ( 
          Psi_Entry_Id            IN Ds_Change_Log.Entry_Id%TYPE, 
          Psi_Target_Table        IN Ds_Transfer_Map.Table_Name%TYPE, 
          Pso_Pontis_Where        OUT VARCHAR2, 
          Pso_User_Where          OUT VARCHAR2, 
          Pso_Pontis_Insert       OUT VARCHAR2, 
          Pso_User_Insert         OUT VARCHAR2, 
          Pso_Pontis_Target_Table OUT VARCHAR2, 
          Pso_User_Target_Table   OUT VARCHAR2, 
          Pso_Brkey               OUT Bridge.Brkey%TYPE, 
          Pso_Second_Key          OUT VARCHAR2, 
          Pso_Third_Key           OUT VARCHAR2 
     ) RETURN BOOLEAN IS 
          Lb_Failed           BOOLEAN := TRUE; -- Until we succeed 
          Ls_Context          Ksbms_Util.Context_String_Type := 'f_build_where_clause()'; 
          Li_Deleted_Count    PLS_INTEGER; 
          Li_Not_Found_Count  PLS_INTEGER; 
          Li_Key_Sequence_Num PLS_INTEGER; 
          Ls_Bridge_Id        Bridge.Bridge_Id%TYPE; 
          Ls_Brkey            Bridge.Brkey%TYPE; 
          Ls_Strunitkey       VARCHAR2(10); -- No anchored type to avoid conversion 
          Ls_Pontis_Where     VARCHAR2(4000); 
          Ls_User_Where       VARCHAR2(4000); 
          Ls_Pontis_Insert    VARCHAR2(4000); 
          Ls_User_Insert      VARCHAR2(4000); 
          Ls_Initial_Where CONSTANT VARCHAR2(6) := 'WHERE'; 
          Ls_Initial_Columns VARCHAR2(4000) := 'NEW'; 
          Ls_Pontis_Columns  VARCHAR2(4000) := Ls_Initial_Columns; -- So we know this is the first loop 
          Ls_Pontis_Values   VARCHAR2(4000) := '('; 
          Ls_User_Columns    VARCHAR2(4000); 
          Ls_User_Values     VARCHAR2(4000); 
          Ls_Missing_Asterisk CONSTANT Roadway.On_Under%TYPE := '*'; 
          Ls_On_Under                   Roadway.On_Under%TYPE := Ls_Missing_Asterisk; -- So we can test whether we set it 
          Ls_Pontis_Insert_Target_Table VARCHAR2(32); 
          Ls_User_Insert_Target_Table   VARCHAR2(32); 
          Ls_Inspkey                    Inspevnt.Inspkey%TYPE; 
          Li_Strunitkey                 Structure_Unit.Strunitkey%TYPE; 
          Ls_Strunitlabel               Structure_Unit.Strunitlabel%TYPE; 
          Ls_Inspdate                   VARCHAR2(100); -- CanNOT be anchored type -- this is a string, not a date 
          Ls_Strunittype                Structure_Unit.Strunittype%TYPE; 
          Ls_Feat_Cross_Type            Userrway.Feat_Cross_Type%TYPE; 
          Ls_Long_String_For_Debugging  VARCHAR2(2000); -- Can remove someday ENHANCEMENT 
          Ls_Value_String               VARCHAR2(255); -- used to pass corresponding_keyvals_rec.key_value to f_evaluate_clr_route 
          Ls_Clr_Route_Where            VARCHAR2(200) := ' route_prefix =' || 
                                                         Ksbms_Util.Sq('XRPX') || 
                                                         '  AND route_num = ' || 
                                                         Ksbms_Util.Sq('XRNX') || -- zero padded on input.... 
                                                         '  AND  route_suffix = ' || 
                                                         Ksbms_Util.Sq('XRSX') || 
                                                         '  AND route_unique_id = ' || 
                                                         Ksbms_Util.Sq('XUIX'); -- Allen Marshall, CS - 2002.12.17 - replace the tokens in this to make a real where clause later in this function.  Special handling for CLR_ROUTE 
          -- NOTE THAT THESE TOKENS ARE ALREADY ENQUOTED BY KSBMS_UTIL.SQ- NO NEED TO DO SO AGAIN LATER WHEN THE VALUES ARE REPLACED WITH MEANINGFUL ONES> 
      
          -- Get the keys that correspond to the passed entry_id 
          -- (and the key's table name so we know how to wrap it) 
      
          CURSOR Corresponding_Keyvals_Cursor(p_Entry_Id Ds_Change_Log.Entry_Id%TYPE) IS 
               SELECT Nvl(Ds_Lookup_Keyvals.Keyvalue, Ls_Missing) Key_Value, 
                      Nvl(Ds_Lookup_Keyvals.Keyname, Ls_Missing) Key_Name, 
                      Ds_Transfer_Map.Table_Name Key_Table_Name, 
                      Ds_Change_Log.Createdatetime Change_Log_Createdatetime, 
                      Ds_Transfer_Key_Map.Transfer_Key_Map_Id Transfer_Key_Map_Id 
               FROM Ds_Lookup_Keyvals, 
                    Ds_Transfer_Key_Map, 
                    Ds_Change_Log, 
                    Ds_Transfer_Map 
               WHERE Ds_Lookup_Keyvals.Entry_Id = Ds_Change_Log.Entry_Id 
               AND Ds_Change_Log.Exchange_Rule_Id = 
                     Ds_Transfer_Map.Exchange_Rule_Id 
               AND Ds_Transfer_Map.Transfer_Key_Map_Id = 
                     Ds_Transfer_Key_Map.Transfer_Key_Map_Id 
               AND Ds_Transfer_Key_Map.Key_Sequence_Num = 
                     Ds_Lookup_Keyvals.Key_Sequence_Num 
               AND Ds_Lookup_Keyvals.Entry_Id = p_Entry_Id 
                    -- Hoyt 02/13/2002 Only use the keys applicable to Pontis 
               AND (Ds_Transfer_Key_Map.Used_By = 'P' OR 
                     Ds_Transfer_Key_Map.Used_By = 'B') 
               ORDER BY Ds_Lookup_Keyvals.Key_Sequence_Num; 
      
          Corresponding_Keyvals_Rec Corresponding_Keyvals_Cursor%ROWTYPE; 
     BEGIN 
          Ksbms_Util.p_Push(Ls_Context); 
      
          <<outer_Exception_Block>> 
          BEGIN 
          
               <<do_Once>> 
               LOOP 
                    -- Make sure the argument is valid 
                    IF f_Ns(Psi_Entry_Id) 
                    THEN 
                         p_Bug('NULL or empty ENTRY_ID passed to ' || 
                               Ls_Context); 
                         EXIT; -- Failed 
                    END IF; 
                
                    -- Hoyt 08/08/2002 Do not permit missing key_value or key_name 
                    IF Corresponding_Keyvals_Rec.Key_Value = '<MISSING>' 
                    THEN 
                         p_Log('<MISSING> key_value for entry id ' || 
                               Psi_Entry_Id); 
                         EXIT; -- Failed 
                    END IF; 
                
                    IF Corresponding_Keyvals_Rec.Key_Name = '<MISSING>' 
                    THEN 
                         p_Log('<MISSING> key_name for entry id ' || 
                               Psi_Entry_Id); 
                         EXIT; -- Failed 
                    END IF; 
                
                    -- Set the INSERT targets based on the passed target table 
                    IF Upper(Psi_Target_Table) = 'BRIDGE' OR 
                       Upper(Psi_Target_Table) = 'USERBRDG' 
                    THEN 
                         Ls_Pontis_Insert_Target_Table := 'BRIDGE'; 
                         Ls_User_Insert_Target_Table   := 'USERBRDG'; 
                    ELSIF Upper(Psi_Target_Table) = 'INSPEVNT' OR 
                          Upper(Psi_Target_Table) = 'USERINSP' 
                    THEN 
                         Ls_Pontis_Insert_Target_Table := 'INSPEVNT'; 
                         Ls_User_Insert_Target_Table   := 'USERINSP'; 
                    ELSIF Upper(Psi_Target_Table) = 'ROADWAY' OR 
                          Upper(Psi_Target_Table) = 'USERRWAY' 
                    THEN 
                         Ls_Pontis_Insert_Target_Table := 'ROADWAY'; 
                         Ls_User_Insert_Target_Table   := 'USERRWAY'; 
                    ELSIF Upper(Psi_Target_Table) = 'STRUCTURE_UNIT' OR 
                          Upper(Psi_Target_Table) = 'USERSTRUNIT' 
                    THEN 
                         Ls_Pontis_Insert_Target_Table := 'STRUCTURE_UNIT'; 
                         Ls_User_Insert_Target_Table   := 'USERSTRUNIT'; 
                    ELSE 
                         p_Bug('Unhandled target table: ' || 
                               Psi_Target_Table); 
                    END IF; 
                
                    -- (later) Return the target tables to the calling routine 
                    Pso_Pontis_Target_Table := Ls_Pontis_Insert_Target_Table; 
                    Pso_User_Target_Table   := Ls_User_Insert_Target_Table; 
                
                    -- Open the keyvalues cursor 
                    IF Corresponding_Keyvals_Cursor%ISOPEN 
                    THEN 
                         p_Bug('Cursor corresponding_keyvals_cursor was unexpectedly open in ' || 
                               Ls_Context); 
                         CLOSE Corresponding_Keyvals_Cursor; 
                    END IF; 
                
                    OPEN Corresponding_Keyvals_Cursor(Psi_Entry_Id); 
                    -- Start the new WHERE and UPDATE clauses 
                    Ls_Pontis_Where := Ls_Initial_Where; 
                    Ls_User_Where   := Ls_Initial_Where; 
                
                    -- Loop through all the keyvalues for this change log entry ID 
                    <<keyval_Loop>> 
                    LOOP 
                         -- Get then next keyvalue 
                         FETCH Corresponding_Keyvals_Cursor 
                              INTO Corresponding_Keyvals_Rec; 
                         EXIT WHEN Corresponding_Keyvals_Cursor%NOTFOUND; 
                    
                         -- First time through, initialize the various INSERT components 
                         IF Ls_Pontis_Columns = Ls_Initial_Columns 
                         THEN 
                              -- This is the first loop, so start the INSERTs 
                              Ls_Pontis_Insert := 'INSERT into ' || 
                                                  Ls_Pontis_Insert_Target_Table || ' '; 
                              Ls_User_Insert   := 'INSERT into ' || 
                                                  Ls_User_Insert_Target_Table || ' '; 
                              -- Start the columns and values clauses 
                              Ls_Pontis_Columns := '( '; 
                              Ls_User_Columns   := '( '; 
                              Ls_Pontis_Values  := '( '; 
                              Ls_User_Values    := '( '; 
                              -- Hoyt 08/08/2002 For these, we only need the brkey, skip the remainder of the keys 
                         ELSIF Corresponding_Keyvals_Rec.Transfer_Key_Map_Id = 7 OR 
                               Corresponding_Keyvals_Rec.Transfer_Key_Map_Id = 8 
                         THEN 
                              EXIT; 
                         END IF; 
                    
                         -- Add the 'AND' to the WHERE clause 
                         -- (if this isn't the beginning and we don't already have one). 
                         IF Ls_Pontis_Where <> Ls_Initial_Where AND 
                            Substr(Ls_Pontis_Where, 
                                   Length(Ls_Pontis_Where) - 3, 
                                   4) <> 'AND ' 
                         THEN 
                              -- We need an AND 
                              Ls_Pontis_Where := Ls_Pontis_Where || ' AND '; 
                         END IF; 
                    
                         IF Ls_User_Where <> Ls_Initial_Where AND 
                            Substr(Ls_User_Where, 
                                   Length(Ls_User_Where) - 3, 
                                   4) <> 'AND ' 
                         THEN 
                              -- We need an AND 
                              Ls_User_Where := Ls_User_Where || ' AND '; 
                         END IF; 
                    
                         -- If this key is the BRIDGE_ID, we need to munge it for the WHERE, 
                         -- esp. convert it to a BRKEY 
                         IF Corresponding_Keyvals_Rec.Key_Name = 
                            'BRIDGE_ID' OR 
                            Corresponding_Keyvals_Rec.Key_Name = 'BRKEY' 
                         THEN 
                              -- Include BRIDGE_ID in the Pontis INSERT clause (only) 
                              IF Ls_Pontis_Insert_Target_Table = 'BRIDGE' 
                              THEN 
                                   Ls_Pontis_Columns := Ls_Pontis_Columns || 
                                                        'BRIDGE_ID, STRUCT_NUM, '; 
                                   Ls_Pontis_Values  := Ls_Pontis_Values || '''' || 
                                                        Corresponding_Keyvals_Rec.Key_Value || 
                                                        ''', ''' || 
                                                        Corresponding_Keyvals_Rec.Key_Value || 
                                                        ''', '; 
                              END IF; 
                          
                              -- The WHERE clause uses the BRKEY 
                              Corresponding_Keyvals_Rec.Key_Name := 'BRKEY'; 
                              -- Converts '0001-B0008' to '001008', 
                              Corresponding_Keyvals_Rec.Key_Value := f_Kdot_Bridge_Id_To_Brkey(Corresponding_Keyvals_Rec.Key_Value); 
                              -- Capture the BRKEY for use in the 'special handling' session below 
                              Ls_Brkey := Corresponding_Keyvals_Rec.Key_Value; 
                              -- Return the BRKEY to the calling routine, for f_set_new_xxx_data() 
                              Pso_Brkey := Ls_Brkey; 
                         END IF; 
                    
                         -- The map key thinks it's in ROADWAY but the keys are in USERRWAY 
                         IF Corresponding_Keyvals_Rec.Key_Table_Name = 
                            'ROADWAY' 
                         THEN 
                              Corresponding_Keyvals_Rec.Key_Table_Name := 'USERRWAY'; 
                         END IF; 
                    
                         -- Similarly, the map key thinks it's in USERSTRUNIT 
                         -- but the key (STRUNITLABEL) is in STRUCTURE_UNIT 
                         IF Corresponding_Keyvals_Rec.Key_Table_Name = 
                            'USERSTRUNIT' 
                         THEN 
                              Corresponding_Keyvals_Rec.Key_Table_Name := 'STRUCTURE_UNIT'; 
                         END IF; 
                    
                         /* Hoyt 08/07/2002 Obsolete since going to STRUNITKEY instead of STRUNITLABEL 
                          
                                                -- Case 2: If the strunitlabel is passed, 
                                                -- then lookup the strunitkey and apply that 
                                                if corresponding_keyvals_rec.key_name = 'STRUNITLABEL' 
                                                then 
                                                   -- Include STRUNITLABEL in the Pontis INSERT (only) 
                                                   ls_pontis_columns :=    ls_pontis_columns 
                                                                        || 'STRUNITLABEL, '; 
                                                   ls_pontis_values :=    ls_pontis_values 
                                                                       || '''' 
                                                                       || corresponding_keyvals_rec.key_value 
                                                                       || ''', '; 
                                                   -- We also need to invent a STRUNITTYPE for the Pontis INSERT 
                                                   ls_pontis_columns :=    ls_pontis_columns 
                                                                        || 'STRUNITTYPE, '; 
                                                   ls_pontis_values :=    ls_pontis_values 
                                                                       || '''1'', '; -- The most common one 
                                                   -- Convert the keyname and keyvalue to STRUNITKEY and the 
                                                   -- STRUNITKEY that corresponds to the strunitlabell 
                                                   corresponding_keyvals_rec.key_name := 'STRUNITKEY'; 
                                                   corresponding_keyvals_rec.key_value := 
                                                                                      f_strunitlabel_to_strunitkey (ls_brkey, corresponding_keyvals_rec.key_value); 
                          
                                                   if corresponding_keyvals_rec.key_value is null 
                                                   then 
                                                      -- Take the next STRUNITKEY in the sequence, for purposes of the INSERT 
                                                      begin 
                                                         select   max (strunitkey) 
                                                                + 1 -- So it is unique 
                                                           into li_strunitkey 
                                                           from structure_unit 
                                                          where brkey = ls_brkey; 
                                                      exception 
                                                         when no_data_found 
                                                         then 
                                                            -- Default to 1 
                                                            li_strunitkey := 1; 
                                                         when others 
                                                         then 
                                                            p_sql_error (   'SELECTing the STRUNITKEY for to entry_id ' 
                                                                         || psi_entry_id); 
                                                      end; 
                          
                                                      -- Somehow, we're STILL getting a NULL strunitkey sometimes 
                               if li_strunitkey is null 
                               then 
                                  li_strunitkey := 1; 
                               end if; 
                          
                               -- Assign it to the usual key_value 
                               corresponding_keyvals_rec.key_value := to_char (li_strunitkey); 
                            end if; 
                          
                            -- Return the STRUNITKEY to the calling routine for f_set_new_structure_unit_data() 
                            pso_second_key := corresponding_keyvals_rec.key_value; 
                         end if; 
                         */ 
                         -- Hoyt 08/07/2002 Capture the STRUNITKEY as it goes by! 
                         -- Allen 2002.12.17 - we need this later to build STRUNITLABEL - see change later near CHANGE CHANGE CHANGE 
                         IF Corresponding_Keyvals_Rec.Key_Name = 
                            'STRUNITKEY' 
                         THEN 
                              Pso_Second_Key := Corresponding_Keyvals_Rec.Key_Value; 
                         END IF; 
                    
                         -- Hoyt 02/27/2002 If the key_name is FEAT_CROSS_TYPE, it's on USERRWAY, not INSPEVNT 
                         IF Corresponding_Keyvals_Rec.Key_Name = 
                            'FEAT_CROSS_TYPE' 
                         THEN 
                              Corresponding_Keyvals_Rec.Key_Table_Name := 'USERRWAY'; 
                         END IF; 
                    
                         -- Wrap the value as needed in the WHERE clause, 
                         -- e.g. add surrounding apostrophes or a to_date() call. 
                         IF Ksbms_Util.f_Wrap_Data_Value(Corresponding_Keyvals_Rec.Key_Table_Name, 
                                                         Corresponding_Keyvals_Rec.Key_Name, 
                                                         Corresponding_Keyvals_Rec.Key_Value) 
                         THEN 
                              p_Sql_Error('Attempting to f_wrap_data_value in ' || 
                                          Ls_Context); -- f_wrap_data_value() failed 
                         END IF; 
                    
                         -- Does the column appear on the target table? 
                         -- Pontis version 
                         IF f_Column_Appears_On_Table(Ls_Pontis_Insert_Target_Table, 
                                                      Corresponding_Keyvals_Rec.Key_Name) 
                         THEN 
                              -- Add to the WHERE 
                              Ls_Pontis_Where := Ls_Pontis_Where || ' ' || 
                                                 Corresponding_Keyvals_Rec.Key_Name || 
                                                 ' = ' || 
                                                 Corresponding_Keyvals_Rec.Key_Value; 
                              -- Build the clauses for the INSERT 
                              Ls_Pontis_Columns := Ls_Pontis_Columns || 
                                                   Corresponding_Keyvals_Rec.Key_Name || ', '; 
                              Ls_Pontis_Values  := Ls_Pontis_Values || 
                                                   Corresponding_Keyvals_Rec.Key_Value || ', '; 
                         END IF; 
                    
                         -- User version 
                         IF f_Column_Appears_On_Table(Ls_User_Insert_Target_Table, 
                                                      Corresponding_Keyvals_Rec.Key_Name) 
                         THEN 
                              -- Add to the WHERE 
                              Ls_User_Where := Ls_User_Where || ' ' || 
                                               Corresponding_Keyvals_Rec.Key_Name || 
                                               ' = ' || 
                                               Corresponding_Keyvals_Rec.Key_Value; 
                              -- Build the clauses for the INSERT 
                              Ls_User_Columns := Ls_User_Columns || 
                                                 Corresponding_Keyvals_Rec.Key_Name || ', '; 
                              Ls_User_Values  := Ls_User_Values || 
                                                 Corresponding_Keyvals_Rec.Key_Value || ', '; 
                         END IF; 
                    
                         -- Hoyt 08/07/2002 Comment below obsolete. 
                         -- If the key_name is FEAT_CROSS_TYPE, then compute which ON_UNDER 
                         -- to include in the INSERT 
                         IF Upper(Corresponding_Keyvals_Rec.Key_Name) = 
                            'FEAT_CROSS_TYPE' 
                         THEN 
                              /* Hoyt 08/07/2002 For now, just "capture" the feat_cross_type, for application below 
                              -- Get the 'next' on_under 
                              if f_feat_cross_type_to_on_under (ls_brkey, corresponding_keyvals_rec.key_value, ls_on_under) 
                              then 
                                 p_bug ( 
                                       'Failed to get an on_under for BRKEY ' 
                                    || ls_brkey 
                                    || ' and FEAT_CROSS_TYPE ' 
                                    || corresponding_keyvals_rec.key_value 
                                 ); 
                              end if; 
                              */ 
                              -- Capture it (removing the lately-added single-quotes, else it's too large!) 
                              Ls_Feat_Cross_Type := Ksbms_Util.f_Substr(Corresponding_Keyvals_Rec.Key_Value, 
                                                                        '''', 
                                                                        ''); 
                         END IF; 
                    END LOOP Keyval_Loop; 
                
                    -- CLOSE the cursor looping through the KEYVALs for this change_log_temp record 
                    CLOSE Corresponding_Keyvals_Cursor; 
                
                    -- Special handling depending on the target table 
                
                    -- For INSPEVNTs, we need to isolate the most recent INSPDATE, 
                    -- because KDOT always operates on the most recent update 
                    IF Ls_Pontis_Insert_Target_Table = 'INSPEVNT' 
                    THEN 
                         -- We need to invent an INSPKEY for the INSERT 
                         Ls_Pontis_Columns := Ls_Pontis_Columns || 
                                              'INSPKEY, '; 
                         Ls_Inspkey        := Ksbms_Pontis_Util.Get_Pontis_Inspkey(Ls_Brkey); 
                         Ls_Pontis_Values  := Ls_Pontis_Values || '''' || 
                                              Ls_Inspkey || ''', '; 
                         Ls_User_Columns   := Ls_User_Columns || 
                                              ', INSPKEY '; 
                         Ls_User_Values    := Ls_User_Values || ', ''' || 
                                              Ls_Inspkey || ''''; 
                         -- Return the INSPKEY as the third key (order reflects f_set_new_inspevnt_data() usage) 
                         Pso_Third_Key := Ls_Inspkey; 
                         -- For INSPEVNT (as opposed to USERINSP) 
                         -- We also need to invent an INSPNAME for the INSERT 
                         Ls_Pontis_Columns := Ls_Pontis_Columns || 
                                              'INSPNAME, '; 
                         Ls_Pontis_Values  := Ls_Pontis_Values || 
                                              '''-1'', '; 
                         -- We also need to invent an INSPUSRKEY for the INSERT 
                         Ls_Pontis_Columns := Ls_Pontis_Columns || 
                                              'INSPUSRKEY, '; 
                         Ls_Pontis_Values  := Ls_Pontis_Values || '''1'', '; 
                         -- We also need to invent an INSPTYPE for the INSERT 
                         Ls_Pontis_Columns := Ls_Pontis_Columns || 
                                              'INSPTYPE, '; 
                         Ls_Pontis_Values  := Ls_Pontis_Values || '''1'', '; 
                         -- And take the createdatetime as the inspdate 
                         -- to_date( '2000-10-17 12:21:55', 'yyyy-mm-dd hh24:mi:ss') 
                         -- to_date( '2002-02-03 00:11:20'YYYY-MM-DD HH24:MI:SS' )) 
                         Ls_Pontis_Columns := Ls_Pontis_Columns || 
                                              'INSPDATE '; 
                         Ls_Inspdate       := 'to_date( ''' || 
                                              To_Char(Corresponding_Keyvals_Rec.Change_Log_Createdatetime, 
                                                      'YYYY-MM-DD HH24:MI:SS') || 
                                              ''', ''YYYY-MM-DD HH24:MI:SS'' )'; 
                         Ls_Pontis_Values  := Ls_Pontis_Values || 
                                              Ls_Inspdate; 
                         -- Return the inspdate _string_ to the calling routine, for use with f_set_new_inspevnt_data() 
                         Pso_Second_Key := Ls_Inspdate; 
                         -- The 'max( inspkey )' is required because MORE than one 
                         -- INSPEVNT can be added in a given day... <ENHANCEMENT> Check this 
                         -- Allen 10/21/2002 - check here if USERINSP needs attention too. 
                         Ls_Pontis_Where := Ls_Pontis_Where || 
                                            ' AND INSPKEY = ( ' || 
                                            ' SELECT MAX( INSPKEY ) FROM INSPEVNT WHERE BRKEY = ''' || 
                                            Ls_Brkey || 
                                            ''' AND INSPDATE = ( ' || 
                                            ' SELECT MAX( INSPDATE ) FROM INSPEVNT WHERE BRKEY = ''' || 
                                            Ls_Brkey || '''))'; 
                         -- Sometimes there is an extra AND 
                         Ls_Pontis_Where := Ksbms_Util.f_Substr(Ls_Pontis_Where, 
                                                                'AND  AND', 
                                                                'AND '); 
                         -- WER 10/21/2002: Need to handle userinsp as well 
                         Ls_User_Where := Ls_User_Where || 
                                          ' AND INSPKEY = ( ' || 
                                          ' SELECT MAX( INSPKEY ) FROM INSPEVNT WHERE BRKEY = ''' || 
                                          Ls_Brkey || 
                                          ''' AND INSPDATE = ( ' || 
                                          ' SELECT MAX( INSPDATE ) FROM INSPEVNT WHERE BRKEY = ''' || 
                                          Ls_Brkey || '''))'; 
                         -- Sometimes there is an extra AND 
                         Ls_User_Where := Ksbms_Util.f_Substr(Ls_User_Where, 
                                                              'AND  AND', 
                                                              'AND '); 
                    END IF; 
                
                    -- Special handling to compute ON_UNDER for the ROADWAY / USERRWAY INSERTs 
                    IF Ls_Pontis_Insert_Target_Table = 'ROADWAY' -- This catches USERRWAY too 
                    THEN 
                         -- Rather than depend on a hard-coded transfer key map ID, 
                         -- look for the presence of FEAT_CROSS_TYPE in the columns list 
                         -- Hoyt 08/07/2002 FEAT_CROSS_TYPE is a USERRWAY column, in ls_user_columns 
                         -- Old: if instr (ls_pontis_columns, 'FEAT_CROSS_TYPE') = 0 
                         IF Instr(Ls_User_Columns, 'FEAT_CROSS_TYPE') = 0 
                         THEN 
                              -- This must be a case where we assume the on_under to be 1 
                              Ls_On_Under := '1'; 
                              -- Hoyt 08/07/2002 NO, we set it now, now that we have the whole WHERE clause assembled 
                              -- Old comment: Otherwise, we should have set the on_under in the FEAT_CROSS_TYPE block above 
                         ELSE 
                              -- Hoyt 08/07/2002 Do we  a new on_under? It's a function of ls_feat_cross_type 
                              -- Sanity check 
                              IF f_Ns(Ls_Feat_Cross_Type) 
                              THEN 
                                   p_Bug('Error: Failed to capture ls_feat_cross_type as it went by!'); 
                                   -- ENHANCEMENT: Get out? 
                              END IF; 
                          
                              --  Get the 'next' on_under- Typically an NBI code, but may be a fixed constant if that is passed.   
                              --  Review the function f_feat_cross_type_to_on_under 
                              IF f_Feat_Cross_Type_To_On_Under(Ls_Brkey, 
                                                               Ls_Feat_Cross_Type, 
                                                               Ls_User_Where, 
                                                               Ls_On_Under) 
                              THEN 
                                   p_Bug('Failed to get an on_under for BRKEY ' || 
                                         Ls_Brkey || 
                                         ' and FEAT_CROSS_TYPE ' || 
                                         Corresponding_Keyvals_Rec.Key_Value); 
                              END IF; 
                              /* Hoyt 08/07/2002 Obsolete 
                              then 
                                 p_bug ( 
                                       'Error: doing transfer key map ID ' 
                                    || to_char (corresponding_keyvals_rec.transfer_key_map_id) 
                                    || ' and never set ls_on_under in the FEAT_CROSS_TYPE block!' 
                                 ); */ 
                         END IF; 
                    
                         -- Allen 9/17/2002 
                         --  for records with transfer key map id of 22, pretend they are on records (which they are ) by forcing ON_UNDER to 1 
                         IF Corresponding_Keyvals_Rec.Transfer_Key_Map_Id = 22 
                         THEN 
                              Ls_On_Under := '1'; 
                         END IF; 
                    
                         -- The Pontis WHERE applies to ROADWAY, we need to join with USERRWAY 
                         -- Allen 10/21/2002 note that this is used below as well for USERRWAY 
                         Ls_Pontis_Where := 'WHERE ROADWAY.brkey = ''' || 
                                            Ls_Brkey || 
                                            ''' and ROADWAY.on_under = ''' || 
                                            Ls_On_Under || ''''; 
                         -- Add the ON_UNDER to the INSERT clauses 
                         Ls_Pontis_Columns := Ls_Pontis_Columns || 
                                              'ON_UNDER '; 
                         Ls_Pontis_Values  := Ls_Pontis_Values || '''' || 
                                              Ls_On_Under || ''' '; 
                         Ls_User_Columns   := Ls_User_Columns || 
                                              'ON_UNDER '; 
                         Ls_User_Values    := Ls_User_Values || '''' || 
                                              Ls_On_Under || ''' '; 
                         -- Return the on_under for use by f_set_new_roadway_data () 
                         Pso_Second_Key := Ls_On_Under; 
                         -- RIGHT HERE - LOOK LOOK 
                         -- Allen 10/21/2002 added this to improve the WHERE clause for USERRWAY too.... 
                         --    IF corresponding_keyvals_rec.transfer_key_map_id = 22 THEN   // TESTING ONLY - APPLIES TO ALL... 
                         -- Add on_under specific code  for transfer map 22 
                         Ls_User_Where := 'WHERE USERRWAY.brkey = ''' || 
                                          Ls_Brkey || 
                                          ''' and USERRWAY.on_under = ''' || 
                                          Ls_On_Under || ''''; 
                    
                         --  END IF; 
                    
                         --- CHANGE CHANGE CHANGE CHANGE 
                         -- SPECIAL HANDLING FOR CLR_ROUTE - FIND USING PARSED OUT CONSTITUENT BITS 
                         -- CHOP UP THE CLR_ROUTE AND FIND ITS MATCHING UNDER RECORD.  REQUIRES THAT CLR_ROUTE UPDATE FOLLOW ALL ITS PARTS!!!!! 
                         --- CHANGE 
                         --   -- Allen Marshall, CS - 2007.10.2 
                         -- to address the problem that clearances applied by CLR_ROUTE for records on and under with the same CLR_ROUTE, 
                         -- we have to differentiate the where clause ON_UNDER value  by target.  Pass 5 if supposed to apply to ON, 6 if supposed to apply to UNDER 
                         -- this will handle ties where on and under have the same CLR_ROUTE as well as the old situation wher e all records have different CLR_ROUTE values. 
                    
                         -- 5 - MATCH BY CLR_ROUTE, MUST GO TO ON RECORD ONLY, ON_UNDER = '1' 
                         -- 6 - MATCH BY CLR_ROUTE, MUST GO TO UNDER RECORDS ONLY, ON_UNDER <> '1' 
                    
                         IF (Corresponding_Keyvals_Rec.Transfer_Key_Map_Id = 5 OR 
                            Corresponding_Keyvals_Rec.Transfer_Key_Map_Id = 6) AND 
                            Corresponding_Keyvals_Rec.Key_Name = 
                            'CLR_ROUTE' 
                         THEN 
                              -- end change  Allen Marshall, CS - 2007.10.4 
                          
                              -- Allen Marshall, CS - 2002.12.17 
                              -- use private local function f_evaluate_clr_route to check the clearance rout evalue for well-formedness 
                              Ls_Value_String := Corresponding_Keyvals_Rec.Key_Value; 
                          
                              -- Make sure the argument is valid 
                              IF f_Ns(Corresponding_Keyvals_Rec.Key_Value) 
                              THEN 
                                   p_Log('NULL or empty KEY VALUE  passed to f_evaluate_clr_route in ' || 
                                         Ls_Context); 
                                   p_Bug('NULL or empty KEY VALUE  passed to f_evaluate_clr_route in ' || 
                                         Ls_Context); 
                                   EXIT; -- Failed 
                              END IF; 
                          
                              -- Allen Marshall, CS - 2002.12.18 
                              -- f_evaluate_clr_route returns TRUE if bogus CLR_ROUTE string 
                              Ls_Value_String := TRIM(Ksbms_Util.f_Substr(Ls_Value_String, 
                                                                          '''', 
                                                                          NULL)); 
                          
                              IF f_Evaluate_Clr_Route(Ls_Value_String) 
                              THEN 
                                   p_Log('Malformed clearance route value encountered:  ' || 
                                         Corresponding_Keyvals_Rec.Key_Value || 
                                         ' - Review entry ID: ' || 
                                         Psi_Entry_Id); 
                                   p_Bug('In ' || Ls_Context || 
                                         ' - Malformed clearance route value encountered:  ' || 
                                         Corresponding_Keyvals_Rec.Key_Value || 
                                         ' - Review entry ID: ' || 
                                         Psi_Entry_Id); 
                                   -- BOMB OUT... 
                                   EXIT; 
                              END IF; 
                          
                              -- route looks good, keep going 
                              -- parse clr_route value and use to replace tokens in magic string variable       ls_clr_route_where           
                              /*  ls_CLR_ROUTE_WHERE VARCHAR2(200) := 
                              'route_prefix='|| ksbms_util.sq( 'XRPX' ) || 
                              ' and route_num = ' || ksbms_util.sq('XRNX') || 
                              ' and route_suffix = ' || ksbms_util.sq('XRSX') || 
                              ' and route_unique_id = ' || ksbms_util.sq('XUIX') ; -- Allen Marshall, CS - 2002.12.17 - replace the tokens in this to make a real where clause later. 
                              */ 
                              -- change 
                              -- Allen Marshall, CS - 01/23/2003 
                              -- return CLEARANCE_ROUTE - NEEDED IN CALLING ROUTINE 
                              Pso_Third_Key := Ls_Value_String; -- raw value 
                              -- change                               
                              Ls_Clr_Route_Where := REPLACE(Ls_Clr_Route_Where, 
                                                            'XRPX', 
                                                            Nvl(Substr(Ls_Value_String, 
                                                                       1, 
                                                                       1), 
                                                                '0')); 
                          
                              -- Allen Marshall, CS - 2002.12.18 -fixup to try and trap conversion error 
                              -- next one has to be made number then back to char to get rid of leading zeroes. 
                              -- ANONYMOUS BLOCK TO TRAP CONVERSION ERROR 
                              BEGIN 
                                   Ls_Clr_Route_Where := REPLACE(Ls_Clr_Route_Where, 
                                                                 'XRNX', 
                                                                 To_Char(To_Number(Nvl(Substr(Ls_Value_String, 
                                                                                              2, 
                                                                                              5), 
                                                                                       '0')))); 
                              EXCEPTION 
                                   WHEN OTHERS THEN 
                                        p_Log('Error found converting route number from zero-padded to number for CLR_ROUTE ' || 
                                              Ls_Value_String || 
                                              ' in entry id ' || 
                                              Psi_Entry_Id); 
                                        p_Bug('Substituting 0 for route number on SQL error' || 
                                              SQLCODE || 
                                              ' continuing with processing entry ID ' || 
                                              Psi_Entry_Id); 
                                        -- fixup to set route num token to 0 - MAY GENERATE BOGUS ROADWAY 
                                        Ls_Clr_Route_Where := REPLACE(Ls_Clr_Route_Where, 
                                                                      'XRNX', 
                                                                      '0'); 
                              END; 
                          
                              -- END CHANGE                   END CHANGE                    END CHANGE                     
                              Ls_Clr_Route_Where := REPLACE(Ls_Clr_Route_Where, 
                                                            'XRSX', 
                                                            Nvl(Substr(Ls_Value_String, 
                                                                       7, 
                                                                       1), 
                                                                '0')); 
                              Ls_Clr_Route_Where := REPLACE(Ls_Clr_Route_Where, 
                                                            'XUIX', 
                                                            Nvl(Substr(Ls_Value_String, 
                                                                       8, 
                                                                       1), 
                                                                '0')); 
                          
                              -- Allen Marshall, CS - 2004-02-03 
                              -- PREPEND BRKEY - otherwise, we update all bridges with the same clearance route - BAD 
                              -- FIX FOR BUG KDO-14 
                              -- BRKEY must be enquoted using the function ksbms_util.sq() 
                              -- ARM 2004-02-04 
                              -- also, need an AND as a conjunction with the clearance route criteria 
                              Ls_Clr_Route_Where := ' BRKEY = ' || 
                                                    Ksbms_Util.Sq(Ls_Brkey) || 
                                                    ' AND ' || 
                                                    Ls_Clr_Route_Where; 
                              -- BEGIN CHANGE 
                              -- ARMarshall, CS - 2007.10.02 - handle special cases of key map ID 5 and 6 where the data must be applied to either just 
                              -- on records or just under records even though most of the match is concerned with CLR_ROUTE.... 
                              --  ARMarshall, CS - 2007.10.02 - updated to just use codes 5 and 6 instead of propagating a special case via codes 55 and 66 
                          
                              IF Corresponding_Keyvals_Rec.Transfer_Key_Map_Id = 5 
                              THEN 
                                   Ls_Clr_Route_Where := Ls_Clr_Route_Where || 
                                                         ' AND  ON_UNDER = ' || 
                                                         Ksbms_Util.Sq('1'); 
                              ELSIF Corresponding_Keyvals_Rec.Transfer_Key_Map_Id = 6 
                              THEN 
                                   Ls_Clr_Route_Where := Ls_Clr_Route_Where || 
                                                         '  AND  ON_UNDER <> ' || 
                                                         Ksbms_Util.Sq('1'); 
                              END IF; 
                          
                              -- now, poke this fellow into the operating where clause for CLR_ROUTE, use for updates etc. 
                              p_Log('Clearance route for transfer_key_map_id  = ' || 
                                    To_Char(Corresponding_Keyvals_Rec.Transfer_Key_Map_Id) || 
                                    Ksbms_Util.Crlf || ' WHERE clause:  ' || 
                                    Ls_Clr_Route_Where || 
                                    ' - Generated by entry ID: ' || 
                                    Psi_Entry_Id); 
                              Ls_User_Where := '  WHERE ' || 
                                               Ls_Clr_Route_Where; -- Allen Marshall, CS - 2002.12.18 - prepend a WHERE 
                              -- END CHANGE 
                         END IF; 
                         --END CHANGE END CHANGE END CHANGE END CHANGE Allen Marshall, CS 2002.12.17 
                    END IF; 
                
                    -- Special handling for STRUCTURE_UNIT / USERSTRUNIT 
                    -- If STRUNITTYPE is not part of the INSERT, then add it (it's NOT NULLable) 
                    IF Ls_Pontis_Insert_Target_Table = 'STRUCTURE_UNIT' -- This catches <USERRWAY> too  BOGOSITY - HANDLES USERSTRUNIT 
                    THEN 
                         IF Instr(Ls_Pontis_Columns, 'STRUNITTYPE') = 0 
                         THEN 
                              Ls_Strunittype    := '_'; -- Default is underscore 
                              Ls_Pontis_Columns := Ls_Pontis_Columns || 
                                                   'STRUNITTYPE ' || ' , '; -- Allen Marshall, CS - 2002.1217 needs comma separator for column names 
                              Ls_Pontis_Values  := Ls_Pontis_Values || '''' || 
                                                   Ls_Strunittype || ''' ' || 
                                                   ' , '; -- Allen Marshall, CS - 2002.1217 needs comma separator for values 
                         END IF; 
                    END IF; 
                
                    --- CHANGE CHANGE CHANGE 
                    -- Allen Marshall, CS - 2002.12.17 - handle STRUNITLABEL !!!!  Must be unique for bridge + label combinations (cannot repeat) 
                    -- Last column so no extra commas needed in created SQL 
                    IF Ls_Pontis_Insert_Target_Table = 'STRUCTURE_UNIT' -- NOT applicable for USERSTRUNIT 
                    THEN 
                         IF Instr(Ls_Pontis_Columns, 'STRUNITLABEL') = 0 
                         THEN 
                              -- use pso_second_key which is STRUNITKEY 
                              Ls_Strunitlabel   := 'Structure Unit ' || 
                                                   Pso_Second_Key; -- Default is Structure Unit + TO_CHAR ( strunitkey , which is right now in pso_Second_key ) 
                              Ls_Pontis_Columns := Ls_Pontis_Columns || 
                                                   'STRUNITLABEL '; 
                              Ls_Pontis_Values  := Ls_Pontis_Values || '''' || 
                                                   Ls_Strunitlabel || ''' '; 
                         END IF; 
                    END IF; 
                
                    --- END CHANGE 2002.12.17 
                    -- Build the INSERTs from the fragments 
                    -- Don't do this for INSPEVNTs because we already added it above. 
                    Pso_Pontis_Insert := Ls_Pontis_Insert || 
                                         Ls_Pontis_Columns || ') values ' || 
                                         Ls_Pontis_Values || ')'; 
                    Pso_User_Insert   := Ls_User_Insert || Ls_User_Columns || 
                                         ') values ' || Ls_User_Values || ')'; 
                    -- Remove any extraneous commas 
                    Pso_Pontis_Insert := Ksbms_Util.f_Substr(Pso_Pontis_Insert, 
                                                             ', )', 
                                                             ' )'); -- comma-space-lparen 
                    Pso_Pontis_Insert := Ksbms_Util.f_Substr(Pso_Pontis_Insert, 
                                                             ',)', 
                                                             ' )'); -- comma-lparen 
                    Pso_User_Insert   := Ksbms_Util.f_Substr(Pso_User_Insert, 
                                                             ', )', 
                                                             ' )'); -- comma-space-lparen 
                    Pso_User_Insert   := Ksbms_Util.f_Substr(Pso_User_Insert, 
                                                             ',)', 
                                                             ' )'); -- comma-lparen 
                    -- This fixes a problem where INSPDATE is not included as a key to USERINSP's INSERT 
                    Pso_User_Insert := Ksbms_Util.f_Substr(Pso_User_Insert, 
                                                           ', , ', 
                                                           ', '); 
                    -- Return the WHERE clause 
                    Pso_Pontis_Where := Ls_Pontis_Where; 
                    Pso_User_Where   := Ls_User_Where; 
                    ------------------- 
                    -- Success exit 
                    ------------------- 
                
                    Lb_Failed := FALSE; 
                    EXIT Do_Once; -- Done! 
               END LOOP Do_Once; 
               -----------------------------------------------------------------           
               -- This exception handler surrounds ALL the code in this function 
               -----------------------------------------------------------------           
          EXCEPTION 
               WHEN OTHERS THEN 
                    Lb_Failed := TRUE; -- Just to be sure 
                    -- Note the failed ID (if it failed) 
                    p_Bug(Ls_Context || ' failed for entry_id ' || 
                          Psi_Entry_Id); 
                    Ksbms_Util.p_Clean_Up_After_Raise_Error(Ls_Context); 
          END Outer_Exception_Block; -- This ends the anonymous block created just to have the error handler 
      
          -- No databases were made so there's nothing to commit or rollback 
          Ksbms_Util.p_Pop(Ls_Context); 
      
          RETURN Lb_Failed; 
      
     END f_Build_Where_Clause; 

  FUNCTION f_evaluate_clr_route(the_clr_route IN VARCHAR2) RETURN BOOLEAN IS
    lb_failed     BOOLEAN := FALSE;
    ls_context    ksbms_util.context_string_type := ' f_evaluate_clr_route ()';
    ls_test_route VARCHAR2(8);
  BEGIN
    -- clr_route must match thes convnetions for length and field content
    ls_test_route := TRIM(the_clr_route);

    IF ls_test_route IS NULL THEN
      lb_failed := TRUE;
    END IF;

    IF LENGTH(ls_test_route) <> 8 THEN
      lb_failed := TRUE;
    END IF;

    IF SUBSTR(ls_test_route, 1, 1) NOT IN
       ('K', 'L', 'I', 'U', '0', 'R', 'M', 'C', 'X') THEN
      lb_failed := TRUE;
    END IF;

    IF SUBSTR(ls_test_route, 7, 1) NOT IN ('A', 'B', 'C', 'S', 'Y', '0') THEN
      lb_failed := TRUE;
    END IF;

    RETURN lb_failed;
  EXCEPTION
    WHEN OTHERS THEN
      BEGIN
        p_bug(' f_evaluate_clr_route blew up with SQLCODE: ' || SQLCODE ||
              ' and incoming CLR_ROUTE value of ' || the_clr_route);
        p_sql_error(' in ' || ls_context || ' blew up with SQLCODE: ' ||
                    SQLCODE || ' and incoming CLR_ROUTE value of ' ||
                    the_clr_route);
        RETURN TRUE; -- failed
      END;
  END f_evaluate_clr_route;

  FUNCTION f_insert_pontis_records(pio_entry_id        IN ds_change_log.entry_id%TYPE,
                                   pio_number_inserted IN OUT PLS_INTEGER)
    RETURN BOOLEAN IS
    lb_failed          BOOLEAN := TRUE; -- Until we succeed
    lb_record_is_there BOOLEAN;
    ls_context         ksbms_util.context_string_type := 'f_insert_pontis_records()';
    li_insertd_count   PLS_INTEGER := 0;
    ls_where           VARCHAR2(4000);
    ls_sql             VARCHAR2(4000);
    li_strunitkey      structure_unit.strunitkey%TYPE;
    ls_bridge_id       bridge.bridge_id%TYPE;
    ls_brkey           bridge.brkey%TYPE;
    ls_inspdate        ds_change_log.new_value%TYPE;
    ldt_inspdate       inspevnt.inspdate%TYPE;
    ls_inspkey         inspevnt.inspkey%TYPE;
    ls_on_under        roadway.on_under%TYPE;
  BEGIN
    ksbms_util.p_push(ls_context);

    <<outer_exception_block>>
    BEGIN

      <<do_once>>
      LOOP
        -- Clear the counter
        -- pio_number_inserted := 0;

        -- Select all of the INS (insert) records from CANSYS
        DECLARE
          -- Get all the merge-ready records representing inserts from CANSYS.
          -- These are merge-ready INS records from CANSYS.
          CURSOR inserts_to_process_cursor IS
            SELECT ds_change_log.entry_id                                                              entry_id,
                   ds_change_log.exchange_rule_id                                                      exchange_rule_id,
                   ds_change_log.exchange_type                                                         exchange_type,
                   ds_change_log.new_value                                                             new_value,
                   TRUNC(ds_change_log.createdatetime) createdate,
                   ds_transfer_map.table_name                                                          target_table_name,
                   ds_transfer_map.column_name                                                         target_column_name,
                   ds_transfer_key_map.table_name                                                      key_table_name,
                   ds_transfer_key_map.column_name                                                     key_column_name
              FROM ds_change_log, ds_transfer_map, ds_transfer_key_map
             WHERE ds_change_log.entry_id = pio_entry_id AND
                   ds_change_log.exchange_rule_id =
                   ds_transfer_map.exchange_rule_id AND
                   ds_transfer_key_map.transfer_key_map_id =
                   ds_transfer_map.transfer_key_map_id AND
                   ds_change_log.exchange_status = ls_insert_ready -- Allen Marshall, CS - test for INSREADY - see globals...
                   AND ds_change_log.precedence = 'FC' AND
                   ds_change_log.exchange_type = ls_insert_type
             --                    order by ds_transfer_map.table_name -- So BRIDGE is first
             ORDER BY ds_change_log.sequence_num;

          -- NOT NECESSARY...                            FOR UPDATE;

          inserts_to_process_cursor_rec inserts_to_process_cursor%ROWTYPE;
        BEGIN
          p_Log('In '|| ls_context || ', processing INS records...');
          -- Loop through all the insert change log records
          <<change_log_loop>>
          FOR inserts_to_process_cursor_rec IN inserts_to_process_cursor LOOP
            -- We always need the brkey and bridge_id from the lookup keyvals table
            IF f_brkey_and_id_from_entry_id(inserts_to_process_cursor_rec.entry_id,
                                            ls_brkey,
                                            ls_bridge_id) THEN
              EXIT do_once; -- Failed
            END IF;

            -- above cannot work for an INS - bridge does not exist
            ls_brkey := f_kdot_bridge_id_to_brkey(ls_bridge_id);

            IF inserts_to_process_cursor_rec.target_table_name = 'BRIDGE' THEN
              IF f_add_bridge(ls_brkey, ls_bridge_id) THEN
                EXIT; -- Failed
              END IF;
              -- INSPEVNT
            ELSIF inserts_to_process_cursor_rec.target_table_name =
                  'INSPEVNT' THEN
              -- Rather than hard-code, what exchange rule ID corresponds to INSPEVNT?
              -- (we only do this once).
              IF li_strunitkey = li_missing THEN
                BEGIN
                  SELECT exchange_rule_id
                    INTO li_strunitkey
                    FROM ds_transfer_map
                   WHERE UPPER(column_name) = 'INSPDATE';
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    p_sql_error('Failed to find the exchange rule for INSPDATE!');
                  WHEN OTHERS THEN
                    p_sql_error('Selecting the exchange rule for INSPDATE!');
                END;
              END IF;

              -- See if there is an inspevnt.inspdate UPDATE record for this BRKEY
              BEGIN
                SELECT new_value
                  INTO ls_inspdate
                  FROM ds_change_log
                 WHERE exchange_rule_id = li_strunitkey AND
                       exchange_type = 'UPD' AND
                       entry_id IN
                       (SELECT entry_id
                          FROM ds_lookup_keyvals
                         WHERE key_sequence_num = 1 -- Bridge ID is always 1
                               AND keyvalue = ls_bridge_id);
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  ls_inspdate := ksbms_util.f_today();
                WHEN OTHERS THEN
                  p_sql_error('Failed trying to find the INSPDATE in ' ||
                              ls_context);
              END;

              -- Convert the date string into a date type (<ENHANCEMENT> Change f_add_inspevnt()?)
              ldt_inspdate := TO_DATE(ls_inspdate, 'YYYY-MM-DD');

              -- Did we just added an INSPEVNT record, via f_add_bridge()?
              -- NB: These records are marked by a special  INSPECTCONTROLID,
              -- in f_add_bridge(), after the records are inserted.
              BEGIN
                lb_record_is_there := TRUE; -- Until the SELECT fails to find it

                SELECT inspkey
                  INTO ls_inspkey
                  FROM inspevnt
                 WHERE brkey = ls_brkey AND
                       TRUNC(createdatetime) = TRUNC(SYSDATE) AND
                       inspectcontrolid = ls_added_with_new_bridge; -- Allen Marshall, CS -01/23/2003 - det_upd used to be the tag field, too sMALL
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  lb_record_is_there := FALSE; -- No structure_unit created today
                WHEN OTHERS THEN
                  p_sql_error('Failed trying to find a INSPEVNT added with the BRIDGE in ' ||
                              ls_context);
              END;

              -- If the record is already there, then we don't need to add it
  IF lb_record_is_there THEN
  -- But we DO need to fix the INSPDATE,
  -- and also fix DET_UPD so the NEXT 'INS' works
  BEGIN
    UPDATE inspevnt
       SET det_upd = '', inspdate = ldt_inspdate
     WHERE brkey = ls_brkey AND inspkey = ls_inspkey;

    IF SQL%ROWCOUNT = 0 THEN
      RAISE no_data_affected;
    END IF;
  EXCEPTION
    WHEN no_data_affected THEN
      p_sql_error('Could not update the just-found INSPEVNT record in ' ||
                  ls_context);
    WHEN OTHERS THEN
      p_sql_error('Failed trying to UPDATE a INSPEVNT added with the BRIDGE in ' ||
                  ls_context);
  END;
ELSE
  -- The record isn't there, so add it
                IF f_add_inspevnt(ls_brkey, ldt_inspdate, ls_inspkey) THEN
                  EXIT; -- Failed
                END IF;
              END IF;
              -- STRUCTURE_UNIT
            ELSIF inserts_to_process_cursor_rec.target_table_name =
                  'STRUCTURE_UNIT' THEN
              -- See if we just added a STRUCTURE_UNIT via f_add_bridge().
              -- NB: These records are marked by a special strunitdescription,
              -- in f_add_bridge(), after the records are inserted.
              BEGIN
                lb_record_is_there := TRUE; -- Until the SELECT fails to find it

                SELECT strunitkey
                  INTO li_strunitkey
                  FROM structure_unit
                 WHERE brkey = ls_brkey AND
                       TRUNC(createdatetime) = TRUNC(SYSDATE) AND
                       strunitdescription = ls_added_with_new_bridge;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  lb_record_is_there := FALSE; -- No structure_unit created today
                WHEN OTHERS THEN
                  p_sql_error('Failed trying to find a STRUCTURE_UNIT added with the BRIDGE in ' ||
                              ls_context);
              END;

              -- If the record is already there, then we don't need to add it
  IF lb_record_is_there THEN
  -- But we DO need to fix the description, so the NEXT 'INS' works
  -- Structure Unit LABELS When Munged by this routine are always a concatenation of Structure Unit  + the unit key
  BEGIN
    UPDATE structure_unit
       SET strunitdescription = 'Structure Unit ' ||
                                TO_CHAR(li_strunitkey)
     WHERE brkey = ls_brkey AND strunitkey = li_strunitkey;

    IF SQL%ROWCOUNT = 0 THEN
      RAISE no_data_affected;
    END IF;
  EXCEPTION
    WHEN no_data_affected THEN
      p_sql_error('Could not update the just-found STRUCTURE_UNIT record in ' ||
                  ls_context);
    WHEN OTHERS THEN
      p_sql_error('Failed trying to UPDATE a STRUCTURE_UNIT added with the BRIDGE in ' ||
                  ls_context);
  END;
ELSE
  -- The record isn't there, so add it
                -- THis one increments unit key if NULL on incoming
                IF f_add_structure_unit(ls_brkey, li_strunitkey) -- IN OUT for UNITKEY
                 THEN
                  EXIT; -- Failed
                END IF;
              END IF;
              -- ROADWAY
            ELSIF inserts_to_process_cursor_rec.target_table_name =
                  'ROADWAY' THEN
              -- See if we just added a ROADWAY via f_add_bridge().
              -- NB: These records are marked by a special ROADWAY_NAME,
              -- in f_add_bridge(), after the records are inserted.
              BEGIN
                lb_record_is_there := TRUE; -- Until the SELECT fails to find it

                SELECT on_under
                  INTO ls_on_under
                  FROM roadway
                 WHERE brkey = ls_brkey AND
                       TRUNC(createdatetime) = TRUNC(SYSDATE) AND
                       roadway_name = ls_added_with_new_bridge;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  lb_record_is_there := FALSE; -- No roadway record created today
                WHEN OTHERS THEN
                  p_sql_error('Failed trying to find a ROADWAY added with the BRIDGE in ' ||
                              ls_context);
              END;

              -- If the record is already there, then we don't need to add it
  IF lb_record_is_there THEN
  -- But we DO need to fix the roadway_name, so the NEXT 'INS' works
  BEGIN
    UPDATE roadway
       SET roadway_name = ''
     WHERE brkey = ls_brkey AND on_under = ls_on_under;

    IF SQL%ROWCOUNT = 0 THEN
      RAISE no_data_affected;
    END IF;
  EXCEPTION
    WHEN no_data_affected THEN
      p_sql_error('Could not update the just-found ROADWAY record in ' ||
                  ls_context);
    WHEN OTHERS THEN
      p_sql_error('Failed trying to UPDATE a ROADWAY added with the BRIDGE in ' ||
                  ls_context);
  END;
ELSE
  -- The record isn't there, so add it
                IF f_add_roadway(ls_brkey, ls_on_under) THEN
                  EXIT; -- Failed
                END IF;
              END IF;
            END IF;

            -- Delete entries from the change log and keyvals
            IF f_delete_from_log_and_keyvals(inserts_to_process_cursor_rec.entry_id) THEN
              EXIT;
            END IF;

            -- Keep track of the count
            pio_number_inserted := pio_number_inserted + 1;
          END LOOP change_log_loop;
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
      WHEN OTHERS THEN
        lb_failed := TRUE; -- Just to be sure
        ksbms_util.p_clean_up_after_raise_error(ls_context);
    END outer_exception_block; -- This ends the anonymous block created just to have the error handler

    -- Note our effect (if any)

    pl(TO_CHAR(li_insertd_count) || ' Pontis records were insertd');
    ksbms_util.p_pop(ls_context);
    -- Save the changes (or not)
    RETURN f_commit_or_rollback(lb_failed, ls_context);
  END f_insert_pontis_records;

  -- Sets the DS_CHANGE_LOG.EXCHANGE_STATUS = '<DELETE>'
  -- so we can delete it at the conclusion of f_update_pontis_records().
  FUNCTION f_mark_log_keyvals_for_delete(pls_entry_id ds_change_log.entry_id%TYPE)
    RETURN BOOLEAN IS
    lb_failed  BOOLEAN := TRUE; -- Until we succeed
    ls_context ksbms_util.context_string_type := 'f_mark_log_keyvals_for_delete()';
  BEGIN
    ksbms_util.p_push(ls_context);

    <<outer_exception_block>>
    BEGIN

      <<do_once>>
      LOOP
        -- Set the EXCHANGE_STATUS to <DELETE>
        BEGIN
          UPDATE ds_change_log
             SET exchange_status = ls_delete
           WHERE entry_id = pls_entry_id;
--          COMMIT;    -- This commit commented out for 9i
          IF SQL%ROWCOUNT = 0 THEN
            RAISE no_data_affected;
          END IF;
          COMMIT;
        EXCEPTION
          WHEN no_data_affected THEN
            p_sql_error('No data affected when attempting UPDATE change log to mark as DELETE-able entry_id ''' ||
                        pls_entry_id || '''');
          WHEN OTHERS THEN
            p_sql_error('Attempting UPDATE change log to mark as DELETE-able entry_id ''' ||
                        pls_entry_id || '''');
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
      WHEN OTHERS THEN
        lb_failed := TRUE; -- Just to be sure
        ksbms_util.p_clean_up_after_raise_error(ls_context);
    END outer_exception_block; -- This ends the anonymous block created just to have the error handler

    -----------------------------------------------------------------
    -- Put any clean-up code that munges on the database here
    -----------------------------------------------------------------

    ksbms_util.p_pop(ls_context);
    -- Save the changes (or not)
    RETURN f_commit_or_rollback(lb_failed, ls_context);
  END f_mark_log_keyvals_for_delete;

  -- Deletes the DS_LOOKUP_KEYVALS record(s) and (then) the DS_CHANGE_LOG record
  -- corresponding to the passed entry ID. f_delete_from_log_and_keyvals() will
  -- raise an exception if either table does not have a corresponding record.
  FUNCTION f_delete_from_log_and_keyvals(psi_entry_id IN ds_change_log.entry_id%TYPE)
    RETURN BOOLEAN IS
    lb_failed  BOOLEAN := TRUE; -- Until we succeed
    ls_context ksbms_util.context_string_type := 'f_delete_from_log_and_keyvals()';
  BEGIN
    ksbms_util.p_push(ls_context);

    <<outer_exception_block>>
    BEGIN

      <<do_once>>
      LOOP
        -- Delete the keyvals record(s) corresponding to the passed entry ID
        BEGIN
          DELETE FROM ds_lookup_keyvals WHERE entry_id = psi_entry_id;

          IF SQL%ROWCOUNT = 0 THEN
            RAISE no_data_affected;
          END IF;
        EXCEPTION
          WHEN no_data_affected THEN
            p_sql_error('Failed to find any KEY VALUES records to DELETE! in ' ||
                        ls_context);
          WHEN OTHERS THEN
            p_sql_error('DELETing KEY VALUES records in ' || ls_context);
        END;

        -- Delete the change log record corresponding to the passed entry ID
        BEGIN
          DELETE FROM ds_change_log WHERE entry_id = psi_entry_id;

          IF SQL%ROWCOUNT = 0 THEN
            RAISE no_data_affected;
          END IF;
        EXCEPTION
          WHEN no_data_affected THEN
            p_sql_error('Failed to find the CHANGE LOG record to DELETE in ' ||
                        ls_context);
          WHEN OTHERS THEN
            p_sql_error('DELETing CHANGE LOG records in ' || ls_context);
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
      WHEN OTHERS THEN
        lb_failed := TRUE; -- Just to be sure
        ksbms_util.p_clean_up_after_raise_error(ls_context);
    END outer_exception_block; -- This ends the anonymous block created just to have the error handler

    ksbms_util.p_pop(ls_context);
    -- Save the changes (or not)
    RETURN f_commit_or_rollback(lb_failed, ls_context);
  END f_delete_from_log_and_keyvals;

  FUNCTION f_brkey_and_id_from_entry_id(psi_entry_id  IN ds_change_log.entry_id%TYPE,
                                      pso_brkey     OUT bridge.brkey%TYPE,
                                      pso_bridge_id OUT bridge.bridge_id%TYPE)
  RETURN BOOLEAN IS
  lb_failed  BOOLEAN := TRUE; -- Until we succeed
  ls_context ksbms_util.context_string_type := 'f_brkey_and_id_from_entry_id()';
BEGIN
  ksbms_util.p_push(ls_context);

  <<outer_exception_block>>
  BEGIN

  <<do_once>>
  LOOP
  -- In every case, we need the Bridge ID and BRKEY
  -- Get the bridge_id from lookup keyvals
  BEGIN
    SELECT keyvalue
      INTO pso_bridge_id
      FROM ds_lookup_keyvals
     WHERE entry_id = psi_entry_id AND keyname = 'BRIDGE_ID';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      p_sql_error('Failed to find the Bridge ID for entry ID ''' ||
                  pso_bridge_id || ''' in ' || ls_context);
    WHEN OTHERS THEN
      p_sql_error('Failed trying to find the Bridge ID for entry ''' ||
                  pso_bridge_id || ''' in ' || ls_context);
  END;

  pso_brkey := ksbms_pontis_util.f_get_brkey_from_bridge_id(pso_bridge_id);

  -- Allen Marshall, CS - 01/22/2003  - added to message
  IF pso_brkey IS NULL THEN
  p_bug('INSERT - Failed to get the brkey from ds_lookup_keyvals is for entry ''' ||
        pso_bridge_id || ''' in ' || ls_context);
  -- NOT  A FAILURE, THOUGH - WE'll synthesize it
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
      WHEN OTHERS THEN
        lb_failed := TRUE; -- Just to be sure
        ksbms_util.p_clean_up_after_raise_error(ls_context);
    END outer_exception_block; -- This ends the anonymous block created just to have the error handler

    ksbms_util.p_pop(ls_context);
    RETURN lb_failed;
  END f_brkey_and_id_from_entry_id;

  FUNCTION f_column_appears_on_table(psi_table_name  IN SYS.all_tab_columns.table_name%TYPE,
                                   psi_column_name IN SYS.all_tab_columns.column_name%TYPE)
  RETURN BOOLEAN IS
  lb_failed                  BOOLEAN := TRUE; -- Until we succeed
  lb_column_appears_on_table BOOLEAN := FALSE; -- Until we confirm it is there
  ls_context                 ksbms_util.context_string_type := 'f_column_appears_on_table()';
  ls_table_name              SYS.all_tab_columns.table_name%TYPE := 'NOTFOUND';
BEGIN
  ksbms_util.p_push(ls_context);

  <<outer_exception_block>>
  BEGIN

  <<do_once>>
  LOOP
  BEGIN
  SELECT table_name
    INTO ls_table_name
    FROM SYS.all_tab_columns
   WHERE table_name = psi_table_name AND
         column_name = psi_column_name;

  -- If we hit this, then we found the column
  lb_column_appears_on_table := TRUE;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
  -- Expected when the column doesn't appear on the table
            lb_column_appears_on_table := FALSE;
          WHEN OTHERS THEN
            p_sql_error('Selecting from all_table_columns for table ' ||
                        psi_table_name || ' and column ' ||
                        psi_column_name);
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
      WHEN OTHERS THEN
        lb_failed := TRUE; -- Just to be sure
        ksbms_util.p_clean_up_after_raise_error(ls_context);
    END outer_exception_block; -- This ends the anonymous block created just to have the error handler

    ksbms_util.p_pop(ls_context);
    RETURN lb_column_appears_on_table;
  END f_column_appears_on_table;

  FUNCTION f_get_the_associated_table(psi_first_table IN VARCHAR2)
    RETURN VARCHAR2 IS
    ls_first_table      VARCHAR2(100);
    ls_associated_table VARCHAR2(100);
  BEGIN
    ls_first_table := UPPER(TRIM(psi_first_table));

    IF ls_first_table = 'BRIDGE' THEN
      ls_associated_table := 'USERBRDG';
    ELSIF ls_first_table = 'USERBRDG' THEN
      ls_associated_table := 'BRIDGE';
    ELSIF ls_first_table = 'INSPEVNT' THEN
      ls_associated_table := 'USERINSP';
    ELSIF ls_first_table = 'USERINSP' THEN
      ls_associated_table := 'INSPEVNT';
    ELSIF ls_first_table = 'ROADWAY' THEN
      ls_associated_table := 'USERRWAY';
    ELSIF ls_first_table = 'USERRWAY' THEN
      ls_associated_table := 'ROADWAY';
    ELSIF ls_first_table = 'STRUCTURE_UNIT' THEN
      ls_associated_table := 'USERSTRUNIT';
    ELSIF ls_first_table = 'USERSTRUNIT' THEN
      ls_associated_table := 'STRUCTURE_UNIT';
    ELSE
      p_bug('Unexpected ''First Table'' in f_get_the_associated_table()');
      ls_associated_table := 'UNKNOWN!';
    END IF;

    RETURN ls_associated_table;
  END f_get_the_associated_table;

  FUNCTION f_archive_cansys_applied RETURN BOOLEAN IS
  PRAGMA AUTONOMOUS_TRANSACTION;
  lb_failed            BOOLEAN := TRUE; -- Until we succeed
  ls_context           ksbms_util.context_string_type := 'f_archive_cansys_applied()';
  li_number_rows_moved PLS_INTEGER;
BEGIN
  ksbms_util.p_push(ls_context);

  <<outer_exception_block>>
  BEGIN

  <<do_once>>
  LOOP
  BEGIN
  -- Move any APPLIED records from the CANSYS change log
  li_number_rows_moved := 0;

  FOR irec IN (SELECT entry_id, exchange_status, ROWID
                 FROM ds_change_log_c) LOOP
    -- check each record, if a match to cs_sendtoarchive for exchange_status , move over to archive
    IF INSTR(cs_sendtoarchive, irec.exchange_status) > 0 THEN
      -- Records from Pontis that CANSYS has successfully applied
      -- Allen Marshall, CS - 2003.01.14 - used to be just ls_applied exchange_status move all matching types to archive - fix this later to be table driven
      BEGIN
        INSERT INTO ds_change_log_archive b
         -- Take the records directly from CANSYS's ds_change_log
          (SELECT a.entry_id,
        a.sequence_num,
        gs_job_id,
        ls_pontis_schema, -- Meaning it ORIGINATED in Pontis
        NVL(a.exchange_rule_id, -1),
        NVL(a.exchange_type, '*'),
        NVL(a.old_value, '*'),
        NVL(a.new_value, '*'),
        NVL(a.exchange_status, '*'),
        SYSDATE, -- Per Allen's 3/13/2002 e-mail
                  a.createuserid,
                  a.remarks
             FROM ds_change_log_c a
            WHERE a.ROWID = irec.ROWID);

/*        p_log('Moved entry id # ' || irec.entry_id ||
              ksbms_util.crlf);
*/
      li_number_rows_moved := li_number_rows_moved + SQL%ROWCOUNT; -- should be 1
      COMMIT;

      EXCEPTION
        WHEN OTHERS THEN
          BEGIN
            ROLLBACK;
            p_sql_error('Inserting CANSYS change log records with exchange_status ' ||
                        ls_applied ||
                        ' into the change log archive');
          END;
      END;

      --- move the keyvals too, but only if they match a good entry_id
      BEGIN
        INSERT INTO ds_lookup_keyvals_archive e
          (SELECT d.entry_id,
                  d.keyvalue,
                  d.key_sequence_num,
                  NVL(d.createdatetime, SYSDATE),
                  NVL(d.createuserid, 'KSBMS_ROBOT')
             FROM ds_lookup_keyvals_c d
            WHERE d.entry_id = irec.entry_id);

     COMMIT;

     EXCEPTION
        WHEN OTHERS THEN
          BEGIN
            ROLLBACK;

            p_sql_error('Inserting CANSYS key value records (with exchange status APPLIED) into the archive');
          END;
      END;
    END IF;
  END LOOP;

  COMMIT; -- Commit locally! Early and often!!
  ksbms_util.p_log(ls_context || ' moved ' -- Since we're deleting them shortly
                           || TO_CHAR(li_number_rows_moved) ||
                           ' APPLIED or DELREADY/INSREADY records from the CANSYS change log into the change log archive');
        EXCEPTION
          WHEN OTHERS THEN
            ROLLBACK;
            p_sql_error('Error encountered while archiving CANSYS ');
            EXIT;
        END;

        /*-- Move the corresponding CANSYS KEYVALS records into the archive
                            IF li_number_rows_moved > 0
                            THEN
                                 BEGIN

                                 \* Allen Marshall, CS - 01/23/2003 - Reported NOT ALL VARIABLES BOUND ERROR HERE - changed to use EXISTS logic  to see if this helps*\
                                      INSERT INTO ds_lookup_keyvals_archive
                                           (SELECT a.entry_id, a.keyvalue,
                                                   a.key_sequence_num, NVL(a.createdatetime, SYSDATE),
                                                   NVL(a.createuserid,'KSBMS_ROBOT')
                                              FROM ds_lookup_keyvals_c a
                                     \*        WHERE entry_id IN (
                                      *\
                                               WHERE EXISTS(
                                                        SELECT b.entry_id
                                                          FROM ds_change_log_c b
                                                          WHERE
                                                          b.entry_id = a.entry_id
                                                           AND ( INSTR(  cs_sendtoarchive, b.exchange_status ) > 0 ) )); -- Allen Marshall, CS - 2003.01.14 - move all matching types to archive - fix this later to be table driven
        \*                                                 WHERE exchange_status =
                                                                            'APPLIED')); -- ls_applied fails here?!
                                                                            *\

                                      COMMIT; -- Commit locally! Early and often!!

                                      IF SQL%ROWCOUNT = 0
                                      THEN
                                           RAISE no_data_affected;
                                      END IF;

                                      ksbms_util.p_log (   ls_context
                                                        || ' inserted '
                                                        || TO_CHAR (SQL%ROWCOUNT)
                                                        || ' CANSYS lookup keyvals records with exchange_status '
                                                        || ls_applied
                                                        || ' into the key values archive'
                                                       );
                                 EXCEPTION
                                      WHEN no_data_affected
                                      THEN
                                           p_sql_error ('No CANSYS key values records (with exchange status APPLIED) inserted into the archive!'
                                                       );
                                      WHEN OTHERS
                                      THEN
                                           p_sql_error ('Inserting CANSYS key value records (with exchange status APPLIED) into the archive'
                                                       );
                                 END;
                            END IF;

        */

        -- Delete all the APPLIED records from ds_change_log_c;
        -- Referential integrity will take care of the keyvals records.
        BEGIN
          DELETE FROM ds_change_log_c
           WHERE (INSTR(cs_sendtoarchive, exchange_status) > 0); --ls_applied;
          -- Allen Marshall, CS - 2003.01.14 - delete all moved records now in archive from ds_change_log - fix this later to be table driven

          COMMIT; -- Commit locally! Early and often!!
        EXCEPTION
          WHEN OTHERS THEN
            ROLLBACK;
            p_sql_error('Failed to DELETE the APPLIED records from ds_change_log_c');
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
      WHEN OTHERS THEN
        ROLLBACK;
        lb_failed := TRUE; -- Just to be sure
        ksbms_util.p_clean_up_after_raise_error(ls_context);
    END outer_exception_block; -- This ends the anonymous block created just to have the error handler

    -----------------------------------------------------------------
    -- Put any clean-up code that munges on the database here
    -----------------------------------------------------------------

    ksbms_util.p_pop(ls_context);
    -- Save the changes (or not)
    RETURN lb_failed;
  END f_archive_cansys_applied;

  -- This function is used to populate ds_change_log_c,
  -- so there are records suitable for testing f_archive_cansys_applied
  FUNCTION f_move_applied_from_archive RETURN BOOLEAN IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    lb_failed            BOOLEAN := TRUE; -- Until we succeed
    ls_context           ksbms_util.context_string_type := 'f_move_applied_from_archive()';
    li_number_rows_moved PLS_INTEGER;
    ls_keyname           ds_lookup_keyvals.keyname%TYPE := 'KEYNAME';
  BEGIN
    ksbms_util.p_push(ls_context);

    <<outer_exception_block>>
    BEGIN

      <<do_once>>
      LOOP
        BEGIN
        -- Move all the APPLIED records from the ARCHIVE into the CANSYS change log
        INSERT INTO ds_change_log_c
         -- Take the records from the ARCHIVE
          (SELECT entry_id,
                  sequence_num,
                  exchange_rule_id,
                  exchange_type,
                  old_value,
                  new_value,
                  exchange_status,
                  'FP',
                  createdatetime,
                  createuserid,
                  remarks
             FROM ds_change_log_archive
            WHERE exchange_status = ls_applied); -- APPLIED only, so f_archive_cansys_applied() will find them!
--        COMMIT;   -- This commit commented out for 9i
        li_number_rows_moved := SQL%ROWCOUNT;

        ksbms_util.p_log(ls_context || ' moved ' -- Since we're deleting them shortly
                     || TO_CHAR(li_number_rows_moved) ||
                     ' APPLIED records from the change log archive into the CANSYS change log');
        COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      p_sql_error('Inserting APPLIED records from the change log archive into the CANSYS change log');
  END;

  -- Move the corresponding CANSYS KEYVALS records FROM the archive
  IF li_number_rows_moved > 0 THEN
  BEGIN
  INSERT INTO ds_lookup_keyvals_c
    (SELECT entry_id,
            ls_keyname, -- NB: Bogus because ARCHIVE does not CONTAIN the KEYHAME!
            keyvalue,
            key_sequence_num,
            createdatetime,
            createuserid
       FROM ds_lookup_keyvals_archive
      WHERE entry_id IN
            (SELECT entry_id
               FROM ds_change_log_archive
              WHERE exchange_status = ls_applied));

--  COMMIT;   -- This commit commented out for 9i

  IF SQL%ROWCOUNT = 0 THEN
    RAISE no_data_affected;
  END IF;

  ksbms_util.p_log(ls_context || ' moved ' -- Since we're deleting them shortly
                             || TO_CHAR(SQL%ROWCOUNT) ||
                             ' CANSYS records with exchange_status ' ||
                             ls_applied ||
                             ' FROM the key values archive into ds_lookup_keyvals_c');
  COMMIT;
          EXCEPTION
            WHEN no_data_affected THEN
              p_sql_error('No CANSYS key values records (with exchange status APPLIED) inserted FROM the archive!');
            WHEN OTHERS THEN
              p_sql_error('Inserting CANSYS key value records (with exchange status APPLIED) FROM the archive');
          END;
        END IF;

        -- Delete all the APPLIED records from the archive, so they can be re-inserted;
        -- Referential integrity will take care of the keyvals records.
        BEGIN
          -- Hoyt 03/20/2002 This is needed until the RI is in place
          DELETE FROM ds_lookup_keyvals_archive
           WHERE entry_id IN
                 (SELECT entry_id
                    FROM ds_change_log_archive
                   WHERE exchange_status = ls_applied);

          DELETE FROM ds_change_log_archive
           WHERE exchange_status = ls_applied;

          COMMIT; -- Commit locally! Early and often!!
        EXCEPTION
          WHEN OTHERS THEN
            p_sql_error('Failed to DELETE the APPLIED records from ds_change_log_c');
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
      WHEN OTHERS THEN
        lb_failed := TRUE; -- Just to be sure
        ksbms_util.p_clean_up_after_raise_error(ls_context);
    END outer_exception_block; -- This ends the anonymous block created just to have the error handler

    -----------------------------------------------------------------
    -- Put any clean-up code that munges on the database here
    -----------------------------------------------------------------

    ksbms_util.p_pop(ls_context);
    -- Save the changes (or not)
    RETURN lb_failed;
  END f_move_applied_from_archive;

  FUNCTION f_uninitialized_keymatch_cols(ls_pontis_target_table IN user_tab_columns.table_name%TYPE, -- the table
                                       ls_brkey               IN bridge.brkey%TYPE, -- the bridge
                                       ls_second_key          IN VARCHAR2, -- on_under or STRUNITKEY
                                       ls_third_key           VARCHAR2) -- INSPKEY
 RETURN BOOLEAN IS
  ls_sqlstring VARCHAR2(4000);
  ls_context   ksbms_util.context_string_type := 'f_uninitialized_keymatch_cols()';
BEGIN
  ksbms_util.p_push(ls_context); -- put func on stack of calls Allen Marshall, CS - 01/23/2003

  IF ls_pontis_target_table = 'BRIDGE' OR
   ls_pontis_target_table = 'USERBRDG' THEN
  ls_sqlstring := 'SELECT 1 FROM ' || ls_pontis_target_table ||
                  ' where brkey = ' || ksbms_util.sq(ls_brkey);
  ls_sqlstring := ls_sqlstring || ' AND INSTR( NOTES,' ||
                  ksbms_util.sq(cs_uninitializedkeys) || ',1) > 0';
ELSIF ls_pontis_target_table = 'INSPEVNT' OR
      ls_pontis_target_table = 'USERBRDG' THEN
  -- use ls_third_key
  ls_sqlstring := 'SELECT 1 FROM ' || ls_pontis_target_table ||
                  ' where brkey = ' || ksbms_util.sq(ls_brkey) ||
                  ' AND INSPKEY = ' || ksbms_util.sq(ls_third_key);
  ls_sqlstring := ls_sqlstring || ' AND INSTR( NOTES,' ||
                  ksbms_util.sq(cs_uninitializedkeys) || ',1) > 0';
ELSIF ls_pontis_target_table = 'ROADWAY' OR
      ls_pontis_target_table = 'USERRWAY' THEN
  -- use ls_second_key
  ls_sqlstring := 'SELECT 1 FROM ' || ls_pontis_target_table ||
                  ' where brkey = ' || ksbms_util.sq(ls_brkey) ||
                  ' AND ON_UNDER = ' || ksbms_util.sq(ls_second_key);
  ls_sqlstring := ls_sqlstring || ' AND INSTR( NOTES,' ||
                  ksbms_util.sq(cs_uninitializedkeys) || ',1) > 0';
ELSIF ls_pontis_target_table = 'STRUCTURE_UNIT' OR
      ls_pontis_target_table = 'USERSTRUNIT' THEN
  -- use ls_second_key, UNQUOTED
  ls_sqlstring := 'SELECT 1 FROM ' || ls_pontis_target_table ||
                  ' where brkey = ' || ksbms_util.sq(ls_brkey) ||
                  ' AND STRUNITKEY = ' || ls_second_key;
  ls_sqlstring := ls_sqlstring || ' AND INSTR( NOTES,' ||
                  ksbms_util.sq(cs_uninitializedkeys) || ',1) > 0';
ELSE
  -- give up
  -- Allen Marshall, CS - 01/;23/2003
  p_sql_error('Invalid table name: ' ||
              NVL(ls_pontis_target_table, 'NULL TABLE NAME') ||
              ' passed to ' || ls_context); --f_unitialized_keymatch_cols'
    END IF;

    -- Is TRUE if any rows exists
    ksbms_util.p_pop(ls_context); -- clear stack
    RETURN ksbms_util.f_any_rows_exist(ls_sqlstring);
  END f_uninitialized_keymatch_cols;

  FUNCTION f_template RETURN BOOLEAN IS
    lb_failed  BOOLEAN := TRUE; -- Until we succeed
    ls_context ksbms_util.context_string_type := 'f_template()';
  BEGIN
    ksbms_util.p_push(ls_context);

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
      WHEN OTHERS THEN
        lb_failed := TRUE; -- Just to be sure
        ksbms_util.p_clean_up_after_raise_error(ls_context);
    END outer_exception_block; -- This ends the anonymous block created just to have the error handler

    -----------------------------------------------------------------
    -- Put any clean-up code that munges on the database here
    -----------------------------------------------------------------

    ksbms_util.p_pop(ls_context);
    -- Save the changes (or not)
    RETURN ksbms_util.f_commit_or_rollback(lb_failed, ls_context);
  END f_template;
/*
--CVS LOG
-- $Log: ksbms_apply_changes.pck,v $
-- Revision 1.24  2003/04/14 18:03:28  arm
-- Allen Marshall, CS - 2003.04.14 - in f_delete_pontis_records, now does not LOG inside the for loop processing DEL directives, and does not use FOR UPDATE for that cursor either.  Also, fixups of DEL records to EXCHANGE_STATUS <DELETE> now occur outside the looping transactions
--
-- Revision 1.23  2003/04/14 17:24:02  arm
-- Allen Marshall, CS - 2003.04.14 - added log messages, verified push/pop in f_delete_pontis_records()....
--
-- Revision 1.21  2003/04/12 18:06:57  arm
-- Allen Marshall, CS - 2003.04.12 - trimmed length of ID string to fit message line limit.
--
-- Revision 1.20  2003/04/12 17:41:29  arm
-- Allen Marshall, CS - 2003.04.12 - added log to documentation area, finalized cvs stamping in code. From now on, to release, commit changes, then update files with get clean copy, load and compile and deliver - this ensures the CVS ID gets into the source code for the package.
--
*/
  PROCEDURE documentation IS
  BEGIN
    -- ENTER IN REVERSE CHRONOLOGICAL ORDER, PLEASE

    ksbms_util.pl('PACKAGE KSBMS_APPLY_CHANGES - Synchronizer package to fire changes from DS_CHANGE_LOG into Pontis database');
    ksbms_util.pl('CVS ID: $Id: ksbms_apply_changes.pck,v 1.24 2003/04/14 18:03:28 arm Exp $ '); -- cvs KEYWORDS - DO NOT UPDATE

    ksbms_util.pl( 'Revision History:');
    ksbms_util.pl('ARM, CS - 02/04/2004 - in f_build_where_clause, at line 4817 or so, added BRKEY criteria to the where clause for key map types 5 or 6 - clearances');
    ksbms_util.pl('ARM, CS - 04/12/2003 - added timestamp and cvs archive ID for package to the e-mail');
    ksbms_util.pl('ARM, CS - 04/07/2003 - updated f_update_pontis() slightly to track original EXCHANGE_STATUS better');
    ksbms_util.pl('ARM, CS - 04/02/2003 - allowed INSREADY records to goto the archive table');
    ksbms_util.pl('ARM, CS - 02/04/2003 -  in f_update_pontis_records(), now marks rows in DS_CHANGE_LOG that were merged but failed UPD as FAILED - leaves them there for later review...');
    ksbms_util.pl('ARM, CS - 01/23/2003 - revised magic string NEWUNINITIALIZEDKEYS to use constant cs_uninitializedkeys - put in starter records without coordinating fields yet filled right');
    ksbms_util.pl('ARM, CS - 01/17/2003 - ALl Stack Trace calls (passing ls_context or argument psi_context) now use the anchored context_string_type from ksbms_util.  Prevent too small buffer problem');
    ksbms_util.pl('ARM, CS - 01/14/2003 - changed constant string cs_sendtoarchive from anchored type to plain old VARCHAR2 - was blowing up! when set to ds_change_log.exchange_status%TYPE!!!  ');
    ksbms_util.pl('ARM, CS - 01/14/2003 - in f_archive_cansys_applied(), changed archiving logic to not just send APPLIED records but INSREADY and DELREADY ( INSTR(  cs_sendtoarchive, exchange_status ) > 0 ) ');
    ksbms_util.pl(' The INSREADY and DELREADY entries are saved purely for documentation reasons and are not in fact applied in 1.0');
    ksbms_util.pl('ARM, CS - 12/20/2002   f_set_new_structure_data() - revised defaults here (YEARBUILT=1000) per discussion agreement with KDOT staff (Deb Kossler)');
    ksbms_util.pl('ARM, CS - 12/19/2002 -major changes to f_Feat_cross_type_to_on_Under - recodes 2 to A if possible, gens random on_under if needed for many routes under situation');
    ksbms_util.pl('ARM, CS - 12/19/2002   f_set_new_inspevnt_data() - revised defaults here per discussion agreement with KDOT staff (Deb Kossler)');
    ksbms_util.pl('ARM, CS - 12/18/2002 -fixup to try and trap conversion error in f_build_where_clause()');
    ksbms_util.pl('ARM, CS - 12/17/2002 - in f_build_where_clause, handled STRUNITLABEL !!!!  Must be unique for bridge + label combinations (cannot repeat)');
    ksbms_util.pl('ARM, CS - 12/17/2002 - in f_build_where_clause, handled CLR_ROUTE UNIQUE WEIRDNESS - CLR_ROUTE CHANGES MUST BE WELLFORMED AND');
    ksbms_util.pl(' must follow initialization of ROUTE_PREFIX, ROUTE_NUM, ROUTE_SUFFIX, AND ROUTE_UNIQUE_ID');
    ksbms_util.pl('ARM, CS - 12/16/2002 - added documentation procedure to this package');
    ksbms_util.pl('ARM, CS - 12/16/2002 - revised f_add_structure_unit to handle multiple units sequentially numbered better.  Uses MAX+1 to find next unit for insert');
    ksbms_util.pl('ARM, CS - 12/16/2002 - revised f_add_xxx functions to embed magic string NEWUNINITIALIZEDKEYS in starter records without coordinating fields yet filled right');
    ksbms_util.pl('ARM, CS - 12/16/2002 - revised f_update_pontis_records to allow a first upate to starter records with coordinating fields not  yet filled like ROUTE_PREFIX');
  END;
/*
   describe all_objects;
Name           Type         Nullable Default Comments
-------------- ------------ -------- ------- ----------------------------------------------------------------------------
OWNER          VARCHAR2(30)                  Username of the owner of the object
OBJECT_NAME    VARCHAR2(30)                  Name of the object
SUBOBJECT_NAME VARCHAR2(30) Y                Name of the sub-object (for example, partititon)
OBJECT_ID      NUMBER                        Object number of the object
DATA_OBJECT_ID NUMBER       Y                Object number of the segment which contains the object
OBJECT_TYPE    VARCHAR2(18) Y                Type of the object
CREATED        DATE                          Timestamp for the creation of the object
LAST_DDL_TIME  DATE                          Timestamp for the last DDL change (including GRANT and REVOKE) to the object
TIMESTAMP      VARCHAR2(19) Y                Timestamp for the specification of the object
STATUS         VARCHAR2(7)  Y                Status of the object
TEMPORARY      VARCHAR2(1)  Y                Can the current session only see data that it placed in this object itself?
GENERATED      VARCHAR2(1)  Y                Was the name of this object system generated?
SECONDARY      VARCHAR2(1)  Y                Is this a secondary object created as part of icreate for domain indexes?

SQL> select object_id from all_objects where object_name='KSBMS_APPLY_CHANGES';
*/

BEGIN
  NULL;
  -- Clear these out every time the package runs, else it accumulates!
  ksbms_util.p_clear_sql_error;
  ksbms_util.p_clear_email_msg;
  -- Initialize the global that corresponds to compile time for the package body - date variable
  select NVL(  last_ddl_time,SYSDATE) INTO gd_package_release_date from all_objects
  where object_name='KSBMS_APPLY_CHANGES' and object_type = 'PACKAGE BODY';
  --gs_package_cvs_archive_id := '1.17'; -- TAKE FROM CVS WINDOW AFTER COMMIT;
END ksbms_apply_changes;
/