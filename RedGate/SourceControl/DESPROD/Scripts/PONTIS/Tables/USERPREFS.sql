CREATE TABLE pontis.userprefs (
  userkey VARCHAR2(4 BYTE) NOT NULL,
  objectname VARCHAR2(255 BYTE) NOT NULL,
  controlname VARCHAR2(255 BYTE) NOT NULL,
  preference VARCHAR2(2000 BYTE) NOT NULL,
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT userprefs_pk PRIMARY KEY (userkey,objectname,controlname),
  CONSTRAINT fk_userprefs_userprefsreg FOREIGN KEY (objectname) REFERENCES pontis.userprefsreg (objectname) ON DELETE CASCADE,
  CONSTRAINT fk_userpref_users FOREIGN KEY (userkey) REFERENCES pontis."USERS" (userkey) ON DELETE CASCADE
);
COMMENT ON COLUMN pontis.userprefs.userkey IS 'User key.  Foreign key to the users table.';
COMMENT ON COLUMN pontis.userprefs.objectname IS 'Name of the user interface object for which preferences are stored.';
COMMENT ON COLUMN pontis.userprefs.controlname IS 'Name of the user interface control object for which preferences are stored.';
COMMENT ON COLUMN pontis.userprefs.preference IS 'Preferred setting for the specified user and user interface object.';