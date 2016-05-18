CREATE TABLE pontis.budgmtrx (
  bukey VARCHAR2(2 BYTE) NOT NULL,
  ykey NUMBER(4) NOT NULL,
  budget NUMBER(10) NOT NULL,
  CONSTRAINT budgmtrx_pk PRIMARY KEY (bukey,ykey),
  CONSTRAINT fk_budgmtrx_16_budgsets FOREIGN KEY (bukey) REFERENCES pontis.budgsets (bukey) ON DELETE CASCADE
);
COMMENT ON COLUMN pontis.budgmtrx.bukey IS 'Budget matrix key';
COMMENT ON COLUMN pontis.budgmtrx.budget IS 'Budget for the year';