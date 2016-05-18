CREATE TABLE pontis.pontlog (
  seqnumber NUMBER(10) NOT NULL,
  userkey VARCHAR2(4 BYTE) NOT NULL,
  "ACTIVITY" VARCHAR2(20 BYTE) NOT NULL,
  logdate DATE NOT NULL,
  logtime DATE NOT NULL,
  "ENTRY" VARCHAR2(255 BYTE),
  CONSTRAINT pontlog_pk PRIMARY KEY (seqnumber)
);
COMMENT ON COLUMN pontis.pontlog.seqnumber IS 'Sequence Number';
COMMENT ON COLUMN pontis.pontlog.userkey IS 'Primary key to the users table. Key of user that last modified record.';
COMMENT ON COLUMN pontis.pontlog."ACTIVITY" IS 'General category of log entry';
COMMENT ON COLUMN pontis.pontlog.logdate IS 'Date of transaction';
COMMENT ON COLUMN pontis.pontlog.logtime IS 'Time of transaction';
COMMENT ON COLUMN pontis.pontlog."ENTRY" IS 'Log entry';