CREATE OR REPLACE PACKAGE pontis."KSBMS_SCOREBOARD"
IS
     -- Author  : ARM
     -- Created : 2002-12-12 11:47:10
     -- updates : 2003-01-02 - added scoreboards for all tables INSPEVNT ROADWAY STRUCTURE_UNIT
     -- Purpose : Utility functions and collection variables used to track changes to various tables via statement level trigger operations
     -- collects primary keys for each table and child table of a bridge + bridge_id for the bridge

     -- Public type declarations
     -- SCOREBOARD OF BRKEY   VALUES, PLUS TABLE SPECICIF KEYS
     -- BRIDGE_ID IS ALWAYS IN LAST POSITION IN THE RECORDS, BRKEY FIRST, SUBORDINATE TABLE KEY SECOND
     TYPE v_bridge_identifier_rec_type IS RECORD (
          brkey       bridge.brkey%TYPE,
          bridge_id   bridge.bridge_id%TYPE
     );

     TYPE v_bridge_key_table_type IS TABLE OF v_bridge_identifier_rec_type
          INDEX BY BINARY_INTEGER;

     TYPE v_inspevnt_keys_rec_type IS RECORD (
          brkey       roadway.brkey%TYPE,
          inspkey     inspevnt.inspkey%TYPE,
          bridge_id   bridge.bridge_id%TYPE
     ); -- denormal

     TYPE v_inspevnt_key_table_type IS TABLE OF v_inspevnt_keys_rec_type
          INDEX BY BINARY_INTEGER;

     TYPE v_roadway_keys_rec_type IS RECORD (
          brkey       roadway.brkey%TYPE,
          on_under    roadway.on_under%TYPE,
          bridge_id   bridge.bridge_id%TYPE
     ); --- denormal

     TYPE v_roadway_key_table_type IS TABLE OF v_roadway_keys_rec_type
          INDEX BY BINARY_INTEGER;

     TYPE v_unit_keys_rec_type IS RECORD (
          brkey        roadway.brkey%TYPE,
          strunitkey   structure_unit.strunitkey%TYPE,
          bridge_id    bridge.bridge_id%TYPE
     ); -- denormal

     TYPE v_unit_key_table_type IS TABLE OF v_unit_keys_rec_type
          INDEX BY BINARY_INTEGER;

      -- Public constant declarations
     -- <ConstantName> constant <Datatype> := <Value>;
      -- Public variable declarations

     v_bridge_key_table      v_bridge_key_table_type; -- table of bridge identifiers
     v_inspevnt_key_table    v_inspevnt_key_table_type; -- table of inspevnt identifiers
     v_roadway_key_table     v_roadway_key_table_type; -- table of roadway identifiers
     v_unit_key_table        v_unit_key_table_type; -- table of structure_unit identifiers

                                                    -- SCOREBOARD OF ENTRY IDS
                                                    -- acumulate log entry ids in a collection variable

     TYPE v_ds_change_log_table_type IS TABLE OF ds_change_log.entry_id%TYPE
          INDEX BY BINARY_INTEGER;

     v_ds_change_log_table   v_ds_change_log_table_type;

     v_bool_br_insert_underway BOOLEAN := FALSE;
     v_bool_br_delete_underway BOOLEAN := FALSE;

     /*
      Allen R. Marshall, CS - 2002-12-12
     Procedure to keep track of the BRKEY being inserted or DELETED
     Called by STATEMENT LEVEL TRIGGERS ON BRIDGE
     EXTENSIBLE FOR ANY TABLE
   */
     PROCEDURE p_reset_br_scoreboard;

-- routines to load PL/.SQL tables to keep track of keys for INSERT and DELETE on most important tables.
     PROCEDURE p_add_brkey_to_scoreboard (p_brkey IN bridge.brkey%TYPE);

     PROCEDURE p_add_br_keyvals_to_scoreboard (
          p_brkey       IN   bridge.brkey%TYPE,
          p_bridge_id   IN   bridge.bridge_id%TYPE
     );

     FUNCTION f_find_bridge_id_for_bridge (p_brkey IN bridge.brkey%TYPE)
          RETURN bridge.bridge_id%TYPE;

     PROCEDURE p_reset_insp_scoreboard;

     PROCEDURE p_add_in_keyvals_to_scoreboard (
          p_brkey       IN   inspevnt.brkey%TYPE,
          p_inspkey     IN   inspevnt.inspkey%TYPE,
          p_bridge_id   IN   bridge.bridge_id%TYPE
     );

     FUNCTION f_find_bridge_id_for_inspevnt (
          p_brkey     IN   inspevnt.brkey%TYPE,
          p_inspkey   IN   inspevnt.inspkey%TYPE
     )
          RETURN bridge.bridge_id%TYPE;

     PROCEDURE p_reset_rway_scoreboard;

     PROCEDURE p_add_rw_keyvals_to_scoreboard (
          p_brkey       IN   roadway.brkey%TYPE,
          p_on_under    IN   roadway.on_under%TYPE,
          p_bridge_id   IN   bridge.bridge_id%TYPE
     );

     FUNCTION f_find_bridge_id_for_rway (
          p_brkey      IN   roadway.brkey%TYPE,
          p_on_under   IN   roadway.on_under%TYPE
     )
          RETURN bridge.bridge_id%TYPE;

     PROCEDURE p_reset_unit_scoreboard;

     PROCEDURE p_add_su_keyvals_to_scoreboard (
          p_brkey        IN   structure_unit.brkey%TYPE,
          p_strunitkey   IN   structure_unit.strunitkey%TYPE,
          p_bridge_id    IN   bridge.bridge_id%TYPE
     );

     FUNCTION f_find_bridge_id_for_unit (
          p_brkey        IN   structure_unit.brkey%TYPE,
          p_strunitkey   IN   structure_unit.strunitkey%TYPE
     )
          RETURN bridge.bridge_id%TYPE;

     PROCEDURE p_init_ds_change_log_entry_ids;

     PROCEDURE p_add_ds_change_log_entry_id (
          p_entry_id   IN   ds_change_log.entry_id%TYPE
     );
-- use in BRIDGE DELETE or INSERT statement level triggers

     PROCEDURE p_br_delete_underway;
     PROCEDURE p_br_insert_underway;
     PROCEDURE p_br_delete_complete;
     PROCEDURE p_br_insert_complete;


     PROCEDURE p_test_br_scoreboard (
          p_brkey       IN   bridge.brkey%TYPE,
          p_bridge_id   IN   bridge.bridge_id%TYPE
     ); -- Allen Marshal-l, CS , 2003.01.03

     PROCEDURE p_test_insp_scoreboard (
          p_brkey       IN   inspevnt.brkey%TYPE,
          p_inspkey     IN   inspevnt.inspkey%TYPE,
          p_bridge_id   IN   bridge.bridge_id%TYPE
     );

     PROCEDURE p_test_rway_scoreboard (
          p_brkey       IN   roadway.brkey%TYPE,
          p_on_under    IN   roadway.on_under%TYPE,
          p_bridge_id   IN   bridge.bridge_id%TYPE
     );

     PROCEDURE p_test_unit_scoreboard (
          p_brkey        IN   structure_unit.brkey%TYPE,
          p_strunitkey   IN   structure_unit.strunitkey%TYPE,
          p_bridge_id    IN   bridge.bridge_id%TYPE
     );

     PROCEDURE documentation;
END ksbms_scoreboard;
 
/