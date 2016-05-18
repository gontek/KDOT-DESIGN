CREATE OR REPLACE TRIGGER pontis.TAUR_DS_UBRDG_RATING_ADJ
   after insert or update of RATING_ADJ on pontis.USERBRDG for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: taur_ds_UBRDG_RATING_ADJ
-- After update trigger to pass essential parameters via ksbms_pontis_util.f_pass_update_trigger_params()
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

--  Added to project by dk on 5-9-2008

-- Generated 2008-05-09

 
 WHEN (nvl( new.RATING_ADJ, '<MISSING>' ) <>  nvl( old.RATING_ADJ, '<MISSING>' ) ) declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params(
      nvl( :new.brkey, '<MISSING>' ),
      'BRIDGE_ID',
      'USERBRDG',
      'RATING_ADJ',
      :old.RATING_ADJ,
      :new.RATING_ADJ,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'TAUR_DS_UBRDG_RATING_ADJ');
	 if lb_result
	 then
		  dbms_output.put_line( 'TAUR_DS_UBRDG_RATING_ADJ failed' );
	 end if;
end TAUR_DS_UBRDG_RATING_ADJ;
/