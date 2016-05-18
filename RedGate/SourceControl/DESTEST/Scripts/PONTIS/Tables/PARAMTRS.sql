CREATE TABLE pontis.paramtrs (
  table_name VARCHAR2(30 BYTE) NOT NULL,
  field_name VARCHAR2(30 BYTE) NOT NULL,
  parmvalue VARCHAR2(8 BYTE) NOT NULL,
  shortdesc VARCHAR2(35 BYTE) NOT NULL,
  longdesc VARCHAR2(2000 BYTE),
  misvalflg CHAR,
  helpid NUMBER(5),
  isactive NUMBER(1) DEFAULT 1 NOT NULL,
  CONSTRAINT paramtrs_pk PRIMARY KEY (table_name,field_name,parmvalue)
)
CACHE;
COMMENT ON TABLE pontis.paramtrs IS 'paramtrs';
COMMENT ON COLUMN pontis.paramtrs.table_name IS 'Table name';
COMMENT ON COLUMN pontis.paramtrs.field_name IS 'Field name';
COMMENT ON COLUMN pontis.paramtrs.parmvalue IS 'Parameters Table - Value Code';
COMMENT ON COLUMN pontis.paramtrs.shortdesc IS 'Parameters Table - Value Description For Drop Down List Box';
COMMENT ON COLUMN pontis.paramtrs.longdesc IS 'Complete description of value';
COMMENT ON COLUMN pontis.paramtrs.misvalflg IS 'Flag to indicate record represents a missing value code';
COMMENT ON COLUMN pontis.paramtrs.helpid IS 'Help ID code from help module.';