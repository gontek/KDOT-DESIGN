CREATE OR REPLACE TRIGGER pontis.taur_ds_UBRDG_ENV_NOTATION_1
   after insert or update of ENV_NOTATION_1 on pontis.USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_ENV_NOTATION_1
-- After update trigger to pass essential parameters via ksbms_pontis_util.f_pass_update_trigger_params()
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:
-- 2002.01.10  - Hoyt Nelson, CS -- Initial adaptation from the generated update triggers
-- 2002.07.23  - Deb Kossler, KDOT -- trigger added because it was not created in original CS package
-----------------------------------------------------------------------------------------------------------------------------------------
  
 WHEN (nvl( new.ENV_NOTATION_1, '<MISSING>' ) <>  nvl( old.ENV_NOTATION_1, '<MISSING>' ) ) declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params(
      nvl( :new.brkey, '<MISSING>' ),
      'BRIDGE_ID',
      'USERBRDG',
      'ENV_NOTATION_1',
      :old.ENV_NOTATION_1,
      :new.ENV_NOTATION_1,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_ENV_NOTATION_1');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_ENV_NOTATION_1 failed' );
	 end if;
end taur_ds_UBRDG_ENV_NOTATION_1;
/