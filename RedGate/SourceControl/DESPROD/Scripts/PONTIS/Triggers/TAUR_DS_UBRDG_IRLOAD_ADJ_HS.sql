CREATE OR REPLACE Trigger pontis.TAUR_DS_UBRDG_IRLOAD_ADJ_HS
   after insert or update of IRLOAD_ADJ_HS on pontis.USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: TAUR_DS_UBRDG_IRLOAD_ADJ_HS
-- After update trigger to pass essential parameters via ksbms_pontis_util.f_pass_update_trigger_params()
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:
-- 2009-3-17 Trigger used to be for bridge.irload.
-----------------------------------------------------------------------------------------------------------------------------------------


 
 
when ( nvl( new.IRLOAD_ADJ_HS, -9 ) <>  nvl( old.IRLOAD_ADJ_HS, -9 ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
  -- new code
  IF Ksbms_Util.f_Numbers_Differ(Nvl(:Old.IRLOAD_ADJ_HS, -9),
                                 Nvl(:New.IRLOAD_ADJ_HS, -9),
                                 -- use the next function to load the tolerances from 
                                 -- the table Ds_Transfer_Delta_Tolerances
                                 Ksbms_Util.f_Get_Delta_Tolerance(Ptab => 'userbrdg',
                                                                  Pcol => 'irload_adj_hs'),
                                 FALSE) = FALSE THEN
    RETURN; -- not a real change
  END IF;
  -- end change 

    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params(
      nvl( :new.brkey, '<MISSING>' ),
      'BRIDGE_ID',
      'USERBRDG',
      'IRLOAD_ADJ_HS',
      TO_CHAR( :old.IRLOAD_ADJ_HS ),
      TO_CHAR( :new.IRLOAD_ADJ_HS ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'TAUR_DS_UBRDG_IRLOAD_ADJ_HS');
   if lb_result
   then
      dbms_output.put_line( 'TAUR_DS_UBRDG_IRLOAD_ADJ_HS failed' );
   end if;
end TAUR_DS_UBRDG_IRLOAD_ADJ_HS;
/