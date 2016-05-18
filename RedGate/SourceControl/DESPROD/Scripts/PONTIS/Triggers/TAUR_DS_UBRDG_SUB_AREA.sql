CREATE OR REPLACE TRIGGER pontis.taur_ds_UBRDG_SUB_AREA
   after insert or update of SUB_AREA on pontis.USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_SUB_AREA
-- After update trigger to pass essential parameters via ksbms_pontis_util.f_pass_update_trigger_params()
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

---    2006.01.13  - Deb, KDOT -- Added to Pontis synch project to pass sub area back & forth from CansysII

-----------------------------------------------------------------------------------------------------------------------------------------


 
 WHEN (nvl( new.SUB_AREA, '<MISSING>' ) <>  nvl( old.SUB_AREA, '<MISSING>' ) ) declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params(
      nvl( :new.brkey, '<MISSING>' ),
      'BRIDGE_ID',
      'USERBRDG',
      'SUB_AREA',
      :old.SUB_AREA,
      :new.SUB_AREA,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_SUB_AREA');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_SUB_AREA failed' );
	 end if;
end taur_ds_UBRDG_SUB_AREA;
/