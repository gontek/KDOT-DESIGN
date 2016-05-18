CREATE TABLE pontis.pfuser_pref (
  keyword VARCHAR2(255 BYTE) NOT NULL,
  ini_section VARCHAR2(255 BYTE) NOT NULL,
  userid VARCHAR2(30 BYTE) NOT NULL,
  key_value VARCHAR2(255 BYTE),
  last_modified_uid VARCHAR2(30 BYTE) NOT NULL,
  last_modified_date DATE NOT NULL,
  CONSTRAINT pfuser_pref_pk PRIMARY KEY (keyword,ini_section,userid)
);
COMMENT ON TABLE pontis.pfuser_pref IS 'pfuser_pref';
COMMENT ON COLUMN pontis.pfuser_pref.keyword IS 'Used to store ini keyword information.';
COMMENT ON COLUMN pontis.pfuser_pref.ini_section IS 'Used to store ini section information.';
COMMENT ON COLUMN pontis.pfuser_pref.userid IS 'Unique set of characters that identify the user to the application.';
COMMENT ON COLUMN pontis.pfuser_pref.key_value IS 'Used to store ini value information for the keyword';
COMMENT ON COLUMN pontis.pfuser_pref.last_modified_uid IS 'The userid who last modified the preference row';
COMMENT ON COLUMN pontis.pfuser_pref.last_modified_date IS 'The date the user preference row was updated';