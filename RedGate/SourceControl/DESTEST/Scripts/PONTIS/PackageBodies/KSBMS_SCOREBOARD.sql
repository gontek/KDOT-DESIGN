CREATE OR REPLACE PACKAGE BODY pontis."KSBMS_SCOREBOARD"
IS
     PROCEDURE p_reset_br_scoreboard
     IS
     BEGIN
          v_bridge_key_table.DELETE;
     END p_reset_br_scoreboard;

     PROCEDURE p_add_br_keyvals_to_scoreboard (
          p_brkey       IN   bridge.brkey%TYPE,
          p_bridge_id   IN   bridge.bridge_id%TYPE
     )
     IS
          v_element   PLS_INTEGER;
     BEGIN
          v_element := NVL (v_bridge_key_table.LAST, 0) + 1;
          v_bridge_key_table (v_element).brkey := p_brkey; -- put BRKEY INTO THE BRKEY COLLECTION VARIABLE
          v_bridge_key_table (v_element).bridge_id := p_bridge_id; --PUT BRIDGE_ID INTO THE BRIDGE_ID COLLECTION VARIABLE
          NULL;
     END p_add_br_keyvals_to_scoreboard;

     PROCEDURE p_add_brkey_to_scoreboard (p_brkey IN bridge.brkey%TYPE)
     IS
          v_element   PLS_INTEGER;
     BEGIN
          v_element := NVL (v_bridge_key_table.LAST, 0) + 1;
          v_bridge_key_table (v_element).brkey := p_brkey; -- put BRKEY INTO THE BRKEY COLLECTION VARIABLE
          v_bridge_key_table (v_element).bridge_id :=
                            ksbms_pontis.f_get_bridge_id_from_brkey (p_brkey); --PUT BRIDGE_ID INTO THE BRIDGE_ID COLLECTION VARIABLE
          NULL;
     END p_add_brkey_to_scoreboard;

     FUNCTION f_find_bridge_id_for_bridge (p_brkey IN bridge.brkey%TYPE)
          RETURN bridge.bridge_id%TYPE
     IS
          v_element     PLS_INTEGER             := 0;
          v_bridge_id   bridge.bridge_id%TYPE;
     BEGIN
          v_element := v_bridge_key_table.FIRST;

          LOOP
               EXIT WHEN v_element IS NULL;

               IF v_bridge_key_table (v_element).brkey = p_brkey
               THEN
                    v_bridge_id := v_bridge_key_table (v_element).bridge_id;
                    EXIT;
               END IF;

               -- increment index to next valid one
               v_element :=
                          ksbms_scoreboard.v_bridge_key_table.NEXT (v_element); -- goes null if past end of collection
          END LOOP;

          RETURN v_bridge_id;
     END f_find_bridge_id_for_bridge;

     PROCEDURE p_reset_insp_scoreboard
     IS
     BEGIN
          v_inspevnt_key_table.DELETE;
     END p_reset_insp_scoreboard;

     PROCEDURE p_add_in_keyvals_to_scoreboard (
          p_brkey       IN   inspevnt.brkey%TYPE,
          p_inspkey     IN   inspevnt.inspkey%TYPE,
          p_bridge_id   IN   bridge.bridge_id%TYPE
     )
     IS
          v_element      PLS_INTEGER;
          ls_bridge_id   bridge.bridge_id%TYPE;
     BEGIN
          v_element := NVL (v_inspevnt_key_table.LAST, 0) + 1;
          v_inspevnt_key_table (v_element).brkey := p_brkey; -- put BRKEY INTO THE  COLLECTION RECORD VARIABLE
          v_inspevnt_key_table (v_element).inspkey := p_inspkey; --PUT  INSPKEY INTO COLLECTION VARIABLE

          IF p_bridge_id IS NULL
          THEN
               ls_bridge_id :=
                            ksbms_pontis.f_get_bridge_id_from_brkey (p_brkey);
          ELSE
               ls_bridge_id := p_bridge_id;
          END IF;

          v_inspevnt_key_table (v_element).bridge_id := ls_bridge_id; --PUT  BRIDGE_ID INTO COLLECTION VARIABLE
          NULL;
     END p_add_in_keyvals_to_scoreboard;

     FUNCTION f_find_bridge_id_for_inspevnt (
          p_brkey     IN   inspevnt.brkey%TYPE,
          p_inspkey   IN   inspevnt.inspkey%TYPE
     )
          RETURN bridge.bridge_id%TYPE
     IS
          v_element     PLS_INTEGER             := 0;
          v_bridge_id   bridge.bridge_id%TYPE;
     BEGIN
          v_element := v_inspevnt_key_table.FIRST;

          LOOP
               EXIT WHEN v_element IS NULL;

               IF     v_inspevnt_key_table (v_element).brkey = p_brkey
                  AND v_inspevnt_key_table (v_element).inspkey = p_inspkey
               THEN
                    v_bridge_id := v_inspevnt_key_table (v_element).bridge_id;
                    EXIT;
               END IF;

               -- increment index to next valid one
               v_element :=
                        ksbms_scoreboard.v_inspevnt_key_table.NEXT (v_element); -- goes null if past end of collection
          END LOOP;

          RETURN v_bridge_id;
     END;

     PROCEDURE p_reset_rway_scoreboard
     IS
     BEGIN
          v_roadway_key_table.DELETE;
     END p_reset_rway_scoreboard;

     PROCEDURE p_add_rw_keyvals_to_scoreboard (
          p_brkey       IN   roadway.brkey%TYPE,
          p_on_under    IN   roadway.on_under%TYPE,
          p_bridge_id   IN   bridge.bridge_id%TYPE
     )
     IS
          v_element      PLS_INTEGER;
          ls_bridge_id   bridge.bridge_id%TYPE;
     BEGIN
          v_element := NVL (v_roadway_key_table.LAST, 0) + 1;
          v_roadway_key_table (v_element).brkey := p_brkey; -- put BRKEY INTO THE  COLLECTION RECORD VARIABLE
          v_roadway_key_table (v_element).on_under := p_on_under; --PUT  INSPKEY INTO COLLECTION VARIABLE

          IF p_bridge_id IS NULL
          THEN
               ls_bridge_id :=
                            ksbms_pontis.f_get_bridge_id_from_brkey (p_brkey);
          ELSE
               ls_bridge_id := p_bridge_id;
          END IF;

          v_roadway_key_table (v_element).bridge_id := ls_bridge_id; --PUT  BRIDGE_ID INTO COLLECTION VARIABLE
          NULL;
     END p_add_rw_keyvals_to_scoreboard;

     FUNCTION f_find_bridge_id_for_rway (
          p_brkey      IN   roadway.brkey%TYPE,
          p_on_under   IN   roadway.on_under%TYPE
     )
          RETURN bridge.bridge_id%TYPE
     IS
          v_element     PLS_INTEGER             := 0;
          v_bridge_id   bridge.bridge_id%TYPE;
     BEGIN
          v_element := v_roadway_key_table.FIRST;

          LOOP
               EXIT WHEN v_element IS NULL;

               IF     v_roadway_key_table (v_element).brkey = p_brkey
                  AND v_roadway_key_table (v_element).on_under = p_on_under
               THEN
                    v_bridge_id := v_roadway_key_table (v_element).bridge_id;
                    EXIT;
               END IF;

               -- increment index to next valid one
               v_element :=
                         ksbms_scoreboard.v_roadway_key_table.NEXT (v_element); -- goes null if past end of collection
          END LOOP;

          RETURN v_bridge_id;
     END f_find_bridge_id_for_rway;

     PROCEDURE p_reset_unit_scoreboard
     IS
     BEGIN
          v_unit_key_table.DELETE;
     END p_reset_unit_scoreboard;

     PROCEDURE p_add_su_keyvals_to_scoreboard (
          p_brkey        IN   structure_unit.brkey%TYPE,
          p_strunitkey   IN   structure_unit.strunitkey%TYPE,
          p_bridge_id    IN   bridge.bridge_id%TYPE
     )
     IS
          v_element      PLS_INTEGER;
          ls_bridge_id   bridge.bridge_id%TYPE;
     BEGIN
          v_element := NVL (v_unit_key_table.LAST, 0) + 1;
          v_unit_key_table (v_element).brkey := p_brkey; -- put BRKEY INTO THE  COLLECTION RECORD VARIABLE
          v_unit_key_table (v_element).strunitkey := p_strunitkey; --PUT  INSPKEY INTO COLLECTION VARIABLE

          IF p_bridge_id IS NULL
          THEN
               ls_bridge_id :=
                            ksbms_pontis.f_get_bridge_id_from_brkey (p_brkey);
          ELSE
               ls_bridge_id := p_bridge_id;
          END IF;

          v_unit_key_table (v_element).bridge_id := ls_bridge_id; --PUT  BRIDGE_ID INTO COLLECTION VARIABLE
          NULL;
     END p_add_su_keyvals_to_scoreboard;

     FUNCTION f_find_bridge_id_for_unit (
          p_brkey        IN   structure_unit.brkey%TYPE,
          p_strunitkey   IN   structure_unit.strunitkey%TYPE
     )
          RETURN bridge.bridge_id%TYPE
     IS
          v_element     PLS_INTEGER             := 0;
          v_bridge_id   bridge.bridge_id%TYPE;
     BEGIN
          v_element := v_unit_key_table.FIRST;

          LOOP
               EXIT WHEN v_element IS NULL;

               IF     v_unit_key_table (v_element).brkey = p_brkey
                  AND v_unit_key_table (v_element).strunitkey = p_strunitkey
               THEN
                    v_bridge_id := v_unit_key_table (v_element).bridge_id;
                    EXIT;
               END IF;

               -- increment index to next valid one
               v_element := ksbms_scoreboard.v_unit_key_table.NEXT (v_element); -- goes null if past end of collection
          END LOOP;

          RETURN v_bridge_id;
     END f_find_bridge_id_for_unit;

     /*
      Allen R. Marshall, CS - 2002-12-12
    Table to keep track of the BRKEY being inserted or DELETED
     Called by STATEMENT LEVEL TRIGGERS ON BRIDGE
     EXTENSIBLE FOR ANY TABLE
     */
     PROCEDURE p_init_ds_change_log_entry_ids
     IS
     BEGIN
          v_ds_change_log_table.DELETE;
     END p_init_ds_change_log_entry_ids;

     PROCEDURE p_add_ds_change_log_entry_id (
          p_entry_id   IN   ds_change_log.entry_id%TYPE
     )
     IS
     BEGIN
          v_ds_change_log_table (NVL (v_ds_change_log_table.LAST, 0) + 1) :=
                                                                   p_entry_id;
     END p_add_ds_change_log_entry_id;

     PROCEDURE p_test_br_scoreboard (
          p_brkey       IN   bridge.brkey%TYPE,
          p_bridge_id   IN   bridge.bridge_id%TYPE
     )
     IS
          ls_bridge_id   bridge.bridge_id%TYPE;
     BEGIN
          p_reset_br_scoreboard;
          p_add_br_keyvals_to_scoreboard (p_brkey, p_bridge_id);
          p_add_brkey_to_scoreboard (p_brkey);
          ls_bridge_id := f_find_bridge_id_for_bridge (p_brkey);
          p_reset_br_scoreboard;
     END p_test_br_scoreboard;

     PROCEDURE p_test_insp_scoreboard (
          p_brkey       IN   inspevnt.brkey%TYPE,
          p_inspkey     IN   inspevnt.inspkey%TYPE,
          p_bridge_id   IN   bridge.bridge_id%TYPE
     )
     IS
          ls_bridge_id   bridge.bridge_id%TYPE;
     BEGIN
          p_reset_insp_scoreboard;
          p_add_in_keyvals_to_scoreboard (p_brkey, p_inspkey, p_bridge_id);
          ls_bridge_id := f_find_bridge_id_for_inspevnt (p_brkey, p_inspkey);
          p_reset_insp_scoreboard;
     END p_test_insp_scoreboard;

     PROCEDURE p_test_rway_scoreboard (
          p_brkey       IN   roadway.brkey%TYPE,
          p_on_under    IN   roadway.on_under%TYPE,
          p_bridge_id   IN   bridge.bridge_id%TYPE
     )
     IS
          ls_bridge_id   bridge.bridge_id%TYPE;
     BEGIN
          p_reset_rway_scoreboard;
          p_add_rw_keyvals_to_scoreboard (p_brkey, p_on_under, p_bridge_id);
          ls_bridge_id := f_find_bridge_id_for_rway (p_brkey, p_on_under);
          p_reset_rway_scoreboard;
     END p_test_rway_scoreboard;

     PROCEDURE p_test_unit_scoreboard (
          p_brkey        IN   structure_unit.brkey%TYPE,
          p_strunitkey   IN   structure_unit.strunitkey%TYPE,
          p_bridge_id    IN   bridge.bridge_id%TYPE
     )
     IS
          ls_bridge_id   bridge.bridge_id%TYPE;
     BEGIN
          p_reset_unit_scoreboard;
          p_add_su_keyvals_to_scoreboard (p_brkey, p_strunitkey, p_bridge_id);
          ls_bridge_id := f_find_bridge_id_for_unit (p_brkey, p_strunitkey);
          p_reset_unit_scoreboard;
     END p_test_unit_scoreboard;

     -- use in BRIDGE DELETE or INSERT statement level triggers

     PROCEDURE p_br_delete_underway
     IS
     BEGIN
     v_bool_br_delete_underway := TRUE;
     END p_br_Delete_underway;

     PROCEDURE p_br_insert_underway
     IS
     BEGIN
     v_bool_br_insert_underway := TRUE;
     END p_br_insert_underway;

     PROCEDURE p_br_delete_complete
     IS
     BEGIN
     v_bool_br_delete_underway := FALSE;
     END p_br_delete_complete;

     PROCEDURE p_br_insert_complete
     IS
     BEGIN
     v_bool_br_insert_underway := FALSE;
     END p_br_insert_complete;

     PROCEDURE documentation
     IS
     BEGIN
          ksbms_util.pl ('KSBMS_SCOREBOARD - Pontis transaction tracking utilities - record incoming and outgoing row key values'
                        );
          ksbms_util.pl ('Revision History:');
          ksbms_util.pl ('ARM - 1/3/2003 - implemented INSPEVNT, ROADWAY, STRUCTURE_UNIT level key tracking - used by various statement level and row level triggers on these tables'
                        );
          ksbms_util.pl ('ARM - 12/2002 - created package KSBMS_SCOREBOARD, implemented bridge level key tracking - used by various statement level and row level triggers on BRIDGE'
                        );
     END documentation;
BEGIN
     NULL;
END ksbms_scoreboard;
/