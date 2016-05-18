CREATE TABLE pontis.kaws_elemdefs (
  elemkey NUMBER(3) NOT NULL,
  ecatkey CHAR,
  paircode NUMBER(2) NOT NULL,
  elemnum NUMBER(3),
  elemdesc VARCHAR2(50 BYTE),
  elemweight NUMBER(4),
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT pk_kaws_elemdefs PRIMARY KEY (elemkey)
);