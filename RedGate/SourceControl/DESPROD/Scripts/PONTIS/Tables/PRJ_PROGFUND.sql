CREATE TABLE pontis.prj_progfund (
  progkey VARCHAR2(2 BYTE) NOT NULL,
  fskey VARCHAR2(2 BYTE) NOT NULL,
  ykey NUMBER(4) NOT NULL,
  progbudg NUMBER(10),
  createdatetime DATE,
  createuserkey VARCHAR2(4 BYTE),
  modtime DATE,
  userkey VARCHAR2(4 BYTE),
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT prj_progfund_pk PRIMARY KEY (progkey,fskey,ykey),
  CONSTRAINT fk_prj_prog_61_prj_fund FOREIGN KEY (fskey) REFERENCES pontis.prj_fundsrc (fskey) ON DELETE CASCADE,
  CONSTRAINT fk_prj_prog_62_prj_prog FOREIGN KEY (progkey) REFERENCES pontis.prj_programs (progkey) ON DELETE CASCADE
);
COMMENT ON TABLE pontis.prj_progfund IS 'Funding budget for programs by year';
COMMENT ON COLUMN pontis.prj_progfund.progkey IS 'Primary key for work programs';
COMMENT ON COLUMN pontis.prj_progfund.fskey IS 'Primary key for funding sources';
COMMENT ON COLUMN pontis.prj_progfund.modtime IS 'Time the record was last modified. Reserved for future use.';
COMMENT ON COLUMN pontis.prj_progfund.userkey IS 'Primary key to the users table. Key of user that last modified record.';
COMMENT ON COLUMN pontis.prj_progfund.notes IS 'Entry comments';