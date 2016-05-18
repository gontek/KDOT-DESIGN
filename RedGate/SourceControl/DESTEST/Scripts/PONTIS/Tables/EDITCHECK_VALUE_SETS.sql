CREATE TABLE pontis.editcheck_value_sets (
  set_name VARCHAR2(24 BYTE) NOT NULL,
  set_value VARCHAR2(255 BYTE) NOT NULL,
  modtime DATE,
  userkey VARCHAR2(4 BYTE),
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT editcheck_value_sets_pk PRIMARY KEY (set_name,set_value)
);
COMMENT ON COLUMN pontis.editcheck_value_sets.set_name IS 'Name of the value set';
COMMENT ON COLUMN pontis.editcheck_value_sets.set_value IS 'Specific value in the value set';
COMMENT ON COLUMN pontis.editcheck_value_sets.modtime IS 'Time the record was last modified';
COMMENT ON COLUMN pontis.editcheck_value_sets.userkey IS 'Key of user that last modified record';
COMMENT ON COLUMN pontis.editcheck_value_sets.notes IS 'Entry comments';