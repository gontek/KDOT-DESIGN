CREATE TABLE pontis.randr_2010 (
  strnum VARCHAR2(15 BYTE) NOT NULL,
  invrte VARCHAR2(9 BYTE),
  hwysys VARCHAR2(1 BYTE),
  funcls VARCHAR2(2 BYTE),
  ftrint VARCHAR2(25 BYTE),
  faccar VARCHAR2(18 BYTE),
  locatn VARCHAR2(25 BYTE),
  distrc VARCHAR2(2 BYTE),
  county VARCHAR2(3 BYTE),
  counme VARCHAR2(15 BYTE),
  aadt VARCHAR2(6 BYTE),
  status VARCHAR2(2 BYTE),
  astric VARCHAR2(1 BYTE),
  sufrat VARCHAR2(5 BYTE),
  brkey VARCHAR2(15 BYTE),
  CONSTRAINT pk_randr_2010 PRIMARY KEY (strnum)
);