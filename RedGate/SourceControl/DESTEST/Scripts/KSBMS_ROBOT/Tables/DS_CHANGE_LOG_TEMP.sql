CREATE TABLE ksbms_robot.ds_change_log_temp (
  entry_id VARCHAR2(32 BYTE) NOT NULL,
  sequence_num NUMBER NOT NULL,
  job_id VARCHAR2(32 BYTE) NOT NULL,
  "SCHEMA" VARCHAR2(2 BYTE) NOT NULL,
  exchange_rule_id NUMBER NOT NULL,
  exchange_type VARCHAR2(3 BYTE) NOT NULL,
  old_value VARCHAR2(255 BYTE),
  new_value VARCHAR2(255 BYTE),
  exchange_status VARCHAR2(10 BYTE) NOT NULL,
  createdatetime DATE DEFAULT SYSDATE NOT NULL,
  createuserid VARCHAR2(30 BYTE) DEFAULT 'USER' NOT NULL,
  remarks VARCHAR2(255 BYTE),
  CONSTRAINT pk_ds_change_log_temp PRIMARY KEY (entry_id),
  CONSTRAINT fk_ds_chg_fk_temp_l_ds_exch FOREIGN KEY (exchange_type) REFERENCES ksbms_robot.ds_exchange_types (exchange_type),
  CONSTRAINT fk_ds_chg_fk_temp_l_ds_exch2 FOREIGN KEY (exchange_status) REFERENCES ksbms_robot.ds_exchange_status (exchange_status),
  CONSTRAINT fk_ds_chg_fk_temp_l_ds_jobru FOREIGN KEY (job_id) REFERENCES ksbms_robot.ds_jobruns_history (job_id),
  CONSTRAINT fk_ds_chg_fk_temp_l_ds_trans FOREIGN KEY (exchange_rule_id) REFERENCES ksbms_robot.ds_transfer_map (exchange_rule_id)
);
COMMENT ON COLUMN ksbms_robot.ds_change_log_temp.entry_id IS 'Unique key for entries, cross-ref key to list of key values (1:N) for the originating source entry';
COMMENT ON COLUMN ksbms_robot.ds_change_log_temp.sequence_num IS 'Ordinal sequence number for change entry, copied from DS_CHANGE_LOG to here during processing, not regenerated.  Allows processing changes in create order';
COMMENT ON COLUMN ksbms_robot.ds_change_log_temp.exchange_type IS 'UPD, INS,DEL, MSG allowed values as of June 28, 2001';
COMMENT ON COLUMN ksbms_robot.ds_change_log_temp.old_value IS 'OLD (previous) value for the table.column row that was changed';
COMMENT ON COLUMN ksbms_robot.ds_change_log_temp.new_value IS 'NEW value for the table.column row that was changed';
COMMENT ON COLUMN ksbms_robot.ds_change_log_temp.exchange_status IS 'Latest status of this change log record from processing activity';
COMMENT ON COLUMN ksbms_robot.ds_change_log_temp.createdatetime IS 'Date and time of insert';
COMMENT ON COLUMN ksbms_robot.ds_change_log_temp.createuserid IS 'Oracle User generating the change( taken from userid of the session) that fired the trigger that stamped the log entry';
COMMENT ON COLUMN ksbms_robot.ds_change_log_temp.remarks IS 'Comment for the change log';