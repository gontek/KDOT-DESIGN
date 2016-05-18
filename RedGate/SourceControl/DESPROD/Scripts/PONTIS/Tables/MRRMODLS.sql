CREATE TABLE pontis.mrrmodls (
  mokey VARCHAR2(2 BYTE) NOT NULL,
  mocostix NUMBER(6,2),
  moagcyadj NUMBER(6,2),
  mouseradj NUMBER(6,2),
  modetadj NUMBER(6,2),
  modate DATE,
  momodflag CHAR,
  moname VARCHAR2(20 BYTE),
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT mrrmodls_pk PRIMARY KEY (mokey)
);
COMMENT ON COLUMN pontis.mrrmodls.mokey IS 'Model key number';
COMMENT ON COLUMN pontis.mrrmodls.mocostix IS 'Cost index (to compensate for inflation)';
COMMENT ON COLUMN pontis.mrrmodls.moagcyadj IS 'Agency cost adj factor for sensitivity analysis';
COMMENT ON COLUMN pontis.mrrmodls.mouseradj IS 'User cost adjustment factor for sensitivity analysis';
COMMENT ON COLUMN pontis.mrrmodls.modetadj IS 'Deterioration adj factor for sensitivity analysis';
COMMENT ON COLUMN pontis.mrrmodls.modate IS 'Model date (when the models were frozen)';
COMMENT ON COLUMN pontis.mrrmodls.momodflag IS 'Modified-by-user flag';
COMMENT ON COLUMN pontis.mrrmodls.moname IS 'User s name of the model';
COMMENT ON COLUMN pontis.mrrmodls.notes IS 'Entry comments';