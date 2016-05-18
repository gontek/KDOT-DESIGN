CREATE TABLE pontis.formerrs (
  setkey VARCHAR2(2 BYTE) NOT NULL,
  result VARCHAR2(24 BYTE) NOT NULL,
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT formerrs_pk PRIMARY KEY (setkey,result),
  CONSTRAINT fk_formerrs_41_formulas FOREIGN KEY (setkey,result) REFERENCES pontis.formulas (setkey,result) ON DELETE CASCADE
);
COMMENT ON TABLE pontis.formerrs IS 'formerrs';
COMMENT ON COLUMN pontis.formerrs.setkey IS 'Enables formulas to be grouped into sets, for selective application of sets of f';
COMMENT ON COLUMN pontis.formerrs.result IS 'The name of the result field';
COMMENT ON COLUMN pontis.formerrs.notes IS 'Entry comments';