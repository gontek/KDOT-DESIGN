CREATE TABLE pontis.elemdefs (
  elemkey NUMBER(3) NOT NULL,
  ecatkey CHAR NOT NULL,
  etypkey VARCHAR2(2 BYTE) NOT NULL,
  matlkey CHAR NOT NULL,
  paircode NUMBER(2) NOT NULL,
  elemnum NUMBER(3),
  coreflag CHAR,
  smartflag CHAR,
  "PARENT" NUMBER(3),
  useparmdls CHAR NOT NULL,
  elemshort VARCHAR2(20 BYTE),
  elemlong VARCHAR2(50 BYTE),
  statecnt NUMBER(1),
  eachflag CHAR,
  paintflag CHAR,
  scaleshort VARCHAR2(10 BYTE),
  scaleunit VARCHAR2(10 BYTE),
  elemweight NUMBER(4),
  scalemet VARCHAR2(10 BYTE),
  docrefkey VARCHAR2(255 BYTE),
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT elemdefs_pk PRIMARY KEY (elemkey),
  CONSTRAINT fk_elemdefs_30_eltypdfs FOREIGN KEY (ecatkey,etypkey) REFERENCES pontis.eltypdfs (ecatkey,etypkey) ON DELETE CASCADE DISABLE NOVALIDATE,
  CONSTRAINT fk_elemdefs_49_matdefs FOREIGN KEY (matlkey) REFERENCES pontis.matdefs (matlkey) ON DELETE CASCADE DISABLE NOVALIDATE,
  CONSTRAINT fk_elemdefs_50_metric_e FOREIGN KEY (paircode) REFERENCES pontis.metric_english (paircode) DISABLE NOVALIDATE
);
COMMENT ON TABLE pontis.elemdefs IS 'elemdefs';
COMMENT ON COLUMN pontis.elemdefs.elemkey IS 'Element key';
COMMENT ON COLUMN pontis.elemdefs.ecatkey IS 'Element category key number';
COMMENT ON COLUMN pontis.elemdefs.etypkey IS 'Element type key number';
COMMENT ON COLUMN pontis.elemdefs.matlkey IS 'Material key number';
COMMENT ON COLUMN pontis.elemdefs.paircode IS 'Metric English Pair Code';
COMMENT ON COLUMN pontis.elemdefs.elemnum IS 'Logical element number as seen by users';
COMMENT ON COLUMN pontis.elemdefs.coreflag IS 'CoRe element flag';
COMMENT ON COLUMN pontis.elemdefs.smartflag IS 'smart flag flag';
COMMENT ON COLUMN pontis.elemdefs."PARENT" IS 'Element key for which this element is a subelement';
COMMENT ON COLUMN pontis.elemdefs.useparmdls IS 'Sub elements that do not have their own models, but rely on the models of their parents.  Default is set to 0.  If an element uses the model of its parent then it is set to 1.';
COMMENT ON COLUMN pontis.elemdefs.elemshort IS 'Short name';
COMMENT ON COLUMN pontis.elemdefs.elemlong IS 'Long name';
COMMENT ON COLUMN pontis.elemdefs.statecnt IS 'Number of states';
COMMENT ON COLUMN pontis.elemdefs.eachflag IS 'Inspect-as-each flag';
COMMENT ON COLUMN pontis.elemdefs.scaleshort IS 'Short name of scale field';
COMMENT ON COLUMN pontis.elemdefs.scaleunit IS 'Units for scale adjustment factor';
COMMENT ON COLUMN pontis.elemdefs.elemweight IS 'Element weight for use with health index instead of failure cost';
COMMENT ON COLUMN pontis.elemdefs.scalemet IS 'Metric unit of scale field';
COMMENT ON COLUMN pontis.elemdefs.docrefkey IS 'Document reference key';
COMMENT ON COLUMN pontis.elemdefs.notes IS 'Entry comments';