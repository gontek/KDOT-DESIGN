CREATE TABLE pontis.kaws_paramtrs (
  table_name VARCHAR2(24 BYTE) NOT NULL,
  field_name VARCHAR2(24 BYTE) NOT NULL,
  parmvalue VARCHAR2(8 BYTE) NOT NULL,
  shortdesc VARCHAR2(35 BYTE),
  longdesc VARCHAR2(2000 BYTE),
  misvalflg CHAR,
  CONSTRAINT pk_kaws_paramtrs PRIMARY KEY (table_name,field_name,parmvalue)
);