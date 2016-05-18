CREATE OR REPLACE trigger pontis.taidr_bridge_to_history
-- Summary: An after update trigger that sets what goes into ds_change_log for deleted structures<BR>
  --   <BR>
  -- %revision-history This was a change in the sync process from taking a structure completely out of Pontis (BrM) to just setting <BR>
  -- bridge.district = '9'...this triggers changes the district 9 update to "DEL"<BR> 
  -- created: Original method for deleting structures existed from build of sync process<BR>
  -- revised: 2011-09-20<BR>
  -- <p id="doc_save_date" style="margin: 0;">documentation revised: 2015-07-10</p><p id="doc_mod_date" style="margin: 0;"></p>
  -- %copyright-notice Kansas Department of Transportation, 2015 - all rights reserved
  -- %kdot-contact Ms. Deb Kossler, Bureau of Structures and Geotechnical Services, Bridge Management<BR>
  -- <a href="mailto:deb@ksdot.org?Subject="Documentation%20Question%20re:%20taidr_bridge_to_history">Email questions about taidr_bridge_to_history</a><BR>
  -- %developer-info Allen R. Marshall, ARM LLC
  -- <BR>ph: 617-335-6934
  -- <BR><a href="http://allenrmarshall-consulting-llc.com" alt="Link to developer website">Visit developer website</a>
  -- <BR><a href="mailto:armarshall@allenrmarshall-consulting-llc.com?Subject="Documentation%20Question%20re:%20taidr_bridge_to_history">Email questions about taidr_bridge_to_history</a><BR>
  -- %development-environment
  -- Oracle Database 11g Release 11.2.0.4.0<BR>
  -- OCI: version 11.1
  -- %param
  -- %usage We set a structure's District = '9' to essentially set it to history...the update to '9' in the ds_change_log is then set
  -- to an update to "Del" in the exchange log which causes Cansys code to set the structure
  -- appropriately to history
  -- %raises  message if the anticipated row does not occur...(has never happened...)
  -- %return A set of data to populate the row for the ds_change_log updating district to '9' for the structure
  -- %see  trigger TUIB_DS_CHANGE_LOG_DEL_HANDLER on ds_change_log in Cansys basically does the same thing except when they
  -- delete a structure, the ds_change_log row is an update of District = '9'

  after update of district on pontis.bridge  
  for each row
  
 
when (nvl(new.DISTRICT,'<missing>' ) <> NVL(OLD.district,'<missing>')  AND
     (NEW.DISTRICT = '9') )
declare
 lb_result            boolean;
 ls_bridge_id         bridge.bridge_id%type;
 ls_brkey             bridge.brkey%type;
 ls_exchange_type     ksbms_robot.ds_change_log.exchange_type%type;
 lex_unsupported_case exception;


begin
ls_brkey := :old.brkey;
ls_bridge_id := :old.bridge_id;
ls_exchange_type := 'DEL';

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