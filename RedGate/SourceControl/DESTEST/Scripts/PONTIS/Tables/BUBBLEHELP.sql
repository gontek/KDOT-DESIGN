CREATE TABLE pontis.bubblehelp (
  lookup_key VARCHAR2(255 BYTE) NOT NULL,
  language VARCHAR2(2 BYTE),
  bubblehelp VARCHAR2(2000 BYTE),
  createdatetime DATE,
  createuserkey VARCHAR2(4 BYTE),
  modtime DATE,
  userkey VARCHAR2(4 BYTE),
  CONSTRAINT bubblehelp_pk PRIMARY KEY (lookup_key)
);
COMMENT ON COLUMN pontis.bubblehelp.modtime IS 'Time the record was last modified. Reserved for future use.';
COMMENT ON COLUMN pontis.bubblehelp.userkey IS 'Primary key to the users table. Key of user that last modified record.';