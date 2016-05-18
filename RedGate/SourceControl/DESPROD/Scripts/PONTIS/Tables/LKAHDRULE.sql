CREATE TABLE pontis.lkahdrule (
  lkahdsetkey VARCHAR2(2 BYTE) NOT NULL,
  lkahdrulekey VARCHAR2(2 BYTE) NOT NULL,
  ifobjkind CHAR,
  ifobjcode VARCHAR2(10 BYTE),
  ifactkind CHAR,
  ifactcode VARCHAR2(2 BYTE),
  thobjkind CHAR,
  thobjcode VARCHAR2(10 BYTE),
  thactkind CHAR,
  thactcode VARCHAR2(2 BYTE),
  applyto CHAR,
  minyears NUMBER(2),
  description VARCHAR2(255 BYTE),
  CONSTRAINT lkahdrule_pk PRIMARY KEY (lkahdsetkey,lkahdrulekey),
  CONSTRAINT fk_lkahdrul_48_lkahdset FOREIGN KEY (lkahdsetkey) REFERENCES pontis.lkahdsets (lkahdsetkey) ON DELETE CASCADE
);
COMMENT ON TABLE pontis.lkahdrule IS 'Lookahead Rule Specifications';
COMMENT ON COLUMN pontis.lkahdrule.lkahdsetkey IS 'Look ahead rule set key';
COMMENT ON COLUMN pontis.lkahdrule.lkahdrulekey IS 'Scenario, key of the lookahead rules family';
COMMENT ON COLUMN pontis.lkahdrule.ifactkind IS 'If action type';
COMMENT ON COLUMN pontis.lkahdrule.ifactcode IS 'IF action code';
COMMENT ON COLUMN pontis.lkahdrule.thobjkind IS 'same as objkind';
COMMENT ON COLUMN pontis.lkahdrule.thobjcode IS 'same as objcode';
COMMENT ON COLUMN pontis.lkahdrule.thactkind IS 'Then action kind';
COMMENT ON COLUMN pontis.lkahdrule.thactcode IS 'Then action code';