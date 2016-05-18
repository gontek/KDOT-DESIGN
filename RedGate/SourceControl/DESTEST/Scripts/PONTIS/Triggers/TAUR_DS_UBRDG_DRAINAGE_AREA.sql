CREATE OR REPLACE Trigger pontis.taur_ds_UBRDG_DRAINAGE_AREA
   after insert or update of DRAINAGE_AREA on pontis.USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_DRAINAGE_AREA
-- After update trigger to pass essential parameters via ksbms_pontis_util.f_pass_update_trigger_params()
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

--    2004-04-16 DEB at KDOT - Added to synch process 
-----------------------------------------------------------------------------------------------------------------------------------------
 -- Generated 2002-02-26 at 09:26
  -- Updated by ARMarshall, ARM LLC 20150615 
  -- extend this to check for actually different values meeting or exceeding the tolerance percentage
  -- return immediately if not and store nothing in the change log.

 
 
when (nvl( new.DRAINAGE_AREA, -9 ) <>  nvl( old.DRAINAGE_AREA, -9 ) )
declare
  lb_result    boolean;
  ls_bridge_id bridge.bridge_id%type;
begin
  -- new code
  IF Ksbms_Util.f_Numbers_Differ(Nvl(:Old.DRAINAGE_AREA, -9),
                                 Nvl(:New.DRAINAGE_AREA, -9),
                                 -- use the next function to load the tolerances from 
                                 -- the table Ds_Transfer_Delta_Tolerances
                                 Ksbms_Util.f_Get_Delta_Tolerance(Ptab => 'userbrdg',
                                                                  Pcol => 'drainage_area'),
                                 FALSE) = FALSE THEN
    RETURN; -- not a real change
  END IF;
  -- end change
  ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey(:new.brkey);
  lb_result    := ksbms_pontis.f_pass_update_trigger_params(nvl(:new.brkey,
                                                                '<MISSING>'),
                                                            'BRIDGE_ID',
                                                            'USERBRDG',
                                                            'DRAINAGE_AREA',
                                                            TO_CHAR(:old.DRAINAGE_AREA),
                                                            TO_CHAR(:new.DRAINAGE_AREA),
                                                            1,
                                                            nvl(ls_bridge_id,
                                                                '<MISSING>'),
                                                            'taur_ds_UBRDG_DRAINAGE_AREA');
  if lb_result then
    dbms_output.put_line('taur_ds_UBRDG_DRAINAGE_AREA failed');
  end if;
end taur_ds_UBRDG_DRAINAGE_AREA;
/