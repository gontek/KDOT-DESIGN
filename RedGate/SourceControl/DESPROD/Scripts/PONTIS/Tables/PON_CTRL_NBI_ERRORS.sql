CREATE TABLE pontis.pon_ctrl_nbi_errors (
  error_code NUMBER(3) NOT NULL,
  error_level NUMBER(1) NOT NULL,
  error_type NUMBER(3) NOT NULL,
  error_message VARCHAR2(256 BYTE) NOT NULL,
  CONSTRAINT pon_ctrl_nbi_errors_pk PRIMARY KEY (error_code)
);