CREATE TABLE pontis.editcheck_session (
  session_key NUMBER(38) NOT NULL,
  batch_id VARCHAR2(32 BYTE),
  brkey VARCHAR2(15 BYTE),
  inspkey VARCHAR2(4 BYTE),
  severity VARCHAR2(1 BYTE),
  input_file VARCHAR2(255 BYTE),
  log_to_file NUMBER(38),
  log_file VARCHAR2(255 BYTE),
  log_to_db NUMBER(38),
  session_status NUMBER(38),
  modtime DATE,
  userkey VARCHAR2(4 BYTE),
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT editcheck_session_pk PRIMARY KEY (session_key)
);
COMMENT ON COLUMN pontis.editcheck_session.session_key IS 'Identifier for the edit check session';
COMMENT ON COLUMN pontis.editcheck_session.batch_id IS 'Batch identifier for the edit check session, if checks were performed for a batch of bridges';
COMMENT ON COLUMN pontis.editcheck_session.brkey IS 'Bridge key for the edit check session, if the session is for single bridge';
COMMENT ON COLUMN pontis.editcheck_session.inspkey IS 'Inspection key for the edit check session, if the session is for a single bridge';
COMMENT ON COLUMN pontis.editcheck_session.severity IS 'Indicator of what severity level of checks should be performed - fatal checks, warnings, or all checks';
COMMENT ON COLUMN pontis.editcheck_session.input_file IS 'Name of the input file checked, if applicable';
COMMENT ON COLUMN pontis.editcheck_session.log_to_file IS 'Indicator of whether session results were logged to a file';
COMMENT ON COLUMN pontis.editcheck_session.log_file IS 'Name of the file to which session results were written, if applicable';
COMMENT ON COLUMN pontis.editcheck_session.log_to_db IS 'Indicator of whether session results were logged to the database';
COMMENT ON COLUMN pontis.editcheck_session.session_status IS 'Session status';
COMMENT ON COLUMN pontis.editcheck_session.modtime IS 'Time the record was last modified';
COMMENT ON COLUMN pontis.editcheck_session.userkey IS 'Key of user that last modified record';
COMMENT ON COLUMN pontis.editcheck_session.notes IS 'Entry comments';