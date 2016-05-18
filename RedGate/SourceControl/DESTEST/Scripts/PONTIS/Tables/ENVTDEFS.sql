CREATE TABLE pontis.envtdefs (
  envkey NUMBER(1) NOT NULL,
  envtnum NUMBER(1),
  envtshort VARCHAR2(10 BYTE),
  envtcolor NUMBER(3),
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT envtdefs_pk PRIMARY KEY (envkey)
);
COMMENT ON COLUMN pontis.envtdefs.envkey IS 'Environment key';
COMMENT ON COLUMN pontis.envtdefs.envtnum IS 'Logical environment number as seen by users';
COMMENT ON COLUMN pontis.envtdefs.envtshort IS 'Short name';
COMMENT ON COLUMN pontis.envtdefs.envtcolor IS 'Color of tabs';
COMMENT ON COLUMN pontis.envtdefs.notes IS 'Entry comments';