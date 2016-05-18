CREATE OR REPLACE TRIGGER ksbms_robot.tuib_ds_lookup_kv_arch_ts
  
-------------------------------------------------------
-- Trigger  tuib_ds_lookup_kv_arch_ts
--- Pre-insert Timestamp and Userstamp Trigger for table ds_lookup_keyvals_archive - stamps all inserted rows with ORACLE SYSDATE and USER values
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Project # 7004 - Kansas DOT Pontis Implementation (Data Synchronization)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Revision History:
-- 2001.11.29  - Allen R. Marshall, CS - initial implementation
-- 2001.11.29  - Allen R. Marshall, CS - renamed trigger, added header
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Copyright: Cambridge Systematics, Inc, Asset Management Group, 2001 - all rights reserved
-- No distribution without express written permission of Cambridge Systematics, Inc., Cambridge MA
-- Cambridge Systematics
-- 150 CambridgePark Drive, Suite 4000
-- Cambridge MA 02140
-- p - 617-354-0167
-- f -  616-354-1542
-- http://www.camsys.com
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
before insert on ksbms_robot.ds_lookup_keyvals_archive
  for each ROW
  





declare
  -- local variables here
begin
  :new.createdatetime := SYSDATE;
  :new.createuserid := USER;
end tuib_ds_lookup_kv_arch_ts;
/