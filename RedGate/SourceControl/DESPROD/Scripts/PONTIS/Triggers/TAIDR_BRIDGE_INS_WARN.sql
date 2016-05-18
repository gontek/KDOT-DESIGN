CREATE OR REPLACE TRIGGER pontis.taidr_bridge_ins_warn
   after insert
   on pontis.bridge
   for each row

-- Summary: An after insert trigger that notifies a list of appropriate users that a structure has been built into Pontis(BrM).<BR>
  --   <BR>
  -- revision-Created originally to handle inserts and deletes messages...revised to only notify on the build of a structure.<BR>
  -- created: Existed from build of sync process<BR>
  -- revised: 2011-09-20<BR>
  -- <p id="doc_save_date" style="margin: 0;">documentation revised: 2015-07-10</p><p id="doc_mod_date" style="margin: 0;"></p>
  -- %copyright-notice Kansas Department of Transportation, 2015 - all rights reserved
  -- %kdot-contact Ms. Deb Kossler, Bureau of Structures and Geotechnical Services, Bridge Management<BR>
  -- <a href="mailto:deb@ksdot.org?Subject="Documentation%20Question%20re:%20taidr_bridge_ins_warn">Email questions about taidr_bridge_ins_warn</a><BR>
  -- %developer-info Allen R. Marshall, ARM LLC
  -- <BR>ph: 617-335-6934
  -- <BR><a href="http://allenrmarshall-consulting-llc.com" alt="Link to developer website">Visit developer website</a>
  -- <BR><a href="mailto:armarshall@allenrmarshall-consulting-llc.com?Subject="Documentation%20Question%20re:%20taidr_bridge_ins_warn">Email questions about taidr_bridge_ins_warn</a><BR>
  -- %development-environment
  -- Oracle Database 11g Release 11.2.0.4.0<BR>
  -- OCI: version 11.1
  -- %param
  -- %usage Uses the procedure p_gen_pontis_email_report to send a robot email message after in the insert of a structure notifying
  -- users that a new structure has been added to the system<BR>
  -- %raises 
  -- %return  
  -- %see 





declare
   ls_email_list          ksbms_robot.ds_config_options.optionvalue%TYPE;
   lex_email_failed       EXCEPTION;
   lex_unsupported_case   EXCEPTION;   
begin
     -- Get alert list from KSBMS_ROBOT.DS_CONFIG_OPTIONS
     
     ls_email_list := nvl( ksbms_util.f_get_coption_value('EMAIL_BRIDGE_CREATDEL_LIST'),'deb@ksdot.org');
   -- What we e-mail depends on 
   -- whether we are INSERTing or DELETing
   if inserting
   then
       
     -- send new BRIDGE_ID  as mail message
     -- Allen R. Marshall, CS 2002.12.13 - fixed timestamp to show time and date, not just date
       if ksbms_util.f_email( ls_email_list, 'Bridge ' ||:new.bridge_id||' was added to the database by user '|| USER || ' at ' || to_char(sysdate,'YYYY-MM-DD HH:MI:SS') ||
       ksbms_util.crlf||'Design folks: Remember to ASAP visit this structure to fill in blank fields and create element level structure items as noted in instructions for this bridge.'
       , 'ATTENTION: BRIDGE INSERTED/CREATED - NEW BRIDGE_ID  # '|| :new.bridge_id ) then 
            raise lex_email_failed;
       end if;
         
  /*    
   elsif deleting
   then
      -- send deleted BRIDGE_ID in mail message
      -- Allen R. Marshall, CS 2002.12.13 - fixed timestamp to show time and date, not just date
      if ksbms_util.f_email( ls_email_list,'Bridge '||:old.bridge_id||' in Dist/Area '||:old.adminarea|| ' was removed from the database by user '|| USER || ' at ' || to_char(sysdate,'YYYY-MM-DD HH:MI:SS')||
        ksbms_util.crlf||'Design folks: Remember to check whether the road intersection was end-dated.', 'ATTENTION: BRIDGE/CULVERT DELETED - BRIDGE ID # '|| :old.bridge_id) then
         raise lex_email_failed;
      end if;
  */    
     else -- Unhandled case
        -- This will raise as an unhandled user error
        raise lex_unsupported_case; -- Does this work?
     end if;

   exception
     WHEN lex_email_failed THEN
          dbms_output.put_line ('ksbms_util.f_email(l,m,s) function call failed processing Trigger taidr_bridge_ins_warn failed');
     WHEN lex_unsupported_case THEN
          dbms_output.put_line ('Unsupported case encountered processing Trigger taidr_bridge_ins_warn failed');
     
     WHEN OTHERS THEN
        dbms_output.put_line ('Trigger taidr_bridge_ins_warn failed');

end taidr_bridge_ins_warn;
/