CREATE TABLE ksbms_robot.ds_lookup_keyvals_temp (
  entry_id VARCHAR2(32 BYTE) NOT NULL,
  keyvalue VARCHAR2(255 BYTE) NOT NULL,
  key_sequence_num NUMBER DEFAULT 1 NOT NULL,
  createdatetime DATE NOT NULL,
  createuserid VARCHAR2(30 BYTE) NOT NULL,
  CONSTRAINT pk_matchkey_vals PRIMARY KEY (entry_id,key_sequence_num),
  CONSTRAINT fk_ds_changelog_temp FOREIGN KEY (entry_id) REFERENCES ksbms_robot.ds_change_log_temp (entry_id) ON DELETE CASCADE
);
COMMENT ON TABLE ksbms_robot.ds_lookup_keyvals_temp IS 'Table of matchkeys from 1:N for each change log entry - Used for processing changes';
COMMENT ON COLUMN ksbms_robot.ds_lookup_keyvals_temp.entry_id IS 'Entry ID for key vals';
COMMENT ON COLUMN ksbms_robot.ds_lookup_keyvals_temp.keyvalue IS 'Value for keyfield';
COMMENT ON COLUMN ksbms_robot.ds_lookup_keyvals_temp.key_sequence_num IS 'Numeric order of keys';