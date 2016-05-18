CREATE TABLE pontis.nbilookup (
  table_name VARCHAR2(24 BYTE) NOT NULL,
  field_name VARCHAR2(24 BYTE) NOT NULL,
  kdot_code VARCHAR2(8 BYTE) NOT NULL,
  nbi_code VARCHAR2(8 BYTE) NOT NULL,
  nbifield VARCHAR2(10 BYTE),
  pontistable VARCHAR2(24 BYTE),
  pontisfield VARCHAR2(24 BYTE),
  kdotshortdesc VARCHAR2(100 BYTE),
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT pk_nbilookup PRIMARY KEY (table_name,field_name,kdot_code)
);