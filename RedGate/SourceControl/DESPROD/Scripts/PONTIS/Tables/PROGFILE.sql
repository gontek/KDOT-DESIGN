CREATE TABLE pontis.progfile (
  filename VARCHAR2(12 BYTE) NOT NULL,
  filetype VARCHAR2(3 BYTE),
  filedesc VARCHAR2(80 BYTE) NOT NULL,
  filereq CHAR NOT NULL,
  CONSTRAINT progfile_pk PRIMARY KEY (filename)
);
COMMENT ON COLUMN pontis.progfile.filename IS 'Name of the program module file';
COMMENT ON COLUMN pontis.progfile.filetype IS 'Type of file - DLL, PBL, BMP, etc.';
COMMENT ON COLUMN pontis.progfile.filedesc IS 'Description of the file';
COMMENT ON COLUMN pontis.progfile.filereq IS 'File is required to operate Pontis';