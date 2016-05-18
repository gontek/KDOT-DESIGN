CREATE TABLE pontis.statmdls (
  mokey VARCHAR2(2 BYTE) NOT NULL,
  elemkey NUMBER(3) NOT NULL,
  skey NUMBER(1) NOT NULL,
  envkey NUMBER(1) NOT NULL,
  netfrac NUMBER(6,2),
  optfrac NUMBER(6,4),
  actrec NUMBER(1),
  varunitco FLOAT,
  fixunitco FLOAT,
  unitben FLOAT,
  CONSTRAINT statmdls_pk PRIMARY KEY (mokey,elemkey,skey,envkey),
  CONSTRAINT fk_statmdls_18_condumdl FOREIGN KEY (mokey,elemkey,envkey) REFERENCES pontis.condumdl (mokey,elemkey,envkey) ON DELETE CASCADE,
  CONSTRAINT fk_statmdls_83_statedfs FOREIGN KEY (elemkey,skey) REFERENCES pontis.statedfs (elemkey,skey) ON DELETE CASCADE
);
COMMENT ON TABLE pontis.statmdls IS 'statmdls';
COMMENT ON COLUMN pontis.statmdls.mokey IS 'Model key number';
COMMENT ON COLUMN pontis.statmdls.elemkey IS 'Element key';
COMMENT ON COLUMN pontis.statmdls.skey IS 'Condition state key';
COMMENT ON COLUMN pontis.statmdls.envkey IS 'Environment key';
COMMENT ON COLUMN pontis.statmdls.netfrac IS 'Not used in this table';
COMMENT ON COLUMN pontis.statmdls.optfrac IS 'Long-term optimal fraction in the state--action';
COMMENT ON COLUMN pontis.statmdls.actrec IS 'Recommended action key for the state';
COMMENT ON COLUMN pontis.statmdls.varunitco IS 'Variable unit cost';
COMMENT ON COLUMN pontis.statmdls.fixunitco IS 'Fixed unit cost';
COMMENT ON COLUMN pontis.statmdls.unitben IS 'Unit benefit of the recommended action';