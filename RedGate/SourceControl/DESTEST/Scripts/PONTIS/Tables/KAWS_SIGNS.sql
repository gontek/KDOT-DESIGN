CREATE TABLE pontis.kaws_signs (
  signid FLOAT NOT NULL,
  serialnumber VARCHAR2(15 BYTE),
  co_ser VARCHAR2(15 BYTE) NOT NULL,
  signcolour VARCHAR2(50 BYTE),
  signheight NUMBER(16,8),
  signlength NUMBER(16,8),
  signoverlay VARCHAR2(50 BYTE),
  signcontents VARCHAR2(2000 BYTE),
  notes VARCHAR2(2000 BYTE),
  CONSTRAINT pk_kaws_signs PRIMARY KEY (signid,co_ser),
  CONSTRAINT fk_kaws_signs_kaws_struc FOREIGN KEY (co_ser) REFERENCES pontis.kaws_structures (co_ser) ON DELETE CASCADE
);