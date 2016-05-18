CREATE TABLE pontis.condumdl (
  mokey VARCHAR2(2 BYTE) NOT NULL,
  elemkey NUMBER(3) NOT NULL,
  envkey NUMBER(1) NOT NULL,
  failprob NUMBER(6,2),
  failagcyco FLOAT,
  failuserco FLOAT,
  optyrcost FLOAT,
  optrunstatus VARCHAR2(5 BYTE),
  CONSTRAINT condumdl_pk PRIMARY KEY (mokey,elemkey,envkey),
  CONSTRAINT fk_condumdl_22_elemdefs FOREIGN KEY (elemkey) REFERENCES pontis.elemdefs (elemkey) ON DELETE CASCADE,
  CONSTRAINT fk_condumdl_32_envtdefs FOREIGN KEY (envkey) REFERENCES pontis.envtdefs (envkey) ON DELETE CASCADE,
  CONSTRAINT fk_condumdl_54_mrrmodls FOREIGN KEY (mokey) REFERENCES pontis.mrrmodls (mokey) ON DELETE CASCADE
);
COMMENT ON COLUMN pontis.condumdl.mokey IS 'Model key number';
COMMENT ON COLUMN pontis.condumdl.elemkey IS 'Element key';
COMMENT ON COLUMN pontis.condumdl.envkey IS 'Environment key';
COMMENT ON COLUMN pontis.condumdl.failprob IS 'Failure probability from worst condition state';
COMMENT ON COLUMN pontis.condumdl.failagcyco IS 'Agency unit fixed cost of element failure';
COMMENT ON COLUMN pontis.condumdl.failuserco IS 'User unit cost of element failure';
COMMENT ON COLUMN pontis.condumdl.optyrcost IS 'Optimal annual cost';
COMMENT ON COLUMN pontis.condumdl.optrunstatus IS 'Optimization run outcome status (FAIL,OK) system field';