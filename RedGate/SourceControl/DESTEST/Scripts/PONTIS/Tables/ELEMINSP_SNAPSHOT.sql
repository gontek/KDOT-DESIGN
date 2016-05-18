CREATE TABLE pontis.eleminsp_snapshot (
  brkey VARCHAR2(15 BYTE) NOT NULL,
  inspkey VARCHAR2(4 BYTE) NOT NULL,
  inspdate DATE NOT NULL,
  elemkey NUMBER(3) NOT NULL,
  envkey NUMBER(1) NOT NULL,
  strunitkey NUMBER(4) NOT NULL,
  quantity FLOAT NOT NULL,
  pctstate1 FLOAT NOT NULL,
  qtystate1 FLOAT,
  pctstate2 FLOAT NOT NULL,
  qtystate2 FLOAT,
  pctstate3 FLOAT NOT NULL,
  qtystate3 FLOAT,
  pctstate4 FLOAT NOT NULL,
  qtystate4 FLOAT,
  pctstate5 FLOAT NOT NULL,
  qtystate5 FLOAT
);