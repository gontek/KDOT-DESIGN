CREATE TABLE pontis.rehabsets (
  rehabsetkey VARCHAR2(2 BYTE) NOT NULL,
  rehabsetname VARCHAR2(24 BYTE),
  modtime DATE,
  userkey VARCHAR2(4 BYTE),
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT rehabsets_pk PRIMARY KEY (rehabsetkey)
);
COMMENT ON TABLE pontis.rehabsets IS 'rehabilitation rulesets with description';
COMMENT ON COLUMN pontis.rehabsets.modtime IS 'Time the record was last modified. Reserved for future use.';
COMMENT ON COLUMN pontis.rehabsets.userkey IS 'Primary key to the users table. Key of user that last modified record.';
COMMENT ON COLUMN pontis.rehabsets.notes IS 'Entry comments';