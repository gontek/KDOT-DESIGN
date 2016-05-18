CREATE TABLE pontis.pon_maint_activity (
  brkey VARCHAR2(15 BYTE) NOT NULL,
  eventkey NUMBER(38) NOT NULL,
  activitykey NUMBER(38) NOT NULL,
  product VARCHAR2(255 BYTE) NOT NULL,
  "METHOD" VARCHAR2(255 BYTE) NOT NULL,
  qty_completed NUMBER(12,2) NOT NULL,
  element_qty NUMBER(12,2) NOT NULL,
  description VARCHAR2(255 BYTE) NOT NULL,
  flexkey NUMBER(6),
  ecatkey CHAR,
  elemkeylist VARCHAR2(255 BYTE),
  strunitkey NUMBER(4),
  envkey NUMBER(1),
  on_order VARCHAR2(2 BYTE),
  asmtkey NUMBER(6),
  direct_cost FLOAT(53),
  CONSTRAINT pon_maint_activity_pk PRIMARY KEY (brkey,eventkey,activitykey)
);