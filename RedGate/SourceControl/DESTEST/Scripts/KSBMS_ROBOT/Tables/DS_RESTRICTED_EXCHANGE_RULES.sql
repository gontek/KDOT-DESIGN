CREATE TABLE ksbms_robot.ds_restricted_exchange_rules (
  exchange_type VARCHAR2(3 BYTE) NOT NULL,
  exchange_rule_id NUMBER NOT NULL,
  status VARCHAR2(1 BYTE),
  CONSTRAINT fk_ds_restr_fk_restr_ds_exch FOREIGN KEY (exchange_type) REFERENCES ksbms_robot.ds_exchange_types (exchange_type),
  CONSTRAINT fk_ds_restr_fk_restr_ds_trans FOREIGN KEY (exchange_rule_id) REFERENCES ksbms_robot.ds_transfer_map (exchange_rule_id)
);
COMMENT ON TABLE ksbms_robot.ds_restricted_exchange_rules IS 'Entries here are used to restrict specific field transfers otherwise supported by the exchange mechanism.  For example, if the code is 2, the type of exchange is always allowed, if 1, allowed for new records (INSERT),  if 0, never allowed (DATA CANNOT BE TRANSFERRED AND ERROR IS RAISED).  As a child of the transfer map table DS_TRANSFER_MAP, the entry here augments the standard rule processing logic.

Whole bridge actions, like insert, typically will not have a rule as it is necessary to get the records into the target database (Pontis).';
COMMENT ON COLUMN ksbms_robot.ds_restricted_exchange_rules.status IS 'Map of allowed exchange activities by rule';