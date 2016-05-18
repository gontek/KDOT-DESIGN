CREATE TABLE pontis.pon_report_security (
  rolekey NUMBER(10) NOT NULL DISABLE,
  report_id NUMBER(10) NOT NULL DISABLE,
  visible_ind CHAR NOT NULL DISABLE,
  CONSTRAINT pon_report_security_pk PRIMARY KEY (rolekey,report_id) DISABLE NOVALIDATE
);