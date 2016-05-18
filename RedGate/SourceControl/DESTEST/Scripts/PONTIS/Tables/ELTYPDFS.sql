CREATE TABLE pontis.eltypdfs (
  ecatkey CHAR NOT NULL,
  etypkey VARCHAR2(2 BYTE) NOT NULL,
  etypname VARCHAR2(20 BYTE),
  etypcode NUMBER(2),
  etyppos NUMBER(2),
  etypicon VARCHAR2(20 BYTE),
  CONSTRAINT eltypdfs_pk PRIMARY KEY (ecatkey,etypkey),
  CONSTRAINT fk_eltypdfs_21_elcatdfs FOREIGN KEY (ecatkey) REFERENCES pontis.elcatdfs (ecatkey) ON DELETE CASCADE
);
COMMENT ON COLUMN pontis.eltypdfs.ecatkey IS 'Element category key number';
COMMENT ON COLUMN pontis.eltypdfs.etypkey IS 'Element type key number';
COMMENT ON COLUMN pontis.eltypdfs.etypname IS 'Element type name, for row labelling';
COMMENT ON COLUMN pontis.eltypdfs.etypcode IS 'Element type code number, for use in formula files';
COMMENT ON COLUMN pontis.eltypdfs.etyppos IS 'Element type position, for arranging rows on the screen';
COMMENT ON COLUMN pontis.eltypdfs.etypicon IS 'Element type icon adentifier';