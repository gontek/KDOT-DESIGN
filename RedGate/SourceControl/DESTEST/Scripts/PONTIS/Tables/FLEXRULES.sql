CREATE TABLE pontis.flexrules (
  fxsetkey VARCHAR2(2 BYTE) NOT NULL,
  fxactkey VARCHAR2(2 BYTE) NOT NULL,
  elemkey NUMBER(3) NOT NULL,
  feastkey VARCHAR2(2 BYTE) NOT NULL,
  seqnumber NUMBER(5),
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT flexrules_pk PRIMARY KEY (fxsetkey,fxactkey,elemkey,feastkey),
  CONSTRAINT fk_flexrule_25_elemdefs FOREIGN KEY (elemkey) REFERENCES pontis.elemdefs (elemkey) ON DELETE CASCADE DISABLE NOVALIDATE,
  CONSTRAINT fk_flexrule_37_flexacti FOREIGN KEY (fxsetkey,fxactkey) REFERENCES pontis.flexactions (fxsetkey,fxactkey) ON DELETE CASCADE
);
COMMENT ON TABLE pontis.flexrules IS 'Flexible action element rules';
COMMENT ON COLUMN pontis.flexrules.fxsetkey IS 'flexible action family key';
COMMENT ON COLUMN pontis.flexrules.fxactkey IS 'Flexible action key';
COMMENT ON COLUMN pontis.flexrules.elemkey IS 'Element key';
COMMENT ON COLUMN pontis.flexrules.feastkey IS 'Comma delimited list of action type code, see actypdfs table';
COMMENT ON COLUMN pontis.flexrules.seqnumber IS 'Sequence Number';
COMMENT ON COLUMN pontis.flexrules.notes IS 'Entry comments';