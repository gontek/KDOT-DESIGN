CREATE OR REPLACE PACKAGE ksbms_robot."KSBMS_DATA_SYNC"
is
   -- Author  : ARM
   -- Created : 2002-01-04
   -- Purpose : Skeleton for collecting changes, evaluating, brokering and propagating changes between
   -- PONTIS 4.0 db and CANSYS

   -- Public type declarations
   --type <TypeName> is <Datatype>;
   subtype a_sqlstring is varchar2 (2048);

   -- f_parse_csv_into_array() returns key_vals
   type key_vals is varray (20) of varchar2 (32); -- no KEY in Pontis is more than 32 characters

   -- Public constant declarations
   -- <ConstantName> constant <Datatype> := <Value>;

   -- Public variable declarations
   gl_job_id   ds_jobruns_history.ora_dbms_job_id%type   := -1; -- This should be set by Oracle job scheduler

   -- Public function and procedure declarations
   -- function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;


-- This takes '0001-B0008' and returns '001008',
-- which is the apparent algorithm that KDOT uses to go between
-- bridge_id (the first string) and brkey and struct_num (the
-- second string -- brkey and struct_num are everywhere the same
-- in the KDOT database).
   function f_bridge_id_to_brkey (p_bridge_id in varchar2)
      return varchar2;

   function f_fix_bogus_strunitkeys
      return boolean;

   function f_remove_old_inspdate_records
      return boolean;

   function f_fill_in_userrway_keys
      return boolean;

   function f_merge_database_changes (
      psi_job_id            in   ds_jobruns_history.job_id%type,
      pli_ora_dbms_job_id   in   ds_jobruns_history.ora_dbms_job_id%type,
      psio_email_msg        in   ksbms_util.gs_email_msg%TYPE
   )
      return boolean;

   function f_move_change_lookup_records (
      psi_exchange_status           in       ds_change_log.exchange_status%type,
      psi_job_id                    in       ds_jobruns_history.job_id%type,
      pio_moved_into_pontis_count   out      pls_integer,
      pio_moved_into_cansys_count   out      pls_integer
   )
      return boolean;

   function f_munge_on_highways_tables (
      psi_exchange_status        in       ds_change_log.exchange_status%type,
      pso_into_log_c_count       out      pls_integer,
      pso_into_keyvals_c_count   out      pls_integer
   )
      return boolean;

   function f_move_merge_ready_records (
      pio_inserted_into_pontis_count   out   pls_integer,
      pio_inserted_into_cansys_count   out   pls_integer
   )
      return boolean;

   function f_move_merge_ready_to_pontis (pio_inserted_into_pontis_count out pls_integer)
      return boolean;

   function f_move_merge_ready_to_cansys (pio_inserted_into_cansys_count out pls_integer)
      return boolean;

   function f_replace_deleted_inspevnt
      return boolean;

   function f_update_change_log_c (pbi_no_cansys_data_to_merge in boolean, pio_num_cansys_change_log_recs out pls_integer)
      return boolean;

   function f_set_exchange_status (
      psi_entry_id   in   ds_change_log.entry_id%type,
      psi_status     in   ds_change_log.exchange_status%type,
      psi_remark     in   ds_change_log.remarks%type
   )
      return boolean;

   procedure ds_sync_exec (pli_ora_dbms_job_id in ds_jobruns_history.ora_dbms_job_id%type);

   procedure ds_sync_exec;
   PROCEDURE documentation;

end ksbms_data_sync;

 
/