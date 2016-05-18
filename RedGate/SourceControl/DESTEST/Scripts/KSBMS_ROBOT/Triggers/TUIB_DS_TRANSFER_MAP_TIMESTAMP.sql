CREATE OR REPLACE TRIGGER ksbms_robot.TUIB_DS_TRANSFER_MAP_TIMESTAMP
  before insert OR UPDATE on ksbms_robot.ds_transfer_map  
  for each row


declare
  -- local variables here
begin
IF INSERTING THEN
  :NEW.CREATEDATETIME := SYSDATE;
  :NEW.CREATEUSERID := USER;
END IF;
 
  :NEW.modTIME := SYSDATE;
  :NEW.changeUSERID := USER;
  
end TUIB_DS_TRANSFER_MAP_TIMESTAMP;
/