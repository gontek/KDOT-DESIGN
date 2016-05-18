CREATE TABLE ksbms_robot.ksbms_config_options_obsolete (
  optionname VARCHAR2(30 BYTE),
  optionvalue VARCHAR2(255 BYTE) DEFAULT 'PLEASE PROVIDE A VALID DEFAULT VALUE FOR THIS OPTION',
  description VARCHAR2(255 BYTE) DEFAULT 'PLEASE PROVIDE A USEFUL DESCRIPTION OF THIS CONFIGURATION OPTION',
  helpid NUMBER(*,0) DEFAULT 99999,
  url VARCHAR2(255 BYTE) DEFAULT 'http://',
  created DATE DEFAULT sysdate,
  created_by VARCHAR2(30 BYTE) DEFAULT user,
  last_update DATE DEFAULT sysdate,
  changed_by VARCHAR2(30 BYTE) DEFAULT user
);
COMMENT ON TABLE ksbms_robot.ksbms_config_options_obsolete IS 'Table of configuration options editable by user ksbms_robot to control data exchange routines ''dynamically''';
COMMENT ON COLUMN ksbms_robot.ksbms_config_options_obsolete.optionname IS 'Configuration Option Lookup Key';
COMMENT ON COLUMN ksbms_robot.ksbms_config_options_obsolete.optionvalue IS 'Configuration option value';
COMMENT ON COLUMN ksbms_robot.ksbms_config_options_obsolete.description IS 'Configuration option usage description';
COMMENT ON COLUMN ksbms_robot.ksbms_config_options_obsolete.helpid IS 'Lookup code for help related to this configuration option';
COMMENT ON COLUMN ksbms_robot.ksbms_config_options_obsolete.url IS 'URL link for help related to this configuration option';
COMMENT ON COLUMN ksbms_robot.ksbms_config_options_obsolete.created IS 'Date option created in database';
COMMENT ON COLUMN ksbms_robot.ksbms_config_options_obsolete.last_update IS 'Data option last updated';
COMMENT ON COLUMN ksbms_robot.ksbms_config_options_obsolete.changed_by IS 'User performing last update to this table';