CREATE TABLE pontis.actmodls (
  mokey VARCHAR2(2 BYTE) NOT NULL,
  elemkey NUMBER(3) NOT NULL,
  skey NUMBER(1) NOT NULL,
  akey NUMBER(1) NOT NULL,
  envkey NUMBER(1) NOT NULL,
  detweight NUMBER(8),
  costweight NUMBER(8),
  prob1 NUMBER(7,2) NOT NULL,
  prob2 NUMBER(7,2) NOT NULL,
  prob3 NUMBER(7,2) NOT NULL,
  prob4 NUMBER(7,2) NOT NULL,
  prob5 NUMBER(7,2) NOT NULL,
  varunitco FLOAT NOT NULL,
  fixunitco FLOAT NOT NULL,
  optfrac NUMBER(6,4),
  ltcost FLOAT NOT NULL,
  CONSTRAINT actmodls_pk PRIMARY KEY (mokey,elemkey,skey,akey,envkey),
  CONSTRAINT fk_actmodls_56_mrrmodls FOREIGN KEY (mokey) REFERENCES pontis.mrrmodls (mokey) ON DELETE CASCADE
);
COMMENT ON TABLE pontis.actmodls IS 'actmodls';
COMMENT ON COLUMN pontis.actmodls.mokey IS 'Model key number';
COMMENT ON COLUMN pontis.actmodls.elemkey IS 'Element key';
COMMENT ON COLUMN pontis.actmodls.skey IS 'Condition state key';
COMMENT ON COLUMN pontis.actmodls.akey IS 'Action key';
COMMENT ON COLUMN pontis.actmodls.envkey IS 'Environment key';
COMMENT ON COLUMN pontis.actmodls.detweight IS 'Current deterioration updating weight';
COMMENT ON COLUMN pontis.actmodls.costweight IS 'Current cost updating weight';
COMMENT ON COLUMN pontis.actmodls.prob1 IS 'Probability of state 1 in one year';
COMMENT ON COLUMN pontis.actmodls.prob2 IS 'Probability of state 2 in one year';
COMMENT ON COLUMN pontis.actmodls.prob3 IS 'Probability of state 3 in one year';
COMMENT ON COLUMN pontis.actmodls.prob4 IS 'Probability of state 4 in one year';
COMMENT ON COLUMN pontis.actmodls.prob5 IS 'Probability of state 5 in one year';
COMMENT ON COLUMN pontis.actmodls.varunitco IS 'Variable unit cost';
COMMENT ON COLUMN pontis.actmodls.fixunitco IS 'Fixed unit cost';
COMMENT ON COLUMN pontis.actmodls.optfrac IS 'Long-term optimal fraction in the state--action';
COMMENT ON COLUMN pontis.actmodls.ltcost IS 'Long-term average cost in the state--action';