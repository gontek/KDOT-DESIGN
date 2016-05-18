CREATE TABLE pontis.cicocntl (
  brkey VARCHAR2(15 BYTE) NOT NULL,
  ioflag CHAR NOT NULL,
  iomoment DATE NOT NULL,
  cicoid CHAR(4 BYTE) NOT NULL,
  userkey VARCHAR2(4 BYTE) NOT NULL,
  atrigger CHAR,
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT cicocntl_pk PRIMARY KEY (brkey,ioflag,iomoment,cicoid),
  CONSTRAINT fk_cicocntl_5_bridge FOREIGN KEY (brkey) REFERENCES pontis.bridge (brkey) ON DELETE CASCADE,
  CONSTRAINT fk_cicocntl_92_users FOREIGN KEY (userkey) REFERENCES pontis."USERS" (userkey)
);
COMMENT ON TABLE pontis.cicocntl IS 'cicocntl';
COMMENT ON COLUMN pontis.cicocntl.brkey IS 'Primary pontis structure key--uniquely identifies the structure in the system.';
COMMENT ON COLUMN pontis.cicocntl.ioflag IS 'I or O indicates input or output';
COMMENT ON COLUMN pontis.cicocntl.iomoment IS 'Time when session in which this structure was checked out began.';
COMMENT ON COLUMN pontis.cicocntl.cicoid IS 'Check-in--Check-out Session ID';
COMMENT ON COLUMN pontis.cicocntl.userkey IS 'Primary key to the users table. Key of user that last modified record.';
COMMENT ON COLUMN pontis.cicocntl.atrigger IS 'If set to 1(bc bridge record was changed), the checked out bridge will not be al';
COMMENT ON COLUMN pontis.cicocntl.notes IS 'Entry comments';