CREATE OR REPLACE TRIGGER pontis.TAUR_DS_ROADWAY_BYPASSLEN
   after insert or update of BYPASSLEN on pontis.ROADWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: TAUR_DS_ROADWAY_BYPASSLEN
-- After update trigger to pass essential parameters via ksbms_pontis_util.f_pass_update_trigger_params()
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:
--    2008.08.18 - Kossler, D, KDOT -- Added to sync-up project for exchange with CansysII
-----------------------------------------------------------------------------------------------------------------------------------------

  DISABLE WHEN (nvl( new.BYPASSLEN, -9 ) <>  nvl( old.BYPASSLEN, -9 )
 and new.ON_UNDER = '1') declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params(
      nvl( :new.brkey, '<MISSING>' ) ,
      'BRIDGE_ID',
      'ROADWAY',
      'BYPASSLEN',
      :old.BYPASSLEN,
      trunc( :new.BYPASSLEN,3),
      22,
      nvl( ls_bridge_id, '<MISSING>' ),
      'TAUR_DS_ROADWAY_BYPASSLEN');
   if lb_result
   then
      dbms_output.put_line( 'TAUR_DS_ROADWAY_BYPASSLEN failed' );
   end if;
end TAUR_DS_ROADWAY_BYPASSLEN;
/