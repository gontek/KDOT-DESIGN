CREATE OR REPLACE TRIGGER pontis.taur_ds_ROADWAY_CRIT_FEAT
   after insert or update of CRIT_FEAT on pontis.ROADWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_ROADWAY_CRIT_FEAT
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

--    2002.11.01  - Deb Kossler, KDOT = Added new.on_under = '1' to exchange only on records.

--    2002.11.05   - NAC, CS -- Changed the transfer_key_map_id from 4 to 22.
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

 
 
  DISABLE WHEN (nvl( new.CRIT_FEAT, '<MISSING>' ) <>  nvl( old.CRIT_FEAT, '<MISSING>' )
 and new.CRIT_FEAT in ('Y','N') and new.ON_UNDER = '1') declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params(
      nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( null, :new.on_under ) || ',' || nvl( null, '<MISSING>' ) || ',' || nvl( null, '<MISSING>' ) || ',' || nvl( null, '<MISSING>' ),
      'BRIDGE_ID,ROUTE_PREFIX,ROUTE_NUM,ROUTE_SUFFIX,ROUTE_UNIQUE_ID',
      'ROADWAY',
      'CRIT_FEAT',
      :old.CRIT_FEAT,
      :new.CRIT_FEAT,
      22,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_ROADWAY_CRIT_FEAT');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_ROADWAY_CRIT_FEAT failed' );
	 end if;
end taur_ds_ROADWAY_CRIT_FEAT;
/