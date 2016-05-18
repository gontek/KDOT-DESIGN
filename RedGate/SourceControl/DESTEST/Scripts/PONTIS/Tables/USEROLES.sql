CREATE TABLE pontis.useroles (
  userkey VARCHAR2(4 BYTE) NOT NULL,
  "PERMISSION" VARCHAR2(10 BYTE) NOT NULL,
  allowed CHAR NOT NULL,
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT useroles_pk PRIMARY KEY (userkey,"PERMISSION"),
  CONSTRAINT fk_useroles_90_users FOREIGN KEY (userkey) REFERENCES pontis."USERS" (userkey) ON DELETE CASCADE
);
COMMENT ON COLUMN pontis.useroles.userkey IS 'Primary key to the users table. Key of user that last modified record.';
COMMENT ON COLUMN pontis.useroles."PERMISSION" IS 'Token for this permission. A hard coded list of availabe permissions exists.';
COMMENT ON COLUMN pontis.useroles.allowed IS 'Is this user allowed this permission 1 or 0.';