CREATE OR REPLACE PACKAGE BODY pontis."KSBMS_PONTIS" IS
  -- Last modified 02/28/2002 on Emperor
  -- Hoyt 09/03/2002 Changed on_under = '1' to on_under = '22' per NAC's e-mail

  ------------------ Magic Strings ----------------
  ls_missing    CONSTANT VARCHAR2(9) := '<MISSING>';
  ls_restricted CONSTANT VARCHAR2(10) := '<RESTRCTD>';
  ls_insert     CONSTANT VARCHAR2(3) := 'INS'; -- 1/10/2002
  ls_delete     CONSTANT VARCHAR2(3) := 'DEL'; -- 1/10/2002
  ls_update     CONSTANT VARCHAR2(6) := 'UPD';
  ls_message    CONSTANT VARCHAR2(3) := 'MSG';
  -- Hoyt 01/11/2002 Changed 'NEWUPD' to 'UPD' (to conform to expectations)
  ls_new_update        CONSTANT VARCHAR2(6) := 'UPD'; -- Was 'NEWUPD'
  ls_apply_changes     CONSTANT VARCHAR2(2) := 'AC';
  ls_restricted_status CONSTANT VARCHAR2(1) := 'Y';
  ls_crlf              CONSTANT VARCHAR2(2) := CHR(13) || CHR(10);
  -- This exception is raised when an INSERT, DELETE or UPDATE doesn't "find" any rows
  no_data_affected EXCEPTION;

  ----------------------------------------------------
  -- Wrappers for functions in the ksbms_util package
  ----------------------------------------------------
  PROCEDURE p_add_msg(psi_msg IN VARCHAR2) IS
  BEGIN
    ksbms_util.p_add_msg(psi_msg);
  END p_add_msg;

  PROCEDURE p_clean_up_after_raise_error(psi_context IN ksbms_util.context_string_type) IS
  BEGIN
    ksbms_util.p_clean_up_after_raise_error(psi_context);
  END p_clean_up_after_raise_error;

  PROCEDURE p_clean_up_after_raise_error2(psi_context IN ksbms_util.context_string_type) IS
  BEGIN
    ksbms_util.p_clean_up_after_raise_error2(psi_context);
  END p_clean_up_after_raise_error2;

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
    ksbms_util.pl(psi_msg);
  END pl; -- END: Wrappers

  FUNCTION f_is_pontis_missing_value(pthe_teststring IN VARCHAR2)
  -- Allen 11/5/2002 return T if the passed parm is in the missing value set.
    --- used to suppressed passing Pontis missing values to CANSYS - see function f_is_pontis_missing_value and f_pass_update_trigger_params '
    -- usage:  if NOT f_is_pontis_missing_value( the_arg) then
    -- do something with a non-missing argument
  
    --ELSE -- it is missing
    -- do something with a  missing argument
    -- end if
  
    -- Allen 11/7/2002 removed extraneous TRIM calls here, chaned work string size to 80 so all changes coming in for evaluation can be accommodated
   RETURN BOOLEAN IS
    ls_teststring    VARCHAR2(80); -- so we never exceed this with passed parameters
    lb_missing_value BOOLEAN := FALSE; -- the result...
  BEGIN
    IF LENGTH(TRIM(pthe_teststring)) > 78 THEN
      p_sql_error('Data value [ ' || pthe_teststring ||
                  ' ] in  argument for f_is_pontis_missing_value is too long - truncating ');
      ls_teststring := '|' || NVL(SUBSTR(pthe_teststring, 1, 78), 'X') || '|';
    ELSE
      ls_teststring := '|' || NVL(pthe_teststring, 'X') || '|';
    END IF;
  
    lb_missing_value := (INSTR(gs_pontis_missing_values, ls_teststring) > 0);
    RETURN lb_missing_value; -- false
  END f_is_pontis_missing_value;

  -- Hoyt 11/30/2001 This function is called by all the update triggers;
  -- Because different triggers pass different numbers of keys, the keys
  -- are all concatenated into a single comma-delimited string (p_keys).
  FUNCTION f_pass_update_trigger_params(p_keys                IN VARCHAR2,
                                        p_key_names           IN VARCHAR2,
                                        p_table_name          IN ksbms_robot.ds_transfer_map.table_name%TYPE,
                                        p_column_name         IN ksbms_robot.ds_transfer_map.column_name%TYPE,
                                        p_old_value           IN VARCHAR2,
                                        p_new_value           IN VARCHAR2,
                                        p_transfer_map_key_id IN ksbms_robot.ds_transfer_map.transfer_key_map_id%TYPE,
                                        p_bridge_id           IN bridge.bridge_id%TYPE,
                                        p_invoking_trigger    IN VARCHAR2)
    RETURN BOOLEAN IS
    -- Local variables                                    
    lb_failed BOOLEAN := TRUE; -- This function returns TRUE on failure
    -- Controls some dbms_output()s
    lb_in_development BOOLEAN := FALSE; -- Make FALSE in production
    -- Set TRUE if a merge is underway
    lb_canceled                  BOOLEAN := FALSE;
    ls_array_of_passed_keys      key_vals; -- An array with ten varchar2 elements
    ls_array_of_passed_key_names key_vals; -- These are the column NAMES, not the values
    li_transfer_key_map_id       ksbms_robot.ds_transfer_map.transfer_key_map_id%TYPE;
    li_exchange_rule_id          ksbms_robot.ds_transfer_map.exchange_rule_id%TYPE;
    ls_precedence                ksbms_robot.ds_transfer_map.precedence%TYPE;
    ls_status                    ksbms_robot.ds_restricted_exchange_rules.status%TYPE;
    ls_entry_id                  ksbms_robot.ds_change_log.entry_id%TYPE;
    ll_change_log_seqnum         ksbms_robot.ds_change_log.sequence_num%TYPE;
    ls_exchange_status           ksbms_robot.ds_change_log.exchange_status%TYPE;
    lb_result                    BOOLEAN := NULL;
    ls_ith_key                   VARCHAR2(32); -- No Pontis keys are longer than 32 characters
    i                            PLS_INTEGER; -- Index variable
    ls_context                   ksbms_util.context_string_type := 'f_pass_update_trigger_params()';
    -- Increments 1, 2, 3... for ksbms_robot.ds_lookup_keyvals.key_sequence_num
    li_key_sequence_num      ksbms_robot.ds_lookup_keyvals.key_sequence_num%TYPE := 0;
    ls_failed_trigger_msg    VARCHAR2(2000);
    ls_current_exchange_type ksbms_robot.ds_change_log.exchange_type%TYPE;
    ls_strunitlabel          structure_unit.strunitlabel%TYPE;
    ls_username              VARCHAR2(45);
  
  BEGIN
  
    -- This anonymous block is for the sole purpose of providing
    -- a catch-all exception block... so raising an exception 
    -- anywhere in the do-once loop below will be "handled" by the 
    -- block's exception handler.
    <<outer_exception_block>>
    BEGIN
      ----------------------------------------------------
      -- Make this TRUE to test the p_sql_error() function
      ----------------------------------------------------
      IF FALSE THEN
        DECLARE
          ls_brkey VARCHAR2(32);
        BEGIN
          SELECT brkey INTO ls_brkey FROM bridge;
        EXCEPTION
          WHEN OTHERS THEN
            p_sql_error('Selecting brkey to generate a SQL error!');
        END;
      END IF;
    
      -- Loop allows exit on failure
      <<do_once>>
      LOOP
        --- CHANGE CHANGE CHANGE CHANGE
        -- Allen 11/5/2002 for column update triggers in Pontis - NOT RELEVANT FOR INSERT DELETE MESSAGE - do not check then
        -- suppress exchange of Pontis missing values when a field is INITIALLY populated.  Later, if a value goes from good to a Pontis missing and the
        -- global suppression boolean gb_suppress_pontis_missing is FALSE, that change will propagate.....
        -- see if the incoming change (new value) is from NULL to a Pontis MISSING_VALUE
        -- uses function f_is_Pontis_Missing_Value
        -- if so, cancel and exit.
      
        IF p_column_name NOT IN (ls_insert, ls_delete, ls_message) THEN
          IF f_is_pontis_missing_value(TRIM(p_new_value)) OR
             p_new_value IS NULL THEN
            IF (p_old_value IS NULL -- always 
               OR gb_suppress_pontis_missing) THEN
              -- whenever we have set gb_suppress_pontis_missing to true and the new value is missing
            
              /*  p_sql_error (
                    'Auto-suppressed propagation to CANSYS for update of '||p_table_name||'.'||p_column_name ||  ' to a Pontis missing value = '
                 || TRIM(  p_new_value )
              ); */
              lb_canceled := TRUE; -- The update is NOT passed along in this case, but not an error
              lb_failed   := FALSE;
              EXIT;
            END IF;
          END IF;
        END IF;
        --- END CHANGE CHANGE CHANGE CHANGE
      
        -- If a merge is underway, then fail immediately
        IF f_is_merge_underway() THEN
          ls_failed_trigger_msg := 'Merge underway! Try again in a minute or two!' ||
                                   ls_crlf || ls_crlf ||
                                   'NOT applying change in column with transfer map key ID ' ||
                                   TO_CHAR(p_transfer_map_key_id) || ', ' ||
                                   ls_crlf || ' table.column = ' ||
                                   p_table_name || '.' || p_column_name ||
                                   ls_crlf || ' changing the value ' ||
                                   p_old_value || ' to ' || p_new_value ||
                                   ' for keys ' || p_keys || ls_crlf ||
                                   ' in stored procedure ' || ls_context;
          p_sql_error(ls_failed_trigger_msg);
          -- IF the user is KSBMS_ROBOT, then this change is coming from
          -- the process where changes from CANSYS are applied to Pontis,
          -- which we do NOT want to propagate to ds_change_log.
        ELSIF f_triggered_by_apply_changes() THEN
          lb_canceled := TRUE; -- The update is NOT passed along
          lb_failed   := FALSE;
          EXIT;
        END IF;
      
        -- Convert the comma-delimited list of keys into an array for easier processing
        ls_array_of_passed_keys := f_parse_csv_into_array(p_keys);
        -- Ditto fo the list of key NAMES
        ls_array_of_passed_key_names := f_parse_csv_into_array(p_key_names);
      
        ---------------------------------------------------------------------
        -- Get ksbms_robot.ds_transfer_map data, esp. the transfer_key_map_id
        ---------------------------------------------------------------------
        -- We need to select using the transfer_map_key_id because five
        -- table.column combinations appear twice; the transfer_map_key_id
        -- has to be included with table_name and column_name to uniquely
        -- identify a row. The five are "special cases" handled in the 
        -- triggers; see the PB function used to generate the triggers.
        BEGIN
          -- select the ksbms_robot.ds_transfer_map row that corresponds to the passed table and column
          SELECT exchange_rule_id, transfer_key_map_id, precedence
            INTO li_exchange_rule_id, li_transfer_key_map_id, ls_precedence
            FROM ksbms_robot.ds_transfer_map
           WHERE table_name = p_table_name
             AND column_name = p_column_name
             AND transfer_key_map_id = p_transfer_map_key_id;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            -- Hoyt 1/10/2002 Handle the INS (INSERT) and DEL (DELETE) cases
            -- (which are not presently represented in ds_transfer_map).
            IF p_column_name = ls_insert OR p_column_name = ls_delete THEN
              BEGIN
                -- Select the minimum exchange rule id corresponding to the INSERTed table
                SELECT exchange_rule_id, transfer_key_map_id, precedence
                  INTO li_exchange_rule_id,
                       li_transfer_key_map_id,
                       ls_precedence
                  FROM ksbms_robot.ds_transfer_map
                -- Same as above only MIN() is applied and column_name is omitted
                -- Keep the 'select min(' IN SYNCH with the same logic in 
                -- ksbms_data_synch.f_replace_deleted_inspevnt_data()
                 WHERE exchange_rule_id IN
                       (SELECT MIN(exchange_rule_id)
                          FROM ksbms_robot.ds_transfer_map
                         WHERE table_name = p_table_name
                           AND sit_id <> '-1'); -- Hoyt 01/15/2002 Added '-1' clause
              EXCEPTION
                WHEN OTHERS THEN
                  p_sql_error('Failed to get the exchange rule ID WHEN INSERTING for table ' ||
                              p_table_name || ' and column ' ||
                              p_column_name);
              END;
            ELSE
              -- When there's an NO_DATA_FOUND error OTHER than an INS case
              p_sql_error('Failed to get the exchange rule ID for table ' ||
                          p_table_name || ' and column ' || p_column_name);
            END IF;
          WHEN OTHERS THEN
            p_sql_error('Selecting exchange rule ID for table ' ||
                        p_table_name || ' and column ' || p_column_name);
        END;
      
        -- For cases 7 and 8, we need to retrieve USERRWAY information
        IF li_transfer_key_map_id = 7 THEN
          BEGIN
            -- Make room in the array for the key values
            FOR i IN 1 .. 5 LOOP
              ls_array_of_passed_keys.EXTEND;
              ls_array_of_passed_key_names.EXTEND;
            END LOOP;
          
            -- BRKEY is already in array element 1
            ls_array_of_passed_key_names(2) := 'FEAT_CROSS_TYPE';
            ls_array_of_passed_key_names(3) := 'ROUTE_PREFIX';
            ls_array_of_passed_key_names(4) := 'ROUTE_NUM';
            ls_array_of_passed_key_names(5) := 'ROUTE_SUFFIX';
            ls_array_of_passed_key_names(6) := 'ROUTE_UNIQUE_ID';
          
            -- Select the required keys from USERRWAY
            -- This version DOES select FEAT_CROSS_TYPE
            -- Hoyt 09/03/2002 Changed on_under = '1' to on_under = '22' per NAC's e-mail
            SELECT NVL(feat_cross_type, ls_missing),
                   NVL(route_prefix, ls_missing),
                   NVL(route_num, ls_missing),
                   NVL(route_suffix, ls_missing),
                   NVL(route_unique_id, ls_missing)
              INTO ls_array_of_passed_keys(2),
                   ls_array_of_passed_keys(3),
                   ls_array_of_passed_keys(4),
                   ls_array_of_passed_keys(5),
                   ls_array_of_passed_keys(6)
              FROM userrway
             WHERE brkey = ls_array_of_passed_keys(1)
               AND on_under = '22';
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              -- Hoyt 01/18/2002 Made this NON-FATAL
              -- We will NEVER have these when adding a new roadway in Pontis
              p_sql_error2('Failed to find the five <ENHANCEMENT> USERRWAY keys for key map 7.');
              -- Fill in the keys as missing
              ls_array_of_passed_keys(2) := ls_missing;
              ls_array_of_passed_keys(3) := ls_missing;
              ls_array_of_passed_keys(4) := ls_missing;
              ls_array_of_passed_keys(5) := ls_missing;
              ls_array_of_passed_keys(6) := ls_missing;
            WHEN OTHERS THEN
              p_sql_error('Selecting the five USERRWAY keys for key map 7.');
          END;
        ELSIF li_transfer_key_map_id = 8 THEN
          BEGIN
            -- Make room in the array for the key values
            FOR i IN 1 .. 4 -- NB 4, not 5
             LOOP
              ls_array_of_passed_keys.EXTEND;
              ls_array_of_passed_key_names.EXTEND;
            END LOOP;
          
            -- BRKEY is already in array element 1
            ls_array_of_passed_key_names(2) := 'ROUTE_PREFIX';
            ls_array_of_passed_key_names(3) := 'ROUTE_NUM';
            ls_array_of_passed_key_names(4) := 'ROUTE_SUFFIX';
            ls_array_of_passed_key_names(5) := 'ROUTE_UNIQUE_ID';
          
            -- Select the required keys from USERRWAY
            -- This version does NOT select FEAT_CROSS_TYPE
            SELECT NVL(route_prefix, ls_missing),
                   NVL(route_num, ls_missing),
                   NVL(route_suffix, ls_missing),
                   NVL(route_unique_id, ls_missing)
              INTO ls_array_of_passed_keys(2),
                   ls_array_of_passed_keys(3),
                   ls_array_of_passed_keys(4),
                   ls_array_of_passed_keys(5)
              FROM userrway
             WHERE brkey = ls_array_of_passed_keys(1)
               AND on_under = '1'; -- <ENHANCEMENT> Ask Natalie
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              -- Hoyt 01/18/2002 Made this NON-FATAL
              -- We will NEVER have these when adding a new roadway in Pontis
              p_sql_error2('Failed to find the four USERRWAY keys for key map 8.');
              -- Fill in the keys as missing
              ls_array_of_passed_keys(2) := ls_missing;
              ls_array_of_passed_keys(3) := ls_missing;
              ls_array_of_passed_keys(4) := ls_missing;
              ls_array_of_passed_keys(5) := ls_missing;
            WHEN OTHERS THEN
              p_sql_error('Selecting the four USERRWAY keys for key map 8.');
          END;
        END IF;
      
        ---------------------------------------------------
        -- Check to see if any NULL key values were passed
        ---------------------------------------------------
        ls_exchange_status := ls_new_update; -- Unless something is missing
      
        FOR ls_ith_key IN ls_array_of_passed_keys.FIRST .. ls_array_of_passed_keys.LAST LOOP
          BEGIN
            -- The triggers pass NVLs as <MISSING>
            IF ls_array_of_passed_keys(ls_ith_key) = ls_missing OR -- It's "missing" if it's "strunitkey={2}" or similar;
              -- search for _both_ "={" and } to avoid inadvertantly classifying
              -- some "real" value as "missing".
               (INSTR(ls_array_of_passed_keys(ls_ith_key), '={') <> 0 AND
                INSTR(ls_array_of_passed_keys(ls_ith_key), '}') <> 0) THEN
              ls_exchange_status := ls_missing;
              EXIT; -- Only need to find one missing key
            END IF;
          END;
        END LOOP;
      
        ---------------------------------------------------
        -- Is there a restriction on this type of exchange?
        ---------------------------------------------------
        BEGIN
          -- select the ksbms_robot.ds_restricted_exchange_rules row that corresponds to echange type and rule ID
          SELECT status
            INTO ls_status
            FROM ksbms_robot.ds_restricted_exchange_rules
           WHERE exchange_type = ls_update
             AND exchange_rule_id = li_exchange_rule_id;
        
          -- If no record is found, then ls_status will be NULL
          -- <ENHANCEMENT> What is the magic value for STATUS that means "Do NOT do this one"???
          IF ls_status = ls_restricted_status THEN
            -- Hoyt 02/25/2002 Per Allen, mark the exchange_status as <RESTRCTD>
            ls_exchange_status := ls_restricted;
          END IF;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            NULL; -- This is an expected condition
          -- ksbms_robot.ds_restricted_exchange_rules only contains rows for exceptions!
          WHEN OTHERS THEN
            p_sql_error('Selecting the restricted exchange rules for exchange rule id ' ||
                        TO_CHAR(li_exchange_rule_id));
        END;
      
        ---------------------------------------------------
        -- Insert the ksbms_robot.ds_change_log record
        ---------------------------------------------------
      
        BEGIN
          ls_entry_id := f_get_entry_id; -- So we can re-use it to insert into ksbms_robot.ds_lookup_keyvals
          -- Hoyt 1/10/2002 If this is an INSERT, then insert that exchange_status
          ls_current_exchange_type := ls_update; -- Unless this is an INSERT or DELETE
          ll_change_log_seqnum     := f_get_entry_sequence_num; -- All entries are stamped in sequence...
        
          IF ls_exchange_status <> ls_missing -- Because we don't want to override that ...
             AND ls_exchange_status <> ls_restricted -- ... or that 
           THEN
            IF p_column_name = ls_insert THEN
              ls_exchange_status       := ls_insert; -- INS for INSERTs only
              ls_current_exchange_type := ls_insert; -- Ditto
            ELSIF p_column_name = ls_delete THEN
              ls_exchange_status       := ls_delete; -- DEL for DELETEs only
              ls_current_exchange_type := ls_delete; -- Ditto
            ELSE
              ls_exchange_status       := ls_update; -- The usual UPD
              ls_current_exchange_type := ls_update;
            END IF;
          END IF;
          ls_username := f_get_username;
          -- Attention!
          -- Do NOT associate a pre- or post-insert trigger
          -- with ksbms_robot.ds_change_log that sets the
          -- createdatetime or the user -- this data is set
          -- explicitly here, and must not be overridden, 
          -- esp. as records are inserted from CANSYS.
        
          INSERT INTO ksbms_robot.ds_change_log
            (entry_id,
             sequence_num,
             exchange_rule_id,
             exchange_type,
             old_value,
             new_value,
             exchange_status,
             precedence,
             createdatetime,
             createuserid,
             remarks)
          VALUES
            (ls_entry_id,
             ll_change_log_seqnum,
             li_exchange_rule_id,
             ls_current_exchange_type,
             p_old_value,
             p_new_value,
             ls_exchange_status, -- Magic constant?
             ls_precedence,
             SYSDATE,
             ls_username, -- used this instead of 'USER'  trying to get the person's name in the exchange tables... 7/23/2015
             'From f_pass_update_trigger_params() via ' ||
             p_invoking_trigger);
        
          IF SQL%ROWCOUNT = 0 THEN
            RAISE NO_DATA_FOUND;
          END IF;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            p_sql_error('No data found with INSERT the change log row for exchange rule ' ||
                        TO_CHAR(li_exchange_rule_id));
          WHEN OTHERS THEN
            p_sql_error('Failed to INSERT the change log row for exchange rule ' ||
                        TO_CHAR(li_exchange_rule_id));
        END;
      
        -- In every case, the first key is the brkey, and we need the bridge_id
        IF p_bridge_id <> ls_missing THEN
          ls_array_of_passed_keys(1) := p_bridge_id;
        ELSE
          -- Clue the MERGE process that this BRKEY needs to be fixed
          ls_array_of_passed_key_names(1) := 'BRKEY';
        END IF;
      
        -- The above is needed because (for example) when STRUCTURE_UNIT records
        -- are deleted because a BRIDGE record is being deleted, and referential
        -- integrity causes the STRUCTURE_UNIT to be deleted to..., then the 
        -- Bridge ID is not available, because it doesn't appear on the 
        -- STRUCTURE_UNIT record... and it cannot be retrieved using the
        -- BRKEY because the BRIDGE record is mutating (it's being deleted).
      
        ------------------------------------------------------------------------------------------------------
        -- Insert the ksbms_robot.ds_lookup_keyvals record(s)
        -- Handle the <n> cases indicated by the number of values of ds_transfer_key_map.transfer_key_map_id
        ------------------------------------------------------------------------------------------------------
      
        -- All the keys are here in the order required
        BEGIN
          -- Simply insert the keys in the order they arrives.
          -- This requires that the triggers be smart enough to GET the keys in the proper order;
          -- Therefore, if ds_transfer_key_map is changed, then the triggers must be regenerated.
          li_key_sequence_num := 0;
        
          FOR ls_ith_key IN ls_array_of_passed_keys.FIRST .. ls_array_of_passed_keys.LAST LOOP
            BEGIN
              -- Increment the sequence number
              li_key_sequence_num := li_key_sequence_num + 1;
            
              -- INSERT the ith key into ksbms_robot.ds_lookup_keyvals
              INSERT INTO ksbms_robot.ds_lookup_keyvals
                (entry_id,
                 keyname,
                 keyvalue,
                 key_sequence_num,
                 createdatetime,
                 createuserid)
              VALUES
                (ls_entry_id,
                 ls_array_of_passed_key_names(li_key_sequence_num),
                 ls_array_of_passed_keys(li_key_sequence_num),
                 li_key_sequence_num,
                 SYSDATE,
                 USER);
            
              IF SQL%ROWCOUNT = 0 THEN
                RAISE NO_DATA_FOUND;
              END IF;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                p_sql_error('No data found with INSERT the key value row for sequence number ' ||
                            TO_CHAR(li_key_sequence_num));
              WHEN OTHERS THEN
                p_sql_error('Failed to INSERT the key value row ' ||
                            ls_crlf || ' Key Name  = ' ||
                            ls_array_of_passed_key_names(li_key_sequence_num) ||
                            ls_crlf || ' Key Value = ' ||
                            ls_array_of_passed_keys(li_key_sequence_num) ||
                            ls_crlf || ' Key Seq # = ' ||
                            TO_CHAR(NVL(li_key_sequence_num, -99)));
            END;
          END LOOP;
        END;
      
        /*
        -- Special case: ROADWAY/USERRWAY
        -- At this writing (03/03/2002), there is not 'send to CANSYS' column
        -- that is updated by the vanilla add-a-structure operation in Pontis.
        -- Therefore only one record is sent, an 'INS' (insert) record. That
        -- fails when coming back from CANSYS -- we need an 'UPD'. Though this
        -- is in part an artifact of our testing method... here we purposely
        -- update a ROADWAY column JUST SO we have an 'UPD' record to force the
        -- INSERT when the changes are applied. ARTIFACT?
        if p_table_name = 'ROADWAY' and p_column_name = 'INS'
        then
            begin
              pl( 'p_new_value is ' || p_new_value );
              update roadway
              set crit_feat = '_' -- Missing
              where on_under = '1' and
                    brkey = p_new_value;
              if sql%rowcount = 0
              then
                  raise no_data_affected;
              end if;
            exception
            when no_data_affected
            then
                p_sql_error( 'Failed to find a record when attempting UPDATE the ROADWAY record for BRIDGE_ID ' || ls_array_of_passed_keys (1) );
            when others
            then
                p_sql_error( 'Failed to UPDATE the ROADWAY record for BRIDGE_ID ' || ls_array_of_passed_keys (1) );
            end;
        end if;
        <ENHANCEMENT> Left here against future need -- doesn't work because of 'mututating' problem */
      
        -- Success!
        lb_failed := FALSE; -- FALSE means 'success' -- it worked!
        EXIT; -- We're done!
      END LOOP do_once;
      -----------------------------------------------------------------          
      -- This exception handler surrounds ALL the code in this function
      -----------------------------------------------------------------          
    EXCEPTION
      WHEN OTHERS THEN
        p_clean_up_after_raise_error2(ls_context);
    END outer_exception_block; -- This ends the anonymous block created just to have the error handler
  
    -- In development, display the result
  
    IF lb_in_development THEN
      IF lb_failed THEN
        ksbms_util.pl('f_pass_update_trigger_params( ' ||
                      p_invoking_trigger || '() ) failed');
      ELSIF lb_canceled THEN
        ksbms_util.pl('f_pass_update_trigger_params( ' ||
                      p_invoking_trigger ||
                      '() ) was CANCELLED (merge underway!)');
      ELSE
        ksbms_util.pl('f_pass_update_trigger_params( ' ||
                      p_invoking_trigger || '() ) SUCCEEDED!');
      END IF;
    END IF;
  
    RETURN(lb_failed);
  END f_pass_update_trigger_params;

  --------------------------------------------------------------------------------
  -- Utility functions, that could be moved to a more generic package
  --
  -- f_boolean_to_string() -- converts to 'TRUE' or 'FALSE'
  -- f_get_bridge_id_from_brkey() - passed a BRKEY, returns the corresponding BRIDGE_ID
  -- f_get_entry_id() -- returns a sys_guid() value (can be called "in line")
  -- f_parse_csv_into_array() -- parses comma-delimited string into array
  --------------------------------------------------------------------------------

  -- Returns 'TRUE' or 'FALSE' so Boolean values can be displayed as strings
  FUNCTION f_boolean_to_string(p_boolean IN BOOLEAN) RETURN VARCHAR2 IS
    lb_boolean VARCHAR2(5);
  BEGIN
    IF p_boolean THEN
      lb_boolean := 'TRUE';
    ELSE
      lb_boolean := 'FALSE';
    END IF;
  
    RETURN lb_boolean;
  END f_boolean_to_string;

  -- Return the bridge_id that corresponds to a given brkey
  /* FUNCTION f_get_bridge_id_from_brkey (p_brkey IN bridge.brkey%TYPE)
     RETURN  bridge.bridge_id%TYPE
  IS
        ls_bridge_id   bridge.bridge_id%TYPE; -- Length of bridge_id in Pontis
        PRAGMA AUTONOMOUS_TRANSACTION; -- Allen MArshall, CS - 2003-01-06
  BEGIN
  
     -- Get the bridge_id that corresponds to the passed brkey
     SELECT bridge_id
       INTO ls_bridge_id
       FROM bridge
      WHERE brkey = p_brkey;
  
     -- If we hit this, then there wasn't an exception, so we got the bridge_id
     RETURN ls_bridge_id;
  EXCEPTION
     WHEN NO_DATA_FOUND
     THEN
        -- Variant 2 so we can return NULL (<ENHANCEMENT> Change this?)
        p_sql_error2 (   'Failed to find the bridge ID corresponding to brkey '
                      || p_brkey
                     );
        RETURN NULL;
     WHEN OTHERS
     THEN
        -- Variant 2 so we can return NULL (<ENHANCEMENT> Change this?)
        p_sql_error2 (   'Selecting the bridge ID corresponding to brkey '
                      || p_brkey
                     );
        RETURN NULL;
  END f_get_bridge_id_from_brkey; */
  -- Allen Marshall, CS - 1/16/2003 - wrapper to call the function in KSBMS_PONTIS_UTIL, obsolete this one.....   leave here in case some other code needs to use this
  -- particular reference
  FUNCTION f_get_bridge_id_from_brkey(p_brkey IN bridge.brkey%TYPE)
    RETURN bridge.bridge_id%TYPE IS
    ls_bridge_id bridge.bridge_id%TYPE; -- Length of bridge_id in Pontis
    PRAGMA AUTONOMOUS_TRANSACTION; -- Allen MArshall, CS - 2003-01-06
  BEGIN
    RETURN ksbms_pontis_util.f_get_bridge_id_from_brkey(p_brkey);
  END f_get_bridge_id_from_brkey;

  -- Get the value used for ksbms_robot.ds_change_log.entry_id and ksbms_robot.ds_lookup_keyvals.entry_id
  FUNCTION f_get_entry_id RETURN VARCHAR2 IS
    RESULT VARCHAR2(32);
  BEGIN
    -- Get the 32-character string provided by sys_guid()
    SELECT SYS_GUID() INTO RESULT FROM DUAL;
  
    -- Return the magic string
    RETURN(RESULT);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      -- Variant 2 so we can return NULL (<ENHANCEMENT> Change this?)
      p_sql_error2('No data found when trying to get the sys_guid()!');
      RETURN NULL;
    WHEN OTHERS THEN
      -- Variant 2 so we can return NULL (<ENHANCEMENT> Change this?)
      p_sql_error2('Failure when trying to get the sys_guid()!');
      RETURN NULL;
  END f_get_entry_id;

  FUNCTION f_get_entry_sequence_num RETURN ds_change_log.sequence_num%TYPE IS
    ll_result ds_change_log.sequence_num%TYPE;
  BEGIN
    -- Allen 9/9/2002
    -- Function returns the next sequence number from the KSBMS_ROBOT.DS_CHANGE_LOG_SEQNUM SEQUENCE>
    -- Users/roles must be granted SELECT on the sequence and either it must be referenced via user.object notation or a public/private synonym must
    -- be created for the sequence if referenced in a package/object not owned by KSBMS_ROBOT
    -- value is used to populate ds_change_log.sequence_num
  
    -- Allen 9/9/2002 - comment was from prior function, fixed
    -- Get the NEXTVAL from the ds_change_log_seqnum SEQUENCE
    SELECT ds_change_log_seqnum.NEXTVAL INTO ll_result FROM DUAL;
  
    -- Return the magic string
    RETURN(ll_result);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      -- Variant 2 so we can return NULL (<ENHANCEMENT> Change this?)
      p_sql_error2('No data found when trying to get a sequence number for the change log entry!');
      RETURN NULL;
    WHEN OTHERS THEN
      -- Variant 2 so we can return NULL (<ENHANCEMENT> Change this?)
      p_sql_error2('Other Oracle error occurred while trying to get a sequence number for the change log entry!');
      RETURN NULL;
  END f_get_entry_sequence_num;

  FUNCTION f_is_merge_underway -- Return TRUE if the merge process is running
   RETURN BOOLEAN IS
    lb_merge_is_underway BOOLEAN := FALSE;
  BEGIN
    -- The fastest way to do this is via this cursor (even though it's a lot of code)
    DECLARE
      -- Is there at least one 'SM' record inserted TODAY?
      -- 'SM' -> Starting Merge
      CURSOR select_sm_record_cur IS
      -- This means only look at today's data: trunc (job_start_time) = trunc (sysdate)
        SELECT job_id
          FROM ksbms_robot.ds_jobruns_history
         WHERE TRUNC(job_start_time) = TRUNC(SYSDATE)
           AND UPPER(job_status) = 'SM';
    
      select_sm_record_cur_rec select_sm_record_cur%ROWTYPE;
    BEGIN
      -- Don't fail because the cursor is open!
      IF select_sm_record_cur%ISOPEN THEN
        CLOSE select_sm_record_cur;
      END IF;
    
      -- Try to get just one record (for maximum speed)
      OPEN select_sm_record_cur;
      FETCH select_sm_record_cur
        INTO select_sm_record_cur_rec;
      lb_merge_is_underway := select_sm_record_cur%FOUND;
      CLOSE select_sm_record_cur;
      RETURN lb_merge_is_underway;
    EXCEPTION
      WHEN OTHERS THEN
        p_sql_error('f_is_merge_underway() - Determining a ''Starting Merge'' operation is underway');
    END;
  END f_is_merge_underway;

  FUNCTION f_triggered_by_apply_changes
  -- Returns TRUE if the 'Apply Changes' process is running,
    -- AND the user who triggered this specific call is the same
    -- as the user running 'Apply Changes' (e.g. KSBMS_ROBOT).
   RETURN BOOLEAN IS
    lb_trigger_from_apply_changes BOOLEAN := FALSE;
  BEGIN
    -- The fastest way to do this is via this cursor (even though it's a lot of code)
    DECLARE
      -- Is there at least one 'AC' record inserted TODAY?
      -- 'AC' -> Apply changes
      CURSOR select_ac_record_cur IS
      -- This means only look at today's data: trunc (job_start_time) = trunc (sysdate)
        SELECT job_userid
          FROM ksbms_robot.ds_jobruns_history
         WHERE TRUNC(job_start_time) = TRUNC(SYSDATE)
           AND UPPER(job_status) = ls_apply_changes
           AND UPPER(job_userid) = USER;
    
      select_ac_record_cur_rec select_ac_record_cur%ROWTYPE;
    BEGIN
      -- Don't fail because the cursor is open!
      IF select_ac_record_cur%ISOPEN THEN
        CLOSE select_ac_record_cur;
      END IF;
    
      -- Try to get just one record (for maximum speed)
      OPEN select_ac_record_cur;
      FETCH select_ac_record_cur
        INTO select_ac_record_cur_rec;
      lb_trigger_from_apply_changes := select_ac_record_cur%FOUND;
      CLOSE select_ac_record_cur;
      RETURN lb_trigger_from_apply_changes;
    EXCEPTION
      WHEN OTHERS THEN
        p_sql_error('f_is_triggered_by_apply_changes() - Determining an ''Apply Changes'' operation is underway');
    END;
  END f_triggered_by_apply_changes;

  -- Takes a comma-delimited list and puts elements into an array
  -- (This code is taken unchanged from Allen's ksbms_pontis_util.)
  FUNCTION f_parse_csv_into_array(the_list_in IN VARCHAR2) RETURN key_vals IS
    ls_token    VARCHAR2(255);
    lv_result   key_vals := key_vals(); -- initialize to EMPTY ( not null );
    ith         PLS_INTEGER := 1;
    li_startpos PLS_INTEGER;
    li_endpos   PLS_INTEGER;
    li_last     PLS_INTEGER;
  BEGIN
    LOOP
    
      <<control_loop>>
      IF the_list_in IS NULL THEN
        EXIT;
      END IF;
    
      ith         := 1;
      li_startpos := 1;
      li_endpos   := INSTR(the_list_in, ',', 1);
    
      IF li_endpos > 0 THEN
        LOOP
          -- extract string token
          lv_result.EXTEND;
          lv_result(ith) := SUBSTR(the_list_in,
                                   li_startpos,
                                   li_endpos - li_startpos);
          ith := ith + 1;
        
          IF ith > 50 THEN
            EXIT;
          END IF; -- only 50 cells for destination addresses
        
          -- reset start with next token
        
          li_startpos := li_endpos + 1;
        
          IF li_startpos > LENGTH(the_list_in) THEN
            EXIT;
          END IF;
        
          -- see if there is another token (another , )
          li_endpos := INSTR(the_list_in, ',', 1, ith);
          EXIT WHEN li_endpos = 0; -- no more commas
        END LOOP;
      
        IF ith > 1 THEN
          BEGIN
            lv_result.EXTEND;
            li_last := LENGTH(the_list_in) + 1 - li_startpos;
            ls_token := TRIM(SUBSTR(the_list_in, li_startpos, li_last));
            lv_result(ith) := ls_token;
          END;
        END IF;
      ELSE
        lv_result.EXTEND;
        lv_result(1) := the_list_in;
      END IF;
    
      EXIT WHEN TRUE;
    END LOOP control_loop;
  
    RETURN lv_result;
  END f_parse_csv_into_array;

  Function f_get_username return varchar2 is
    -- changed the 'USER' option in the list of values for the ds_change_log for 'createuserid' from 
    -- 'USER' to the result of this function which retrieves a name from the sys_context table 
    -- so that the trigger places a username (not just PONTIS) in the exchange tables... 7/23/2015
    retval varchar2(2000);
  
  begin
  
    select sys_context('userenv', 'os_user') into retval from dual;
  
    return retval;
  end f_get_username;

  -- The opposite of f_kdot_bridge_id_to_brkey
  -- <ENHANCEMENT> This is duplicated in ksbms_apply_changes() -- consolidate?
  /* ARM 2002-03-05 added this function by stealing it from ksbms_apply_changes wholesale */
  FUNCTION f_kdot_brkey_to_bridge_id(p_brkey IN VARCHAR2)
  -- This takes '001008' and returns'0001-B0008',
   RETURN VARCHAR2 IS
    ls_bridge_id VARCHAR2(10);
    brkey_is_null          EXCEPTION;
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
                  'The BRKEY is ''' || p_brkey ||
                  ''' AND it''s length is ' || TO_CHAR(LENGTH(p_brkey)));
  END f_kdot_brkey_to_bridge_id;

  /* ARM 2002-03-05 added this function by stealing it from ksbms_apply_changes wholesale */
  FUNCTION f_kdot_bridge_id_to_brkey(p_bridge_id IN VARCHAR2)
  -- This takes '0001-B0008' and returns '001008',
    -- which is the apparent algorithm that KDOT uses to go between
    -- bridge_id (the first string) and brkey and struct_num (the
    -- second string -- brkey and struct_num are everywhere the same
    -- in the KDOT database).
   RETURN VARCHAR2 IS
    ls_brkey VARCHAR2(6);
    bridge_id_is_null          EXCEPTION;
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
            ls_crlf || ls_crlf || 'The bridge_id is ''' || p_bridge_id ||
            ''' AND it''s length is ' || TO_CHAR(LENGTH(p_bridge_id)));
      RETURN NULL;
  END f_kdot_bridge_id_to_brkey;

  PROCEDURE p_turn_off_exchange IS
    lb_failed  BOOLEAN := TRUE; -- Until we succeed
    ls_context ksbms_util.context_string_type := 'p_turn_off_exchange()';
    -- Local variables
    li_job_id ksbms_robot.ds_jobruns_history.job_id%TYPE;
  BEGIN
  
    <<outer_exception_block>>
    BEGIN
    
      <<do_once>>
      LOOP
        IF USER = 'KSBMS_ROBOT' THEN
          -- Allen Marshall, CS  - 2004-02-06 so this doesn't cause a failure message in the log - this is an OK exit.
          lb_Failed := false;
          EXIT;
        END IF; -- not to be run by ROBOT
      
        -- ARM 3/19/2002 NOT ORA_DBMS_JOB_ID, JOB_ID
        -- The job_id has to be unique so use f_get_entry_id()
      
        -- Insert into job runs to prevent f_pass_update_trigger_params() from doing so
      
        BEGIN
          INSERT INTO ksbms_robot.ds_jobruns_history
            (job_id,
             ora_dbms_job_id,
             job_start_time,
             job_end_time,
             job_status,
             job_userid,
             remarks)
          VALUES
            (f_get_entry_id(),
             '999',
             SYSDATE,
             SYSDATE,
             'AC',
             USER,
             'Inserted by ' || ls_context);
        EXCEPTION
          WHEN OTHERS THEN
            p_sql_error('Failed trying to INSERT an ''AC'' record in ' ||
                        ls_context);
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
  
    -- Save the changes (or not)
  
    lb_failed := ksbms_util.f_commit_or_rollback(lb_failed, ls_context);
  END p_turn_off_exchange;

  PROCEDURE p_turn_on_exchange IS
    lb_failed  BOOLEAN := TRUE; -- Until we succeed
    ls_context ksbms_util.context_string_type := 'p_turn_on_exchange()';
  BEGIN
  
    <<outer_exception_block>>
    BEGIN
    
      <<do_once>>
      LOOP
        -- Insert into job runs to prevent f_pass_update_trigger_params() from doing so
        BEGIN
          IF USER = 'KSBMS_ROBOT' THEN
            -- Allen Marshall, CS  - 2004-02-06 so this doesn't cause a failure message in the log - this is an OK exit.
            lb_Failed := false;
            EXIT;
          END IF; -- not to be run by ROBOT
        
          UPDATE ksbms_robot.ds_jobruns_history
             SET job_status = 'AD' -- All Done
           WHERE job_userid = USER; -- Leave KSBMS_ROBOT's process alone!
        EXCEPTION
          WHEN OTHERS THEN
            p_sql_error('Failed trying to UPDATE an ''AD'' (All Done) record in ' ||
                        ls_context);
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
  
    -- Save the changes (or not)
  
    lb_failed := ksbms_util.f_commit_or_rollback(lb_failed, ls_context);
  END p_turn_on_exchange;

  FUNCTION f_get_userkey_for_orauser(the_user IN VARCHAR2)
  -- Allen 7/27/2001
   RETURN users.userkey%TYPE IS
    ---------------------------------------------------------------------------------------
    -- function f_get_userkey_for_orauser
    ---------------------------------------------------------------------------------------
    -- Function returns a userkey from USERS for an arbitrary Oracle USER or a
    -- default userkey , which is a default set in
    -- sms2k_insp_pg.gs_default_userkey, if USER not found in the USERS table.
    -- That userkey must be in USERS even if it is a default to prevent
    -- referential integrity errors Assumption: DEFAULT USERID = 'DEFAULT' in
    -- USERS table. See gs_default_userid and gs_default_userkey
  
    -- Usage: select get_userkey_for_orauser() from dual;
    ---------------------------------------------------------------------------------------
    -- Allen R. Marshall, Cambridge Systematics
    -- Created 5/2001
    -- Revised: 7/23/2001 - (ARM) added comments
    -- Revised: 7/27/2001 - moved into this package.
    -- Revised: 1/2/2002 - simplified structure to rely on NO_DATA_FOUND exception
    -- removed a variable. Still relies on existence of a default row in USERS
    ---------------------------------------------------------------------------------------
  
    v_user users.userkey%TYPE := gs_default_userkey;
    -- Exception when cannot find a legitimate userid for a record - ARM 7/27/2001
    no_userid_found EXCEPTION;
    PRAGMA EXCEPTION_INIT(no_userid_found, -20009);
  BEGIN
    -- for logged in USER, find a userkey, or use the default userkey of 9999 if none found
    --ARM 1/20/2001 removed NVL(userkey,'NOTFOUND')
    BEGIN
      SELECT userkey
        INTO v_user
        FROM users u
       WHERE UPPER(u.userid) = NVL(UPPER(the_user), USER); -- ARM 7/26/2001 just to be sure...
    EXCEPTION
      WHEN NO_DATA_FOUND -- No data, try finding a default userkey using the default userid
       THEN
        BEGIN
          SELECT userkey
            INTO v_user
            FROM users u
           WHERE UPPER(u.userid) = UPPER(gs_default_userid);
        EXCEPTION
          -- this means the default userid is missing from the USERS table so no key can be
          -- determined.  Function returns NULL.
        
          WHEN NO_DATA_FOUND THEN
            RAISE no_userid_found;
          WHEN OTHERS THEN
            RAISE;
        END;
      WHEN OTHERS THEN
        RAISE;
    END;
  
    -- send back the userkey value
    RETURN v_user;
  EXCEPTION
    WHEN no_userid_found THEN
      raise_application_error(SQLCODE,
                              'Unable to lookup userkey for Oracle user = ' ||
                              the_user -- ARM 1/2/2002 NOT USER
                              );
      RETURN NULL;
    WHEN OTHERS THEN
      RAISE;
  END f_get_userkey_for_orauser;

  -- Return the db_id_key if available in database (4.0) only
  FUNCTION get_pontis_db_id_key RETURN VARCHAR2 IS
  BEGIN
    RETURN gs_db_id_key;
  END;

  -- generate an inspkey ( 4 letters )
  -- no obscenity check.

  FUNCTION get_pontis_inspkey(the_brkey_in IN VARCHAR2) RETURN VARCHAR2 IS
    ll_tries         PLS_INTEGER := 0;
    ls_inspkey       VARCHAR2(4) := 'XXXX';
    ll_seq           PLS_INTEGER := 0;
    lb_rowexists     BOOLEAN := TRUE;
    base_ascii_val   PLS_INTEGER := 65; -- A=65, 65+0 = A
    ascii_char_range PLS_INTEGER := 25; -- A-Z
    no_inspkey_found EXCEPTION;
  BEGIN
    LOOP
      -- through, try to create INSPKEY
      BEGIN
        -- Adapted from RANDOM_NUMBERFUNC in BMS_UTIL
        -- use GREATEST( 0, X ) to ensure result is > 0
        -- use LEAST( to_char(sysdate, 'DD') , 25 )  to ensure result is between 0 and 25
        --  ENGLISH ASCII DEPENDENCY - NOT PORTABLE OVERSEAS, BUT SO WHAT?
        /*      random_char :=    CHR (  first_num
                                     + start_ascii_val)
                             || CHR (  second_num
                                     + start_ascii_val)
                             || CHR (  third_num
                                     + start_ascii_val)
                             || CHR (  fourth_num
                                     + start_ascii_val);
        */
        SELECT CHR(GREATEST(0,
                            LEAST(ROUND((ksbms_util.random(2) / 100) *
                                        ascii_char_range,
                                        0))) + base_ascii_val) ||
               CHR(GREATEST(0,
                            LEAST(ROUND(((100 - ksbms_util.random(2)) / 100) *
                                        ascii_char_range,
                                        0))) + base_ascii_val) ||
               CHR(GREATEST(0,
                            LEAST(ROUND((ksbms_util.random(2) / 100) *
                                        ascii_char_range,
                                        0))) + base_ascii_val) ||
               CHR(GREATEST(0,
                            LEAST(ROUND(((100 - ksbms_util.random(2)) / 100) *
                                        ascii_char_range,
                                        0))) + base_ascii_val)
          INTO ls_inspkey
          FROM DUAL;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          -- Hoyt 1/11/2002
          ksbms_util.p_sql_error('get_pontis_inspkey(): no_data_found!');
        WHEN OTHERS THEN
          -- Hoyt 1/11/2002
          ksbms_util.p_sql_error('get_pontis_inspkey(): others!');
      END;
    
      -- test for uniqueness of BRKEY amd test value in table INSPEVNT ...
      -- Allen 06.21.2001 - f_any_rows_exist returns TRUE if found.
      -- All exceptions are raised in the called store procedure count_rows_for_table in PONTIS_UTIL
    
      lb_rowexists := ksbms_util.f_any_rows_exist('INSPEVNT',
                                                  'BRKEY = ' ||
                                                  ksbms_util.sq(the_brkey_in) ||
                                                  ' and inspkey = ' ||
                                                  ksbms_util.sq(ls_inspkey));
      -- check if done..
      -- INSPKEY is not reused
      -- no INSPKEY exists in INSPEVNT
      -- OR, unhappily, we are > 100 tries
    
      EXIT WHEN((ls_inspkey <> gs_last_inspkey) OR (lb_rowexists = FALSE) OR
                (ll_tries > 100));
      -- increment counter for attempts to generate INSPKEY
      ll_tries := ll_tries + 1;
    END LOOP;
  
    IF lb_rowexists OR ll_tries > 100 THEN
      -- failed after 100 attempts, or exited due to EXCEPTION!
      ls_inspkey := NULL;
    ELSE
      -- keep track of this in the loaded package...
      gs_last_inspkey := ls_inspkey;
    END IF;
  
    RETURN ls_inspkey;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE;
  END get_pontis_inspkey;

  PROCEDURE set_pontis_db_id_key IS
    -- 30 character key used for BRIDGE.DOCREFKEY for example, or any other place a unique key is needed.
    -- depends on pontis_rowkey_seq sequence.
    -- Function to determine DB_ID_KEY for the active database where this
    -- package is installed
  
  BEGIN
    -- init global DB ID KEY
    IF gs_pontis_version = '3.4' THEN
      gs_db_id_key := 'P34';
    ELSIF gs_pontis_version = '4.0' THEN
      BEGIN
        DECLARE
          ls_sqlstring VARCHAR2(255);
          ll_cur       PLS_INTEGER := DBMS_SQL.open_cursor;
          ll_ret       PLS_INTEGER := 0;
        BEGIN
          -- ACTDBROW on DBDESCRP for 4.0 stamps the row that identifies this database
          -- build 4.0 compatible lookup
          ls_sqlstring := 'SELECT NVL( DB_ID_KEY, ' || ksbms_util.sq('P40') ||
                          ' ) FROM DBDESCRP WHERE ACTDBROW = ' ||
                          ksbms_util.sq('1');
          -- evaluate SQL
          DBMS_SQL.parse(ll_cur, ls_sqlstring, DBMS_SQL.native);
          -- associate col 1 to variable
          DBMS_SQL.define_column(ll_cur, 1, gs_db_id_key, 6);
          -- get it
          ll_ret := DBMS_SQL.execute_and_fetch(ll_cur);
          --assign actual column value to variable
          DBMS_SQL.column_value(ll_cur, 1, gs_db_id_key);
          -- tidy
          DBMS_SQL.close_cursor(ll_cur);
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            DBMS_SQL.close_cursor(ll_cur);
            gs_db_id_key := 'P40'; -- default
          WHEN OTHERS THEN
            DBMS_SQL.close_cursor(ll_cur);
            /*err.RAISE (
               SQLCODE,
               'Unable to determine db_id_key using DynSQL during initialization of PONTIS_UTIL'
            );*/
        END;
      END;
    ELSE
      gs_db_id_key := NULL;
    END IF;
  END set_pontis_db_id_key; -- init DB_ID_KEY

  PROCEDURE set_pontis_version -- private
   IS
    ls_version VARCHAR2(24); -- what version...
    ls_count   PLS_INTEGER; -- any rows for a test table
  
    -- Allen 6/14/2001 - determines version of Pontis installed based
    -- on whether the table DBDESCRP exists, meaning at least 4.0, or
    -- CONDUNIT, which was obsoleted after 3.4.4.
  
    -- Arguments: NONE
    -- Returns: major version # 4.0
    -- as of 2001.06.14
    -- Todo - determine minor version number.  Probably will require an update
    -- to the DBDESCRP table in a future release.
    -- Revision:
    -- Allen 2001.06.13 used a cursor, since all we want to know is if the col DB_ID_KEY exists.
    -- before, it did a count which is EXTREMELY slow in comparison
  
    -- see if column name db_id_key is defined in sys.all_tab_columns -indicates 3.4
  
    CURSOR ls_checkver4_cur IS
      SELECT 1
        FROM SYS.all_tab_columns
       WHERE table_name = 'DBDESCRP'
         AND column_name = 'DB_ID_KEY'
         AND owner = ksbms_util.get_object_owner('ksbms_pontis_util_tmp');
  
    -- see if any entries for table CONDUNIT in all_tab_columns
    CURSOR ls_checkver34_cur IS
      SELECT 1 FROM SYS.all_tab_columns WHERE table_name = 'CONDUNIT';
  
    -- generic
    ls_ver4_rec ls_checkver4_cur%ROWTYPE;
    ls_ver3_rec ls_checkver34_cur%ROWTYPE;
  BEGIN
    BEGIN
      -- check version
      -- see if 4.0 because DBDESCRP table column DB_ID_KEY, new to 4.0, is known in system catalog all_tab_columns,
      -- if so, all done
      -- remember to check the owner of this package to make sure we look up owner
      -- of the schema, not connected user.
      OPEN ls_checkver4_cur;
      FETCH ls_checkver4_cur
        INTO ls_ver4_rec;
    
      IF ls_checkver4_cur%FOUND THEN
        ls_version := '4.0';
        CLOSE ls_checkver4_cur;
      ELSE
        -- apparently not version 4
        BEGIN
          CLOSE ls_checkver4_cur; -- tidy up.
          -- now see if condunit is there
          OPEN ls_checkver34_cur;
          FETCH ls_checkver34_cur
            INTO ls_ver3_rec;
        
          -- assumes nobody is running anything < release 3.4
          IF ls_checkver34_cur%FOUND THEN
            ls_version := '3.4';
            CLOSE ls_checkver34_cur;
          END IF;
        EXCEPTION
          WHEN OTHERS THEN
            ls_version := NULL;
            CLOSE ls_checkver34_cur;
        END;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        BEGIN
          CLOSE ls_checkver4_cur;
          ls_version := NULL;
        END;
    END;
  
    gs_pontis_version := ls_version;
  END set_pontis_version;

  FUNCTION get_nbicode_from_nbilookup(p_table_name IN VARCHAR2,
                                      p_field_name IN VARCHAR2,
                                      p_kdot_code  IN VARCHAR2)
    RETURN nbilookup.nbi_code%TYPE --ARM 3/7/2002 fixed to use anchored type
   AS
    --ARM 3/7/2002 fixed to use anchored type
    v_nbi_code nbilookup.nbi_code%TYPE; --varchar2 (10); -- HOYTURGENT nbilookup.nbi_code%type;
  BEGIN
    SELECT TRIM(UPPER(nbi_code))
      INTO v_nbi_code
      FROM nbilookup
     WHERE UPPER(table_name) = UPPER(p_table_name)
       AND UPPER(field_name) = UPPER(p_field_name)
       AND UPPER(kdot_code) = UPPER(p_kdot_code);
  
    RETURN v_nbi_code;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN NULL;
  END get_nbicode_from_nbilookup;

  -- This is called in triggers that (attempt to) pass  as a key column;
  -- if the strunitlabel is some form of missing (generously defined),
  -- then a special string containing the strunitkey is returned instead.
  FUNCTION f_strunitlabel_or_strunitkey(psi_strunitlabel IN structure_unit.strunitlabel%TYPE,
                                        pdi_strunitkey   IN structure_unit.strunitkey%TYPE)
    RETURN VARCHAR2 IS
    lb_failed  BOOLEAN := TRUE; -- Until we succeed
    ls_context ksbms_util.context_string_type := 'f_strunitlabel_or_strunitkey()';
  BEGIN
    -- Invalid STRUNITLABELs include NULL or empty strings,
    -- the magic <MISSING> string,
    -- or the default applied in Pontis's inspection module
    IF ksbms_util.f_ns(psi_strunitlabel) OR psi_strunitlabel = ls_missing OR
       TRIM(LOWER(psi_strunitlabel)) = '<please enter a unit id>' THEN
      RETURN 'STRUNITKEY={' || TO_CHAR(pdi_strunitkey) || '}';
    ELSE
      RETURN psi_strunitlabel;
    END IF;
  END f_strunitlabel_or_strunitkey;

  -- This is called in triggers that (attempt to) pass ROUTE_PREFIX as a key column;
  -- if the ROUTE_PREFIX is missing, then a special string containing the ON_UNDER
  -- value is returned instead. That string will be "fixed" later, during the merge.
  -- This function is also applied to CLR_ROUTE, so the function name is misleading!
  FUNCTION f_route_prefix_or_on_under(psi_route_prefix IN userrway.route_prefix%TYPE,
                                      psi_on_under     IN userrway.on_under%TYPE)
    RETURN VARCHAR2 IS
    lb_failed  BOOLEAN := TRUE; -- Until we succeed
    ls_context ksbms_util.context_string_type := 'f_route_prefix_or_on_under()';
  BEGIN
    -- Invalid ROUTE_PREFIXs include NULL or empty strings,
    -- and the magic <MISSING> string.
    -- NB: The passed 'route_prefix' might actually be a 'clr_route'
    IF ksbms_util.f_ns(psi_route_prefix) OR psi_route_prefix = ls_missing THEN
      RETURN 'ON_UNDER={' || psi_on_under || '}';
    ELSE
      RETURN psi_route_prefix;
    END IF;
  END f_route_prefix_or_on_under;

  FUNCTION f_clr_route(psi_clr_route IN userrway.clr_route%TYPE,
                       psi_on_under  IN userrway.on_under%TYPE)
  /* Allen Marshall, CS - 2003-01-04 - FUNCTION f_clr_route()
     returns string 'ON_UNDER = x'  if clr_route is null or missing
    this string goes in the ds_lookup_keyvals
    Added to compensate for the overloading of f_route_prefix_or_on_under in USERRWAY triggers
    where clr-route is passed, not route_prefix
    */
   RETURN VARCHAR2 IS
    lb_failed  BOOLEAN := TRUE; -- Until we succeed
    ls_context ksbms_util.context_string_type := 'f_clr_route()';
  BEGIN
    -- Invalid ROUTE_PREFIXs include NULL or empty strings,
    -- and the magic <MISSING> string.
  
    IF ksbms_util.f_ns(psi_clr_route) OR psi_clr_route = ls_missing THEN
      RETURN 'ON_UNDER={' || psi_on_under || '}';
    ELSE
      RETURN psi_clr_route;
    END IF;
  END f_clr_route;

  FUNCTION f_template RETURN BOOLEAN IS
    lb_failed  BOOLEAN := TRUE; -- Until we succeed
    ls_context ksbms_util.context_string_type := 'f_template()';
  BEGIN
  
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
  
    -- Save the changes (or not)
  
    RETURN ksbms_util.f_commit_or_rollback(lb_failed, ls_context);
  END f_template;

  FUNCTION f_is_latest_inspdate(psi_brkey   IN bridge.brkey%TYPE,
                                psi_inspkey IN inspevnt.inspkey%TYPE)
    RETURN BOOLEAN IS
    lb_failed        BOOLEAN := TRUE; -- Until we succeed
    lb_is_latest     BOOLEAN := TRUE; -- Conservative, so it gets in
    ls_context       ksbms_util.context_string_type := 'f_is_latest_inspdate()';
    ldt_inspdate     inspevnt.inspdate%TYPE;
    ldt_max_inspdate inspevnt.inspdate%TYPE;
  BEGIN
  
    <<outer_exception_block>>
    BEGIN
    
      <<do_once>>
      LOOP
        -- Get the latest INSPDATE for this BRKEY
        -- This is jammed in there by the INSPEVNT update trigger (<ENHANCEMENT>: Todo!)
        BEGIN
          SELECT TO_DATE(userkey9, 'YYYY-MM-DD')
            INTO ldt_max_inspdate
            FROM bridge
           WHERE brkey = psi_brkey;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            -- The first INSPDATE is the most recent
            lb_is_latest := TRUE;
          WHEN OTHERS THEN
            p_sql_error('SELECTing the latest INSPDATE for BRKEY ' ||
                        psi_brkey);
        END;
      
        /*            -- Get the INSPDATE for the passed BRKEY and INSPKEY
                    begin
                       select inspdate
                         into ldt_inspdate
                         from inspevnt
                        where brkey = psi_brkey AND
                              inspkey = psi_inspkey;
                    exception
                       when no_data_found
                       then
                          p_sql_error (   'No data found getting the INSPDATE for BRKEY '
                                       || psi_brkey
                                       || ' and INSPKEY '
                                       || psi_inspkey
                                                   );
                       when others
                       then
                          p_sql_error (   'SELECTing the INSPDATE for BRKEY '
                                       || psi_brkey
                                       || ' and INSPKEY '
                                       || psi_inspkey
                                                   );
                    end;
        */
        -- Is the passed date equal to or NEWER than the max?
        -- <ENHANCEMENT> Check with Allen -- To the _day_? (trunc?)
        lb_is_latest := TRUNC(ldt_inspdate) >= TRUNC(ldt_max_inspdate);
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
  
    RETURN lb_is_latest;
  END f_is_latest_inspdate;

  PROCEDURE p_delete_triggers(the_trigger_mask IN VARCHAR,
                              the_schema       IN SYS.all_tables.owner%TYPE) IS
    -- DROP 1 or more triggers in schema PONTIS by trigger mask, or explicit name
    /* TO TEST
    begin
      -- Call the procedure
      -- e.g.. dev_delete_triggers('HN', 'PONTIS');
      dev_delete_triggers(the_trigger_mask => :the_trigger_mask,
                          the_schema => :the_schema);
    end;
    
    */
    ls_schema    user_triggers.table_owner%TYPE;
    ls_ddlstring VARCHAR2(255);
    no_schema_owner EXCEPTION;
    no_trigger_mask EXCEPTION;
  BEGIN
    LOOP
      -- look up triggers for logged in or Pontis schema, selecting only those that
      -- that are found in the view USER_TRIGGERS.  These have to be disabled before
    
      -- default schema to logged in user if missing
      ls_schema := UPPER(NVL(the_schema, USER));
    
      IF the_trigger_mask IS NULL THEN
        RAISE no_trigger_mask;
      END IF;
    
      -- load a cursor from USER_triggers
      /*
      We are creating the following DDL dynamically ...
      DROP  trigger pontis.taur_userbrdg_bridgemed;
      */
      FOR the_trigger_rec IN (SELECT *
                                FROM user_triggers
                               WHERE table_owner = ls_schema
                                 AND trigger_name LIKE
                                     '' || the_trigger_mask || '%' || '') LOOP
        BEGIN
          ls_ddlstring := 'DROP TRIGGER ' || ls_schema || '.' ||
                          the_trigger_rec.trigger_name;
          DBMS_OUTPUT.put_line(ls_ddlstring);
          EXECUTE IMMEDIATE ls_ddlstring; -- NB - commented out for now - uncomment to do something
          DBMS_OUTPUT.put_line(ls_schema || ': ' || 'Trigger ' ||
                               the_trigger_rec.trigger_name || ' ' ||
                               'DROPPED successfully');
        EXCEPTION
          WHEN OTHERS THEN
            BEGIN
              RAISE;
              EXIT;
            END;
        END;
      END LOOP;
    
      EXIT WHEN TRUE;
    END LOOP;
  END p_delete_triggers;

  PROCEDURE p_suppress_false_updates
  -- procedure turns off false updates globally
   IS
  BEGIN
    -- turn them off - only really changed values will go
    gb_suppress_false_updates := TRUE;
  END p_suppress_false_updates;

  PROCEDURE p_permit_false_updates
  -- procedure turns on false updates globally
   IS
  BEGIN
    gb_suppress_false_updates := FALSE;
  END p_permit_false_updates;

  FUNCTION f_is_column_registered(the_tablename_in  IN user_tab_columns.table_name%TYPE,
                                  the_columnname_in IN user_tab_columns.column_name%TYPE)
    RETURN BOOLEAN IS
    ls_result VARCHAR2(5);
  BEGIN
  
    EXECUTE IMMEDIATE 'SELECT 1 FROM ksbms_robot.DS_TRANSFER_MAP WHERE ' ||
                      ' ksbms_robot.ds_TRANSFER_MAP.table_name = :a AND ' ||
                      ' ksbms_robot.ds_TRANSFER_MAP.column_name = :b'
      INTO ls_result
      USING the_tablename_in, the_columnname_in;
  
    RETURN TRUE;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN FALSE;
    WHEN TOO_MANY_ROWS THEN
      RETURN FALSE;
    WHEN OTHERS THEN
      RETURN FALSE;
    
  END f_is_column_Registered;

  PROCEDURE p_false_upd_all_tbl_cols(psi_table_name   IN user_tab_columns.table_name%TYPE,
                                     psi_where_clause IN VARCHAR2,
                                     pbi_null_out     IN BOOLEAN := FALSE)
  -- psi_table_name is simple table name e.g. INSPEVNT
    -- psi_Where_clause is fully formed where clause with Word WHERE at the front e.g. WHERE BRKEY ='001009'
    -- pbi_null_out = phony update sets columns to null
    -- updates all columns of a table to their existing values - false update - to force values in to the change long for CANSYS.  Useful for recovering a past inspection
    -- puts a copy of all the fields into the log ruthglessly.
    -- only puts in fields that are registered for transfer in ds_transfer_map
    -- pbi_null_out not implemented - always 0
    -- Allen R. Marshall, CS - 2002-11-29
   IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    TYPE col_values_rectype IS RECORD(
      tab_name     user_tab_columns.table_name%TYPE,
      col_name     user_tab_columns.column_name%TYPE,
      col_value    VARCHAR2(4000),
      exch_rule_id ksbms_robot.ds_transfer_map.exchange_rule_id%TYPE,
      keymap_id    ksbms_robot.ds_transfer_map.transfer_key_map_id%TYPE);
  
    TYPE col_values_tabletype IS TABLE OF col_values_rectype INDEX BY BINARY_INTEGER;
  
    col_values_rec col_values_rectype;
  
    col_values_tab col_values_tabletype;
  
    icol               PLS_INTEGER := 0;
    ls_Where           VARCHAR2(255);
    ls_SQLString       VARCHAR2(4000);
    ls_SQLUpdateString VARCHAR2(4000);
  BEGIN
    p_permit_false_updates;
    -- fill in table and column names, null out values and rules...
  
    -- initialize an update SQLString to run for all the columns in the table that we find below
    ls_SQLUpdateString := 'UPDATE ' || psi_table_name || '  SET ';
  
    FOR col_vals_rec IN (SELECT table_name, column_name --,NULL,NULL
                           FROM USER_TAB_COLUMNS u
                          WHERE u.TABLE_NAME = psi_table_name
                          ORDER BY COLUMN_ID) LOOP
      BEGIN
      
        -- 1 record only
        icol := icol + 1;
      
        --col_values_tab.EXTEND;
      
        col_Values_tab(icol).tab_name := col_vals_Rec.table_name;
        col_Values_tab(icol).col_name := col_vals_Rec.column_name;
      
        -- Get column value
      
        ls_SQLString := 'SELECT ' || col_Vals_rec.column_name || '  FROM ' ||
                        psi_table_name || NVL(psi_where_clause, '  1=0 ');
        EXECUTE IMMEDIATE ls_SQLString
          INTO col_Values_tab(icol).col_Value;
        BEGIN
          EXECUTE IMMEDIATE 'SELECT exchange_rule_id, transfer_key_map_id FROM ksbms_robot.ds_transfer_map  WHERE table_name = :1  and column_name = :2 '
            INTO col_Values_tab(icol).exch_rule_id, col_Values_tab(icol).keymap_id
            USING col_vals_Rec.table_name, col_vals_Rec.column_name;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            BEGIN
              col_Values_tab(icol).exch_rule_id := '-1';
              col_Values_tab(icol).keymap_id := '-1';
            END;
          WHEN OTHERS THEN
            BEGIN
              col_Values_tab(icol).exch_rule_id := '-1';
              col_Values_tab(icol).keymap_id := '-1';
            END;
        END;
      
        IF col_Values_tab(icol).keymap_id <> '-1' THEN
          -- in other words, a field that is exchangeable with CANSYS because it has keymaps
        
          --           ls_SQLString :=
          --           ' UPDATE ' || col_vals_rec.table_name||'  SET ' || col_vals_Rec.column_name || ' = ' ||  col_vals_Rec.column_name ||
          --             '  WHERE '  ||  psi_where_clause;
          -- add each column to the update
        
          --              EXECUTE IMMEDIATE ls_SQLString;
          --                COMMIT;
          ls_SQLUpdateString := ls_SQLUpdateString || ' ' ||
                                col_vals_Rec.column_name || ' = ' ||
                                col_vals_Rec.column_name || ', '; --COMMA BLANK AT END
          dbms_output.put_line('The table name = ' || col_Values_tab(icol)
                               .tab_name || ' ,  column = ' || col_Values_tab(icol)
                               .col_name || ', value = ' || col_Values_tab(icol)
                               .col_Value || ', rule # = ' ||
                               NVL(col_Values_tab(icol).exch_rule_id, '-1') ||
                               ', key map id # = ' ||
                               NVL(col_Values_tab(icol).keymap_id, '-1'));
        
        END IF;
      
      END;
    
    END LOOP;
    -- get rid of last ','
  
    ls_SQLUpdateString := SUBSTR(ls_SQLUpdateString,
                                 1,
                                 LENGTH(ls_SQLUpdateString) - 2);
    ls_SQLUpdateString := ls_SQLUpdateString || ' ' || psi_where_clause;
  
    EXECUTE IMMEDIATE ls_SQLUpdateString; -- fire off the notify update for transferrable columns
    COMMIT;
  
    p_suppress_false_updates;
  
  END p_false_upd_all_tbl_cols;

  /* Formatted on 2002/12/12 11:38 (Formatter Plus v4.7.0) */
  /*
   Allen R. Marshall, CS - 2002-12-12
  Procedure to keep track of the BRKEY being inserted or DELETED
  Called by STATEMENT LEVEL TRIGGERS ON BRIDGE
  EXTENSIBLE FOR ANY TABLE
  */

  PROCEDURE documentation IS
  BEGIN
    ksbms_util.pl('KSBMS_PONTIS - Pontis specific utilities');
    ksbms_util.pl('Revision History:');
    ksbms_util.pl('ARM - 2004-02-06 - updated p_turn_on_exchange and p_turn_off_exchange to suppress bogus error messages when run as KSBMS_ROBOT');
    ksbms_util.pl('ARM - 4/1/2003 - Made function f_clr_route to use with triggers where CLR_ROUTE is the lookup keyvals - still returns ON_UNDER=xx ');
    ksbms_util.pl('ARM - 1/17/2003 - All Stack Trace calls (passing ls_context or argument psi_context) now use the anchored context_string_type from ksbms_util.  Prevent too small buffer problem');
    ksbms_util.pl('ARM - 1/16/2003 - wrapped f_get_bridge_id_from_brkey() to call ksbms_pontis_util.f_get_bridge_id_from_brkey() - kept in case any code calls this one');
    ksbms_util.pl('ARM - 1/18/2002 - folded KSBMS_PONTIS_UTIL stuff back into KSBMS_PONTIS');
    ksbms_util.pl('ARM - 1/18/2002 - upped size of type key_Vals to type key_vals is varray (20) of varchar2 (32)');
    ksbms_util.pl('ARM - 1/18/2002 - added startup initializations here for gs variables');
    ksbms_util.pl('ARM - 2002-03-05 added this function by stealing it from ksbms_robot.ksbms_apply_changes wholesale ');
    ksbms_util.pl('ARM - 2002-03-05 f_kdot_functions are redundant, so consolidation is warranted ');
    ksbms_util.pl('ARM - 2002-03-08 fixed get_nbicode_from_lookup to use anchored types ');
    ksbms_util.pl('ARM - 2002-11-05 suppressed passing Pontis missing values to CANSYS - see function f_is_pontis_missing_value and f_pass_update_trigger_params ');
    ksbms_util.pl('ARM - 2002-11-05 moved this procedure DOCUMENTATION to end of code section for package KSBMS_PONTIS');
    ksbms_util.pl('ARM - 2002-11-07  in f_is_Pontis_missing_value,  removed extraneous TRIM calls here, chaned work string size to 80 so all changes coming in for evaluation can be accommodated  - was failing updates');
    ksbms_util.pl('ARM - 2002-11-25 added global boolean gb_suppress_false_updates to control whether do-nothing updates propagate their changes to the change log - see also p_suppress_false_updates and p_permit_false_updates ');
  END documentation;
  -- Package code
BEGIN
  -- Initialization
  -- <Statement>;
  --   null; -- Just so the package compiles

  -- ARM 1/18/2000 added startup initializations here for gs variables
  IF gs_pontis_version IS NULL THEN
    set_pontis_version;
  END IF;

  -- set Pontis DB IDKEY (version specific)
  IF gs_db_id_key IS NULL THEN
    set_pontis_db_id_key;
  END IF;

  -- initialize gs_last_inspkey;
  IF gs_last_inspkey IS NULL THEN
    gs_last_inspkey := 'NOTSETYET';
  END IF;

  -- make sure there is a user with USERID DEFAULT in the Pontis USERS table
  IF gs_default_userid IS NULL THEN
    gs_default_userid := 'DEFAULT';
  END IF;

  IF gs_default_userkey IS NULL THEN
    gs_default_userkey := f_get_userkey_for_orauser(gs_default_userid);
  END IF;

  IF gs_pontis_missing_values IS NULL THEN
    -- somehow, so initialize
    gs_pontis_missing_values := '|_|!|>|<|#|&|/|~|+|}|{|?|@|-1|-2|-3|-4|-5|-6|-7|-8|-9|';
  END IF;
  -- Allen 11/25/2002 - activate the variable that controls propagation of phony updates
  -- to the ds_change_log
  IF gb_suppress_false_updates IS NULL THEN
    p_suppress_false_Updates;
  END IF;
END ksbms_pontis;
/