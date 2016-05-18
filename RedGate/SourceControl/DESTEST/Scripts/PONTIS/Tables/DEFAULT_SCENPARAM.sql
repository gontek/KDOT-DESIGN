CREATE TABLE pontis.default_scenparam (
  sckey VARCHAR2(2 BYTE) NOT NULL,
  scparam VARCHAR2(2 BYTE) NOT NULL,
  scparamvalue VARCHAR2(40 BYTE),
  scparamname VARCHAR2(24 BYTE),
  scparamdescr VARCHAR2(40 BYTE),
  helpid NUMBER(5),
  CONSTRAINT default_scenparam_pk PRIMARY KEY (sckey,scparam)
);
COMMENT ON COLUMN pontis.default_scenparam.sckey IS 'Scenario key';
COMMENT ON COLUMN pontis.default_scenparam.helpid IS 'Help ID code from help module.';