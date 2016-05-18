CREATE OR REPLACE TRIGGER pontis.TAUR_DS_USTR_CRIT_NOTE_CUL_1
   after insert or update of CRIT_NOTE_CUL_1 on pontis.USERSTRUNIT for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: TAUR_DS_USTR_CRIT_NOTE_CUL_1
-- After update trigger to pass essential parameters via ksbms_pontis_util.f_pass_update_trigger_params()
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

--    2004.3.5 - DK - KDOT -- Created to exchange critical notations for Decks
-----------------------------------------------------------------------------------------------------------------------------------------

 
  WHEN (nvl( new.CRIT_NOTE_CUL_1, '<MISSING>' ) <>  nvl( old.CRIT_NOTE_CUL_1, '<MISSING>' ) ) declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := ksbms_pontis.f_get_bridge_id_from_brkey( :new.brkey );
    lb_result := ksbms_pontis.f_pass_update_trigger_params(
 /*     nvl( :new.brkey, '<MISSING>' ) || ',' || ksbms_pontis.f_strunitlabel_or_strunitkey( null, :new.strunitkey ),
      'BRIDGE_ID,STRUNITLABEL',*/
         nvl( ls_bridge_id, '<MISSING>' ) || ',' || to_char( :new.strunitkey ),
      'BRIDGE_ID,STRUNITKEY', -- was STRUNITLABEL  2002.08.08 - Allen Marshall, CS     
      'USERSTRUNIT',
      'CRIT_NOTE_CUL_1',
      :old.CRIT_NOTE_CUL_1,
      :new.CRIT_NOTE_CUL_1,
      2,
      nvl( ls_bridge_id, '<MISSING>' ),
      'TAUR_DS_USTR_CRIT_NOTE_CUL_1');
	 if lb_result
	 then
		  dbms_output.put_line( 'TAUR_DS_USTR_CRIT_NOTE_CUL_1 failed' );
	 end if;
end TAUR_DS_USTR_CRIT_NOTE_CUL_1;
/