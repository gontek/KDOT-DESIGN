CREATE TABLE ksbms_robot.ds_transfer_delta_tolerances (
  exchange_rule_id NUMBER(*,0) NOT NULL,
  transfer_delta_value FLOAT DEFAULT .001 NOT NULL,
  tolerance_chk_status NUMBER(1) DEFAULT 1 NOT NULL CONSTRAINT chk_tol_chk_status CHECK (TOLERANCE_CHK_STATUS IN (0,1)),
  modtime DATE,
  moduserkey NUMBER(*,0),
  notes VARCHAR2(4000 CHAR),
  CONSTRAINT pk_transfer_deltas PRIMARY KEY (exchange_rule_id),
  CONSTRAINT fk_ds_transfer_map_rule_id FOREIGN KEY (exchange_rule_id) REFERENCES ksbms_robot.ds_transfer_map (exchange_rule_id) ON DELETE CASCADE
);
COMMENT ON COLUMN ksbms_robot.ds_transfer_delta_tolerances.exchange_rule_id IS 'Identifier for field points to DS_TRANSFER_MAP';
COMMENT ON COLUMN ksbms_robot.ds_transfer_delta_tolerances.transfer_delta_value IS 'Tolerance for percent change';
COMMENT ON COLUMN ksbms_robot.ds_transfer_delta_tolerances.tolerance_chk_status IS 'Tolerance factor is active =1  disabled =0';
COMMENT ON COLUMN ksbms_robot.ds_transfer_delta_tolerances.modtime IS 'When changed';
COMMENT ON COLUMN ksbms_robot.ds_transfer_delta_tolerances.moduserkey IS 'By whom?';
COMMENT ON COLUMN ksbms_robot.ds_transfer_delta_tolerances.notes IS 'Notes about this factor';