CREATE OR REPLACE TRIGGER pontis.TAUR_DS_URWAY_TOLL_KDOT
   after insert or update of TOLL_kdot on pontis.USERRWAY for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: TAUR_DS_URWAY_TOLL_KDOT
-- After update trigger to pass essential parameters via ksbms_pontis_util.f_pass_update_trigger_params()
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

--    2009.9.15  - Deb Kossler added to sync project---------------------------------------------------------------------------------------------------------------------------------

-- Generated 2009-09-15 at 03:15 PM

  WHEN (substr( nvl(new.brkey, -9),4,1) in ('0','1','2','3','4','5','6','7','8','9') and
nvl( new.toll_kdot, '_' ) <>  nvl( old.toll_kdot, '_' ) and new.on_under = '1') declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params(
      nvl( :new.brkey, '<MISSING>' ),
      'BRIDGE_ID',
      'USERRWAY',
      'TOLL_KDOT',
      TO_CHAR( :old.TOLL_KDOT ),
      TO_CHAR( :new.TOLL_KDOT ),
      22,
      nvl( ls_bridge_id, '<MISSING>' ),
      'TAUR_DS_URWAY_TOLL_KDOT');
	 if lb_result
	 then
		  dbms_output.put_line( 'TAUR_DS_URWAY_TOLL_KDOT failed' );
	 end if;
end TAUR_DS_URWAY_TOLL_KDOT;
/