CREATE TABLE pontis.lkahdsets (
  lkahdsetkey VARCHAR2(2 BYTE) NOT NULL,
  lkahdsetname VARCHAR2(24 BYTE),
  modtime DATE,
  userkey VARCHAR2(4 BYTE),
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT lkahdsets_pk PRIMARY KEY (lkahdsetkey)
);
COMMENT ON TABLE pontis.lkahdsets IS 'Look ahead ruleset with description';
COMMENT ON COLUMN pontis.lkahdsets.lkahdsetkey IS 'Look ahead rule set key';
COMMENT ON COLUMN pontis.lkahdsets.modtime IS 'Time the record was last modified. Reserved for future use.';
COMMENT ON COLUMN pontis.lkahdsets.userkey IS 'Primary key to the users table. Key of user that last modified record.';
COMMENT ON COLUMN pontis.lkahdsets.notes IS 'Entry comments';