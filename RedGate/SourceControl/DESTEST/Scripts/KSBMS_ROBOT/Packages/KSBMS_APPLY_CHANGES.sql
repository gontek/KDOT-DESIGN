CREATE OR REPLACE PACKAGE ksbms_robot."KSBMS_APPLY_CHANGES"
    is
  -- Author  : Hoyt Nelson
  -- Created : 1/5/2002 5:45:41 PM
  -- Purpose : Start a new function in a new package from this template

  -- Standard wrapped functions and procedures (for ease of typing)
  function f_commit_or_rollback(pbi_failed  boolean,
                                psi_context in ksbms_util.context_string_type)
    return boolean;

  procedure p_add_msg(psi_msg in varchar2);

  procedure p_bug(psi_msg in varchar2);

  procedure p_sql_error(psi_msg in varchar2);

  procedure p_sql_error2(psi_msg in varchar2);

  procedure pl(psi_msg in varchar2);

  procedure p_log(psi_msg in ds_message_log.msg_body%type);

  procedure p_log(psi_job_id in ds_message_log.job_id%type,
                  psi_msg    in ds_message_log.msg_body%type);

  -- This takes '0001-B0008' and returns '001008'
  function f_kdot_bridge_id_to_brkey(p_bridge_id in varchar2) return varchar2;

  -- This takes '001008' and returns '0001-B0008'
  function f_kdot_brkey_to_bridge_id(p_brkey in varchar2) return varchar2;

  function f_update_pontis(psi_job_id          in ds_jobruns_history.job_id%type,
                           pli_ora_dbms_job_id in ds_jobruns_history.ora_dbms_job_id%type,
                           psio_email_msg      in ksbms_util.gs_email_msg%type) return boolean;

  function f_set_new_structure_data(psi_brkey in bridge.brkey%type)
    return boolean;

  -- Array type
  type key_vals is varray(10) of varchar2(32); -- no KEY in Pontis is more than 32 characters

  -- Move to ksbms_pontis_util_tmp spec
  function f_add_bridge(psi_brkey     in bridge.brkey%type,
                        psi_bridge_id in bridge.bridge_id%type)
    return boolean;

  -- Move to ksbms_pontis_util_tmp spec
  function f_add_inspevnt(psi_brkey    in bridge.brkey%type,
                          psi_inspdate in inspevnt.inspdate%type,
                          pso_inspkey  out inspevnt.inspkey%type)
    return boolean;

  function f_add_roadway(psi_brkey     in bridge.brkey%type,
                         psio_on_under in out roadway.on_under%type)
    return boolean;

  function f_add_structure_unit(psi_brkey      in bridge.brkey%type,
                                pso_strunitkey IN out structure_unit.strunitkey%type)
    return boolean;

  function f_delete_pontis_records(pio_entry_id       in ds_change_log.entry_id%type,
                                   pio_number_deleted in out pls_integer)
    return boolean;

  function f_insert_pontis_records(pio_entry_id        in ds_change_log.entry_id%type,
                                   pio_number_inserted in out pls_integer)
    return boolean;

  function f_update_pontis_records(pio_entry_id               in ds_change_log.entry_id%type,
                                   pio_number_updated         in out pls_integer,
                                   pio_number_inserted        in out pls_integer,
                                   pio_number_failed          in out pls_integer,
                                   pio_number_inserted_failed in out pls_integer,
                                   pio_where_count            in out pls_integer)
    return boolean;

  function f_delete_from_log_and_keyvals(psi_entry_id in ds_change_log.entry_id%type)
    return boolean;

  function f_mark_log_keyvals_for_delete(pls_entry_id ds_change_log.entry_id%type)
    return boolean;

  function f_build_where_clause(psi_entry_id            in ds_change_log.entry_id%type,
                                psi_target_table        in ds_transfer_map.table_name%type,
                                pso_pontis_where        out varchar2,
                                pso_user_where          out varchar2,
                                pso_pontis_insert       out varchar2,
                                pso_user_insert         out varchar2,
                                pso_pontis_target_table out varchar2,
                                pso_user_target_table   out varchar2,
                                pso_brkey               out bridge.brkey%type,
                                pso_second_key          out varchar2,
                                pso_third_key           out varchar2)
    return boolean;

  function f_feat_cross_type_to_on_under(psi_brkey           in bridge.brkey%type,
                                         psi_feat_cross_type in userrway.feat_cross_type%type,
                                         psi_user_where      in varchar2,
                                         pso_on_under        out roadway.on_under%type)
    return boolean;

  function f_add_record(psi_entry_id in ds_change_log.entry_id%type)
    return boolean;

  function f_set_new_inspevnt_data(psi_brkey   in inspevnt.brkey%type,
                                   psi_inspkey in inspevnt.inspkey%type -- psi_inspdate   in   inspevnt.inspdate%type
                                   ) return boolean;

  function f_set_new_roadway_data(psi_brkey    in roadway.brkey%type,
                                  psi_on_under in roadway.on_under%type)
    return boolean;

  function f_set_new_userrway_data(psi_brkey     in userrway.brkey%type,
                                   psi_on_under  in userrway.on_under%type,
                                   psi_clr_route IN userrway.clr_route%TYPE)
    return boolean;

  function f_set_new_structure_unit_data(psi_brkey      in structure_unit.brkey%type,
                                         psi_strunitkey in structure_unit.strunitkey%type)
    return boolean;
    
  FUNCTION f_set_new_userbrdg_data(psi_brkey     IN userbrdg.brkey%TYPE)
    return boolean;  
    

  function f_brkey_and_id_from_entry_id(psi_entry_id  in ds_change_log.entry_id%type,
                                        pso_brkey     out bridge.brkey%type,
                                        pso_bridge_id out bridge.bridge_id%type)
    return boolean;

  function f_column_appears_on_table(psi_table_name  in sys.all_tab_columns.table_name%type,
                                     psi_column_name in sys.all_tab_columns.column_name%type)
    return boolean;

  function f_get_the_associated_table(psi_first_table in varchar2)
    return varchar2;

  function f_archive_cansys_applied return boolean;

  function f_move_applied_from_archive return boolean;

  FUNCTION f_uninitialized_keymatch_cols(ls_pontis_target_table IN user_tab_columns.table_name%TYPE, -- the table
                                         ls_brkey               IN BRIDGE.BRKEY%TYPE, -- the bridge
                                         ls_second_key          IN VARCHAR2, -- on_under or STRUNITKEY
                                         ls_third_key           VARCHAR2) -- INSPKEY
   RETURN BOOLEAN;

  FUNCTION f_evaluate_clr_route(the_clr_route IN VARCHAR2) RETURN BOOLEAN;

  PROCEDURE documentation; -- Added by ARM, CS - 2002.12.16
end ksbms_apply_changes;

 
/