CREATE TABLE pontis."USERS" (
  userkey VARCHAR2(4 BYTE) NOT NULL,
  userid VARCHAR2(12 BYTE),
  last_name VARCHAR2(20 BYTE),
  first_name VARCHAR2(20 BYTE),
  middle VARCHAR2(20 BYTE),
  district VARCHAR2(2 BYTE),
  title VARCHAR2(40 BYTE),
  agency VARCHAR2(40 BYTE),
  address1 VARCHAR2(40 BYTE),
  address2 VARCHAR2(40 BYTE),
  city VARCHAR2(30 BYTE),
  "STATE" VARCHAR2(2 BYTE),
  zip VARCHAR2(10 BYTE),
  phone VARCHAR2(20 BYTE),
  fax VARCHAR2(20 BYTE),
  email VARCHAR2(80 BYTE),
  superuser CHAR,
  initials VARCHAR2(3 BYTE),
  CONSTRAINT users_pk PRIMARY KEY (userkey)
);
COMMENT ON COLUMN pontis."USERS".userkey IS 'Primary key to the users table. Key of user that last modified record.';
COMMENT ON COLUMN pontis."USERS".userid IS 'User s ID for logging into system';
COMMENT ON COLUMN pontis."USERS".last_name IS 'User s last name';
COMMENT ON COLUMN pontis."USERS".first_name IS 'User s first name';
COMMENT ON COLUMN pontis."USERS".middle IS 'User s middle name or initials';
COMMENT ON COLUMN pontis."USERS".district IS 'Highway agency district';
COMMENT ON COLUMN pontis."USERS".title IS 'User s title';
COMMENT ON COLUMN pontis."USERS".agency IS 'User s agency name';
COMMENT ON COLUMN pontis."USERS".address1 IS 'First line of address';
COMMENT ON COLUMN pontis."USERS".address2 IS 'Second line of address';
COMMENT ON COLUMN pontis."USERS".city IS 'City';
COMMENT ON COLUMN pontis."USERS"."STATE" IS 'State';
COMMENT ON COLUMN pontis."USERS".zip IS 'Zip code';
COMMENT ON COLUMN pontis."USERS".phone IS 'Phone number';
COMMENT ON COLUMN pontis."USERS".fax IS 'Fax number';
COMMENT ON COLUMN pontis."USERS".email IS 'Electronic mail address';
COMMENT ON COLUMN pontis."USERS".superuser IS 'Flag indicating person with all rights';
COMMENT ON COLUMN pontis."USERS".initials IS 'User s initials';