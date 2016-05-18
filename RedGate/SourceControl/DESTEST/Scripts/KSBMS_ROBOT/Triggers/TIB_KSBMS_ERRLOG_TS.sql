CREATE OR REPLACE TRIGGER ksbms_robot.tib_ksbms_errlog_ts
   
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Trigger:  tib_ds_ksbms_errlog_ts
-- Pre-insert Timestamp and Userstamp Trigger for table ksbms_errlog_ - stamps all inserted rows with ORACLE SYSDATE and USER values
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Pontis Utilities)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:
-- 2001.11.29  - Allen R. Marshall, CS - initial implementation
-- 2001.11.29  - Allen R. Marshall, CS - renamed trigger, added header
-- 2001.12.03  - Allen R. Marshall, CS - adapted for table ksbms_errlog
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Copyright: Cambridge Systematics, Inc, Asset Management Group, 2001 - all rights reserved
-- No distribution without express written permission of Cambridge Systematics, Inc., Cambridge MA
-- Cambridge Systematics
-- 150 CambridgePark Drive, Suite 4000
-- Cambridge MA 02140
-- p - 617-354-0167
-- f -  616-354-1542
-- http://www.camsys.com
-------------------------------------------------------
   BEFORE INSERT
   ON ksbms_robot.ksbms_errlog
   FOR EACH ROW





DECLARE
-- local variables go here
-- SESSION ID
li_sessionid PLS_INTEGER;
BEGIN
-- use USERENV call to find out the originating session for the log entry
SELECT userenv('SESSIONID') INTO li_sessionid FROM dual;
-- burn into new rows.

   :NEW.createdatetime := SYSDATE;
   :NEW.createuserid := USER;
   :NEW.session_id := li_sessionid;
END tib_ksbms_errlog_ts;
/