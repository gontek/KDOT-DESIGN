CREATE OR REPLACE TRIGGER pontis.taur_ds_URWAY_HCLR_W
   after insert or update of HCLR_W on pontis.USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_HCLR_W
-- After update trigger to pass essential parameters via ksbms_pontis_util.f_pass_update_trigger_params()
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

--    2003.04.01 - Allen Marshall, CS - Changed f_route_prefix_or_on_under to f_clr_route with typed arguments

--     2002.07.08 - Allen Marshall, CS -- added directional indicator for use by HIGHWAYS...
-- determined from column name suffix

--    2001.11.29  - Hoyt Nelson, CS -- Initial coding

--    2001.11.30  - Hoyt Nelson, CS -- Added the 'calling trigger' argument (last in the parameter list) so we
--                                     can identify the trigger that made the call, in ds_change_log.remarks.

--    2001.12.03  - Hoyt Nelson, CS -- Added 'old.bridge_id' and transfer_map_key_id as parameters to f_pass_update_trigger_params().
--                                     Also added code to consolidate duplicated "special cases" into single triggers.
-----------------------------------------------------------------------------------------------------------------------------------------

-- ?2001 Copyright: Cambridge Systematics, Inc, Asset Management Group: All Rights Reserved
-- No distribution without express written permission of Cambridge Systematics, Inc., Cambridge MA

--    Cambridge Systematics
--    150 CambridgePark Drive, Suite 4000
--    Cambridge MA 02140
--    Phone: 617-354-0167
--    Fax:   616-354-1542
--    http://www.camsys.com

-- Generated 2002-02-26 at 09:26
  -- Updated by ARMarshall, ARM LLC 20150615 
  -- extend this to check for actually different values meeting or exceeding the tolerance percentage
  -- return immediately if not and store nothing in the change log.
 
 
 WHEN (nvl( new.HCLR_W, -9 ) <>  nvl( old.HCLR_W, -9 ) ) declare
  lb_result    boolean;
  ls_bridge_id bridge.bridge_id%type;
begin
  -- new code
  IF Ksbms_Util.f_Numbers_Differ(Nvl(:Old.HCLR_W, -9),
                                 Nvl(:New.HCLR_W, -9),
                                 -- use the next function to load the tolerances from 
                                 -- the table Ds_Transfer_Delta_Tolerances
                                 Ksbms_Util.f_Get_Delta_Tolerance(Ptab => 'userrway',
                                                                  Pcol => 'hclr_w'),
                                 FALSE) = FALSE THEN
    RETURN; -- not a real change
  END IF;
  -- end change  
  ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey(:new.brkey);
  lb_result    := ksbms_pontis.f_pass_update_trigger_params(nvl(:new.brkey,
                                                                '<MISSING>') || ',' ||
                                                            ksbms_pontis.f_clr_route(:new.clr_route,
                                                                                     :new.on_under) || ',' || 'W',
                                                            --     2002.07.08 - Allen Marshall, CS -- added directional indicator for use by HIGHWAYS...
                                                            'BRIDGE_ID,CLR_ROUTE,DIRECTION',
                                                            'USERRWAY',
                                                            'HCLR_W',
                                                            TO_CHAR(:old.HCLR_W),
                                                            TO_CHAR(:new.HCLR_W),
                                                            6,
                                                            nvl(ls_bridge_id,
                                                                '<MISSING>'),
                                                            'taur_ds_URWAY_HCLR_W');
  if lb_result then
    dbms_output.put_line('taur_ds_URWAY_HCLR_W failed');
  end if;
end taur_ds_URWAY_HCLR_W;
/