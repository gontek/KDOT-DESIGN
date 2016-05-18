CREATE TABLE pontis.datadict (
  table_name VARCHAR2(30 BYTE) NOT NULL,
  col_name VARCHAR2(30 BYTE) NOT NULL,
  col_alias VARCHAR2(30 BYTE),
  v2convert VARCHAR2(10 BYTE),
  datatype VARCHAR2(16 BYTE),
  width NUMBER(10),
  dec_plcs NUMBER(1),
  null_allow CHAR,
  uniquekey CHAR,
  position NUMBER(16),
  nbi_cd VARCHAR2(10 BYTE),
  valtype VARCHAR2(12 BYTE),
  valattr1 VARCHAR2(40 BYTE),
  valattr2 VARCHAR2(40 BYTE),
  sysfield CHAR,
  sysdefault VARCHAR2(40 BYTE),
  keyattr1 CHAR,
  unique_fld VARCHAR2(30 BYTE),
  helpid NUMBER(5),
  paircode NUMBER(2) NOT NULL,
  conversionrules VARCHAR2(12 BYTE),
  snotes VARCHAR2(255 BYTE),
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT datadict_pk PRIMARY KEY (table_name,col_name),
  CONSTRAINT fk_datadict_98_metric_e FOREIGN KEY (paircode) REFERENCES pontis.metric_english (paircode)
)
CACHE;
COMMENT ON COLUMN pontis.datadict.table_name IS 'Table name';
COMMENT ON COLUMN pontis.datadict.col_name IS 'Column name';
COMMENT ON COLUMN pontis.datadict.col_alias IS 'Name of analogous field in Pontis 2.0.';
COMMENT ON COLUMN pontis.datadict.v2convert IS 'Pontis 2.0 data type';
COMMENT ON COLUMN pontis.datadict.datatype IS 'Data type';
COMMENT ON COLUMN pontis.datadict.width IS 'Width for storage and display';
COMMENT ON COLUMN pontis.datadict.dec_plcs IS 'Number of decimal places';
COMMENT ON COLUMN pontis.datadict.null_allow IS 'Flag indicating whether null values are allowed.';
COMMENT ON COLUMN pontis.datadict.uniquekey IS 'Flag indicating whether field value must be unique.';
COMMENT ON COLUMN pontis.datadict.position IS 'Position of the field in internal ordering system.';
COMMENT ON COLUMN pontis.datadict.nbi_cd IS 'NBI code';
COMMENT ON COLUMN pontis.datadict.valtype IS 'Indicates whether possible values come from a range or list of values.';
COMMENT ON COLUMN pontis.datadict.valattr1 IS 'Holds minimum value of a range of values, or holds list.';
COMMENT ON COLUMN pontis.datadict.valattr2 IS 'Holds maximum value of a range of allowed values.';
COMMENT ON COLUMN pontis.datadict.sysfield IS 'Flag indicator of a field that is used by the system.';
COMMENT ON COLUMN pontis.datadict.sysdefault IS 'System default';
COMMENT ON COLUMN pontis.datadict.keyattr1 IS 'Holds primary key status of field if field is used in a formula.';
COMMENT ON COLUMN pontis.datadict.unique_fld IS 'Distinct alias for each field.';
COMMENT ON COLUMN pontis.datadict.helpid IS 'Help ID code from help module.';
COMMENT ON COLUMN pontis.datadict.paircode IS 'Metric English Pair Code';
COMMENT ON COLUMN pontis.datadict.conversionrules IS 'To hold codes for converting special quantities like 999';
COMMENT ON COLUMN pontis.datadict.snotes IS 'Short description of the Pontis database field.';
COMMENT ON COLUMN pontis.datadict.notes IS 'Entry comments';