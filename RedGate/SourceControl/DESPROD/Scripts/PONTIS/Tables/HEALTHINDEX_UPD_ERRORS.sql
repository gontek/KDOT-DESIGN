CREATE TABLE pontis.healthindex_upd_errors (
  brkey VARCHAR2(15 BYTE),
  strunitkey NUMBER(4),
  inspdate DATE,
  strtype VARCHAR2(4 BYTE),
  deck_hi NUMBER(5,1),
  super_hi NUMBER(5,1),
  sub_hi NUMBER(5,1),
  culvert_hi NUMBER(5,1),
  "ERROR" VARCHAR2(2000 BYTE)
);