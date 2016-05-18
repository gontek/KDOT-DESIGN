CREATE TABLE pontis.coptions (
  optionname VARCHAR2(40 BYTE) NOT NULL,
  optionval VARCHAR2(255 BYTE),
  defaultval VARCHAR2(255 BYTE),
  helpid NUMBER(5),
  description VARCHAR2(255 BYTE),
  CONSTRAINT coptions_pk PRIMARY KEY (optionname)
)
CACHE;
COMMENT ON TABLE pontis.coptions IS 'coptions';
COMMENT ON COLUMN pontis.coptions.optionname IS 'Name for this option used by the program to locate the option';
COMMENT ON COLUMN pontis.coptions.optionval IS 'The current value of this configuration option';
COMMENT ON COLUMN pontis.coptions.defaultval IS 'The Option Value assigned as a default by the application creators';
COMMENT ON COLUMN pontis.coptions.helpid IS 'Help ID code from help module.';