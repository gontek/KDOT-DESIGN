CREATE TABLE pontis.pon_benefit_groups (
  benefit_group_id NUMBER(38) NOT NULL,
  "NAME" VARCHAR2(255 BYTE) NOT NULL,
  description VARCHAR2(2000 BYTE),
  create_date VARCHAR2(32 BYTE),
  create_userkey VARCHAR2(4 BYTE),
  mod_date VARCHAR2(32 BYTE),
  mod_userkey VARCHAR2(4 BYTE),
  sort_order NUMBER(4),
  CONSTRAINT pon_benefit_groups_pk PRIMARY KEY (benefit_group_id)
);