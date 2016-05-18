CREATE OR REPLACE TRIGGER pontis.TAUR_DS_URWAY_TOTLANES
   after insert or update of TOTLANES on pontis.USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: TAUR_DS_URWAY_TOTLANES
-- After update trigger to pass essential parameters via ksbms_pontis_util.f_pass_update_trigger_params()
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

--    2008.02.12 - Kossler, D. KDOT -- Added lanes to the sync process 
-----------------------------------------------------------------------------------------------------------------------------------------


  WHEN (substr( nvl(new.brkey, -9),4,1) in ('0','1','2','3','4','5','6','7','8','9') and
nvl( new.TOTLANES, '-9' ) <>  nvl( old.TOTLANES, '-9' ) and
new.TOTLANES != 0 ) declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    if :new.on_under <> '1' then
      lb_result := ksbms_pontis.f_pass_update_trigger_params(
        nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.feat_cross_type, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.route_prefix, :new.on_under ) || ',' || nvl( :new.route_num, '<MISSING>' ) || ',' || nvl( :new.route_suffix, '<MISSING>' ) || ',' || nvl( :new.route_unique_id, '<MISSING>' ),
        'BRIDGE_ID,FEAT_CROSS_TYPE,ROUTE_PREFIX,ROUTE_NUM,ROUTE_SUFFIX,ROUTE_UNIQUE_ID',
        'USERRWAY',
        'TOTLANES',
        :old.TOTLANES,
        :new.TOTLANES,
        3,
        nvl( ls_bridge_id, '<MISSING>' ),
        'TAUR_DS_URWAY_TOTLANES');
    else
      lb_result := ksbms_pontis.f_pass_update_trigger_params(
        nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.route_prefix, :new.on_under ) || ',' || nvl( :new.route_num, '<MISSING>' ) || ',' || nvl( :new.route_suffix, '<MISSING>' ) || ',' || nvl( :new.route_unique_id, '<MISSING>' ),
        'BRIDGE_ID,ROUTE_PREFIX,ROUTE_NUM,ROUTE_SUFFIX,ROUTE_UNIQUE_ID',
        'USERRWAY',
        'TOTLANES',
        :old.TOTLANES,
        :new.TOTLANES,
        4,
        nvl( ls_bridge_id, '<MISSING>' ),
        'TAUR_DS_URWAY_TOTLANES');
    end if;
   if lb_result
   then
      dbms_output.put_line( 'TAUR_DS_URWAY_TOTLANES failed' );
   end if;
end TAUR_DS_URWAY_TOTLANES;
/