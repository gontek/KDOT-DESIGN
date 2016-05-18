CREATE TABLE pontis.scopesets (
  scopesetkey VARCHAR2(2 BYTE) NOT NULL,
  scopesetname VARCHAR2(24 BYTE),
  modtime DATE,
  userkey VARCHAR2(4 BYTE),
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT scopesets_pk PRIMARY KEY (scopesetkey)
);
COMMENT ON TABLE pontis.scopesets IS 'scoping ruleset with description';
COMMENT ON COLUMN pontis.scopesets.scopesetkey IS 'Scoping rule set key';
COMMENT ON COLUMN pontis.scopesets.modtime IS 'Time the record was last modified. Reserved for future use.';
COMMENT ON COLUMN pontis.scopesets.userkey IS 'Primary key to the users table. Key of user that last modified record.';
COMMENT ON COLUMN pontis.scopesets.notes IS 'Entry comments';