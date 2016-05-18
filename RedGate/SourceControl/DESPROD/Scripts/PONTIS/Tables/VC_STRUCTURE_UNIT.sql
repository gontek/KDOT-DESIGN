CREATE TABLE pontis.vc_structure_unit (
  brkey VARCHAR2(15 BYTE) NOT NULL,
  strunitkey NUMBER(4) NOT NULL,
  strunittype CHAR,
  strunitlabel VARCHAR2(24 BYTE),
  strunitdescription VARCHAR2(255 BYTE),
  defaultflag CHAR,
  createdatetime DATE,
  createuserkey VARCHAR2(4 BYTE),
  modtime DATE,
  userkey VARCHAR2(4 BYTE),
  docrefkey VARCHAR2(255 BYTE),
  notes VARCHAR2(2000 BYTE)
);