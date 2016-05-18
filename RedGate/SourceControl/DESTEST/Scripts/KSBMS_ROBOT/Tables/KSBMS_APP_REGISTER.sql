CREATE TABLE ksbms_robot.ksbms_app_register (
  "OWNER" VARCHAR2(30 BYTE) DEFAULT USER NOT NULL,
  appcode NUMBER(*,0) NOT NULL,
  appname VARCHAR2(30 BYTE) NOT NULL,
  appdesc VARCHAR2(255 BYTE) DEFAULT 'KSBMS APPLICATION',
  CONSTRAINT pk_ksbms_apps_register PRIMARY KEY ("OWNER",appcode)
);
COMMENT ON TABLE ksbms_robot.ksbms_app_register IS 'Register for KSBMS related application families - integer code for appcode, descriptions';
COMMENT ON COLUMN ksbms_robot.ksbms_app_register."OWNER" IS 'Schema of the application family';
COMMENT ON COLUMN ksbms_robot.ksbms_app_register.appcode IS 'Coded ID for the application family';
COMMENT ON COLUMN ksbms_robot.ksbms_app_register.appname IS 'Name of the application family';
COMMENT ON COLUMN ksbms_robot.ksbms_app_register.appdesc IS 'Description of the application family e.g. DATA SYNCHRONIZATION ROUTINES';