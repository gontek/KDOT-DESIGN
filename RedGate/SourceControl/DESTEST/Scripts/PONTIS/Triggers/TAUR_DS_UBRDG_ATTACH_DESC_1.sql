CREATE OR REPLACE Trigger pontis.taur_ds_UBRDG_ATTACH_DESC_1
   after insert or update of ATTACH_DESC_1 on pontis.USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_ATTACH_DESC_1
-- After update trigger to pass essential parameters via ksbms_pontis_util.f_pass_update_trigger_params()
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

--    2002.07.08   - Allen Marshall, CS - Added Sequence # to keys passed (1,2,3)                                                                                                               

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

 
 
 
when (nvl( new.ATTACH_DESC_1, '<MISSING>' ) <>  nvl( old.ATTACH_DESC_1, '<MISSING>' ))
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params(
       nvl( :new.brkey, '<MISSING>' )||','||'1',
      'BRIDGE_ID,SEQUENCE_NUM',
   'USERBRDG',
      'ATTACH_DESC_1',
      trim(upper(:old.ATTACH_DESC_1)),
      trim(UPPER(:new.ATTACH_DESC_1)),--get rid of spaces dk 2010.10.15
      11, -- Allen Marshall, CS - 2002.07.08 - key map number 11
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_ATTACH_DESC_1');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_ATTACH_DESC_1 failed' );
	 end if;
end taur_ds_UBRDG_ATTACH_DESC_1;
/