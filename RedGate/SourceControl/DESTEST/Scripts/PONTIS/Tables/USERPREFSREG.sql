CREATE TABLE pontis.userprefsreg (
  objectname VARCHAR2(255 BYTE) NOT NULL,
  status CHAR DEFAULT 'A' NOT NULL,
  createdatetime DATE NOT NULL,
  createuserkey VARCHAR2(4 BYTE) NOT NULL,
  modtime DATE,
  userkey VARCHAR2(4 BYTE),
  CONSTRAINT userprefsreg_pk PRIMARY KEY (objectname)
);
COMMENT ON COLUMN pontis.userprefsreg.objectname IS 'Name of the user interface object for which preferences are stored.';
COMMENT ON COLUMN pontis.userprefsreg.status IS 'Status indicator for the specified user interface object.';
COMMENT ON COLUMN pontis.userprefsreg.createdatetime IS 'Date and time the record was created.';
COMMENT ON COLUMN pontis.userprefsreg.createuserkey IS 'Key value for the user that created the record.';
COMMENT ON COLUMN pontis.userprefsreg.modtime IS 'Date and time the record was last modified.';
COMMENT ON COLUMN pontis.userprefsreg.userkey IS 'Key value for the user that last modified the record.';