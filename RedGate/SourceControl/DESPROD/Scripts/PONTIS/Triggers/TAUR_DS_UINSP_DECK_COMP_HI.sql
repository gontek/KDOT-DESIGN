CREATE OR REPLACE TRIGGER pontis.TAUR_DS_UINSP_DECK_COMP_HI
  after insert or update on pontis.userinsp  
  for each row
-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UINSP_DECK_COMP_HI
-- After update trigger to pass essential parameters via ksbms_pontis_util.f_pass_update_trigger_params()
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

-- Created 2002-10-30 to transfer deck health index to CANSYSII
-----------------------------------------------------------------------------------------------------------------------------------------

 
  WHEN (nvl( new.DECK_COMP_HI, -9 ) <>  nvl( old.DECK_COMP_HI, -9 ) ) declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    
 if (substr(ls_bridge_id,6,1)='B') then -- only bridges, not 500 culverts at this time dk
    lb_result := ksbms_pontis.f_pass_update_trigger_params(
      nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.inspkey, '<MISSING>' ),
      'BRIDGE_ID,INSPKEY',
      'USERINSP',
      'DECK_COMP_HI',
      TO_CHAR( :old.DECK_COMP_HI ),
      TO_CHAR( :new.DECK_COMP_HI ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UINSP_DECK_COMP_HI');
end if;
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UINSP_DECK_COMP_HI failed' );
	 end if;

end TAUR_DS_UINSP_DECK_COMP_HI;
/