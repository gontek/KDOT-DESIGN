CREATE TABLE pontis.default_coptions (
  optionname VARCHAR2(40 BYTE) NOT NULL,
  optionval VARCHAR2(255 BYTE),
  defaultval VARCHAR2(255 BYTE),
  helpid NUMBER(5),
  description VARCHAR2(255 BYTE),
  CONSTRAINT pk_default_coptions PRIMARY KEY (optionname)
);
COMMENT ON TABLE pontis.default_coptions IS 'Default system coptions';
COMMENT ON COLUMN pontis.default_coptions.optionname IS 'Name for this option used by the program to locate the option';
COMMENT ON COLUMN pontis.default_coptions.optionval IS 'The current value of this configuration option';
COMMENT ON COLUMN pontis.default_coptions.defaultval IS 'The Option Value assigned as a default by the application creators';
COMMENT ON COLUMN pontis.default_coptions.helpid IS 'Help ID code from help module.';