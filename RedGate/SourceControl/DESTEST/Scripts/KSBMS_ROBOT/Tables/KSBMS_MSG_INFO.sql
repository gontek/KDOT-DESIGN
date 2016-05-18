CREATE TABLE ksbms_robot.ksbms_msg_info (
  "OWNER" VARCHAR2(30 BYTE) DEFAULT USER NOT NULL,
  appcode NUMBER DEFAULT 1 NOT NULL,
  msgcode NUMBER NOT NULL,
  msgtype VARCHAR2(30 BYTE) NOT NULL,
  msglevel NUMBER DEFAULT 0 NOT NULL,
  msgtext VARCHAR2(2000 BYTE) NOT NULL,
  msgname VARCHAR2(30 BYTE) NOT NULL,
  helpid NUMBER DEFAULT 99999,
  url VARCHAR2(255 BYTE),
  description VARCHAR2(2000 BYTE) NOT NULL,
  createdatetime DATE DEFAULT SYSDATE,
  createuserid VARCHAR2(30 BYTE) DEFAULT USER,
  modtime DATE DEFAULT SYSDATE,
  changeuserid VARCHAR2(30 BYTE) DEFAULT USER,
  CONSTRAINT pk_msg_info PRIMARY KEY ("OWNER",appcode,msgcode),
  CONSTRAINT fk_msg_info_app_register FOREIGN KEY ("OWNER",appcode) REFERENCES ksbms_robot.ksbms_app_register ("OWNER",appcode) ON DELETE CASCADE
);
COMMENT ON COLUMN ksbms_robot.ksbms_msg_info.appcode IS '1=Pontis, 2=Data Synchronization, 3=General Utilities';