CREATE TABLE pontis.kaws_signs_temp_2 (
  inspecfirm VARCHAR2(4000 BYTE),
  signid FLOAT NOT NULL,
  serialnumber VARCHAR2(15 BYTE),
  co_ser VARCHAR2(15 BYTE) NOT NULL,
  signcolour VARCHAR2(50 BYTE),
  signheight NUMBER(16,8),
  signlength NUMBER(16,8),
  signoverlay VARCHAR2(50 BYTE),
  signcontents VARCHAR2(2000 BYTE),
  notes VARCHAR2(2000 BYTE)
);