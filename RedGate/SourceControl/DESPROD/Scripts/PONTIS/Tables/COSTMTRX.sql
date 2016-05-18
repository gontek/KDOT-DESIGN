CREATE TABLE pontis.costmtrx (
  cokey VARCHAR2(2 BYTE) NOT NULL,
  dim1val VARCHAR2(2 BYTE) NOT NULL,
  dim2val VARCHAR2(2 BYTE) NOT NULL,
  dim3val VARCHAR2(2 BYTE) NOT NULL,
  dim4val VARCHAR2(2 BYTE) NOT NULL,
  ucreplace FLOAT,
  ucwidenvar FLOAT,
  ucraise FLOAT,
  ucstrength FLOAT,
  hrdetourco FLOAT,
  kmdetourco FLOAT,
  acccost FLOAT,
  userweight NUMBER(6,2),
  CONSTRAINT costmtrx_pk PRIMARY KEY (cokey,dim1val,dim2val,dim3val,dim4val),
  CONSTRAINT fk_costmtrx_19_costsets FOREIGN KEY (cokey) REFERENCES pontis.costsets (cokey) ON DELETE CASCADE
);
COMMENT ON COLUMN pontis.costmtrx.cokey IS 'Cost matrix key';
COMMENT ON COLUMN pontis.costmtrx.dim1val IS 'Field value, dimension 1 District (First policy dimension selection value)';
COMMENT ON COLUMN pontis.costmtrx.dim2val IS 'Field value, dimension 2 Functional Class (Second policy dimension selection value)';
COMMENT ON COLUMN pontis.costmtrx.dim3val IS 'Field value, dimension 3 Ownership (Third policy--cost dimension selection value)';
COMMENT ON COLUMN pontis.costmtrx.dim4val IS 'Field value, dimension 4 NHS Status (Fourth policy--cost dimension selection value)';
COMMENT ON COLUMN pontis.costmtrx.ucreplace IS 'Structure replacement unit cost';
COMMENT ON COLUMN pontis.costmtrx.ucwidenvar IS 'Structure widening unit cost - variable portion';
COMMENT ON COLUMN pontis.costmtrx.ucraise IS 'Structure raising unit cost';
COMMENT ON COLUMN pontis.costmtrx.ucstrength IS 'Structure strengthening unit cost';
COMMENT ON COLUMN pontis.costmtrx.hrdetourco IS 'Hourly cost of vehicle detours';
COMMENT ON COLUMN pontis.costmtrx.kmdetourco IS 'Kilometer cost of vehicle detours';
COMMENT ON COLUMN pontis.costmtrx.acccost IS 'Cost per accident';
COMMENT ON COLUMN pontis.costmtrx.userweight IS 'User cost weight';