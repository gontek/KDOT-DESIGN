CREATE TABLE pontis.imprsets (
  imkey VARCHAR2(2 BYTE) NOT NULL,
  imname VARCHAR2(28 BYTE) NOT NULL,
  imdate DATE NOT NULL,
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT imprsets_pk PRIMARY KEY (imkey)
);
COMMENT ON COLUMN pontis.imprsets.imkey IS 'Improvement formula values';
COMMENT ON COLUMN pontis.imprsets.notes IS 'Entry comments';