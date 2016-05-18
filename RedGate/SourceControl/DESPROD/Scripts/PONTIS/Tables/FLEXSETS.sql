CREATE TABLE pontis.flexsets (
  fxsetkey VARCHAR2(2 BYTE) NOT NULL,
  modtime DATE,
  userkey VARCHAR2(4 BYTE),
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT flexsets_pk PRIMARY KEY (fxsetkey)
);
COMMENT ON TABLE pontis.flexsets IS 'Flexible element rule sets (default set needed)';
COMMENT ON COLUMN pontis.flexsets.fxsetkey IS 'flexible action family key';
COMMENT ON COLUMN pontis.flexsets.modtime IS 'Time the record was last modified. Reserved for future use.';
COMMENT ON COLUMN pontis.flexsets.userkey IS 'Primary key to the users table. Key of user that last modified record.';
COMMENT ON COLUMN pontis.flexsets.notes IS 'Entry comments';