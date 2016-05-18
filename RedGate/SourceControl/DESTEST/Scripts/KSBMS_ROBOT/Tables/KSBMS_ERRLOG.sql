CREATE TABLE ksbms_robot.ksbms_errlog (
  "OWNER" VARCHAR2(30 BYTE) DEFAULT 'KSBMS_ROBOT' NOT NULL CONSTRAINT ckc_owner_ksbms_errlog CHECK ("OWNER" IS NOT NULL),
  appcode NUMBER DEFAULT 3 NOT NULL CONSTRAINT ckc_appcode_ksbms_errlog CHECK ("APPCODE" IS NOT NULL),
  errcode NUMBER NOT NULL CONSTRAINT ckc_errcode_ksbms_errlog CHECK ("ERRCODE" IS NOT NULL),
  event_id VARCHAR2(32 BYTE) DEFAULT sys_guid() NOT NULL CONSTRAINT ckc_event_id_ksbms_errlog CHECK ("EVENT_ID" IS NOT NULL),
  session_id NUMBER,
  errmsg VARCHAR2(4000 BYTE),
  createdatetime DATE DEFAULT SYSDATE NOT NULL,
  createuserid VARCHAR2(30 BYTE) DEFAULT USER NOT NULL,
  CONSTRAINT pk_errlog PRIMARY KEY ("OWNER",appcode,errcode,event_id),
  CONSTRAINT fk_errlog_app_register FOREIGN KEY ("OWNER",appcode) REFERENCES ksbms_robot.ksbms_app_register ("OWNER",appcode) ON DELETE CASCADE
);
COMMENT ON COLUMN ksbms_robot.ksbms_errlog."OWNER" IS 'Source schema for error entry';
COMMENT ON COLUMN ksbms_robot.ksbms_errlog.appcode IS 'Source application for error entry 1=Pontis, 2= Data Synchronization';
COMMENT ON COLUMN ksbms_robot.ksbms_errlog.session_id IS 'Login session ID';
COMMENT ON COLUMN ksbms_robot.ksbms_errlog.errmsg IS 'Error text ( may be intentionally denormalized standard error text from KSBMS_MSG_INFO )';
COMMENT ON COLUMN ksbms_robot.ksbms_errlog.createuserid IS 'Source user generating entry';