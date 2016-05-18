CREATE TABLE pontis.elcatdfs (
  ecatkey CHAR NOT NULL,
  ecatname VARCHAR2(20 BYTE),
  ecatcode NUMBER(2),
  ecatpos NUMBER(2),
  ecatcolor NUMBER(3),
  CONSTRAINT elcatdfs_pk PRIMARY KEY (ecatkey)
);
COMMENT ON COLUMN pontis.elcatdfs.ecatkey IS 'Element category key number';
COMMENT ON COLUMN pontis.elcatdfs.ecatname IS 'Element category name, for tab labelling';
COMMENT ON COLUMN pontis.elcatdfs.ecatcode IS 'Element category code number, for use in formula files';
COMMENT ON COLUMN pontis.elcatdfs.ecatpos IS 'Element category position, for arranging tabs on the screen';
COMMENT ON COLUMN pontis.elcatdfs.ecatcolor IS 'Color of tabs';