CREATE TABLE pontis.health_index_results (
  brkey VARCHAR2(10 BYTE),
  strtype VARCHAR2(4 BYTE),
  inspdate DATE,
  inspkey VARCHAR2(4 BYTE),
  deck_comp_hi NUMBER(5,2),
  super_comp_hi NUMBER(5,2),
  sub_comp_hi NUMBER(5,2),
  culvert_comp_hi NUMBER(5,2),
  avg_hi NUMBER(5,2),
  deck_hi NUMBER(5,2),
  structure_hi NUMBER(5,2),
  special_note VARCHAR2(2000 BYTE),
  brdgculv CHAR
);