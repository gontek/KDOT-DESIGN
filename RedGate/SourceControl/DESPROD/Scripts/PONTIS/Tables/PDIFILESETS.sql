CREATE TABLE pontis.pdifilesets (
  fileset NUMBER(2) NOT NULL,
  filetype VARCHAR2(70 BYTE),
  dirname VARCHAR2(30 BYTE),
  filename VARCHAR2(30 BYTE),
  CONSTRAINT pdifilesets_pk PRIMARY KEY (fileset)
);
COMMENT ON TABLE pontis.pdifilesets IS 'Contains the list of the different PDI files that can be exported from Pontis.';
COMMENT ON COLUMN pontis.pdifilesets.filetype IS 'PDI file type';
COMMENT ON COLUMN pontis.pdifilesets.dirname IS 'Directory';
COMMENT ON COLUMN pontis.pdifilesets.filename IS 'Name of the file for a given file type';