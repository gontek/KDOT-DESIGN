CREATE TABLE pontis.prj_fundsrc (
  fskey VARCHAR2(2 BYTE) NOT NULL,
  fs_name VARCHAR2(30 BYTE),
  fs_type CHAR,
  fs_desc VARCHAR2(255 BYTE),
  createdatetime DATE,
  createuserkey VARCHAR2(4 BYTE),
  modtime DATE,
  userkey VARCHAR2(4 BYTE),
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT prj_fundsrc_pk PRIMARY KEY (fskey)
);
COMMENT ON TABLE pontis.prj_fundsrc IS 'Agency funding sources for work programs and projects';
COMMENT ON COLUMN pontis.prj_fundsrc.fskey IS 'Primary key for funding sources';
COMMENT ON COLUMN pontis.prj_fundsrc.fs_name IS 'Name of the funding source, agency-defined';
COMMENT ON COLUMN pontis.prj_fundsrc.fs_type IS 'Agency-defined funding source type';
COMMENT ON COLUMN pontis.prj_fundsrc.fs_desc IS 'Funding source comments';
COMMENT ON COLUMN pontis.prj_fundsrc.modtime IS 'Time the record was last modified. Reserved for future use.';
COMMENT ON COLUMN pontis.prj_fundsrc.userkey IS 'Primary key to the users table. Key of user that last modified record.';
COMMENT ON COLUMN pontis.prj_fundsrc.notes IS 'Entry comments';