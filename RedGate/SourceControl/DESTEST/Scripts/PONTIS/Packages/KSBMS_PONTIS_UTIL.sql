CREATE OR REPLACE PACKAGE pontis."KSBMS_PONTIS_UTIL"
is
   -- Author  : ARM
   -- Created : 2001-06-28 09:04:22
   -- Purpose : Pontis utilities (procedures and functions ) used by triggers and other Pontis schema objects

   -- Revision: 7/6/2001 - store old column value in change log record
   -- modifications to p_stamp_change_log and f_stamp_change_log
   -- stamped ROWID and CII_XREF_ID (str_id, str_top_id etc.) into datasync_matchkey_vals

  -- Public type declarations
/*  type <TypeName> is <Datatype>;*/
   type key_vals is varray (10) of varchar2 (32); -- no KEY in Pontis is more than 32 characters

   type key_name_array is varray (10) of sys.all_tab_columns.column_name%type;

   subtype exchange_type is varchar2 (3); -- HOYTFIX ds_change_log.exchange_type%TYPE;

   -- SUBTYPE exchange_type IS ksbms_robot.ds_change_log.exchange_type%TYPE;


  -- Public constant declarations
/*  <ConstantName> constant <Datatype> := <Value>;*/

  -- Public variable declarations
/*  <VariableName> <Datatype>;*/

    -- Public function and procedure declarations
   -- function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;

   gs_db_id_key         varchar2 (30); -- determined at time of load...
   gs_pontis_version    varchar2 (24);
   gs_last_inspkey      varchar2 (10);
   gs_default_userkey   users.userkey%type;
   gs_default_userid    users.userid%type;

   -- functions
   -- get_db_id_key - return the id of the database
   -- usage: select pontis_util.get_db_id_key from DUAL;

   function get_pontis_db_id_key
      return varchar2;

   -- get_pontis_Version - return the version of Pontis we are running
   -- usage: select pontis_util.get_Pontis_version from DUAL;
   function get_pontis_version
      return varchar2;

   -- get_pontis_inspkey -- generate a four character serial key for Pontis
   -- used as part of primary key for INSPEVNT, ELEMINSP.
   -- Must be unique for a particular bridge.
   -- Uniqueness here will be to convert each digit of a unique sequence into a positive letter
   -- This allows 9999 inspections per structure.
   -- when generated, a BRKEY is passed to test the value prior to insertion...

   function get_pontis_inspkey (the_brkey_in in varchar2)
      return varchar2;


   -- generate a unique 2 character on_under key for a roadway on a particular bridge excluding a fixed set of values expressed as a constant in the function
   function f_get_pontis_on_under(the_brkey_in in varchar2)
      return varchar2;

   -- get_pontis_rkey - generate a 30-char serial key for Pontis
   -- usage: select pontis_util.get_pontis_rkey from DUAL;
     -- generate a unique key for Pontis purposes consisting of dbstamp, date, and a sequence
     -- only robust across databases for version 4.0, where db_id_key is available.
   function get_pontis_rkey
      return sys.all_tab_columns.table_name%type;

   -- procedures
   -- sync_datadict - brute-force fixup of datadict run as needed after
   -- changes to agency tables.
   -- usage exec pontis_util.sync_datadict;

   procedure sync_datadict;

   -- Public function and procedure declarations
   -- function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;
   -- pass brkey, returns TRUE if the bridge exists in table BRIDGE
   -- BRKEY is never upperized
   -- RETURNS NULL if bad arguments
   -- RETURNS TRUE if found
   -- RETURNS FALSE if NOT found



   function get_nbicode_from_nbilookup (p_table_name in varchar2, p_field_name in varchar2, p_kdot_code in varchar2)
      return varchar2;

   -- Procedure that actually stamps the log, handles exceptions, etc...


-- no data change parms, just makes an entry in CHANGELOG for some TABLE LEVEL trigger event
   return               boolean; -- TRUE IF FAILED!


-- for any arbitrary table, return an array of keynames
   procedure p_get_primary_key_names (p_table_name in sys.all_tables.table_name%type, p_key_names out key_name_array);

   function f_parse_csv_into_array (the_list_in in varchar2)
      return key_vals;

   function f_get_entry_id
      return varchar2;

   function recode_designload (

-- Allen 5/17/2001
--pDesignLoad_Type, pDesignLoad_KDOT ON USERBRDG
-- CHANGE USERBRDG table NAME IF NECESSARY
-- Anchored by %TYPE
-- Added exception handling, messages to explain problemn
-- returns null if it fails - test for null in calling trigger

-- arguments
      pdesignload_type   in   userbrdg.designload_type%type,
      pdesignload_kdot   in   userbrdg.designload_kdot%type,
      pnullallowed       in   boolean
   )
      return number;

   procedure trig_test;

   -- Pass in a BRKEY and get back the corresponding Bridge ID
   -- Allen Marshall, CS - 2003.01.03 - DO NOT USE
   function f_get_bridge_id_from_brkey (p_brkey in bridge.brkey%type)
      return bridge.bridge_id%TYPE;-- Allen  Marshall, CS- 2003.01.04 - anchored type

   function f_get_bridge_id_from_brkey_bad (p_brkey in bridge.brkey%type)
      return BRIDGE.BRIDGE_ID%TYPE; -- Allen  Marshall, CS- 2003.01.04 - anchored type

   -- Pass in a Bridge ID and get back the corresponding BRKEY
   function f_get_brkey_from_bridge_id (p_bridge_id in bridge.bridge_id%type)
      return varchar2;

   -- Returns 1900-01-01 00:00:00 as a string
   function f_return_missing_date_string
      return varchar2;

   -- Hoyt 1/8/2002: This version uses pontis.coptions instead of ds_config_options;
   -- It also gets the default value, if the option value is null (probably needless).
   function f_get_pontis_coption_value (opt_name IN coptions.optionname%type)
      return coptions.optionval%type;


  -- Given a brkey, determines if the bridge exists in the database and returns TRUE if so.
   function f_get_users_userkey
      return VARCHAR2;

   procedure p_init_package;

     function f_bridge_exists (the_brkey_in in bridge.brkey%type)

    return boolean;

    function f_get_pontis_datadict_value (
      psi_table_name   in   pontis.datadict.table_name%type,
      psi_col_name     in   pontis.datadict.col_name%type
   )
      return pontis.datadict.sysdefault%type;
   -- Given a brkey, column name, and value, updates BRIDGE to set the column to the value
   function f_set_bridge_value (psi_brkey in bridge.brkey%type, psi_column_name in varchar2, psi_column_value in varchar2)
      return boolean;
      
 -- Given a brkey, column name, and value, updates USERBRDG to set the column to the value
   function f_set_userbrdg_value (psi_brkey in bridge.brkey%type, psi_column_name in varchar2, psi_column_value in varchar2)
      return boolean; 
         
 function f_userbrdg_exists (psi_brkey in bridge.brkey%type)
   return boolean;     


   function f_set_inspevnt_value (
      psi_brkey          in   bridge.brkey%type,
      psi_inspkey        in   inspevnt.inspkey%type,
      psi_column_name    in   varchar2,
      psi_column_value   in   varchar2
   )
      return boolean;

   --  pass brkey and inspkey, returns TRUE if the bridge + inspkey combination exists in table INSPEVNT
   -- BRKEY is never upperized
   -- INSPKEY is always UPPERIZED
   -- RETURNS NULL if bad arguments
   -- RETURNS TRUE if found
   -- RETURNS FALSE if NOT found

   function f_inspection_exists (the_brkey_in in bridge.brkey%type, the_inspkey_in in inspevnt.inspkey%type)
      return boolean;



   function f_set_roadway_value (
      psi_brkey          in   bridge.brkey%type,
      psi_on_under       in   roadway.on_under%type,
      psi_column_name    in   varchar2,
      psi_column_value   in   varchar2
   )
      return boolean;

   function f_roadway_exists (psi_brkey in bridge.brkey%type, psi_on_under in roadway.on_under%type)
      return boolean;

function f_set_userrway_value (
      psi_brkey          in   userrway.brkey%type,
      psi_on_under       in   userrway.on_under%type,
      psi_column_name    in   varchar2,
      psi_column_value   in   varchar2
   )
      return boolean;

   function f_userrway_exists (psi_brkey in userrway.brkey%type, psi_on_under in userrway.on_under%type)
      return boolean;

   function f_set_structure_unit_value (
      psi_brkey          in   bridge.brkey%type,
      psi_strunitkey     in   structure_unit.strunitkey%type,
      psi_column_name    in   varchar2,
      psi_column_value   in   varchar2
   )
      return BOOLEAN;

  function f_structure_unit_exists (psi_brkey in bridge.brkey%type, psi_strunitkey in structure_unit.strunitkey%type)
      return BOOLEAN;

  PROCEDURE p_set_inspectiondates_missing(psi_brkey in bridge.brkey%type);

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

 PROCEDURE documentation; -- ARM , CS 12/17/2002
end ksbms_pontis_util;

 
/