CREATE TABLE pontis.formulas (
  setkey VARCHAR2(2 BYTE) NOT NULL,
  result VARCHAR2(24 BYTE) NOT NULL,
  fortrigger VARCHAR2(24 BYTE),
  formulatxt VARCHAR2(2000 BYTE),
  CONSTRAINT formulas_pk PRIMARY KEY (setkey,result)
);
COMMENT ON TABLE pontis.formulas IS 'formulas';
COMMENT ON COLUMN pontis.formulas.setkey IS 'Enables formulas to be grouped into sets, for selective application of sets of f';
COMMENT ON COLUMN pontis.formulas.result IS 'The name of the result field';
COMMENT ON COLUMN pontis.formulas.fortrigger IS 'Flag to trigger missing value formulas';
COMMENT ON COLUMN pontis.formulas.formulatxt IS 'The text of the formula itself';