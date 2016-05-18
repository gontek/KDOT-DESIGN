CREATE OR REPLACE TRIGGER pontis.TAUR_DS_UBRDG_DESIGN_METHOD
   after insert or update of DESIGN_METHOD on pontis.USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_DESIGN_METHOD
-- After update trigger to pass essential parameters via ksbms_pontis_util.f_pass_update_trigger_params()
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- CREATED BY dlk 2006-08-25 for the Kansas DOT Pontis Implementation (Data Synchronization)
----------------------------------------------------------------------------------------------------------------------------------------

 
 WHEN (nvl( new.DESIGN_METHOD, -9 ) <>  nvl( old.DESIGN_METHOD, -9 ) ) declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params(
      nvl( :new.brkey, '<MISSING>' ),
      'BRIDGE_ID',
      'USERBRDG',
      'DESIGN_METHOD',
      TO_CHAR( :old.DESIGN_METHOD ),
      TO_CHAR( :new.DESIGN_METHOD ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_DESIGN_METHOD');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_DESIGN_METHOD failed' );
	 end if;
end TAUR_DS_UBRDG_DESIGN_METHOD;
/