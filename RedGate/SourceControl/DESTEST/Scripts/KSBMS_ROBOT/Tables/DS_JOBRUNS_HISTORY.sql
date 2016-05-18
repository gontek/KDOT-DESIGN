CREATE TABLE ksbms_robot.ds_jobruns_history (
  job_id VARCHAR2(32 BYTE) NOT NULL,
  ora_dbms_job_id NUMBER NOT NULL,
  job_start_time DATE NOT NULL,
  job_end_time DATE NOT NULL,
  job_status VARCHAR2(2 BYTE) NOT NULL,
  job_userid VARCHAR2(30 BYTE) DEFAULT 'USER' NOT NULL,
  job_processid VARCHAR2(32 BYTE),
  remarks VARCHAR2(255 BYTE),
  CONSTRAINT pk_jobruns_history PRIMARY KEY (job_id)
);
COMMENT ON TABLE ksbms_robot.ds_jobruns_history IS 'Processing run log';
COMMENT ON COLUMN ksbms_robot.ds_jobruns_history.job_userid IS 'Oracle User generating the change( taken from userid of the session) that fired the trigger that stamped the log entry';
COMMENT ON COLUMN ksbms_robot.ds_jobruns_history.remarks IS 'Comment for the change log';