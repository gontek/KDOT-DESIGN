CREATE TABLE ksbms_robot.ds_message_log (
  job_id VARCHAR2(32 BYTE) NOT NULL,
  "SCHEMA" VARCHAR2(2 BYTE) NOT NULL,
  msg_id VARCHAR2(32 BYTE) DEFAULT 'sys_guid()' NOT NULL,
  msg_seqnum NUMBER DEFAULT 1 NOT NULL,
  msg_format VARCHAR2(10 BYTE) DEFAULT 'TEXT' NOT NULL CONSTRAINT chk_msg_format CHECK (MSG_FORMAT in ('TEXT','XML','RAW','TEXTBFILE','XMLBFILE','RAWFILE')),
  msg_bfile BFILE,
  createdatetime DATE DEFAULT sysdate NOT NULL,
  createuserid VARCHAR2(30 BYTE) DEFAULT 'USER' NOT NULL,
  modtime DATE DEFAULT sysdate NOT NULL,
  changeuserid VARCHAR2(30 BYTE) DEFAULT 'USER' NOT NULL,
  msg_body VARCHAR2(4000 BYTE),
  msg_clob CLOB,
  CONSTRAINT pk_ds_message_log PRIMARY KEY (job_id,"SCHEMA",msg_id,msg_seqnum),
  CONSTRAINT fk_jobruns_history FOREIGN KEY (job_id) REFERENCES ksbms_robot.ds_jobruns_history (job_id) ON DELETE CASCADE
);
COMMENT ON TABLE ksbms_robot.ds_message_log IS 'Stores 1:N part messages or message file refs for session ID.  Message chunks maximum of VC(4000) or CLOB type';
COMMENT ON COLUMN ksbms_robot.ds_message_log.msg_id IS 'message identifier code ( reuse for multi-part message )';
COMMENT ON COLUMN ksbms_robot.ds_message_log.msg_seqnum IS 'Sequence number on insert of multi-part message';
COMMENT ON COLUMN ksbms_robot.ds_message_log.msg_format IS 'TEXT,  XML,  RAW,  TEXTBFILE, XMLBFILE, RAWFILE for contents of CLOB column';
COMMENT ON COLUMN ksbms_robot.ds_message_log.msg_bfile IS 'Location of file source for message ( stored on server ) -  used for predefined formatted messages';
COMMENT ON COLUMN ksbms_robot.ds_message_log.createdatetime IS 'Date and time message generated';
COMMENT ON COLUMN ksbms_robot.ds_message_log.createuserid IS 'User ID of process generating the message';
COMMENT ON COLUMN ksbms_robot.ds_message_log.modtime IS 'Date and time message updated';
COMMENT ON COLUMN ksbms_robot.ds_message_log.changeuserid IS 'User ID of process updating the message';
COMMENT ON COLUMN ksbms_robot.ds_message_log.msg_body IS 'ASCII text body of the message';
COMMENT ON COLUMN ksbms_robot.ds_message_log.msg_clob IS 'Body of the message stored in CLOB column';