CREATE TABLE pontis.scenelem (
  sckey VARCHAR2(2 BYTE) NOT NULL,
  elemkey NUMBER(3) NOT NULL,
  includelm CHAR NOT NULL,
  CONSTRAINT scenelem_pk PRIMARY KEY (sckey,elemkey),
  CONSTRAINT fk_scenelem_24_elemdefs FOREIGN KEY (elemkey) REFERENCES pontis.elemdefs (elemkey) ON DELETE CASCADE,
  CONSTRAINT fk_scenelem_75_scenario FOREIGN KEY (sckey) REFERENCES pontis.scenario (sckey) ON DELETE CASCADE
);
COMMENT ON COLUMN pontis.scenelem.sckey IS 'Scenario key';
COMMENT ON COLUMN pontis.scenelem.elemkey IS 'Element key';