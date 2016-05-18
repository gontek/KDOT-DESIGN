CREATE TABLE pontis.costindx (
  indexdate DATE NOT NULL,
  indexvalue NUMBER(6,2),
  CONSTRAINT costindx_pk PRIMARY KEY (indexdate)
);
COMMENT ON COLUMN pontis.costindx.indexdate IS 'First day of quarter';
COMMENT ON COLUMN pontis.costindx.indexvalue IS 'Index value';