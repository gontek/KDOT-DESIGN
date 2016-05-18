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
  -- Generated 2002-02-26 at 09:26
  -- Updated by ARMarshall, ARM LLC 20150615 
  -- extend this to check for actually different values meeting or exceeding the tolerance percentage
  -- return immediately if not and store nothing in the change log.

 
 WHEN (nvl( new.BYPASSLEN, -9 ) <>  nvl( old.BYPASSLEN, -9 )
 and new.ON_UNDER = '1') declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
   -- new code
  IF Ksbms_Util.f_Numbers_Differ(Nvl(:Old.bypasslen, -9),
                                 nvl(:New.bypasslen, -9),
                                 -- use the next function to load the tolerances from 
                                 -- the table Ds_Transfer_Delta_Tolerances
                                 Ksbms_Util.f_Get_Delta_Tolerance(Ptab => 'roadway',
                                                                  Pcol => 'bypasslen'),
                                 FALSE) = FALSE THEN
    RETURN; -- not a real change
  END IF;
  -- end change
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