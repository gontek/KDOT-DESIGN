CREATE TABLE pontis.pon_bridge_grps (
  grpskey NUMBER(10) NOT NULL,
  grps_name VARCHAR2(30 BYTE),
  widen_tskey NUMBER(6),
  replace_tskey NUMBER(6),
  criteria VARCHAR2(2000 BYTE),
  status NUMBER(38),
  create_datetime DATE,
  create_userkey NUMBER(38),
  mod_datetime DATE,
  mod_userkey NUMBER(38),
  docrefkey VARCHAR2(255 BYTE),
  description VARCHAR2(255 BYTE),
  CONSTRAINT pon_bridge_grps_pk PRIMARY KEY (grpskey)
);