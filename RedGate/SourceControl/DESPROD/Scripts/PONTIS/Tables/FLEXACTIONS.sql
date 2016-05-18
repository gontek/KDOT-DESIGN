CREATE TABLE pontis.flexactions (
  fxsetkey VARCHAR2(2 BYTE) NOT NULL,
  fxactkey VARCHAR2(2 BYTE) NOT NULL,
  fxname VARCHAR2(32 BYTE) NOT NULL,
  fxlongname VARCHAR2(100 BYTE),
  "IMPACT" VARCHAR2(2 BYTE),
  states VARCHAR2(6 BYTE) NOT NULL,
  description VARCHAR2(255 BYTE),
  CONSTRAINT flexactions_pk PRIMARY KEY (fxsetkey,fxactkey),
  CONSTRAINT fk_flexacti_40_flexsets FOREIGN KEY (fxsetkey) REFERENCES pontis.flexsets (fxsetkey) ON DELETE CASCADE
);
COMMENT ON COLUMN pontis.flexactions.fxsetkey IS 'flexible action family key';
COMMENT ON COLUMN pontis.flexactions.fxactkey IS 'Flexible action key';
COMMENT ON COLUMN pontis.flexactions.fxname IS 'flexible action name';
COMMENT ON COLUMN pontis.flexactions.fxlongname IS 'flexible action long name';
COMMENT ON COLUMN pontis.flexactions."IMPACT" IS 'State number to which quantities from below are upgraded';
COMMENT ON COLUMN pontis.flexactions.states IS 'State number starting from which action is applied';