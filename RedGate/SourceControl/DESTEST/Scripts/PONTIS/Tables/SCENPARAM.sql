CREATE TABLE pontis.scenparam (
  sckey VARCHAR2(2 BYTE) NOT NULL,
  scparam VARCHAR2(2 BYTE) NOT NULL,
  scparamvalue VARCHAR2(40 BYTE),
  scparamname VARCHAR2(24 BYTE),
  scparamdescr VARCHAR2(40 BYTE),
  helpid NUMBER(5),
  CONSTRAINT scenparam_pk PRIMARY KEY (sckey,scparam),
  CONSTRAINT fk_scenpara_77_scenario FOREIGN KEY (sckey) REFERENCES pontis.scenario (sckey) ON DELETE CASCADE
);
COMMENT ON COLUMN pontis.scenparam.sckey IS 'Scenario key';
COMMENT ON COLUMN pontis.scenparam.helpid IS 'Help ID code from help module.';