CREATE TABLE pontis.pon_insp_status_log (
  log_id NUMBER(38) NOT NULL,
  brkey VARCHAR2(15 BYTE) NOT NULL,
  inspkey VARCHAR2(4 BYTE) NOT NULL,
  new_status NUMBER(38),
  old_status NUMBER(38),
  status_change_date DATE,
  userkey VARCHAR2(4 BYTE),
  CONSTRAINT pon_insp_status_log_pk PRIMARY KEY (log_id)
);