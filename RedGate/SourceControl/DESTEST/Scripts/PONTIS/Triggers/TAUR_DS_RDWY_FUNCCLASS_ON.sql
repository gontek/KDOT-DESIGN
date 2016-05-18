CREATE OR REPLACE TRIGGER pontis.TAUR_DS_RDWY_FUNCCLASS_ON
   after insert or update of FUNCCLASS on pontis.ROADWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: TAUR_DS_RDWY_FUNCCLASS_ON
-- After update trigger to pass essential parameters via ksbms_pontis_util.f_pass_update_trigger_params()
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:
--    2009.5.5 - Kossler, D. KDOT -- Added to the sync-up process -----------------------------------------------------------------------
--               these updates go the Cansys FUNC - on-records only----------------------------------------------------------------------
 
 
  DISABLE WHEN (nvl( new.funcclass, '<MISSING>' ) <>  nvl( old.funcclass, '<MISSING>' )and NEW.ON_UNDER = '1' ) declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params(
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( null, :new.on_under ) || ',' || nvl( null, '<MISSING>' ) || ',' || nvl( null, '<MISSING>' ) || ',' || nvl( null, '<MISSING>' ),
      'BRIDGE_ID,ROUTE_PREFIX,ROUTE_NUM,ROUTE_SUFFIX,ROUTE_UNIQUE_ID',
      'ROADWAY',
      'FUNCCLASS',
      :old.FUNCCLASS,
      :new.FUNCCLASS,
      4,
      nvl( ls_bridge_id, '<MISSING>' ),
      'TAUR_DS_RDWY_FUNCCLASS_ON');
   if lb_result
   then
      dbms_output.put_line( 'TAUR_DS_RDWY_FUNCCLASS_ON failed' );
   end if;
end TAUR_DS_RDWY_FUNCCLASS_ON;
/