CREATE TABLE pontis.pon_maint_event (
  brkey VARCHAR2(15 BYTE) NOT NULL,
  eventkey NUMBER(38) NOT NULL,
  total_cost NUMBER(12,2) NOT NULL,
  flag_valid NUMBER(1) NOT NULL,
  yard VARCHAR2(50 BYTE) NOT NULL,
  "ADMINISTRATOR" VARCHAR2(50 BYTE) NOT NULL,
  complete_date DATE,
  inspkey_next VARCHAR2(4 BYTE),
  inspkey_prev VARCHAR2(4 BYTE),
  projcatkey NUMBER(6),
  execution VARCHAR2(50 BYTE),
  fedfund NUMBER(38),
  "ACCOUNT" VARCHAR2(50 BYTE),
  workordernum VARCHAR2(50 BYTE),
  contractnum VARCHAR2(50 BYTE),
  status NUMBER(38),
  createdatetime DATE,
  createuserkey NUMBER(38),
  moddatetime DATE,
  moduserkey NUMBER(38),
  docrefkey VARCHAR2(255 BYTE),
  description VARCHAR2(255 BYTE),
  CONSTRAINT pon_maint_event_pk PRIMARY KEY (brkey,eventkey)
);