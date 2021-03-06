CREATE TABLE ksbms_robot.pbcattbl (
  pbt_tnam CHAR(31 BYTE) NOT NULL,
  pbt_tid NUMBER(10),
  pbt_ownr CHAR(31 BYTE) NOT NULL,
  pbd_fhgt NUMBER(5),
  pbd_fwgt NUMBER(5),
  pbd_fitl CHAR,
  pbd_funl CHAR,
  pbd_fchr NUMBER(5),
  pbd_fptc NUMBER(5),
  pbd_ffce CHAR(18 BYTE),
  pbh_fhgt NUMBER(5),
  pbh_fwgt NUMBER(5),
  pbh_fitl CHAR,
  pbh_funl CHAR,
  pbh_fchr NUMBER(5),
  pbh_fptc NUMBER(5),
  pbh_ffce CHAR(18 BYTE),
  pbl_fhgt NUMBER(5),
  pbl_fwgt NUMBER(5),
  pbl_fitl CHAR,
  pbl_funl CHAR,
  pbl_fchr NUMBER(5),
  pbl_fptc NUMBER(5),
  pbl_ffce CHAR(18 BYTE),
  pbt_cmnt VARCHAR2(254 BYTE)
);