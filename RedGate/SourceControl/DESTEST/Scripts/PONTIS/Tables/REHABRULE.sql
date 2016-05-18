CREATE TABLE pontis.rehabrule (
  rehabsetkey VARCHAR2(2 BYTE) NOT NULL,
  rehabrulekey VARCHAR2(2 BYTE) NOT NULL,
  ecatkey CHAR,
  "PRIORITY" NUMBER(2),
  threshkind CHAR,
  threshold NUMBER(12),
  actkind CHAR,
  actcode VARCHAR2(2 BYTE) NOT NULL,
  applyto CHAR,
  description VARCHAR2(255 BYTE),
  CONSTRAINT rehabrule_pk PRIMARY KEY (rehabsetkey,rehabrulekey),
  CONSTRAINT fk_rehabrul_71_rehabset FOREIGN KEY (rehabsetkey) REFERENCES pontis.rehabsets (rehabsetkey) ON DELETE CASCADE
);
COMMENT ON TABLE pontis.rehabrule IS 'Rehabilitation rule specifications';
COMMENT ON COLUMN pontis.rehabrule.rehabrulekey IS 'Scenario, major rehabilitation policy key';
COMMENT ON COLUMN pontis.rehabrule.ecatkey IS 'Element category key number';
COMMENT ON COLUMN pontis.rehabrule.actkind IS 'Action Kind (1: Action Type, 2: Action Category, 3: Flex Action)';
COMMENT ON COLUMN pontis.rehabrule.actcode IS 'Action type key e.g.g 11,12,31,41 depending on the action kind';