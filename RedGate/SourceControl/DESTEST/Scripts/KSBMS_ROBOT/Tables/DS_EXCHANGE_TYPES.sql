CREATE TABLE ksbms_robot.ds_exchange_types (
  exchange_type VARCHAR2(3 BYTE) NOT NULL,
  exchange_type_label VARCHAR2(30 BYTE) NOT NULL,
  createdatetime DATE NOT NULL,
  createuserid VARCHAR2(30 BYTE) NOT NULL,
  modtime DATE NOT NULL,
  changeuserid VARCHAR2(30 BYTE) NOT NULL,
  remarks VARCHAR2(255 BYTE),
  CONSTRAINT pk_exchange_activity_types PRIMARY KEY (exchange_type)
);
COMMENT ON TABLE ksbms_robot.ds_exchange_types IS 'Fixed predetermined set of types used to log activity code e.g. UPDATE';