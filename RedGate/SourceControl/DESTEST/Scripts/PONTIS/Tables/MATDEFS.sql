CREATE TABLE pontis.matdefs (
  matlkey CHAR NOT NULL,
  matlname CHAR(20 BYTE),
  matlcode NUMBER(2),
  matlpos NUMBER(2),
  matlcolor NUMBER(3),
  CONSTRAINT matdefs_pk PRIMARY KEY (matlkey)
);
COMMENT ON COLUMN pontis.matdefs.matlkey IS 'Material key number';
COMMENT ON COLUMN pontis.matdefs.matlname IS 'Material name, for column labelling';
COMMENT ON COLUMN pontis.matdefs.matlcode IS 'Code number, for use in formula files';
COMMENT ON COLUMN pontis.matdefs.matlpos IS 'Material position, for arranging columns on the screen';
COMMENT ON COLUMN pontis.matdefs.matlcolor IS 'Color of icons';