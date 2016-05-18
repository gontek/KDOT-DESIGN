CREATE TABLE pontis.expactn (
  userkey VARCHAR2(4 BYTE) NOT NULL,
  elemkey NUMBER(3) NOT NULL,
  envkey NUMBER(1) NOT NULL,
  skey NUMBER(1) NOT NULL,
  akey NUMBER(1) NOT NULL,
  prob1 NUMBER(7,2) NOT NULL,
  prob2 NUMBER(7,2) NOT NULL,
  prob3 NUMBER(7,2) NOT NULL,
  prob4 NUMBER(7,2) NOT NULL,
  prob5 NUMBER(7,2) NOT NULL,
  medyears NUMBER(5,1) NOT NULL,
  CONSTRAINT expactn_pk PRIMARY KEY (userkey,elemkey,envkey,skey,akey),
  CONSTRAINT fk_expactn_36_expcondu FOREIGN KEY (userkey,elemkey,envkey) REFERENCES pontis.expcondu (userkey,elemkey,envkey) ON DELETE CASCADE,
  CONSTRAINT fk_expactn_53_mrractdf FOREIGN KEY (elemkey,skey,akey) REFERENCES pontis.mrractdf (elemkey,skey,akey) ON DELETE CASCADE
);
COMMENT ON COLUMN pontis.expactn.userkey IS 'Primary key to the users table. Key of user that last modified record.';
COMMENT ON COLUMN pontis.expactn.elemkey IS 'Element key';
COMMENT ON COLUMN pontis.expactn.envkey IS 'Environment key';
COMMENT ON COLUMN pontis.expactn.skey IS 'Condition state key';
COMMENT ON COLUMN pontis.expactn.akey IS 'Action key';
COMMENT ON COLUMN pontis.expactn.prob1 IS 'Probability of state 1 in one year';
COMMENT ON COLUMN pontis.expactn.prob2 IS 'Probability of state 2 in one year';
COMMENT ON COLUMN pontis.expactn.prob3 IS 'Probability of state 3 in one year';
COMMENT ON COLUMN pontis.expactn.prob4 IS 'Probability of state 4 in one year';
COMMENT ON COLUMN pontis.expactn.prob5 IS 'Probability of state 5 in one year';
COMMENT ON COLUMN pontis.expactn.medyears IS 'median number of years to deteriorate';