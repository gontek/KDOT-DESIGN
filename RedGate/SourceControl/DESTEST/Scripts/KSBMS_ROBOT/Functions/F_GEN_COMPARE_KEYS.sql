CREATE OR REPLACE FUNCTION ksbms_robot.f_gen_compare_keys (
   the_entryid_in   IN   ds_change_log_temp.entry_id%TYPE
)
   RETURN VARCHAR2
IS
   -- This is the string we're building
   ls_key_values_concatenated   ds_change_log_temp.remarks%TYPE;

BEGIN
   
---------------------------------------------------------------------------------------------------
-- Pass through all the ds_change_log_temp values, concatenating the keys into the remarks column.
-- This is needed so we can sort by the key values, to identify "ties" where we need to apply the
-- tie-breaking precedence. A "tie" means the same record.table.column was changed by both systems.
---------------------------------------------------------------------------------------------------

   DECLARE
      -- Loop through all the ds_change_log_temp records
      /*ls_merge_ready     constant ds_change_log.exchange_status%type
      := 'MERGEREADY'; -- "
      */
      li_error_code               PLS_INTEGER;

      -- Loop through the CORRESPONDING ds_lookup_keyvals_temp records
      CURSOR corresponding_keyvals_cursor (
         the_entryid_in   IN   ds_change_log_temp.entry_id%TYPE
      )
      IS
         SELECT   NVL (keyvalue, '<MISSING>') this_key
             FROM ds_lookup_keyvals_temp
            WHERE ds_lookup_keyvals_temp.entry_id = the_entryid_in
         ORDER BY key_sequence_num;

      corresponding_keyvals_rec   corresponding_keyvals_cursor%ROWTYPE;
   BEGIN -- So we have an exception-handler for the cursor
      -- Open the keyvalues cursor
      IF corresponding_keyvals_cursor%ISOPEN
      THEN
         -- HOYTFIX Raise an error if this happens?
         CLOSE corresponding_keyvals_cursor;
      END IF;

      OPEN corresponding_keyvals_cursor (the_entryid_in);
      -- Clear out the string we're going to accumulate
      ls_key_values_concatenated := '|'; -- | keeps A + BC from equaling AB + C: |A|BC| <> |AB|C|

      -- Loop through all the keyvalues for this change log record
      <<keyval_loop>>
      LOOP
         -- Get then next keyvalue
         FETCH corresponding_keyvals_cursor INTO corresponding_keyvals_rec;
         EXIT WHEN corresponding_keyvals_cursor%NOTFOUND;
         -- Accumulate the keyvalue (the vertical bar is used to separate values, for ease of debugging)
         ls_key_values_concatenated :=    ls_key_values_concatenated
                                       || corresponding_keyvals_rec.this_key
                                       || '|';
      END LOOP keyval_loop;

      -- CLOSE the cursor looping through the KEYVALs for this change_log_temp record
      CLOSE corresponding_keyvals_cursor;
   -- Save the accumulated keys

   EXCEPTION
      WHEN OTHERS
      THEN
         li_error_code := ksbms_ds_exc.building_concatenated_keys ();
         ksbms_err.errhandler (
            2,
            ksbms_ds_exc.building_concatenated_keys (),
            ksbms_msginfo.getmsgtext (
               2,
               ksbms_ds_exc.building_concatenated_keys (),
               'EXCEPTION',
               TRUE
            ),
            FALSE,
            TRUE
         );
   END;

   RETURN (ls_key_values_concatenated);
END f_gen_compare_keys;

 
/