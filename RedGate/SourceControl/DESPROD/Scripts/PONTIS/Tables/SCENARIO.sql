CREATE TABLE pontis.scenario (
  sckey VARCHAR2(2 BYTE) NOT NULL,
  bukey VARCHAR2(2 BYTE) NOT NULL,
  cokey VARCHAR2(2 BYTE) NOT NULL,
  imkey VARCHAR2(2 BYTE) NOT NULL,
  mokey VARCHAR2(2 BYTE) NOT NULL,
  pokey VARCHAR2(2 BYTE) NOT NULL,
  scopesetkey VARCHAR2(2 BYTE) NOT NULL,
  lkahdsetkey VARCHAR2(2 BYTE) NOT NULL,
  rehabsetkey VARCHAR2(2 BYTE) NOT NULL,
  fxsetkey VARCHAR2(2 BYTE) NOT NULL,
  agcypolsetkey VARCHAR2(2 BYTE),
  scenname VARCHAR2(30 BYTE) NOT NULL,
  ptthresh2 NUMBER(3),
  ptthresh1 NUMBER(3),
  ptcrit NUMBER(1),
  dim1val VARCHAR2(2 BYTE),
  dim2val VARCHAR2(2 BYTE),
  dim3val VARCHAR2(2 BYTE),
  dim4val VARCHAR2(2 BYTE),
  scmdlkey1 VARCHAR2(2 BYTE),
  scmdlkey2 VARCHAR2(2 BYTE),
  scmdlkey3 VARCHAR2(2 BYTE),
  scmdlkey4 VARCHAR2(2 BYTE),
  scmdlkey5 VARCHAR2(2 BYTE),
  modtime DATE,
  userkey VARCHAR2(4 BYTE),
  docrefkey VARCHAR2(255 BYTE),
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT scenario_pk PRIMARY KEY (sckey),
  CONSTRAINT fk_scenario_105_agencypo FOREIGN KEY (agcypolsetkey) REFERENCES pontis.agencypolsets (agcypolsetkey),
  CONSTRAINT fk_scenario_20_costsets FOREIGN KEY (cokey) REFERENCES pontis.costsets (cokey),
  CONSTRAINT fk_scenario_39_flexsets FOREIGN KEY (fxsetkey) REFERENCES pontis.flexsets (fxsetkey),
  CONSTRAINT fk_scenario_43_imprsets FOREIGN KEY (imkey) REFERENCES pontis.imprsets (imkey),
  CONSTRAINT fk_scenario_47_lkahdset FOREIGN KEY (lkahdsetkey) REFERENCES pontis.lkahdsets (lkahdsetkey),
  CONSTRAINT fk_scenario_55_mrrmodls FOREIGN KEY (mokey) REFERENCES pontis.mrrmodls (mokey) ON DELETE CASCADE,
  CONSTRAINT fk_scenario_58_polsets FOREIGN KEY (pokey) REFERENCES pontis.polsets (pokey),
  CONSTRAINT fk_scenario_70_rehabset FOREIGN KEY (rehabsetkey) REFERENCES pontis.rehabsets (rehabsetkey),
  CONSTRAINT fk_scenario_80_scopeset FOREIGN KEY (scopesetkey) REFERENCES pontis.scopesets (scopesetkey)
);
COMMENT ON TABLE pontis.scenario IS 'scenario';
COMMENT ON COLUMN pontis.scenario.sckey IS 'Scenario key';
COMMENT ON COLUMN pontis.scenario.bukey IS 'Budget matrix key';
COMMENT ON COLUMN pontis.scenario.cokey IS 'Cost matrix key';
COMMENT ON COLUMN pontis.scenario.imkey IS 'Improvement formula values';
COMMENT ON COLUMN pontis.scenario.mokey IS 'Model key number';
COMMENT ON COLUMN pontis.scenario.pokey IS 'Policy matrix key';
COMMENT ON COLUMN pontis.scenario.scopesetkey IS 'Scoping rule set key';
COMMENT ON COLUMN pontis.scenario.lkahdsetkey IS 'Look ahead rule set key';
COMMENT ON COLUMN pontis.scenario.fxsetkey IS 'flexible action family key';
COMMENT ON COLUMN pontis.scenario.agcypolsetkey IS 'Agency preservation policy set key';
COMMENT ON COLUMN pontis.scenario.scenname IS 'User s name for the scenario';
COMMENT ON COLUMN pontis.scenario.ptthresh2 IS 'Scenario, Threshold Q2%, when S1%<Q2% paint all cond. states > 1';
COMMENT ON COLUMN pontis.scenario.ptthresh1 IS 'Scenario, Threshold Q1%, when S1%<Q1% paint all cond. states';
COMMENT ON COLUMN pontis.scenario.ptcrit IS 'Scenario, Apply painting rule flag: 0-not applied, 1-applied';
COMMENT ON COLUMN pontis.scenario.dim1val IS 'First policy dimension selection value';
COMMENT ON COLUMN pontis.scenario.dim2val IS 'Second policy dimension selection value';
COMMENT ON COLUMN pontis.scenario.dim3val IS 'Third policy--cost dimension selection value';
COMMENT ON COLUMN pontis.scenario.dim4val IS 'Fourth policy--cost dimension selection value';
COMMENT ON COLUMN pontis.scenario.scmdlkey1 IS 'Place holder for agency defined rule set keys';
COMMENT ON COLUMN pontis.scenario.scmdlkey2 IS 'Place holder for agency defined rule set keys';
COMMENT ON COLUMN pontis.scenario.scmdlkey3 IS 'Place holder for agency defined rule set keys';
COMMENT ON COLUMN pontis.scenario.scmdlkey4 IS 'Place holder for agency defined rule set keys';
COMMENT ON COLUMN pontis.scenario.scmdlkey5 IS 'Place holder for agency defined rule set keys';
COMMENT ON COLUMN pontis.scenario.modtime IS 'Time the record was last modified. Reserved for future use.';
COMMENT ON COLUMN pontis.scenario.userkey IS 'Primary key to the users table. Key of user that last modified record.';
COMMENT ON COLUMN pontis.scenario.docrefkey IS 'Document reference key';
COMMENT ON COLUMN pontis.scenario.notes IS 'Entry comments';