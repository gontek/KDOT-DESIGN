CREATE TABLE pontis.mrractdf (
  elemkey NUMBER(3) NOT NULL,
  skey NUMBER(1) NOT NULL,
  akey NUMBER(1) NOT NULL,
  tkey VARCHAR2(2 BYTE) NOT NULL,
  modelflag CHAR,
  actnum CHAR,
  actshort VARCHAR2(10 BYTE),
  actlong VARCHAR2(80 BYTE),
  paintflag CHAR,
  wholeflag CHAR,
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT mrractdf_pk PRIMARY KEY (elemkey,skey,akey),
  CONSTRAINT fk_mrractdf_1_actypdfs FOREIGN KEY (tkey) REFERENCES pontis.actypdfs (tkey) ON DELETE CASCADE,
  CONSTRAINT fk_mrractdf_84_statedfs FOREIGN KEY (elemkey,skey) REFERENCES pontis.statedfs (elemkey,skey) ON DELETE CASCADE
);
COMMENT ON COLUMN pontis.mrractdf.elemkey IS 'Element key';
COMMENT ON COLUMN pontis.mrractdf.skey IS 'Condition state key';
COMMENT ON COLUMN pontis.mrractdf.akey IS 'Action key';
COMMENT ON COLUMN pontis.mrractdf.tkey IS 'Action type key (of the structure as a whole)';
COMMENT ON COLUMN pontis.mrractdf.modelflag IS 'It is set to 1 if it is used in the model.  Indicates whether an action is feasible for performing MRR optimization.';
COMMENT ON COLUMN pontis.mrractdf.actnum IS 'Action number (as seen by users)';
COMMENT ON COLUMN pontis.mrractdf.actshort IS 'Short name';
COMMENT ON COLUMN pontis.mrractdf.actlong IS 'Long name';
COMMENT ON COLUMN pontis.mrractdf.paintflag IS 'Painting action boolean (TRUE--FALSE)';
COMMENT ON COLUMN pontis.mrractdf.wholeflag IS 'Whole bridge action flag';
COMMENT ON COLUMN pontis.mrractdf.notes IS 'Entry comments';