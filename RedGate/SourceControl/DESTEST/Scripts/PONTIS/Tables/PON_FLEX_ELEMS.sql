CREATE TABLE pontis.pon_flex_elems (
  flexelemid NUMBER(32) NOT NULL,
  flexkey VARCHAR2(8 BYTE) NOT NULL,
  elemkey NUMBER(4) NOT NULL,
  create_date VARCHAR2(32 BYTE),
  create_userkey VARCHAR2(4 BYTE),
  mod_date VARCHAR2(32 BYTE),
  mod_userkey VARCHAR2(4 BYTE),
  unitcost FLOAT,
  CONSTRAINT pon_flex_elems_pk PRIMARY KEY (flexelemid)
);