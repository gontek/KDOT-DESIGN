CREATE OR REPLACE TRIGGER pontis.TAUR_DS_RDWY_FUNCCLASS_UNDER
   after insert or update of FUNCCLASS on pontis.ROADWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: TAUR_DS_RDWY_FUNCCLASS_UNDER
-- After update trigger to pass essential parameters via ksbms_pontis_util.f_pass_update_trigger_params()
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:
--    2009.5.5 - Kossler, D. KDOT -- Added to the sync-up process -----------------------------------------------------------------------
--               these updates go the Cansys FTCR - UNDER-records only----------------------------------------------------------------------
 
 
  WHEN (nvl( new.funcclass, '<MISSING>' ) <>  nvl( old.funcclass, '<MISSING>' ) ) declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    if :new.on_under <> '1' then
    lb_result := ksbms_pontis.f_pass_update_trigger_params(
      nvl( :new.brkey,'<MISSING>' ) || ',' || nvl(null,'<MISSING>') || ',' || ksbms_pontis.f_route_prefix_or_on_under( null, :new.on_under ) || ',' || nvl( null, '<MISSING>' ) || ',' || nvl( null, '<MISSING>' ) || ',' || nvl( null, '<MISSING>' ),
      'BRIDGE_ID,FEAT_CROSS_TYPE,ROUTE_PREFIX,ROUTE_NUM,ROUTE_SUFFIX,ROUTE_UNIQUE_ID',
      'ROADWAY',
      'FUNCCLASS',
      :old.FUNCCLASS,
      :new.FUNCCLASS,
      3,
      nvl( ls_bridge_id, '<MISSING>' ),
      'TAUR_DS_RDWY_FUNCCLASS_UNDER');
   if lb_result
   then
      dbms_output.put_line( 'TAUR_DS_RDWY_FUNCCLASS_UNDER FAILED' );
   end if;
End if;   
end TAUR_DS_RDWY_FUNCCLASS_UNDER;
/