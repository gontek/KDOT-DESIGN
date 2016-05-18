CREATE TABLE pontis.vc_kaws_eleminsp (
  serialnumber VARCHAR2(15 BYTE) NOT NULL,
  co_ser VARCHAR2(15 BYTE) NOT NULL,
  inspkey VARCHAR2(4 BYTE) NOT NULL,
  inspfirm VARCHAR2(24 BYTE) NOT NULL,
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