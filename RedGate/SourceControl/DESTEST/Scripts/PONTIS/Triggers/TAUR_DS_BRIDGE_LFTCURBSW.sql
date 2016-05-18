CREATE OR REPLACE TRIGGER pontis.taur_ds_BRIDGE_LFTCURBSW
   after insert or update of LFTCURBSW on pontis.BRIDGE for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_BRIDGE_LFTCURBSW
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

 
 
 DISABLE WHEN ( nvl( new.LFTCURBSW, -9 ) <>  nvl( old.LFTCURBSW, -9 ) and
(new.lftcurbsw > 0) ) declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := :new.bridge_id;
    lb_result := ksbms_pontis.f_pass_update_trigger_params(
      nvl( :new.brkey, '<MISSING>' ),
      'BRIDGE_ID',
      'BRIDGE',
      'LFTCURBSW',
      TO_CHAR( :old.LFTCURBSW ),
      TO_CHAR( :new.LFTCURBSW ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_BRIDGE_LFTCURBSW');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_BRIDGE_LFTCURBSW failed' );
	 end if;
end taur_ds_BRIDGE_LFTCURBSW;
/