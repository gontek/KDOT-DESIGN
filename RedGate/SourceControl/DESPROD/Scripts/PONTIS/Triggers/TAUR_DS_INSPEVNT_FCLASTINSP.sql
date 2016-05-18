CREATE OR REPLACE TRIGGER pontis.taur_ds_INSPEVNT_FCLASTINSP
   after insert or update of FCLASTINSP on pontis.INSPEVNT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_INSPEVNT_FCLASTINSP
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
----------------------------------------------------------------------------------------------------------------------------------------

-- ?2001 Copyright: Cambridge Systematics, Inc, Asset Management Group: All Rights Reserved
-- No distribution without express written permission of Cambridge Systematics, Inc., Cambridge MA

--    Cambridge Systematics
--    150 CambridgePark Drive, Suite 4000
--    Cambridge MA 02140
--    Phone: 617-354-0167
--    Fax:   616-354-1542
--    http://www.camsys.com

-- Generated 2002-02-26 at 09:26

 
  WHEN (nvl( new.FCLASTINSP, TO_DATE( '1901-01-01', 'YYYY-MM-DD' ) ) <>  nvl( old.FCLASTINSP, TO_DATE( '1901-01-01', 'YYYY-MM-DD' ) ) ) declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params(
      nvl( :new.brkey, '<MISSING>' ) || ',' || nvl( :new.inspkey, '<MISSING>' ),
      'BRIDGE_ID,INSPKEY',
      'INSPEVNT',
      'FCLASTINSP',
      TO_CHAR( :old.FCLASTINSP, 'YYYY-MM-DD' ),
      TO_CHAR( :new.FCLASTINSP, 'YYYY-MM-DD' ),
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_INSPEVNT_FCLASTINSP');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_INSPEVNT_FCLASTINSP failed' );
	 end if;
end taur_ds_INSPEVNT_FCLASTINSP;
/