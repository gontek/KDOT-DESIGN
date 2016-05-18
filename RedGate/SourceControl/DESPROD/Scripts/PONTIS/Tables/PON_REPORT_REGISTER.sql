CREATE TABLE pontis.pon_report_register (
  report_id NUMBER(38) NOT NULL DISABLE,
  "NAME" VARCHAR2(64 BYTE) NOT NULL DISABLE,
  description VARCHAR2(256 BYTE),
  report_type VARCHAR2(32 BYTE) NOT NULL DISABLE,
  "CONTEXT" VARCHAR2(32 BYTE) NOT NULL,
  report_origin VARCHAR2(16 BYTE) NOT NULL,
  report_xml_file VARCHAR2(128 BYTE) NOT NULL,
  createdatetime DATE,
  createuserkey VARCHAR2(4 BYTE),
  modtime DATE,
  moduserkey VARCHAR2(4 BYTE),
  CONSTRAINT pon_report_register_pk PRIMARY KEY (report_id) DISABLE NOVALIDATE,
  CONSTRAINT fk_report_reg_to_context FOREIGN KEY ("CONTEXT") REFERENCES pontis.pon_app_contexts ("CONTEXT") DISABLE NOVALIDATE
);