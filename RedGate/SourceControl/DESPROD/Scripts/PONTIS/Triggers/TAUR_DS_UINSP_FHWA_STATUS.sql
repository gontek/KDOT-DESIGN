CREATE OR REPLACE TRIGGER pontis.TAUR_DS_UINSP_FHWA_STATUS
  after insert or update of FHWA_STATUS on pontis.userinsp  
  for each row
-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: TAUR_DS_UINSP_FHWA_STATUS
-- After update trigger to pass essential parameters via ksbms_pontis_util.f_pass_update_trigger_params()
-----------------------------------------------------------------------------------------------------------------------------------------

-- Revision History:

-- Created 2011-07-26 to transfer federal eligibility status updates created from R&R list
-- from Pontis to CANSYSII ------------------------------------------------------------------------------------

 
  WHEN (nvl( new.fhwa_status, '_' ) <>  nvl( old.fhwa_status, '_' )) declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;

begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    
if (substr(ls_bridge_id,6,1)='B') then
    lb_result := ksbms_pontis.f_pass_update_trigger_params(
      nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.inspkey, '<MISSING>' ),
      'BRIDGE_ID,INSPKEY',
      'USERINSP',
      'FHWA_STATUS',
     TO_CHAR(:old.FHWA_STATUS),
      TO_CHAR( :new.FHWA_STATUS),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'TAUR_DS_UINSP_FHWA_STATUS');
  end if;
   if lb_result
   then
      dbms_output.put_line( 'TAUR_DS_UINSP_FHWA_STATUS FAILED' );
   end if;

end TAUR_DS_UINSP_FHWA_STATUS;
/