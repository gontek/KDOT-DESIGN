CREATE TABLE pontis.multimedia (
  docrefkey VARCHAR2(255 BYTE) NOT NULL,
  "SEQUENCE" NUMBER(10) NOT NULL,
  "CONTEXT" VARCHAR2(255 BYTE) NOT NULL,
  fileloc VARCHAR2(255 BYTE),
  fileref VARCHAR2(255 BYTE),
  filetype VARCHAR2(255 BYTE),
  agencytype VARCHAR2(8 BYTE),
  status VARCHAR2(8 BYTE) DEFAULT 'A',
  reportflag CHAR DEFAULT 'N' NOT NULL,
  userkey1 VARCHAR2(30 BYTE),
  userkey2 VARCHAR2(30 BYTE),
  userkey3 VARCHAR2(30 BYTE),
  userkey4 VARCHAR2(30 BYTE),
  userkey5 VARCHAR2(30 BYTE),
  createdatetime DATE NOT NULL,
  createuserkey VARCHAR2(4 BYTE) NOT NULL,
  modtime DATE,
  userkey VARCHAR2(4 BYTE),
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT multimedia_pk PRIMARY KEY (docrefkey,"SEQUENCE")
);
COMMENT ON COLUMN pontis.multimedia.docrefkey IS 'Document reference key.';
COMMENT ON COLUMN pontis.multimedia."SEQUENCE" IS 'Sequence number for the multimedia document.  Used to distinguish between multiple documents with the same document reference key.';
COMMENT ON COLUMN pontis.multimedia."CONTEXT" IS 'Indicates the table linked to the specified multimedia document.';
COMMENT ON COLUMN pontis.multimedia.fileloc IS 'Location of the specified multimedia document.';
COMMENT ON COLUMN pontis.multimedia.fileref IS 'File name of the specified multimedia document.';
COMMENT ON COLUMN pontis.multimedia.filetype IS 'File type for the specified multimedia document.';
COMMENT ON COLUMN pontis.multimedia.agencytype IS 'Agency-specified document type.';
COMMENT ON COLUMN pontis.multimedia.status IS 'Multimedia document status.';
COMMENT ON COLUMN pontis.multimedia.reportflag IS 'Indicates whether the specified multimedia document should be included in inspection reports.';
COMMENT ON COLUMN pontis.multimedia.userkey1 IS 'Agency-defined field 1.';
COMMENT ON COLUMN pontis.multimedia.userkey2 IS 'Agency-defined field 2.';
COMMENT ON COLUMN pontis.multimedia.userkey3 IS 'Agency-defined field 3.';
COMMENT ON COLUMN pontis.multimedia.userkey4 IS 'Agency-defined field 4.';
COMMENT ON COLUMN pontis.multimedia.userkey5 IS 'Agency-defined field 5.';
COMMENT ON COLUMN pontis.multimedia.createdatetime IS 'Date and time the record was created.';
COMMENT ON COLUMN pontis.multimedia.createuserkey IS 'Key value for the user that created the record.';
COMMENT ON COLUMN pontis.multimedia.modtime IS 'Date and time the record was last modified.';
COMMENT ON COLUMN pontis.multimedia.userkey IS 'Key value for the user that last modified the record.';
COMMENT ON COLUMN pontis.multimedia.notes IS 'Multimedia document notes.';