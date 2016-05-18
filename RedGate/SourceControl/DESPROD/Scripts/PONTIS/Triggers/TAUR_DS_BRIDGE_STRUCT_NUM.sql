CREATE OR REPLACE TRIGGER pontis.TAUR_DS_BRIDGE_STRUCT_NUM
  after update of struct_num on pontis.bridge for each row

-----------------------------------------------------------------------------------------------------------------------------------------
-- Trigger: TAUR_DS_BRIDGE_STRUCT_NUM
-----------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:

--    2010.08.16  DK, KDOT -- Added to sync-up to facility moving
--                NBI_8 from Pontis to Cansys (previous updates only came to Pontis from
--                Cansys
--    2011.09.20  Revised to send changes to sync-up only on update, not insert...we don't
--                want these when a bridge is initially built.
 
 
 WHEN ( nvl( new.struct_num, '<MISSING>' ) <>  nvl( old.struct_num, '<MISSING>' ) ) declare
   lb_result boolean;
   ls_bridge_id bridge.bridge_id%type;
begin
    ls_bridge_id := :new.bridge_id;
    lb_result := ksbms_pontis.f_pass_update_trigger_params(
      nvl( :new.brkey, '<MISSING>' ),
      'BRIDGE_ID',
      'BRIDGE',
      'STRUCT_NUM',
      '',
      :new.struct_num,
      1,
      nvl( ls_bridge_id, '<MISSING>' ),
      'TAUR_DS_BRIDGE_STRUCT_NUM');
   if lb_result
	 then
		  dbms_output.put_line( 'TAUR_DS_BRIDGE_STRUCT_NUM failed' );
	 end if;
end TAUR_DS_BRIDGE_STRUCT_NUM;
/