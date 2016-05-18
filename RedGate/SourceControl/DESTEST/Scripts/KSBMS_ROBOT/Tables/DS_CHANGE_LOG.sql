CREATE TABLE ksbms_robot.ds_change_log (
  entry_id VARCHAR2(32 BYTE) NOT NULL,
  sequence_num NUMBER NOT NULL,
  exchange_rule_id NUMBER(38) NOT NULL,
  exchange_type VARCHAR2(3 BYTE) NOT NULL,
  old_value VARCHAR2(255 BYTE),
  new_value VARCHAR2(255 BYTE),
  exchange_status VARCHAR2(10 BYTE) NOT NULL,
  precedence VARCHAR2(2 BYTE) NOT NULL,
  createdatetime DATE DEFAULT sysdate NOT NULL,
  createuserid VARCHAR2(30 BYTE) DEFAULT 'USER' NOT NULL,
  remarks VARCHAR2(255 BYTE),
  CONSTRAINT pk_ds_change_log PRIMARY KEY (entry_id),
  CONSTRAINT fk_ds_chg_fk_chg_ds_exch FOREIGN KEY (exchange_type) REFERENCES ksbms_robot.ds_exchange_types (exchange_type),
  CONSTRAINT fk_ds_chg_fk_chg_ds_trans FOREIGN KEY (exchange_rule_id) REFERENCES ksbms_robot.ds_transfer_map (exchange_rule_id),
  CONSTRAINT fk_exchange_status FOREIGN KEY (exchange_status) REFERENCES ksbms_robot.ds_exchange_status (exchange_status)
);
COMMENT ON COLUMN ksbms_robot.ds_change_log.entry_id IS 'Unique key for entries, cross-ref key to list of key values (3:N) for the originating source entry';
COMMENT ON COLUMN ksbms_robot.ds_change_log.sequence_num IS 'Order of entry of the change into the log, generated from Oracle sequence ds_change_sequence';
COMMENT ON COLUMN ksbms_robot.ds_change_log.exchange_type IS 'UPD, INS,DEL, MSG allowed values as of June 28, 2001';
COMMENT ON COLUMN ksbms_robot.ds_change_log.old_value IS 'OLD (previous) value for the table.column row that was changed';
COMMENT ON COLUMN ksbms_robot.ds_change_log.new_value IS 'NEW value for the table.column row that was changed';
COMMENT ON COLUMN ksbms_robot.ds_change_log.exchange_status IS 'Latest status of this change log record from processing activity';
COMMENT ON COLUMN ksbms_robot.ds_change_log.createdatetime IS 'Date and time of insert';
COMMENT ON COLUMN ksbms_robot.ds_change_log.createuserid IS 'Oracle User generating the change( taken from userid of the session) that fired the trigger that stamped the log entry';
COMMENT ON COLUMN ksbms_robot.ds_change_log.remarks IS 'Comment for the change log';