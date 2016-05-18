CREATE TABLE ksbms_robot.ds_config_options (
  optionname VARCHAR2(30 BYTE) NOT NULL CONSTRAINT optionname_all_caps CHECK ("OPTIONNAME" IS NOT NULL),
  optionvalue VARCHAR2(255 BYTE) DEFAULT 'PLEASE PROVIDE A VALID DEFAULT VALUE FOR THIS OPTION' NOT NULL,
  description VARCHAR2(255 BYTE) DEFAULT 'PLEASE PROVIDE A USEFUL DESCRIPTION OF THIS CONFIGURATION OPTION' NOT NULL,
  helpid NUMBER DEFAULT 99999 CONSTRAINT helpid_gt_0 CHECK (HELPID is null or (HELPID > 0 )),
  url VARCHAR2(255 BYTE) DEFAULT 'http://' CONSTRAINT valid_url_stem CHECK (URL is null or (SUBSTR( url , 1, 7) = 'http://' )),
  createdatetime DATE DEFAULT sysdate NOT NULL,
  createuserid VARCHAR2(30 BYTE) DEFAULT 'user' NOT NULL,
  modtime DATE DEFAULT sysdate NOT NULL,
  changeuserid VARCHAR2(30 BYTE) DEFAULT 'user' NOT NULL,
  CONSTRAINT pk_optionname PRIMARY KEY (optionname)
);
COMMENT ON TABLE ksbms_robot.ds_config_options IS 'Table of configuration options editable by user ksbms_robot to control data exchange routines ''dynamically''';
COMMENT ON COLUMN ksbms_robot.ds_config_options.optionname IS 'Configuration Option Lookup Key';
COMMENT ON COLUMN ksbms_robot.ds_config_options.optionvalue IS 'Configuration option value';
COMMENT ON COLUMN ksbms_robot.ds_config_options.description IS 'Configuration option usage description';
COMMENT ON COLUMN ksbms_robot.ds_config_options.helpid IS 'Lookup code for help related to this configuration option';
COMMENT ON COLUMN ksbms_robot.ds_config_options.url IS 'URL link for help related to this configuration option';
COMMENT ON COLUMN ksbms_robot.ds_config_options.createdatetime IS 'Date option created in database';
COMMENT ON COLUMN ksbms_robot.ds_config_options.modtime IS 'Data option last updated';
COMMENT ON COLUMN ksbms_robot.ds_config_options.changeuserid IS 'User performing last update to this table';