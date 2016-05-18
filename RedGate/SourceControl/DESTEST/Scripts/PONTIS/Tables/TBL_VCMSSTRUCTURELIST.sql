CREATE TABLE pontis.tbl_vcmsstructurelist (
  routeid VARCHAR2(12 BYTE),
  county NUMBER(3),
  str_number VARCHAR2(11 BYTE),
  state_mp NUMBER(7,3),
  loc_descr VARCHAR2(50 BYTE),
  func_descr VARCHAR2(50 BYTE),
  ftcr_descr VARCHAR2(50 BYTE),
  str_type VARCHAR2(4 BYTE),
  num_girders NUMBER(3),
  latitude NUMBER(9,5),
  longitude NUMBER(9,5),
  year_built VARCHAR2(12 BYTE),
  kta_ind VARCHAR2(1 BYTE),
  county_mp NUMBER(7,3),
  divundiv VARCHAR2(2 BYTE),
  uniqueid NUMBER(8)
);