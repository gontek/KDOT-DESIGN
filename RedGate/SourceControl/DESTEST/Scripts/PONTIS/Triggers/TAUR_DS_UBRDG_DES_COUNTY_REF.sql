CREATE OR REPLACE TRIGGER pontis.TAUR_DS_UBRDG_DES_COUNTY_REF
   after insert or update of DESIGN_COUNTY_REF on pontis.USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: TAUR_DS_UBRDG_DES_COUNTY_REF
-- After update trigger to pass essential parameters via ksbms_pontis_util.f_pass_update_trigger_params()
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

--    2006-08-02  - Deb Kossler, KDOT -- Added to triggers to augment passing of design county reference post between
--                  Pontis and CansysII
-----------------------------------------------------------------------------------------------------------------------------------------


 
 WHEN (nvl( new.DESIGN_COUNTY_REF, -9 ) <>  nvl( old.DESIGN_COUNTY_REF, -9 ) ) declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params(
      nvl( :new.brkey, '<MISSING>' ),
      'BRIDGE_ID',
      'USERBRDG',
      'DESIGN_COUNTY_REF',
      TO_CHAR( :old.DESIGN_COUNTY_REF ),
      TO_CHAR( :new.DESIGN_COUNTY_REF ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_DESIGN_COUNTY_REF');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_DES_COUNTY_REF failed' );
	 end if;
end taur_ds_UBRDG_DES_COUNTY_REF;
/