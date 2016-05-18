CREATE TABLE pontis.prj_programs (
  progkey VARCHAR2(2 BYTE) NOT NULL,
  prog_id VARCHAR2(30 BYTE),
  progname VARCHAR2(50 BYTE),
  progobjective VARCHAR2(100 BYTE),
  progtype CHAR,
  progstatus CHAR,
  progstartyr NUMBER(4),
  progendyr NUMBER(4),
  createdatetime DATE,
  createuserkey VARCHAR2(4 BYTE),
  modtime DATE,
  userkey VARCHAR2(4 BYTE),
  docrefkey VARCHAR2(255 BYTE),
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT prj_programs_pk PRIMARY KEY (progkey)
);
COMMENT ON COLUMN pontis.prj_programs.progkey IS 'Primary key for work programs';
COMMENT ON COLUMN pontis.prj_programs.prog_id IS 'Program Id';
COMMENT ON COLUMN pontis.prj_programs.progtype IS 'Agency-defined work program type e.g. Interstate maintenance - coded in PARAMTRS';
COMMENT ON COLUMN pontis.prj_programs.progstatus IS 'Work Program status - active, inactive, underway, etc coded in PARAMTRS';
COMMENT ON COLUMN pontis.prj_programs.progstartyr IS 'Calendar Start Year of the work program';
COMMENT ON COLUMN pontis.prj_programs.progendyr IS 'Calendar Termination Year of the work program';
COMMENT ON COLUMN pontis.prj_programs.modtime IS 'Time the record was last modified. Reserved for future use.';
COMMENT ON COLUMN pontis.prj_programs.userkey IS 'Primary key to the users table. Key of user that last modified record.';
COMMENT ON COLUMN pontis.prj_programs.docrefkey IS 'Document reference key';
COMMENT ON COLUMN pontis.prj_programs.notes IS 'Entry comments';