CREATE TABLE pontis.actypdfs (
  tkey VARCHAR2(2 BYTE) NOT NULL,
  atypenum NUMBER(2),
  atypeshort VARCHAR2(10 BYTE),
  atypelong VARCHAR2(20 BYTE),
  atypcat CHAR,
  atypeelig CHAR,
  paircode NUMBER(2) NOT NULL,
  pontis_standard_ind CHAR DEFAULT 'F' NOT NULL,
  CONSTRAINT actypdfs_pk PRIMARY KEY (tkey),
  CONSTRAINT fk_actypdfs_100_metric_e FOREIGN KEY (paircode) REFERENCES pontis.metric_english (paircode)
);
COMMENT ON COLUMN pontis.actypdfs.tkey IS 'Action type key (of the structure as a whole)';
COMMENT ON COLUMN pontis.actypdfs.atypenum IS 'Logical action type number (as seen by users)';
COMMENT ON COLUMN pontis.actypdfs.atypeshort IS 'Short name';
COMMENT ON COLUMN pontis.actypdfs.atypelong IS 'Long name';
COMMENT ON COLUMN pontis.actypdfs.atypcat IS 'Action category (nothing, pipeline, MRR, improvement, replacement)';
COMMENT ON COLUMN pontis.actypdfs.atypeelig IS 'Federal eligibility flag';