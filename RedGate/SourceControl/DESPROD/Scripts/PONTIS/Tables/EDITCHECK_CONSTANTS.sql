CREATE TABLE pontis.editcheck_constants (
  constant_name VARCHAR2(24 BYTE) NOT NULL,
  constant_value VARCHAR2(255 BYTE),
  modtime DATE,
  userkey VARCHAR2(4 BYTE),
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT editcheck_constants_pk PRIMARY KEY (constant_name)
);
COMMENT ON COLUMN pontis.editcheck_constants.constant_name IS 'Unique name of the constant';
COMMENT ON COLUMN pontis.editcheck_constants.constant_value IS 'Value of the constant';
COMMENT ON COLUMN pontis.editcheck_constants.modtime IS 'Time the record was last modified';
COMMENT ON COLUMN pontis.editcheck_constants.userkey IS 'Key of user that last modified record';
COMMENT ON COLUMN pontis.editcheck_constants.notes IS 'Entry comments';