CREATE OR REPLACE Trigger pontis.taur_ds_BRIDGE_RTCURBSW
   after insert or update of RTCURBSW on pontis.BRIDGE for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_BRIDGE_RTCURBSW
-- After update trigger to pass essential parameters via ksbms_pontis_util.f_pass_update_trigger_params()
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

--    2001.11.29  - Hoyt Nelson, CS -- Initial coding

--    2001.11.30  - Hoyt Nelson, CS -- Added the 'calling trigger' argument (last in the parameter list) so we
--                                     can identify the trigger that made the call, in ds_change_log.remarks.

--    2001.12.03  - Hoyt Nelson, CS -- Added 'old.bridge_id' and transfer_map_key_id as parameters to f_pass_update_trigger_params().
--                                     Also added code to consolidate duplicated "special cases" into single triggers.

--    2013.01.24  - added a phrase so the trigger only fires when an update is > 0.

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
-- Generated 2002-02-26 at 09:26
 -- Generated 2002-02-26 at 09:26
  -- Updated by ARMarshall, ARM LLC 20150615 
  -- extend this to check for actually different values meeting or exceeding the tolerance percentage
  -- return immediately if not and store nothing in the change log.

 
when (nvl( new.RTCURBSW, -9 ) <>  nvl( old.RTCURBSW, -9 )
 )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
  -- new code
  IF Ksbms_Util.f_Numbers_Differ(Nvl(:Old.RTCURBSW, -9),
                                 Nvl(:New.RTCURBSW, -9),
                                 -- use the next function to load the tolerances from 
                                 -- the table Ds_Transfer_Delta_Tolerances
                                 Ksbms_Util.f_Get_Delta_Tolerance(Ptab => 'bridge',
                                                                  Pcol => 'rtcurbsw'),
                                 FALSE) = FALSE THEN
    RETURN; -- not a real change
  END IF;
  -- end change  

    ls_bridge_id := :new.bridge_id;
    lb_result := ksbms_pontis.f_pass_update_trigger_params(
      nvl( :new.brkey, '<MISSING>' ),
      'BRIDGE_ID',
      'BRIDGE',
      'RTCURBSW',
      TO_CHAR( :old.RTCURBSW ),
      TO_CHAR( :new.RTCURBSW ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_BRIDGE_RTCURBSW');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_BRIDGE_RTCURBSW failed' );
	 end if;
end taur_ds_BRIDGE_RTCURBSW;
/