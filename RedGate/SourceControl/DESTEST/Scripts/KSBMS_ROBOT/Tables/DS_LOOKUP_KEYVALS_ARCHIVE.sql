CREATE TABLE ksbms_robot.ds_lookup_keyvals_archive (
  entry_id VARCHAR2(32 BYTE) NOT NULL,
  keyvalue VARCHAR2(255 BYTE) NOT NULL,
  key_sequence_num NUMBER(*,0) DEFAULT 1 NOT NULL,
  createdatetime DATE NOT NULL,
  createuserid VARCHAR2(30 BYTE) NOT NULL,
  CONSTRAINT pk_matchkey_vals3 PRIMARY KEY (entry_id,key_sequence_num),
  CONSTRAINT fk_arch_keyvals_arch_log FOREIGN KEY (entry_id) REFERENCES ksbms_robot.ds_change_log_archive (entry_id) ON DELETE CASCADE
);
COMMENT ON TABLE ksbms_robot.ds_lookup_keyvals_archive IS 'Table of matchkeys from 1:N for each change log entry -';
COMMENT ON COLUMN ksbms_robot.ds_lookup_keyvals_archive.entry_id IS 'Entry ID for key vals';
COMMENT ON COLUMN ksbms_robot.ds_lookup_keyvals_archive.keyvalue IS 'Value for keyfield';
COMMENT ON COLUMN ksbms_robot.ds_lookup_keyvals_archive.key_sequence_num IS 'Numeric order of keys';