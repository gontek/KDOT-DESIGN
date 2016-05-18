CREATE TABLE ksbms_robot.ds_transfer_map (
  exchange_rule_id NUMBER NOT NULL,
  transfer_key_map_id NUMBER NOT NULL CONSTRAINT chk_key_map_id_values CHECK (transfer_key_map_id  IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,22,55,66, -1 )),
  table_name VARCHAR2(30 BYTE) NOT NULL,
  column_name VARCHAR2(30 BYTE) NOT NULL,
  sit_id VARCHAR2(10 BYTE) NOT NULL,
  sat_id VARCHAR2(10 BYTE) NOT NULL,
  precedence VARCHAR2(2 BYTE) NOT NULL,
  createdatetime DATE,
  createuserid VARCHAR2(30 BYTE),
  modtime DATE,
  changeuserid VARCHAR2(30 BYTE),
  remarks VARCHAR2(255 BYTE),
  CONSTRAINT pk_transfer_map PRIMARY KEY (exchange_rule_id),
  CONSTRAINT fk_ds_trans_fk_ds_tra_ds_trans FOREIGN KEY (transfer_key_map_id) REFERENCES ksbms_robot.ds_transfer_key_types (transfer_key_map_id) ON DELETE SET NULL
);
COMMENT ON TABLE ksbms_robot.ds_transfer_map IS 'Map of the exchange of data between PONTIS (BRIDGEWARE) and CANSYS II, tying Pontis Table.Column to CANSYS II SIT_ID,SAT_ID';
COMMENT ON COLUMN ksbms_robot.ds_transfer_map.exchange_rule_id IS 'Identifier for the exchange rule, ties to individual change log entries';
COMMENT ON COLUMN ksbms_robot.ds_transfer_map.transfer_key_map_id IS 'Identifier for the coordinating key set for the exchange attribute';
COMMENT ON COLUMN ksbms_robot.ds_transfer_map.table_name IS 'KSBMS table name of exchange attribute';
COMMENT ON COLUMN ksbms_robot.ds_transfer_map.column_name IS 'KSBMS column name of exchange attribute';
COMMENT ON COLUMN ksbms_robot.ds_transfer_map.sit_id IS 'CANSYS-II SIT_ID of exchange attribute';
COMMENT ON COLUMN ksbms_robot.ds_transfer_map.sat_id IS 'CANSYS-II SAT_ID of exchange attribute';
COMMENT ON COLUMN ksbms_robot.ds_transfer_map.precedence IS 'System with primary authority  (precedence) for the attribute';
COMMENT ON COLUMN ksbms_robot.ds_transfer_map.createdatetime IS 'Date rule record created';
COMMENT ON COLUMN ksbms_robot.ds_transfer_map.createuserid IS 'Oracle user that created the rule record ( e.g. KSBMS_ROBOT)';
COMMENT ON COLUMN ksbms_robot.ds_transfer_map.modtime IS 'Datetime rule record changed';
COMMENT ON COLUMN ksbms_robot.ds_transfer_map.changeuserid IS 'Oracle user that modified the rule record ( e.g. KSBMS_ROBOT)';
COMMENT ON COLUMN ksbms_robot.ds_transfer_map.remarks IS 'Any special handling remarks for this particular rule record, coding rules, etc.';