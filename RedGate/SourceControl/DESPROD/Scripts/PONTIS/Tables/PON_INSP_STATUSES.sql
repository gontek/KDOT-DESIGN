CREATE TABLE pontis.pon_insp_statuses (
  status_key NUMBER(38) NOT NULL,
  status_name VARCHAR2(30 BYTE) NOT NULL,
  status_is_approved VARCHAR2(5 BYTE) NOT NULL,
  status_description VARCHAR2(50 BYTE),
  status_is_locked VARCHAR2(5 BYTE),
  CONSTRAINT pon_insp_statuses_pk PRIMARY KEY (status_key)
);