CREATE TABLE pontis.object_help (
  object_name VARCHAR2(64 BYTE) NOT NULL,
  helptype VARCHAR2(2 BYTE),
  helpid NUMBER(5),
  CONSTRAINT object_help_pk PRIMARY KEY (object_name)
)
CACHE;
COMMENT ON COLUMN pontis.object_help.object_name IS 'Name of Pontis Object';
COMMENT ON COLUMN pontis.object_help.helptype IS 'Type of help--metric conversion or popup help.';
COMMENT ON COLUMN pontis.object_help.helpid IS 'Help ID code from help module.';