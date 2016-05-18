CREATE OR REPLACE Trigger pontis.TAUR_DS_UBRDG_KDOT_LATITUDE
   after insert or update of KDOT_LATITUDE on pontis.USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_KDOT_LATITUDE
-- After update trigger to pass essential parameters via ksbms_pontis_util.f_pass_update_trigger_params()
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

-- 2003-08-25 KDOT-Design - created by KDOT to synch latitude between CANSYSII and Pontis.
----------------------------------------------------------------------------------------------------------------------------------------
  -- Updated by ARMarshall, ARM LLC 20150615 
  -- extend this to check for actually different values meeting or exceeding the tolerance percentage
  -- return immediately if not and store nothing in the change log.


 
 
 
when (nvl( new.KDOT_LATITUDE, -9 ) <>  nvl( old.KDOT_LATITUDE, -9 ) )
declare
  lb_result    boolean;
  ls_bridge_id bridge.bridge_id%type;
begin
/*
  -- new code
  IF Ksbms_Util.f_Numbers_Differ(Nvl(:Old.KDOT_LATITUDE, -9),
                                 Nvl(:New.KDOT_LATITUDE, -9),
                                 -- use the next function to load the tolerances from 
                                 -- the table Ds_Transfer_Delta_Tolerances
                                 Ksbms_Util.f_Get_Delta_Tolerance(Ptab => 'userbrdg',
                                                                  Pcol => 'kdot_latitude'),
                                 FALSE) = FALSE THEN
    RETURN; -- not a real change
  END IF;
  -- end change 
  */
  ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey(:new.brkey);
  lb_result    := ksbms_pontis.f_pass_update_trigger_params(nvl(:new.brkey,
                                                                '<MISSING>'),
                                                            'BRIDGE_ID',
                                                            'USERBRDG',
                                                            'KDOT_LATITUDE',
                                                            TO_CHAR(:old.KDOT_LATITUDE),
                                                            TO_CHAR(:new.KDOT_LATITUDE),
                                                            1,
                                                            nvl(ls_bridge_id,
                                                                '<MISSING>'),
                                                            'taur_ds_UBRDG_KDOT_LATITUDE');
  if lb_result then
    dbms_output.put_line('taur_ds_UBRDG_KDOT_LATITUDE failed');
  end if;
end taur_ds_UBRDG_KDOT_LATITUDE;
/