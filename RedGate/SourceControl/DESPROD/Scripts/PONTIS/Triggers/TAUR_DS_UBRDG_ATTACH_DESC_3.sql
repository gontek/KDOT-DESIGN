CREATE OR REPLACE Trigger pontis.taur_ds_UBRDG_ATTACH_DESC_3
   after insert or update of ATTACH_DESC_3 on pontis.USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_ATTACH_DESC_3
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
--    2008.02.12 - Kossler, D. KDOT -- Added the substr phrase to ensure this trigger
--              only fires for bridge-type structures (not signs, trusses, etc.) 
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

 
 
 
when (substr( nvl(new.brkey, -9),4,1) in ('0','1','2','3','4','5','6','7','8','9') and
nvl( new.ATTACH_DESC_3, '<MISSING>' ) <>  nvl( old.ATTACH_DESC_3, '<MISSING>' ) )
declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params(
        nvl( :new.brkey, '<MISSING>' )||','||'3',
      'BRIDGE_ID,SEQUENCE_NUM',
     'USERBRDG',
      'ATTACH_DESC_3',
      trim(upper(:old.ATTACH_DESC_3)),
      trim(upper(:new.ATTACH_DESC_3)), -- get rid of extra spaces dk 2010.10.15
      11, -- Allen Marshall, CS - 2002.07.08 - key map number 11
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_ATTACH_DESC_3');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_ATTACH_DESC_3 failed' );
	 end if;
end taur_ds_UBRDG_ATTACH_DESC_3;
/