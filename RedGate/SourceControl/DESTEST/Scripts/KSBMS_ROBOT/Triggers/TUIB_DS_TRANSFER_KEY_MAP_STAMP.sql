CREATE OR REPLACE TRIGGER ksbms_robot.TUIB_DS_TRANSFER_key_MAP_STAMP
  before insert OR UPDATE on ksbms_robot.ds_transfer_KEY_map  
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
  
end TUIB_DS_TRANSFER_key_MAP_STAMP;
/