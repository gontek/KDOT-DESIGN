CREATE TABLE ksbms_robot.junk_delta_keyvals (
  entry_id VARCHAR2(32 BYTE) NOT NULL,
  keyname VARCHAR2(30 BYTE) NOT NULL,
  keyvalue VARCHAR2(255 BYTE) NOT NULL,
  key_sequence_num NUMBER(38) NOT NULL,
  createdatetime DATE NOT NULL,
  createuserid VARCHAR2(30 BYTE) NOT NULL
);