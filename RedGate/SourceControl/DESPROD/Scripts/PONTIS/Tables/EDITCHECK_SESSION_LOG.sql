CREATE TABLE pontis.editcheck_session_log (
  logkey NUMBER(38) NOT NULL,
  session_key NUMBER(38),
  struct_num VARCHAR2(15 BYTE),
  on_under VARCHAR2(1 BYTE),
  check_key NUMBER(38),
  CONSTRAINT editcheck_session_log_pk PRIMARY KEY (logkey)
);
COMMENT ON COLUMN pontis.editcheck_session_log.logkey IS 'Identifier for the log entry';
COMMENT ON COLUMN pontis.editcheck_session_log.session_key IS 'Key of the session for which the entry was generated.  Foreign key to the editcheck_session table';
COMMENT ON COLUMN pontis.editcheck_session_log.struct_num IS 'Structure number for which the entry was generated.  Foreign key to the bridge table.';
COMMENT ON COLUMN pontis.editcheck_session_log.on_under IS 'On_under value for which the entry was generated.  Foreign key to the roadway table.';
COMMENT ON COLUMN pontis.editcheck_session_log.check_key IS 'Check triggered.  Foreign key to the editcheck_definitions table.';