CREATE OR REPLACE TRIGGER pontis.taur_ds_URWAY_FEAT_CROSS_TYPE
   after insert or update of FEAT_CROSS_TYPE on pontis.USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_URWAY_FEAT_CROSS_TYPE
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
 
  WHEN (nvl( new.FEAT_CROSS_TYPE, '<MISSING>' ) <>  nvl( old.FEAT_CROSS_TYPE, '<MISSING>' ) ) declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params(
      nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.feat_cross_type, '<MISSING>' ) || ',' || ksbms_pontis.f_route_prefix_or_on_under( :new.route_prefix, :new.on_under ) || ',' || nvl( :new.route_num, '<MISSING>' ) || ',' || nvl( :new.route_suffix, '<MISSING>' ) || ',' || nvl( :new.route_unique_id, '<MISSING>' ),
      'BRIDGE_ID,FEAT_CROSS_TYPE,ROUTE_PREFIX,ROUTE_NUM,ROUTE_SUFFIX,ROUTE_UNIQUE_ID',
      'USERRWAY',
      'FEAT_CROSS_TYPE',
      :old.FEAT_CROSS_TYPE,
      :new.FEAT_CROSS_TYPE,
      3,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_URWAY_FEAT_CROSS_TYPE');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_URWAY_FEAT_CROSS_TYPE failed' );
	 end if;
end taur_ds_URWAY_FEAT_CROSS_TYPE;
/