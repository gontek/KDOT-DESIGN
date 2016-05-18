CREATE OR REPLACE TRIGGER pontis.taur_ds_UBRDG_HORIZ_UNDR_SIGN
   after insert or update of HORIZ_UNDR_SIGN on pontis.USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_HORIZ_UNDR_SIGN
-- After update trigger to pass essential parameters via ksbms_pontis_util.f_pass_update_trigger_params()
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

-- 2002.01.10  - Hoyt Nelson, CS -- Initial adaptation from the generated update triggers
-- 2002.07.23  - Deb Kossler, KDOT -- trigger added because it was not created in original CS package
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

 
 
 WHEN (nvl( new.HORIZ_UNDR_SIGN, '<MISSING>' ) <>  nvl( old.HORIZ_UNDR_SIGN, '<MISSING>' ) ) declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params(
      nvl( :new.brkey, '<MISSING>' ),
      'BRIDGE_ID',
      'USERBRDG',
      'HORIZ_UNDR_SIGN',
      :old.HORIZ_UNDR_SIGN,
      :new.HORIZ_UNDR_SIGN,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'taur_ds_UBRDG_HORIZ_UNDR_SIGN');
	 if lb_result
	 then
		  dbms_output.put_line( 'taur_ds_UBRDG_HORIZ_UNDR_SIGN failed' );
	 end if;
end taur_ds_UBRDG_HORIZ_UNDR_SIGN;
/