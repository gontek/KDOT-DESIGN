CREATE TABLE ksbms_robot.ds_transfer_key_map (
  transfer_key_map_id NUMBER NOT NULL,
  key_sequence_num NUMBER NOT NULL,
  table_name VARCHAR2(30 BYTE) NOT NULL,
  column_name VARCHAR2(30 BYTE) NOT NULL,
  sit_id VARCHAR2(30 BYTE) NOT NULL,
  sat_id VARCHAR2(30 BYTE) NOT NULL,
  used_by VARCHAR2(1 BYTE) CONSTRAINT ckc_used_by_ds_trans CHECK (USED_BY in ('B','P','H')),
  createdatetime DATE,
  createuserid VARCHAR2(30 BYTE),
  modtime DATE,
  changeuserid VARCHAR2(30 BYTE),
  remarks VARCHAR2(255 BYTE),
  CONSTRAINT pk_ds_transfer_key_map PRIMARY KEY (transfer_key_map_id,key_sequence_num,table_name,column_name,sit_id,sat_id),
  CONSTRAINT fk_ds_trans_fk_transf_ds_trans FOREIGN KEY (transfer_key_map_id) REFERENCES ksbms_robot.ds_transfer_key_types (transfer_key_map_id) ON DELETE CASCADE
);
COMMENT ON TABLE ksbms_robot.ds_transfer_key_map IS 'List of keys that are to be used to synchronize between Pontis and CANSYS II.  
For example, to send data at the UNIT level from Pontis to EXOR Highways/CANSYS, depending on the rule, the entry would look like

1, BRIDGE, STRUC_NUM, RG14, RG14, 1
1, STRUCTURE_UNIT, UNIT_ID,  RU01, 2';