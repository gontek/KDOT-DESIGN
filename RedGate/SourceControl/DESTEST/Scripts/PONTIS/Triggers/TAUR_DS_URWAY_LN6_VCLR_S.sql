CREATE OR REPLACE TRIGGER pontis.TAUR_DS_URWAY_LN6_VCLR_S
   after insert or update of LN6_VCLR_S on pontis.USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_LN6_VCLR_S
-- After update trigger to pass essential parameters via ksbms_pontis_util.f_pass_update_trigger_params()
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:
--   2006-07-12 New field to facilitate transfer of additional vertical underclearances between CansysII and Pontis
-----------------------------------------------------------------------------------------------------------------------------------------

-- Generated 2006-07-12
  -- Updated by ARMarshall, ARM LLC 20150615 
  -- extend this to check for actually different values meeting or exceeding the tolerance percentage
  -- return immediately if not and store nothing in the change log.
 
 
 WHEN (nvl( new.LN6_VCLR_S, -9 ) <>  nvl( old.LN6_VCLR_S, -9 ) ) declare
  lb_result    boolean;
  ls_bridge_id bridge.bridge_id%type;
begin

  -- new code
  IF Ksbms_Util.f_Numbers_Differ(Nvl(:Old.LN6_VCLR_S, -9),
                                 Nvl(:New.LN6_VCLR_S, -9),
                                 -- use the next function to load the tolerances from 
                                 -- the table Ds_Transfer_Delta_Tolerances
                                 Ksbms_Util.f_Get_Delta_Tolerance(Ptab => 'userrway',
                                                                  Pcol => 'ln6_vclr_s'),
                                 FALSE) = FALSE THEN
    RETURN; -- not a real change
  END IF;
  -- end change 
  ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey(:new.brkey);
  lb_result    := ksbms_pontis.f_pass_update_trigger_params(nvl(:new.brkey,
                                                                '<MISSING>') || ',' ||
                                                            ksbms_pontis.f_clr_route(:new.clr_route,
                                                                                     :new.on_under) || ',' || 'S',
                                                            'BRIDGE_ID,CLR_ROUTE,DIRECTION',
                                                            'USERRWAY',
                                                            'LN6_VCLR_S',
                                                            TO_CHAR(:old.LN6_VCLR_S),
                                                            TO_CHAR(:new.LN6_VCLR_S),
                                                            6,
                                                            nvl(ls_bridge_id,
                                                                '<MISSING>'),
                                                            'taur_ds_URWAY_LN6_VCLR_S');
  if lb_result then
    dbms_output.put_line('taur_ds_URWAY_LN6_VCLR_S failed');
  end if;
end taur_ds_URWAY_LN6_VCLR_S;
/