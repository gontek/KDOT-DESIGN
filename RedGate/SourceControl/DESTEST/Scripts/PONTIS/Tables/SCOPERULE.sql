CREATE TABLE pontis.scoperule (
  scopesetkey VARCHAR2(2 BYTE) NOT NULL,
  scoperulekey VARCHAR2(2 BYTE) NOT NULL,
  ifactcode VARCHAR2(2 BYTE),
  ifactkind CHAR,
  ifobjcode VARCHAR2(10 BYTE),
  ifobjkind CHAR,
  thactcode VARCHAR2(2 BYTE),
  thactkind CHAR,
  thobjcode VARCHAR2(10 BYTE),
  thobjkind CHAR,
  applyto CHAR,
  "PRIORITY" NUMBER(2),
  description VARCHAR2(255 BYTE),
  CONSTRAINT scoperule_pk PRIMARY KEY (scopesetkey,scoperulekey),
  CONSTRAINT fk_scoperul_81_scopeset FOREIGN KEY (scopesetkey) REFERENCES pontis.scopesets (scopesetkey) ON DELETE CASCADE
);
COMMENT ON TABLE pontis.scoperule IS 'Scoping Rule Specifications';
COMMENT ON COLUMN pontis.scoperule.scopesetkey IS 'Scoping rule set key';
COMMENT ON COLUMN pontis.scoperule.scoperulekey IS 'Scoping rule key';
COMMENT ON COLUMN pontis.scoperule.ifactcode IS 'IF action code';
COMMENT ON COLUMN pontis.scoperule.ifactkind IS 'If action type';
COMMENT ON COLUMN pontis.scoperule.thactcode IS 'Then action code';
COMMENT ON COLUMN pontis.scoperule.thactkind IS 'Then action kind';
COMMENT ON COLUMN pontis.scoperule.thobjcode IS 'same as objcode';
COMMENT ON COLUMN pontis.scoperule.thobjkind IS 'same as objkind';