CREATE TABLE pontis.agencypolsets (
  agcypolsetkey VARCHAR2(2 BYTE) NOT NULL,
  agcypolsetname VARCHAR2(24 BYTE),
  modtime DATE,
  userkey VARCHAR2(4 BYTE),
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT agencypolsets_pk PRIMARY KEY (agcypolsetkey)
);
COMMENT ON COLUMN pontis.agencypolsets.agcypolsetkey IS 'Agency preservation policy set key.  Two character code of the rule set as it will be addressed by scenario.';
COMMENT ON COLUMN pontis.agencypolsets.modtime IS 'Time the record was last modified. Reserved for future use.';
COMMENT ON COLUMN pontis.agencypolsets.userkey IS 'Primary key to the users table. Key of user that last modified record.';
COMMENT ON COLUMN pontis.agencypolsets.notes IS 'Entry comments';