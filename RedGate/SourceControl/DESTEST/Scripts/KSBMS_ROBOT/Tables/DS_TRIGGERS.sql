CREATE TABLE ksbms_robot.ds_triggers (
  "OWNER" VARCHAR2(30 BYTE) DEFAULT 'PONTIS' NOT NULL,
  trigger_name VARCHAR2(30 BYTE) NOT NULL,
  trigger_status VARCHAR2(2 BYTE) NOT NULL,
  createdatetime DATE NOT NULL,
  createuserid VARCHAR2(30 BYTE) NOT NULL,
  modtime DATE NOT NULL,
  changeuserid VARCHAR2(30 BYTE) NOT NULL,
  CONSTRAINT pk_ds_triggers PRIMARY KEY ("OWNER",trigger_name)
);
COMMENT ON COLUMN ksbms_robot.ds_triggers."OWNER" IS 'Owner of a trigger that affects data synchronization';
COMMENT ON COLUMN ksbms_robot.ds_triggers.trigger_name IS 'Trigger name for a trigger that affects data synchronization routines - the trigger is actually instantiated in the schema  forund in the field OWNER';
COMMENT ON COLUMN ksbms_robot.ds_triggers.trigger_status IS 'Set to ''1'' to disable this trigger during processing, ''0'' if OK to leave enabled during processing';