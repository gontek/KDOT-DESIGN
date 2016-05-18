CREATE OR REPLACE TRIGGER pontis.taur_ds_BRIDGE_RATINGDATE
   after insert or update of RATINGDATE on pontis.BRIDGE for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_BRIDGE_RATINGDATE
-- After update trigger to pass essential parameters via ksbms_pontis_util.f_pass_update_trigger_params()
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

--   2002.07.01 - Allen Marshall, CS - Copied from trigger for BRIDGE.NAVHC

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


 
 
 WHEN ( nvl( new.RATINGDATE, TO_DATE( '1901-01-01', 'YYYY-MM-DD' ) ) <>  nvl( old.RATINGDATE, TO_DATE( '1901-01-01', 'YYYY-MM-DD' ) ) ) declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := :new.bridge_id;
    lb_result := ksbms_pontis.f_pass_update_trigger_params(
      nvl( :new.brkey, '<MISSING>' ),
      'BRIDGE_ID',
      'BRIDGE',
      'RATINGDATE',
      TO_CHAR( :old.RATINGDATE ,'YYYY-MM-DD' ),
      TO_CHAR( :new.RATINGDATE ,'YYYY-MM-DD' ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_BRIDGE_RATINGDATE');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_BRIDGE_RATINGDATE failed' );
	 end if;
end taur_ds_BRIDGE_RATINGDATE;
/