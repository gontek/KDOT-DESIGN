CREATE TABLE ksbms_robot.ds_exchange_status (
  exchange_status VARCHAR2(10 BYTE) NOT NULL,
  status_label VARCHAR2(30 BYTE) DEFAULT 'Please provide a status label' NOT NULL,
  createdatetime DATE,
  createuserid VARCHAR2(30 BYTE),
  modtime DATE,
  changeuserid VARCHAR2(30 BYTE),
  remarks VARCHAR2(255 BYTE),
  CONSTRAINT pk_exchange_status PRIMARY KEY (exchange_status)
);
COMMENT ON TABLE ksbms_robot.ds_exchange_status IS 'Labels for the exchange status field.';
COMMENT ON COLUMN ksbms_robot.ds_exchange_status.exchange_status IS 'Default means not processed at all yet';
COMMENT ON COLUMN ksbms_robot.ds_exchange_status.status_label IS 'Short status description for reporting';
COMMENT ON COLUMN ksbms_robot.ds_exchange_status.createdatetime IS 'Description of business rule meaning of the exchange status';