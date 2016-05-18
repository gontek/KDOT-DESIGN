CREATE OR REPLACE TRIGGER pontis.taidr_bridge_to_history
  after update of district on pontis.bridge  
  for each row

----------------------------------------------------------------------------------------
-- Trigger: taidr_bridge_to_history
-- After update of district to '9', denotes the bridge should
-- has been historized in Pontis and sends a "del" to Cansys for
-- their code to end-date items
----------------------------------------------------------------------------------------
-- Revision History
-- 2011.09.20 -- DK added
----------------------------------------------------------------------------------------

  
 DISABLE WHEN (nvl(new.DISTRICT,'<missing>' ) <> NVL(OLD.district,'<missing>')  AND
     (NEW.DISTRICT = '9') ) declare
 lb_result            boolean;
 ls_bridge_id         bridge.bridge_id%type;
 ls_brkey             bridge.brkey%type;
 ls_exchange_type     ksbms_robot.ds_change_log.exchange_type%type;
 lex_unsupported_case exception;


begin
ls_brkey := :old.brkey;
ls_bridge_id := :old.bridge_id;
ls_exchange_type := 'DEL';

-- When District is set to "9", this means we need
-- to send a del row to Cansys so code will set
-- their structure record to history

lb_result := ksbms_pontis.f_pass_update_trigger_params (
       nvl (ls_brkey,'<MISSING>'),
       'BRIDGE_ID',
       'BRIDGE',
       ls_exchange_type,
       :old.bridge_id,
       null,
       1,
       nvl (ls_bridge_id, '<MISSING>'),
       'taidr_bridge_history'
       );
       
 if lb_result
   then
     dbms_output.put_line('Trigger taidr_bridge_history failed');
     end if;
 
  
end taidr_bridge_history;
/