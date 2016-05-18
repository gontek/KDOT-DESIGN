CREATE OR REPLACE TRIGGER pontis.taid_sl_bridge
   AFTER INSERT OR DELETE
   ON pontis.bridge
/*
taid_sl_bridge:
Allen R. Marshall, CS - 2002-12-12
STATEMENT LEVEL TRIGGER EXECUTES ON INSERT OR DELETE ON BRIDGE TABLE
when inserting
     1) sets inspection dates for the bridge to missing (there should be but one inspection record to update but does all/any it finds
     uses procedure ksbm_pontis_util.p_set_inspectiondates_missing
     
     
     LAST) reset scoreboard of brkeys

when deleting
     After all delete rows have been processed, there may be spurious change log entries for the
     deleted bridges.  Will troll through the log and find all these and delete all of them EXCEPT
     the latest DEL entry.  Prior entries for the bridge of ANY type on any table linked by BRIDGE_ID will go away.
     
     LAST) reset scoreboard of brkeys

*/


DISABLE DECLARE
   -- local variables here
   v_bridge_id                              bridge.bridge_id%TYPE; -- bridge id being processed in loop  <<ENTRY_ID_TROLL>>
   v_brkey                                   BRIDGE.BRKEY%TYPE; -- brkey being processed - reduces need to look in scoreboard table
   v_last_entry_id                          ds_change_log.entry_id%TYPE; -- comparison variable to see if a new bridge_id has been encountered
   v_element                                PLS_INTEGER                  := 0;                                                       -- collection table index for lookup
   -- local constant
   cl_bridge_id_exchange_rule_id   CONSTANT PLS_INTEGER                 := 90; -- change here if the rule changes
BEGIN

   IF INSERTING
   THEN
       BEGIN
      -- do something with the accumulated BRKEYS because of INSERT

      v_element := ksbms_scoreboard.v_bridge_key_table.FIRST;
      <<entry_id_troll_inserting>>
      
      LOOP -- through all the BRKEY of inserted records stored in the PL/SQL table
         EXIT WHEN v_element IS NULL;
         -- pass BRKEY from the inserted table to procedure(s)
      -- 1) clear out inspection dates for newly inserted bridge if any......
      -- set new inspection to have all dates missing
      v_brkey         :=       ksbms_scoreboard.v_bridge_key_table (v_element).brkey; 
      ksbms_pontis_util.p_set_inspectiondates_missing( v_brkey );
 
    -- increment index to next valid one
       v_element := ksbms_scoreboard.v_bridge_key_table.NEXT (v_element); -- goes null if past end of collection
      END LOOP entry_id_troll_inserting;
      
      -- LAST) reset the scoreboard for tidiness purposes.
      -- RESET SCOREBOARD - IMPORTANT
      ksbms_scoreboard.p_reset_br_scoreboard;
      END;
   ELSIF DELETING THEN
       BEGIN
      -- Allen Marshall, CS - 12/12/2002
      -- do something with the accumulated BRKEYS because of DELETE
      -- in this case, find all the spurious ds_change_log entries for each bridge prior to this DEL
      -- directive..

      v_element := ksbms_scoreboard.v_bridge_key_table.FIRST;

      ksbms_scoreboard.p_init_ds_change_log_entry_ids; -- empty me out first so the loop      <<FIND_LOG_ENTRIES>> can fill me

      <<entry_id_troll_deleting>>
      LOOP
         EXIT WHEN v_element IS NULL;
         -- troll through the change log key values and get all the entries for this bridge_id....
         -- we can't just delete from DS_CHANGE_LOG because it has no key matches to BRKEY - they are in the child table DS_LOOKUP_KEYVALS;

         -- convert brkey to a bridge_id using the magic function that looks it up in the database.  Allen Marshall, CS - 2003.01.03
         -- we want the current value of BRIDGE_ID from the BRIDGE table for the BRKEY entered...
--         v_bridge_id :=
--            ksbms_pontis.f_get_bridge_id_from_brkey (ksbms_scoreboard.v_brkey_table (v_element
 --                                                                                 )
  --                                                 );
         v_bridge_id  :=      ksbms_scoreboard.v_bridge_key_table (v_element).bridge_id;              
         v_brkey         :=       ksbms_scoreboard.v_bridge_key_table (v_element).brkey;                                              
         
         -- set the entry_id empty for sure
         v_last_entry_id := NULL;

         <<find_log_entries>>
         /*
         -- skips latest entry with exchange_rule_id = cl_bridge_id_exchange_rule_id ( see above, set to 90 ) in the stream for each bridge
         -- exchange_rule_id cl_bridge_id_exchange_rule_id means  a change to BRIDGE.BRIDGE_ID
           Give me all the change log entries ENTRY_ID values for every change on each bridge that match the set of BRKEY or BRIDGE_ID values that
            I collected during this
           delete event, and for those that are either not exchange_rule_id =cl_bridge_id_exchange_rule_id  (any changes other than
           bridge_id DEL

           OR

           those changes that are exchange_rule_id = cl_bridge_id_exchange_rule_id  but PRECEDED the latest DEL directive, and are consequently
           obsolete as well,

         */
             -- logrec is a cursor loop - do not use after scope of loop
             -- loop is accumulating entry id values in the collection variable ksbms_scoreboard.v_ds_change_log_table
             -- get rid of both BRIDGE_ID entries and BRKEY entries for the same bridge...
         FOR logrec IN
            (SELECT   ds_change_log.entry_id, ds_change_log.sequence_num,
                      ds_lookup_keyvals.keyvalue, ds_change_log.exchange_type
                 FROM ds_change_log, ds_lookup_keyvals
                WHERE ((    (       ds_lookup_keyvals.keyname = 'BRIDGE_ID'
                                AND ds_lookup_keyvals.keyvalue = v_bridge_id
                             OR     ds_lookup_keyvals.keyname = 'BRKEY'
                                AND ds_lookup_keyvals.keyvalue =
                                       v_brkey
                            )
                        AND ds_change_log.entry_id =
                                                    ds_lookup_keyvals.entry_id
                        AND ds_change_log.exchange_rule_id <>
                                                 cl_bridge_id_exchange_rule_id
                       )
                      )
                   OR (    (       ds_lookup_keyvals.keyname = 'BRIDGE_ID'
                               AND ds_lookup_keyvals.keyvalue = v_bridge_id
                            OR     ds_lookup_keyvals.keyname = 'BRKEY'
                               AND ds_lookup_keyvals.keyvalue =
                                     v_brkey
                           )
                       AND ds_change_log.entry_id = ds_lookup_keyvals.entry_id
                       AND ds_change_log.exchange_rule_id =
                                                 cl_bridge_id_exchange_rule_id
                       AND ds_change_log.sequence_num <
                              (SELECT MAX (sequence_num)
                                 FROM ds_change_log, ds_lookup_keyvals
                                WHERE (       ds_lookup_keyvals.keyname =
                                                                   'BRIDGE_ID'
                                          AND ds_lookup_keyvals.keyvalue =
                                                                   v_bridge_id
                                       OR     ds_lookup_keyvals.keyname =
                                                                       'BRKEY'
                                          AND ds_lookup_keyvals.keyvalue =
                                                v_brkey
                                      )
                                  AND ds_change_log.entry_id =
                                                    ds_lookup_keyvals.entry_id)
                      )
             ORDER BY ds_change_log.entry_id DESC)
         LOOP
            -- put the latest entry_id into the collection variable
            -- array only if different than prior or if prior is null on first loop execution

            IF logrec.entry_id <> v_last_entry_id OR v_last_entry_id IS NULL
            THEN
               ksbms_scoreboard.p_add_ds_change_log_entry_id (logrec.entry_id);
               v_last_entry_id := logrec.entry_id;
            END IF;
         END LOOP find_log_entries;

         -- increment index to next valid one
         v_element := ksbms_scoreboard.v_bridge_key_table.NEXT (v_element); -- goes null if past end of collection
      END LOOP entry_id_troll_deleting;

      -- reset v_element to first valid entry of collection variable (PL/SQL Table)
      v_element := ksbms_scoreboard.v_ds_change_log_table.FIRST;

      <<entry_id_delete>>
      LOOP
         EXIT WHEN v_element IS NULL;

         /*
         -- for all the entry ids in the collection variable  ksbms_scoreboard.v_ds_change_log_table, delete those
         -- entries from ds_change_log because they are obsoleted by the DEL directive that 'follows' them in sequence_num
         -- order
         */
         DELETE FROM ds_change_log
               WHERE entry_id =
                           ksbms_scoreboard.v_ds_change_log_table (v_element);
         /* Increment v_element to next valid entry */
         v_element := ksbms_scoreboard.v_ds_change_log_table.NEXT (v_element);
      END LOOP entry_id_delete;

      /* Clean up */
      ksbms_scoreboard.p_reset_br_scoreboard; -- empty me out..
      ksbms_scoreboard.p_reset_insp_scoreboard; -- empty me out..
      ksbms_scoreboard.p_reset_unit_scoreboard; -- empty me out..
      ksbms_scoreboard.p_reset_rway_scoreboard; -- empty me out..
      ksbms_scoreboard.p_init_ds_change_log_entry_ids; -- empty me out
      -- change status flags to FALSE (all done) depending on what we are doing....
      IF INSERTING THEN
           ksbms_scoreboard.p_br_insert_complete;
     ELSIF updating THEN
           ksbms_scoreboard.p_br_delete_complete;
     END IF;
      END;
   END IF;
   
END taid_sl_bridge;
/