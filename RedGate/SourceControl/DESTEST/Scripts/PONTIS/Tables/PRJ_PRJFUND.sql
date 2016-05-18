CREATE TABLE pontis.prj_prjfund (
  fskey VARCHAR2(2 BYTE) NOT NULL,
  projkey VARCHAR2(30 BYTE) NOT NULL,
  "COST" NUMBER(10),
  createdatetime DATE,
  createuserkey VARCHAR2(4 BYTE),
  modtime DATE,
  userkey VARCHAR2(4 BYTE),
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT prj_prjfund_pk PRIMARY KEY (fskey,projkey),
  CONSTRAINT fk_prj_prjf_60_prj_fund FOREIGN KEY (fskey) REFERENCES pontis.prj_fundsrc (fskey) ON DELETE CASCADE,
  CONSTRAINT fk_prj_prjf_68_projects FOREIGN KEY (projkey) REFERENCES pontis.projects (projkey) ON DELETE CASCADE
);
COMMENT ON TABLE pontis.prj_prjfund IS 'Agency funding sources for projects per year';
COMMENT ON COLUMN pontis.prj_prjfund.fskey IS 'Primary key for funding sources';
COMMENT ON COLUMN pontis.prj_prjfund.projkey IS 'Project primary key';
COMMENT ON COLUMN pontis.prj_prjfund."COST" IS 'percent of cost';
COMMENT ON COLUMN pontis.prj_prjfund.modtime IS 'Time the record was last modified. Reserved for future use.';
COMMENT ON COLUMN pontis.prj_prjfund.userkey IS 'Primary key to the users table. Key of user that last modified record.';
COMMENT ON COLUMN pontis.prj_prjfund.notes IS 'Entry comments';