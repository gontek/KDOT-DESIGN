CREATE OR REPLACE PACKAGE pontis."KSBMS_PONTIS" is
  -- Author  : ADMINISTRATOR
  -- Created : 11/30/2001 11:02:19 AM
  -- Purpose : Contains the code needed on the Pontis side for KDOT synchronization

  -- Public type declarations

  -- f_parse_csv_into_array() returns key_vals
  type key_vals is varray(20) of varchar2(32); -- no KEY in Pontis is more than 32 characters

  -- ARM 1/18/2002 upped to 20 key values storable

  -- Author  : Hoyt
  -- Created : 1/18/2002 10:50:56 AM
  -- Purpose : Contains the mininum set of ksbms_pontis_util needed to compile the TUA triggers

  gs_db_id_key       varchar2(30); -- determined at time of load...
  gs_pontis_version  varchar2(24);
  gs_last_inspkey    varchar2(10);
  gs_default_userkey users.userkey%type;
  gs_default_userid  users.userid%type;

  /*
   Allen, CS 11/5/2002 - Suppress MISSING values
  
   from Pontis  C++ code #define
   THESE ARE THE CONVENTIONAL MISSING VALUE INDICATORS USED BY PONTIS, SOMEWHAT ADAPTED
   FROM SAS SYSTEM CONVENTIONS
   MISS_VAL_ENTRY MissValTable [msvTotal] =
  
  { //              CHAR  CHAR(1) NUM NUMSHORT  DATE
  
    { "Unknown",        "-1", "_",  -1,  -1, { 1, 1, 1901 }, { 0, 0, 0 } },
    { "Not Applicable",     "-2", "!",  -2,  -2, { 2, 2, 1902 }, { 0, 0, 0 } },
    { "Input Too High",   "-3", ">",  -3,  -3, { 3, 3, 1903 }, { 0, 0, 0 } },
    { "Input Too Low",    "-4", "<",  -4,  -4, { 4, 4, 1904 }, { 0, 0, 0 } },
    { "Input Bad Format", "-5", "@",  -5,  -5, { 5, 5, 1905 }, { 0, 0, 0 } },
    { "Input Illegal",  "-6", "#",  -6,  -6, { 6, 6, 1906 }, { 0, 0, 0 } },
    { "Input Bad Length", "-7", "&",  -7,  -7, { 7, 7, 1907 }, { 0, 0, 0 } },
    { "Division By Zero", "-8", "/",  -8,  -8, { 8, 8, 1908 }, { 0, 0, 0 } },
    { "Other Math Error", "-9", "~",  -9,  -9, { 9, 9, 1909 }, { 0, 0, 0 } },
    { "Aggregation Error",  "-9",  "+", -10, -9, { 9, 9, 1909 }, { 0, 0, 0 } },
    { "Calc. Result High",  "-9", "}",  -11, -9, { 9, 9, 1909 }, { 0, 0, 0 } },
    { "Calc. Result Low", "-9",  "{", -12, -9, { 9, 9, 1909 }, { 0, 0, 0 } },
    { "Calc. Based On Miss","-9", "?",  -13, -9, { 9, 9, 1909 }, { 0, 0, 0 } }
  };
  
   */
  -- GENERAL RULE : DO NOT PROPAGATE THESE CHANGES TO CANSYS-II IF OLD VALUE WAS NULL AND NEW VALUE IS IN THE MISSING SET
  gs_pontis_missing_values VARCHAR2(80) := '|!|_|>|<|#|&|/|~|+|}|{|?|@|-1|-2|-3|-4|-5|-6|-7|-8|-9|-10|-11|-12|-13|';

  gb_suppress_pontis_missing BOOLEAN := TRUE; -- DO NOT PROPAGATE THESE EVER IF TRUE, EVEN DURING EDITING AFTER INITIALIZATION OF A RECORD

  gb_suppress_false_updates BOOLEAN := TRUE; -- tested in triggers to see if phony updates ( set A = A) should be propagated/transmitted to the change log
  --e.g. when ( nvl( new.DECKGEOM, '<MISSING>' ) <>  nvl( old.DECKGEOM, '<MISSING>' ) ) AND  gb_suppress_false_updates
  -- so if FALSE, phony updates go - do this to recover old values for INSPEVNT for example - see trigger taidb_inspevnt_recover

  -- see boolean function f_is_pontis_missing_value that tests for these in f_pass_update_trigger_params

  FUNCTION f_is_pontis_missing_value(pThe_Teststring IN VARCHAR2)
  -- Allen 11/5/2002 return T if the passed parm is in the missing value set.
   RETURN BOOLEAN;

  function f_get_userkey_for_orauser(the_user in varchar2)
  -- Allen 7/27/2001
   return users.userkey%type;

  function get_nbicode_from_nbilookup(p_table_name in varchar2,
                                      p_field_name in varchar2,
                                      p_kdot_code  in varchar2)
    return nbilookup.nbi_code%type; --ARM 3/7/2002 fixed to use anchored type

  -- Public function and procedure declarations
  function f_triggered_by_apply_changes return boolean;

  function f_boolean_to_string(p_boolean in boolean) return varchar2;

  function f_get_bridge_id_from_brkey(p_brkey in bridge.brkey%type)
    return bridge.bridge_id%TYPE;

  function f_get_entry_id return varchar2;

  function f_get_entry_sequence_num return ds_change_log.sequence_num%TYPE;

  function f_is_merge_underway return boolean;

  function f_parse_csv_into_array(the_list_in in varchar2) return key_vals;

  function f_get_username return varchar2;

  function f_pass_update_trigger_params(p_keys                in varchar2,
                                        p_key_names           in varchar2,
                                        p_table_name          in ksbms_robot.ds_transfer_map.table_name%type,
                                        p_column_name         in ksbms_robot.ds_transfer_map.column_name%type,
                                        p_old_value           in varchar2,
                                        p_new_value           in varchar2,
                                        p_transfer_map_key_id in ksbms_robot.ds_transfer_map.transfer_key_map_id%type,
                                        p_bridge_id           in bridge.bridge_id%type,
                                        p_invoking_trigger    in varchar2)
    return boolean;

  procedure p_clean_up_after_raise_error(psi_context in ksbms_util.context_string_type);

  -- This takes '001008' and returns'0001-B0008',
  function f_kdot_brkey_to_bridge_id(p_brkey in varchar2) return varchar2;

  function f_kdot_bridge_id_to_brkey(p_bridge_id in varchar2)
  -- This takes '0001-B0008' and returns '001008',
    -- which is the apparent algorithm that KDOT uses to go between
    -- bridge_id (the first string) and brkey and struct_num (the
    -- second string -- brkey and struct_num are everywhere the same
    -- in the KDOT database).
   return VARCHAR2;

  function f_strunitlabel_or_strunitkey(psi_strunitlabel in structure_unit.strunitlabel%type,
                                        pdi_strunitkey   in structure_unit.strunitkey%type)
    return varchar2;

  function f_is_latest_inspdate(psi_brkey   in bridge.brkey%type,
                                psi_inspkey in inspevnt.inspkey%type)
    return boolean;

  /* Allen Marshall, CS - 2003-01-04 - returns string ON_UNDER = x  if route_prefix is null or missing
  this string goes in the ds_lookup_keyvals */
  function f_route_prefix_or_on_under(psi_route_prefix in userrway.route_prefix%type,
                                      psi_on_under     in userrway.on_under%type)
    return varchar2;

  /* Allen Marshall, CS - 2003-01-04 - FUNCTION f_clr_route()
   returns string 'ON_UNDER = x'  if clr_route is null or missing
  this string goes in the ds_lookup_keyvals
  Added to compensate for the overloading of f_route_prefix_or_on_under in USERRWAY triggers
  where clr-route is passed, not route_prefix
  */
  FUNCTION f_clr_route(psi_clr_route IN userrway.clr_route%TYPE,
                       psi_on_under  IN userrway.on_under%TYPE)
    RETURN VARCHAR2;

  procedure p_turn_off_exchange;

  procedure p_turn_on_exchange;

  PROCEDURE p_suppress_false_updates;
  PROCEDURE p_permit_false_updates;

  PROCEDURE p_false_upd_all_tbl_cols(psi_table_name   IN user_tab_columns.table_name%TYPE,
                                     psi_where_clause in VARCHAR2,
                                     pbi_null_out     IN BOOLEAN := FALSE);

  procedure documentation;

  procedure p_delete_triggers(the_trigger_mask in varchar,
                              the_schema       in sys.all_tables.owner%type);
end ksbms_pontis;
/