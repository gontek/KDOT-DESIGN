CREATE TABLE pontis.userproj (
  projkey VARCHAR2(30 BYTE) NOT NULL,
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT userproj_pk PRIMARY KEY (projkey)
);