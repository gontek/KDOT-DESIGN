CREATE TABLE pontis.pon_coptions (
  optionname VARCHAR2(40 BYTE) NOT NULL,
  optionval VARCHAR2(2000 BYTE),
  defaultval VARCHAR2(2000 BYTE),
  helpid NUMBER(5),
  description VARCHAR2(255 BYTE),
  CONSTRAINT pon_coptions_pk PRIMARY KEY (optionname)
);