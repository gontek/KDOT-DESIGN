CREATE TABLE pontis.useracc (
  userkey VARCHAR2(4 BYTE) NOT NULL,
  whereclause VARCHAR2(2000 BYTE),
  englishclause VARCHAR2(2000 BYTE),
  customsqlflag CHAR,
  createdatetime DATE,
  createuserkey VARCHAR2(4 BYTE),
  modtime DATE,
  moduserkey VARCHAR2(4 BYTE),
  CONSTRAINT useracc_pk PRIMARY KEY (userkey),
  CONSTRAINT fk_useracc_users FOREIGN KEY (userkey) REFERENCES pontis."USERS" (userkey) ON DELETE CASCADE
);
COMMENT ON COLUMN pontis.useracc.userkey IS 'User key.  Foreign key to the users table.';
COMMENT ON COLUMN pontis.useracc.whereclause IS 'Specifies the supplemental where clause for the specified user when retrieving structure lists.';
COMMENT ON COLUMN pontis.useracc.englishclause IS 'Specifies the English language description of the supplemental where clause for the specified user when retrieving structure lists.';
COMMENT ON COLUMN pontis.useracc.customsqlflag IS 'Indicates whether the where clause for the specified user has been customized.';
COMMENT ON COLUMN pontis.useracc.createdatetime IS 'Date and time the record was created.';
COMMENT ON COLUMN pontis.useracc.createuserkey IS 'Key value for the user that created the record.';
COMMENT ON COLUMN pontis.useracc.modtime IS 'Date and time the record was last modified.';
COMMENT ON COLUMN pontis.useracc.moduserkey IS 'Key value for the user that last modified the record.';