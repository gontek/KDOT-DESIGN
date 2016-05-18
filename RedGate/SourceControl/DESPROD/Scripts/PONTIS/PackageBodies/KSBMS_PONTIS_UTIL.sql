CREATE OR REPLACE PACKAGE BODY pontis."KSBMS_PONTIS_UTIL"
IS
     -- this variable is for INSERTS to the table DATASYNC_CHANGE_LOG, column status
     gs_default_exchange_log_status   ds_exchange_status.status_label%TYPE;

     FUNCTION f_get_userkey_for_orauser (the_user IN VARCHAR2)
          RETURN users.userkey%TYPE;

     FUNCTION f_ispontisuser (the_userid IN VARCHAR2)
          -- Allen 7/27/2001 Function to see if users belongs to Pontis users.
          -- pass USER or an arbitrary user name from Oracle to see if in Pontis.

     RETURN BOOLEAN;

     FUNCTION f_ispontisuser (the_userid IN VARCHAR2)
          -- Allen 7/27/2001 Function to see if users belongs to Pontis users.
     RETURN BOOLEAN
     IS
     BEGIN
          RETURN     f_get_userkey_for_orauser (the_userid) =
                                                           gs_default_userkey
                 AND the_userid <> gs_default_userid;
     END f_ispontisuser;

     FUNCTION f_get_userkey_for_orauser (the_user IN VARCHAR2)
          -- Allen 7/27/2001
     RETURN users.userkey%TYPE
     IS
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

          v_user            users.userkey%TYPE   := gs_default_userkey;
          -- Exception when cannot find a legitimate userid for a record - ARM 7/27/2001
          no_userid_found   EXCEPTION;
          PRAGMA EXCEPTION_INIT (no_userid_found, -20009);
     BEGIN
          -- for logged in USER, find a userkey, or use the default userkey of 9999 if none found
          --ARM 1/20/2001 removed NVL(userkey,'NOTFOUND')
          BEGIN
               SELECT userkey
                 INTO v_user
                 FROM users u
                WHERE UPPER (u.userid) = NVL (UPPER (the_user), USER); -- ARM 7/26/2001 just to be sure...
          EXCEPTION
               WHEN NO_DATA_FOUND
               -- No data, try finding a default userkey using the default userid
               THEN
                    BEGIN
                         SELECT userkey
                           INTO v_user
                           FROM users u
                          WHERE UPPER (u.userid) = UPPER (gs_default_userid);
                    EXCEPTION
                         -- this means the default userid is missing from the USERS table so no key can be
                         -- determined.  Function returns NULL.

                         WHEN NO_DATA_FOUND
                         THEN
                              RAISE no_userid_found;
                         WHEN OTHERS
                         THEN
                              RAISE;
                    END;
               WHEN OTHERS
               THEN
                    RAISE;
          END;

          -- send back the userkey value
          RETURN v_user;
     EXCEPTION
          WHEN no_userid_found
          THEN
               raise_application_error (SQLCODE,
                                            'Unable to lookup userkey for Oracle user = '
                                         || the_user -- ARM 1/2/2002 NOT USER
                                       );
               RETURN NULL;
          WHEN OTHERS
          THEN
               RAISE;
     END f_get_userkey_for_orauser;

     FUNCTION f_parse_csv_into_array (the_list_in IN VARCHAR2)
          RETURN key_vals
     IS
          ls_token      VARCHAR2 (255);
          lv_result     key_vals       := key_vals (); -- initialize to EMPTY ( not null );
          ith           PLS_INTEGER    := 1;
          li_startpos   PLS_INTEGER;
          li_endpos     PLS_INTEGER;
          li_last       PLS_INTEGER;
     BEGIN
          LOOP

               <<control_loop>>
               IF the_list_in IS NULL
               THEN
                    EXIT;
               END IF;

               ith := 1;
               li_startpos := 1;
               li_endpos := INSTR (the_list_in, ',', 1);

               IF li_endpos > 0
               THEN
                    LOOP
                         -- extract string token
                         lv_result.EXTEND;
                         lv_result (ith) :=
                              SUBSTR (the_list_in,
                                      li_startpos,
                                       li_endpos - li_startpos
                                     );
                         ith := ith + 1;

                         IF ith > 50
                         THEN
                              EXIT;
                         END IF; -- only 50 cells for destination addresses

                                 -- reset start with next token

                         li_startpos := li_endpos + 1;

                         IF li_startpos > LENGTH (the_list_in)
                         THEN
                              EXIT;
                         END IF;

                         -- see if there is another token (another , )
                         li_endpos := INSTR (the_list_in, ',', 1, ith);
                         EXIT WHEN li_endpos = 0; -- no more commas
                    END LOOP;

                    IF ith > 1
                    THEN
                         BEGIN
                              lv_result.EXTEND;
                              li_last :=
                                         LENGTH (the_list_in) + 1
                                         - li_startpos;
                              ls_token :=
                                   TRIM (SUBSTR (the_list_in,
                                                 li_startpos,
                                                 li_last
                                                )
                                        );
                              lv_result (ith) := ls_token;
                         END;
                    END IF;
               ELSE
                    lv_result.EXTEND;
                    lv_result (1) := the_list_in;
               END IF;

               EXIT WHEN TRUE;
          END LOOP control_loop;

          RETURN lv_result;
     END f_parse_csv_into_array;

     FUNCTION get_nbicode_from_nbilookup (
          p_table_name   IN   VARCHAR2,
          p_field_name   IN   VARCHAR2,
          p_kdot_code    IN   VARCHAR2
     )
          RETURN VARCHAR2
     AS
          v_nbi_code   VARCHAR2 (10); -- HOYTURGENT nbilookup.nbi_code%type;
     BEGIN
          /* HOYTURGENT
          select trim (upper (nbi_code))
            into v_nbi_code
            from nbilookup
           where upper (table_name) = upper (p_table_name)
             and upper (field_name) = upper (p_field_name)
             and upper (kdot_code) = upper (p_kdot_code);
          */
          RETURN v_nbi_code;
     EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
               RETURN NULL;
     END get_nbicode_from_nbilookup;

     FUNCTION recode_designload (
-- Allen 5/17/2001
--pDesignLoad_Type, pDesignLoad_KDOT ON USERBRDG
-- CHANGE USERBRDG table NAME IF NECESSARY
-- Anchored by %TYPE
-- Added exception handling, messages to explain problemn
-- returns null if it fails - test for null in calling trigger

-- arguments
          pdesignload_type   IN   userbrdg.designload_type%TYPE,
          pdesignload_kdot   IN   userbrdg.designload_kdot%TYPE,
          pnullallowed       IN   BOOLEAN
     )
          RETURN NUMBER
     IS
-- variables
          new_designload            bridge.designload%TYPE;                                                   -- char(1) as of Pontis 4.0
                                                            -- change the next declaration to assign a different
                                                            -- default return code
          missing_designload        bridge.designload%TYPE   := NULL;
          --'X' returned from function indicates exception raised
          --'X' cannot be a good value for designload....
          bad_designload            bridge.designload%TYPE   := 'X';
-- exceptions
          null_designload_type      EXCEPTION;
          invalid_designload_type   EXCEPTION;
          null_designload_kdot      EXCEPTION;
          invalid_designload_kdot   EXCEPTION;
          invalid_result            EXCEPTION;
     BEGIN
          -- Allen 5/17/2001 change
          /*
             Validate inputs
             We must have a valid Designload_KDOT and pDesignLoad_Type
             designload >=0 and not null
             type in the magic numbers (string) 1-7 and not null
          */
          -- Check KDOT designload values
          IF pdesignload_kdot IS NULL
          THEN
               RAISE null_designload_kdot;
          END IF;

          IF pdesignload_kdot <= 0
          THEN
               RAISE invalid_designload_kdot;
          END IF;

          -- Check KDOT designload types
          IF pdesignload_type IS NULL
          THEN
               RAISE null_designload_type;
          END IF;

          IF pdesignload_type NOT IN ('1', '2', '3', '4', '5', '6', '7')
          THEN
               RAISE invalid_designload_type;
          END IF;

          -- initialize design load result new_DesignLoad to NULL
          new_designload := missing_designload;

          -- Recode rules
          -- If  pDesignLoad_KDOT is less than 13.5 set this item to 1;
          -- If  :NEW.pDesignLoad_Type is 1 or 2 or 4 and pDesignLoad_KDOT is  >= 13.5 and < 18, set this item to 2;
          -- If  :NEW.pDesignLoad_Type is 3 or 5 and pDesignLoad_KDOT is >=13.5 and < 18, set this item to 3;
          -- If :NEW.pDesignLoad_Type is 1, 2 or 4 and pDesignLoad_KDOT  is >= 18, set this item to 4;
          -- If :NEW.pDesignLoad_Type is 3 and pDesignLoad_KDOT is  >= 18 and < 22.5, set this item to 5;
          -- If :NEW.pDesignLoad_Type is 5 and pDesignLoad_KDOT is >= 18 and < 22.5, set this item to 6;
          -- If :NEW.pDesignLoad_Type is equal to 7, set this item to 7;
          -- If :NEW.pDesignLoad_Type is equal to 6, set this item to 8;
          -- If :NEW.pDesignLoad_Type  is 3 or 5 and pDesignLoad_KDOT is >= 22.5, set this item to 9;


          -- first see if in the 'outliers' 6,7
          IF pdesignload_type IN ('6', '7')
          THEN
               IF pdesignload_type = '7'
               THEN
                    new_designload := '7';
               ELSE
                    new_designload := '8';
               END IF;
          ELSE   -- design load type not in 6,7, check by load range
               -- >0 only
               IF pdesignload_kdot > 0 AND pdesignload_kdot < 13.5
               THEN
                    new_designload := '1';
               ELSIF pdesignload_kdot >= 13.5 AND pdesignload_kdot < 18
               THEN
                    IF pdesignload_type IN ('1', '2', '4')
                    THEN
                         new_designload := '2';
                    ELSIF pdesignload_type IN ('3', '5')
                    THEN
                         new_designload := '3';
                    END IF;
               ELSIF pdesignload_kdot >= 18
               THEN
                    IF (pdesignload_type IN ('1', '2', '4'))
                    THEN
                         new_designload := '4';
                    ELSE
                         -- for types not in 1,2,4, decide by value of designload
                         IF pdesignload_kdot < 22.5
                         THEN
                              IF pdesignload_type = '3'
                              THEN
                                   new_designload := '5';
                              ELSIF pdesignload_type = '5'
                              THEN
                                   new_designload := '6';
                              END IF;
                         ELSE -- >= 22.5
                              IF pdesignload_type IN ('3', '5')
                              THEN
                                   new_designload := '9';
                              END IF;
                         END IF;
                    END IF;
               ELSE -- fell through, not allowed
                    RAISE invalid_result;
               END IF;
          END IF;

          -- see if we got a value, raise error invalid_result if null or <=0
          -- if pNullAllowed is TRUE then NULL is OK as a result
          -- negative numbers are never OK as a result

          IF (   (new_designload IS NULL AND NOT pnullallowed)
              OR TO_NUMBER (new_designload) <= 0
             )
          THEN
               RAISE invalid_result;
          END IF;

          -- Success!
          RETURN (new_designload);
     EXCEPTION
-- TODO - KDOT Specific exception handlers
          WHEN null_designload_type
          THEN
               BEGIN
                    raise_application_error (-20000,
                                             'NULL Design Load Type passed to function recode_designload'
                                            );
                    RETURN (bad_designload);
               END;
          WHEN invalid_designload_type
          THEN
               BEGIN
                    raise_application_error (-20000,
                                             'INVALID (not in 1-7) Design Load Type passed to function recode_designload'
                                            );
                    RETURN (bad_designload);
               END;
          WHEN null_designload_kdot
          THEN
               BEGIN
                    raise_application_error (-20000,
                                             'NULL Design Load Value passed to function recode_designload'
                                            );
                    RETURN (bad_designload);
               END;
          WHEN invalid_designload_kdot
          THEN
               BEGIN
                    raise_application_error (-20000,
                                             'INVALID (<=0) Design Load Value passed to function recode_designload'
                                            );
                    RETURN (bad_designload);
               END;
          WHEN invalid_result
          THEN
               BEGIN
                    raise_application_error (-20000,
                                             'INVALID result (NULL or <=0) for BRIDGE.DESIGNLOAD calculated by function recode_designload'
                                            );
                    RETURN (bad_designload);
               END;
          WHEN OTHERS
          THEN
               BEGIN
                    raise_application_error (-20000,
                                                 'Unable to determine recoded value for BRIDGE.DESIGNLOAD - '
                                              || SQLERRM
                                            );
                    RETURN (bad_designload);
               END;
     END recode_designload;

     PROCEDURE p_get_primary_key_names (
          p_table_name   IN       SYS.all_tables.table_name%TYPE,
          p_key_names    OUT      key_name_array
     )
     IS
          -- LOOKUP CONSTRAINT NAME USING SYS.ALL_CONSTRAINTS;
          --select * from sys.all_constraints t WHERE constraint_type = 'P'
          -- LOOKUP CONSTRAINT COLUMNS USING SYS.ALL_CONS_COLUMNS
          --
          /*
          CURSOR cur_key_names IS
          SELECT COLUMN_NAME FROM SYS.ALL_CONS_COLUMNS
          WHERE TABLE_NAME = p_table_name AND
          CONSTRAINT_NAME = (SELECT CONSTRAINT_NAME FROM sys.all_constraints t WHERE constraint_type = 'P' AND table_name = p_table_name)
          ORDER BY POSITION ASC;
          */
          irow   PLS_INTEGER := 0;
     BEGIN
          -- init array to empty.
          p_key_names := key_name_array ();
          -- First two keys are ROWID, and the CANSYS STR_ID (STR_TOP_ID)

          p_key_names.EXTEND;
          p_key_names (1) := 'ROWID';
          p_key_names.EXTEND;
          p_key_names (2) := 'CII_XREF_ID'; -- CANSYS xref field - may contain str_id, str_top_id, or a variant of str_id for roadways.
          irow := p_key_names.COUNT;

          -- load table key column names into the array.

          FOR key_rec IN (SELECT   column_name
                              FROM SYS.all_cons_columns
                             WHERE table_name = p_table_name
                               AND constraint_name =
                                        (SELECT constraint_name
                                           FROM SYS.all_constraints t
                                          WHERE constraint_type = 'P'
                                            AND table_name = p_table_name)
                          ORDER BY POSITION ASC)
          LOOP -- through all primary keys names
               irow := irow + 1;
               p_key_names.EXTEND;
               p_key_names (irow) := key_rec.column_name;
          END LOOP;
     EXCEPTION
          -- there HAS to be a primary key on any tables we
          -- are using...
          WHEN NO_DATA_FOUND
          THEN
               RAISE;
          WHEN OTHERS
          THEN
               RAISE;
     END p_get_primary_key_names;

     -- Get the value used for ds_change_log.entry_id and ds_lookup_keyvals.entry_id
     FUNCTION f_get_entry_id
          RETURN VARCHAR2
     IS
          RESULT   VARCHAR2 (32);
     BEGIN
          -- Get the 32-character string provided by sys_guid()
          SELECT SYS_GUID ()
            INTO RESULT
            FROM DUAL;

          -- Return the magic string
          RETURN (RESULT);
     EXCEPTION
          WHEN OTHERS
          THEN
               RAISE;
               RETURN NULL;
     END f_get_entry_id;

     PROCEDURE trig_test
     IS
     BEGIN
          UPDATE userbrdg
             SET bridgemed_kdot = '3'
           WHERE brkey = '001002';
     END;

     FUNCTION get_pontis_version
          RETURN VARCHAR2
     IS
     BEGIN
          RETURN gs_pontis_version;
     END;

     -- Return the db_id_key if available in database (4.0) only
     FUNCTION get_pontis_db_id_key
          RETURN VARCHAR2
     IS
     BEGIN
          RETURN gs_db_id_key;
     END;

     -- generate an inspkey ( 4 letters )
     -- no obscenity check.

     FUNCTION get_pontis_inspkey (the_brkey_in IN VARCHAR2)
          RETURN VARCHAR2
     IS
          ll_tries           PLS_INTEGER  := 0;
          ls_inspkey         VARCHAR2 (4) := 'XXXX';
          ll_seq             PLS_INTEGER  := 0;
          lb_rowexists       BOOLEAN      := TRUE;
          base_ascii_val     PLS_INTEGER  := 65; -- A=65, 65+0 = A
          ascii_char_range   PLS_INTEGER  := 25; -- A-Z
          no_inspkey_found   EXCEPTION;
     BEGIN
          LOOP -- through, try to create INSPKEY
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
                    SELECT    CHR (  GREATEST (0,
                                               LEAST (ROUND (  (  ksbms_util.random (2
                                                                                    )
                                                                / 100
                                                               )
                                                             * ascii_char_range,
                                                             0
                                                            )
                                                     )
                                              )
                                   + base_ascii_val
                                  )
                           || CHR (  GREATEST (0,
                                               LEAST (ROUND (  (  (  100
                                                                   - ksbms_util.random (2
                                                                                       )
                                                                  )
                                                                / 100
                                                               )
                                                             * ascii_char_range,
                                                             0
                                                            )
                                                     )
                                              )
                                   + base_ascii_val
                                  )
                           || CHR (  GREATEST (0,
                                               LEAST (ROUND (  (  ksbms_util.random (2
                                                                                    )
                                                                / 100
                                                               )
                                                             * ascii_char_range,
                                                             0
                                                            )
                                                     )
                                              )
                                   + base_ascii_val
                                  )
                           || CHR (  GREATEST (0,
                                               LEAST (ROUND (  (  (  100
                                                                   - ksbms_util.random (2
                                                                                       )
                                                                  )
                                                                / 100
                                                               )
                                                             * ascii_char_range,
                                                             0
                                                            )
                                                     )
                                              )
                                   + base_ascii_val
                                  )
                      INTO ls_inspkey
                      FROM DUAL;
               EXCEPTION
                    WHEN NO_DATA_FOUND
                    THEN
                         -- Hoyt 1/11/2002
                         ksbms_util.p_sql_error ('get_pontis_inspkey(): no_data_found!'
                                                );
                    WHEN OTHERS
                    THEN
                         -- Hoyt 1/11/2002
                         ksbms_util.p_sql_error ('get_pontis_inspkey(): others!'
                                                );
               END;

               -- test for uniqueness of BRKEY amd test value in table INSPEVNT ...
               -- Allen 06.21.2001 - f_any_rows_exist returns TRUE if found.
               -- All exceptions are raised in the called store procedure count_rows_for_table in PONTIS_UTIL

               lb_rowexists :=
                    ksbms_util.f_any_rows_exist ('INSPEVNT',
                                                     'BRKEY = '
                                                  || ksbms_util.sq (the_brkey_in
                                                                   )
                                                  || ' and inspkey = '
                                                  || ksbms_util.sq (ls_inspkey)
                                                );
               -- check if done..
               -- INSPKEY is not reused
               -- no INSPKEY exists in INSPEVNT
               -- OR, unhappily, we are > 100 tries

               EXIT WHEN (   (ls_inspkey <> gs_last_inspkey)
                          OR (lb_rowexists = FALSE)
                          OR (ll_tries > 100)
                         );
               -- increment counter for attempts to generate INSPKEY
               ll_tries := ll_tries + 1;
          END LOOP;

          IF lb_rowexists OR ll_tries > 100
          THEN -- failed after 100 attempts, or exited due to EXCEPTION!
               ls_inspkey := NULL;
          ELSE
               -- keep track of this in the loaded package...
               gs_last_inspkey := ls_inspkey;
          END IF;

          RETURN ls_inspkey;
     EXCEPTION
          WHEN OTHERS
          THEN
               RAISE;
     END get_pontis_inspkey;

     FUNCTION f_get_pontis_on_under (the_brkey_in IN VARCHAR2)
          RETURN VARCHAR2
     IS
          ll_tries                      PLS_INTEGER    := 0;
          ls_on_under                   VARCHAR2 (2)   := 'XX'; -- test value, returned if OKAY
          ll_seq                        PLS_INTEGER    := 0;
          lb_rowexists                  BOOLEAN        := TRUE;
          base_ascii_val                PLS_INTEGER    := 65; -- A=65, 65+0 = A
          ascii_char_range              PLS_INTEGER    := 25; -- A-Z
          no_inspkey_found              EXCEPTION;
          -- these 2-char values are not okay to generate randomly in this domain - exclude
          cs_excluded_values   CONSTANT VARCHAR2 (255)
                          := '|22|24|90|92|93|94|96|97|98|99|10|30|50|51|70|';
     /* usage in ksbms_apply_changes - exclude the constants below
                THEN
                   ls_on_under := '22';
              ELSIF ls_feat_cross_type = '4'
              THEN
                   ls_on_under := '24';
              -- Hoyt 08/07/2002 Per NAC's email, on_under = feat_cross_type for these values
              ELSIF ls_feat_cross_type IN
                            ('90', '92', '93', '94', '96', '97', '98', '99')
              THEN
                   ls_on_under := ls_feat_cross_type;
              ELSIF ls_feat_cross_type IN ('10', '30', '50', '51', '70')
     */
     BEGIN
          LOOP -- through, try to create 2 character ON_UNDER VALUE
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

-- always two characters
                    SELECT    CHR (  GREATEST (0,
                                               LEAST (ROUND (  (  ksbms_util.random (2
                                                                                    )
                                                                / 100
                                                               )
                                                             * ascii_char_range,
                                                             0
                                                            )
                                                     )
                                              )
                                   + base_ascii_val
                                  )
                           || CHR (  GREATEST (0,
                                               LEAST (ROUND (  (  (  100
                                                                   - ksbms_util.random (2
                                                                                       )
                                                                  )
                                                                / 100
                                                               )
                                                             * ascii_char_range,
                                                             0
                                                            )
                                                     )
                                              )
                                   + base_ascii_val
                                  )
                      INTO ls_on_under
                      FROM DUAL;
               EXCEPTION
                    WHEN NO_DATA_FOUND
                    THEN
                         -- Hoyt 1/11/2002
                         ksbms_util.p_sql_error ('get_pontis_inspkey(): no_data_found!'
                                                );
                    WHEN OTHERS
                    THEN
                         -- Hoyt 1/11/2002
                         ksbms_util.p_sql_error ('get_pontis_inspkey(): others!'
                                                );
               END;

                -- test for uniqueness of BRKEY amd test value in table INSPEVNT ...
                -- Allen 06.21.2001 - f_any_rows_exist returns TRUE if found.
                -- All exceptions are raised in the called store procedure count_rows_for_table in PONTIS_UTIL
               -- see if in not allowed or a row already exists in ROADWAY
               lb_rowexists :=
                        INSTR (cs_excluded_values, '|' || ls_on_under || '|') >
                                                                             0
                     OR ksbms_util.f_any_rows_exist ('ROADWAY',
                                                         'BRKEY = '
                                                      || ksbms_util.sq (the_brkey_in
                                                                       )
                                                      || ' and ON_UNDER = '
                                                      || ksbms_util.sq (ls_on_under
                                                                       )
                                                    );
               -- check if done..
               -- value not in excluded list
               -- no ON_UNDER exists in ROADWAY for this BRKEY
               -- OR, unhappily, we are > 100 tries

               EXIT WHEN (lb_rowexists = FALSE) OR (ll_tries > 100);
               -- increment counter for attempts to generate INSPKEY
               ll_tries := ll_tries + 1;
          END LOOP;

          IF lb_rowexists OR ll_tries > 100
          THEN -- failed after 100 attempts, or exited due to EXCEPTION!
               ls_on_under := NULL;
          END IF;

          RETURN ls_on_under;
     EXCEPTION
          WHEN OTHERS
          THEN
               RAISE;
     END f_get_pontis_on_under;

     -- 30 character key used for BRIDGE.DOCREFKEY for example, or any other place a unique key is needed.
     -- depends on pontis_rowkey_seq sequence.

     FUNCTION get_pontis_rkey
          RETURN SYS.all_tab_columns.table_name%TYPE
     IS
          -- we use a well-known 30 character standard for the value
          ls_testkey     SYS.all_tab_columns.table_name%TYPE;
          ls_version     VARCHAR2 (24)               := get_pontis_version ();
          ll_keyval      PLS_INTEGER;
          ls_sqlstring   VARCHAR2 (255);
     BEGIN
      /* HOYTURGENT
      select rowidkey_seq.nextval
        into ll_keyval
        from dual;
      */
-- SERIALKEY FORMAT XXXXXXMMDDYYHHMISS099999999999;
-- 30 chars         123456789012345678901234567890
          ls_testkey :=
               REPLACE (   gs_db_id_key
                        || TO_CHAR (SYSDATE, 'MMDDYYHHMISS')
                        || TO_CHAR (ll_keyval, '099999999999'),
                        ' '
                       );
          RETURN ls_testkey;
     EXCEPTION
          WHEN NO_DATA_FOUND
          THEN -- Bad SEQUENCE!
               /*err.RAISE (
                  SQLCODE,
                  'Unable to determine next sequence from pontis_rowkey_seq'
               );*/
               RETURN NULL;
          WHEN OTHERS -- who cares, just return null and let calling routine
                      -- handle the issue
          THEN
               RETURN NULL;
     END get_pontis_rkey;

     PROCEDURE set_pontis_version -- private
     IS
          ls_version    VARCHAR2 (24); -- what version...
          ls_count      PLS_INTEGER; -- any rows for a test table

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

          CURSOR ls_checkver4_cur
          IS
               SELECT 1
                 FROM SYS.all_tab_columns
                WHERE table_name = 'DBDESCRP'
                  AND column_name = 'DB_ID_KEY'
                  AND owner =
                             ksbms_util.get_object_owner ('ksbms_pontis_util');

          -- see if any entries for table CONDUNIT in all_tab_columns
          CURSOR ls_checkver34_cur
          IS
               SELECT 1
                 FROM SYS.all_tab_columns
                WHERE table_name = 'CONDUNIT';

          -- generic
          ls_ver4_rec   ls_checkver4_cur%ROWTYPE;
          ls_ver3_rec   ls_checkver34_cur%ROWTYPE;
     BEGIN
          BEGIN    -- check version
                -- see if 4.0 because DBDESCRP table column DB_ID_KEY, new to 4.0, is known in system catalog all_tab_columns,
                -- if so, all done
                -- remember to check the owner of this package to make sure we look up owner
                -- of the schema, not connected user.
               OPEN ls_checkver4_cur;
               FETCH ls_checkver4_cur INTO ls_ver4_rec;

               IF ls_checkver4_cur%FOUND
               THEN
                    ls_version := '4.0';
                    CLOSE ls_checkver4_cur;
               ELSE -- apparently not version 4
                    BEGIN
                         CLOSE ls_checkver4_cur;                         -- tidy up.
                                                 -- now see if condunit is there
                         OPEN ls_checkver34_cur;
                         FETCH ls_checkver34_cur INTO ls_ver3_rec;

                         -- assumes nobody is running anything < release 3.4
                         IF ls_checkver34_cur%FOUND
                         THEN
                              ls_version := '3.4';
                              CLOSE ls_checkver34_cur;
                         END IF;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              ls_version := NULL;
                              CLOSE ls_checkver34_cur;
                    END;
               END IF;
          EXCEPTION
               WHEN OTHERS
               THEN
                    BEGIN
                         CLOSE ls_checkver4_cur;
                         ls_version := NULL;
                    END;
          END;

          gs_pontis_version := ls_version;
     END set_pontis_version;

     PROCEDURE set_pontis_db_id_key
     IS
-- 30 character key used for BRIDGE.DOCREFKEY for example, or any other place a unique key is needed.
-- depends on pontis_rowkey_seq sequence.
-- Function to determine DB_ID_KEY for the active database where this
-- package is installed

     BEGIN
          -- init global DB ID KEY
          IF gs_pontis_version = '3.4'
          THEN
               gs_db_id_key := 'P34';
          ELSIF gs_pontis_version = '4.0'
          THEN
               BEGIN
                    DECLARE
                         ls_sqlstring   VARCHAR2 (255);
                         ll_cur         PLS_INTEGER   := DBMS_SQL.open_cursor;
                         ll_ret         PLS_INTEGER    := 0;
                    BEGIN
                         -- ACTDBROW on DBDESCRP for 4.0 stamps the row that identifies this database
                          -- build 4.0 compatible lookup
                         ls_sqlstring :=
                                  'SELECT NVL( DB_ID_KEY, '
                               || ksbms_util.sq ('P40')
                               || ' ) FROM DBDESCRP WHERE ACTDBROW = '
                               || ksbms_util.sq ('1');
                         -- evaluate SQL
                         DBMS_SQL.parse (ll_cur, ls_sqlstring,
                                         DBMS_SQL.native);
                         -- associate col 1 to variable
                         DBMS_SQL.define_column (ll_cur, 1, gs_db_id_key, 6);
                         -- get it
                         ll_ret := DBMS_SQL.execute_and_fetch (ll_cur);
                         --assign actual column value to variable
                         DBMS_SQL.column_value (ll_cur, 1, gs_db_id_key);
                         -- tidy
                         DBMS_SQL.close_cursor (ll_cur);
                    EXCEPTION
                         WHEN NO_DATA_FOUND
                         THEN
                              DBMS_SQL.close_cursor (ll_cur);
                              gs_db_id_key := 'P40'; -- default
                         WHEN OTHERS
                         THEN
                              DBMS_SQL.close_cursor (ll_cur);
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



                               --  pass brkey and inspkey, returns TRUE if the bridge + inspkey combination exists in table INSPEVNT
                               -- BRKEY is never upperized
                               -- INSPKEY is always UPPERIZED
                               -- RETURNS NULL if bad arguments
                               -- RETURNS TRUE if found
                               -- RETURNS FALSE if NOT found

     PROCEDURE sync_datadict
     IS
          ls_version                         VARCHAR2 (24)
                                                     := get_pontis_version ();
          ll_datadict_rows                   PLS_INTEGER               := 0;
          ll_deleted_rows                    PLS_INTEGER               := 0;
          ll_insertedrows                    PLS_INTEGER               := 0;
          ll_missingrows                     PLS_INTEGER               := 0;
          ls_unique_name                     datadict.col_alias%TYPE;
          lb_loop_error                      BOOLEAN                 := FALSE;                                                                        -- signal from EXCEPTION block inside a loop that a problem occurred.
                                                                               -- we need to be careful about concatenating stuff and exceeding table name lengths across versions
          c_max_len_table_name_34   CONSTANT PLS_INTEGER               := 16;
          c_max_len_table_name_4    CONSTANT PLS_INTEGER               := 24;
          -- flag for avoiding records with too-long tablenames and so on
          skiprec                            BOOLEAN                 := FALSE;
          -- for maintenance
          ls_miss_ch1                        VARCHAR2 (1)              := '_';
          -- to be prepared dynamically in a switch later between versions.
          ls_sqlstring                       VARCHAR2 (500);
          ll_ins_cur                         PLS_INTEGER
                                                      := DBMS_SQL.open_cursor;
          exc_bad_version                    EXCEPTION;

          CURSOR updatecursor
          IS
               SELECT   *
                   FROM SYS.all_tab_columns v
                  WHERE v.owner = ksbms_util.f_get_table_owner ('DATADICT')
                    AND (    v.table_name IN (
                                            SELECT DISTINCT UPPER (table_name)
                                                       FROM datadict)
                         AND v.column_name IN (
                                  SELECT DISTINCT UPPER (col_name)
                                             FROM datadict
                                            WHERE UPPER (datadict.table_name) =
                                                                  v.table_name)
                        )
               ORDER BY v.table_name, v.column_id;

          CURSOR missingcursor
          IS
               SELECT   *
                   FROM SYS.all_tab_columns v
                  WHERE v.owner = ksbms_util.f_get_table_owner ('DATADICT')
                    AND (   v.table_name NOT IN (
                                            SELECT DISTINCT UPPER (table_name)
                                                       FROM datadict)
                         OR v.column_name NOT IN (
                                 SELECT DISTINCT UPPER (col_name)
                                            FROM datadict
                                           WHERE UPPER (datadict.table_name) =
                                                                  v.table_name)
                        )
               ORDER BY v.table_name, v.column_id;
/*
|| FORMAT OF ALL_TAB_COLUMNS - WE ONLY NEED CERTAIN FIELDS
||  1 owner, varchar2(30), , , ,
||  2 table_name, varchar2(30), , , table, view or cluster name,
||  3 column_name, varchar2(30), , , column name,
||  4 data_type, varchar2(106), y, , datatype of the column,
||  5 data_type_mod, varchar2(3), y, , datatype modifier of the column,
||  6 data_type_owner, varchar2(30), y, , owner of the datatype of the column,
||  7 data_length, number, , , length of the column in bytes,
||  8 data_precision, number, y, , length: decimal digits (number) or binary digits (float),
||  9 data_scale, number, y, , digits to right of decimal point in a number,
|| 10 nullable, varchar2(1), y, , does column allow null values?,
|| 11 column_id, number, , , sequence number of the column as created,
|| 12 default_length, number, y, , length of default value for the column,
|| 13 data_default, long, y, , default value for the column,
|| 14 num_distinct, number, y, , the number of distinct values in the column,
|| 15 low_value, raw(32), y, , the low value in the column,
|| 16 high_value, raw(32), y, , the high value in the column,
|| 17 density, number, y, , the density of the column,
|| 18 num_nulls, number, y, , the number of nulls in the column,
|| 19 num_buckets, number, y, , the number of buckets in histogram for the column,
|| 20 last_analyzed, date, y, , the date of the most recent time this column was analyzed,
|| 21 sample_size, number, y, , the sample size used in analyzing this column,
|| 22 character_set_name, varchar2(44), y, , character set name,
|| 23 char_col_decl_length, number, y, , declaration length of character type column,
|| 24 global_stats, varchar2(3), y, , are the statistics calculated without merging underlying partitions?,
|| 25 user_stats, varchar2(3), y, , were the statistics entered directly by the user?,
|| 26 avg_col_len, number, y, , the average length of the column in bytes
*/
     BEGIN
          -- immediately test if version is in the allowables
          IF ls_version NOT IN ('3.4', '4.0')
          THEN
               RAISE ksbms_exc.exc_pontis_version_error;
          END IF;

          /*
             Delete all records in DATADICT not found at all in all_tab_columns - both version
          */
          ksbms_util.pl ('Starting processing');

          LOOP
               BEGIN
                    -- how many rows are there at the beginning of processing?
                    SELECT NVL (COUNT (*), 0)
                      INTO ll_datadict_rows
                      FROM datadict;

                    ll_deleted_rows := ll_datadict_rows;
               EXCEPTION
                    WHEN OTHERS
                    THEN -- any SQL error or whatever
                         BEGIN
                              IF NVL (ll_datadict_rows, 0) = 0
                              THEN
                                   -- arg 1 = Pontis error.
                                   ksbms_err.handle (1,
                                                     ksbms_exc.application_exception,
                                                     'Error selecting from DATADICT before DELETE',
                                                     FALSE,
                                                     TRUE
                                                    );
                                   EXIT; -- no rows to process
                              END IF;
                         END;
               END;

               -- kill records in DATADICT where not found in sys.all_tab_columns
               ksbms_util.pl ('Deleting records in DATADICT not found in sys.all_tab_columns...'
                             );
               ksbms_util.pl ('These are (stale) table entries in the Pontis DATADICT table '
                             );
               ksbms_util.pl ('which do not correspond to instantiated Oracle tables...'
                             );
               ksbms_util.pl (   'Records before delete  : '
                              || ksbms_util.display_zero_as_label (ll_datadict_rows,
                                                                   '09999',
                                                                   '<none>'
                                                                  )
                             );

               BEGIN
                    DELETE FROM datadict d
                          WHERE UPPER (d.table_name) NOT IN (
                                     SELECT view_name
                                       FROM SYS.all_views
                                      WHERE owner =
                                                 ksbms_util.get_object_owner ('ksbms_pontis_util'
                                                                             ))
                            AND (   UPPER (d.table_name) NOT IN (
                                         SELECT s.table_name
                                           FROM SYS.all_tables s
                                          WHERE s.owner =
                                                     ksbms_util.get_object_owner ('ksbms_pontis_util'
                                                                                 ))
                                 OR (    UPPER (d.table_name) IN (
                                              SELECT x.table_name
                                                FROM SYS.all_tables x
                                               WHERE x.owner =
                                                          ksbms_util.get_object_owner ('ksbms_pontis_util'
                                                                                      ))
                                     AND UPPER (d.col_name) NOT IN (
                                              SELECT y.column_name
                                                FROM SYS.all_tab_columns y
                                               WHERE y.table_name =
                                                          UPPER (d.table_name))
                                    )
                                );
               EXCEPTION
                    WHEN OTHERS
                    THEN
                         ROLLBACK;
                         ksbms_err.handle (1,
                                           ksbms_exc.application_exception,
                                           'Error deleting bogus records from DATADICT.',
                                           FALSE,
                                           TRUE
                                          );
                         EXIT; -- out of outermost control loop
               END;

               COMMIT; -- deletes

               BEGIN
                    -- how many records now?
                    SELECT NVL (COUNT (*), 0)
                      INTO ll_datadict_rows
                      FROM datadict;
               EXCEPTION
                    WHEN OTHERS
                    THEN -- any SQL error or whatever
                         BEGIN
                              IF NVL (ll_datadict_rows, 0) = 0
                              THEN
                                   ksbms_err.handle (1,
                                                     ksbms_exc.application_exception,
                                                     'Error selecting from DATADICT after DELETE',
                                                     FALSE,
                                                     TRUE
                                                    );
                                   EXIT; -- no rows to process
                              END IF;

                              EXIT;
                         END;
               END;

               ksbms_util.pl (   'Records after delete   : '
                              || ksbms_util.display_zero_as_label (ll_datadict_rows,
                                                                   '09999',
                                                                   '<none>'
                                                                  )
                             );
               ll_deleted_rows := ll_deleted_rows - ll_datadict_rows;
               ksbms_util.pl (   'Deleted rows           : '
                              || ksbms_util.display_zero_as_label (ll_deleted_rows,
                                                                   '09999',
                                                                   '<none>'
                                                                  )
                             );

               FOR update_rec IN updatecursor
               LOOP
                    BEGIN
                         -- update nullable status, width, type, dec_plcs
                         -- which are known from the system catalog
                         -- no changes here for 4.0 Allen 2001.06.13
                         UPDATE datadict
                            SET datatype =
                                     NVL (SUBSTR (update_rec.data_type, 1, 16),
                                          'UNK'
                                         ), -- datatype
                                width = NVL (update_rec.data_precision, 0), -- width
                                dec_plcs =
                                     NVL (LEAST (update_rec.data_scale, 9), 0), -- dec_plcs
                                null_allow =
                                     NVL (update_rec.nullable, 'N') --null_allow
                          WHERE datadict.table_name = update_rec.table_name
                            AND datadict.col_name = update_rec.column_name;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              ksbms_err.RAISE (1,
                                               ksbms_exc.application_exception
                                              );
                              lb_loop_error := TRUE;
                    END;

-- only if something bad happened.  This exit gets us out of the processing.
                    IF lb_loop_error
                    THEN
                         EXIT;
                    END IF;
               END LOOP;

               COMMIT; -- changes (updates)
               ksbms_util.pl (' ');
               ksbms_util.pl ('Inserting missing entries in DATADICT. These are tables owned by'
                             );
               ksbms_util.pl (   'the Pontis software schema owner ( '
                              || ksbms_util.get_object_owner ('ksbms_pontis_util'
                                                             )
                              || ' ) that are not'
                             );
               ksbms_util.pl ('registered with Pontis through the DATADICT table.'
                             );

               -- the next section builds DYNAMIC INSERT statements depending on the version of Pontis
               -- these SQL Strings are parsed 1 time and reused inside a cursor for loop
               -- inside the loop, values are bound to the columns at each iteration.

               -- insert SQL String format (3.4) example

/*
               INSERT INTO datadict
               VALUES (
               SUBSTR( missing_rec.table_name, 1, 16),  --table_name
               SUBSTR( missing_rec.column_name, 1 , 24),  -- col_name
               ls_unique_name , -- col_alias
               '_', -- v2convert
               NVL ( SUBSTR (missing_rec.data_type, 1, 16 ),'UNK'), -- datatype
               NVL ( missing_rec.data_precision, 0 ), -- width
               NVL ( LEAST( missing_rec.data_scale, 9 ), 0 ), -- dec_plcs
               NVL (missing_rec.nullable, 'N'),  --null_allow
               'N', --uniquekey
               missing_rec.column_id, -- position
                '_', -- nbi_cd
                 '_', --valtype
                  '_', --valattr1
                   '_', --valattr2
                    'N', --sysfield
                     NVL (missing_rec.data_default,'_'),  --sysdefault
                     'N', --keyattr1
                     ls_unique_name, --unique_fld
                      'X', --helptype
                      -1, --helpid
                      NULL, --metricunit
                      NULL, --englshunit
                      'FIXUP',   --snotes
                      'FIXUP REQUIRED - Record inserted by stored procedure sync_datadict on '|| TO_CHAR (SYSDATE) ) ; -- notes
*/
               IF ls_version = '3.4'
               THEN
                    BEGIN
                         -- initialize CURSOR string - there are 24 DATADICT fields in 3.4
                         -- see documentation near bind below....
                         ls_sqlstring :=
                                  ' INSERT INTO DATADICT '
                               || ' VALUES ( '
                               || ':col1, :col2, :col3, :col4, :col5, :col6, :col7, :col8, '
                               || ':col9, :col10, :col11, :col12, :col13, :col14, :col15, :col16,'
                               || ':col17, :col18, :col19, :col20, :col21, :col22, :col23, :col24 )';
                         -- evaluate to see if it is a valid SQL string

                         DBMS_SQL.parse (ll_ins_cur,
                                         ls_sqlstring,
                                         DBMS_SQL.native
                                        );
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              ksbms_err.handle (1,
                                                SQLCODE,
                                                'Error parsing Insert for version 3.',
                                                FALSE,
                                                TRUE
                                               );
                              lb_loop_error := TRUE;
                              EXIT;
                    END;
               ELSIF ls_version = '4.0'
               THEN
                    BEGIN
                         /*
                         INSERT INTO datadict
                              VALUES (missing_rec.table_name, missing_rec.column_name,    missing_rec.table_name
                                                                                       || TO_CHAR (
                                                                                             missing_rec.column_id,
                         -- initialize CURSOR string - there are 23 DATADICT fields in 4.0
                         */
                         ls_sqlstring :=
                                  ' INSERT INTO DATADICT '
                               || ' VALUES ( '
                               || ':col1, :col2, :col3, :col4, :col5, :col6, :col7, :col8, '
                               || ':col9, :col10, :col11, :col12, :col13, :col14, :col15, :col16,'
                               || ':col17, :col18, :col19, :col20, :col21, :col22, :col23 )';
                         DBMS_SQL.parse (ll_ins_cur,
                                         ls_sqlstring,
                                         DBMS_SQL.native
                                        );
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              ksbms_err.handle (1,
                                                SQLCODE,
                                                'Error parsing Insert for version 4.0',
                                                FALSE,
                                                TRUE
                                               );
                              lb_loop_error := TRUE;
                              EXIT;
                    END;
               ELSE
                    ksbms_err.RAISE (1,
                                     ksbms_exc.pontis_version_error,
                                     'Wrong version encountered'
                                    );
               END IF;

               -- run the cursor
               FOR missing_rec IN missingcursor
               LOOP
                    BEGIN
                         ll_missingrows := missingcursor%ROWCOUNT;

                         -- use cursor set up for version
                         IF ls_version = '3.4'
                         THEN
                              -- we need to be careful about concatenating stuff and exceeding table name lengths across versions
                              -- this skips all records with table_names > 16, in effect, those that are not compatible with Pontis
                              skiprec :=
                                   (LENGTH (missing_rec.table_name) >
                                                       c_max_len_table_name_34
                                   );

                              IF NOT skiprec
                              THEN
                                   BEGIN
                                        ls_unique_name :=
                                                 TRIM (SUBSTR (missing_rec.table_name,
                                                               1,
                                                               7
                                                              )
                                                      )
                                              || TRIM (TO_CHAR (missing_rec.column_id,
                                                                '0999'
                                                               )
                                                      )
                                              || TRIM (TO_CHAR (ll_missingrows,
                                                                '09999'
                                                               )
                                                      );
                                        -- max table name length is 16 chars...

                                        /* DATADICT FORMAT FROM DESCRIBE
                                        1      table_name, varchar2(16), , , table name,
                                        2      col_name, varchar2(24), , , column name,
                                        3      col_alias, varchar2(24), , , name of analogous field in pontis 2.0.,
                                        4      v2convert, varchar2(10), , , pontis 2.0 data type,
                                        5      datatype, varchar2(16), , , data type,
                                        6      width, number(5), , , width for storage and display,
                                        7      dec_plcs, number(1), , , number of decimal places,
                                        8      null_allow, varchar2(1), , , flag indicating whether null values are allowed.,
                                        9      uniquekey, varchar2(1), , , flag indicating whether field value must be unique.,
                                        10      position, number(16), , , position of the field in internal ordering system.,
                                        11      nbi_cd, varchar2(10), y, , nbi code,
                                        12      valtype, varchar2(12), y, , indicates whether possible values come from a range or list of values.,
                                        13      valattr1, varchar2(40), y, , holds minimum value of a range of values, or holds list.,
                                        14      valattr2, varchar2(40), y, , holds maximum value of a range of allowed values.,
                                        15      sysfield, varchar2(1), , , flag indicator of a field that is used by the system.,
                                        16      sysdefault, varchar2(40), y, , system default,
                                        17      keyattr1, varchar2(1), y, , holds primary key status of field if field is used in a formula.,
                                        18      unique_fld, varchar2(24), , , distinct alias for each field.,
                                        19      helptype, varchar2(2), , , type of help--metric conversion or popup help.,
                                        20      helpid, number(5), , , help id code from help module.,
                                        21      metricunit, varchar2(4), y, , metric system (si) unit label for field value.,
                                        22      englshunit, varchar2(4), y, , english system unit label for field value.,
                                        23      snotes, varchar2(100), y, , short description of the pontis database field.,
                                        24      notes, varchar2(2000), y, , entry comments
                                        */
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col1',
                                                                SUBSTR (missing_rec.table_name,
                                                                        1,
                                                                        16
                                                                       ),
                                                                16
                                                               ); --table_name
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col2',
                                                                SUBSTR (missing_rec.column_name,
                                                                        1,
                                                                        24
                                                                       ),
                                                                24
                                                               ); -- col_name
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col3',
                                                                ls_unique_name,
                                                                24
                                                               ); -- col_alias
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col4',
                                                                '_'
                                                               ); -- v2convert
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col5',
                                                                NVL (SUBSTR (missing_rec.data_type,
                                                                             1,
                                                                             16
                                                                            ),
                                                                     'UNK'
                                                                    ),
                                                                16
                                                               ); -- datatype
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col6',
                                                                NVL (missing_rec.data_precision,
                                                                     0
                                                                    )
                                                               ); -- width
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col7',
                                                                NVL (LEAST (missing_rec.data_scale,
                                                                            9
                                                                           ),
                                                                     0
                                                                    )
                                                               ); -- dec_plcs
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col8',
                                                                NVL (missing_rec.nullable,
                                                                     'N'
                                                                    )
                                                               ); --null_allow
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col9',
                                                                'N'
                                                               ); --uniquekey
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col10',
                                                                missing_rec.column_id
                                                               ); -- position
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col11',
                                                                ls_miss_ch1
                                                               ); -- nbi_cd
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col12',
                                                                ls_miss_ch1
                                                               ); --valtype
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col13',
                                                                ls_miss_ch1
                                                               ); --valattr1
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col14',
                                                                ls_miss_ch1
                                                               ); --valattr2
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col15',
                                                                'N'
                                                               ); --sysfield
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col16',
                                                                NVL (missing_rec.data_default,
                                                                     '_'
                                                                    )
                                                               ); --sysdefault
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col17',
                                                                'N'
                                                               ); --keyattr1
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col18',
                                                                ls_unique_name,
                                                                24
                                                               ); --unique_fld
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col19',
                                                                'X'
                                                               ); --helptype
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col20',
                                                                -1
                                                               ); --helpid
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col21',
                                                                ls_miss_ch1
                                                               ); --metricunit
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col22',
                                                                ls_miss_ch1
                                                               ); --englshunit
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col23',
                                                                'FIXUP'
                                                               ); --snotes
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col24',
                                                                    'FIXUP REQUIRED - Record inserted by stored procedure sync_datadict on '
                                                                 || TO_CHAR (SYSDATE
                                                                            )
                                                               ); -- notes
                                   EXCEPTION
                                        WHEN OTHERS
                                        THEN
                                             BEGIN
                                                  ksbms_err.RAISE (1,
                                                                   SQLCODE,
                                                                       'Error binding variables for INSERT( '
                                                                    || ls_version
                                                                    || ' )'
                                                                  );
                                                  RAISE;
                                             END;
                                   END;
                              ELSE
                                   skiprec := TRUE;
                              END IF; -- length check
                         ELSIF ls_version = '4.0'
                         THEN
                              -- we need to be careful about concatenating stuff and exceeding table name lengths across versions
                              -- this skips all records with table_names > 16, in effect, those that are not compatible with Pontis
                              skiprec :=
                                   (LENGTH (missing_rec.table_name) >
                                                        c_max_len_table_name_4
                                   );

                              IF NOT skiprec
                              THEN
                                   BEGIN
                                        ls_unique_name :=
                                                 TRIM (SUBSTR (missing_rec.table_name,
                                                               1,
                                                               15
                                                              )
                                                      )
                                              || TRIM (TO_CHAR (missing_rec.column_id,
                                                                '0999'
                                                               )
                                                      )
                                              || TRIM (TO_CHAR (ll_missingrows,
                                                                '09999'
                                                               )
                                                      );
                                        /*
                                        1   table_name, varchar2(24), , , table name,
                                        2   col_name, varchar2(24), , , column name,
                                        3   col_alias, varchar2(24), y, , name of analogous field in pontis 2.0.,
                                        4   v2convert, varchar2(10), y, , pontis 2.0 data type,
                                        5   datatype, varchar2(16), y, , data type,
                                        6   width, number(10), y, , width for storage and display,
                                        7   dec_plcs, number(1), y, , number of decimal places,
                                        8   null_allow, char(1), y, , flag indicating whether null values are allowed.,
                                        9   uniquekey, char(1), y, , flag indicating whether field value must be unique.,
                                        10   position, number(16), y, , position of the field in internal ordering system.,
                                        11   nbi_cd, varchar2(10), y, , nbi code,
                                        12   valtype, varchar2(12), y, , indicates whether possible values come from a range or list of values.,
                                        13   valattr1, varchar2(40), y, , holds minimum value of a range of values, or holds list.,
                                        14  valattr2, varchar2(40), y, , holds maximum value of a range of allowed values.,
                                        15   sysfield, char(1), y, , flag indicator of a field that is used by the system.,
                                        16   sysdefault, varchar2(40), y, , system default,
                                        17   keyattr1, char(1), y, , holds primary key status of field if field is used in a formula.,
                                        18   unique_fld, varchar2(24), y, , distinct alias for each field.,
                                        19   helpid, number(5), y, , help id code from help module.,
                                        20   paircode, number(2), , , metric english pair code,
                                        21   conversionrules, varchar2(12), y, , to hold codes for converting special quantities like 999,
                                        22   snotes, varchar2(255), y, , short description of the pontis database field.,
                                        23   notes, varchar2(2000), y, , entry comments
                                        */
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col1',
                                                                SUBSTR (missing_rec.table_name,
                                                                        1,
                                                                        24
                                                                       ),
                                                                24
                                                               ); --table_name
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col2',
                                                                SUBSTR (missing_rec.column_name,
                                                                        1,
                                                                        24
                                                                       ),
                                                                24
                                                               ); -- col_name
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col3',
                                                                ls_unique_name,
                                                                24
                                                               ); -- col_alias
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col4',
                                                                '_'
                                                               ); -- v2convert
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col5',
                                                                NVL (SUBSTR (missing_rec.data_type,
                                                                             1,
                                                                             16
                                                                            ),
                                                                     'UNK'
                                                                    ),
                                                                16
                                                               ); -- datatype
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col6',
                                                                NVL (missing_rec.data_precision,
                                                                     0
                                                                    )
                                                               ); -- width
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col7',
                                                                NVL (LEAST (missing_rec.data_scale,
                                                                            9
                                                                           ),
                                                                     0
                                                                    )
                                                               ); -- dec_plcs
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col8',
                                                                NVL (missing_rec.nullable,
                                                                     'N'
                                                                    )
                                                               ); --null_allow
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col9',
                                                                'N'
                                                               ); --uniquekey
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col10',
                                                                missing_rec.column_id
                                                               ); -- position
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col11',
                                                                ls_miss_ch1
                                                               ); -- nbi_cd
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col12',
                                                                ls_miss_ch1
                                                               ); --valtype
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col13',
                                                                ls_miss_ch1
                                                               ); --valattr1
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col14',
                                                                ls_miss_ch1
                                                               ); --valattr2
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col15',
                                                                'N'
                                                               ); --sysfield
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col16',
                                                                NVL (missing_rec.data_default,
                                                                     '_'
                                                                    )
                                                               ); --sysdefault
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col17',
                                                                'N'
                                                               ); --keyattr1
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col18',
                                                                ls_unique_name,
                                                                24
                                                               ); --unique_fld
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col19',
                                                                -1
                                                               ); --helpid
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col20',
                                                                -1
                                                               ); --paircode
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col21',
                                                                ls_miss_ch1
                                                               ); --conversion_rules
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col22',
                                                                'FIXUP'
                                                               ); --snotes
                                        DBMS_SQL.bind_variable (ll_ins_cur,
                                                                'col23',
                                                                    'FIXUP REQUIRED - Record inserted by stored procedure sync_datadict on '
                                                                 || TO_CHAR (SYSDATE
                                                                            )
                                                               ); -- notes
                                   EXCEPTION
                                        WHEN OTHERS
                                        THEN
                                             BEGIN
                                                  ksbms_err.RAISE (1,
                                                                   SQLCODE,
                                                                       'Error binding variables for INSERT ( '
                                                                    || ls_version
                                                                    || ' )'
                                                                  );
                                                  RAISE;
                                             END;
                                   END;
                              ELSE
                                   skiprec := TRUE;
                              END IF; -- length check
                         ELSE -- uh-oh - wrong version
                              ksbms_err.RAISE (1,
                                               ksbms_exc.pontis_version_error,
                                               'Pontis version error in INSERT block'
                                              );
                         END IF;

                         IF NOT skiprec
                         THEN
                              -- same statement for both versions - execute the SQL

                              -- INSERT NOW AND increment fixed rows
                              ll_insertedrows :=
                                      ll_insertedrows
                                    + DBMS_SQL.EXECUTE (ll_ins_cur);
                         --ll_insertedrows :=   ll_insertedrows
                         --                    + 1;
                         END IF;
                    EXCEPTION
                         WHEN ksbms_exc.exc_pontis_version_error
                         THEN
                              BEGIN
                                   ksbms_err.handle (1,
                                                     ksbms_exc.pontis_version_error,
                                                     'Bad version',
                                                     FALSE,
                                                     TRUE
                                                    );
                                   lb_loop_error := TRUE;
                                   RAISE; -- should jump
                              END;
                         WHEN OTHERS
                         THEN
                              BEGIN
                                   lb_loop_error := TRUE;
                                   RAISE; -- should jump
                              END;
                    END;
               END LOOP; -- FOR CURSOR

                         -- Failure, stop loop and skip commit

               IF lb_loop_error
               THEN
                    EXIT; -- skip commit
               END IF;

               COMMIT;         -- save inserts
                       -- close INSERT processing  cursor (probably not required )
               DBMS_SQL.close_cursor (ll_ins_cur);
               -- success.... stop loop
               EXIT; -- stop outermost loop.
          END LOOP;

--      IF lb_loop_error then RAISE; END IF; -- whatever error got us here.

-- summary of activity
          ksbms_util.pl (' ');
          ksbms_util.pl ('Processed datadict updates successfully!');
          ksbms_util.pl (   'Missing rows processed : '
                         || ksbms_util.display_zero_as_label (ll_missingrows,
                                                              '09999',
                                                              '<none>'
                                                             )
                        );
          ksbms_util.pl (   'Inserted rows          : '
                         || ksbms_util.display_zero_as_label (ll_insertedrows,
                                                              '09999',
                                                              '<none>'
                                                             )
                        );
          ksbms_util.pl (   'Deleted rows           : '
                         || ksbms_util.display_zero_as_label (ll_deleted_rows,
                                                              '09999',
                                                              '<none>'
                                                             )
                        );
          ksbms_util.pl (   'Skipped rows           : '
                         || ksbms_util.display_zero_as_label (  ll_missingrows
                                                              - ll_insertedrows,
                                                              '09999',
                                                              '<none>'
                                                             )
                         || '( table_name too long, etc. )'
                        );
          ksbms_util.pl (' ');
     EXCEPTION
          WHEN ksbms_exc.exc_pontis_version_error
          THEN
               ROLLBACK; -- kill changes
               ksbms_err.RAISE (1, ksbms_exc.pontis_version_error);
          WHEN VALUE_ERROR
          THEN
               ROLLBACK; -- kill changes
               ksbms_util.pl ('Datadict update failed!');
               ksbms_util.pl (   'Missing rows processed : '
                              || ksbms_util.display_zero_as_label (ll_missingrows,
                                                                   '09999',
                                                                   '<none>'
                                                                  )
                             );
               ksbms_util.pl (   'Inserted rows          : '
                              || ksbms_util.display_zero_as_label (ll_insertedrows,
                                                                   '09999',
                                                                   '<none>'
                                                                  )
                             );
               ksbms_util.pl (   'Deleted rows           : '
                              || ksbms_util.display_zero_as_label (ll_deleted_rows,
                                                                   '09999',
                                                                   '<none>'
                                                                  )
                             );
               ksbms_util.pl (   'Skipped rows           : '
                              || ksbms_util.display_zero_as_label (  ll_missingrows
                                                                   - ll_insertedrows,
                                                                   '09999',
                                                                   '<none>'
                                                                  )
                              || '( table_name too long, etc. )'
                             );
               ksbms_util.pl (' ');
               ksbms_err.RAISE (1, SQLCODE, 'Value error encountered!');
          WHEN OTHERS
          THEN
               ROLLBACK; -- kill changes
               ksbms_util.pl ('Datadict update failed!');
               ksbms_util.pl (   'Missing rows processed : '
                              || ksbms_util.display_zero_as_label (ll_missingrows,
                                                                   '09999',
                                                                   '<none>'
                                                                  )
                             );
               ksbms_util.pl (   'Inserted rows          : '
                              || ksbms_util.display_zero_as_label (ll_insertedrows,
                                                                   '09999',
                                                                   '<none>'
                                                                  )
                             );
               ksbms_util.pl (   'Deleted rows           : '
                              || ksbms_util.display_zero_as_label (ll_deleted_rows,
                                                                   '09999',
                                                                   '<none>'
                                                                  )
                             );
               ksbms_util.pl (   'Skipped rows           : '
                              || ksbms_util.display_zero_as_label (  ll_missingrows
                                                                   - ll_insertedrows,
                                                                   '09999',
                                                                   '<none>'
                                                                  )
                              || '( table_name too long, etc. )'
                             );
               ksbms_util.pl (' ');
               ksbms_err.RAISE (1, ksbms_exc.application_exception);
     END sync_datadict;

     -- Hoyt 1/8/2002: This version uses pontis.coptions instead of ds_config_options;
     -- It also gets the default value, if the option value is null (probably needless).
     FUNCTION f_get_pontis_coption_value (
          opt_name   IN   coptions.optionname%TYPE
     )
          RETURN coptions.optionval%TYPE
     IS
          ls_result   pontis.coptions.optionval%TYPE;
     /*

     f_get_pontis_coption_value() does a SELECT against the
     pontis.COPTIONS table to get the option value that corresponds
     to the passed option name. If the option name is not found in
     COPTIONS, then f_get_pontis_coption_value() returns NULL. If
     f_get_pontis_coption_value() finds the option name, but the
     option value is NULL, then f_get_pontis_coption_value() SELECTs
     the option's default value.

     Parameters: the option name, e.g. 'XTRNBRDGTABLE'

     Returns: The option value (or the default), or NULL if the option isn't found

     Requires: The calling user must have read privilege for COPTIONS

     Usage:

     This example shows how to test for a NULL when the option name
     is not found:

       -- Variables
       ls_option_name pontis.coptions.optionname%type;
       ls_option_value pontis.coptions.optionval%type;

       ls_option_name := 'XTRNBRDGTABLE';
       ls_option_value := f_get_pontis_coption_value( ls_option_name );
       if ls_option_value is NULL
       then
           p_sql_error( ls_optionname || ' is not valid!' );
       end if;

     You could also call this function in-line without ANY variables:

        if f_is_yes( f_get_pontis_coption_value( 'SHOWESTCOST' )
        then
           ... show the est cost...
        end if;
     */
     BEGIN
          BEGIN
               SELECT optionval
                 INTO ls_result
                 FROM pontis.coptions
                WHERE UPPER (optionname) = UPPER (opt_name);
          EXCEPTION
               WHEN OTHERS
               THEN
                    RETURN NULL;
          END;

          -- If the result is NULL, then get the default
          IF ls_result IS NULL OR LENGTH (ls_result) = 0
          THEN
               BEGIN
                    SELECT defaultval
                      INTO ls_result
                      FROM pontis.coptions
                     WHERE UPPER (optionname) = UPPER (opt_name);

                    RETURN ls_result;
               EXCEPTION
                    WHEN OTHERS
                    THEN
                         RETURN NULL;
               END;
          ELSE
               RETURN ls_result;
          END IF;
     END f_get_pontis_coption_value;

     -- Pass in a brkey and get back the corresponding bridge ID (from BRIDGE)
       -- Return the bridge_id that corresponds to a given brkey
   FUNCTION f_get_bridge_id_from_brkey (p_brkey IN bridge.brkey%TYPE)
      RETURN  bridge.bridge_id%TYPE
   IS
      ls_bridge_id   bridge.bridge_id%TYPE; -- Length of bridge_id in Pontis
      ls_context ksbms_util.context_string_type  := 'ksbms_pontis_util.f_get_bridge_id_from_brkey ()';
      PRAGMA AUTONOMOUS_TRANSACTION; -- Allen MArshall, CS - 2003-01-06
   BEGIN
        -- Allen Marshall, CS - 2003-03-06 - Change
       ksbms_util.p_push( ls_context) ;
      -- Get the bridge_id that corresponds to the passed brkey
      SELECT bridge_id
        INTO ls_bridge_id
        FROM bridge
       WHERE brkey = p_brkey;

      -- If we hit this, then there wasn't an exception, so we got the bridge_id
              -- Allen Marshall, CS - 2003-03-06 - Change
      ksbms_util.p_pop( ls_context) ;
      RETURN ls_bridge_id;
   EXCEPTION
           -- Allen Marshall, CS - 2003-03-06 - Change
          WHEN NO_DATA_FOUND -- may be BENIGN, but the calling routine should confirm NULL return
          THEN
            BEGIN
              -- Variant 3 - we can return NULL , not screw up e-mail message, swallow exception
              -- (see KSBMS_ROBOT.ksbms_util.p_sql_error3 )
              -- Allen Marshall, CS - 2003-03-06 - Change
              ksbms_util.p_sql_error3 (   'Warning:  Failed to find the Bridge_ID corresponding to brkey - returning NULL Bridge_id for brkey = '
                                        || p_brkey
                                       );
               ksbms_util.p_pop( ls_context) ;
               RETURN NULL; -- We hit this because p_sql_error2() does NOT raise an exception
              END;
           -- Allen Marshall, CS - 2003-03-06 - Change
          WHEN OTHERS
          THEN
              BEGIN
               -- Variant  so we can return NULL, add message to e-mail
               ksbms_util.p_sql_error(   'Selecting the Bridge_ID corresponding to brkey - returning NULL Bridge_ID for brkey = '
                                        || p_brkey
                                       );
                              ksbms_util.p_pop( ls_context) ;
                              RETURN NULL; -- never gets here because of p_sql_error but...
               END;
   END f_get_bridge_id_from_brkey;

     FUNCTION f_get_bridge_id_from_brkey_bad (p_brkey IN bridge.brkey%TYPE)
          RETURN  bridge.bridge_id%TYPE
     -- Allen Marshall, CS - 2003.01.04 - TURNED BAD, NOT USABLE SINCE IT DOES NOT NOT NOT
     -- give a good bridge_id back for bridges with a C in the BRIDGE_ID - OBSOLETE. USE
     -- KSBMS_PONTIS.F_get_bridge_id_from_brkey instead, or use one of the ksbms_scoreboard functions to
     -- interrogate actively in-process rows.
     IS
          ls_bridge_id   bridge.bridge_id%TYPE; -- Length of bridge_id in Pontis
          ls_context ksbms_util.context_string_type  := 'ksbms_pontis_util.f_get_bridge_id_from_brkey_bad ()';

     BEGIN
          ksbms_util.p_push( ls_context) ;
          -- Because of 'mutating table' problem, substituted a call to f_kdot_brkey_to_bridge_id()
          ls_bridge_id := ksbms_pontis.f_kdot_brkey_to_bridge_id (p_brkey);
          ksbms_util.p_pop( ls_context) ;
          RETURN ls_bridge_id;
     /* -- HOYTFIX Replace calls to this function!
      -- Get the bridge_id that corresponds to the passed brkey
      select bridge_id
        into ls_bridge_id
        from bridge
       where brkey = p_brkey;

      -- If we hit this, then there wasn't an exception, so we got the bridge_id
      return ls_bridge_id;*/
     EXCEPTION
          WHEN NO_DATA_FOUND -- may be BENIGN, but the calling routine should confirm NULL return
          THEN
          BEGIN
              -- Variant 3 - we can return NULL , not screw up e-mail message, swallow exception
              -- (see KSBMS_ROBOT.ksbms_util.p_sql_error3 )
              ksbms_util.p_sql_error3 (   'Warning: Failed to find the Bridge_ID corresponding to brkey - returning NULL Bridge_ID for brkey =  '
                                        || p_brkey
                                       );
              ksbms_util.p_pop( ls_context) ;
               RETURN NULL; -- We hit this because p_sql_error2() does NOT raise an exception
           END;
          WHEN OTHERS
          THEN
              BEGIN
               -- Variant  so we can return NULL, add message to e-mail
               ksbms_util.p_sql_error(   'Selecting the Bridge_ID corresponding to brkey - returning NULL Bridge_ID'
                                        || p_brkey
                                       );
               ksbms_util.p_pop( ls_context) ;
               RETURN NULL; -- never gets here because of p_sql_error but...

            END;

     END f_get_bridge_id_from_brkey_bad;

     -- Pass in a Bridge ID and get back the corresponding BRKEY (from BRIDGE)
     FUNCTION f_get_brkey_from_bridge_id (
          p_bridge_id   IN   bridge.bridge_id%TYPE
     )
          RETURN VARCHAR2
     IS
          ls_brkey   bridge.brkey%TYPE; -- Length of bridge_id in Pontis
          ls_context ksbms_util.context_string_type  := 'ksbms_pontis_util.f_get_brkey_from_bridge_id ()';

     BEGIN
          ksbms_util.p_push( ls_context) ;
          -- Get the bridge_id that corresponds to the passed brkey
          SELECT brkey
            INTO ls_brkey
            FROM bridge
           WHERE bridge_id = p_bridge_id;

          -- If we hit this, then there wasn't an exception, so we got the BRKEY
          ksbms_util.p_pop( ls_context) ;
          RETURN ls_brkey;
     EXCEPTION
          WHEN NO_DATA_FOUND -- may be BENIGN, but the calling routine should confirm NULL return
          THEN
          BEGIN
                  -- Variant 3 - we can return NULL , not screw up e-mail message, swallow exception
                  -- (see KSBMS_ROBOT.ksbms_util.p_sql_error3 )
                  -- Allen Marshall, 2003-03-06 - fixed formatting.
                  -- Allen Marshall, CS - 2003-03-06 - Change
                  ksbms_util.p_sql_error3 (   'Warning: Failed to find the BRKEY corresponding to Bridge ID - returning NULL BRKEY for Bridge_ID = '
                                           || p_bridge_id
                                          );
                  ksbms_util.p_pop( ls_context) ;
                  RETURN NULL; -- We hit this because p_sql_error3() does NOT raise an exception
           END;
          WHEN OTHERS -- NEVER BENIGN, RAISE EXCEPTION WITH p_SQL_error
          THEN
              BEGIN
                  -- this  is NOT benign
                  -- Allen Marshall, 2003-03-06 - fixed formatting.
                  -- Allen Marshall, CS - 2003-03-06 - Change
                  ksbms_util.p_sql_error (   'Selecting the BRKEY corresponding to Bridge_ID = '
                                           || p_bridge_id
                                          );
                  ksbms_util.p_pop( ls_context) ;
                  RETURN NULL; -- never gets here because of p_sql_error but...
               END;
     END f_get_brkey_from_bridge_id;

     -- Given a brkey, column name, and value, updates BRIDGE to set the column to the value
     FUNCTION f_return_missing_date_string
          -- ALlen Marshall, CS - 2002.12.20 - fixed to return 1901-01-01 and to use the DS_CONFIG_OPTIONS entry if available

     RETURN VARCHAR2
     IS
          ls_date   VARCHAR2 (40);
     BEGIN
          -- look upd ate in DS_CONFIG_OPTIONS, use default of 1901-01-01 if nothing available
          ls_date :=
               NVL (ksbms_util.f_get_coption_value ('DEFAULTMISSINGDATETIMEVALUE'),
                    '1901-01-01 00:00:00'
                   );
          RETURN ls_date;
     END f_return_missing_date_string;

-- Public function and procedure declarations
-- function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;
-- pass brkey, returns TRUE if the bridge exists in table BRIDGE
-- BRKEY is never upperized
-- RETURNS NULL if bad arguments
-- RETURNS TRUE if found
-- RETURNS FALSE if NOT found

     -- Hoyt 1/10/2002: Returns SYSDEFAULT for the passed table and column
     -- It also gets the default value, if the option value is null (probably needless).
     FUNCTION f_get_pontis_datadict_value (
          psi_table_name   IN   pontis.datadict.table_name%TYPE,
          psi_col_name     IN   pontis.datadict.col_name%TYPE
     )
          RETURN pontis.datadict.sysdefault%TYPE
     IS
          ls_sysdefault   pontis.datadict.sysdefault%TYPE;
     /*

     f_get_pontis_datadict_value() does a SELECT against the pontis.datadict
     table to get the SYSDEFAULT value that corresponds to the passed table
     and column names. If the table and column names are not found in
     datadict, then f_get_pontis_datadict_value() returns NULL.

     Parameters:

        The table_name, e.g. 'ROADWAY'
        The col_name, e.g. 'FEAT_CRIT'

     Returns: The SYSDEFAULT value, or NULL if the table_name and col_name isn't found

     Requires: The calling user must have read privilege for datadict

     Usage:

     This example shows how to test for a NULL when the table and column
     are not found:

       -- Variables
       ls_table_name pontis.datadict.table_name%type;
       ls_column_name pontis.datadict.col_name%type;
       ls_sysdefault pontis.datadict.sysdefault%type;

       ls_table_name := 'ROADWAY';
       ls_column_name := 'FEAT_CRIT';
       ls_sysdefault := f_get_pontis_datadict_value( ls_table_name, ls_column_na );
       if ls_sysdefault is NULL
       then
           p_sql_error( ls_table_name || '.' || ls_column_name || ' was not found!' );
       end if;

     You could also call this function in-line without ANY variables:

        if f_is_yes( f_get_pontis_datadict_value( 'ROADWAY', 'FEAT_CRIT' )
        then
           ... show the est cost...
        end if;
     */
     BEGIN
          BEGIN
               SELECT DISTINCT sysdefault
                          INTO ls_sysdefault
                          FROM datadict
                         WHERE UPPER (table_name) = UPPER (psi_table_name)
                           AND UPPER (col_name) = UPPER (psi_col_name);

               RETURN ls_sysdefault;
          EXCEPTION
               WHEN OTHERS
               THEN
                    RETURN NULL;
          END;
     END f_get_pontis_datadict_value;

     PROCEDURE p_init_package
     IS
     BEGIN
          ksbms_util.pl ('Initializing package ksbms_pontis_util');
     END p_init_package;

     -- Returns the users.userkey that corresponds to the (Oracle) 'user',
     -- if any, else returns the minimum userkey (so at least it's valid)
     FUNCTION f_get_users_userkey
          RETURN VARCHAR2
     IS
          ls_userkey            users.userkey%TYPE; -- Length of bridge_id in Pontis
          ls_context  ksbms_util.context_string_type      := 'f_get_users_userkey()';
     BEGIN
          -- See if there is a userkey corresponding to (Oracle) 'user'
          BEGIN
               SELECT userkey
                 INTO ls_userkey
                 FROM users
                WHERE UPPER (userid) = USER;

               RETURN ls_userkey;
          EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                    -- Just take the minimum userkey
                    BEGIN
                         SELECT MIN (userkey)
                           INTO ls_userkey
                           FROM users;

                         RETURN ls_userkey;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              -- Variant 2 so we can return NULL
                              ksbms_util.p_sql_error2 (  ls_context
                                                       + ': Failed to get the min( USERKEY )!'
                                                      );
                              RETURN NULL;
                    END;
               WHEN OTHERS
               THEN
                    -- Variant 2 so we can return NULL
                    ksbms_util.p_sql_error2 (   ls_context
                                             +  ': Failed to get the USERKEY corresponding to USER '
                                             || USER
                                            );
                    RETURN NULL;
          END;

          -- If we hit this, then something is seriously wrong with our
          -- exception-handling theory
          RETURN NULL;
     END f_get_users_userkey;

      FUNCTION f_set_bridge_value (
          psi_brkey          IN   bridge.brkey%TYPE,
          psi_column_name    IN   VARCHAR2,
          psi_column_value   IN   VARCHAR2
     )
          RETURN BOOLEAN -- function returns FALSE on success, TRUE on FAILURE
     IS
          lb_failed             BOOLEAN         := TRUE; -- Assume failure
          ls_column_value       VARCHAR2 (2000);
          ls_context  ksbms_util.context_string_type   := 'f_set_bridge_value()';
          ls_sql                VARCHAR2 (2000);
          lex_invalid_brkey     EXCEPTION;
          PRAGMA EXCEPTION_INIT (lex_invalid_brkey, -20301);
     BEGIN
          BEGIN

               <<outer_exception_block>>
               LOOP
                    -- Make sure the brkey is valid
                    IF NOT f_bridge_exists (psi_brkey)
                    THEN
                         ksbms_util.p_sql_error (   'The passed BRKEY '
                                                 || psi_brkey
                                                 || ' does not exist!'
                                                );
                    END IF;

                    -- Do we need apostrophes or date conversion? Fix the literal based on its data type.
                    ls_column_value := psi_column_value;

                    IF ksbms_util.f_wrap_data_value ('BRIDGE',
                                                     psi_column_name,
                                                     ls_column_value
                                                    )
                    THEN
                         EXIT;
                    END IF;

                    BEGIN
                         ls_sql :=
                                  'update bridge set '
                               || psi_column_name
                               || ' = '
                               || ls_column_value
                               || ' where brkey = '''
                               || UPPER (psi_brkey)
                               || '''';
                         EXECUTE IMMEDIATE ls_sql;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              ksbms_util.p_sql_error (   'Updating BRIDGE column '
                                                      || psi_column_name
                                                      || ' to '
                                                      || ls_column_value
                                                     );
                    END;

                    -- success!
                    lb_failed := FALSE;
                    EXIT;
               END LOOP;
          -- This catches the exception triggered by p_sql_error() above
          EXCEPTION
               WHEN OTHERS
               THEN
                    ksbms_util.p_add_msg (ls_context || ' failed');
                    RAISE ksbms_util.generic_exception;
          END outer_exception_block;

          RETURN lb_failed;
     END f_set_bridge_value;

     FUNCTION f_bridge_exists (the_brkey_in IN bridge.brkey%TYPE)
          RETURN BOOLEAN
     IS
          lb_bridge_exists      BOOLEAN       := FALSE;
          ls_context ksbms_util.context_string_type := 'f_bridge_exists()';
     BEGIN
     ksbms_util.p_push( ls_context );
          LOOP
               IF ksbms_util.f_ns (the_brkey_in)
               THEN
                    ksbms_util.p_bug (   'NULL or empty BRKEY passed to '
                                      || ls_context
                                     );
                    RETURN FALSE;
               END IF;

               lb_bridge_exists :=
                    ksbms_util.f_any_rows_exist ('BRIDGE',
                                                     'brkey = '
                                                  || ksbms_util.sq (the_brkey_in
                                                                   )
                                                );
               EXIT WHEN TRUE;
          END LOOP;
     ksbms_util.p_pop( ls_context );
          RETURN lb_bridge_exists;
     EXCEPTION
          WHEN OTHERS
          THEN
     ksbms_util.p_push( ls_context );
               RETURN NULL;
     END f_bridge_exists;
     
     
 FUNCTION f_set_userbrdg_value (
          psi_brkey          IN   bridge.brkey%TYPE,
          psi_column_name    IN   VARCHAR2,
          psi_column_value   IN   VARCHAR2
     )
          RETURN BOOLEAN -- function returns FALSE on success, TRUE on FAILURE
     IS
          lb_failed             BOOLEAN         := TRUE; -- Assume failure
          ls_column_value       VARCHAR2 (2000);
          ls_context  ksbms_util.context_string_type   := 'f_set_userbrdg_value()';
          ls_sql                VARCHAR2 (2000);
          lex_invalid_brkey     EXCEPTION;
          PRAGMA EXCEPTION_INIT (lex_invalid_brkey, -20301);
     BEGIN
        BEGIN
           
                    <<outer_exception_block>>
   
               LOOP
                    -- Make sure the brkey is valid
                    IF NOT f_userbrdg_exists (psi_brkey)
                    THEN
                         ksbms_util.p_sql_error (   'The passed BRKEY '
                                                 || psi_brkey
                                                 || ' does not exist!'
                                                );
                    END IF;

                    -- Do we need apostrophes or date conversion? Fix the literal based on its data type.
                    ls_column_value := psi_column_value;

                    IF ksbms_util.f_wrap_data_value ('USERBRDG',
                                                     psi_column_name,
                                                     ls_column_value
                                                    )
                    THEN
                         EXIT;
                    END IF;

                    BEGIN
                         ls_sql :=
                                  'update userbrdg set '
                               || psi_column_name
                               || ' = '
                               || ls_column_value
                               || ' where brkey = '''
                               || UPPER (psi_brkey)
                               || '''';
                         EXECUTE IMMEDIATE ls_sql;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              ksbms_util.p_sql_error (   'Updating USERBRDG column '
                                                      || psi_column_name
                                                      || ' to '
                                                      || ls_column_value
                                                     );
                    END;

                    -- success!
                    lb_failed := FALSE;
                    EXIT;
               END LOOP;
          -- This catches the exception triggered by p_sql_error() above
          EXCEPTION
               WHEN OTHERS
               THEN
                    ksbms_util.p_add_msg (ls_context || ' failed');
                    RAISE ksbms_util.generic_exception;
          END outer_exception_block;

          RETURN lb_failed;
     END f_set_userbrdg_value;
     
 FUNCTION f_userbrdg_exists (psi_brkey IN bridge.brkey%TYPE)
          RETURN BOOLEAN
     IS
          lb_userbrdg_exists      BOOLEAN       := FALSE;
          ls_context ksbms_util.context_string_type := 'f_userbrdg_exists()';
     BEGIN
     ksbms_util.p_push( ls_context );
          LOOP
               IF ksbms_util.f_ns (psi_brkey)
               THEN
                    ksbms_util.p_bug (   'NULL or empty BRKEY passed to '
                                      || ls_context
                                     );
                    RETURN FALSE;
               END IF;

               lb_userbrdg_exists :=
                    ksbms_util.f_any_rows_exist ('USERBRDG',
                                                     'brkey = '
                                                  || ksbms_util.sq (psi_brkey)
                                                );
               EXIT WHEN TRUE;
          END LOOP;
            RETURN lb_userbrdg_exists;
     EXCEPTION
          WHEN OTHERS
          THEN
               RETURN NULL;
     END f_userbrdg_exists;

     -- Given a brkey and inspkey, column name, and value,
     -- updates INSPEVNT to set the column to the value
     FUNCTION f_set_inspevnt_value (
          psi_brkey          IN   bridge.brkey%TYPE,
          psi_inspkey        IN   inspevnt.inspkey%TYPE,
          psi_column_name    IN   VARCHAR2,
          psi_column_value   IN   VARCHAR2
     )
          RETURN BOOLEAN -- function returns FALSE on success, TRUE on FAILURE
     IS
          lb_failed             BOOLEAN         := TRUE; -- Assume failure
          ls_column_value       VARCHAR2 (2000);
          ls_context  ksbms_util.context_string_type  := 'f_set_inspevnt_value()';
          ls_sql                VARCHAR2 (2000);
     BEGIN

          <<outer_exception_block>>
          BEGIN
               LOOP
                    -- Make sure the brkey is valid
                    IF NOT f_bridge_exists (psi_brkey)
                    THEN
                         ksbms_util.p_sql_error (   'The passed BRKEY '
                                                 || psi_brkey
                                                 || ' does not exist!'
                                                );
                    END IF;

                    -- Do we need apostrophes or date conversion? Fix the literal based on its data type.
                    ls_column_value := psi_column_value;

                    IF ksbms_util.f_wrap_data_value ('INSPEVNT',
                                                     psi_column_name,
                                                     ls_column_value
                                                    )
                    THEN
                         EXIT;
                    END IF;

                    BEGIN
                         ls_sql :=
                                  'update inspevnt set '
                               || psi_column_name
                               || ' = '
                               || ls_column_value
                               || ' where brkey = '''
                               || UPPER (psi_brkey)
                               || ''' and inspkey = '''
                               || psi_inspkey
                               || '''';
                         EXECUTE IMMEDIATE ls_sql;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              ksbms_util.p_sql_error (   'Updating INSPEVNT column '
                                                      || psi_column_name
                                                      || ' to '
                                                      || ls_column_value
                                                     );
                    END;

                    -- success!
                    lb_failed := FALSE;
                    EXIT;
               END LOOP;
          -- This catches the exception triggered by p_sql_error() above
          EXCEPTION
               WHEN OTHERS
               THEN
                    ksbms_util.p_add_msg (ls_context || ' failed');
                    RAISE ksbms_util.generic_exception;
          END outer_exception_block;

          RETURN lb_failed;
     END f_set_inspevnt_value;

     FUNCTION f_inspection_exists (
          the_brkey_in     IN   bridge.brkey%TYPE,
          the_inspkey_in   IN   inspevnt.inspkey%TYPE
     )
          RETURN BOOLEAN
     IS
          lb_inspection_exists   BOOLEAN       := FALSE;
          ls_context  ksbms_util.context_string_type := 'f_inspection_exists()';
     BEGIN
          LOOP
               IF ksbms_util.f_ns (the_brkey_in)
               THEN
                    ksbms_util.p_bug (   'NULL or empty BRKEY passed to '
                                      || ls_context
                                     );
                    RETURN FALSE;
               END IF;

               IF ksbms_util.f_ns (the_inspkey_in)
               THEN
                    ksbms_util.p_bug (   'NULL or empty INSPKEY passed to '
                                      || ls_context
                                     );
                    RETURN FALSE;
               END IF;

               lb_inspection_exists :=
                    ksbms_util.f_any_rows_exist ('INSPEVNT',
                                                     'brkey = '
                                                  || ksbms_util.sq (the_brkey_in
                                                                   )
                                                  || ' AND inspkey = '
                                                  || ksbms_util.sq (UPPER (the_inspkey_in
                                                                          )
                                                                   )
                                                );
               EXIT WHEN TRUE;
          END LOOP;

          RETURN lb_inspection_exists;
     EXCEPTION
          WHEN OTHERS
          THEN
               RETURN NULL;
     END f_inspection_exists;

       -- Given a brkey and strunitkey, column name, and value,
       -- updates STRUCTURE_UNIT to set the column to the value
     -- Given a brkey and on_under, column name, and value,
       -- updates ROADWAY to set the column to the value
     FUNCTION f_set_roadway_value (
          psi_brkey          IN   bridge.brkey%TYPE,
          psi_on_under       IN   roadway.on_under%TYPE,
          psi_column_name    IN   VARCHAR2,
          psi_column_value   IN   VARCHAR2
     )
          RETURN BOOLEAN -- function returns FALSE on success, TRUE on FAILURE
     IS
          lb_failed             BOOLEAN         := TRUE; -- Assume failure
          ls_column_value       VARCHAR2 (2000);
          ls_context   ksbms_util.context_string_type   := 'f_set_roadway_value()';
          ls_sql                VARCHAR2 (2000);
     BEGIN

          <<outer_exception_block>>
          BEGIN
               LOOP
                    -- Make sure the brkey and on_under is valid
                    IF NOT f_roadway_exists (psi_brkey, psi_on_under)
                    THEN
                         ksbms_util.p_sql_error (   'The passed BRKEY '
                                                 || psi_brkey
                                                 || ' and on_under '
                                                 || psi_on_under
                                                 || ' do not correspond to any ROADWAY record!'
                                                );
                    END IF;

                    -- Do we need apostrophes or date conversion? Fix the literal based on its data type.
                    ls_column_value := psi_column_value;

                    IF ksbms_util.f_wrap_data_value ('ROADWAY',
                                                     psi_column_name,
                                                     ls_column_value
                                                    )
                    THEN
                         EXIT;
                    END IF;

                    BEGIN
                         ls_sql :=
                                  'update roadway set '
                               || psi_column_name
                               || ' = '
                               || ls_column_value
                               || ' where brkey = '''
                               || UPPER (psi_brkey)
                               || ''' and on_under = '''
                               || psi_on_under
                               || '''';
                         EXECUTE IMMEDIATE ls_sql;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              ksbms_util.p_sql_error (   'Updating ROADWAY column '
                                                      || psi_column_name
                                                      || ' to '
                                                      || ls_column_value
                                                     );
                    END;

                    -- success!
                    lb_failed := FALSE;
                    EXIT;
               END LOOP;
          -- This catches the exception triggered by p_sql_error() above
          EXCEPTION
               WHEN OTHERS
               THEN
                    ksbms_util.p_add_msg (ls_context || ' failed');
                    RAISE ksbms_util.generic_exception;
          END outer_exception_block;

          RETURN lb_failed;
     END f_set_roadway_value;

     FUNCTION f_roadway_exists (
          psi_brkey      IN   bridge.brkey%TYPE,
          psi_on_under   IN   roadway.on_under%TYPE
     )
          RETURN BOOLEAN
     IS
          lb_roadway_exists     BOOLEAN       := FALSE;
          ls_context   ksbms_util.context_string_type := 'f_roadway_exists()';
     BEGIN
          LOOP
               -- Make sure the arguments are valid
               IF ksbms_util.f_ns (psi_brkey)
               THEN
                    ksbms_util.p_bug (   'NULL or empty BRKEY passed to '
                                      || ls_context
                                     );
                    RETURN FALSE;
               END IF;

               IF ksbms_util.f_ns (psi_on_under)
               THEN
                    ksbms_util.p_bug (   'NULL or empty ON_UNDER passed to '
                                      || ls_context
                                     );
                    RETURN FALSE;
               END IF;

               lb_roadway_exists :=
                    ksbms_util.f_any_rows_exist ('ROADWAY',
                                                     'brkey = '
                                                  || ksbms_util.sq (psi_brkey)
                                                  || ' and on_under = '
                                                  || ksbms_util.sq (psi_on_under
                                                                   )
                                                );
               EXIT WHEN TRUE;
          END LOOP;

          RETURN lb_roadway_exists;
     EXCEPTION
          WHEN OTHERS
          THEN
               RETURN NULL;
     END f_roadway_exists;


       -- updates USERWAY to set the column to the value
     FUNCTION f_set_userrway_value (
          psi_brkey          IN   USERrway.brkey%TYPE,
          psi_on_under       IN   USERrway.on_under%TYPE,
          psi_column_name    IN   VARCHAR2,
          psi_column_value   IN   VARCHAR2
     )
          RETURN BOOLEAN -- function returns FALSE on success, TRUE on FAILURE
     IS
          lb_failed             BOOLEAN         := TRUE; -- Assume failure
          ls_column_value       VARCHAR2 (2000);
          ls_context   ksbms_util.context_string_type   := 'f_set_userrway_value()';
          ls_sql                VARCHAR2 (2000);
     BEGIN
          -- push context on stack
          ksbms_util.p_push( ls_context );

          <<outer_exception_block>>
          BEGIN
               LOOP
                    -- Make sure the brkey and on_under is valid
                    IF NOT f_userrway_exists (psi_brkey, psi_on_under)
                    THEN
                         ksbms_util.p_sql_error (   'The passed BRKEY '
                                                 || psi_brkey
                                                 || ' and on_under '
                                                 || psi_on_under
                                                 || ' do not correspond to any USERRWAY record!'
                                                );
                    END IF;

                    -- Do we need apostrophes or date conversion? Fix the literal based on its data type.
                    ls_column_value := psi_column_value;

                    IF ksbms_util.f_wrap_data_value ('USERRWAY',
                                                     psi_column_name,
                                                     ls_column_value
                                                    )
                    THEN
                         EXIT;
                    END IF;

                    BEGIN
                         ls_sql :=
                                  'update userrway set '
                               || psi_column_name
                               || ' = '
                               || ls_column_value
                               || ' where brkey = '''
                               || UPPER (psi_brkey)
                               || ''' and on_under = '''
                               || psi_on_under
                               || '''';
                         EXECUTE IMMEDIATE ls_sql;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              ksbms_util.p_sql_error (   'Updating USERRWAY column '
                                                      || psi_column_name
                                                      || ' to '
                                                      || ls_column_value
                                                     );
                    END;

                    -- success!
                    lb_failed := FALSE;
                    EXIT;
               END LOOP;
          -- This catches the exception triggered by p_sql_error() above
          EXCEPTION
               WHEN OTHERS
               THEN
                    ksbms_util.p_add_msg (ls_context || ' failed');
                    RAISE ksbms_util.generic_exception;
          END outer_exception_block;
          ksbms_util.p_pop( ls_context ); -- clear stack
          RETURN lb_failed;
     END f_set_userrway_value;

     FUNCTION f_userrway_exists (
          psi_brkey      IN   userrway.brkey%TYPE,
          psi_on_under   IN   userrway.on_under%TYPE
     )
          RETURN BOOLEAN
     IS
          lb_userrway_exists     BOOLEAN       := FALSE;
          ls_context   ksbms_util.context_string_type := 'f_userrway_exists()';
     BEGIN
               ksbms_util.p_push( ls_context );
          LOOP
               -- Make sure the arguments are valid
               IF ksbms_util.f_ns (psi_brkey)
               THEN
                    ksbms_util.p_bug (   'NULL or empty BRKEY passed to '
                                      || ls_context
                                     );
                    RETURN FALSE;
               END IF;

               IF ksbms_util.f_ns (psi_on_under)
               THEN
                    ksbms_util.p_bug (   'NULL or empty ON_UNDER passed to '
                                      || ls_context
                                     );
                    RETURN FALSE;
               END IF;

               lb_userrway_exists :=
                    ksbms_util.f_any_rows_exist ('USERRWAY',
                                                     'brkey = '
                                                  || ksbms_util.sq (psi_brkey)
                                                  || ' and on_under = '
                                                  || ksbms_util.sq (psi_on_under
                                                                   )
                                                );
               EXIT WHEN TRUE;
          END LOOP;
          ksbms_util.p_pop( ls_context );
          RETURN lb_userrway_exists;
     EXCEPTION
          WHEN OTHERS
          THEN
               RETURN NULL;
     END f_userrway_exists;

     FUNCTION f_set_structure_unit_value (
          psi_brkey          IN   bridge.brkey%TYPE,
          psi_strunitkey     IN   structure_unit.strunitkey%TYPE,
          psi_column_name    IN   VARCHAR2,
          psi_column_value   IN   VARCHAR2
     )
          RETURN BOOLEAN -- function returns FALSE on success, TRUE on FAILURE
     IS
          lb_failed             BOOLEAN         := TRUE; -- Assume failure
          ls_column_value       VARCHAR2 (2000);
          ls_context   ksbms_util.context_string_type
                                            := 'f_set_structure_unit_value()';
          ls_sql                VARCHAR2 (2000);
     BEGIN

          <<outer_exception_block>>
          BEGIN
               LOOP
                    -- Make sure the structure_unit is valid
                    IF NOT f_structure_unit_exists (psi_brkey,
                                                    psi_strunitkey)
                    THEN
                         ksbms_util.p_sql_error (   'The passed BRKEY '
                                                 || psi_brkey
                                                 || ' and STRUNITKEY '
                                                 || psi_strunitkey
                                                 || ' does not correspond to an existing structure unit!'
                                                );
                    END IF;

                    -- Do we need apostrophes or date conversion? Fix the literal based on its data type.
                    ls_column_value := psi_column_value;

                    IF ksbms_util.f_wrap_data_value ('STRUCTURE_UNIT',
                                                     psi_column_name,
                                                     ls_column_value
                                                    )
                    THEN
                         EXIT;
                    END IF;

                    BEGIN
                         ls_sql :=
                                  'update structure_unit set '
                               || psi_column_name
                               || ' = '
                               || ls_column_value
                               || ' where brkey = '''
                               || UPPER (psi_brkey)
                               || ''' and strunitkey = '''
                               || psi_strunitkey
                               || '''';
                         EXECUTE IMMEDIATE ls_sql;
                    EXCEPTION
                         WHEN OTHERS
                         THEN
                              ksbms_util.p_sql_error (   'Updating STRUCTURE_UNIT column '
                                                      || psi_column_name
                                                      || ' to '
                                                      || ls_column_value
                                                     );
                    END;

                    -- success!
                    lb_failed := FALSE;
                    EXIT;
               END LOOP;
          -- This catches the exception triggered by p_sql_error() above
          EXCEPTION
               WHEN OTHERS
               THEN
                    ksbms_util.p_add_msg (ls_context || ' failed');
                    RAISE ksbms_util.generic_exception;
          END outer_exception_block;

          RETURN lb_failed;
     END f_set_structure_unit_value;

     FUNCTION f_structure_unit_exists (
          psi_brkey        IN   bridge.brkey%TYPE,
          psi_strunitkey   IN   structure_unit.strunitkey%TYPE
     )
          RETURN BOOLEAN
     IS
          lb_structure_unit_exists   BOOLEAN       := FALSE;
          ls_context        ksbms_util.context_string_type := 'f_inspection_exists()';
     BEGIN
          LOOP
               -- Make sure the arguments are valid
               IF ksbms_util.f_ns (psi_brkey)
               THEN
                    ksbms_util.p_bug (   'NULL or empty BRKEY passed to '
                                      || ls_context
                                     );
                    RETURN FALSE;
               END IF;

               IF ksbms_util.f_ns (psi_strunitkey)
               THEN
                    ksbms_util.p_bug (   'NULL or empty STRUNITKEY passed to '
                                      || ls_context
                                     );
                    RETURN FALSE;
               END IF;

               lb_structure_unit_exists :=
                    ksbms_util.f_any_rows_exist ('STRUCTURE_UNIT',
                                                     'brkey = '
                                                  || ksbms_util.sq (psi_brkey)
                                                  || ' AND strunitkey = '
                                                  --|| ksbms_util.sq (upper (psi_strunitkey)) -- NOT QUITE, USE TO_CHAR  Allen Marshall, CS - 2002.12.17 was enquoted
                                                  || TO_CHAR (psi_strunitkey) -- NOT QUITE, USE TO_CHAR
                                                );
               EXIT WHEN TRUE;
          END LOOP;

          RETURN lb_structure_unit_exists;
     EXCEPTION
          WHEN OTHERS
          THEN
               RETURN NULL;
     END f_structure_unit_exists;

     -- So we can avoid the package initialization in code we're debugging;
     -- call this procedure before the code you're working on.

     PROCEDURE p_set_inspectiondates_missing(psi_brkey in bridge.brkey%type)

/*
 procedure p_set_inspectiondates_missing
 Allen Marshall, CS, 2002-12-30
  sets all inspection dates for a bridge missing.  Used when creating a
  new structure to force missing inspection dates wholesale
  Fired for each bridge created during an inspection session
  Does not propagate to log
  All updates are autonomous transactions.

 inputs;
        Requires passed BRKEY

 exceptions
           not implemented
*/
IS
  -- local variables here
  -- Allen Marshall, CS -2002.12.20 - use the default missing date string from ksbms_pontis_util.f_return_missing_date_string,
  ls_date_format VARCHAR2(10) ;

 ld_missing_date DATE ;

PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
      ksbms_pontis.p_turn_off_exchange;
  ls_date_format :=  NVL( ksbms_util.f_get_COPTION_VALUE('DEFAULTDATEFORMAT'), 'YYYY-MM-DD');
                    ld_missing_date :=  to_date(substr( ksbms_pontis_util.f_return_missing_date_string,1,10), ls_date_format );

      /*
      from taib_inspevnt_validation (obsoleted)
       ls_date_format :=  NVL( ksbms_util.f_get_COPTION_VALUE('DEFAULTDATEFORMAT'), 'YYYY-MM-DD');
                    ld_missing_date :=  to_date(substr( ksbms_pontis_util.f_return_missing_date_string,1,10), ls_date_format );
                                 :new.inspdate               :=  ld_missing_date;
                                :new.NEXTINSP           :=  ld_missing_date;
                                :new.ELINSPDATE       :=  ld_missing_date;
                                :new.ELNEXTDATE       := ld_missing_date;
                                :new.OSLASTINSP       := ld_missing_date;
                                :new.OSNEXTDATE      := ld_missing_date;
                                :new.FCLASTINSP        := ld_missing_date;
                                :new.FCNEXTDATE       := ld_missing_date;
                                :new.UWLASTINSP      := ld_missing_date;
                                :new.UWNEXTDATE     := ld_missing_date;
      */
      -- set all to missing date taken from the DS_CONFIG_OPTIONS table
      UPDATE inspevnt
                               SET
                               INSPDATE            =  ld_missing_date,
                               LASTINSP            =  ld_missing_date,
                               NEXTINSP            =  ld_missing_date,
                                ELINSPDATE       =  ld_missing_date,
                                ELNEXTDATE       = ld_missing_date,
                                OSLASTINSP       = ld_missing_date,
                                OSNEXTDATE      = ld_missing_date,
                                FCLASTINSP        = ld_missing_date,
                                FCNEXTDATE       = ld_missing_date,
                                UWLASTINSP      = ld_missing_date,
                                UWNEXTDATE     = ld_missing_date
    WHERE BRKEY = psi_brkey;
    COMMIT;

       ksbms_pontis.p_turn_on_exchange;
       EXCEPTION
       WHEN OTHERS THEN
       -- we don't do anything if the update failed, just make sure to
       -- turn on EXCHANGE mechanisms if we get here..
       ksbms_pontis.p_turn_on_exchange;

END p_set_inspectiondates_missing;


     PROCEDURE documentation
     IS
     BEGIN

          ksbms_util.pl ('KSBMS_PONTIS_UTIL - Pontis specific utilities');
          ksbms_util.pl ('Revision History:');

-- ENTER IN REVERSE CHRONOLOGICAL ORDER, PLEASE
         ksbms_util.pl ('ARM, CS- 3/6/2003 - Revised again, to suppress error message in e-mail from F_get_bridge_id_from_brkey - still goes to log.  Calling routine is responsible for figuring out if NULL return is not OK.  Bad exceptions other than NO_DATA_FOUND now actually raised');
         ksbms_util.pl ('ARM, CS - 3/6/2003 - Changed f_get_pontis_coption_value to NOT use pontis.table_name notation - also, dropped package PONTIS from KSBMS_ROBOT that was muddying the SYNONYM waters');
         ksbms_util.pl ('ARM, CS - 3/6/2003 - Suppressed error message in e-mail from F_get_bridge_id_from_brkey - still goes to log.  Calling routine is responsible for figuring out if NULL return is not OK.  Bad exceptions other than NO_DATA_FOUND now actually raised');
         ksbms_util.pl ('ARM, CS - 1/17/2003 - All Stack Trace calls (passing ls_context or argument psi_context) now use the anchored context_string_type from ksbms_util.  Prevent too small buffer problem');
         ksbms_util.pl ('ARM, CS - 01/16/2003 - changed ksbms_pontis to use f_get_bridge_id_from_brkey from this package - left wrapper in ksbms_pontis');
         ksbms_util.pl ('ARM, CS - 01/16/2003 - augmented f_get_bridge_id_from_brkey exception message');
         ksbms_util.pl ('ARM, CS - 01/03/2003 - replaced f_get_bridge_id_from_brkey from ksbms_pontis - duplicate');

         ksbms_util.pl ('ARM, CS - 01/03/2003 -defeated f_get_bridge_id_from_brkey set to BAD because it gives erroneous results - DO NOT USE, PLAN TO DROP');

          ksbms_util.pl ('ARM, CS - 12/29/2002 -p_set_inspectiondates_missing - forces any new inspections to have missing dates if gen erated as part of CREATE STRUCTURE');
          ksbms_util.pl ('ARM, CS - 12/20/2002 -f_return_missing_date_string() enhanced to lookup a default missing date string in DS_CONFIG_OPTIONS'
                        );
          ksbms_util.pl ('ARM, CS - 12/19/2002 - added function f_get_pontis_on_under to generate a random on_under 2 character value'
                        );
          ksbms_util.pl ('ARM, CS -12/17/2002 - added this procedure, resorted modules to put table exists and table set value functions at bottom'
                        );
           /*
           -- these en-commented lines should not be edited - they force CVS to stick all these expanded keywords in to the source code automatically on check-in
          $ID$
          $Source: /repository/kansas/ksbms/ksbms_pontis_util.pck,v $
          $Log: ksbms_pontis_util.pck,v $
          Revision 1.12  2003/03/06 22:01:49  arm
          Allen Marshall, CS - 2003.03.06 - further revisions to f_get_bridge_id_for_brkey and f_get_brkey_for_Bridge_id().  Added push pop of stack, added begin end to exception blocks, standardized formatting.

          Revision 1.11  2003/03/06 19:54:44  arm
          Allen Marshall, CS - 2003.03.06  Various changes related to f_get_brkey_for_bridge_id and vice versa, intended to stop stamping email with bogus messages about bridge not found when evaluating need to insert.  Code must still verify that NULL return from these searching functions is OK.

         */
     END documentation;
BEGIN
  -- Initialization
/*  <Statements>;*/
  -- Initialization section on load (if null)
  -- set Pontis version (1 time,
  -- use pontis_util.get_pontis_version from calling routines to
  -- find the value )
     IF gs_pontis_version IS NULL
     THEN
          set_pontis_version;
     END IF;

     -- set Pontis DB IDKEY (version specific)
     IF gs_db_id_key IS NULL
     THEN
          set_pontis_db_id_key;
     END IF;

     -- initialize gs_last_inspkey;
     IF gs_last_inspkey IS NULL
     THEN
          gs_last_inspkey := 'NOTSETYET';
     END IF;

     -- make sure there is a user with USERID DEFAULT in the Pontis USERS table
     IF gs_default_userid IS NULL
     THEN
          gs_default_userid := 'DEFAULT';
     END IF;

     IF gs_default_userkey IS NULL
     THEN
          gs_default_userkey := f_get_userkey_for_orauser (gs_default_userid);
     END IF;

     gs_default_exchange_log_status := '0';
END ksbms_pontis_util;
/