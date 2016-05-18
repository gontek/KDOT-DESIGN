CREATE TABLE pontis.kaws_eleminsp_temp_2 (
  inspecfirm VARCHAR2(4000 BYTE),
  serialnumber VARCHAR2(15 BYTE) NOT NULL,
  co_ser VARCHAR2(15 BYTE) NOT NULL,
  inspkey VARCHAR2(4 BYTE) NOT NULL,
  elemkey NUMBER(3) NOT NULL,
  elemunit VARCHAR2(5 BYTE),
  quantity FLOAT NOT NULL,
  qtystate1 FLOAT,
  qtystate2 FLOAT,
  qtystate3 FLOAT,
  qtystate4 FLOAT,
  description VARCHAR2(255 BYTE),
  notes VARCHAR2(2000 BYTE)
);