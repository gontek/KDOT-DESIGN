CREATE TABLE ksbms_robot.ds_ss_cl_10527201500008013 (
  entry_id VARCHAR2(32 BYTE) NOT NULL,
  sequence_num NUMBER NOT NULL,
  exchange_rule_id NUMBER(38) NOT NULL,
  exchange_type VARCHAR2(3 BYTE) NOT NULL,
  old_value VARCHAR2(255 BYTE),
  new_value VARCHAR2(255 BYTE),
  exchange_status VARCHAR2(10 BYTE) NOT NULL,
  precedence VARCHAR2(2 BYTE) NOT NULL,
  createdatetime DATE NOT NULL,
  createuserid VARCHAR2(30 BYTE) NOT NULL,
  remarks VARCHAR2(255 BYTE)
);